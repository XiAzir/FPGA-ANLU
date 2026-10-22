param(
    [string]$SourceFile = 'C:/Users/PENGYUHAO/Downloads/只因你太美（鸡你太美）原版.mp4'
)
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$taskFfmpeg = 'E:/JianyingPro/11.2.0.14339/ffmpeg.exe'
New-Item -ItemType Directory -Path "$taskRoot/media","$taskRoot/logs" -Force | Out-Null
$taskVariants = @(
    @('640x480_15fps', 'fps=15,scale=640:360:flags=lanczos,pad=640:480:0:60:black,format=rgb24'),
    @('crop_640x480_15fps', 'fps=15,scale=-2:480:flags=lanczos,crop=640:480,format=rgb24'),
    @('640x480_30fps', 'fps=30,scale=640:360:flags=lanczos,pad=640:480:0:60:black,format=rgb24')
)
foreach ($taskVariant in $taskVariants) {
    & $taskFfmpeg -hide_banner -nostdin -y -ss 16 -i $SourceFile -t 20 -map 0:v:0 -an -vf $taskVariant[1] -f rawvideo "$taskRoot/media/reference_$($taskVariant[0]).rgb" 2>&1 |
        Set-Content -LiteralPath "$taskRoot/logs/prepare_$($taskVariant[0]).log" -Encoding utf8
    if ($LASTEXITCODE -ne 0) { throw "Video extraction failed: $($taskVariant[0])" }
}
& $taskFfmpeg -hide_banner -nostdin -y -f rawvideo -pixel_format rgb24 -video_size 640x480 -framerate 15 -i "$taskRoot/media/reference_640x480_15fps.rgb" -vf 'scale=320:240:flags=lanczos' -an -f rawvideo "$taskRoot/media/reference_320x240_15fps.rgb" 2>&1 |
    Set-Content -LiteralPath "$taskRoot/logs/prepare_320x240.log" -Encoding utf8
if ($LASTEXITCODE -ne 0) { throw '320x240 extraction failed' }
& $taskFfmpeg -hide_banner -nostdin -y -ss 16 -i $SourceFile -t 20 -map 0:a:0 -vn -ar 48000 -ac 1 -c:a pcm_s16le "$taskRoot/media/original_audio_16_36_pcm48k_mono.wav" 2>&1 |
    Set-Content -LiteralPath "$taskRoot/logs/prepare_audio.log" -Encoding utf8
if ($LASTEXITCODE -ne 0) { throw 'Audio extraction failed' }
