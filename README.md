# AmiToolkit — An AmiBroker Plugin

AmiToolkit is an [AmiBroker](https://www.amibroker.com/) plug-in that adds string manipulation, JSON handling, structured data, text file I/O, technical indicators, codecs (Base64, MessagePack, CBOR), inter-process communication (pipes, named pipes, websockets), LLMs COM using OpenAI, backtesting facilities and quantitative utilities to the AFL scripting language.

## Installing

1. Copy `libcurl-x64.dll` to your AmiBroker directory (NOT in `Plugins`).
2. Copy `AmiToolkit.dll` in `Amibroker\Plugins` subdirectory BEFORE starting Amibroker.

## User Guide

Read `Doc\index.html`

## Important Note

To avoid name collision with native functions and other plugins, a prefix is used. This project prefix is "sf".
All functions listed below are named without this prefix. In practice when used in AFL Amibroker's Formula Language,
the sf prefix should be used. Thus practical names are sfRoundQuotes, sfStrFind, sfStrFindLast, sfStrExtractFrom...

## Functions

### String

`RoundQuotes`, `RoundQuote`, `StrFind`, `StrFindLast`, `StrExtractFrom`, `StrTrimExtractFrom`, `StrFindNested`, `StrNextField`, `StrFrom`, `StrFromChar`, `StrToChar`, `StrQuote`, `StrUnquote`, `StrDisclose`, `StrEnclose`, `StrToQuote`, `StrFromQuote`, `StrInsert`, `StrColumnSizes`, `StrFormatTable`, `StrFormatHeaders`, `StrFormatAlignedTable`, `StrTrimIn`

### Regex

`StrFindRegEx`, `StrExtractRegEx`, `StrReplaceRegEx`, `StrReplaceAllRegEx`

### String Builder

`StrBuilder`, `StrBuilderAppend`, `StrBuilderAppend2`, `StrBuild`, `StrBuilderClear`, `StrBuilderPrepend`, `StrBuilderRemove`, `StrBuilderDestroy`

### Vector

`VectorCreate`, `VectorDestroy`, `VectorGet`, `VectorSetFloat`, `VectorSetString`, `VectorSize`, `VectorClear`, `VectorResize`, `VectorToString`, `VectorFromString`, `VectorPushFloat`, `VectorPushString`, `VectorPop`

### JSON (RapidJSON — object ID based)

`JSONCreate`, `JSONDestroy`, `JSONLoad`, `JSONSave`, `JSONGet`, `JSONSetString`, `JSONSetFloat`, `JSONParse`, `JSONToString`, `JSONFix`, `JSONPretty`

### JStr (Lightweight JSON strings — no parser, no ID)

`JStrGetKey`, `JStrGet`, `JStrSetKeyString`, `JStrSetKeyFloat`, `JStrSetKeyBool`, `JStrRemoveKey`, `JStrRemove`, `JStrClear`, `JStrFix`, `JStrMerge`, `JStrGetPath`

**Key builder / stream functions:** `JStrKeyFloat`, `JStrKeyString`, `JStrKeyRaw`, `JStrKeyBool`, `JStrKeyNull`, `JStrStripPair`, `JStrStrip`, `JStrNextPair`, `JStrNextKey`, `JStrNextValue`

### Text Files

`TextLoad`, `TextLoadAndClear`, `TextSave`, `TextFree`

### CSV

`CSVParse`, `CSVLoad`, `CSVLoadAndAppend`, `CSVSave`, `CSVAppendToFile`, `CSVDestroy`, `CSVGetCell`, `CSVSetCell`, `CSVGetNumRows`, `CSVGetNumCols`, `CSVAppendRow`, `CSVAppendCol`, `CSVAppendColStr`, `CSVAppendColArray`, `CSVRemoveRow`, `CSVRemoveCol`, `CSVExtractSubtable`, `CSVExtractSubtableWithMask`, `CSVExtractCol`, `CSVExtractCols`, `CSVSetDelimiter`, `CSVGetDelimiter`

### Record (Static Store)

`RecordCreate`, `RecordGet`, `RecordSetString`, `RecordSetFloat`, `RecordSetArray`, `RecordClear`

### Store

`StoreCreate`, `StoreDestroy`, `StoreGet`, `StoreSet`, `StorePush`, `StorePushFloat`, `StorePushString`, `StoreRemove`, `StoreExists`, `StoreSize`, `StoreClear`, `StoreToString`, `StoreFromString`

### Table

`TableCreate`, `TableDestroy`, `TableLength`, `TableWidth`, `TableGet`, `TableSetFloat`, `TableSetString`, `TableAppendRowStr`, `TableInsertRowStr`, `TableRemoveRow`, `TableClearRow`, `TableFindRow`, `TableAvgColumn`, `TableCumColumn`, `TableSort`, `TableRowToString`, `TableColumnToString`, `TableColumnToArray`, `TableToMatrix`, `TableColumnFromString`

### Position / Backtesting

`RemoveExcessSignals`, `RestrictSignals`, `RestrictPosition`, `CapPosition`, `PositionFromSignals`, `SignalsFromPosition`, `EquityCurve`, `FutureMarginEstimate`, `RequiredMargin`, `LimitPositionSize`, `DrawdownCurve`, `MaxDrawdown`, `Percentize`, `SwitchEquityCurves`

### Codec

`Base64Encode`, `Base64Decode`, `MPEncode`, `MPDecode`

### Binary

`BinFromString`, `BinFromFloat`, `BinFromInt`, `BinFromBool`, `BinToString`, `BinToFloat`, `BinToInt`, `BinToBool`, `BinExtract`, `BinInsert`, `BinReplace`, `BinLoad`, `BinSave`

### CBOR

`CBOREncode`, `CBORDecode`, `CBORParse`, `CBORCreate`, `CBORGet`, `CBORSetString`, `CBORSetFloat`, `CBORDestroy`, `CBORToString`, `CBORLoad`, `CBORSave`, `WSSendCBOR`

### Technical Indicators

**Moving Averages** — `SMA`, `MA`, `KAMA`, `VWAP`, `InvFisher`

**Trend / Trailing** — `Direction`, `TrailingStop`, `SuperTrend`, `MOST`, `PMAX`, `PROMAXI`, `AverageSince`, `DynamicCycles`

**Ehlers DSP** — `MAMA`, `FAMA`, `FRAMA`, `ITL`, `ITLX`, `NET`, `Sinewave`, `LaguerreRSI`, `Reflex`, `SuperSmoother`, `HilbertOsc`, `RocketRSI`

**Beta / Regression / Cointegration** — `UpBeta`, `DownBeta`, `UpAlpha`, `DownAlpha`, `PolyReg`, `Cointegrate`

**Statistical** — `ZScore`, `RobustScaler`, `MutualInfo`, `SortinoRatio`, `UlcerIndex`, `VaR`, `VaREx`

**Volume / Money Flow** — `ChaikinMoneyFlow`, `TwiggsMoneyFlow`, `DemandIndex`

**Volatility / Oscillators** — `VIXFix`, `WilliamsPercentRange`, `Expectancy`, `DeMarker`, `TDSetup`, `TDCountdown`

**Pricing / Utilities** — `HeikinAshi`, `RoundPrice`, `LogReturns`, `FracDiff`, `SimulatePrices`, `AddNoise`, `HHV`, `LLV`, `RemoveGaps`, `LimitJumps`, `FixSpikes`

**Regime Detection** — `MarketRegime`

**Floor Pivot Score** — `FloorPivotScore`

**Detection** — `BarsSincePeak`, `BarsSinceTrough`, `LakeRatio`

### Statistics

`MedianArrays`, `MedianArray2`, `MedianArray4`, `MedianArray6`, `PeriodicStat`, `Regularize`, `FirstValue`, `Diff`, `TestAverage`, `TestThreshold`, `HitProbability`, `HitLevel`, `HitMovingTarget`

### Wavelet / ARIMA / GARCH / FFT

`WaveletD4`, `WaveletHaar`, `WaveletMorlet`, `ARFIMA`, `ARIMA`, `GARCH`, `HurstDFA`, `HurstDFA2`, `HodrickPrescott`, `Goertzel`, `GoertzelDFTSpectrum`, `FFTSpectrum`, `FFTDenoising`

### Slippage Estimation

`IntradaySlippageEstimate`, `SlippageEstimate`

### Error Handling

`GetError`, `GetMostRecentError`, `GetErrorDetails`, `GetLastErrors`, `GetErrorById`, `GetErrorByCode`, `GetErrorByNumber`, `GetErrorBySeverity`, `NumErrors`

### IPC: Pipe (process I/O)

`PipeCreate`, `PipeSend`, `PipeRequest`, `PipeRead`, `PipeIsClosed`, `PipeClose`

### IPC: Named Pipe (P2P)

`NPCreate`, `NPConnect`, `NPGetStatus`, `NPSend`, `NPReceive`, `NPClose`

### IPC: WebSocket (client)

`WSConnect`, `WSGetStatus`, `WSSend`, `WSReceive`, `WSClose`

### OpenAI (LLM)

`OpenAIConfigure`, `OpenAIRequest`, `OpenAIGetAnswer`, `OpenAIForget`

### Dialog

`SelectFile`, `SaveFile`, `DialogYesNo`, `DialogOkCancel`, `DialogOK`

### Options

`BSCall`, `BSPut`, `Black76Call`, `Black76Put`, `BSImpliedVol`, `Black76ImpliedVol`, `OptionPrice`, `ImpliedVol`

### Utilities

`GetChrono`, `ResetChrono`, `UTF16ToAscii`, `UnicodeToAscii`, `DetectFileChange`, `DetectDirChange`, `GetFileSize`, `CreateTempFile`, `KellyCriterion`, `FixQuotes`, `MxSparseMatrix`, `BondQuoteToStr`, `BondPrice`, `YieldToMaturity`, `WACC`, `TerminalValue`

### Other

`GetPluginInfo`, `CheckArrayInit`, `InitArray`, `IsAllocArrayInit`, `EmptyValue`, `EqualVariables`, `Alloc`, `Free`, `AllocArrayResult`, `GetArrayLength`, `GetVariable`, `SetArray`, `SetFloat`, `ArrayShiftLeft`, `ArrayShiftRight`

## Building the DLL

### Prerequisites

- Microsoft Visual Studio 2022 (or newer) with Desktop development with C++ workload.
- [CMake](https://cmake.org/) 3.12+.

### CMake (recommended)

From a **Developer Command Prompt for VS**:

```cmd
cd AmiToolkit
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

The DLL is produced at `build\Release\AmiToolkit.dll` (x86) or `build\x64\Release\AmiToolkit.dll` (x64).

### Visual Studio solution

Open `AmiToolkit.sln` in Visual Studio and build.

### Direct `cl.exe`

```cmd
cl.exe /nologo /O2 /EHsc /std:c++20 /I. /I3rdparty /LD /FeAmiToolkit.dll ^
    AmiToolkit.cpp Functions.cpp Plugin.cpp Helpers.cpp StdAfx.cpp ^
    /link /DLL /OUT:AmiToolkit.dll
```

## Documentation

A multi-page HTML user guide is generated from `Documentation.md`.

```powershell
# Requires PowerShell 7+ (pwsh.exe) — NOT Windows PowerShell 5.1
pwsh.exe Doc/generate-docs.ps1
```

Output: `Doc/index.html` (index), `Doc/AmiToolkit Reference Guide.html` (navigation + glossary), and category pages.

## Running Tests

### Compile and run

From a **Developer Command Prompt for VS**:

```cmd
cd sfStr
cl.exe /nologo /EHsc /std:c++20 /I. /I3rdparty /Fetests\AmiToolkit_tests.exe tests\tests.cpp /link comdlg32.lib ole32.lib ws2_32.lib
tests\AmiToolkit_tests.exe
```

The test runner prints `PASS`/`FAIL` per assertion and exits with 0 on success, 1 on failure.

### Adding new tests

1. Open `tests\tests.cpp`.
2. Write a test function using the macros from `tests\tests.h`:

```cpp
static void test_myFeature() {
    section("myFeature");
    AmiVar r = StrFind(1, args);
    TEST_ASSERT_EQ(r.type, VAR_FLOAT, "returns float");
    TEST_ASSERT(r.val > 0, "positive value");
}
```

Macros: `TEST_ASSERT(cond, msg)`, `TEST_ASSERT_EQ(a, b, msg)`, `TEST_ASSERT_STR_EQ(a, b, msg)`, `TEST_ASSERT_FLOAT_EQ(a, b, msg)`.

3. Call `test_myFeature()` from `main()`.
4. Rebuild and run.

#### LLM tests (OpenAI / Mistral)

To test `OpenAIRequest` with a real API response, set the environment variable
before running tests:

```powershell
$env:MISTRAL_API_KEY = "your-api-key-here"
tests\AmiToolkit_tests.exe
```

If the variable is unset the test is skipped with a CAUSE message.

**Total: 1866 tests all passing**

## License

MIT License 2.0.

Copyright © 2026 SF

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



Note: Of course this project uses the AmiBroker Plugin SDK (© Tomasz Janescko / AmiBroker.com). See `Plugin.h` for details and license. Reproduced below:

// Copyright (c) 2001-2010 AmiBroker.com. All rights reserved. 
//
// Users and possessors of this source code are hereby granted a nonexclusive, 
// royalty-free copyright license to use this code in individual and commercial software.
//
// AMIBROKER.COM MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE CODE FOR ANY PURPOSE. 
// IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF ANY KIND. 
// AMIBROKER.COM DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOURCE CODE, 
// INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
// IN NO EVENT SHALL AMIBROKER.COM BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL, OR 
// CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, 
// ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOURCE CODE.
// 
// Any use of this source code must include the above notice, 
// in the user documentation and internal comments to the code.
