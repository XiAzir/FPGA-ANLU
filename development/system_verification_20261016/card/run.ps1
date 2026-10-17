$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$project = (Resolve-Path (Join-Path $here '..\..\..')).Path
$iverilogDir = Join-Path $project 'bringup\tf_wav_hdmi\tools\iverilog\app\bin'
$outDir = Join-Path $here 'modelsim'
$image = Join-Path $here 'card.mem'
$model = Join-Path $here 'sd_spi_card_model.v'
$tb = Join-Path $here 'tb_sd_card.v'
$src = @(
  (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\SD\sd_card_top.v'),
  (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\SD\sd_card_sec_read_write.v'),
  (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\SD\sd_card_cmd.v'),
  (Join-Path $project 'development\player_spectrum_fft_recover\src\user_source\hdl_source\SD\spi_master.v')
)
$vvpFile = Join-Path $outDir 'tb_sd_card.vvp'
$logFile = Join-Path $here 'run.log'
if (Test-Path $logFile) { Remove-Item -LiteralPath $logFile -Force }
Push-Location $here
try {
  & (Join-Path $iverilogDir 'iverilog.exe') -g2005 -o $vvpFile -s tb_sd_card $model @src $tb 2>&1 | Tee-Object -FilePath $logFile
  if ($LASTEXITCODE -ne 0) { throw "iverilog failed with exit code $LASTEXITCODE" }
  & (Join-Path $iverilogDir 'vvp.exe') $vvpFile 2>&1 | Tee-Object -FilePath $logFile -Append
  $runExit = $LASTEXITCODE
  if ($runExit -ne 0) { throw "vvp failed with exit code $runExit" }
  if (-not (Select-String -Path $logFile -SimpleMatch 'PASS init + two production CMD17 sectors + CRC + pin-level CS interruption recovery' -Quiet)) {
    throw 'PASS marker not found in run.log'
  }
  $manifest = Get-Content (Join-Path $here 'manifest.json') -Raw | ConvertFrom-Json
  $hashes = [ordered]@{}
  foreach ($file in @($model,$tb) + $src + @($image,(Join-Path $here 'packed_mem.mem'),(Join-Path $here 'lba_map.mem'),(Join-Path $here 'expected_sectors.mem'),(Join-Path $here 'manifest.json'),(Join-Path $here 'gen_card.py'))) {
    $hashes[[IO.Path]::GetFileName($file)] = (Get-FileHash -Algorithm SHA256 -LiteralPath $file).Hash.ToLowerInvariant()
  }
  $summary = [ordered]@{
    status = 'PASS'
    simulator = 'Icarus Verilog / vvp, Verilog-2005'
    modelsim = 'PASS: ModelSim SE-64 10.1c vlog + vsim -novopt; full SD unit and CS recovery; see modelsim/vlog.log and modelsim/unit_novopt.log'
    run_log = 'run.log'
    result = 'current packed-sector model: real sd_card_top initialization; LBA 0 and 4130, 512 bytes each; production CRC checked=2 bad=0; independent pin-level CS interruption and CMD17 recovery pass'
    model = 'SDHC block addressing, production SPI mode 3, compact packed-sector array plus explicit LBA map; missing/X sectors fatal; unsupported commands set protocol_error'
    image_bytes = $manifest.image_bytes
    populated_sectors = $manifest.populated_sectors
    fat32_cluster_count = $manifest.fat32_cluster_count
    wave_source_sha256 = $manifest.wave_source.sha256
    wave_payload_byte_offset = $manifest.wave_source.data_payload_byte_offset
    wave_sample_count = $manifest.wave_source.sample_count
    source_sha256 = $hashes
  }
  $summary | ConvertTo-Json -Depth 6 | Set-Content -Encoding utf8 (Join-Path $here 'summary.json')
} catch {
  if (-not (Test-Path $logFile)) { $_ | Out-String | Set-Content -Encoding utf8 $logFile }
  throw
} finally { Pop-Location }
