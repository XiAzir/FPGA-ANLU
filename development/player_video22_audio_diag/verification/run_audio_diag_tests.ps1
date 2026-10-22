$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\..\..\scripts\anlu_tools.ps1')

$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$project = Join-Path $repoRoot 'development\player_video22_audio_diag'
$c21 = Join-Path $repoRoot 'development\player_video21_diag\src\user_source\hdl_source'
$c22 = Join-Path $project 'src\user_source\hdl_source'
$results = Join-Path $PSScriptRoot 'results'
New-Item -ItemType Directory -Path $results -Force | Out-Null
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$topSource = Join-Path $c22 'top_tf_hdmi_audio.v'

function Invoke-LoggedTool {
    param([string]$Name,[string]$LogPath,[string]$Exe,[string[]]$Arguments)
    @("Tool: $Exe","Arguments: $($Arguments -join ' ')","Started: $([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss.fff zzz'))") |
        Set-Content -LiteralPath $LogPath -Encoding utf8
    & $Exe @Arguments 2>&1 | Tee-Object -FilePath $LogPath -Append
    $code=$LASTEXITCODE
    "ExitCode: $code" | Add-Content -LiteralPath $LogPath -Encoding utf8
    if($code -ne 0){throw "$Name failed with exit code $code; see $LogPath"}
}

function Normalize-Newlines([string]$Text){ return $Text.Replace("`r`n","`n").Replace("`r","`n") }
function Assert-TapOnly([string]$File,[string[]]$RemovalPatterns){
    $old=Normalize-Newlines([IO.File]::ReadAllText((Join-Path $c21 $File)))
    $new=Normalize-Newlines([IO.File]::ReadAllText((Join-Path $c22 $File)))
    foreach($pattern in $RemovalPatterns){$new=[regex]::Replace($new,$pattern,'')}
    if($new -cne $old){throw "Unexpected C22 media-logic difference remains after removing the declared output taps: $File"}
    return [pscustomobject]@{file=$File;c21_sha256=(Get-FileHash (Join-Path $c21 $File)).Hash;c22_sha256=(Get-FileHash (Join-Path $c22 $File)).Hash;normalized_equal=$true}
}

$staticResults=@()
$staticResults+=Assert-TapOnly 'wav_pcm_bridge.v' @('(?m)^[ \t]*output wire underflow_event,[ \t]*\n','(?m)^assign underflow_event = .*;[ \t]*\n')
$staticResults+=Assert-TapOnly 'player_audio_probe.v' @('(?m)^[ \t]*output underflow_event,[ \t]*\n','(?m),\n[ \t]*\.underflow_event\(underflow_event\)')
$staticResults+=Assert-TapOnly 'tf_wav_file_player.v' @('(?m)^[ \t]*output wire \[12:0\] debug_fifo_level,[ \t]*\n','(?m)^[ \t]*assign debug_fifo_level = fifo_count;[ \t]*\n')

$topText=[IO.File]::ReadAllText($topSource)
$crcMarker=$topText.IndexOf('// Hold CRC and its block number across the separate one-second pages.',[StringComparison]::Ordinal)
if($crcMarker -lt 0){throw 'CRC snapshot marker not found in top'}
$crcTail=$topText.Substring($crcMarker)
$crcPattern='(?s)always\s*@\(posedge\s+video_clk\s+or\s+posedge\s+rst_all\)\s*begin.*?\r?\nend(?=\r?\nalways\s*@\(posedge\s+video_clk\s+or\s+posedge\s+rst_all\)\s*begin)'
$crcMatch=[regex]::Match($crcTail,$crcPattern)
if(-not $crcMatch.Success){throw 'CRC snapshot always block extraction failed'}
$crcBlock=$crcMatch.Value
$crcHash=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($crcBlock)))
$crcWrapper=@"
``timescale 1ns/1ps
module crc_snapshot_observer(
 input wire video_clk,input wire rst_all,input wire [3:0] compact_status_page,
 input wire [15:0] pcm_last_crc,input wire [15:0] pcm_crc_block,
 input wire [23:0] pcm_observed_samples,input wire [23:0] audio_underflow_count,
 output reg [15:0] pcm_crc_snapshot,output reg [15:0] pcm_block_snapshot,
 output reg [23:0] pcm_count_snapshot,output reg [23:0] underflow_count_snapshot
);
reg [3:0] diag_page_previous;
$crcBlock
endmodule
"@
$crcWrapperPath=Join-Path $results 'crc_snapshot_observer.generated.v'
[IO.File]::WriteAllText($crcWrapperPath,$crcWrapper,[Text.UTF8Encoding]::new($false))

