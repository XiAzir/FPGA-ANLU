param()
$ErrorActionPreference='Stop'
$root=(Resolve-Path '.').Path
$dir=Join-Path $root 'development\player_spectrum_private_init\build\oddr_only_audit'
$iv=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\iverilog.exe'
$vvp=Join-Path $root 'bringup\tf_wav_hdmi\tools\iverilog\app\bin\vvp.exe'
$tb=Join-Path $dir 'tb_serializer_model.v'
$wrap=Join-Path $dir 'wrapper_baseline.v'
$rows=[System.Collections.Generic.List[string]]::new()
$failures=[System.Collections.Generic.List[string]]::new()
function Run-Group([string]$name,[string]$lane,[int]$d0,[int]$d1,[int]$clk,[bool]$expectPass){
  foreach($toggle in @(0,1000,2000)){
    $exe=Join-Path $dir "model_${name}_${toggle}_${d0}_${d1}_${clk}.vvp"
    & $iv -g2012 -s tb_serializer_model -P "tb_serializer_model.TOGGLE_DELAY_PS=$toggle" -P 'tb_serializer_model.CANDIDATE=0' -P "tb_serializer_model.ODDR_D0_DELAY_PS=$d0" -P "tb_serializer_model.ODDR_D1_DELAY_PS=$d1" -P "tb_serializer_model.PAD_CLK_DELAY_PS=$clk" -o $exe $tb $lane $wrap
    if($LASTEXITCODE -ne 0){throw "iverilog compile failed: $name toggle=$toggle"}
    foreach($phase in @(-1000,0,1000)){foreach($seed in @(1,37,97)){
      $out=& $vvp $exe "+phase=$phase" "+seed=$seed" 2>&1
      $code=$LASTEXITCODE
      $line=$out|Where-Object {$_ -like 'SUMMARY *'}|Select-Object -Last 1
      if(!$line){$out|Set-Content -LiteralPath (Join-Path $dir "missing_${name}_${toggle}_${d0}_${d1}_${clk}_${phase}_${seed}.log") -Encoding ascii; throw "missing summary: $name toggle=$toggle phase=$phase seed=$seed"}
      $rows.Add("$name $line")
      $failed=($code -ne 0) -or ($line -match 'align_bit=-1') -or ($line -match 'word_errors=([1-9][0-9]*)') -or ($line -match 'serial_bit_errors=([1-9][0-9]*)') -or ($line -match 'target_errors=([1-9][0-9]*)') -or ($line -match 'capture_errors=([1-9][0-9]*)') -or ($line -match 'source_sequence_errors=([1-9][0-9]*)')
      if($failed){$failures.Add("$name toggle=$toggle d0=$d0 d1=$d1 clk=$clk phase=$phase seed=$seed code=$code $line");$out|Set-Content -LiteralPath (Join-Path $dir "failure_${name}_${toggle}_${d0}_${d1}_${clk}_${phase}_${seed}.log") -Encoding ascii}
      if($expectPass -and $failed){continue}
    }}
  }
}
Run-Group 'candidate_nominal' (Join-Path $dir 'lane_oddr_negedge.v') 0 0 0 $true
Run-Group 'candidate_pad_boundary' (Join-Path $dir 'lane_oddr_negedge.v') 50 1500 1000 $true
Run-Group 'baseline_nominal' (Join-Path $dir 'lane_baseline.v') 0 0 0 $true
Run-Group 'baseline_pad_boundary' (Join-Path $dir 'lane_baseline.v') 50 1500 1000 $false
$rows|Set-Content -LiteralPath (Join-Path $dir 'matrix_summary.txt') -Encoding ascii
$failures|Set-Content -LiteralPath (Join-Path $dir 'matrix_failures.txt') -Encoding ascii
$candNom=@($rows|Where-Object {$_ -like 'candidate_nominal *'}).Count
$candBnd=@($rows|Where-Object {$_ -like 'candidate_pad_boundary *'}).Count
$baseNom=@($rows|Where-Object {$_ -like 'baseline_nominal *'}).Count
$baseBnd=@($rows|Where-Object {$_ -like 'baseline_pad_boundary *'}).Count
$candFailures=@($failures|Where-Object {$_ -like 'candidate_*'}).Count
$baseFailures=@($failures|Where-Object {$_ -like 'baseline_*'}).Count
$report="candidate nominal pass=$($candNom-$candFailures)/$candNom; candidate PAD boundary pass=$($candBnd-@($failures|Where-Object {$_ -like 'candidate_pad_boundary *'}).Count)/$candBnd; baseline nominal pass=$($baseNom-@($failures|Where-Object {$_ -like 'baseline_nominal *'}).Count)/$baseNom; baseline PAD boundary pass=$($baseBnd-@($failures|Where-Object {$_ -like 'baseline_pad_boundary *'}).Count)/$baseBnd; baseline boundary counterexamples=$(@($failures|Where-Object {$_ -like 'baseline_pad_boundary *'}).Count)"
$report|Set-Content -LiteralPath (Join-Path $dir 'result_summary.txt') -Encoding ascii
Get-Content -LiteralPath (Join-Path $dir 'result_summary.txt')
if($candFailures -ne 0 -or $candNom -ne 27 -or $candBnd -ne 27 -or $baseNom -ne 27 -or $baseBnd -ne 27){throw "Unexpected candidate or matrix result; see $dir"}
