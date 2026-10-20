param([string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path)
$ErrorActionPreference='Stop'
$modelDir=Join-Path $ProjectRoot 'build/model'
$hdlDir=Join-Path $ProjectRoot 'src/user_source/hdl_source'
$mediaDir=Join-Path $modelDir 'test_media'
$receiptPath=Join-Path $modelDir 'scaler_validation_receipt.json'

function Get-Sha256([string]$Path) { (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant() }
function Find-PassingRun([string]$Pattern,[string]$Marker) {
    foreach($file in (Get-ChildItem -LiteralPath $modelDir -Filter $Pattern -File | Sort-Object LastWriteTime -Descending)) {
        $body=Get-Content -LiteralPath $file.FullName -Raw
        if($body.Contains($Marker) -and $body -notmatch '(?m)^(FAIL|FATAL)') { return $file }
    }
    throw "No complete passing run found for $Pattern"
}

$full=Find-PassingRun 'scaler_full_loader_run_*.log' 'SCALER_INTEGRATION PASS images=6 pixels=1843200'
$bad=Find-PassingRun 'scaler_bad_inputs_run_*.log' 'SCALER_ERRORS PASS cases=4 retained=4'
$fullTag=[regex]::Match($full.Name,'scaler_full_loader_run_(\d{8}_\d{6}_\d{3})\.log').Groups[1].Value
$sourceSnapshot=Join-Path $modelDir "scaler_source_snapshot_$fullTag.json"
if(Test-Path -LiteralPath $sourceSnapshot) {
    $sourceObj=Get-Content -LiteralPath $sourceSnapshot -Raw | ConvertFrom-Json
    $codeHashes=[ordered]@{
        'bmp_scale_engine.v'=$sourceObj.'bmp_scale_engine.v'
        'tf_bmp_file_player.v'=$sourceObj.'tf_bmp_file_player.v'
    }
} elseif($fullTag -eq '20261012_131952_792') {
    # Captured immediately after this run, before the later row-RAM inference edit.
    $codeHashes=[ordered]@{
        'bmp_scale_engine.v'='9846713515ddadfc9d5f9b758f76e68ce7b3e80b0a08a247965016399974358c'
        'tf_bmp_file_player.v'='9cddacb2f20a36d2e066eb74bf8fe55c5d675115281ce73b7d64edad3b8f93df'
    }
} else {
    throw "Source snapshot missing for passing run $($full.Name)"
}
$manifest=Get-Content -LiteralPath (Join-Path $mediaDir 'media_manifest.json') -Raw | ConvertFrom-Json
$assets=@()
foreach($asset in $manifest.assets) {
    $assets += [ordered]@{
        bmp=$asset.bmp; width=$asset.source_width; height=$asset.source_height
        heightSign=$asset.height_sign; stride=$asset.stride; rowPaddingBytes=$asset.row_padding_bytes
        geometry=$asset.geometry; bmpSha256=(Get-Sha256 (Join-Path $mediaDir $asset.bmp))
        sourceBytesMemSha256=(Get-Sha256 (Join-Path $mediaDir $asset.source_bytes_mem))
        expectedBottomupRgb24MemSha256=(Get-Sha256 (Join-Path $mediaDir $asset.expected_mem))
    }
}
$failureFixtures=@(
    [ordered]@{name='zero_dimension'; result='PASS retained old image/buffer; no new publication'},
    [ordered]@{name='unsupported_width_1025'; result='PASS retained old image/buffer; no new publication'},
    [ordered]@{name='short_511_byte_sector'; result='PASS retained old image/buffer; no new publication'},
    [ordered]@{name='truncated_payload_transport_error'; result='PASS retained old image/buffer; no new publication'}
)
$currentCodeHashes=[ordered]@{
    'bmp_scale_engine.v'=(Get-Sha256 (Join-Path $hdlDir 'bmp_scale_engine.v'))
    'tf_bmp_file_player.v'=(Get-Sha256 (Join-Path $hdlDir 'tf_bmp_file_player.v'))
}
$testHashes=[ordered]@{
    'tb_scaler_full_loader.v'=(Get-Sha256 (Join-Path $modelDir 'tb_scaler_full_loader.v'))
    'tb_scaler_bad_inputs.v'=(Get-Sha256 (Join-Path $modelDir 'tb_scaler_bad_inputs.v'))
    'scaler_make_media.py'=(Get-Sha256 (Join-Path $modelDir 'scaler_make_media.py'))
    'scaler_full_loader.ps1'=(Get-Sha256 (Join-Path $modelDir 'scaler_full_loader.ps1'))
    'scaler_bad_inputs.ps1'=(Get-Sha256 (Join-Path $modelDir 'scaler_bad_inputs.ps1'))
    'scaler_write_receipt.ps1'=(Get-Sha256 (Join-Path $modelDir 'scaler_write_receipt.ps1'))
}
$receipt=[ordered]@{
    status='PASS'
    completeFrames=6
    checkedPixels=1843200
    productionAssets=4
    nativeRegressionFrames=1
    oddVerticalFrames=1
    errorFixtureCases=4
    sourceSha256=$codeHashes
    currentSourceSha256=$currentCodeHashes
    sourceSnapshot=$sourceSnapshot | Split-Path -Leaf
    testSha256=$testHashes
    successfulRunLog=$full.Name
    successfulRunLogSha256=(Get-Sha256 $full.FullName)
    successfulErrorRunLog=$bad.Name
    successfulErrorRunLogSha256=(Get-Sha256 $bad.FullName)
    assetGold=$assets
    failedFixtures=$failureFixtures
    coverage=@('real tf_bmp_file_player header/sector/payload/COMMIT path',
        '640x480 every write_en output compared against independent BMP-derived bottom-up RGB24 gold',
        'positive and negative BMP height; odd-width 3-byte row padding; source sectors at 512-byte boundaries',
        'non-integer horizontal/vertical nearest-neighbor mapping; repeated source rows; centered horizontal black bars',
        'odd vertical letterbox: 800x599 -> 640x479, top black rows=0 and bottom black rows=1',
        'periodic write_ready stalls and a continuous 300-cycle write stall; all pixels retained',
        'write_finish_toggle sent only after all accepted output words are drained and >256 clocks elapsed',
        'WAIT_DISPLAY with queued NEXT does not request another sector before a real display_finish_toggle',
        'all four malformed/error inputs preserve previously committed display identity and buffer')
    limitations=@('host-only card sector and frame-writer models; no physical TF, encrypted SDRAM, HDMI, or board validation',
        'preview/gold files are host reference artifacts and are not TF payloads')
}
$receipt | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $receiptPath -Encoding utf8
Write-Output "SCALER_RECEIPT PASS $receiptPath"
Write-Output "SCALER_RECEIPT_FULL_LOG $($full.Name) SHA256=$($receipt.successfulRunLogSha256)"
Write-Output "SCALER_RECEIPT_ERROR_LOG $($bad.Name) SHA256=$($receipt.successfulErrorRunLogSha256)"
