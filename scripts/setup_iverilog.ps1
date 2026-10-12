[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Get-Sha256([string]$Path) {
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Assert-UnderTools([string]$Path, [string]$ToolsRoot) {
    $fullPath = [IO.Path]::GetFullPath($Path)
    $fullRoot = [IO.Path]::GetFullPath($ToolsRoot).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    if ($fullPath.Equals($fullRoot, [StringComparison]::OrdinalIgnoreCase)) { return $fullPath }
    $prefix = $fullRoot + [IO.Path]::DirectorySeparatorChar
    if (-not $fullPath.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "目标路径必须位于项目 tools 目录内：$fullPath"
    }
    return $fullPath
}

function Get-VersionText([string]$Executable, [string[]]$Arguments) {
    $output = @(& $Executable @Arguments 2>&1 | ForEach-Object { $_.ToString() })
    $code = $LASTEXITCODE
    $text = $output -join [Environment]::NewLine
    if ($code -ne 0) { throw "无法读取工具版本（退出码 $code）：$Executable`n$text" }
    return $text
}

function Download-VerifiedArtifact([string]$Url, [string]$ExpectedHash, [string]$Destination, [string]$ToolsRoot) {
    $temporaryPath = Assert-UnderTools ($Destination + '.download-' + [guid]::NewGuid().ToString('N')) $ToolsRoot
    $downloaded = $false
    $webError = $null
    try {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $temporaryPath -SslProtocol Tls12 -TimeoutSec 90
            $downloaded = $true
        } catch {
            $webError = $_.Exception.Message
        }

        if (-not $downloaded) {
            if (Test-Path -LiteralPath $temporaryPath -PathType Leaf) {
                Remove-Item -LiteralPath $temporaryPath -Force
            }
            $curl = Get-Command -Name 'curl.exe' -CommandType Application -ErrorAction SilentlyContinue
            if (-not $curl) {
                throw "Invoke-WebRequest TLS 1.2 失败，且未找到 curl.exe 备用下载器：$webError"
            }
            $curlOutput = @(& $curl.Source '--fail' '--location' '--retry' '2' '--retry-delay' '1' '--connect-timeout' '15' '--max-time' '120' '--output' $temporaryPath $Url 2>&1 | ForEach-Object { $_.ToString() })
            $curlCode = $LASTEXITCODE
            if ($curlCode -ne 0) {
                throw "下载失败：Invoke-WebRequest TLS 1.2 失败（$webError）；curl.exe 退出码 $curlCode。$($curlOutput -join [Environment]::NewLine)"
            }
            $downloaded = $true
        }

        if (-not (Test-Path -LiteralPath $temporaryPath -PathType Leaf)) {
            throw '下载命令成功返回，但没有生成下载文件。'
        }
        $actualHash = Get-Sha256 $temporaryPath
        if ($actualHash -ne $ExpectedHash.ToUpperInvariant()) {
            throw "下载文件 SHA256 不匹配；期望 $($ExpectedHash.ToUpperInvariant())，实际 $actualHash。"
        }
        Move-Item -LiteralPath $temporaryPath -Destination $Destination -Force
    } finally {
        if (Test-Path -LiteralPath $temporaryPath -PathType Leaf) {
            Remove-Item -LiteralPath $temporaryPath -Force
        }
    }
}

function Assert-IcarusVersion([string]$BinDirectory, [string]$ExpectedVersion) {
    $iverilog = Join-Path $BinDirectory 'iverilog.exe'
    $vvp = Join-Path $BinDirectory 'vvp.exe'
    foreach ($exe in @($iverilog, $vvp)) {
        if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) { throw "缺少可执行文件：$exe" }
    }
    $iverilogText = Get-VersionText $iverilog @('-V')
    $vvpText = Get-VersionText $vvp @('-V')
    foreach ($entry in @(@{Name='iverilog'; Text=$iverilogText}, @{Name='vvp'; Text=$vvpText})) {
        $match = [regex]::Match($entry.Text, '(?im)Icarus Verilog(?: runtime)? version\s+([0-9]+\.[0-9]+)')
        if (-not $match.Success -or $match.Groups[1].Value -ne $ExpectedVersion) {
            throw "$($entry.Name) 版本不符，要求 $ExpectedVersion。检测结果：$($entry.Text.Trim())"
        }
    }
    return [pscustomobject]@{ Iverilog=$iverilog; Vvp=$vvp }
}

$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$toolsRoot = Assert-UnderTools (Join-Path $repoRoot 'bringup/tf_wav_hdmi/tools') (Join-Path $repoRoot 'bringup/tf_wav_hdmi/tools')
$provenancePath = Assert-UnderTools (Join-Path $toolsRoot 'provenance.json') $toolsRoot
if (-not (Test-Path -LiteralPath $provenancePath -PathType Leaf)) { throw "未找到工具来源记录：$provenancePath" }
$provenance = Get-Content -LiteralPath $provenancePath -Raw | ConvertFrom-Json

