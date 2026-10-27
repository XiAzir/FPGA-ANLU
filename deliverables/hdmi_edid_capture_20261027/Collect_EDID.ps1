param([string]$OutputParent = $PSScriptRoot)

$ErrorActionPreference = 'Stop'
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss_fff'
$outputDirectory = Join-Path $OutputParent "EDID_result_$stamp"
New-Item -ItemType Directory -Path $outputDirectory | Out-Null

Write-Host 'Reading active monitors and raw EDID through Windows WMI...'
$monitors = @(Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorID | Where-Object Active)
$descriptors = @(Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorDescriptorMethods)
$records = @()
$summary = @(
    'ANLU HDMI monitor EDID capture'
    "Recorded at: $((Get-Date).ToString('o'))"
    "Active monitors: $($monitors.Count)"
    'Connection: confirm the board-tested monitor is connected to this PC with the same HDMI cable.'
    ''
)

for ($index = 0; $index -lt $monitors.Count; $index++) {
    $monitor = $monitors[$index]
    $name = -join ($monitor.UserFriendlyName | Where-Object { $_ -ne 0 } | ForEach-Object { [char]$_ })
    $descriptor = $descriptors | Where-Object InstanceName -eq $monitor.InstanceName
    $baseReply = Invoke-CimMethod -InputObject $descriptor -MethodName WmiGetMonitorRawEEdidV1Block -Arguments @{ BlockId = [byte]0 }
    [byte[]]$baseBytes = $baseReply.BlockContent
    $extensionCount = [int]$baseBytes[126]
    $raw = New-Object 'System.Collections.Generic.List[byte]'
    $blocks = @()
    $prefix = 'monitor{0:D2}' -f ($index + 1)

    for ($blockIndex = 0; $blockIndex -le $extensionCount; $blockIndex++) {
        if ($blockIndex -eq 0) {
            $reply = $baseReply
        } else {
            $reply = Invoke-CimMethod -InputObject $descriptor -MethodName WmiGetMonitorRawEEdidV1Block -Arguments @{ BlockId = [byte]$blockIndex }
        }
        [byte[]]$bytes = $reply.BlockContent
        $raw.AddRange($bytes)
        $blockName = '{0}_block{1:D2}.bin' -f $prefix, $blockIndex
        [IO.File]::WriteAllBytes((Join-Path $outputDirectory $blockName), $bytes)
        $checksum = ([int]($bytes | Measure-Object -Sum).Sum) % 256
        $blocks += [pscustomobject]@{
            block_index = $blockIndex
            wmi_block_type = $reply.BlockType
            byte_count = $bytes.Length
            checksum_mod256 = $checksum
            file = $blockName
        }
    }

    $rawName = "${prefix}_edid.bin"
    $rawPath = Join-Path $outputDirectory $rawName
    [IO.File]::WriteAllBytes($rawPath, $raw.ToArray())
    $hex = [BitConverter]::ToString($raw.ToArray()).Replace('-', '')
    $hex | Set-Content -LiteralPath (Join-Path $outputDirectory "${prefix}_edid.hex.txt") -Encoding Ascii
    $records += [pscustomobject]@{
        monitor_number = $index + 1
        windows_name = $name
        active = [bool]$monitor.Active
        instance_name = $monitor.InstanceName
        declared_extensions = $extensionCount
        captured_bytes = $raw.Count
        raw_file = $rawName
        sha256 = (Get-FileHash -LiteralPath $rawPath -Algorithm SHA256).Hash.ToLowerInvariant()
        blocks = $blocks
    }
    $summary += @(
        "$prefix : $name"
        "Instance: $($monitor.InstanceName)"
        "EDID bytes: $($raw.Count); declared extensions: $extensionCount"
        "Block checksums (0 expected): $(($blocks.checksum_mod256) -join ', ')"
        ''
    )
    Write-Host "$prefix : $name; EDID $($raw.Count) bytes"
}

$capture = [pscustomobject]@{
    format = 'ANLU_EDID_CAPTURE_V1'
    recorded_at = (Get-Date).ToString('o')
    powershell_version = $PSVersionTable.PSVersion.ToString()
    active_monitor_count = $monitors.Count
    target_monitor_identity = 'To be confirmed by operator; every active monitor is included.'
    monitors = $records
}
$capture | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath (Join-Path $outputDirectory 'capture.json') -Encoding UTF8
$summary | Set-Content -LiteralPath (Join-Path $outputDirectory 'Summary.txt') -Encoding UTF8
$archive = "$outputDirectory.zip"
Compress-Archive -LiteralPath $outputDirectory -DestinationPath $archive -CompressionLevel Optimal
Write-Host ''
Write-Host "Active monitors captured: $($monitors.Count)"
Write-Host 'Send this ZIP back, and identify the monitor used with the FPGA board:'
Write-Host $archive
