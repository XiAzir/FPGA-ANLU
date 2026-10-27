$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$positive = Join-Path $here 'equiv.vvp'
$negative = Join-Path $here 'negative_control.vvp'
$sources = @(
    (Join-Path $here 'frame_fifo_write_original.v'),
    (Join-Path $here 'frame_fifo_write_candidate.v'),
    (Join-Path $here 'jpeg420_word_address.v'),
    (Join-Path $here 'tb_equiv.v')
)
if (-not (Get-Command iverilog -ErrorAction SilentlyContinue) -or -not (Get-Command vvp -ErrorAction SilentlyContinue)) {
    throw 'Icarus Verilog commands iverilog and vvp are required.'
}
& iverilog -g2012 -s tb_equiv -o $positive @sources
if ($LASTEXITCODE -ne 0) { throw "Icarus compile failed: $LASTEXITCODE" }
& vvp $positive
if ($LASTEXITCODE -ne 0) { throw "Equivalence bench failed: $LASTEXITCODE" }
$negativeSources = @(
    (Join-Path $here 'frame_fifo_write_original.v'),
    (Join-Path $here 'frame_fifo_write_negative.v'),
    (Join-Path $here 'jpeg420_word_address.v'),
    (Join-Path $here 'tb_equiv.v')
)
& iverilog -g2012 -s tb_equiv -o $negative @negativeSources
if ($LASTEXITCODE -ne 0) { throw "Negative-control compile failed: $LASTEXITCODE" }
& vvp $negative
if ($LASTEXITCODE -eq 0) { throw 'Negative control escaped detection.' }
Write-Host 'PASS: BURST_SIZE=256 candidate matches; isolated early-burst variant was detected.'
