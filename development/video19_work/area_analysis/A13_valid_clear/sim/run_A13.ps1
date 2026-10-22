param(
    [int]$Mode = 2,
    [int]$Seed = 324508639,
    [int]$FrameIndex = 0,
    [int]$Gap = 0,
    [int]$AbortBytes = 0,
    [int]$Width = 640,
    [int]$Height = 480,
    [string]$JpegPath = '',
    [switch]$BaselineA11
)

$ErrorActionPreference = 'Stop'
$simDir = $PSScriptRoot
$videoWork = (Resolve-Path (Join-Path $simDir '../../..')).Path
$variantDir = Split-Path $simDir -Parent
$frameTag = '{0:D3}' -f $FrameIndex
$library = 'work'
$prefix = 'A13'
if ($BaselineA11) {
    $variantDir = Join-Path $videoWork 'area_rebalance/A11_color_mul'
    $library = 'work_a11'
    $prefix = 'A11'
}
$modelsim = 'E:/ModelsimSE/win64'
$inputTag = "frame${frameTag}"
if ($JpegPath) {
    $jpegPath = (Resolve-Path -LiteralPath $JpegPath).Path
    $inputTag = [IO.Path]::GetFileNameWithoutExtension($jpegPath)
} else {
    $jpegPath = Join-Path $simDir "frame_${frameTag}.jpg"
}
$outputPath = Join-Path $simDir "${prefix}_${inputTag}_mode${Mode}_gap${Gap}_abort${AbortBytes}_seed${Seed}.bin"
$resultPath = Join-Path $simDir "${prefix}_${inputTag}_mode${Mode}_gap${Gap}_abort${AbortBytes}_seed${Seed}.log"
$simLog = Join-Path $simDir "${prefix}_${inputTag}_mode${Mode}_gap${Gap}_abort${AbortBytes}_seed${Seed}_run.log"

if (-not (Test-Path -LiteralPath $jpegPath)) {
    & python (Join-Path $simDir 'extract_reference_frames.py') $FrameIndex
    if ($LASTEXITCODE -ne 0) { throw "frame extraction failed: $LASTEXITCODE" }
}

Push-Location $simDir
try {
    & (Join-Path $modelsim 'vlib.exe') $library *> (Join-Path $simDir "vlib_${library}.log")
    if ($LASTEXITCODE -ne 0) { throw "vlib failed: $LASTEXITCODE" }

    $sources = Get-ChildItem (Join-Path $variantDir 'src_v') -Filter '*.v' |
        Where-Object Name -ne 'jpeg_dht.v' |
        ForEach-Object { $_.FullName }
    $sources += (Resolve-Path (Join-Path $simDir 'jpeg_dht_compat.v')).Path
    $sources += (Resolve-Path (Join-Path $simDir 'tb_jpeg_core_trace.sv')).Path
    & (Join-Path $modelsim 'vlog.exe') -modelsimini modelsim.ini -work $library -sv $sources *> (Join-Path $simDir "compile_${prefix}.log")
    if ($LASTEXITCODE -ne 0) { throw "vlog failed; see compile_${prefix}.log" }

    $top = "${library}.tb_jpeg_core"
    & (Join-Path $modelsim 'vsim.exe') -modelsimini modelsim.ini -c -lic_noqueue $top `
        "+JPEG=$($jpegPath.Replace('\','/'))" "+OUT=$([IO.Path]::GetFileName($outputPath))" "+LOG=$([IO.Path]::GetFileName($resultPath))" "+MODE=$Mode" "+SEED=$Seed" "+GAP=$Gap" "+ABORT_BYTES=$AbortBytes" "+WIDTH=$Width" "+HEIGHT=$Height" `
        -do 'run -all; quit -code 0 -f' -l $simLog
    if ($LASTEXITCODE -ne 0) { throw "vsim failed; see $simLog" }
    Get-Content -LiteralPath $resultPath
}
finally {
    Pop-Location
}
