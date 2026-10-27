param([ValidateSet('baseline','fast')][string]$Mode='fast', [int]$TodNs=0, [int]$InjectBit=-1, [switch]$BypassAckWait)
$ErrorActionPreference='Stop'
$dir=Split-Path -Parent $MyInvocation.MyCommand.Path
$root=Split-Path (Split-Path (Split-Path $dir -Parent) -Parent) -Parent
$iv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
if(-not (Test-Path $iv)){ $iv=(Get-Command iverilog.exe -ErrorAction Stop).Source; $vv=(Get-Command vvp.exe -ErrorAction Stop).Source }
$fast=if($Mode -eq 'fast'){'1'}else{'0'}
$bypass=if($BypassAckWait){'1'}else{'0'}
$sim=Join-Path $dir "spi_$Mode.vvp"
& $iv -g2012 -s tb_spi "-Ptb_spi.FAST=$fast" "-Ptb_spi.BYPASS=$bypass" -o $sim (Join-Path $dir 'spi_master.v') (Join-Path $dir 'tb_spi.v')
if($LASTEXITCODE -ne 0){ throw "iverilog failed: $LASTEXITCODE" }
$tag=if($BypassAckWait){'bypass'}else{'keep'}
$log=Join-Path $dir "run_${Mode}_tod${TodNs}_${tag}_inject${InjectBit}.log"
& $vv $sim "+TOD=$TodNs" "+INJECT=$InjectBit" 2>&1 | Tee-Object -FilePath $log
if($LASTEXITCODE -ne 0){ throw "vvp failed: $LASTEXITCODE; log=$log" }
