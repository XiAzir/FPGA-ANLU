$ErrorActionPreference = 'Stop'
$ffmpeg = 'C:/Users/PENGYUHAO/ffmpeg-8.1.2-essentials_build/bin/ffmpeg.exe'
$outDir = Join-Path $PSScriptRoot 'synthetic'
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$cases = @(
    @{ Name = 'solid_zero_ac'; Filter = 'color=c=0x808080:s=64x64:d=1' },
    @{ Name = 'dc_step_negative'; Filter = 'color=c=white:s=64x64:d=1,drawbox=x=0:y=32:w=64:h=32:color=black:t=fill' },
    @{ Name = 'dense_ac'; Filter = 'nullsrc=s=64x64:d=1,geq=lum=mod(X*13+Y*17\,256):cb=128:cr=128' }
)

foreach ($case in $cases) {
    $output = Join-Path $outDir ($case.Name + '.jpg')
    & $ffmpeg -hide_banner -loglevel error -y -f lavfi -i $case.Filter -frames:v 1 -c:v mjpeg -huffman default -q:v 2 -pix_fmt yuvj420p $output
    if ($LASTEXITCODE -ne 0) { throw "ffmpeg failed for $($case.Name)" }
}

Get-ChildItem $outDir -Filter '*.jpg' | ForEach-Object {
    $hash = Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256
    [pscustomobject]@{ Name = $_.Name; Bytes = $_.Length; SHA256 = $hash.Hash }
} | Format-Table -AutoSize
