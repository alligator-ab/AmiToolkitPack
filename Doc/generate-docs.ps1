param(
    [string]$MarkdownFile = (Join-Path (Split-Path $PSScriptRoot) 'Documentation.md'),
    [string]$OutputDir = $PSScriptRoot
)

# Requires PowerShell 7+ (pwsh.exe).
# Does NOT work with Windows PowerShell 5.1 — [regex]::Replace with script block
# is only supported in .NET 5+ / PowerShell 7+.
# Install pwsh from https://github.com/PowerShell/PowerShell/releases
$ErrorActionPreference = 'Stop'

function Convert-MarkdownToHtml {
    param([string[]]$Lines)

    $insideCode = $false
    $insideTable = $false
    $tableHtml = @()
    $html = @()

    $i = 0
    while ($i -lt $Lines.Length) {
        $line = $Lines[$i]

        # Code block
        if ($line -match '^```') {
            if ($insideCode) {
                $html += '</code></pre>'
                $insideCode = $false
            } else {
                $html += '<pre><code>'
                $insideCode = $true
            }
            $i++
            continue
        }
        if ($insideCode) {
            $escaped = [System.Security.SecurityElement]::Escape($line)
            $html += "$escaped`n"
            $i++
            continue
        }

        # Table
        if ($line -match '^\|.*\|$') {
            if (-not $insideTable) {
                $insideTable = $true
                $tableHtml = @()
            }
            $tableHtml += $line
            $i++
            continue
        } else {
            if ($insideTable) {
                $html += Convert-TableToHtml $tableHtml
                $insideTable = $false
                $tableHtml = @()
            }
        }

        # Headers
        if ($line -match '^### (.+)') {
            $html += "<h3>$($matches[1])</h3>"
        } elseif ($line -match '^## (.+)') {
            $html += "<h2>$($matches[1])</h2>"
        } elseif ($line -match '^# (.+)') {
            $html += "<h1>$($matches[1])</h1>"

        # Horizontal rule
        } elseif ($line -match '^---') {
            $html += '<hr>'

        # Unordered list
        } elseif ($line -match '^- (.+)') {
            $html += "<li>$($matches[1])</li>"

        # Bold **text**
        } elseif ($line -match '^\*\*(.+)\*\*$') {
            $html += "<p><strong>$($matches[1])</strong></p>"

        # Empty line
        } elseif ($line -match '^\s*$') {
            # skip
        } elseif ($line -match '^\|') {
            # table row (continued)
        } else {
            $escaped = [System.Security.SecurityElement]::Escape($line)
            # inline formatting
            $escaped = $escaped -replace '\*\*(.+?)\*\*', '<strong>$1</strong>'
            $escaped = $escaped -replace '`(.+?)`', '<code>$1</code>'
            $escaped = $escaped -replace '\*(.+?)\*', '<em>$1</em>'
            # Handle syntax lines like `**Syntax:**`
            $html += "<p>$escaped</p>"
        }

        $i++
    }

    if ($insideTable) {
        $html += Convert-TableToHtml $tableHtml
    }

    return $html -join "`n"
}