$expectedVersionMatch = [regex]::Match([string]$provenance.IcarusVersion, '([0-9]+\.[0-9]+)')
if (-not $expectedVersionMatch.Success) { throw 'provenance.json 中没有可识别的 Icarus 版本。' }
$expectedVersion = $expectedVersionMatch.Groups[1].Value
$installerName = [IO.Path]::GetFileName(([uri]$provenance.PackageURL).AbsolutePath)
$installerPath = Assert-UnderTools (Join-Path $toolsRoot $installerName) $toolsRoot
$extractorArchivePath = Assert-UnderTools (Join-Path $toolsRoot 'innoextract.zip') $toolsRoot
$extractorRoot = Assert-UnderTools (Join-Path $toolsRoot 'innoextract') $toolsRoot
$extractorPath = Assert-UnderTools (Join-Path $extractorRoot 'innoextract.exe') $toolsRoot
$iverilogRoot = Assert-UnderTools (Join-Path $toolsRoot 'iverilog') $toolsRoot
$iverilogBin = Assert-UnderTools (Join-Path $iverilogRoot 'app/bin') $toolsRoot

if (Test-Path -LiteralPath $iverilogRoot -PathType Container) {
    try {
        $existing = Assert-IcarusVersion $iverilogBin $expectedVersion
        Write-Host "复用已验证的 Icarus $expectedVersion：$($existing.Iverilog)"
    } catch {
        throw "现有 tools/iverilog 目录存在但版本或内容不匹配。脚本保留现有目录，不会递归删除或覆盖；请先人工检查后移走该目录，再重试。详情：$($_.Exception.Message)"
    }
} else {
    foreach ($spec in @(
        @{ Path=$installerPath; Url=[string]$provenance.PackageURL; Hash=[string]$provenance.PackageSHA256 },
        @{ Path=$extractorArchivePath; Url=[string]$provenance.ExtractorURL; Hash=[string]$provenance.ExtractorSHA256 }
    )) {
        if ($spec.Hash -notmatch '^[A-Fa-f0-9]{64}$' -or $spec.Url -notmatch '^https://') {
            throw "来源记录 URL 或 SHA256 格式无效：$($spec.Path)"
        }
        if ((Test-Path -LiteralPath $spec.Path -PathType Leaf) -and (Get-Sha256 $spec.Path) -eq $spec.Hash.ToUpperInvariant()) {
            Write-Host "复用已校验下载：$([IO.Path]::GetFileName($spec.Path))"
            continue
        }
        Write-Host "下载 $([IO.Path]::GetFileName($spec.Path))"
        Download-VerifiedArtifact $spec.Url $spec.Hash $spec.Path $toolsRoot
    }

    New-Item -ItemType Directory -Path $extractorRoot -Force | Out-Null
    $zip = [IO.Compression.ZipFile]::OpenRead($extractorArchivePath)
    try {
        $entries = @($zip.Entries | Where-Object { [IO.Path]::GetFileName($_.FullName) -ieq 'innoextract.exe' })
        if ($entries.Count -ne 1) { throw "innoextract ZIP 中应恰有一个 innoextract.exe，实际 $($entries.Count) 个。" }
        $entry = $entries[0]
        $destination = Assert-UnderTools $extractorPath $toolsRoot
        $inputStream = $entry.Open()
        try {
            $outputStream = [IO.File]::Open($destination, [IO.FileMode]::Create, [IO.FileAccess]::Write, [IO.FileShare]::None)
            try { $inputStream.CopyTo($outputStream) } finally { $outputStream.Dispose() }
        } finally { $inputStream.Dispose() }
    } finally { $zip.Dispose() }

    $extractorVersion = Get-VersionText $extractorPath @('--version')
    if ($extractorVersion -notmatch '(?i)innoextract\s+1\.9') { throw "innoextract 版本不符，要求 1.9：$($extractorVersion.Trim())" }

    $stagingRoot = Assert-UnderTools (Join-Path $toolsRoot ('.iverilog-extract-' + [guid]::NewGuid().ToString('N'))) $toolsRoot
    New-Item -ItemType Directory -Path $stagingRoot | Out-Null
    $extractOutput = @(& $extractorPath '-d' $stagingRoot $installerPath 2>&1 | ForEach-Object { $_.ToString() })
    $extractCode = $LASTEXITCODE
    if ($extractCode -ne 0) { throw "innoextract 失败（退出码 $extractCode）。暂存目录保留供检查：$stagingRoot`n$($extractOutput -join [Environment]::NewLine)" }

    $stagedBin = Assert-UnderTools (Join-Path $stagingRoot 'app/bin') $toolsRoot
    [void](Assert-IcarusVersion $stagedBin $expectedVersion)
    if (Test-Path -LiteralPath $iverilogRoot) { throw "目标安装目录已出现，保留现有内容并停止：$iverilogRoot" }
    Move-Item -LiteralPath $stagingRoot -Destination $iverilogRoot
}

$verified = Assert-IcarusVersion $iverilogBin $expectedVersion
Write-Host "Icarus $expectedVersion 已就绪。"
Write-Host "可设置环境变量：ANLU_IVERILOG_BIN=$($verified.Iverilog | Split-Path -Parent)"
Write-Host '安装程序仅作为归档下载并由 innoextract 解包；未执行安装程序、未改 PATH/注册表，也未读取或修改许可证。'
