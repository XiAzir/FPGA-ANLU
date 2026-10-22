$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\..\..\scripts\anlu_tools.ps1')

$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$project = Join-Path $repoRoot 'development\player_video21_diag'
$results = Join-Path $PSScriptRoot 'results'
New-Item -ItemType Directory -Path $results -Force | Out-Null
$iverilog = Resolve-AnluTool -Name 'iverilog'
$vvp = Resolve-AnluTool -Name 'vvp'
$c20Source = Join-Path $repoRoot 'development\player_video20\src\user_source\hdl_source\SD\frame_fifo_write.v'
$diagSource = Join-Path $project 'src\user_source\hdl_source\SD\frame_fifo_write.v'
$jpegAddress = Join-Path $project 'src\user_source\hdl_source\jpeg420_word_address.v'
$pagesSource = Join-Path $project 'src\user_source\hdl_source\player_compact_status_pages.v'
$statusTb = Join-Path $PSScriptRoot 'tb_player_compact_status_pages.v'
$fifoTb = Join-Path $PSScriptRoot 'tb_frame_fifo_write_diff.v'
$captureTb = Join-Path $PSScriptRoot 'tb_first4_capture_observer.v'
$reference = Join-Path $results 'frame_fifo_write_c20_reference.generated.v'
$topSource = Join-Path $project 'src\user_source\hdl_source\top_tf_hdmi_audio.v'
$captureSource = Join-Path $results 'first4_capture_observer.generated.v'

$sourceText = [IO.File]::ReadAllText($c20Source)
$renamedText = [regex]::Replace($sourceText, '(?m)^module\s+frame_fifo_write\b', 'module frame_fifo_write_c20_reference', 1)
if ($renamedText -eq $sourceText) { throw "Could not rename C20 reference module in $c20Source" }
[IO.File]::WriteAllText($reference, $renamedText, [Text.UTF8Encoding]::new($false))

$topText = [IO.File]::ReadAllText($topSource)
$diagMarker = $topText.IndexOf('// Passive board diagnostics.', [StringComparison]::Ordinal)
if ($diagMarker -lt 0) { throw "Diagnostic observer marker missing from $topSource" }
$observerPattern = '(?s)always\s*@\(posedge\s+sd_card_clk\s+or\s+posedge\s+rst_all\)\s*begin.*?\r?\nend(?=\r?\nalways\s*@\(posedge\s+video_clk)'
$observerMatch = [regex]::Match($topText.Substring($diagMarker), $observerPattern)
if (-not $observerMatch.Success) { throw "Could not extract SD-domain first4 observer block from $topSource" }
$observerBlock = $observerMatch.Value
$observerHash = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($observerBlock)))
$wrapper = @"
``timescale 1ns/1ps
module first4_capture_observer (
    input wire sd_card_clk, input wire rst_all,
    input wire [3:0] compact_status_page,
    input wire bmp_card_read, input wire bmp_card_valid, input wire bmp_card_end,
    input wire [31:0] bmp_card_addr, input wire [7:0] bmp_card_data,
    input wire wav_card_read, input wire wav_card_valid, input wire wav_card_end,
    input wire [31:0] wav_card_addr, input wire [7:0] wav_card_data,
    output reg [9:0] diag_bmp_byte, output reg [9:0] diag_wav_byte,
    output reg [31:0] diag_bmp_head, output reg [31:0] diag_wav_head
);
reg [3:0] diag_page_sync0,diag_page_sync1;
$observerBlock
endmodule
"@
[IO.File]::WriteAllText($captureSource, $wrapper, [Text.UTF8Encoding]::new($false))

function Invoke-LoggedTool {
    param([string]$Name, [string]$LogPath, [string]$Exe, [string[]]$Arguments)
    $header = @(
        "Tool: $Exe",
        "Arguments: $($Arguments -join ' ')",
        "Started: $([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss.fff zzz'))"
    )
    $header | Set-Content -LiteralPath $LogPath -Encoding utf8
    & $Exe @Arguments 2>&1 | Tee-Object -FilePath $LogPath -Append
    $code = $LASTEXITCODE
    "ExitCode: $code" | Add-Content -LiteralPath $LogPath -Encoding utf8
    if ($code -ne 0) { throw "$Name failed with exit code $code; see $LogPath" }
}

$statusImage = Join-Path $results 'tb_player_compact_status_pages.vvp'
$statusCompileLog = Join-Path $results 'tb_player_compact_status_pages_compile.log'
$statusSimLog = Join-Path $results 'tb_player_compact_status_pages_simulation.log'
$statusCompile = @('-g2012','-s','tb_player_compact_status_pages','-o',$statusImage,$statusTb,$pagesSource)
Invoke-LoggedTool 'status compile' $statusCompileLog $iverilog $statusCompile
Invoke-LoggedTool 'status simulation' $statusSimLog $vvp @($statusImage)

$fifoImage = Join-Path $results 'tb_frame_fifo_write_diff.vvp'
$fifoCompileLog = Join-Path $results 'tb_frame_fifo_write_diff_compile.log'
$fifoSimLog = Join-Path $results 'tb_frame_fifo_write_diff_simulation.log'
$fifoCompile = @('-g2012','-s','tb_frame_fifo_write_diff','-o',$fifoImage,$fifoTb,$jpegAddress,$diagSource,$reference)
Invoke-LoggedTool 'frame fifo compile' $fifoCompileLog $iverilog $fifoCompile
Invoke-LoggedTool 'frame fifo simulation' $fifoSimLog $vvp @($fifoImage)

"C20 reference SHA256: $((Get-FileHash -LiteralPath $c20Source -Algorithm SHA256).Hash)" |
    Add-Content -LiteralPath $fifoCompileLog -Encoding utf8
"Icarus: $iverilog" | Add-Content -LiteralPath $statusCompileLog -Encoding utf8
"Icarus: $iverilog" | Add-Content -LiteralPath $fifoCompileLog -Encoding utf8
"vvp: $vvp" | Add-Content -LiteralPath $statusSimLog -Encoding utf8
"vvp: $vvp" | Add-Content -LiteralPath $fifoSimLog -Encoding utf8

$captureImage = Join-Path $results 'tb_first4_capture_observer.vvp'
$captureCompileLog = Join-Path $results 'tb_first4_capture_observer_compile.log'
$captureSimLog = Join-Path $results 'tb_first4_capture_observer_simulation.log'
$captureCompile = @('-g2012','-s','tb_first4_capture_observer','-o',$captureImage,$captureTb,$captureSource)
Invoke-LoggedTool 'capture compile' $captureCompileLog $iverilog $captureCompile
Invoke-LoggedTool 'capture simulation' $captureSimLog $vvp @($captureImage)
"top source SHA256: $((Get-FileHash -LiteralPath $topSource -Algorithm SHA256).Hash)" |
    Add-Content -LiteralPath $captureCompileLog -Encoding utf8
"extracted SD observer SHA256: $observerHash" | Add-Content -LiteralPath $captureCompileLog -Encoding utf8
"Icarus: $iverilog" | Add-Content -LiteralPath $captureCompileLog -Encoding utf8
"vvp: $vvp" | Add-Content -LiteralPath $captureSimLog -Encoding utf8
Write-Host 'PASS: all three Icarus verification simulations completed.'
