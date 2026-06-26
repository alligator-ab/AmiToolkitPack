# AmiToolkit AmiBroker Plugin — Function Reference

## Overview

AmiToolkit is an AmiBroker plug-in that provides string processing,
 JSON/CBOR manipulation, Vector and Record data structures, technical indicators,
  quantitative functions and many other useful functions for AFL formulas.

---

## String Functions

### sfStrFind

Finds the first occurrence of a substring within a string,
 starting from an optional position.

**Syntax:** `sfStrFind( str, substr, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to search in |
| substr | string | The substring to find |
| start | float | (optional) Starting position (0-based). Negative values count from the end of the string. Default: 0 |

**Returns:** float — The 0-based position of the first occurrence,
 or -1 if not found.

**Note:** Positions are 0-based character indices,
 unlike the built-in `StrFind()` which is 1-based byte offsets.

---

### sfStrFindLast

Finds the last occurrence of a substring, searching backwards from an optional position.

**Syntax:** `sfStrFindLast( str, substr, start = -1 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to search in |
| substr | string | The substring to find |
| start | float | (optional) Starting position (0-based). Negative values count from the end. Default: -1 (start from last character) |

**Returns:** float — The 0-based position of the last occurrence, or -1 if not found.

---

### sfStrExtractFrom

Extracts a delimited field from a string, starting from a given position.
Separators inside nested brackets `()`, `[]`, `{}` are **not** preserved
— use `sfStrNextField` if you need nested expression support.

**Syntax:** `sfStrExtractFrom( str, start, field, separator = ',' )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| start | float | Position to begin searching (0-based). Negative values count from the end |
| field | float | The field index to extract (0-based) |
| separator | float | (optional) ASCII code of the separator character. Default: 44 (comma) |

**Returns:** string — The extracted field, or an empty string if not found.

**Note:** This is a simple scan — see `sfStrNextField` for bracket-aware extraction.

---

### sfStrTrimExtractFrom

Same as `sfStrExtractFrom` but trims leading and trailing whitespace
 from the extracted field. Does **not** handle nested brackets
 — use `sfStrNextField` if you need nested expression support.

**Syntax:** `sfStrTrimExtractFrom( str, start, field, separator = ',' )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| start | float | Position to begin searching |
| field | float | The field index to extract (0-based) |
| separator | float | (optional) ASCII code of the separator character. Default: 44 (comma) |

**Returns:** string — The trimmed field, or an empty string if not found.

---

### sfStrFindNested

Finds the position of the closing parenthesis matching the opening parenthesis
 at the given position.

**Syntax:** `sfStrFindNested( str, close, start )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| close | float | ASCII code of the closing parenthesis to match: `)` `]` or `}` |
| start | float | Position of the opening parenthesis (0-based). Negative values count from the end |

**Returns:** float — The 0-based position of the matching closing parenthesis, or -1 if not found.

---

### sfStrNextField

Returns the next delimited field from a string, starting from a given position
and optionally limited by an end position. Unlike `sfStrExtractFrom`, this
function understands and preserves nested bracketed expressions (parentheses,
square and curly brackets), so separators inside such nested expressions are
ignored.

**Syntax:** `sfStrNextField( str, separator, start = 0, to = -1 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| separator | float | ASCII code of the separator character (e.g. 44 for comma) |
| from | float | (optional) Starting position (0-based). Negative values count from the end. Default: 0 |
| to | float | (optional) End position (0-based) that limits the search. Negative values count from the end. Default: -1 → end of string |

**Returns:** string — The extracted field trimmed of leading and trailing whitespace. If no field is found the function returns an empty string.

**Notes:**

- Positions are 0-based character indices.
- Nested brackets `()`, `[]`, and `{}` are respected: separators inside these
  constructs are not treated as delimiters for the returned field.
- For simple field extraction without nesting support, see `sfStrExtractFrom`.


### sfStrFromChar

Returns a string consisting of a single character with the given ASCII code.

**Syntax:** `sfStrFromChar( code )`

| Arg | Type | Description |
|-----|------|-------------|
| code | float | ASCII code of the character |

**Returns:** string — A single-character string.

---

### sfStrToChar

Returns the ASCII code of the character at a given position in a string.

**Syntax:** `sfStrToChar( str, pos )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| pos | float | Position of the character (0-based). Negative values count from the end |

**Returns:** float — The ASCII code, or 0 if the position is out of range.

---

### sfStrQuote

Wraps a string in double quotes, escaping any embedded double quotes or backslashes.

**Syntax:** `sfStrQuote( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to quote |

**Returns:** string — The quoted string.

---

### sfStrUnquote

Removes surrounding double quotes from a string
and un-escapes embedded quotes and backslashes.

**Syntax:** `sfStrUnquote( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to unquote |

**Returns:** string — The unquoted string.

---

### sfStrDisclose

Removes leading/trailing whitespace and enclosing brackets from a string.
 Supports `{}`, `[]`, `()`, `""`, and `''` pairs.

**Syntax:** `sfStrDisclose( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to process |

**Returns:** string — The trimmed and de-bracketed string.

---

### sfStrEnclose

Wraps a string with the specified opening and closing characters.

**Syntax:** `sfStrEnclose( open_close, str )`

| Arg | Type | Description |
|-----|------|-------------|
| open_close | string | The first character is the opening delimiter; the second character (if present) is the closing delimiter. If only one character is given, it is used for both |
| str | string | The string to enclose |

**Returns:** string — The enclosed string.

---

### sfStrToQuote

Converts a string to a floating-point number.  When the string contains a
bond‑quote separator (`^`, `'`, `/`, `-`), the fractional part is parsed as
32nds (with an optional trailing digit for 256ths, or `+` for a half‑32nd =
4/256).  If no separator is provided, the function auto‑detects it from the
string.

**Syntax:** `sfStrToQuote( str [, sep ] )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to convert (e.g. `"101'04"`, `"99^16+"`) |
| sep | float / string | (optional) Separator character; default is auto‑detected |

**Returns:** float — The numeric value.  Examples: `"101'04"` → 101.125,
`"99^16+"` → 99.515625, `"100^02"` → 100.0625.

---

### sfStrFromQuote

Converts a floating-point number to its string representation,
 preserving decimal precision appropriate for financial quotations
  (handles tick sizes that are powers of 2, e.g. 0.5, 0.25, 0.125…).

**Syntax:** `sfStrFromQuote( val )`

| Arg | Type | Description |
|-----|------|-------------|
| val | float | The numeric value to convert |

**Returns:** string — The formatted quotation string.

---

### sfStrInsert

Inserts a substring into a string at the specified position.

**Syntax:** `sfStrInsert( str, substr, pos )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The original string |
| substr | string | The substring to insert |
| pos | float | Insertion position (0‑based). Negative positions count from the end; `-1` appends. |

**Returns:** string — The resulting string after insertion.

---

### sfStrColumnSizes

Analyzes a delimited table string and returns the maximum width of each column, with an optional margin.

**Syntax:** `sfStrColumnSizes( table, separators, margin = 2 )`

| Arg | Type | Description |
|-----|------|-------------|
| table | string | The input table string |
| separators | string | First character = column separator, second character = row separator (default: `,\n`) |
| margin | float | (optional) Extra padding to add to each column width. Default: 2 |

**Returns:** string — A comma-separated list of column widths,
or an empty string if the table has more than 255 columns.

---

### sfStrFormatHeaders

Formats a header/title line with each header centered in its column,
 using a format string of column widths and a headers string.

**Syntax:** `sfStrFormatHeaders( format, headers, separator = 44 )`

| Arg | Type | Description |
|-----|------|-------------|
| format | string | Comma-separated column widths (e.g. `"10,15,20"`). Must be comma-separated regardless of `separator` |
| headers | string | Header texts separated by the `separator` character |
| separator | float | (optional) ASCII code of the separator character used in `headers`. Default: 44 (comma) |

**Returns:** string — The formatted header line with each header centered
 in its column, padded with spaces, fields separated by `separator`.

**Note:** If a header text is longer than its column width, it is
 truncated on the right to fit.

---

### sfStrFormatTable

Formats a delimited table string according to a format string specifying column widths.

**Syntax:** `sfStrFormatTable( format, table, separators )`

| Arg | Type | Description |
|-----|------|-------------|
| format | string | Comma-separated column widths (e.g. `"10,5,8"`) |
| table | string | The input table string |
| separators | string | First char = column separator, second char = row separator (default: `,\n`) |

**Returns:** string — The formatted table. Numeric fields are right-aligned,
text fields are left-aligned.

---

### sfStrFormatAlignedTable

Formats a delimited table string like `sfStrFormatTable`, but supports
decimal-aligned columns. When a column format uses `x.y` notation
(e.g. `7.2`), numbers in that column are aligned on their decimal point:

- `x` = width reserved for the integer part (including sign)
- `y` = width reserved for the fractional part
- Total column width = `x` + 1 (decimal point) + `y`

A plain format like `10` behaves identically to `sfStrFormatTable`
(right-aligned for numbers, left-aligned for text).

**Syntax:** `sfStrFormatAlignedTable( format, table, separators )`

| Arg | Type | Description |
|-----|------|-------------|
| format | string | Comma-separated column formats, e.g. `"10,7.2,8"`. Mixing plain and decimal-aligned columns is allowed |
| table | string | The input table string |
| separators | string | First char = column separator, second char = row separator (default: `,\n`) |

**Returns:** string — The formatted table with decimal-aligned columns.

**Examples:**

Format `"8,7.2,6"` with data `Name,Price,Change`:

- Column 0: plain width 8
- Column 1: decimal-aligned, integer part 7 + point + fraction 2 = 10 total
- Column 2: plain width 6

In a decimal column, a value like `-123.456` is displayed as "   -123.46" 
(right-aligned integer, decimal point, 2 fractional digits).

---

### sfStrTrimIn

Removes all whitespace characters from a string, except whitespace inside
 single-quoted or double-quoted substrings.

**Syntax:** `sfStrTrimIn( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to process |

**Returns:** string — The string with whitespace removed outside quotes.

---

### sfStrFrom

Returns a substring of the given string starting from the specified position.

**Syntax:** `sfStrFrom( str, from )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| from | float | Starting position (0-based). If negative, counts from the end of the string (e.g. -1 = last character) |

**Returns:** string — A pointer into the original string starting at position `from`. This function does not allocate a new buffer; the returned string points into the original plugin-managed string. Do NOT store the result in a static AFL variable. If you need to modify or persist the substring, copy it first (for example with `StrMid()` or similar).

---

### sfRoundQuotes

Rounds the numeric values in an AFL array in-place to the nearest multiple of the specified tick size.

**Syntax:** `sfRoundQuotes( array, tickSize )`

| Arg | Type | Description |
|-----|------|-------------|
| array | array | The numeric array to be modified in-place (passed by reference) |
| tickSize | float | The tick size to round to. Supports fractional tick sizes (e.g. 0.5, 0.25, 0.125). For sub-1 tick sizes the function computes the appropriate reciprocal internally |

**Returns:** None — The function returns nothing and updates the provided array in-place. Empty values (`EMPTY_VAL`) are preserved.

---

### sfRoundQuote

Rounds a single numeric value to the nearest multiple of the specified tick size and returns the result.

**Syntax:** `sfRoundQuote( value, tickSize )`

| Arg | Type | Description |
|-----|------|-------------|
| value | float | The numeric value to round |
| tickSize | float | The tick size to round to. See `sfRoundQuotes` for supported tick sizes |

**Returns:** float — The rounded value. Returns the original value unchanged if `tickSize <= 0`. Returns `Null` if fewer than 2 arguments are provided.

---

### sfStrFindRegEx

Finds the position of the first substring matching a regular expression,
 starting from an optional position.

**Syntax:** `sfStrFindRegEx( str, regex, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to search in |
| regex | string | The regular expression pattern (ECMAScript syntax) |
| start | float | (optional) Starting position (0-based). Negative values count from the end of the string. Default: 0 |

**Returns:** float — The 0-based position of the first match,
 or -1 if the pattern is not found or if the regex is invalid.

**Note:** The regex engine uses ECMAScript syntax (C++ `std::regex`).
 If the regex is malformed, the function returns -1 without error.

---

### sfStrExtractRegEx

Extracts the first substring matching a regular expression,
 starting from an optional position.

**Syntax:** `sfStrExtractRegEx( str, regex, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to search in |
| regex | string | The regular expression pattern (ECMAScript syntax) |
| start | float | (optional) Starting position (0-based). Negative values count from the end of the string. Default: 0 |

**Returns:** string — The matched substring,
 or an empty string if not found or if the regex is invalid.

---

### sfStrReplaceRegEx

Replaces the **first** substring matching a regular expression
 with a replacement string, starting from an optional position.

**Syntax:** `sfStrReplaceRegEx( str, regex, subst, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| regex | string | The regular expression pattern (ECMAScript syntax) |
| subst | string | The replacement string |
| start | float | (optional) Starting position (0-based). Only occurrences at or after this position are replaced. Negative values count from the end. Default: 0 |

**Returns:** string — The input string with the first match replaced,
 or the original string if the pattern is not found or invalid.

---

### sfStrReplaceAllRegEx

Replaces **all** substrings matching a regular expression
 with a replacement string, starting from an optional position.

**Syntax:** `sfStrReplaceAllRegEx( str, regex, subst, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The input string |
| regex | string | The regular expression pattern (ECMAScript syntax) |
| subst | string | The replacement string |
| start | float | (optional) Starting position (0-based). Only occurrences at or after this position are replaced. Negative values count from the end. Default: 0 |

**Returns:** string — The input string with all matches replaced,
 or the original string if the pattern is not found or invalid.

---

## String Builder Functions

The string builder provides an efficient way to concatenate many
string fragments. Create a builder, append/prepend fragments,
then build the final string.

### sfStrBuilder

Creates a new string builder and returns its unique ID.

**Syntax:** `sfStrBuilder()`

**Returns:** float — The builder ID, to be used with other builder functions.

---

### sfStrBuilderAppend

Appends a string to the builder.

**Syntax:** `sfStrBuilderAppend( str, id )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to append |
| id | float | Builder ID returned by `sfStrBuilder` |

**Returns:** None

---

### sfStrBuilderAppend2

Appends two strings to the builder in sequence.

**Syntax:** `sfStrBuilderAppend2( str1, str2, id )`

| Arg | Type | Description |
|-----|------|-------------|
| str1 | string | First string to append |
| str2 | string | Second string to append |
| id | float | Builder ID |

**Returns:** None

---

### sfStrBuild

Builds the final concatenated string and optionally destroys the builder.

**Syntax:** `sfStrBuild( id, delete_builder = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Builder ID |
| delete_builder | float | (optional) If non-zero, the builder is destroyed after building. Default: 0 |

**Returns:** string — The concatenated result.

---

### sfStrBuilderClear

Removes all strings from the builder, resetting it to empty.

**Syntax:** `sfStrBuilderClear( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Builder ID |

**Returns:** None

---

### sfStrBuilderPrepend

Prepends a string to the beginning of the builder.

**Syntax:** `sfStrBuilderPrepend( str, id )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to prepend |
| id | float | Builder ID |

**Returns:** None

---

### sfStrBuilderRemove

Removes the last *n* strings from the builder.

**Syntax:** `sfStrBuilderRemove( num, id )`

| Arg | Type | Description |
|-----|------|-------------|
| num | float | Number of strings to remove from the end |
| id | float | Builder ID |

**Returns:** None

---

### sfStrBuilderDestroy

Destroys the builder and frees all associated memory.

**Syntax:** `sfStrBuilderDestroy( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Builder ID |

**Returns:** None

---

## Pipe Functions

Functions for creating and communicating with a child process via an anonymous pipe.

### sfPipeCreate

Launches a child process and creates a pipe pair for communicating with it.

**Syntax:** `sfPipeCreate( command )`

| Arg | Type | Description |
|-----|------|-------------|
| command | string | Command line to execute (child process) |

**Returns:** float — A pipe ID to use with other `sfPipe*` functions, or `Null()` on failure.

---

### sfPipeSend

Writes data to the child process standard input.

**Syntax:** `sfPipeSend( data, pipeId )`

| Arg | Type | Description |
|-----|------|-------------|
| data | string | Data to write to child's stdin |
| pipeId | float | Pipe ID returned by `sfPipeCreate` |

**Returns:** None

**Note:** `WriteFile` is used without overlapped I/O. The call may block if the pipe buffer is full or if the child does not read.

---

### sfPipeRequest

Send data to the child and wait (up to an optional timeout) for output.

**Syntax:** `sfPipeRequest( data, pipeId, timeout_ms = 500 )`

| Arg | Type | Description |
|-----|------|-------------|
| data | string | Data to write to child's stdin |
| pipeId | float | Pipe ID |
| timeout_ms | float | (optional) Maximum wait time in milliseconds. Default: 500 |

**Returns:** string — The collected output as a string, or `Null()` if allocation failed or no output was produced within the timeout.

**Behavior:** The function writes `data` then polls the pipe (using `PeekNamedPipe`/`ReadFile`) until data is available or the timeout expires. It may block for short periods while waiting but will return when the timeout is reached.

---

### sfPipeRead

Non-blocking read that returns any output currently available from the child process.

**Syntax:** `sfPipeRead( pipeId )`

| Arg | Type | Description |
|-----|------|-------------|
| pipeId | float | Pipe ID |

**Returns:** string — A string containing currently-available output, or `Null()` if no data is available.

**Note:** Use this to poll for additional output after a previous `sfPipeRequest` returned early, or to periodically collect output without blocking.

---

### sfPipeIsClosed

Check whether the child process has exited.

**Syntax:** `sfPipeIsClosed( pipeId )`

| Arg | Type | Description |
|-----|------|-------------|
| pipeId | float | Pipe ID |

**Returns:** float — `1` if the process has exited (or the pipe does not exist), `0` otherwise.

---

### sfPipeClose

Closes pipe handles and terminates the child process.

**Syntax:** `sfPipeClose( pipeId )`

| Arg | Type | Description |
|-----|------|-------------|
| pipeId | float | Pipe ID |

**Returns:** None

**Warning:** `sfPipeClose` calls `TerminateProcess` to force the child to exit and closes the handles. Prefer a graceful shutdown by signalling the child if possible before calling this.

---

## Vector Functions

The vector functions let you create and manipulate dynamic arrays of mixed-type
values (`AmiVar`), identified by a unique numeric ID.

### sfVectorCreate

Creates a new struct with the specified number of elements.

**Syntax:** `sfVectorCreate( size )`

| Arg | Type | Description |
|-----|------|-------------|
| size | float | Number of elements in the struct |

**Returns:** float — The struct ID.

---

### sfVectorDestroy

Destroys a struct and frees its memory.

**Syntax:** `sfVectorDestroy( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Vector ID |

**Returns:** None

---

### sfVectorToString

Returns a JSON-like string representation of the struct's contents.

**Syntax:** `sfVectorToString( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Vector ID |

**Returns:** string — e.g. `[1.5,"hello",null]`

---

### sfVectorFromString

Parses a JSON-like string and creates a new struct from it if no struct's id is provided.

**Syntax:** `sfVectorFromString( str, id = -1 )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The JSON-like string to parse |

**Returns:** float — The new struct ID, or nothing if parsing fails.

---

### sfVectorGet

Retrieves the value at a given index.

**Syntax:** `sfVectorGet( index, id )`

| Arg | Type | Description |
|-----|------|-------------|
| index | float | Zero-based element index |
| id | float | Vector ID |

**Returns:** AmiVar — The value (string, float, or none).

---

### sfVectorSetFloat

Sets a float value at a given index.

**Syntax:** `sfVectorSetFloat( value, index, id )`

| Arg | Type | Description |
|-----|------|-------------|
| value | float | The float value to set |
| index | float | Zero-based element index |
| id | float | Vector ID |

**Returns:** float — The previous value at that index.

---

### sfVectorSetString

Sets a string value at a given index.

**Syntax:** `sfVectorSetString( str, index, id )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string value to set |
| index | float | Zero-based element index |
| id | float | Vector ID |

**Returns:** string — The previous value at that index.

---

### sfVectorSize

Returns the number of elements in the struct.

**Syntax:** `sfVectorSize( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Vector ID |

**Returns:** float — The size of the struct.

---

### sfVectorClear

Clears all values in the struct (sets them to none and frees string memory).

**Syntax:** `sfVectorClear( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Vector ID |

**Returns:** None

---

### sfVectorResize

Changes the size of the struct. If the new size is smaller, the trailing
 elements are freed. If larger, new elements are initialized to none.

**Syntax:** `sfVectorResize( newSize, id )`

| Arg | Type | Description |
|-----|------|-------------|
| newSize | float | The new size |
| id | float | Vector ID |

**Returns:** float — The struct ID.

---

### sfVectorPushFloat

Pushes a float value to the end of the vector.

**Syntax:** `sfVectorPushFloat( value, id )`

| Arg | Type | Description |
|-----|------|-------------|
| value | float | The float value to push |
| id | float | Vector ID |

**Returns:** None

---

### sfVectorPushString

Pushes a string value to the end of the vector.

**Syntax:** `sfVectorPushString( str, id )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string value to push |
| id | float | Vector ID |

**Returns:** None

---

### sfVectorPop

Removes and returns the last value from the vector.

**Syntax:** `sfVectorPop( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Vector ID |

**Returns:** AmiVar — The last value (string, float, or none). Returns `Null` if the vector is empty or the ID is invalid.

---

## JSON Functions

JSON objects are created and manipulated via a numeric ID, using RapidJSON internally.

### sfJSONParse

Parses a JSON string and returns a JSON object ID.

**Syntax:** `sfJSONParse( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The JSON string to parse |

**Returns:** float — The JSON object ID.

---

### sfJSONLoad

Loads a JSON file from disk and returns a JSON object ID.

**Syntax:** `sfJSONLoad( filename )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the JSON file |

**Returns:** float — The JSON object ID, or nothing if loading/parsing fails.

---

### sfJSONSave

Saves a JSON object to a file.

**Syntax:** `sfJSONSave( id, filename, mode = "w" )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | JSON object ID |
| filename | string | Path to the output file |
| mode | string | (optional) File mode. Default: `"w"` |

**Returns:** float — 1.0 on success, nothing on failure.

---

### sfJSONGet

Retrieves a value from the JSON object by dot-separated path.

**Syntax:** `sfJSONGet( path, id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | JSON object ID |
| path | string | Dot-separated path to the value (e.g. `"data.items.0.name"`) |

**Returns:** AmiVar — The value (string, float, or none).

**Note:** Supports array index access using numeric keys in the path
 (e.g. `"0"` for the first element).

---

### sfJSONSet

Sets a value in the JSON object by dot-separated path.
 Can optionally create missing path segments.

**Syntax:** `sfJSONSet( path, value, id, create_missing = 1 )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | JSON object ID |
| path | string | Dot-separated path |
| value | AmiVar | The value to set (string or float) |
| create_missing | float | (optional) If non-zero, create missing objects/arrays along the path. Default: 1 |

**Returns:** AmiVar — The set value, or nothing on failure.

---

### sfJSONSetString

Sets a string value in the JSON object by dot-separated path.
 Can optionally create missing path segments.

**Syntax:** `sfJSONSetString( path, value, id, create_missing = 1 )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | JSON object ID |
| path | string | Dot-separated path |
| value | string | The value to set (string or float) |
| create_missing | float | (optional) If non-zero, create missing objects/arrays along the path. Default: 1 |

**Returns:** AmiVar — The set value, or nothing on failure.

---

### sfJSONSetFloat

Sets a value in the JSON object by dot-separated path.
 Can optionally create missing path segments.

**Syntax:** `sfJSONSetFloat( path, value, id, create_missing = 1 )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | JSON object ID |
| path | string | Dot-separated path |
| value | float | The value to set (string or float) |
| create_missing | float | (optional) If non-zero, create missing objects/arrays along the path. Default: 1 |

**Returns:** AmiVar — The set value, or nothing on failure.

---

### sfJSONDestroy

Destroys a JSON object and frees its memory.

**Syntax:** `sfJSONDestroy( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | JSON object ID |

**Returns:** float — 1.0 on success, nothing on failure.

---

### sfJSONCreate

Creates a new empty JSON object.

**Syntax:** `sfJSONCreate()`

**Returns:** float — The JSON object ID.

---

### sfJSONFix

Attempts to fix common issues in a malformed JSON string (removes comments,
 quotes unquoted keys, replaces single quotes with double quotes, etc.).

**Syntax:** `sfJSONFix( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The malformed JSON string |

**Returns:** string — The fixed JSON string.

---

### sfJSONPretty

Pretty-prints a JSON string with 2-space indentation and line breaks.
If the input is not valid JSON, it attempts to fix it first via
`sfJSONFix`'s internal logic.

**Syntax:** `sfJSONPretty( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The JSON string to pretty-print |

**Returns:** string — The formatted JSON string. If both parsing and
fixing fail, returns the original (or fixed) string as-is.

**Example (AFL):**

```afl
formatted = sfJSONPretty("{\"a\":1,\"b\":[2,3]}");
// Result:
// {
//   "a": 1,
//   "b": [
//     2,
//     3
//   ]
// }
```

---

### sfJSONToString

Serializes a JSON object back to a string.

**Syntax:** `sfJSONToString( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | JSON object ID |

**Returns:** string — The JSON string representation.

---

## JStr Functions

JStr functions manipulate lightweight JSON strings directly (no parser, no ID).
All inputs and outputs are AFL strings.

### sfJStrGetKey

Extracts a value by key from a JSON object string.

**Syntax:** `sfJStrGetKey( jstr, key )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string (e.g. `{"name":"John","age":30}`) |
| key | string | Key to look up |

**Returns:** string — The value as a JSON string, or nothing if the key does not exist.

---

### sfJStrGet

Extracts a value by index from a JSON array string.

**Syntax:** `sfJStrGet( jstr, index )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON array string (e.g. `["a","b","c"]`) |
| index | float | Zero-based element index |

**Returns:** string — The value as a JSON string, or nothing if the index is out of range.

---

### sfJStrSetKeyString

Sets a key to a string value in a JSON object string. If the key exists,
its value is replaced; otherwise the key-value pair is appended.

**Syntax:** `sfJStrSetKeyString( jstr, key, value )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string |
| key | string | Key to set |
| value | string | String value to assign |

**Returns:** string — The modified JSON object, or nothing on failure.

---

### sfJStrSetKeyFloat

Sets a key to a numeric value in a JSON object string.

**Syntax:** `sfJStrSetKeyFloat( jstr, key, value )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string |
| key | string | Key to set |
| value | float | Numeric value to assign |

**Returns:** string — The modified JSON object, or nothing on failure.

---

### sfJStrSetKeyBool

Sets a key to a JSON boolean (`true` / `false`) in a JSON object string.

**Syntax:** `sfJStrSetKeyBool( jstr, key, bool )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string |
| key | string | Key to set |
| bool | float | Non‑zero → `true`, zero → `false` |

**Returns:** string — The modified JSON object, or nothing on failure.

---

### sfJStrRemoveKey

Removes a key from a JSON object string.

**Syntax:** `sfJStrRemoveKey( jstr, key )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string |
| key | string | Key to remove |

**Returns:** string — The modified JSON object.

---

### sfJStrRemove

Removes an element by index from a JSON array string.

**Syntax:** `sfJStrRemove( jstr, index )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON array string |
| index | float | Zero-based index to remove |

**Returns:** string — The modified JSON array.

---

### sfJStrClear

Returns an empty JSON structure of the same type as the input
(`{}` for objects, `[]` for arrays).

**Syntax:** `sfJStrClear( jstr )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | Input JSON string |

**Returns:** string — `{}` or `[]`.

---

### sfJStrFix

Fixes common issues in a JSON string:

- Replaces `=` with `:`
- Replaces `;` with `,`
- Converts single quotes to double quotes
- Inserts missing separators
- Removes redundant separators and unnecessary whitespace

**Syntax:** `sfJStrFix( jstr )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | The (possibly malformed) JSON string |

**Returns:** string — The fixed JSON string.

---

### sfJStrMerge

Merges two JSON strings of the same type. For objects, keys from both are
combined. For arrays, elements are concatenated. If the types differ, the
first argument is returned unchanged.

**Syntax:** `sfJStrMerge( jstr1, jstr2 )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr1 | string | First JSON string |
| jstr2 | string | Second JSON string |

**Returns:** string — The merged JSON string.

---

### sfJStrGetPath

Navigates a dot-separated path into a JSON value and returns the result with
the correct AFL type. Numeric path components index into arrays; string
components index into objects.

**Syntax:** `sfJStrGetPath( jstr, path )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON string (object, array, or value) |
| path | string | Dot-separated path, e.g. `"x.1"` for the second element of the array at key `"x"` |

**Returns:** typed value — string, float (1.0/0.0 for booleans), or nothing for null/missing.

| JSON value | AFL type |
|------------|----------|
| string | string (unquoted, unescaped) |
| number | float |
| true | float (1.0) |
| false | float (0.0) |
| null | nothing |
| object / array | string (raw JSON fragment) |

---

### sfJStrKeyFloat

Builds a JSON key—value pair with a numeric value.

**Syntax:** `sfJStrKeyFloat( key, value, opt = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | JSON key |
| value | float | Numeric value |
| opt | float | (optional) 1 = append `,` after value, -1 = prepend `,` before key, 0 = no comma |

**Returns:** string — A JSON fragment `"key":value` (possibly with comma).

---

### sfJStrKeyString

Builds a JSON key—value pair with a string value.

**Syntax:** `sfJStrKeyString( key, value, opt = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | JSON key |
| value | string | String value (will be JSON-escaped) |
| opt | float | (optional) Comma placement: 1 = after, -1 = before, 0 = none |

**Returns:** string — A JSON fragment `"key":"value"` (possibly with comma).

---

### sfJStrKeyRaw

Builds a JSON key—value pair with a raw (unescaped) string value.

**Syntax:** `sfJStrKeyRaw( key, value, opt = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | JSON key |
| value | string | Raw value (inserted as-is, no escaping) |
| opt | float | (optional) Comma placement: 1 = after, -1 = before, 0 = none |

**Returns:** string — A JSON fragment `"key":value` (value not quoted/escaped).

---

### sfJStrKeyBool

Builds a JSON key—value pair with a boolean value.

**Syntax:** `sfJStrKeyBool( key, value, opt = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | JSON key |
| value | float | Non‑zero → `true`, zero → `false` |
| opt | float | (optional) Comma placement: 1 = after, -1 = before, 0 = none |

**Returns:** string — A JSON fragment `"key":true` or `"key":false`.

---

### sfJStrKeyNull

Builds a JSON key with a `null` value.

**Syntax:** `sfJStrKeyNull( key, opt = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | JSON key |
| opt | float | (optional) Comma placement: 1 = after, -1 = before, 0 = none |

**Returns:** string — A JSON fragment `"key":null`.

---

### sfJStrStripPair

Strips the key (and separator) from a `key:value` pair string, returning only the value part.

**Syntax:** `sfJStrStripPair( pair, sep = ':' )`

| Arg | Type | Description |
|-----|------|-------------|
| pair | string | A string containing a `key:value` pair |
| sep | string | (optional) Separator character, default `:` |

**Returns:** string — The value part of the pair.

---

### sfJStrStrip

Strips outermost `{` `}` or `[` `]` brackets from a JSON string.

**Syntax:** `sfJStrStrip( jstr )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON string |

**Returns:** string — The inner content, or the original string if no brackets.

---

### sfJStrNextPair

Extracts the first `key:value` pair from a JSON object string and returns it.

**Syntax:** `sfJStrNextPair( jstr, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string |
| start | float | (optional) Starting offset to begin searching |

**Returns:** string — The next `"key":value` pair, or empty string if no more pairs.

---

### sfJStrNextKey

Extracts the key from the next `key:value` pair in a JSON object string.

**Syntax:** `sfJStrNextKey( jstr, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string |
| start | float | (optional) Starting offset |

**Returns:** string — The key (unquoted), or empty string if no more pairs.

---

### sfJStrNextValue

Extracts the value from the next `key:value` pair in a JSON object string.

**Syntax:** `sfJStrNextValue( jstr, start = 0 )`

| Arg | Type | Description |
|-----|------|-------------|
| jstr | string | JSON object string |
| start | float | (optional) Starting offset |

**Returns:** string — The value part (raw JSON), or empty string if no more pairs.

---

## INI Functions

INI files are created and manipulated via a numeric ID, using inicpp internally.

### sfINILoad

Loads an INI file from disk and returns an INI object ID.

**Syntax:** `sfINILoad( filename )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the INI file |

**Returns:** float — The INI object ID, or nothing if loading fails.

---

### sfINISave

Saves an INI object to a file.

**Syntax:** `sfINISave( filename, id )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the output file |
| id | float | INI object ID |

**Returns:** float — 1.0 on success, nothing on failure.

---

### sfINIGetString

Retrieves a string value from the INI object by section and key.

**Syntax:** `sfINIGetString( section, key, id )`

| Arg | Type | Description |
|-----|------|-------------|
| section | string | Section name |
| key | string | Key within the section |
| id | float | INI object ID |

**Returns:** string — The value as a string, or nothing if the key does not exist.

---

### sfINIGetFloat

Retrieves a float value from the INI object by section and key.

**Syntax:** `sfINIGetFloat( section, key, id )`

| Arg | Type | Description |
|-----|------|-------------|
| section | string | Section name |
| key | string | Key within the section |
| id | float | INI object ID |

**Returns:** float — The value converted to a number, or nothing if the key does not exist.

---

### sfINISet

Sets a string value in the INI object for the given section and key.

**Syntax:** `sfINISet( section, key, value, id )`

| Arg | Type | Description |
|-----|------|-------------|
| section | string | Section name |
| key | string | Key within the section |
| value | string | The value to set |
| id | float | INI object ID |

**Returns:** string — The value that was set, or nothing on failure.

---

### sfINIRemove

Removes a key from the INI object.

**Syntax:** `sfINIRemove( section, key, id )`

| Arg | Type | Description |
|-----|------|-------------|
| section | string | Section name |
| key | string | Key to remove |
| id | float | INI object ID |

**Returns:** None — Returns nothing.

---

## Text File Functions

### sfTextLoad

Loads the entire contents of a text file into a string.

**Syntax:** `sfTextLoad( path )`

| Arg | Type | Description |
|-----|------|-------------|
| path | string | Path to the file |

**Returns:** string — The file contents, or nothing if the file could not be loaded.

---

### sfTextSave

Saves a string to a text file.

**Syntax:** `sfTextSave( path, text )`

| Arg | Type | Description |
|-----|------|-------------|
| path | string | Path to the output file |
| text | string | The text to write |

**Returns:** float — 1.0 on success, 0.0 on failure.

---

### sfTextFree

Frees the memory of a string previously allocated by the plug-in
 (e.g. from `sfTextLoad` or `sfJSONToString`).

**Syntax:** `sfTextFree( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to free |

**Returns:** None

---

## Indicator Functions

### sfDirection

Calculates the position direction (long/short/flat)
 based on price crossing upper and lower bands.

**Syntax:** `sfDirection( Price, UpperBand, LowerBand )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| UpperBand | array | Upper band (non-increasing for short positions) |
| LowerBand | array | Lower band (non-decreasing for long positions) |

**Returns:** array — 1.0 for long, -1.0 for short, 0.0 for flat.

---

### sfTrailingStop

Calculates a trailing stop level based on the current position direction and bands.

**Syntax:** `sfTrailingStop( Direction, UpperBand, LowerBand )`

| Arg | Type | Description |
|-----|------|-------------|
| Direction | array | Direction array (positive = long, negative = short) |
| UpperBand | array | Upper band for short positions |
| LowerBand | array | Lower band for long positions |

**Returns:** array — The trailing stop level, or EMPTY_VAL when flat.

---

### sfSMA

Simple moving average with O(n) complexity, independent of the period,
 using a rolling sum algorithm.

**Syntax:** `sfSMA( Price, period )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| period | float | Moving average period |

**Returns:** array — The SMA values. The first `period-1` bars are `EMPTY_VAL`.

---

### sfMA

Multi-type moving average dispatcher. Supports all standard types plus special types
(JMA, MAMA, ITL, ITLX) that delegate to their dedicated implementations.

#### Standard types

| Type | Description | Formula |
|------|-------------|---------|
| `"SMA"` | Simple Moving Average | Rolling sum `O(n)` |
| `"EMA"` | Exponential Moving Average | α = 2/(p+1), seed = Price[0] |
| `"WMA"` | Linear-Weighted Moving Average | `∑(i·Price[i]) / ∑i` over window |
| `"TMA"` | Triangular Moving Average | SMA(SMA(Price, ceil(p/2)), floor(p/2)+1) |
| `"WWMA"` | Welles-Wilder Windowed MA | Seeded with SMA, then EMA(α = 1/p) |
| `"VAR"` | VIDYA variant | EMA seeded with SMA, alpha = 1/p |
| `"ZMA"` / `"ZLEMA"` | Zero-Lag EMA (Ehlers) | α·(2·Price[i] − Price[i−lag]) + (1−α)·ZMA[i−1], lag = (p−1)/2 |
| `"DEMA"` | Double EMA | 2·EMA − EMA(EMA) |
| `"TEMA"` | Triple EMA | 3·EMA − 3·EMA(EMA) + EMA³ |
| `"KAMA"` | Kaufman's Adaptive MA (simplified) | Efficiency ratio over `p` bars, short = √p, long = p, unit volume |
| `"ALMA"` | Arnaud Legoux Moving Average | Gaussian weighted, σ = 6, offset = 0.85 |
| `"RMA"` / `"Wilder"` | Wilder's Smoothing | α = 1/p, seeded with SMA of first p bars |
| `"VIDYA"` | Variable Index Dynamic Average | Chande's VIDYA, α = 1/p |
| `"DSMA"` | Deviation-Squared MA | Weighted by 1/(1+(Price−Mean)²/Var) per window |
| `"HULL"` | Hull Moving Average | WMA(2·WMA(p/2) − WMA(p), √p) |

#### Special types

| Type | Description | Extra args |
|------|-------------|------------|
| `"JMA"` | Jurik Moving Average — 3-stage adaptive filter with phase/power control | `phase` (default 0, range −100…100), `power` (default 2, range 0.1…9) |
| `"ALMA"` (with extra args) | ALMA with configurable offset and sigma | `offset` (default 0.85), `sigma_div` (default 6.0) |
| `"MAMA"` | MESA Adaptive Moving Average by John Ehlers | `slowLimit` (default 0.05) |
| `"ITL"` | Instantaneous Trendline by John Ehlers (Hilbert Transform + Homodyne discriminator) | — |
| `"ITLX"` | Extended Instantaneous Trendline with user-selectable detrender window | — |

**Syntax:** `sfMA( Price, type, period [, arg1 [, arg2 ]] )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| type | string | Moving average type (case-insensitive) |
| period | float | Period / primary float parameter |
| arg1 | float | *Optional* — meaning depends on type (see per-type docs) |
| arg2 | float | *Optional* — meaning depends on type (see per-type docs) |

**Returns:** array — The moving average values.

**Notes:**
- For most standard types, only `Price`, `type`, and `period` are needed.
- When `type = "JMA"`: `period` is used as the JMA lookback, `arg1` = phase (default 0),
  `arg2` = power (default 2). See [JurikMA](#sfJurikMA) for details.
- When `type = "MAMA"`: `period` is used as `fastLimit` (default 0.5), `arg1` = `slowLimit`
  (default 0.05). See [MAMA](#sfMAMA) for details.
- When `type = "ITL"`: `period` and extras are ignored — ITL takes only the price array.
- When `type = "ITLX"`: `period` is used as the detrender window `n`. See [ITLX](#sfITLX) for details.
- When `type = "ALMA"` with extra args: `period` = window, `arg1` = offset (default 0.85),
  `arg2` = sigma_div (default 6.0). Without extras, ALMA uses the defaults via the standard path.

---

### sfKAMA

Kaufman's Adaptive Moving Average, incorporating volume for greater responsiveness.

**Syntax:** `sfKAMA( Price, Volume, nfast, nslow, d )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| Volume | array | Volume array (set all to 1 for standard KAMA) |
| nfast | float | Fast smoothing period (typically 2) |
| nslow | float | Slow smoothing period (typically 30) |
| d | float | Window ratio period for the efficiency ratio |

**Returns:** array — The KAMA values.

---

### sfHeikinAshi

Performs Heikin-Ashi candle calculation. Modifies the OHLC arrays in place.

**Syntax:** `sfHeikinAshi( Open, High, Low, Close, iterations = 1 )`

| Arg | Type | Description |
|-----|------|-------------|
| Open | array | Open price array (modified in place) |
| High | array | High price array (modified in place) |
| Low | array | Low price array (modified in place) |
| Close | array | Close price array (modified in place) |
| iterations | float | (optional) Number of smoothing iterations. Default: 1 |

**Returns:** None (the input arrays are modified in place).

---

### sfRoundPrice

Rounds a price array to the nearest tick.

**Syntax:** `sfRoundPrice( Price, tickSize )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| tickSize | float | Minimum price increment (tick size) |

**Returns:** array — The rounded prices.

---

### sfHHV

Rolling maximum over a sliding window.
 Small windows (≤ 30): naive O(n·w) algorithm.
 Large windows: monotonic deque O(n).

**Syntax:** `sfHHV( Price, window )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| window | float | Rolling window size |

**Returns:** array — The rolling maximum.

---

### sfLLV

Rolling minimum over a sliding window.
 Same structure as `sfHHV` with reversed comparators.

**Syntax:** `sfLLV( Price, window )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| window | float | Rolling window size |

**Returns:** array — The rolling minimum.

---

### sfZScore

Rolling Z-score normalization over a fixed window. At each bar computes
`(Price - mean) / stddev` using the last `n` values. Returns `EMPTY_VAL`
before the window fills.

**Syntax:** `sfZScore( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Rolling window size (minimum 2) |

**Returns:** array — The Z-score values.

---

### sfRobustScaler

Rolling Robust Scaler over a fixed window. At each bar computes
`(Price - median) / IQR` using the last `n` values with Tukey hinges
for quartile estimation. Robust to outliers compared to Z-score.
Returns `EMPTY_VAL` before the window fills.

**Syntax:** `sfRobustScaler( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Rolling window size (minimum 4) |

**Returns:** array — The robustly scaled values.

---

### sfPolyReg

Rolling polynomial regression over a fixed window. Fits a polynomial
of degree `d` to the last `n` values (x normalized to [0,1]) and
returns the fitted value at the rightmost bar (end-point of the
window). Useful for smoothing and trend estimation with higher-order
curvature.

**Syntax:** `sfPolyReg( Price, n, d )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| d | float | Polynomial degree (≥1, must be < n, capped at 10) |
| n | float | Rolling window size (minimum 2) |

**Notes:**

- Filter weights are precomputed analytically via the pseudo-inverse
  of the design matrix (x in [0,1] for numerical stability).
- Degree is capped at 10 to keep the moment matrix well-conditioned.
- For `d=1`, equivalent to rolling endpoint linear regression (a
  smoothed version of the last value).

**Returns:** array — The polynomial-fitted values.

---

### sfMutualInfo

Rolling mutual information between two series over a fixed window.
For each window the function:

1. **Z-score** normalizes both series within the window — captures
   linear/co-dependence structure.
2. **Percentile-ranks** both series within the window — distribution-
   free, robust to outliers and scale differences.
3. Returns the **average** of the two MI estimates (in nats).

MI is computed via equal-width histogram binning with
`k = max(2, min(10, floor(sqrt(n))))` bins per dimension.

Range: 0 (independent) → ~log(k) (fully dependent, limited by
discretisation).

**Syntax:** `sfMutualInfo( SeriesA, SeriesB, n )`

| Arg | Type | Description |
|-----|------|-------------|
| SeriesA | array | First input series |
| SeriesB | array | Second input series |
| n | float | Rolling window size (minimum 5) |

**Returns:** array — Average MI (z-score + percentile) per window.

---

### sfUpBeta / sfDownBeta

Rolling bull-beta / bear-beta over a fixed window. Computes the
slope of asset vs market returns conditional on market direction.

**Up beta (bull):** regression of `asset_return` on `market_return`
using only periods where `market_return > 0`.

**Down beta (bear):** same but using only periods where
`market_return < 0`. Periods where market return = 0 are excluded
from both.

Returns are computed from simple period-over-period returns of the
input arrays (prices). The first valid output bar is at position
`j + n` (where `j` is the first bar with non-empty values in both
series). If fewer than 2 periods of the required direction are found
within the window, returns 0.

**Syntax:** `sfUpBeta( Asset, Market, n )`\
`sfDownBeta( Asset, Market, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Asset | array | Dependent variable (asset prices) |
| Market | array | Independent variable (market prices) |
| n | float | Rolling window size (minimum 3) |

**Returns:** array — Conditional beta values.

---

### sfUpAlpha / sfDownAlpha

Rolling bull-alpha / bear-alpha over a fixed window. Regresses
excess returns (simple return minus per-period risk-free rate) of
the asset on excess market returns, conditional on the sign of
market excess return.

**Up alpha (bull):** regression intercept using only periods where
`market_return - rf > 0`.

**Down alpha (bear):** regression intercept using only periods where
`market_return - rf < 0`.

For a given subset, `α = E[R_asset - Rf] - β·E[R_market - Rf]` where
`β` is the conditional beta on that subset.

**Syntax:** `sfUpAlpha( Asset, Market, Rf, n )`\
`sfDownAlpha( Asset, Market, Rf, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Asset | array | Dependent variable (asset prices) |
| Market | array | Independent variable (market prices) |
| Rf | array | Per-period risk-free return (same length) |
| n | float | Rolling window size (minimum 3) |

**Notes:**

- `Rf` should be the per-period (daily / weekly / …) risk-free
  return, e.g. `0.05 / 252` for 5 % annualised on daily data.
  Pass a constant or an array.
- First valid output at `j + n` (where `j` is first bar with all
  three inputs non-empty). Returns 0 if fewer than 2 periods of
  the required direction are available in the window.

**Returns:** array — Conditional alpha values.

---

### sfWaveletD4

Causal k-level Daubechies-4 wavelet decomposition over a fixed
sliding window. At each bar the function decomposes the last `n`
values into approximation and detail coefficients at `k` scales,
keeping the most recent (rightmost) coefficient per level.

Boundary treatment uses symmetric mirror extension. The minimum
window size is 4.

**Syntax:** `sfWaveletD4( Price, prefix, n, k )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| prefix | string | Prefix for generated variable names |
| n | float | Sliding window size (≥4) |
| k | float | Number of decomposition levels (≥1) |

**AFL variables created (via `gSite.SetVariable`):**

| Variable | Content |
|----------|---------|
| `<prefix>_CA` | Final-level approximation (smoothest) — also the return value |
| `<prefix>_CD1` | Detail level 1 (highest frequency) |
| `<prefix>_CD2` | Detail level 2 |
| … | … |
| `<prefix>_CDK` | Detail level K (lowest-frequency detail) |

**Example (AFL):**

```afl
approx = sfWaveletD4( Close, "WAV", 64, 3 );
Plot( WAV_CD1, "D1", colorRed );
Plot( approx, "CA3", colorBlue );
```

**Returns:** array — Final-level approximation.

---

### sfWaveletHaar

Causal k-level Haar wavelet decomposition over a fixed sliding window.
Same semantics as `sfWaveletD4` but uses the 2-tap Haar filter
(`h = [1/√2, 1/√2]`, `g = [1/√2, -1/√2]`).

Minimum window size is 2.

**Syntax:** `sfWaveletHaar( Price, prefix, n, k )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| prefix | string | Prefix for generated variable names |
| n | float | Sliding window size (≥2) |
| k | float | Number of decomposition levels (≥1) |

**AFL variables created (via `gSite.SetVariable`):**

| Variable | Content |
|----------|---------|
| `<prefix>_CA` | Final-level approximation — also the return value |
| `<prefix>_CD1` | Detail level 1 (highest frequency) |
| `<prefix>_CD2` | Detail level 2 |
| … | … |
| `<prefix>_CDK` | Detail level K |

**Returns:** array — Final-level approximation.

---

### sfWaveletMorlet

Causal k-scale Morlet continuous wavelet decomposition over a fixed
sliding window. Uses the real part of the Morlet wavelet with
ω₀ = 6 at octave scales s = 1, 2, 4, …, 2^(k−1). At each bar the
wavelet filter is convolved with the window and the rightmost value
is kept per scale.

Unlike the DWT-based wavelets (`sfWaveletD4`, `sfWaveletHaar`), the
Morlet CWT does not sub-sample — each scale produces a full-length
bandpass-filtered version of the input.

The largest scale (lowest frequency) is stored as `<prefix>_CA` and
is also the return value. All k scales are available as
`<prefix>_CD1` … `<prefix>_CDK`.

**Syntax:** `sfWaveletMorlet( Price, prefix, n, k )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| prefix | string | Prefix for generated variable names |
| n | float | Sliding window size (≥4) |
| k | float | Number of scales (≥1) |

**AFL variables created (via `gSite.SetVariable`):**

| Variable | Content |
|----------|---------|
| `<prefix>_CA` | Largest scale (smoothest) — also the return value |
| `<prefix>_CD1` | Scale 1 (highest frequency) |
| `<prefix>_CD2` | Scale 2 |
| … | … |
| `<prefix>_CDK` | Scale K (lowest frequency — same as CA) |

**Returns:** array — Largest-scale wavelet coefficient.

---

### sfARIMA

Rolling ARIMA(p,d,q) forecast over a fixed sliding window. At each
bar the function estimates an ARIMA model on the last `n` values of
`Price` (allowing `d` extra leading bars for differencing) and
returns the `h`-step-ahead forecast.

**Estimation method:**

1. Difference the window `d` times.
2. Fit a high-order AR(p+q) via Yule–Walker / Levinson–Durbin and
   compute residuals.
3. Estimate ARMA(p,q) via OLS (Hannan–Rissanen two-stage) on the
   differenced series.
4. Forecast `h` steps on the differenced scale.
5. Undifference to obtain the price forecast.

**Limits:** `p ≤ 10`, `q ≤ 10`, `d ≤ 2`, `h ≤ 20`.

**Syntax:** `sfARIMA( Price, n, p, d, q, h )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥4) |
| p | float | AR order (0–10) |
| d | float | Differencing order (0–2) |
| q | float | MA order (0–10) |
| h | float | Forecast horizon (≥1, ≤20) |

**Notes:**

- If the effective sample after differencing is too small for
  estimation, the function returns the last observed price.
- The window used internally is `n + d` bars to account for the
  `d` lost observations after differencing. The first valid output
  bar is at `j + n + d`.
- Use `h = 1` for a one-step-ahead forecast.

**Returns:** array — The h-step-ahead forecast made at each bar.

---

### sfGARCH

Rolling GARCH(1,1) conditional volatility over a fixed sliding
window. At each bar the function estimates the GARCH(1,1) model on
the last `n` values (producing `n-1` simple returns) and returns
the conditional standard deviation σ at the window endpoint.

**Estimation method:**

1. Compute simple returns `r_t = (P_{t+1} - P_t) / P_t`.
2. Compute the unconditional variance `σ²_unc`.
3. Variance-targeting: `ω = σ²_unc · (1 − α − β)`.
4. Grid search over `α ∈ [0.01, 0.31]`, `β ∈ [0.55, 0.97]` (step
   0.02) to minimise the negative log-likelihood
   `Σ [ln(σ²_t) + r²_t / σ²_t]`.
5. Return `√σ²_T` using the optimal (α, β).

The model:
`σ²_t = ω + α · r²_{t-1} + β · σ²_{t-1}`

Stationarity requires `α + β < 1`.

**Syntax:** `sfGARCH( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥5, gives ≥4 returns) |

**Notes:**

- Returns 0 if the unconditional variance is zero (constant prices
  within the window).
- The grid spans typical financial GARCH parameters. For unusual
  data the estimate may fall on the grid boundary.

**Returns:** array — Conditional volatility (standard deviation).

---

### sfSortinoRatio

Rolling Sortino ratio over a fixed sliding window. Measures
risk-adjusted return using only downside (negative excess) deviation
instead of total volatility.

`Sortino = (E[R] − Rf) / DD`

where `DD = √( mean( min(R − Rf, 0)² ) )`.

The optional `Rf` parameter sets the risk-free rate / minimum
acceptable return (default 0). Returns are computed as simple
period-over-period changes from the price array.

**Syntax:** `sfSortinoRatio( Price, n [, Rf ] )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥3) |
| Rf | float | Risk-free return per period (optional, default 0) |

**Notes:**

- If the downside deviation is zero (all excess returns ≥ 0) and
  mean excess is positive, returns 100 (practical upper bound).
- If all excess returns are negative or zero, returns 0.

**Returns:** array — Sortino ratio.

---

### sfUlcerIndex

Rolling Ulcer Index over a fixed sliding window. Measures downside
risk by quantifying the depth and duration of drawdowns from the
running peak within the window.

`UI = √( mean( drawdown² ) )`

where for each bar inside the window:
`drawdown = (Price − running_peak) / running_peak`

The index is always ≥ 0; higher values indicate larger and/or longer
drawdowns.

**Syntax:** `sfUlcerIndex( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥2) |

**Returns:** array — Ulcer Index.

---

### sfHurstDFA

Rolling Hurst exponent via Detrended Fluctuation Analysis (DFA)
over a fixed sliding window. At each bar the function:

1. Computes the **profile** (cumulative sum of mean-adjusted values).
2. For each segment size `s ∈ [4, n/4]`, detrends each segment with
   a linear OLS fit and computes the RMS fluctuation `F(s)`.
3. Fits `log F(s)` vs `log s` via OLS → slope = Hurst exponent `H`.

**Interpretation:**

| H | Behaviour |
|---|-----------|
| 0.5 | Random walk (no memory) |
| > 0.5 | Trending / persistent (long memory) |
| < 0.5 | Mean-reverting / anti-persistent |

**Syntax:** `sfHurstDFA( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥8) |

**Notes:**

- Uses at most 64 scale sizes from `4` to `n/4`. Requires at least 3
  valid scales for a stable regression, otherwise returns 0.5.
- If the window is too small (`n < 8`), it is silently raised to 8.
- DFA is robust to non-stationarities compared to R/S analysis.

**Returns:** array — Hurst exponent (0.0–1.0 range typical).

---

### sfHurstDFA2

Rolling Hurst exponent via **second-order** Detrended Fluctuation Analysis
(DFA‑2) over a fixed sliding window. Identical to `sfHurstDFA` except that
each segment is detrended with a **quadratic** (order 2) instead of a
linear polynomial.

This removes curvature artefacts from the profile before computing the RMS
fluctuation, making the estimator more robust for non‑stationary data with
trends that are not purely linear.

**Syntax:** `sfHurstDFA2( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥8) |

**Returns:** array — Hurst exponent (0.0–1.0 range typical).

---

### sfHodrickPrescott

Rolling Hodrick‑Prescott filter over a fixed sliding window. At each
bar solves the HP optimisation on the last `n` values:

`minimise  Σ(y_t − τ_t)² + λ Σ((τ_{t+1}−τ_t) − (τ_t−τ_{t-1}))²`

where `τ_t` is the trend. Returns the rightmost trend value `τ_T`
from the window (purely causal).

The penalty parameter λ controls the smoothness of the trend:

| Data frequency | Recommended λ |
|----------------|:------------:|
| Yearly         | 100          |
| Quarterly      | 1 600        |
| Monthly        | 14 400       |
| Daily          | 129 600      |
| 5‑minute       | 6.25 × 10⁷   |

Internally the function solves the pentadiagonal system `(I+λD′D)τ=y`
with a specialised O(n) banded Gaussian elimination.

**Syntax:** `sfHodrickPrescott( Price, n, lambda )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥5) |
| lambda | float | Smoothing parameter (≥ 0). λ = 0 returns the raw price |

**Returns:** array — HP trend component. Use `Price − trend` for the
cyclical component.

**Example (AFL):**

```afl
trend = sfHodrickPrescott( Close, 128, 129600 );
cycle = Close - trend;
```

---

### sfGoertzel

Rolling Goertzel algorithm over a fixed sliding window. Detects the
amplitude of a specific frequency bin `k` in the last `n` values using
the second-order Goertzel filter (single-bin DFT).

For each window the function computes:
`s₀ = x[t] + 2·cos(2πk/n)·s₁ − s₂` for `t = 0…n−1`, then derives
the magnitude from the final state variables.

**Use cases:**

- Detect cycles at a specific harmonic of the window length
- Build narrow band-pass filters without a full FFT
- Measure the strength of a known periodic component

**Syntax:** `sfGoertzel( Price, n, k )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥3) |
| k | float | Frequency bin index (0 ≤ k < n). `k=0` → DC component, `k=1` → fundamental frequency |

**Notes:**

- The output is the **magnitude** normalized by `n` (consistent scale
  across different window sizes).
- `k = n/2` corresponds to the Nyquist frequency.
- The algorithm is O(n) per bar and numerically stable for moderate n.

**Returns:** array — Goertzel magnitude at frequency bin `k`.

---

### sfFFTSpectrum

Rolling full FFT spectrum (radix‑2 Cooley–Tukey) over a fixed sliding
window. At each bar the function computes the DFT of the last `n`
values of `Price`, zero‑padded to the next power of two
`N = 2^ceil(log₂(n))`.

The magnitude spectrum (`N/2 + 1` bins) is stored as an AFL variable
`<prefix>_MAG` via `gSite.SetVariable`. This array is sized to the
chart length and its first `N/2 + 1` entries contain the magnitude at
each frequency bin (index 0 = DC, index 1 = fundamental, …,
index N/2 = Nyquist).

The function returns the magnitude of the **dominant** (largest)
bin excluding DC, which can be used to detect the prevailing cycle.

**Syntax:** `sfFFTSpectrum( Price, n, prefix )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥4) |
| prefix | string | Prefix for the stored variable name |

**AFL variable created:**

| Variable | Content |
|----------|---------|
| `<prefix>_MAG` | Magnitude spectrum array (first `N/2+1` entries valid) |

**Example (AFL):**

```afl
dom = sfFFTSpectrum( Close, 256, "SP" );
Plot( SP_MAG, "Spectrum", colorRed );
printf( "Dominant magnitude: %g\n", dom );
```

**Returns:** array — Dominant magnitude (largest bin, excluding DC).

---

### sfFFTDenoising

Rolling FFT-based denoising over a fixed sliding window. At each bar
the function:

1. Computes the full radix‑2 FFT of the last `n` values (zero‑padded
   to the next power of two `N`)
2. **Hard-thresholds** the spectrum: bins whose magnitude is below
   `threshold × max_magnitude` are zeroed (DC is always preserved)
3. Reconstructs the signal via IFFT (conjugation trick)

This produces a non-linear low‑pass / band‑pass filter that adapts
to the signal's spectral content, removing low‑amplitude noise while
preserving strong cyclical components.

**Syntax:** `sfFFTDenoising( Price, n, threshold )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥4) |
| threshold | float | Relative cutoff (0–1). Higher values = more aggressive denoising. `threshold = 0` returns the raw signal; `threshold = 0.1` keeps bins with magnitude ≥ 10 % of the dominant component |

**Notes:**

- The threshold is relative to the **maximum magnitude** (excluding
  DC) within each window.
- The function returns the **rightmost** reconstructed value from
  each window, making it purely causal.
- Internally uses the conjugation trick (`IFFT(X) = conj(FFT(conj(X)))
  / N`) to reuse the same radix‑2 FFT routine.

**Returns:** array — Denoised price series.

---

### sfGoertzelDFTSpectrum

Rolling Goertzel DFT spectrum with **Bartels significance test** for
cycle detection. At each bar the function:

1. Computes the **Goertzel magnitude** for every frequency bin
   `k = 1 … n/2` (period = `n/k`)
2. Runs the **Bartels rank test** on the window data to assess
   whether it deviates significantly from white noise
3. If the Bartels p‑value `< sigLevel`, the dominant cycle is
   reported; otherwise the output is 0 (no significant cycle)

The Bartels statistic:
`RV = Σ(R_i − R_{i+1})² / Σ(R_i − R̄)²` where `R_i` are the ranks.
Under H₀ (randomness) `RV ~ N(2, 4/n)`. A one‑sided p‑value
(small → cyclicality) is computed via the normal CDF.

**Syntax:** `sfGoertzelDFTSpectrum( Price, n, prefix, sigLevel )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Sliding window size (≥6) |
| prefix | string | Prefix for stored variable names |
| sigLevel | float | Significance threshold (default 0.05). Cycles with p‑value ≥ sigLevel are rejected |

**AFL variables created:**

| Variable | Content |
|----------|---------|
| `<prefix>_PERIOD` | Dominant cycle period (bars), or 0 if none |
| `<prefix>_MAG` | Goertzel magnitude at the dominant bin |
| `<prefix>_BARTELS_RV` | Bartels RV statistic per bar |
| `<prefix>_BARTELS_P` | Bartels one‑sided p‑value per bar |

**Returns:** array — Dominant cycle period in bars (0 = no significant
cycle detected).

**Example (AFL):**

```afl
period = sfGoertzelDFTSpectrum( Close, 128, "DFT", 0.05 );
Plot( DFT_PERIOD, "Dominant Cycle", colorRed );
Plot( DFT_BARTELS_P, "Bartels p", colorBlue );
```

---

### sfDynamicCycles

Rolling dynamic cycle detection with adaptive entropy‑based threshold,
EWMA smoothing, multi‑scale hierarchy, and signal reconstruction.

At each bar the algorithm:

1. **Multi‑scale spectrum**: computes Goertzel magnitudes at 3 time
   scales (`n`, `2n/3`, `n/2`) for robust cycle detection
2. **Entropy‑based threshold**: estimates the normalised spectral
   entropy `H ∈ [0,1]` (0 = fully peaked, 1 = white noise) and adjusts
   the threshold factor: `k = k₀·(1 + β·(H − 0.5))`
3. **EWMA smoothing**: smooths the threshold cross‑bar:
   `T̅ = α·T_raw + (1−α)·T̅_prev`
4. **Peak detection**: finds spectral peaks above `T̅` with a minimum
   separation of `min_gap` bins
5. **Signal reconstruction**: reconstructs the rightmost value from the
   detected cycles: `recon = DC + Σ 2·Aₖ·cos(φₖ − 2πk/n)`
6. **Window adaptation**: adjusts the window size to ~3× the dominant
   cycle period: `n_new = 0.9·n_old + 0.1·W_optimal`

**Syntax:** `sfDynamicCycles( Price, n, k0, alpha, min_gap, prefix )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price array |
| n | float | Initial window size (≥20) |
| k0 | float | Base threshold multiplier (recommended 2.5–3.0) |
| alpha | float | EWMA smoothing factor (recommended 0.03–0.08) |
| min_gap | float | Minimum bin separation for peaks (recommended 3–5) |
| prefix | string | Prefix for stored variable names |

**AFL variables created:**

| Variable | Content |
|----------|---------|
| `<prefix>_RECON` | Reconstructed signal (also the return value) |
| `<prefix>_ENTROPY` | Normalised spectral entropy per bar |
| `<prefix>_NCYCLES` | Number of detected cycles |
| `<prefix>_ADAPT_K` | Adapted k‑factor per bar |
| `<prefix>_ADAPT_N` | Adapted window size per bar |
| `<prefix>_THRESHOLD` | EWMA‑smoothed threshold value |

**Parameter adaptation rules (per the original specification):**

| Parameter | Initial | Adaptation |
|-----------|---------|------------|
| k (k0) | 2.5–3.0 | Decreases 1 % per extra cycle if > 5 cycles; increases 2 % if no cycles found at low entropy |
| Window n | 100–200 | `n_new = 0.9·n_old + 0.1·W_optimal` where `W_optimal ≈ 3 × dominant_period` |
| α EWMA | 0.03–0.08 | Fixed per call (choose smaller α for slow cycles, larger α for fast cycles) |
| β entropy | 0.3 | Fixed factor weighting the entropy deviation from H = 0.5 |

**Returns:** array — Reconstructed (de‑noised) price series.

---

### sfTwiggsMoneyFlow

Twiggs Money Flow over a sliding window. A volume-weighted measure
of money flow that smooths raw money flow with an EMA.

Raw money flow per bar:
`MF[t] = Volume[t] · ((Close[t] − Low[t]) − (High[t] − Close[t])) / (High[t] − Low[t])`

If `High = Low`, MF[t] is set to 0.

The result is the EMA of MF over the window (α = 2/(n+1)), seeded
with the first MF value in the window.

**Syntax:** `sfTwiggsMoneyFlow( High, Low, Close, Volume, n )`

| Arg | Type | Description |
|-----|------|-------------|
| High | array | High price array |
| Low | array | Low price array |
| Close | array | Close price array |
| Volume | array | Volume array |
| n | float | EMA period (≥2) |

**Returns:** array — Twiggs Money Flow values.

---

### sfChaikinMoneyFlow

Chaikin Money Flow (CMF) measures the amount of Money Flow Volume
over a specified period. It was developed by Marc Chaikin.

Money Flow Multiplier per bar:
`MFM[t] = ((Close[t] − Low[t]) − (High[t] − Close[t])) / (High[t] − Low[t])`

If `High = Low`, that bar contributes zero to the sum.

CMF is the ratio of accumulated Money Flow Volume to accumulated
Volume over the window:
`CMF = Σ(MFM[t] · Volume[t]) / Σ(Volume[t])`

Values range from −1 to +1. Positive values indicate buying pressure
(accumulation); negative values indicate selling pressure (distribution).

**Syntax:** `sfChaikinMoneyFlow( High, Low, Close, Volume, n )`

| Arg | Type | Description |
|-----|------|-------------|
| High | array | High price array |
| Low | array | Low price array |
| Close | array | Close price array |
| Volume | array | Volume array |
| n | float | Lookback period (≥2). Default: 21 |

**Returns:** array — Chaikin Money Flow values between −1 and +1.

---

### sfExpectancy

Rolling expectancy (expected gain per bar) over a sliding window.

Measures the statistical edge per bar by comparing the probability‑weighted average win against the probability‑weighted average loss.

**Syntax:** `sfExpectancy( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| n | float | Window length (≥ 2) |

**Algorithm:**

- For each bar, look at the last `n` price changes
- `WinRate = #positive / n`
- `LossRate = #negative / n`
- `Expectancy = WinRate·AvgWin − LossRate·AvgLoss`

**Returns:** array — expectancy values (in price units).

**Notes:**

- The first `n` bars return `Empty`.
- A positive expectancy indicates a statistical edge in the direction of the position.

---

### sfVWAP

Volume‑Weighted Average Price, reset at user‑defined start points.

Cumulates `Σ(Price·Volume)` and `Σ(Volume)` from the most recent `Start` signal and returns their ratio at each bar.

**Syntax:** `sfVWAP( Price, Volume, Start )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| Volume | array | Volume array |
| Start | array | Non‑zero values reset the VWAP calculation |

**Returns:** array — VWAP values.

**Notes:**

- When `Start` is non‑zero, cumulative sums are reset and VWAP restarts from that bar.
- When `Volume` is zero, the previous VWAP value is carried forward (if already started).
- Cells where `Price` or `Volume` are `Empty` are skipped.

**Example:**

```afl
// Daily VWAP — reset at each session open
Start = Day() != Ref(Day(), -1);
VWAP = sfVWAP(C, V, Start);
```

---

### sfVixFix

Williams VIX Fix — an estimate of implied volatility from price data.

Computes the annualised standard deviation of the typical price `(H + L + C)/3` over a rolling window of *n* periods, expressed as a percentage of the mean typical price.  The result is conceptually similar to the CBOE VIX index but requires only OHLC data.

**Syntax:** `sfVixFix( High, Low, Close, n )`

| Arg | Type | Description |
|-----|------|-------------|
| High | array | High price array |
| Low | array | Low price array |
| Close | array | Close price array |
| n | float | Window length (≥ 2, default 22) |

**Algorithm:**

- `Typical = (High + Low + Close) / 3`
- `σ = sample standard deviation of Typical over n bars`
- `VIX Fix = σ · √252 / SMA(Typical, n) · 100`

**Returns:** array — VIX Fix values (annualised volatility, %).

**Notes:**

- The first `n` bars return `Empty`.
- `n = 22` corresponds to one trading month (≈ 22 days).

---

### sfSuperTrend

SuperTrend trailing stop.

Computes a trend-following trailing stop based on the Average True Range (Wilder's smoothing).  Band crossings are judged against the midpoint `(Open + Close) / 2`.

**Syntax:** `sfSuperTrend( Open, High, Low, Close, k, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Open | array | Open price |
| High | array | High price |
| Low | array | Low price |
| Close | array | Close price |
| k | float | ATR multiplier (≥ 0.1) |
| n | float | ATR period (≥ 2, default 7) |

**Returns:** array — the SuperTrend trailing stop level.  When price is above the stop the trend is up; when below, the trend is down.

**Notes:**

- Uses Wilder's modified EMA for ATR: `ATR = (prev_ATR × (n‑1) + TR) / n`.
- In an uptrend the trailing stop is the lower band (ratchets up only); in a downtrend it is the upper band (ratchets down only).
- The first `n` bars return `Empty`.

---

### sfPMAX

Profit Maximizer — combines sfMOST (configurable MA) with sfSuperTrend (ATR bands + trailing stop).

Uses a moving average as the centre line, ATR and percentage bands for the trailing stop, and median for band-crossing tests.

**Syntax:** `sfPMAX( Open, High, Low, Close, "MA_type", ma_len, k, atr_period, percent )`

| Arg | Type | Description |
|-----|------|-------------|
| Open | array | Open price |
| High | array | High price |
| Low | array | Low price |
| Close | array | Close price |
| MA_type | string | Moving average type (see sfMOST) |
| ma_len | float | MA period (≥ 2, default 21) |
| k | float | ATR multiplier (≥ 0.1, default 3.0) |
| atr_period | float | ATR period (≥ 2, default 10) |
| percent | float | Additional % band offset (default 1.0) |

**Returns:** array — the PMAX trailing stop level.  When median is above the stop the trend is up; when below, the trend is down.

**Algorithm:**

- MA = moving average of Close over `ma_len` using `MA_type`
- ATR = Average True Range over `atr_period` (Wilder's smoothing)
- Upper band = MA + `k`·ATR + MA·`percent`/100
- Lower band = MA − `k`·ATR − MA·`percent`/100
- In an uptrend the trailing stop is the lower band (ratchets up only); in a downtrend it is the upper band (ratchets down only).

**Notes:**

- The first `max(ma_len, atr_period)` bars return `Empty`.

---

### sfPROMAXI

Bollinger variant of sfPMAX — replaces the percentage band with a rolling standard‑deviation band (Bollinger).

Identical to `sfPMAX` except the last parameter controls a Bollinger band instead of a percentage offset.

**Syntax:** `sfPROMAXI( Open, High, Low, Close, "MA_type", ma_len, k, atr_period, bb_mult )`

| Arg | Type | Description |
|-----|------|-------------|
| Open | array | Open price |
| High | array | High price |
| Low | array | Low price |
| Close | array | Close price |
| MA_type | string | Moving average type (see sfMOST) |
| ma_len | float | MA period (≥ 2, default 21) |
| k | float | ATR multiplier (≥ 0.1, default 3.0) |
| atr_period | float | ATR period (≥ 2, default 10) |
| bb_mult | float | StdDev multiplier (default 2.0) |

**Returns:** array — the PROMAXI trailing stop level.

**Algorithm:**

- MA = moving average of median over `ma_len` using `MA_type`
- ATR = Average True Range over `atr_period` (Wilder's smoothing)
- StdDev = rolling population standard deviation of Close over `ma_len`
- Upper band = MA + Max(`k`·ATR, `bb_mult`·StdDev)
- Lower band = MA − Max(`k`·ATR, `bb_mult`·StdDev)
- Trailing stop logic identical to sfPMAX.

**Notes:**

- The first `max(ma_len, atr_period)` bars return `Empty`.

---

### sfAverageSince

Volume-weighted average price since the last detected peak or trough.

The `PeakOrTrough` array contains 0 by default.  When a peak or trough is detected at bar `i`, it contains the number of bars ago where that turning point occurred (e.g., 3 means the peak/trough was at bar `i − 3`).  The average is computed from that detected bar to the current bar, using volume as the weight.

**Syntax:** `sfAverageSince( PeakOrTrough, Price, Volume )`

| Arg | Type | Description |
|-----|------|-------------|
| PeakOrTrough | array | 0 = no detection, N = peak/trough was N bars ago |
| Price | array | Price array (typically Close) |
| Volume | array | Volume array |

**Returns:** array — VWAP since the most recent peak/trough detection.

**Algorithm:**

- Maintain cumulative sums `Σ(Price·Volume)` and `Σ(Volume)` from the first valid bar.
- When `PeakOrTrough[i] ≠ 0`, set `peakBar = i − N` (the detected turning point).
- `VWAP = (ΣPV[i] − ΣPV[peakBar−1]) / (ΣV[i] − ΣV[peakBar−1])`.

**Notes:**

- The very first detection position (non-zero `PeakOrTrough`) determines the look‑back window; earlier bars return `Empty`.

---

### sfMOST

Moving Optimal Stop (MOST) by Anıl Özekşi.

Trailing stop based on an adjustable percentage of a moving average.  The stop band follows the MA on one side and ratchets (only moves away from the MA).  Trend reverses when the MA crosses the stop.

**Syntax:** `sfMOST( Price, "MA_type", len, percent )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Input price (typically Close) |
| MA_type | string | Moving average type: `"EMA"` (default), `"SMA"`, `"WMA"` (Weighted), `"TMA"` (Triangular), `"WWMA"` (Wilder's/RMA), `"VAR"` (VIDYA), `"ZLEMA"` (Zero-Lag) |
| len | float | MA period (≥ 2, default 21) |
| percent | float | Bandwidth as % of MA (≥ 0, default 2.0) |

**Returns:** array — the MOST trailing stop level.  When the MA is above the stop the trend is up; when below, the trend is down.

**Algorithm:**

- Compute MA = MA(Price, len) using the requested type
- If MA > previous MOST: stop = MA × (1 − percent/100), ratcheted up
- If MA < previous MOST: stop = MA × (1 + percent/100), ratcheted down

**Notes:**

- The developer recommends the Variable Moving Average (VIDYA) for ranging markets; use `"EMA"` or `"SMA"` for trending markets.
- The first `len` bars return `Empty`.

---

### sfInvFisher

Inverse Fisher Transform.

**Syntax:** `sfInvFisher( Price )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | input price array |

**Returns:** array - the inverse Fisher transform of input prices.

---

### sfMAMA

MESA Adaptive Moving Average by John Ehlers.

Uses the Hilbert Transform (7‑weight FIR) to measure the instantaneous dominant cycle period via the Homodyne discriminator, then adapts the smoothing factor *α* to the measured period. When the market is cycling (short period) the filter responds quickly; when the market is trending (long period) it smooths heavily.

**Syntax:** `sfMAMA( Price, fastLimit, slowLimit, prefix )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| fastLimit | float | Upper bound for *α* (default 0.5) |
| slowLimit | float | Lower bound for *α* (default 0.05) |
| prefix | string | Prefix for stored variables |

**Returns:** array — MAMA values.

**Notes:**

- The first 8 bars return `Empty` (needed for the Hilbert FIR filter).
- `fastLimit` must be ≥ `slowLimit`; values are swapped if needed.
- Input arrays with leading `Empty` values are skipped automatically.

---

### sfFAMA

Following Adaptive Moving Average by John Ehlers.

Uses the same Hilbert‑Transform cycle measurement as `sfMAMA` but returns the
double‑smoothed FAMA line instead of the faster MAMA line.  No stored variables.

**Syntax:** `sfFAMA( Price, fastLimit, slowLimit )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| fastLimit | float | Upper bound for *α* (default 0.5) |
| slowLimit | float | Lower bound for *α* (default 0.05) |

**Returns:** array — FAMA values.

**Notes:**

- The first 8 bars return `Empty`.
- `fastLimit` must be ≥ `slowLimit`; values are swapped if needed.
- Input arrays with leading `Empty` values are skipped automatically.

---

### sfFRAMA

Fractal Adaptive Moving Average by John Ehlers.

Computes the fractal dimension *D* from the log‑range ratio of two window halves. When *D* → 1 (smooth trend) the filter is fast (α → 1); when *D* → 2 (rough/choppy market) it becomes very smooth (α → 0.01).

**Syntax:** `sfFRAMA( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| n | float | Window length (≥4, rounded to even) |

**Returns:** array — FRAMA values.

**Notes:**

- The first `n` bars return `Empty`.
- `n` must be ≥ 4; odd values are rounded up to the nearest even.

---

### sfITL

Instantaneous Trendline by John Ehlers.

Uses the Hilbert Transform (7‑weight FIR) and Homodyne discriminator to measure the dominant cycle period, then applies a super‑smooth recursive filter with *α* = ( 2 / (Period + 1) )². The squared alpha makes the ITL considerably smoother than MAMA while still adapting to the measured cycle.

**Syntax:** `sfITL( Price )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |

**Returns:** array — Instantaneous Trendline values.

**Notes:**

- The first 8 bars return `Empty` (Hilbert FIR lookback).
- No static state — safe for multiple simultaneous calls.

---

### sfITLX

Extended Instantaneous Trendline with a user‑selectable detrender window.

Same Hilbert‑Transform / Homodyne structure as `sfITL`, but both the detrender
(SMA window) and the Hilbert‑FIR lags are scaled proportionally to *n*.
A larger *n* removes slower cycles and produces a smoother trendline.

**Syntax:** `sfITLX( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| n | float | Detrender SMA window (≥ 4, rounded up to multiple of 4) |

**Returns:** array — ITLX values.

**Notes:**

- The first `3·n` bars return `Empty` (Hilbert lookback scales with *n*).
- No static state — safe for multiple simultaneous calls.

---

### sfNET

Noise Elimination Technology by John Ehlers.

Measures the signal‑to‑noise ratio via 1‑bar and 2‑bar differences over a window *n*.  When the market trends strongly (d₁ ≫ d₂) the filter tracks closely; when it is noisy (d₂ ≈ d₁) the filter smooths heavily.

**Syntax:** `sfNET( Price, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| n | float | Smoothing window for the SNR estimates (≥ 2) |

**Algorithm:**

- `d₁[i] = Price[i] − Price[i−1]`
- `d₂[i] = (Price[i] − Price[i−1]) − (Price[i−1] − Price[i−2])`  *(second difference)*
- `SNR = SMA(|d₁|, n) / SMA(|d₂|, n)`
- `α = SNR² / (1 + SNR²)` — maps [0, ∞) → [0, 1)
- `NET[i] = α · Price[i] + (1−α) · NET[i−1]`

**Returns:** array — NET values.

**Notes:**

- The first `n + 1` bars return `Empty` (needed for the SMA and second difference).
- No static state — safe for multiple simultaneous calls.

---

### sfSinewave

Ehlers' sinewave oscillator for identifying cycle turning points.

Uses the Hilbert Transform (7‑weight FIR) to extract the instantaneous phase angle from the detrended price, then normalises it to a sine wave oscillating in [−1, +1].  The lead sine (45° ahead) is stored as a named variable.

**Syntax:** `sfSinewave( Price, prefix )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| prefix | string | Prefix for the stored LeadSine variable |

**Returns:** array — Sine values.

**Stored variable:**

| Variable | Description |
|----------|-------------|
| `<prefix>_LEADSINE` | Sine advanced by 45°; its crossings with the main Sine identify cycle tops and bottoms |

**Algorithm:**

- `I` and `Q` via Hilbert FIR on the detrended price (`Price − SMA(Price, 4)`)
- `r = √(I² + Q²)`,  `Sine = Q / r`,  `LeadSine = (I + Q) / (r · √2)`

**Notes:**

- The first 8 bars return `Empty`.
- No static state — safe for multiple simultaneous calls.

---

### sfLaguerreRSI

Laguerre RSI by John Ehlers.

Applies a 4‑pole Laguerre all‑pass filter to the price, then computes an RSI‑like oscillator from the cumulative differences between the leading (L₀) and lagging (L₁) filter outputs.

The Laguerre RSI is smoother and more responsive than a traditional RSI of comparable lookback.

**Syntax:** `sfLaguerreRSI( Price, gamma, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| gamma | float | Laguerre filter coefficient (0.01–0.99, default 0.5) |
| n | float | Decay period for the Cu/Cd accumulators (≥ 1, default 8) |

**Algorithm:**

- Laguerre filter (recursive, all‑pass):
  `L₀ = (1−γ)·Price + γ·L₀[1]`
  `L₁ = −γ·L₀ + L₀[1] + γ·L₁[1]`
  *(L₂, L₃ follow the same structure)*
- Cu/Cd accumulation with exponential decay `α = 1/n`:
  - if `L₀ > L₁` : `Cu += (L₀−L₁) − Cu·α` , else `Cu −= Cu·α`
  - if `L₀ < L₁` : `Cd += (L₁−L₀) − Cd·α` , else `Cd −= Cd·α`
- `RSI = Cu / (Cu+Cd) · 100`

**Returns:** array — Laguerre RSI values (0–100 scale).

**Notes:**

- The first bar returns `Empty` (filter needs at least one prior bar).
- No static state — safe for multiple simultaneous calls.

---

### sfReflex

Reflex indicator by John Ehlers.

Extracts the underlying trend via a SuperSmoother (2‑pole Butterworth), isolates the cycle component (`Price − Trend`), smooths it with a second SuperSmoother, and normalises by the rolling standard deviation of the raw cycle. Positive extremes show price extended above its trend; negative extremes show price extended below.

**Syntax:** `sfReflex( Price, hp, lp, n )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| hp | float | High‑pass SuperSmoother period for trend extraction (4–200) |
| lp | float | Low‑pass SuperSmoother period for cycle smoothing (2–50) |
| n | float | EMA lookback for rolling variance of the raw cycle (2–100) |

**Algorithm:**

- Trend = SuperSmoother(Price, hp)
- Cycle = Price − Trend
- SmoothCycle = SuperSmoother(Cycle, lp)
- Rolling mean *M* and variance *V* of Cycle via EMA(α = 1 / n)
- `Reflex = SmoothCycle / √V`, clipped to [−3, +3]

**Returns:** array — Reflex oscillator (dimensionless).

**Recommended defaults:** `hp = 20…48`, `lp = 5…10`, `n = hp / 2` (or ≈ 20).

**Notes:**

- The first `max(hp, 8)` bars return `Empty` (filter warm‑up).
- No static state — safe for multiple simultaneous calls.

---

### sfSuperSmoother

2‑pole SuperSmoother filter by John Ehlers.

A maximally smooth, zero‑lag filter based on a 2‑pole Butterworth design. Often used as a building block for other Ehlers indicators (e.g. Reflex, Roofing Filter).

**Syntax:** `sfSuperSmoother( Price, period )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| period | float | Filter period (≥ 2) |

**Algorithm:**

- `a₁ = exp(−√2 · π / period)`
- `b₁ = 2 · a₁ · cos(√2 · π / period)`
- `c₂ = b₁`,  `c₃ = −a₁²`,  `c₁ = 1 − c₂ − c₃`
- `SS[t] = c₁ · (Price[t] + Price[t−1]) / 2 + c₂ · SS[t−1] + c₃ · SS[t−2]`

**Returns:** array — SuperSmoother values.

**Notes:**

- The first `period` bars return `Empty` (filter convergence).
- No static state — safe for multiple simultaneous calls.

---

### sfHilbertOsc

Hilbert oscillator by John Ehlers.

Returns the normalised in‑phase component (cosine of the instantaneous phase) extracted from the Hilbert Transform. Oscillates in [−1, +1] and is 90° out of phase with `sfSinewave`.

Use the two together to identify cycle turning points:

- Sine (`sfSinewave`) crosses zero at cycle midpoints
- Hilbert Osc crosses zero at cycle extremes

**Syntax:** `sfHilbertOsc( Price )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |

**Algorithm:**

- Detrender = Price − SMA(Price, 4)
- `I`, `Q` via Hilbert FIR (7‑weight)
- `r = √(I² + Q²)`,  `HilbertOsc = I / r` (cosine of phase)

**Returns:** array — Hilbert oscillator values [−1, +1].

**Notes:**

- The first 8 bars return `Empty` (Hilbert FIR lookback).
- No static state — safe for multiple simultaneous calls.

---

### sfRocketRSI

Rocket RSI by John Ehlers.

Replaces the traditional RSI's EMA / Wilder smoothing with a SuperSmoother (2‑pole Butterworth) applied to the raw up/down changes. The result is a smoother, more responsive RSI with less lag.

**Syntax:** `sfRocketRSI( Price, period )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Price array |
| period | float | SuperSmoother period (≥ 2, typical 8–14) |

**Algorithm:**

- `Up[t] = max(Price[t]−Price[t−1], 0)`,  `Dn[t] = max(Price[t−1]−Price[t], 0)`
- `Sup = SuperSmoother(Up, period)`,  `Sdn = SuperSmoother(Dn, period)`
- `RSI = Sup / (Sup + Sdn) · 100`

**Returns:** array — Rocket RSI values (0–100 scale).

**Notes:**

- The first `period + 1` bars return `Empty` (change + SuperSmoother convergence).
- No static state — safe for multiple simultaneous calls.

---

### sfBarsSincePeak

Returns the number of bars elapsed since the last confirmed peak in a time
series. A peak is detected with a delay (causal — no look-ahead) using two
criteria: **duration** and **prominence**.

A candidate peak P (a local high) is confirmed at bar `P + duration` when:

1. At least **duration** bars have passed.
2. The price has retraced by at least **prominence** from the peak
   (`peak − min_low_since_peak ≥ prominence`).
3. No bar has exceeded the peak value during the waiting period.

If any later value exceeds the candidate, it is invalidated and the new higher
value becomes the candidate.

**Syntax:** `sfBarsSincePeak( series, duration, prominence )`

| Arg | Type | Description |
|-----|------|-------------|
| series | array | Time series to detect peaks in |
| duration | float | Minimum number of bars before a peak can be confirmed (≥ 1) |
| prominence | float | Minimum retracement from the peak to confirm it (≥ 0) |

**Algorithm (per bar):**

```pseudo
For each bar i:
  if series[i] > candidateVal → new candidate at i
  if candidate exists and i − candidateBar ≥ duration:
    if candidateVal − minLowSinceCandidate ≥ prominence:
      → peak confirmed at candidateBar
      → rescan for next candidate from candidateBar+1
  result[i] = i − lastConfirmedPeakBar (or -1 if none)
```

**Returns:** array — Number of bars since the last confirmed peak, or −1 if
no peak has been detected yet.

**Example:**

```afl
bars = BarsSincePeak(H, 5, 1.5);  // H peak, 5-bar min wait, 1.5 retracement
Plot(bars, "BarsSincePeak", colorRed);
```

---

### sfBarsSinceTrough

Returns the number of bars elapsed since the last confirmed trough in a time
series. Mirror of `sfBarsSincePeak` — uses the same **duration** and
**prominence** criteria but detects local minima.

A candidate trough T (a local low) is confirmed at bar `T + duration` when:

1. At least **duration** bars have passed.
2. The price has rallied by at least **prominence** from the trough
   (`max_high_since_trough − trough ≥ prominence`).
3. No bar has gone below the candidate trough during the waiting period.

If any later value goes below the candidate, it is invalidated and the new
lower value becomes the candidate.

**Syntax:** `sfBarsSinceTrough( series, duration, prominence )`

| Arg | Type | Description |
|-----|------|-------------|
| series | array | Time series to detect troughs in |
| duration | float | Minimum number of bars before a trough can be confirmed (≥ 1) |
| prominence | float | Minimum rally from the trough to confirm it (≥ 0) |

**Algorithm (per bar):**

```pseudo
For each bar i:
  if series[i] < candidateVal → new candidate at i
  if candidate exists and i − candidateBar ≥ duration:
    if maxHighSinceCandidate − candidateVal ≥ prominence:
      → trough confirmed at candidateBar
      → rescan for next candidate from candidateBar+1
  result[i] = i − lastConfirmedTroughBar (or -1 if none)
```

**Returns:** array — Number of bars since the last confirmed trough, or −1 if
no trough has been detected yet.

**Example:**

```afl
bars = BarsSinceTrough(L, 5, 1.5);  // L trough, 5-bar min wait, 1.5 rally
Plot(bars, "BarsSinceTrough", colorBlue);
```

---

### sfDemandIndex

James Sibbet's Demand Index — measures the relationship between price and
volume by comparing smoothed buying and selling pressure.

For each bar:

- **Buying pressure** = Volume / Range when Close > Open, else 0.
- **Selling pressure** = Volume / Range when Close < Open, else 0.
- If Close == Open, both equal Volume / Range.

Both pressures are smoothed with separate EMAs, then combined into a single
oscillator:

```afl
DI = (EMA_Buy − EMA_Sell) / (EMA_Buy + EMA_Sell) × 100
```

**Syntax:** `sfDemandIndex( Open, High, Low, Close, Volume, period )`

| Arg | Type | Description |
|-----|------|-------------|
| Open | array | Open prices |
| High | array | High prices |
| Low | array | Low prices |
| Close | array | Close prices |
| Volume | array | Volume |
| period | float | EMA smoothing period (default 13, minimum 2) |

**Returns:** array — Demand Index values, oscillating between −100
(extreme supply) and +100 (extreme demand). Zero indicates balance.

**Notes:**

- The first `period − 1` bars return `Empty` (EMA convergence).
- `Range = max(High − Low, 1e-10)` to avoid division by zero.
- Values near +100 suggest strong demand (bullish); near −100 suggest
  strong supply (bearish).

---

### sfDeMarker

Tom DeMark's DeMarker oscillator — measures whether the current high/low is
higher/lower than the previous bar's high/low, then smooths the result.

For each bar `i ≥ 1`:

- `DeMax[i] = max(High[i] − High[i-1], 0)`
- `DeMin[i] = max(Low[i-1] − Low[i], 0)`

Both series are smoothed with a simple moving average over `period` bars,
then combined:

```afl
DeMarker = SMA(DeMax) / (SMA(DeMax) + SMA(DeMin))
```

**Syntax:** `sfDeMarker( High, Low, period )`

| Arg | Type | Description |
|-----|------|-------------|
| High | array | High prices |
| Low | array | Low prices |
| period | float | Smoothing period (≥ 2, typical 10–20) |

**Returns:** array — DeMarker values oscillating between 0 and 1.
Traditional thresholds: > 0.7 overbought, < 0.3 oversold.

**Notes:**

- The first `period` bars return `Empty` (SMA convergence).
- Values near 0.5 indicate neutral momentum.

---

### sfWilliamsPercentRange

Williams %R (Williams Percent Range) — a momentum oscillator that measures
the level of the Close relative to the highest high and lowest low over
a lookback period. Developed by Larry Williams.

```afl
%R = (HighestHigh(n) - Close) / (HighestHigh(n) - LowestLow(n)) × -100
```

The oscillator ranges from −100 to 0. Values below −80 suggest the
security is **oversold** (potential buying opportunity); values above −20
suggest it is **overbought** (potential selling opportunity).

**Syntax:** `sfWilliamsPercentRange( High, Low, Close, n )`

| Arg | Type | Description |
|-----|------|-------------|
| High | array | High price array |
| Low | array | Low price array |
| Close | array | Close price array |
| n | float | Lookback period (≥2). Default: 14 |

**Returns:** array — Williams %R values between −100 and 0.

**Notes:**

- The first `n − 1` bars return `Empty` (window convergence).
- The higher the bar range (High-Low), the more informative the indicator.
- Values at −100 mean the Close equals the lowest low of the window;
  values at 0 mean the Close equals the highest high.

---

### sfTDSetup

Tom DeMark's TD Setup — detects consecutive buy or sell signals by comparing
each Close with the Close `lookback` bars earlier.

- **Buy Setup** (count): `Close[i] < Close[i − lookback]`
- **Sell Setup** (count): `Close[i] > Close[i − lookback]`

The counter increments for each consecutive bar that satisfies the condition
and resets to zero on any failure.

A Setup is **Perfected** when the count reaches `setupLen` AND the following
extra conditions hold at the same bar:

- Buy Perfected: `Close[i] > Close[i−(lookback−1)]` AND `Close[i] > Close[i−(lookback−2)]`
- Sell Perfected: `Close[i] < Close[i−(lookback−1)]` AND `Close[i] < Close[i−(lookback−2)]`

If the perfection conditions are not met, the Setup remains active (1 / −1).

**Syntax:** `sfTDSetup( Close [, setupLen, lookback ] )`

| Arg | Type | Description |
|-----|------|-------------|
| Close | array | Close prices |
| setupLen | float | (optional) Number of bars needed to complete a setup (default 9) |
| lookback | float | (optional) Comparison offset (default 4, minimum 2) |

**Returns:** array — Per‑bar status:

| Value | Meaning |
|-------|---------|
| 0 | No setup active |
| 1 | Buy Setup in progress (count ≥ 1, not perfected) |
| 2 | Buy Setup perfected |
| −1 | Sell Setup in progress |
| −2 | Sell Setup perfected |

**Notes:**

- The first `lookback` bars return `0` (insufficient history).
- `lookback` must be ≥ 2 so that the perfection lookbacks (`lookback−1`, `lookback−2`) are valid.

---

### sfTDCountdown

Tom DeMark's TD Countdown — the second phase of TD Sequential. Counts
13 occurrences of a "touch" condition after a TD Setup completes.

The Setup is detected internally (setupLen=9, lookback=4). Once a Buy or Sell
Setup completes, the countdown begins on the following bars:

- **Buy Countdown**: `Close[i] ≤ Low[i−2]` → increment count (returns 1…13)
- **Sell Countdown**: `Close[i] ≥ High[i−2]` → increment count (returns −1…−13)

If an opposite‑direction Setup completes during the countdown, the current
countdown is cancelled and the opposite one starts.

**Syntax:** `sfTDCountdown( Close, High, Low [, countdownLen ] )`

| Arg | Type | Description |
|-----|------|-------------|
| High | array | High prices |
| Low | array | Low prices |
| Close | array | Close prices |
| countdownLen | float | (optional) Touch count needed (default 13) |

**Returns:** array — Current countdown progress:

| Value | Meaning |
|-------|---------|
| 0 | No countdown active |
| 1 … N | Buy countdown in progress (N = countdownLen = perfected) |
| −1 … −N | Sell countdown in progress |

**Notes:**

- The first 4 bars return `0` (setup lookback needs history).
- `countdownLen` default is 13 (DeMark standard).

---

### sfLakeRatio

Ed Seykota's Lake Ratio — accumulates the drawdown from the highest value
detected over a lookback window. The metaphor is of water flowing out of a
lake (the peak) as price declines.

For each bar `i`:

1. Find the highest value of `P` in the last `n` bars
   (or the all‑time high if `n = 0`).
2. **Lake**[`i`] = sum of (`peak` − `P[k]`) for `k` from the peak bar to `i`.
3. A new peak resets the Lake to zero.

If `opt = 0` the raw cumulative sum is returned; if `opt = 1` the
per‑bar average since the peak is returned.

**Syntax:** `sfLakeRatio( P, n, opt )`

| Arg | Type | Description |
|-----|------|-------------|
| P | array | Price series |
| n | float | Lookback window (0 = all‑time high) |
| opt | float | 0 = cumulative sum, 1 = average since peak |

**Algorithm (n = 0, all‑time high):**

```pseudo
peakVal = P[0]
for each bar i:
  if P[i] > peakVal: new peak → lake = 0
  else:              lake += peakVal − P[i]
  result = (opt==0) ? lake : lake / (i − peakBar + 1)
```

**Returns:** array — Lake Ratio values (non‑negative). The ratio grows as
price declines from the peak and resets at each new high.

---

## Slippage Estimation Functions

### sfIntradaySlippageEstimate

Estimates intraday market order slippage based on OHLCV data and order size.
 Supports multiple models.

**Syntax:** `sfIntradaySlippageEstimate( Open, High, Low, Close, Volume,
                            TradeVolume, TickSize, PointValue, liqCap, options )`

| Arg | Type | Description |
|-----|------|-------------|
| Open | array | Open price array |
| High | array | High price array |
| Low | array | Low price array |
| Close | array | Close price array |
| Volume | array | Volume array |
| TradeVolume | array | Trade volume to estimate slippage for |
| TickSize | float | Minimum price increment |
| PointValue | float | Monetary value per point |
| liqCap | float | Liquidity capture parameter (typically 0.1) |
| options | float | Model selection: 0 = tick-based, 1 = Roll's model, 2 = Amihud's model, 3 = Almgren's model |

**Returns:** array — Estimated slippage in monetary units.

---

### sfSlippageEstimate

End-of-day slippage estimation. Same signature as `sfIntradaySlippageEstimate`.

**Syntax:** `sfSlippageEstimate( Open, High, Low, Close, Volume, TradeVolume,
                                 TickSize, PointValue, liqCap, options )`

| Arg | Type | Description |
|-----|------|-------------|
| Open | array | Open price array |
| High | array | High price array |
| Low | array | Low price array |
| Close | array | Close price array |
| Volume | array | Volume array |
| TradeVolume | array | Trade volume to estimate slippage for |
| TickSize | float | Minimum price increment |
| PointValue | float | Monetary value per point |
| liqCap | float | Liquidity capture parameter (typically 0.1) |
| options | float | Model selection (same as `sfIntradaySlippageEstimate`) |

**Returns:** array — Estimated slippage in monetary units.

---

## Utility Functions

### sfResetChrono

Reset the chrono.

**Syntax:** `sfResetChrono()`

**Returns:** float — Elapsed time in seconds (with sub-millisecond precision).

### sfGetChrono

Returns the number of seconds elapsed since the plug-in was loaded
or since the chrono was resetted. Precision is between 1 millisecond and 1 microsecond,
about a few dozen microseconds on modern systems.
Due to floating number storage capacity,
it's recommended to reset the chrono first when one needs to measure
an elapsed time during long sessions (a long time after software start).

**Syntax:** `sfGetChrono()`

**Returns:** float — Elapsed time in seconds (with sub-millisecond precision).

### sfUTF16ToAscii

This function converts a UTF‑16LE encoded string (stored in a char* buffer)
 into an ASCII string by removing diacritics and mapping Latin, Latin‑1,
 and Latin Extended‑A/B characters to their closest ASCII equivalents.
 It also handles UTF‑16 surrogate pairs and ignores combining marks,
 producing a clean, accent‑stripped ASCII output.

**Syntax:** `sfUTF16ToAscii(UTF16String)`

**Returns:** char * — Converted string in ASCII Extended.

### sfUnicodeToAscii

Converts a UTF‑8 or ANSI string into an ASCII string by removing diacritics
 and mapping accented Latin characters and typographic punctuation
  to their closest ASCII equivalents.
  Auto-detects UTF‑8 (via `MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS)`)
   and falls back to ANSI (CP_ACP) if UTF‑8 fails.

**Syntax:** `sfUnicodeToAscii(str)`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | UTF‑8 or ANSI encoded string |

**Returns:** string — The ASCII-converted string.

---

### sfRemoveGaps

Removes overnight price gaps from OHLC arrays in place, producing a
continuous price series. Detects new trading days via `TimeNum()` and
adjusts all five arrays so that `Open[i]` follows `Close[i-1]` without
a jump.

**Syntax:** `sfRemoveGaps( O, H, L, C, Avg )`

| Arg | Type | Description |
|-----|------|-------------|
| O | array | Open prices (modified in place) |
| H | array | High prices (modified in place) |
| L | array | Low prices (modified in place) |
| C | array | Close prices (modified in place) |
| Avg | array | Average price, recalculated as `(H+L+C)/3` (modified in place) |

**Returns:** Nothing — all arrays are modified in place.

**RemoveGaps Example:**

```afl
sfRemoveGaps(O, H, L, C, Avg);
// O, H, L, C, Avg are now gap-adjusted
```

---

### sfLimitJumps

Limits close-to-close jumps so that no jump exceeds the `BaseJump`
threshold. Works like `sfRemoveGaps` but instead of removing overnight
gaps, it caps any price jump (positive or negative) to a per-bar limit.
The excess is accumulated and subtracted from all subsequent bars,
keeping the series continuous.

**Syntax:** `sfLimitJumps( O, H, L, C, Avg, BaseJump )`

| Arg | Type | Description |
|-----|------|-------------|
| O | array | Open prices (modified in place) |
| H | array | High prices (modified in place) |
| L | array | Low prices (modified in place) |
| C | array | Close prices (modified in place) |
| Avg | array | Average price, recalculated as `(H+L+C)/3` (modified in place) |
| BaseJump | array | Per-bar threshold  |

if `|C[i] - C[i-1]|` exceeds `BaseJump[i]`, the excess is removed from this bar and all subsequent bars

**Returns:** Nothing — all arrays are modified in place.

**LimitJumps Example:**

```afl
// Limit any close-to-close jump to at most 2.0 points
base = 2.0 * Ones(C);
sfLimitJumps(O, H, L, C, Avg, base);
// O, H, L, C, Avg are now jump-limited
```

---

### sfFixSpikes

Caps High and Low so they never deviate more than `A` from the Open-Close
range. Useful for filtering momentary price spikes that exceed a
reasonable amplitude.

**Syntax:** `sfFixSpikes( O, H, L, C, A )`

| Arg | Type | Description |
|-----|------|-------------|
| O | array | Open prices (read) |
| H | array | High prices (modified in place) |
| L | array | Low prices (modified in place) |
| C | array | Close prices (read) |
| A | array | Per-bar maximum amplitude: `H` ≤ `Max(O,C) + A` and `L` ≥ `Min(O,C) − A` |

**Returns:** Nothing — H and L are modified in place.

**FixSpikes Example:**

```afl
// Spike threshold: 0.5 % of the Close
amp = 0.005 * C;
sfFixSpikes(O, H, L, C, amp);
```

---

### sfFixQuotes

Detects anomalous values in a time series and replaces them. A value is
considered anomalous when it deviates from the rolling mean by more than
`stdev` standard deviations over the preceding `window` bars.

**Syntax:** `sfFixQuotes( A, window, stdev, opt )`

| Arg | Type | Description |
|-----|------|-------------|
| A | array | Input time series |
| window | float | Rolling window for mean/standard‑deviation calculation |
| stdev | float | Number of standard deviations forming the threshold |
| opt | float | (optional) Filling method. Default: 0 |

| opt | Behavior |
|-----|----------|
| `0` | **Forward‑fill** — copy the last non‑anomalous value |
| `≥ 1` | **EMA** — fill with an exponential moving average of the last `opt` valid values |
| `< 0` | **Linear regression** — fill by extrapolating a line fitted to the last `−opt` valid values |

**Returns:** array — The cleaned series with anomalies replaced.

---

### sfMxSparseMatrix

Creates a `rows × cols` matrix where each cell has `density` probability
of being non‑zero.  Non‑zero values are drawn from a uniform distribution
on `[‑1, 1]`.  Internally builds a string and passes it to `MxFromString`.

**Syntax:** `sfMxSparseMatrix( rows, cols, density )`

| Arg | Type | Description |
|-----|------|-------------|
| rows | float | Number of rows |
| cols | float | Number of columns |
| density | float | Fraction of non‑zero cells (0.0 – 1.0) |

**Returns:** matrix — A 2‑D array of floats.

---

### sfBondQuoteToStr

Converts a floating‑point price to a US Treasury bond‑quote string in
32nds (with optional 256ths or `+` for a half‑32nd).

**Syntax:** `sfBondQuoteToStr( price [, sep ] )`

| Arg | Type | Description |
|-----|------|-------------|
| price | float | Numeric price (e.g. `101.125`) |
| sep | float / string | (optional) Separator character; default `'` (apostrophe) |

**Returns:** string — Bond‑quote representation.  Examples:
`101.125` → `"101'04"`, `99.515625` → `"99'16+"`, `100.0625` → `"100'02"`.

---

## Dialog Functions

Non‑blocking dialog boxes that run on a background thread, allowing the AFL engine to continue processing.

### sfSelectFile

Opens a Windows file‑open dialog **without blocking the AFL engine**.
The dialog runs on a background thread; the function returns immediately.

**Usage pattern (polling):**

```afl
file = SelectFile("C:\", "MyVar");
if (file != "") {
    // user selected a file, path is in "file" and also in StaticVarGetText("MyVar")
}
```

- **First call** in a scan/indicator: the dialog is opened, the function returns `Nothing`.
- **Subsequent calls** (next AFL recalc): if the user has selected a file, the path is stored
  via `StaticVarSetText` and returned as a string. Returns `Nothing` while the dialog is still open.

**Syntax:** `sfSelectFile( directory, varname )`

| Arg | Type | Description |
|-----|------|-------------|
| directory | string | Initial directory shown in the dialog |
| varname | string | Name of the AmiBroker static variable to store the selected path |

**Returns:** string — The selected file path, or `Nothing` if cancelled or still pending.

---

### sfSaveFile

Opens a Windows **Save As…** dialog **without blocking the AFL engine**.

**Syntax:** `sfSaveFile( directory, filename_hint )`

| Arg | Type | Description |
|-----|------|-------------|
| directory | string | Initial directory shown in the dialog |
| filename_hint | string | Default file name pre‑filled in the dialog |

**Returns:** string — The full chosen path, or empty string if cancelled or still pending.

---

### sfDialogYesNo

Displays a message box with **Yes / No** buttons, non‑blocking.

**Syntax:** `sfDialogYesNo( message, title )`

| Arg | Type | Description |
|-----|------|-------------|
| message | string | Text to display in the message box |
| title | string | Window title |

**Returns:** float — `1` if Yes was clicked, `0` if No, or `Nothing` while the dialog is still open.

---

### sfDialogOkCancel

Displays a message box with **OK / Cancel** buttons, non‑blocking.

**Syntax:** `sfDialogOkCancel( message, title )`

| Arg | Type | Description |
|-----|------|-------------|
| message | string | Text to display in the message box |
| title | string | Window title |

**Returns:** float — `1` if OK, `0` if Cancel, or `Nothing` while still pending.

---

### sfDialogOK

Displays an informational message box with a single **OK** button, non‑blocking.

**Syntax:** `sfDialogOK( message, title )`

| Arg | Type | Description |
|-----|------|-------------|
| message | string | Text to display in the message box |
| title | string | Window title |

**Returns:** float — `1` when the user clicks OK.

---

## WebSocket Functions

WebSocket client for real‑time communication with servers via the RFC 6455 protocol.
All functions are **non‑blocking** — the connection runs on a background thread
and data is exchanged via internal queues.

### sfWSConnect

Opens a WebSocket connection to a server. The connection is attempted
on a background thread; the function returns immediately.

**Syntax:** `sfWSConnect( url )`

| Arg | Type | Description |
|-----|------|-------------|
| url | string | WebSocket URL (`ws://host:port/path`). Default port: 80 |

**Returns:** float — A connection ID (to be used with other WS functions),
or `Nothing` if the connection could not be initiated.

**Note:** Use `sfWSGetStatus` to check when the connection is established.

---

### sfWSGetStatus

Returns the current status of a WebSocket connection.

**Syntax:** `sfWSGetStatus( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Connection ID returned by `sfWSConnect` |

**Returns:** float:

| Value | Meaning |
|-------|---------|
| 0 | Connecting (handshake in progress) |
| 1 | Open (connected and ready) |
| 2 | Closed (normal disconnect) |
| -1 | Error (connection failed) |

---

### sfWSSend

Enqueues a text message to be sent over the WebSocket connection.
The actual send happens asynchronously on the background thread.

**Syntax:** `sfWSSend( text, id )`

| Arg | Type | Description |
|-----|------|-------------|
| text | string | The message to send |
| id | float | Connection ID |

**Returns:** None

---

### sfWSReceive

Dequeues the oldest received message from the internal queue.
Messages are received asynchronously on the background thread.

**Syntax:** `sfWSReceive( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Connection ID |

**Returns:** string — The next received message, or `Nothing` if the queue is empty.

---

### sfWSClose

Closes the WebSocket connection, cleans up the background thread,
and frees all associated resources.

**Syntax:** `sfWSClose( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Connection ID to close |

**Returns:** None

---

### Example (AFL)

```afl
id = sfWSConnect("ws://localhost:8080/data");

// Wait for connection (polling loop)
for (i = 0; i < 50; i++) {
    status = sfWSGetStatus(id);
    if (status == 1) break;        // connected
    if (status == -1) return;       // error
    Sleep(100);
}

// Send a request
sfWSSend("{\"action\":\"getQuote\",\"symbol\":\"AAPL\"}", id);

// Read response (poll)
for (i = 0; i < 20; i++) {
    msg = sfWSReceive(id);
    if (msg != "") {
        // process msg
        break;
    }
    Sleep(100);
}

sfWSClose(id);
```

---

## Named Pipe Functions (IPC)

Named Pipes provide thread‑to‑thread communication on the same machine.
One side creates a server (`sfNPCreate`), the other connects (`sfNPConnect`).
Once connected, both sides send and receive text messages.

### sfNPCreate

Creates a Named Pipe server and waits for a client to connect on a background thread.

**Syntax:** `sfNPCreate( name )`

| Arg | Type | Description |
|-----|------|-------------|
| name | string | Unique pipe name (used by the client to connect) |

**Returns:** float — Pipe ID, or `Nothing` on failure.

---

### sfNPConnect

Connects as a client to an existing Named Pipe server.

**Syntax:** `sfNPConnect( name )`

| Arg | Type | Description |
|-----|------|-------------|
| name | string | Pipe name (must match the server's name) |

**Returns:** float — Pipe ID, or `Nothing` on failure.

---

### sfNPGetStatus

Returns the connection status.

**Syntax:** `sfNPGetStatus( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Pipe ID |

**Returns:** float — 0 = waiting for client (server) / connecting (client), 1 = connected, 2 = closed, -1 = error.

---

### sfNPSend

Enqueues a text message to send through the pipe.

**Syntax:** `sfNPSend( text, id )`

| Arg | Type | Description |
|-----|------|-------------|
| text | string | The message to send |
| id | float | Pipe ID |

**Returns:** None

---

### sfNPReceive

Dequeues the oldest received message.

**Syntax:** `sfNPReceive( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Pipe ID |

**Returns:** string — The message, or `Nothing` if the queue is empty.

---

### sfNPClose

Closes the pipe and cleans up the background thread.

**Syntax:** `sfNPClose( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Pipe ID to close |

**Returns:** None

---

### Example (AFL) for NP

**Server side** (AFL in one chart/script):

```afl
id = sfNPCreate("MyPipe");
// Wait for client
for (i = 0; i < 100; i++) {
    if (sfNPGetStatus(id) == 1) break;
    Sleep(100);
}

// Receive & echo
for (i = 0; i < 10; i++) {
    msg = sfNPReceive(id);
    if (msg != "") {
        sfNPSend("ECHO: " + msg, id);
    }
    Sleep(50);
}
sfNPClose(id);
```

**Client side** (AFL in another chart/script):

```afl
id = sfNPConnect("MyPipe");
// Wait for connection
for (i = 0; i < 50; i++) {
    if (sfNPGetStatus(id) == 1) break;
    Sleep(100);
}

sfNPSend("Hello from client!", id);

for (i = 0; i < 10; i++) {
    msg = sfNPReceive(id);
    if (msg != "") {
        // process msg
        break;
    }
    Sleep(50);
}
sfNPClose(id);
```

---

## OpenAI Functions (LLM)

Asynchronous LLM API calls via OpenAI‑compatible endpoints (e.g. OpenAI, Mistral).
Uses `libcurl` internally. All calls are non‑blocking — the HTTP request runs on a
background thread and the result is polled via `sfOpenAIGetAnswer`.

### sfOpenAIConfigure

Sets the API base URL, API key, and model for subsequent requests.

**Syntax:** `sfOpenAIConfigure( base_url, api_key, model )`

| Arg | Type | Description |
|-----|------|-------------|
| base_url | string | API endpoint URL (e.g. `https://api.openai.com/v1/` or `https://api.mistral.ai/v1/`) |
| api_key | string | API authentication key |
| model | string | Model identifier (e.g. `gpt-4o`, `mistral-small-latest`) |

**Returns:** None

**Note:** Must be called at least once before `sfOpenAIRequest`.

---

### sfOpenAIRequest

Sends a chat completion request with a single message on a background thread.

**Syntax:** `sfOpenAIRequest( role, content )`

| Arg | Type | Description |
|-----|------|-------------|
| role | string | Message role (e.g. `"user"`, `"system"`, `"assistant"`) |
| content | string | The message content / prompt |

**Returns:** float — A request ID (to be used with `sfOpenAIGetAnswer` / `sfOpenAIForget`),
or `Null` if no configuration was set.

**Example:**

```afl
id = sfOpenAIRequest("user", "What is the capital of France?");
```

---

### sfOpenAIGetAnswer

Checks whether the async request has completed and retrieves the response.

**Syntax:** `sfOpenAIGetAnswer( request_id )`

| Arg | Type | Description |
|-----|------|-------------|
| request_id | float | Request ID returned by `sfOpenAIRequest` |

**Returns:** string — The assistant's reply text, or `""` (empty string) if the request
is still pending. Returns `Null` if the request ID is invalid or if an error occurred.

**Polling pattern:**

```afl
id = sfOpenAIRequest("user", "Explain AI in one sentence.");
for (i = 0; i < 100; i++) {
    answer = sfOpenAIGetAnswer(id);
    if (answer != "") {
        // process answer
        break;
    }
    Sleep(100);
}
```

---

### sfOpenAIForget

Frees the resources associated with a completed (or abandoned) request.

**Syntax:** `sfOpenAIForget( request_id )`

| Arg | Type | Description |
|-----|------|-------------|
| request_id | float | Request ID to release |

**Returns:** None

---

### Complete AFL example

```afl
// Configure (call once)
sfOpenAIConfigure("https://api.mistral.ai/v1/", "your-key", "mistral-small-latest");

// Send request
reqId = sfOpenAIRequest("user", "What is the capital of France?");

// Poll for answer
answer = "";
for (i = 0; i < 50; i++) {
    answer = sfOpenAIGetAnswer(reqId);
    if (answer != "") break;
    Sleep(100);
}

// Print result
if (answer != "") {
    printf("Answer: %s\n", answer);
}

// Cleanup
sfOpenAIForget(reqId);
```

---

## Codec Functions

Encode/decode data in Base64 and MessagePack formats for interoperability with external services.

### sfBase64Encode

Encodes a string to Base64.

**Syntax:** `sfBase64Encode( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The string to encode |

**Returns:** string — The Base64-encoded string.

---

### sfBase64Decode

Decodes a Base64 string back to its original content.

**Syntax:** `sfBase64Decode( str )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The Base64-encoded string |

**Returns:** string — The decoded string.

---

### sfMPEncode

Encodes an AFL value to the MessagePack binary format.
Supports `VAR_NONE` → nil, `VAR_FLOAT` → float/int, `VAR_STRING` → str, `VAR_ARRAY` → array of floats.

**Syntax:** `sfMPEncode( value )`

| Arg | Type | Description |
|-----|------|-------------|
| value | AmiVar | The value to encode (float, string, or array) |

**Returns:** string — The MessagePack binary data as a string.

**Note:** Integer-valued floats (where `val == floor(val)` and within ±10¹⁵) are encoded as MessagePack integers for compactness; non‑integer floats use float64.

---

### sfMPDecode

Decodes a MessagePack binary string back to an AFL value.

**Syntax:** `sfMPDecode( binary_str )`

| Arg | Type | Description |
|-----|------|-------------|
| binary_str | string | MessagePack-encoded binary data |

**Returns:** AmiVar — Decoded value:

- nil → `Nothing`
- boolean → `Float(0.0)` / `Float(1.0)`
- integer / float → `Float(value)`
- string → `String(str)`
- array → `VarArray` of floats
- map → `Nothing` (keys/values consumed but not returned)
- binary → `Nothing` (data consumed but not returned)

The underlying `mp::` encoder provides primitives for the full MessagePack
specification, including `float32`, `bin` (8/16/32), and `map` (fixmap/map16/map32)
headers, even though `sfMPEncode` only emits nil, int, float64, str, and array.

---

### Example (Base64)

```afl
encoded = sfBase64Encode("Hello World");
// encoded == "SGVsbG8gV29ybGQ="

decoded = sfBase64Decode(encoded);
// decoded == "Hello World"
```

### Example (MessagePack)

```afl
mp = sfMPEncode(42.0);
val = sfMPDecode(mp);        // val == 42.0

mp = sfMPEncode("hello");
val = sfMPDecode(mp);        // val == "hello"
```

---

## CBOR Functions

[CBOR (RFC 8949)](https://cbor.io) is a binary data format like MessagePack,
designed for small code size and compact messages. This module uses
[nlohmann/json](https://github.com/nlohmann/json) internally and provides
both a simple codec interface (`sfCBOREncode`/`sfCBORDecode`) and a
full DOM-based API (analogous to the JSON module) for random access,
modification, and serialization.

**Note:** CBOR binary data is base64-encoded when passed as AFL strings
to avoid null-byte truncation issues. Use `sfBase64Encode`/`sfBase64Decode`
to convert to/from raw CBOR bytes for external communication.

### sfCBOREncode

Encodes an AFL value to CBOR format, returned as a base64 string.

**Syntax:** `sfCBOREncode( value )`

| Arg | Type | Description |
|-----|------|-------------|
| value | AmiVar | The value to encode (nil, float, string, or array) |

**Returns:** string — Base64-encoded CBOR data.

---

### sfCBORDecode

Decodes a base64-encoded CBOR string back to an AFL value.

**Syntax:** `sfCBORDecode( b64_str )`

| Arg | Type | Description |
|-----|------|-------------|
| b64_str | string | Base64-encoded CBOR data |

**Returns:** AmiVar — Decoded value (nil → `Nothing`, bool → `Float`, number → `Float`, string → `String`, array → `VarArray`).

---

### sfCBORParse

Parses a base64-encoded CBOR document and returns a store ID for subsequent
read/modify operations.

**Syntax:** `sfCBORParse( b64_str )`

| Arg | Type | Description |
|-----|------|-------------|
| b64_str | string | Base64-encoded CBOR document |

**Returns:** float — The store ID, or `Null` if parsing failed.

---

### sfCBORCreate

Creates a new empty CBOR document store.

**Syntax:** `sfCBORCreate()`

**Returns:** float — The store ID.

---

### sfCBORGet

Retrieves a value from a CBOR document by dot-separated path.

**Syntax:** `sfCBORGet( path, id )`

| Arg | Type | Description |
|-----|------|-------------|
| path | string | Dot-separated path (e.g. `"data.items.0.name"`) |
| id | float | Store ID returned by `sfCBORParse` or `sfCBORCreate` |

**Returns:** AmiVar — The value, or `Null` if not found.

---

### sfCBORSetString

Sets a string value in a CBOR document by dot-separated path.
Creates missing intermediate path segments by default.

**Syntax:** `sfCBORSetString( path, value, id, create_missing = 1 )`

| Arg | Type | Description |
|-----|------|-------------|
| path | string | Dot-separated path |
| value | string | The string value to set |
| id | float | Store ID |
| create_missing | float | (optional) If non-zero, create missing objects along the path. Default: 1 |

**Returns:** AmiVar — The set value, or `Null` on failure.

---

### sfCBORSetFloat

Sets a float value in a CBOR document by dot-separated path.
Creates missing intermediate path segments by default.

**Syntax:** `sfCBORSetFloat( path, value, id, create_missing = 1 )`

| Arg | Type | Description |
|-----|------|-------------|
| path | string | Dot-separated path |
| value | float | The float value to set |
| id | float | Store ID |
| create_missing | float | (optional) If non-zero, create missing objects along the path. Default: 1 |

**Returns:** AmiVar — The set value, or `Null` on failure.

---

### sfCBORDestroy

Destroys a CBOR document store and frees its memory.

**Syntax:** `sfCBORDestroy( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Store ID to destroy |

**Returns:** float — 1.0 on success, `Null` on failure.

---

### sfCBORToString

Serializes a CBOR document store to a JSON string for inspection.

**Syntax:** `sfCBORToString( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Store ID |

**Returns:** string — The JSON representation.

---

### sfCBORLoad

Loads a CBOR file from disk and returns a store ID.

**Syntax:** `sfCBORLoad( filename )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the CBOR file |

**Returns:** float — The store ID, or `Null` if loading/parsing fails.

---

### sfCBORSave

Saves a CBOR document store to a binary CBOR file.

**Syntax:** `sfCBORSave( id, filename )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Store ID |
| filename | string | Path to the output file |

**Returns:** float — 1.0 on success, `Null` on failure.

---

### Example (encode/decode)

```afl
// Encode AFL value to CBOR (base64 string)
cbor = sfCBOREncode(42.0);
val = sfCBORDecode(cbor);        // val == 42.0

cbor = sfCBOREncode("Hello");
val = sfCBORDecode(cbor);        // val == "Hello"

// Convert to/from raw CBOR for server communication
raw_cbor = sfBase64Decode(cbor); // raw CBOR bytes
sfWSSend(raw_cbor, ws_id);
```

### Example (DOM API)

```afl
// Create and build a document
id = sfCBORCreate();
sfCBORSetString("name", "Alice", id);
sfCBORSetFloat("age", 30, id);
sfCBORSetString("address.city", "Paris", id);

// Read values
name = sfCBORGet("name", id);          // "Alice"
age = sfCBORGet("age", id);            // 30.0
city = sfCBORGet("address.city", id);  // "Paris"

sfCBORDestroy(id);
```

---

### sfWSSendCBOR

Sends a CBOR document store as a binary WebSocket frame (opcode `0x2`).
Use this instead of `sfCBOREncode` + `sfWSSend` to avoid the `VAR_STRING`
null-byte limitation: the CBOR is serialized directly to raw bytes in C++
and sent as a binary frame.

**Syntax:** `sfWSSendCBOR( cbor_id, ws_id )`

| Arg | Type | Description |
|-----|------|-------------|
| cbor_id | float | CBOR store ID (from `sfCBORCreate` or `sfCBORParse`) |
| ws_id | float | WebSocket client ID (from `sfWSConnect`) |

**Returns:** AmiVar — `Nothing` on success, `Null` if invalid ID or
serialization fails.

**Example:**

```afl
cbor_id = sfCBORCreate();
sfCBORSetString("action", "ping", cbor_id);
sfWSSendCBOR(cbor_id, ws_id);
sfCBORDestroy(cbor_id);
```

---

## Binary Functions

Binary encoding converts raw bytes into a printable ASCII string where each byte is represented by two characters: `'a' + (high nibble)` and `'a' + (low nibble)`. This "Bin str" format is safe for AFL string storage and can be persisted, transmitted, or embedded in formulas.

All functions return `Null()` on invalid input (odd-length bin string, out-of-bounds access, unsupported size, I/O failure).

### sfBinFromString

Converts a raw AFL string into a binary-encoded string.

**Syntax:** `sfBinFromString( str [, maxlen ] )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | Raw string to encode |
| maxlen | float | Optional — pad or truncate to this many bytes (default: strlen(str)) |

**Returns:** string — The binary-encoded representation (2×maxlen characters).

**Note:** If `maxlen > strlen(str)` the extra bytes are zero-filled. If `maxlen < strlen(str)` the string is truncated.

---

### sfBinFromFloat

Encodes a float as a binary string with the given byte size.

**Syntax:** `sfBinFromFloat( val, size )`

| Arg | Type | Description |
|-----|------|-------------|
| val | float | Value to encode |
| size | float | Byte size — `1` (int8), `2` (int16), `4` (float32), `8` (float64) |

**Returns:** string — Binary-encoded value.

**Note:** Sizes 1-2 truncate to integer. Unsupported sizes return `Null`.

---

### sfBinFromInt

Encodes an integer as a binary string with the given byte size.

**Syntax:** `sfBinFromInt( val, size )`

| Arg | Type | Description |
|-----|------|-------------|
| val | float | Integer value to encode |
| size | float | Byte size — `1` (int8), `2` (int16), `4` (int32), `8` (int64) |

**Returns:** string — Binary-encoded value.

**Note:** Values are clamped to the target integer range. Unsupported sizes return `Null`.

---

### sfBinFromBool

Encodes a boolean as a 1-byte binary string.

**Syntax:** `sfBinFromBool( val )`

| Arg | Type | Description |
|-----|------|-------------|
| val | float | Non-zero = true, zero = false |

**Returns:** string — 2-character bin string (`0x01` or `0x00`).

---

### sfBinToString

Decodes a binary-encoded string back to a raw AFL string.

**Syntax:** `sfBinToString( bin )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Binary-encoded string (even length) |

**Returns:** string — Decoded raw string.

**Note:** Returns `Null` for odd-length or empty input.

---

### sfBinToFloat

Decodes a binary string to a float, auto-detecting the byte size from the encoded length.

**Syntax:** `sfBinToFloat( bin )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Binary-encoded value (1, 2, 4, or 8 bytes) |

**Returns:** float — Decoded value.

**Note:** Sizes 1-2 decode as signed integers. Size 4 decodes as IEEE 754 float32; size 8 as float64 (converted to float). Returns `Null` for unsupported sizes.

---

### sfBinToInt

Decodes a binary string to an integer, auto-detecting the byte size from the encoded length.

**Syntax:** `sfBinToInt( bin )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Binary-encoded value (1, 2, 4, or 8 bytes) |

**Returns:** float — Decoded integer as float.

**Note:** Returns `Null` for unsupported sizes or empty input.

---

### sfBinToBool

Decodes a binary string to a boolean (non-zero = true).

**Syntax:** `sfBinToBool( bin )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Binary-encoded value (any length) |

**Returns:** float — `1.0` if the first byte is non-zero, `0.0` otherwise.

---

### sfBinExtract

Extracts a sub-region from a binary string, optionally converting the extracted bytes.

**Syntax:** `sfBinExtract( bin, from, count [, type ] )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Source binary string |
| from | float | Zero-based byte offset |
| count | float | Number of bytes to extract |
| type | float | Output type — `0` = bin string (default), `1` = bool, `2` = int, `3` = float, `4` = raw string |

**Returns:** string or float — Depends on `type`.

**Note:** `from` and `count` are in bytes (not bin-string characters). `from + count` must not exceed the total byte length. Returns `Null` on out-of-bounds. Type conversions (2–3) follow the same size rules as `BinToInt`/`BinToFloat`.

---

### sfBinInsert

Inserts a binary string into another at a given byte position.

**Syntax:** `sfBinInsert( bin, sub, pos )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Destination binary string |
| sub | string | Binary string to insert |
| pos | float | Byte position (negative = append at end) |

**Returns:** string — New binary string with `sub` inserted.

**Note:** `pos` is clamped to `[0, len(bin)]`. If `pos = -1` the sub-string is appended at the end.

---

### sfBinReplace

Replaces bytes in a binary string with another binary string starting at a given position.

**Syntax:** `sfBinReplace( bin, sub, pos )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Source binary string |
| sub | string | Replacement binary string |
| pos | float | Byte position to start replacement |

**Returns:** string — New binary string with the region replaced.

**Note:** If `pos + len(sub) > len(bin)`, the output is extended to accommodate the replacement. `pos` is clamped to `[0, len(bin)]`.

---

### sfBinLoad

Reads a file from disk and returns its contents as a binary-encoded string.

**Syntax:** `sfBinLoad( filename )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the file |

**Returns:** string — Binary-encoded file contents.

**Note:** Returns `Null` if the file cannot be opened, is empty, or a read error occurs.

---

### sfBinSave

Writes a binary-encoded string to disk (raw bytes, not the encoded representation).

**Syntax:** `sfBinSave( bin, filename [, mode ] )`

| Arg | Type | Description |
|-----|------|-------------|
| bin | string | Binary-encoded data |
| filename | string | Output file path |
| mode | float | `0` = write (default), `1` = append |

**Returns:** Nothing.

---

### Example

```afl
// Encode a string to binary and back
bin = sfBinFromString("Hello");
back = sfBinToString(bin);
// back == "Hello"

// Encode/decode a float
bin = sfBinFromFloat(3.14159, 4);
val = sfBinToFloat(bin);
// val ≈ 3.14159

// Store integers compactly
bin = sfBinFromInt(42000, 2);    // 2 bytes
val = sfBinToInt(bin);            // val == 42000.0

// Extract a sub-region
bin = sfBinFromString("Hello World");
sub = sfBinExtract(bin, 0, 5, 4); // raw string "Hello"

// Insert at end
bin = sfBinFromString("abc");
sub = sfBinFromString("xyz");
result = sfBinInsert(bin, sub, -1);
// result encodes "abcxyz"

// Load/save files
data = sfBinLoad("image.bin");    // file → bin string
sfBinSave(data, "copy.bin");       // bin string → file
```

## CSV Functions

DOM-based CSV parsing and manipulation. Load or parse a CSV string into an
object identified by a numeric ID, then read/write cells, append rows/columns,
extract subtables, and save back to disk. Uses comma as the default delimiter.

All functions return `Null` on error (invalid ID, out of bounds, I/O failure).

### sfCSVParse

Parses a raw CSV string and returns a CSV object ID.

**Syntax:** `sfCSVParse( csv_data )`

| Arg | Type | Description |
|-----|------|-------------|
| csv_data | string | The raw CSV string to parse |

**Returns:** float — The CSV object ID.

---

### sfCSVLoad

Loads a CSV file from disk and returns a CSV object ID.

**Syntax:** `sfCSVLoad( filename )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the CSV file |

**Returns:** float — The CSV object ID.

---

### sfCSVDestroy

Destroys a CSV object and frees its memory.

**Syntax:** `sfCSVDestroy( csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| csv_id | float | CSV object ID to destroy |

**Returns:** Nothing

---

### sfCSVGetCell

Retrieves the value of a cell at the given row and column.

**Syntax:** `sfCSVGetCell( row, col, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| row | float | Row index (0-based) |
| col | float | Column index (0-based) |
| csv_id | float | CSV object ID |

**Returns:** string — The cell value.

---

### sfCSVSetCell

Sets the value of a cell at the given row and column.

**Syntax:** `sfCSVSetCell( value, row, col, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| value | string | New cell value |
| row | float | Row index (0-based) |
| col | float | Column index (0-based) |
| csv_id | float | CSV object ID |

**Returns:** Nothing

---

### sfCSVGetNumRows

Returns the number of rows in the CSV object.

**Syntax:** `sfCSVGetNumRows( csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| csv_id | float | CSV object ID |

**Returns:** float — Row count.

---

### sfCSVGetNumCols

Returns the number of columns in the CSV object.

**Syntax:** `sfCSVGetNumCols( csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| csv_id | float | CSV object ID |

**Returns:** float — Column count.

---

### sfCSVAppendRow

Appends a new row by parsing a delimiter-separated string.

**Syntax:** `sfCSVAppendRow( row_str, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| row_str | string | Delimiter-separated cell values (e.g. `"a,b,c"`) |
| csv_id | float | CSV object ID |

**Returns:** float — The new total number of rows.

---

### sfCSVAppendCol

Appends a new column from a newline-separated string or a float array.
Duplicate of `sfCSVAppendColStr` / `sfCSVAppendColArray` but auto-detects
the input type.

**Syntax:** `sfCSVAppendCol( data, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| data | string or array | Newline-separated string of cell values, or float array |
| csv_id | float | CSV object ID |

**Returns:** float — The new total number of columns.

---

### sfCSVAppendColStr

Appends a new column from a newline-separated string.

**Syntax:** `sfCSVAppendColStr( col_str, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| col_str | string | Newline-separated column values |
| csv_id | float | CSV object ID |

**Returns:** float — The new total number of columns.

---

### sfCSVAppendColArray

Appends a new column from a float array.

**Syntax:** `sfCSVAppendColArray( col_array, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| col_array | array | Float array to convert and append as a new column |
| csv_id | float | CSV object ID |

**Returns:** float — The new total number of columns.

---

### sfCSVRemoveRow

Removes a row by index.

**Syntax:** `sfCSVRemoveRow( row, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| row | float | Row index to remove (0-based) |
| csv_id | float | CSV object ID |

**Returns:** float — The new total number of rows.

---

### sfCSVRemoveCol

Removes a column by index.

**Syntax:** `sfCSVRemoveCol( col, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| col | float | Column index to remove (0-based) |
| csv_id | float | CSV object ID |

**Returns:** float — The new total number of columns.

---

### sfCSVExtractSubtable

Extracts a rectangular region of the CSV as a new CSV object.

**Syntax:** `sfCSVExtractSubtable( start_row, end_row, start_col, end_col, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| start_row | float | Starting row index (0-based) |
| end_row | float | Ending row index (inclusive, -1 for last) |
| start_col | float | Starting column index (0-based) |
| end_col | float | Ending column index (inclusive, -1 for last) |
| csv_id | float | Source CSV object ID |

**Returns:** float — The new CSV subtable ID.

---

### sfCSVExtractSubtableWithMask

Extracts rows and selected columns (by mask) as a new CSV object.

**Syntax:** `sfCSVExtractSubtableWithMask( start_row, end_row, col_mask, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| start_row | float | Starting row index (0-based) |
| end_row | float | Ending row index (inclusive, -1 for last) |
| col_mask | string | Comma-separated list of column indices (e.g. `"0,2,4"`) |
| csv_id | float | Source CSV object ID |

**Returns:** float — The new CSV subtable ID.

---

### sfCSVExtractCol

Extracts a single column as a float array.

**Syntax:** `sfCSVExtractCol( col, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| col | float | Column index (0-based) |
| csv_id | float | CSV object ID |

**Returns:** array — Float array of column values.

---

### sfCSVExtractCols

Extracts selected columns (by mask, all rows) as a new CSV object.

**Syntax:** `sfCSVExtractCols( col_mask, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| col_mask | string | Comma-separated list of column indices (e.g. `"0,2,4"`) |
| csv_id | float | Source CSV object ID |

**Returns:** float — The new CSV subtable ID.

---

### sfCSVSetDelimiter

Changes the delimiter character used for parsing row strings and saving.

**Syntax:** `sfCSVSetDelimiter( delim, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| delim | string | First character is used as the new delimiter |
| csv_id | float | CSV object ID |

**Returns:** Nothing

---

### sfCSVGetDelimiter

Returns the current delimiter character.

**Syntax:** `sfCSVGetDelimiter( csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| csv_id | float | CSV object ID |

**Returns:** string — The delimiter character.

---

### sfCSVSave

Saves the CSV object to a file on disk.

**Syntax:** `sfCSVSave( filename, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the output file |
| csv_id | float | CSV object ID |

**Returns:** Nothing

---

### sfCSVLoadAndAppend

Loads a CSV file and appends its rows to an existing CSV object.

**Syntax:** `sfCSVLoadAndAppend( filename, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the CSV file to load |
| csv_id | float | Target CSV object ID |

**Returns:** float — The new total number of rows.

---

### sfCSVAppendToFile

Appends the CSV object's content to an existing file.

**Syntax:** `sfCSVAppendToFile( filename, csv_id )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Path to the file to append to |
| csv_id | float | CSV object ID |

**Returns:** Nothing

---

### Example

```afl
// Parse a CSV string
csv = sfCSVParse("name,age,city\nAlice,30,Paris\nBob,25,Lyon");

// Read values
name = sfCSVGetCell(0, 0, csv);   // "Alice"
age  = sfCSVGetCell(0, 1, csv);   // "30"

// Modify a cell
sfCSVSetCell("31", 0, 1, csv);

// Append a row
sfCSVAppendRow("Charlie,35,Nice", csv);

// Get dimensions
rows = sfCSVGetNumRows(csv);      // 3
cols = sfCSVGetNumCols(csv);      // 3

// Extract a subtable (rows 1-2, cols 0-1)
sub = sfCSVExtractSubtable(1, 2, 0, 1, csv);

// Extract column as array
ages = sfCSVExtractCol(1, csv);   // [31, 25, 35]

// Save to disk
sfCSVSave("output.csv", csv);

// Cleanup
sfCSVDestroy(csv);
sfCSVDestroy(sub);
```

---

## Record Functions

Heterogeneous vector — a fixed-size list of `AmiVar` values (float, string,
or none). Created via `sfRecordCreate`, accessed by index, and destroyed
via `sfRecordDestroy`.

Internally, `VAR_STRING` values are deep-copied so that the vector owns its
own memory. `VAR_FLOAT` and `VAR_NONE` are stored inline. All functions
return `Null` on invalid input (bad handle, out-of-bounds).

### sfRecordCreate

Creates a new vector with the given number of elements, all initialized
to `Null`.

**Syntax:** `sfRecordCreate( length )`

| Arg | Type | Description |
|-----|------|-------------|
| length | float | Number of elements in the vector |

**Returns:** string — An opaque handle to the vector.

---

### sfRecordGet

Reads the value at a given index.

**Syntax:** `sfRecordGet( handle, index )`

| Arg | Type | Description |
|-----|------|-------------|
| handle | string | Vector handle returned by `sfRecordCreate` |
| index | float | Zero-based element index |

**Returns:** AmiVar — The value (float, string, or none).

---

### sfRecordSetString

Sets the string value at a given index and returns the previous value.

**Syntax:** `sfRecordSet( handle, value, index )`

| Arg | Type | Description |
|-----|------|-------------|
| handle | string | Vector handle |
| value | AmiVar | The new value (float or string) |
| index | float | Zero-based element index |

**Returns:** AmiVar — The previous value at that index, or `Null` if the
slot was empty.

**Note:** Strings are deep-copied; the vector owns its own copy.

---

### sfRecordSetFloat

Sets the float value at a given index and returns the previous value.

**Syntax:** `sfRecordSetFloat( handle, value, index )`

| Arg | Type | Description |
|-----|------|-------------|
| handle | string | Vector handle |
| value | AmiVar | The new value (float or string) |
| index | float | Zero-based element index |

**Returns:** AmiVar — The previous value at that index, or `Null` if the
slot was empty.

---

### sfRecordSetArray

Sets the array value at a given index and returns the previous value.

**Syntax:** `sfRecordSetArray( value, handle, index )`

| Arg | Type | Description |
|-----|------|-------------|
| value | AmiVar | The new value (float or string) |
| handle | string | Vector handle |
| index | float | Zero-based element index |

**Returns:** AmiVar — The previous value at that index, or `Null` if the
slot was empty.

**Note:** Arrays are not deep-copied; the vector does not own a copy.
Contrary to other 'Set' functions, the handle is not the first argument but the second.

---

### sfRecordClear

Clears all elements of the vector (frees owned strings, resets to `Null`).

**Syntax:** `sfRecordClear( handle )`

| Arg | Type | Description |
|-----|------|-------------|
| handle | string | Vector handle |

**Returns:** None

---

### sfRecordDestroy

Destroys the vector and frees all associated memory.

**Syntax:** `sfRecordDestroy( handle )`

| Arg | Type | Description |
|-----|------|-------------|
| handle | string | Vector handle to destroy |

**Returns:** Nothing

---

### Vector Example

```afl
// Create a vector of 3 elements
v = sfRecordCreate(3);

// Set values
old = sfRecordSetString(v, "hello", 0);
old = sfRecordSetFloat(v, 42.5, 1);

// Read back
s = sfRecordGet(v, 0);   // "hello"
n = sfRecordGet(v, 1);   // 42.5
e = sfRecordGet(v, 2);   // null (IsNull(e) == 1)

// Cleanup
sfRecordDestroy(v);
```

---

## Store Functions

Key-value store — a map of named `AmiVar` values (float, string, or null),
identified by a unique numeric ID. Created via `StoreCreate`, accessed
by key, and destroyed via `StoreDestroy`.

All functions return `Null` on invalid input (bad handle).

### StoreCreate

Creates a new empty store.

**Syntax:** `StoreCreate( size )`

| Arg | Type | Description |
|-----|------|-------------|
| size | float | Ignored (reserved for future use) |

**Returns:** float — The store ID.

---

### StoreDestroy

Destroys a store and frees all associated memory.

**Syntax:** `StoreDestroy( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Store ID to destroy |

**Returns:** Nothing

---

### StoreSize

Returns the number of key-value pairs in the store.

**Syntax:** `StoreSize( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Store ID |

**Returns:** float — The number of entries.

---

### StoreGet

Retrieves the value at a given key.

**Syntax:** `StoreGet( key, id )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | The key to look up |
| id | float | Store ID |

**Returns:** AmiVar — The value (float, string, or null if not found).

---

### StoreSet

Sets the value at a given key and returns the old value.
If the key does not exist, it is created and `Null` is returned.

**Syntax:** `StoreSet( key, value, id )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | The key to set |
| value | AmiVar | The new value (float or string) |
| id | float | Store ID |

**Returns:** AmiVar — The previous value, or null if the key was created.

---

### StorePush

Sets the value at a given key and returns the old value.
If the key does not exist, it is created and `Nothing` is returned.

**Syntax:** `StorePush( key, value, id )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | The key to set |
| value | AmiVar | The new value |
| id | float | Store ID |

**Returns:** AmiVar — The previous value, or nothing if the key was created.

---

### StorePushFloat

Alias for `StorePush` with a float value.

**Syntax:** `StorePushFloat( key, value, id )`

---

### StorePushString

Alias for `StorePush` with a string value.

**Syntax:** `StorePushString( key, value, id )`

---

### StoreRemove

Removes the value at the given key and returns it.

**Syntax:** `StoreRemove( key, id )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | The key to remove |
| id | float | Store ID |

**Returns:** AmiVar — The removed value, or null if the key did not exist.

---

### StoreClear

Removes all key-value pairs from the store.

**Syntax:** `StoreClear( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Store ID |

**Returns:** Nothing

---

### StoreExists

Checks whether a given key exists in the store.

**Syntax:** `StoreExists( key, id )`

| Arg | Type | Description |
|-----|------|-------------|
| key | string | The key to check |
| id | float | Store ID |

**Returns:** float — `1` if the key exists, `0` otherwise.

---

### StoreToString

Serializes the store to a JSON-like string.

**Syntax:** `StoreToString( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | Store ID |

**Returns:** string — e.g. `{"age":30,"name":"hello"}`.

---

### StoreFromString

Parses a JSON-like string into the store. If `id` is `-1`, a new store is
created. If `id` is a valid store ID, the existing store is cleared and
reloaded.

**Syntax:** `StoreFromString( str, id )`

| Arg | Type | Description |
|-----|------|-------------|
| str | string | The JSON-like string to parse |
| id | float | Store ID (or `-1` to create new) |

**Returns:** float — The store ID, or null if parsing fails.

---

### Store Example

```afl
// Create a store
s = StoreCreate(0);

// Load data from string
StoreFromString("{\"name\":\"AAPL\",\"price\":150.25,\"active\":null}", s);

// Read values
name = StoreGet("name", s);    // "AAPL"
price = StoreGet("price", s);  // 150.25
active = StoreGet("active", s); // null (IsNull(active) == 1)

// Check if a key exists
exists = StoreExists("price", s); // 1
exists = StoreExists("volume", s); // 0

// Set creates the key if it doesn't exist
old = StoreSet("volume", 1000000, s); // Null (key was created)
old = StoreSet("price", 151.00, s);   // 150.25 (old value)

// Push also creates keys and returns old value
old = StorePush("sector", "Technology", s); // Nothing (key was created)
old = StorePush("price", 152.00, s);        // 151.00 (old value)

// Remove a key
removed = StoreRemove("active", s);

// Clear all
StoreClear(s);

// Destroy
StoreDestroy(s);
```

---



Statistical functions that operate on multiple arrays.

### sfMedianArrays

Computes the median of values from multiple AFL arrays, bar by bar.
The arrays are accessed by name using the pattern `prefix` + number
(e.g. `prefix1`, `prefix2`, …).

For bars where all input values are empty, the result is `Empty`.
For an even number of non-empty values, the average of the two middle
values is returned.

**Syntax:** `sfMedianArrays( prefix, count )`

| Arg | Type | Description |
|-----|------|-------------|
| prefix | string | Base name of the AFL arrays (e.g. `"MyArray"` for arrays `MyArray1`, `MyArray2`, …) |
| count | float | Number of arrays to read (1‑based). Must be ≥ 1 |

**Returns:** array — Median of the input values at each bar.

**Example:**

```afl
// Assume MyArray1, MyArray2, MyArray3 exist
Med = sfMedianArrays( "MyArray", 3 );
```

---

### sfMedianArray2

Optimized median of exactly 2 arrays. For each bar, returns the average
of the two values, or the single non-empty value if one is empty,
or `Empty` if both are empty.

**Syntax:** `sfMedianArray2( Array1, Array2 )`

| Arg | Type | Description |
|-----|------|-------------|
| Array1 | array | First input array |
| Array2 | array | Second input array |

**Returns:** array — Bar-by-bar median of the two arrays.

---

### sfMedianArray4

Optimized median of exactly 4 arrays.

**Syntax:** `sfMedianArray4( Array1, Array2, Array3, Array4 )`

| Arg | Type | Description |
|-----|------|-------------|
| Array1‑Array4 | array | Four input arrays |

**Returns:** array — Bar-by-bar median. For an even number of non-empty
values at a bar, the average of the two middle values is returned.

---

### sfMedianArray6

Optimized median of exactly 6 arrays.

**Syntax:** `sfMedianArray6( Array1, Array2, Array3, Array4, Array5, Array6 )`

| Arg | Type | Description |
|-----|------|-------------|
| Array1‑Array6 | array | Six input arrays |

**Returns:** array — Bar-by-bar median.

---

### sfPeriodicStat

Computes a sliding-window statistic (mean, cumulative sum, or median)
per period group. Each bar belongs to a group indicated by `PeriodNumber`
(e.g. day of week 1–7, month 1–12, etc.). A separate sliding window of
the last `n` values is maintained for each unique period number, and the
chosen statistic is computed over that window.

**Syntax:** `sfPeriodicStat( Values, PeriodNumber, n, type )`

| Arg | Type | Description |
|-----|------|-------------|
| Values | array | The input values |
| PeriodNumber | array | Period identifier for each bar (e.g. `DayOfWeek()`, `Month()`) |
| n | float | (optional) Sliding window size. Default: 20 |
| type | float | (optional) Statistic type: 0 = mean, 1 = sum (cumul), 2 = median. Default: 0 |

**Returns:** array — The per-bar statistic for the group to which each bar
belongs.

**Example:**

```afl
// Average volume for each weekday over the last 20 weeks
AvgVol = sfPeriodicStat( Volume, DayOfWeek(), 20, 0 );
```

The first bar of each period group returns the average/sum/median of
all values encountered so far (results are valid from the first occurrence).

---

### sfRegularize

Fills gaps (`Empty` values) in a time series array to produce a
regularized (gap‑free) series.

**Syntax:** `sfRegularize( A, opt )`

| Arg | Type | Description |
|-----|------|-------------|
| A | array | Input time series (may contain `Empty` gaps) |
| opt | float | (optional) Filling method. Default: 0 |

| opt | Behavior |
|-----|----------|
| `0` | **Forward‑fill** — copy the last valid value forward |
| `≥ 1` | **EMA** — fill with an exponential moving average of the last `opt` valid values (α = 2/(opt+1)) |
| `−1` | **Median‑2** — fill with the median (average) of the two most recent valid values |
| `< −1` | **Linear regression** — fill by extrapolating a straight line fitted to the last `−opt` valid values |

**Returns:** array — The regularized series (same length as input).

**Notes:**

- All filling methods require at least one prior valid value; bars before
  the first valid value remain `Empty`.
- For `opt ≥ 1`, the minimum effective period is 2.
- For `opt < −1`, regression requires at least 2 valid points.

---

### sfFirstValue

Returns the first non‑`Empty` value in the array.

**Syntax:** `sfFirstValue( A )`

| Arg | Type | Description |
|-----|------|-------------|
| A | array | Input array |

**Returns:** float — The first valid value, or 0 if all values are empty.

---

### sfDiff

Computes successive differences between array values. The first valid bar
is set to 0. For `opt > 1`, computes `A[n] − A[n − opt]`.

**Syntax:** `sfDiff( A, opt )`

| Arg | Type | Description |
|-----|------|-------------|
| A | array | Input array |
| opt | float | (optional) Lag. Default: 1 (consecutive bars) |

**Returns:** array — Differences. `Empty` where either value is missing.

---

## Table Functions

Functions for creating and manipulating 2D tables (rows and columns of
mixed-type values), identified by a unique numeric ID.

### sfTableCreate

Creates a new table.

**Syntax:** `sfTableCreate( index_col, order, width )`

| Arg | Type | Description |
|-----|------|-------------|
| index_col | float | (optional) Column index to use as key for sorted inserts. Default: −1 (no index) |
| order | float | (optional) 1 = maintain rows in sorted order by `index_col`. Default: 0 |
| width | float | (optional) Initial column count. Default: 0 |

**Returns:** float — The table ID.

### sfTableDestroy

Destroys a table and frees all memory.

**Syntax:** `sfTableDestroy( tab )`

| Arg | Type | Description |
|-----|------|-------------|
| tab | float | Table ID |

### sfTableLength

Returns the number of rows.

**Syntax:** `sfTableLength( tab )`

### sfTableWidth

Returns the number of columns.

**Syntax:** `sfTableWidth( tab )`

### sfTableGet

Gets the value at a given row and column.

**Syntax:** `sfTableGet( row_index, col_index, tab )`

| Arg | Type | Description |
|-----|------|-------------|
| row_index | float | Row index (0‑based) |
| col_index | float | Column index |
| tab | float | Table ID |

**Returns:** AmiVar — The value at that cell (float, string, or none if out of range).

### sfTableSetFloat

Sets a float value at a given row and column.

**Syntax:** `sfTableSetFloat( value, row_index, col_index, tab )`

### sfTableSetString

Sets a string value at a given row and column.

**Syntax:** `sfTableSetString( str, row_index, col_index, tab )`

### sfTableAppendRowStr

Appends a new row at the end, parsing values from a delimited string.

**Syntax:** `sfTableAppendRowStr( row_str, separator, tab )`

| Arg | Type | Description |
|-----|------|-------------|
| row_str | string | Delimited string of field values |
| separator | float | ASCII code of the field separator character |
| tab | float | Table ID |

Fields are parsed as numbers if possible, otherwise stored as strings.

### sfTableInsertRowStr

Inserts a row at the position indicated by `key_val` in `column_index`.
If the key already exists the row is updated; otherwise it is inserted
in sorted order (if the table was created with `order=1`) or appended.

**Syntax:** `sfTableInsertRowStr( row_str, key_val, column_index, separator, tab )`

### sfTableRemoveRow

Removes a row by index.

**Syntax:** `sfTableRemoveRow( row_index, tab )`

### sfTableClearRow

Clears all cells in a row (sets them to `VAR_NONE`).

**Syntax:** `sfTableClearRow( row_index, tab )`

### sfTableFindRow

Finds the first row where `column_index` equals `key`.
Returns the 0‑based row index, or −1 if not found.

**Syntax:** `sfTableFindRow( key, column_index, tab )`

### sfTableAvgColumn

Returns the average of all float values in a column.

**Syntax:** `sfTableAvgColumn( col_index, tab )`

### sfTableCumColumn

Returns the sum of all float values in a column.

**Syntax:** `sfTableCumColumn( col_index, tab )`

### sfTableSort

Sorts all rows in ascending order by the values in the specified column.
Non‑float rows are treated as very large values and sort to the end.

**Syntax:** `sfTableSort( column, tab )`

### sfTableRowToString

Converts a row to a delimited string.

**Syntax:** `sfTableRowToString( row_index, separator, tab )`

### sfTableColumnToString

Converts a column to a delimited string.

**Syntax:** `sfTableColumnToString( col_index, separator, tab )`

### sfTableColumnToArray

Converts a column to an AFL array. Rows beyond the current chart size are
omitted.

**Syntax:** `sfTableColumnToArray( col_index, tab )`

**Returns:** array — Float array of column values (or `Empty` for string rows).

### sfTableToMatrix

Converts the entire table to a string in matrix format: rows separated by
newline (`\n`), columns separated by comma.

**Syntax:** `sfTableToMatrix( tab )`

**Returns:** string — Matrix representation of the table.

### sfTableColumnFromString

Parses existing string values in a column to floats. The `separator`
character is treated as the decimal point (e.g. `,` for European locale
where `"123,45"` → `123.45`). Non‑string cells are left unchanged;
strings that cannot be parsed become 0.

**Syntax:** `sfTableColumnFromString( col_index, separator, tab )`

---

## Position Functions

Backtesting‑oriented functions for signal management, position sizing, equity‑curve computation, and margin estimation.

### sfRemoveExcessSignals

Limits the number of simultaneous BUY, SELL, SHORT and COVER signals so that
the cumulative position never exceeds `max` lots.  Modifies the input arrays
in place.

**Syntax:** `sfRemoveExcessSignals( Buy, Sell, Short, Cover, max )`

| Arg | Type | Description |
|-----|------|-------------|
| Buy | array | BUY signals (modified in place) |
| Sell | array | SELL signals (modified in place) |
| Short | array | SHORT signals (modified in place) |
| Cover | array | COVER signals (modified in place) |
| max | float | Maximum number of simultaneous positions |

**Returns:** Nothing.

---

### sfRestrictSignals

Removes or modifies signals based on a `Restriction` array. Values:
`1` = everything allowed, `0` = close any open positions,
`2` = hold existing but prevent new entries.  Modifies original arrays.

**Syntax:** `sfRestrictSignals( Buy, Sell, Short, Cover, Size, Restriction )`

| Arg | Type | Description |
|-----|------|-------------|
| Buy | array | BUY signals (modified) |
| Sell | array | SELL signals (modified) |
| Short | array | SHORT signals (modified) |
| Cover | array | COVER signals (modified) |
| Size | array | Position size at signal time (modified) |
| Restriction | array | Per‑bar restriction (1 / 0 / 2) |

**Returns:** Nothing.

---

### sfRestrictPosition

Returns a new position array with positions restricted per a `Restriction`
array.  Values: `1` = pass through, `0` = close to zero,
`2` = hold current size, no new entries.

**Syntax:** `sfRestrictPosition( Position, Restriction )`

| Arg | Type | Description |
|-----|------|-------------|
| Position | array | Position sizes (input) |
| Restriction | array | Per‑bar restriction (1 / 0 / 2) |

**Returns:** array — Restricted position sizes.

---

### sfPositionFromSignals

Computes the theoretical position size from BUY, SELL, SHORT, COVER signals
and a lot‑size array.  Assumes excess signals have already been removed.
`opt = 1` shifts the size by one bar (buy/sell next bar at open);
`opt = 0` applies same bar (buy/sell at close).

**Syntax:** `sfPositionFromSignals( Buy, Sell, Short, Cover, Size, opt )`

| Arg | Type | Description |
|-----|------|-------------|
| Buy | array | BUY signals |
| Sell | array | SELL signals |
| Short | array | SHORT signals |
| Cover | array | COVER signals |
| Size | array | Lot size at signal time |
| opt | float | Shift size by 1 bar if non‑zero (default `0`) |

**Returns:** array — Accumulated position sizes (positive = long, negative = short).

---

### sfEquityCurve

Computes an equity curve from a position array and a price array.  A cost
array (absolute cost per lot) can be provided in the third argument; set to
`0` for no transaction costs.

**Syntax:** `sfEquityCurve( Price, Position, Cost )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Per‑bar price |
| Position | array | Position size (> 0 long, < 0 short, 0 flat) |
| Cost | array | Absolute transaction cost per lot |

**Returns:** array — Equity curve starting from 0.

---

### sfFutureMarginEstimate

Estimates margin requirements for futures based on price and volatility.

**Syntax:** `sfFutureMarginEstimate( Price, fraction [, window ] )`

| Arg | Type | Description |
|-----|------|-------------|
| Price | array | Per‑bar price |
| fraction | array | Fraction of notional value (e.g. 0.1 for 10 %) |
| window | float | Rolling window for volatility estimate (default `20`) |

**Returns:** array — Margin estimate per bar.

---

### sfRequiredMargin

Computes required margin as `abs(position) × margin_per_lot`.

**Syntax:** `sfRequiredMargin( Position, MarginPerLot )`

| Arg | Type | Description |
|-----|------|-------------|
| Position | array | Position size |
| MarginPerLot | array | Margin required per lot |

**Returns:** array — Required margin values.

---

### sfLimitPositionSize

Reduces position size proportionally when required margin exceeds available
margin.

**Syntax:** `sfLimitPositionSize( Position, RequiredMargin, AvailableMargin )`

| Arg | Type | Description |
|-----|------|-------------|
| Position | array | Unrestricted position size |
| RequiredMargin | array | Margin per lot (from `sfRequiredMargin`) |
| AvailableMargin | array | Available account margin |

**Returns:** array — Limited position sizes.

---

### sfDrawdownCurve

Returns the drawdown curve from peak equity.  `opt = 0` (default) returns
absolute drawdown; `opt ≠ 0` returns drawdown as a fraction of peak.

**Syntax:** `sfDrawdownCurve( Equity [, opt ] )`

| Arg | Type | Description |
|-----|------|-------------|
| Equity | array | Equity curve |
| opt | float | `0` = absolute (default), non‑zero = percent of peak |

**Returns:** array — Drawdown values.

---

### sfMaxDrawdown

Returns the running maximum drawdown from peak equity.  `opt = 0` (default)
returns absolute max drawdown; `opt ≠ 0` returns it as a fraction of peak.

**Syntax:** `sfMaxDrawdown( Equity [, opt ] )`

| Arg | Type | Description |
|-----|------|-------------|
| Equity | array | Equity curve |
| opt | float | `0` = absolute (default), non‑zero = percent of peak |

**Returns:** array — Running maximum drawdown.

---

### sfPercentize

Converts an array to percentage change from its first non‑empty value.

**Syntax:** `sfPercentize( Array )`

| Arg | Type | Description |
|-----|------|-------------|
| Array | array | Input time series |

**Returns:** array — `(value − start) / start`.

---

### sfSwitchEquityCurves

Selects the best strategy every `step` bars based on recent relative
performance over `lookback` bars.  The decision at bar `i` uses equity
values up to bar `i‑1` (no look‑ahead).  Returns the position array of the
chosen strategy.

Strategies are referenced by two variable prefixes with indices from 1 to
`count` (e.g. `EqPrefix1 … EqPrefixN` and `PosPrefix1 … PosPrefixN`).

**Syntax:** `sfSwitchEquityCurves( EqPrefix, PosPrefix, count [, step [, lookback ]] )`

| Arg | Type | Description |
|-----|------|-------------|
| EqPrefix | string | Variable‑name prefix for equity curves |
| PosPrefix | string | Variable‑name prefix for position arrays |
| count | float | Number of strategies |
| step | float | Re‑evaluation period in bars (default `1`) |
| lookback | float | Window for recent return (default = `step`) |

**Returns:** array — Position sizes of the selected strategy.

---

## Detect Functions

Non‑blocking file and directory change detection. Each function uses a background
thread to monitor the filesystem; the AFL engine is never blocked.

### sfDetectFileChange

Monitors a single file for content changes. The background thread polls the
file's last‑write timestamp every 500 ms until a change is detected.

**Usage pattern (polling):**

```afl
change = DetectFileChange("C:\data.csv");    // start monitoring
if (change) {
    // file has been modified
    DetectFileChange("C:\data.csv", 1);      // stop monitoring
}
```

**Syntax:** `sfDetectFileChange( filename [, stop ] )`

| Arg | Type | Description |
|-----|------|-------------|
| filename | string | Full path to the file to monitor |
| stop | float | (optional) Set to `1` to stop monitoring |

**Returns:** float — `1` when a change is detected, `0` otherwise.

---

### sfDetectDirChange

Monitors a directory for file creation or modification using
`ReadDirectoryChangesW`. The background thread blocks until a change occurs,
then returns the name of the affected file.

**Syntax:** `sfDetectDirChange( directory [, stop ] )`

| Arg | Type | Description |
|-----|------|-------------|
| directory | string | Full path to the directory to monitor |
| stop | float | (optional) Set to `1` to stop monitoring |

**Returns:** string — The file name (without path) that was created or modified,
or empty string if no change has been detected yet.

---

## ESN Functions

Echo State Network (reservoir computing) routines. Each ESN is identified by
a unique ID returned by `sfESNCreate`.

### sfESNCreate

Creates a new ESN with the specified reservoir size, input size, and output size.

**Syntax:** `sfESNCreate( N_res, N_in, N_out, sparsity, spectral_radius, leaking_rate )`

| Arg | Type | Description |
|-----|------|-------------|
| N_res | float | Number of reservoir neurons |
| N_in | float | Number of input dimensions |
| N_out | float | Number of output dimensions |
| sparsity | float | Fraction of non-zero reservoir connections (e.g. `0.1` = 10 %) |
| spectral_radius | float | Desired spectral radius of the reservoir weight matrix |
| leaking_rate | float | Leaking rate for state updates (`1.0` = no leak) |

**Returns:** float — ESN ID (used by all other ESN functions).

---

### sfESNStep

Advances the reservoir state by one time step.

**Syntax:** `sfESNStep( input, out_state, id )`

| Arg | Type | Description |
|-----|------|-------------|
| input | array | Input vector of size N\_in |
| out_state | array | (output) Reservoir state vector of size N\_res |
| id | float | ESN ID |

**Returns:** None

---

### sfESNTrain

Trains the output weights using ridge regression. The new data batch is
accumulated with any previous training data and W\_out is re-solved
incrementally.

**Syntax:** `sfESNTrain( X_data, Y_data, T, lambda, id )`

| Arg | Type | Description |
|-----|------|-------------|
| X_data | array | Concatenated [x; u] matrix, row‑major, T × (N\_res+N\_in) |
| Y_data | array | Target matrix, row‑major, T × N\_out |
| T | float | Number of timesteps in this batch |
| lambda | float | Ridge regularisation parameter |
| id | float | ESN ID |

**Returns:** None

Call `sfESNTrain` multiple times with different data batches to perform
progressive (incremental) training.

---

### sfESNPredict

Computes the output from the current reservoir state and input.

**Syntax:** `sfESNPredict( input, output, id )`

| Arg | Type | Description |
|-----|------|-------------|
| input | array | Input vector of size N\_in |
| output | array | (output) Output vector of size N\_out |
| id | float | ESN ID |

**Returns:** None

---

### sfESNTrainBg

Starts training in a background thread. The input data is copied so the
caller may reuse or free the original AFL arrays immediately.

**Syntax:** `sfESNTrainBg( X_data, Y_data, T, lambda, id )`

| Arg | Type | Description |
|-----|------|-------------|
| X_data | array | Concatenated [x; u] matrix, row‑major, T × (N\_res+N\_in) |
| Y_data | array | Target matrix, row‑major, T × N\_out |
| T | float | Number of timesteps in this batch |
| lambda | float | Ridge regularisation parameter |
| id | float | ESN ID |

**Returns:** float — Background task ID (can be ignored).

Only one background training may run at a time per ESN; starting a new one
cancels any pending task. Poll completion with `sfESNTrainingStatus`.

---

### sfESNTrainingStatus

Returns the current training status of an ESN.

**Syntax:** `sfESNTrainingStatus( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | ESN ID |

**Returns:** float — `0` idle, `1` training in background, `-1` error.

---

### sfESNDestroy

Destroys an ESN and releases all associated resources. Any running background
training is cancelled first.

**Syntax:** `sfESNDestroy( id )`

| Arg | Type | Description |
|-----|------|-------------|
| id | float | ESN ID |

**Returns:** None