$sdStart=$topText.IndexOf('always @(posedge sd_card_clk or posedge rst_all) begin',$crcMarker,[StringComparison]::Ordinal)
if($sdStart -lt 0){throw 'SD observer always block start not found in top'}
$sdTail=$topText.Substring($sdStart)
$sdPattern='(?s)^always\s*@\(posedge\s+sd_card_clk\s+or\s+posedge\s+rst_all\)\s*begin.*?\r?\nend(?=\r?\n// Passive board diagnostics)'
$sdMatch=[regex]::Match($sdTail,$sdPattern)
if(-not $sdMatch.Success){throw 'SD wait/FIFO observer always block extraction failed'}
$sdBlock=$sdMatch.Value
$sdHash=[Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($sdBlock)))
$sdWrapper=@"
``timescale 1ns/1ps
module audio_sd_observer(
 input wire sd_card_clk,input wire rst_all,input wire wav_card_read,input wire wav_card_valid,
 input wire wav_sample_take,input wire [12:0] wav_fifo_level,
 output reg [23:0] wav_first_wait_cycles,output reg [23:0] wav_max_first_wait_cycles,
 output reg wav_first_wait_active,output reg wav_read_previous,output reg diag_wav_started,
 output reg [11:0] wav_fifo_lowwater
);
$sdBlock
endmodule
"@
$sdWrapperPath=Join-Path $results 'audio_sd_observer.generated.v'
[IO.File]::WriteAllText($sdWrapperPath,$sdWrapper,[Text.UTF8Encoding]::new($false))

$commonHashes=[ordered]@{}
foreach($file in @('wav_pcm_bridge.v','player_audio_probe.v','tf_wav_file_player.v','top_tf_hdmi_audio.v','player_compact_status_pages.v')){
    $commonHashes[$file]=[ordered]@{c21=(Get-FileHash (Join-Path $c21 $file)).Hash;c22=(Get-FileHash (Join-Path $c22 $file)).Hash}
}

$tests=@(
    @{name='tb_player_compact_status_pages';tb=(Join-Path $PSScriptRoot 'tb_player_compact_status_pages.v');sources=@((Join-Path $c22 'player_compact_status_pages.v'))},
    @{name='tb_audio_crc_snapshot';tb=(Join-Path $PSScriptRoot 'tb_audio_crc_snapshot.v');sources=@((Join-Path $c22 'player_compact_status_pages.v'),$crcWrapperPath)},
    @{name='tb_audio_sd_observer';tb=(Join-Path $PSScriptRoot 'tb_audio_sd_observer.v');sources=@($sdWrapperPath)}
)
$testResults=@()
foreach($test in $tests){
    $image=Join-Path $results ($test.name+'.vvp')
    $compileLog=Join-Path $results ($test.name+'_compile.log')
    $simLog=Join-Path $results ($test.name+'_simulation.log')
    $compileArgs=@('-g2012','-s',$test.name,'-o',$image,$test.tb)+$test.sources
    Invoke-LoggedTool "$($test.name) compile" $compileLog $iverilog $compileArgs
    Invoke-LoggedTool "$($test.name) simulation" $simLog $vvp @($image)
    $testResults+=@{name=$test.name;compile_exit_code=0;simulation_exit_code=0;logs=@((Split-Path -Leaf $compileLog),(Split-Path -Leaf $simLog))}
}

$staticLog=Join-Path $results 'static_module_comparison.log'
@("C21/C22 normalized media logic comparison: PASS","Tool versions: $iverilog ; $vvp")+($staticResults|ForEach-Object{"$($_.file): normalized_equal=$($_.normalized_equal); C21=$($_.c21_sha256); C22=$($_.c22_sha256)"}) |
    Set-Content -LiteralPath $staticLog -Encoding utf8
"C22 top SHA256: $((Get-FileHash $topSource).Hash)" | Add-Content -LiteralPath $staticLog -Encoding utf8
"CRC snapshot block SHA256: $crcHash" | Add-Content -LiteralPath $staticLog -Encoding utf8
"SD wait/FIFO observer block SHA256: $sdHash" | Add-Content -LiteralPath $staticLog -Encoding utf8

$summary=[ordered]@{
    date=(Get-Date -Format 'yyyy-MM-dd')
    project='development/player_video22_audio_diag'
    execution=[ordered]@{shell='PowerShell 7';permission='require_escalated';reason='Icarus temp-path failure in restricted execution';result='completed'}
    tool_paths=[ordered]@{iverilog=$iverilog;vvp=$vvp}
    static_module_comparison=$staticResults
    top_sha256=(Get-FileHash $topSource).Hash
    extracted_blocks=[ordered]@{crc_snapshot_sha256=$crcHash;sd_wait_fifo_observer_sha256=$sdHash}
    tests=$testResults
    failed_attempts=@()
}
$summaryPath=Join-Path $results 'summary.json'
$summary|ConvertTo-Json -Depth 8|Set-Content -LiteralPath $summaryPath -Encoding utf8
Write-Host 'PASS: all C22 audio diagnostic Icarus tests completed.'
