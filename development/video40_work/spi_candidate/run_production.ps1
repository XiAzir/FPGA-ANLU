param([ValidateSet('baseline','fast')][string]$Mode='fast', [int]$TodNs=0, [int]$InjectBit=-1)
$ErrorActionPreference='Stop'
$dir=Split-Path -Parent $MyInvocation.MyCommand.Path
$root=Split-Path (Split-Path (Split-Path $dir -Parent) -Parent) -Parent
$iv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
if(-not (Test-Path $iv)){ $iv=(Get-Command iverilog.exe -ErrorAction Stop).Source; $vv=(Get-Command vvp.exe -ErrorAction Stop).Source }
$fast=if($Mode -eq 'fast'){'1'}else{'0'}
$sim=Join-Path $dir "spi_production_${Mode}_tod${TodNs}_inject${InjectBit}.vvp"
& $iv -g2012 -s tb_spi "-Ptb_spi.FAST=$fast" -o $sim (Join-Path $dir 'spi_master_production.v') (Join-Path $dir 'tb_spi_production.v')
if($LASTEXITCODE -ne 0){ throw "iverilog failed: $LASTEXITCODE" }
$log=Join-Path $dir "run_production_${Mode}_tod${TodNs}_inject${InjectBit}.log"
& $vv $sim "+TOD=$TodNs" "+INJECT=$InjectBit" 2>&1 | Tee-Object -FilePath $log
if($LASTEXITCODE -ne 0){ throw "vvp failed: $LASTEXITCODE; log=$log" }

