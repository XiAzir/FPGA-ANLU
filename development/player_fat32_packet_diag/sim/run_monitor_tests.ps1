$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$repo = (Join-Path $AnluDocsRoot 'development/player_fat32_packet_diag')
$sim = Join-Path $repo 'sim'
$iverilog = (Resolve-AnluTool 'iverilog')
$vvp = (Resolve-AnluTool 'vvp')
$python = 'python'
$result = Join-Path $sim 'test_result.txt'
& $python (Join-Path $sim 'verify_audio_packet_vector.py') 2>&1 | Tee-Object -FilePath $result
if ($LASTEXITCODE -ne 0) { throw "Python vector verification failed: $LASTEXITCODE" }
$exe = Join-Path $sim 'test_hdmi_packet_monitor.vvp'
$rtl = Join-Path $repo 'src\user_source\hdl_source\hdmi_packet_monitor.v'
$tb = Join-Path $sim 'test_hdmi_packet_monitor.v'
& $iverilog -g2012 -Wall -s test_hdmi_packet_monitor -o $exe $rtl $tb 2>&1 | Tee-Object -FilePath $result -Append
if ($LASTEXITCODE -ne 0) { throw "iverilog failed: $LASTEXITCODE" }
Push-Location $sim
try {
  & $vvp $exe 2>&1 | Tee-Object -FilePath $result -Append
  if ($LASTEXITCODE -ne 0) { throw "vvp failed: $LASTEXITCODE" }
  Remove-Item -LiteralPath $exe -Force
} finally { Pop-Location }