function Convert-TableToHtml {
    param([string[]]$Rows)
    if ($Rows.Count -lt 2) { return '' }

    $alignRow = $Rows[1]
    $alignments = @()
    if ($alignRow -match '^\|[-:|\s]+\|$') {
        $parts = $alignRow -split '\|' | Where-Object { $_ -ne '' -and $_ -ne $null }
        foreach ($p in $parts) {
            $p = $p.Trim()
            if ($p -match '^:-+:$') { $alignments += 'center' }
            elseif ($p -match '^:-+$') { $alignments += 'left' }
            elseif ($p -match '^-+:$') { $alignments += 'right' }
            else { $alignments += 'left' }
        }
    }

    $html = @('<table class="doc-table">')

    for ($r = 0; $r -lt $Rows.Count; $r++) {
        # skip alignment row
        if ($r -eq 1 -and $Rows[$r] -match '^\|[-:|\s]+\|$') { continue }

        $cells = $Rows[$r] -split '\|' | Where-Object { $_ -ne $null }
        $cells = $cells[1..($cells.Length - 2)]  # remove leading/trailing empty
        $tag = if ($r -eq 0) { 'th' } else { 'td' }

        $html += '<tr>'
        for ($c = 0; $c -lt $cells.Count; $c++) {
            $val = $cells[$c].Trim()
            $val = $val -replace '`(.+?)`', '<code>$1</code>'
            $align = if ($c -lt $alignments.Count) { " align=`"$($alignments[$c])`"" } else { '' }
            $html += "<$tag$align>$val</$tag>"
        }
        $html += '</tr>'
    }

    $html += '</table>'
    return $html -join "`n"
}

function Get-FunctionAnchor {
    param([string]$Name)
    $anchor = $Name.ToLower()
    $anchor = $anchor -replace '[^a-z0-9_]', ''
    if ($anchor -match '^[0-9]') { $anchor = "f$anchor" }
    return $anchor
}

# Parse the markdown into sections
$md = Get-Content -LiteralPath $MarkdownFile -Raw
$lines = $md -split '\r?\n'

# Find section headings and their ranges
$categories = @()
$currentCat = $null
$functions = @()  # all functions with their category

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]

    # Category heading (## ...)
    if ($line -match '^## (.+)') {
        $catName = $matches[1].Trim()
        # Skip Overview — it's already on the main page
        if ($catName -eq 'Overview') { continue }

        if ($currentCat) {
            $currentCat.endLine = $i - 1
            $categories += $currentCat
        }
        $currentCat = @{
            name = $catName
            startLine = $i
            endLine = $lines.Length - 1
            functions = @()
            file = ''
        }
        continue
    }

    # Function heading (### sfFunctionName or ### FunctionName)
    if ($line -match '^### (sf(?:\w+|UpBeta|DownBeta|UpAlpha|DownAlpha|WSSendCBOR|CSVExtractCols|CSVLoadAndAppend|CSVAppendToFile|CSVSetDelimiter|CSVGetDelimiter|StrExtractCols|WSSendCBOR)|SelectFile|SaveFile|Dialog\w+|Detect\w+|GetFileSize|CreateTempFile|KellyCriterion|BarsSince\w+|DemandIndex|LakeRatio|DeMarker|TDSetup|TDCountdown|RemoveExcessSignals|RestrictSignals|RestrictPosition|PositionFromSignals|EquityCurve|FutureMarginEstimate|RequiredMargin|LimitPositionSize|DrawdownCurve|MaxDrawdown|Percentize|SwitchEquityCurves|JurikMA)') {
        $funcName = $matches[1]
        if ($currentCat) {
            $currentCat.functions += @{
                name = $funcName
                line = $i
            }
            $functions += @{
                name = $funcName
                category = $currentCat.name
            }
        }
    }

    # Handle "sfXxx / sfYyy" combined headings
    if ($line -match '^### (sf\w+) / (sf\w+)') {
        $f1 = $matches[1]
        $f2 = $matches[2]
        if ($currentCat) {
            $currentCat.functions += @{ name = $f1; line = $i }
            $currentCat.functions += @{ name = $f2; line = $i }
            $functions += @{ name = $f1; category = $currentCat.name }
            $functions += @{ name = $f2; category = $currentCat.name }
        }
    }
}

if ($currentCat) {
    $categories += $currentCat
}

# Determine output file names
foreach ($cat in $categories) {
    $base = $cat.name -replace '[^a-zA-Z0-9 ]', ''
    $base = $base -replace '\s+', ''
    $cat.file = "$base.html"
}

# Build glossary
$glossaryHtml = @()
$glossaryHtml += '<div class="glossary">'
$glossaryHtml += '<h2>Glossary — All Functions</h2>'
$glossaryHtml += '<table class="doc-table"><tr><th>Function</th><th>Category</th></tr>'

$sortedFunctions = $functions | Sort-Object name
foreach ($f in $sortedFunctions) {
    $cat = $categories | Where-Object { $_.name -eq $f.category } | Select-Object -First 1
    $file = if ($cat) { $cat.file } else { 'indicators.html' }
    $anchor = Get-FunctionAnchor $f.name
    $glossaryHtml += "<tr><td><a href=`"$file`#$anchor`">$($f.name)</a></td><td>$($f.category)</td></tr>"
}
$glossaryHtml += '</table></div>'

# Write each category page
foreach ($cat in $categories) {
    $filePath = Join-Path $OutputDir $cat.file
    Write-Host "Writing $filePath..."

    $bodyLines = @()
    $bodyLines += "<h1>$($cat.name)</h1>"
    $bodyLines += '<nav class="section-nav"><a href="AmiToolkit Reference Guide.html">← Back to AmiToolkit Reference</a></nav>'
    $bodyLines += '<hr>'

    # Extract content lines for this category
    $start = $cat.startLine
    $end = $cat.endLine
    $contentLines = $lines[$start..$end]

    $bodyHtml = Convert-MarkdownToHtml $contentLines

    # Fix function anchors — apply to all headings that start with a known function prefix
    $bodyHtml = [regex]::Replace($bodyHtml, '<h3>(sf\w+)</h3>', {
        param($m) '<h3 id="' + $m.Groups[1].Value.ToLower() + '">' + $m.Groups[1].Value + '</h3>'
    })
    # Handle combined headings like "sfUpBeta / sfDownBeta"
    $bodyHtml = [regex]::Replace($bodyHtml, '<h3>(sf\w+) / (sf\w+)</h3>', {
        param($m) '<h3 id="' + $m.Groups[1].Value.ToLower() + '">' + $m.Groups[1].Value + ' / ' + $m.Groups[2].Value + ' <span id="' + $m.Groups[2].Value.ToLower() + '"></span></h3>'
    })
    # Dialog/Detect functions (no "sf" prefix)
    $bodyHtml = [regex]::Replace($bodyHtml, '<h3>(SelectFile|SaveFile|Dialog\w+|Detect\w+|GetFileSize|CreateTempFile|KellyCriterion|BarsSince\w+|DemandIndex|LakeRatio|DeMarker|TDSetup|TDCountdown|JurikMA)</h3>', {
        param($m) '<h3 id="' + $m.Groups[1].Value.ToLower() + '">' + $m.Groups[1].Value + '</h3>'
    })

    $bodyLines += $bodyHtml

    $body = $bodyLines -join "`n"

    $fullHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AmiToolkit — $($cat.name)</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;line-height:1.6;color:#1a1a1a;background:#fafafa;padding:2rem;max-width:1000px;margin:0 auto}
h1{color:#2c3e50;border-bottom:3px solid #3498db;padding-bottom:.5rem;margin-bottom:1.5rem}
h2{color:#2c3e50;margin-top:2rem;margin-bottom:.75rem}
h3{color:#2980b9;margin-top:1.5rem;margin-bottom:.5rem}
h3:target{background:#fff3cd;padding:.25rem .5rem;border-radius:4px}
p{margin:.5rem 0}
pre{background:#1e1e2e;color:#cdd6f4;padding:1rem;border-radius:6px;overflow-x:auto;font-size:.9rem;margin:.75rem 0}
code{font-family:'JetBrains Mono','Fira Code','Cascadia Code',Consolas,monospace;font-size:.9em}
pre code{background:0 0;padding:0}
p code{background:#e8e8e8;padding:.1em .4em;border-radius:3px}
.doc-table{border-collapse:collapse;margin:.75rem 0;width:100%;font-size:.9rem}
.doc-table th,.doc-table td{border:1px solid #d0d0d0;padding:.4rem .6rem;text-align:left}
.doc-table th{background:#3498db;color:#fff;font-weight:600}
.doc-table tr:nth-child(even){background:#f0f4f8}
hr{border:0;border-top:1px solid #d0d0d0;margin:1.5rem 0}
li{margin:.25rem 0 .25rem 1.5rem}
a{color:#2980b9;text-decoration:none}
a:hover{text-decoration:underline}
.section-nav{margin-bottom:1rem}
.section-nav a{font-size:.9rem;color:#7f8c8d}
.section-nav a:hover{color:#2980b9}
</style>
</head>
<body>
$body
</body>
</html>
"@

    Set-Content -LiteralPath $filePath -Value $fullHtml -Encoding UTF8
}

# Write main AmiToolkit Reference Guide
Write-Host "Writing AmiToolkit Reference Guide.html..."
$catLinks = @()
foreach ($cat in $categories) {
    $catLinks += "<li><a href=`"$($cat.file)`">$($cat.name)</a> ($($cat.functions.Count) functions)</li>"
}

$guideBody = @"
<h1>AmiToolkit AmiBroker Plugin — User Guide</h1>

<h2>Overview</h2>
<p>AmiToolkit is an AmiBroker plug-in that provides string processing,
JSON/CBOR manipulation, Vector and Record data structures, technical indicators,
quantitative functions and many other useful functions for AFL formulas.</p>

<hr>

<h2>Function Categories</h2>
<ul>
$($catLinks -join "`n")
</ul>

<hr>

$($glossaryHtml -join "`n")
"@

$fullHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AmiToolkit — User Guide</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;line-height:1.6;color:#1a1a1a;background:#fafafa;padding:2rem;max-width:1000px;margin:0 auto}
h1{color:#2c3e50;border-bottom:3px solid #3498db;padding-bottom:.5rem;margin-bottom:1.5rem}
h2{color:#2c3e50;margin-top:2rem;margin-bottom:.75rem}
h3{color:#2980b9;margin-top:1.5rem;margin-bottom:.5rem}
p{margin:.5rem 0}
pre{background:#1e1e2e;color:#cdd6f4;padding:1rem;border-radius:6px;overflow-x:auto;font-size:.9rem;margin:.75rem 0}
code{font-family:'JetBrains Mono','Fira Code','Cascadia Code',Consolas,monospace;font-size:.9em}
pre code{background:0 0;padding:0}
p code{background:#e8e8e8;padding:.1em .4em;border-radius:3px}
.doc-table{border-collapse:collapse;margin:.75rem 0;width:100%;font-size:.9rem}
.doc-table th,.doc-table td{border:1px solid #d0d0d0;padding:.4rem .6rem;text-align:left}
.doc-table th{background:#3498db;color:#fff;font-weight:600}
.doc-table tr:nth-child(even){background:#f0f4f8}
hr{border:0;border-top:1px solid #d0d0d0;margin:1.5rem 0}
li{margin:.25rem 0 .25rem 1.5rem}
a{color:#2980b9;text-decoration:none}
a:hover{text-decoration:underline}
.glossary{margin-top:2rem}
.glossary h2{border-bottom:2px solid #3498db;padding-bottom:.25rem}
.glossary .doc-table{font-size:.85rem}
.glossary .doc-table td:first-child{font-family:'JetBrains Mono','Fira Code',Consolas,monospace;font-size:.85rem}
</style>
</head>
<body>
$guideBody
</body>
</html>
"@

Set-Content -LiteralPath (Join-Path $OutputDir 'AmiToolkit Reference Guide.html') -Value $fullHtml -Encoding UTF8

Write-Host "Done — generated $($categories.Count) category pages + AmiToolkit Reference Guide.html"
