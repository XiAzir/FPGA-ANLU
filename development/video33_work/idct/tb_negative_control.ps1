$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$repo = Split-Path (Split-Path (Split-Path $here -Parent) -Parent) -Parent
$iverilog = Join-Path $repo 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $repo 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$badSource = Join-Path $here 'jpeg_idct_dc_fast_bad.v'
$image = Join-Path $here 'tb_negative.vvp'
try {
    (Get-Content (Join-Path $here 'jpeg_idct_dc_fast.v') -Raw).Replace("32'sd2896", "32'sd2895") |
        Set-Content -Encoding ascii $badSource
    & $iverilog -g2012 -s tb -o $image `
        (Join-Path $here 'tb_compare.v') `
        (Join-Path $here 'jpeg_idct.v') $badSource `
        (Join-Path $here 'jpeg_idct_ram.v') `
        (Join-Path $here 'jpeg_idct_ram_dp.v') `
        (Join-Path $here 'jpeg_idct_transpose.v') `
        (Join-Path $here 'jpeg_idct_transpose_ram.v') `
        (Join-Path $here 'jpeg_idct_y.v') `
        (Join-Path $here 'jpeg_idct_fifo.v')
    if ($LASTEXITCODE -ne 0) { throw 'Icarus compile failed' }
    $output = & $vvp $image 2>&1
    $runCode = $LASTEXITCODE
    if ($runCode -eq 0) { throw 'Negative control unexpectedly passed' }
    $output | Select-Object -Last 3
    'NEGATIVE_CONTROL_DETECTED'
}
finally {
    Remove-Item -LiteralPath $badSource,$image -ErrorAction SilentlyContinue
}
