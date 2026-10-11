param(
    [ValidatePattern('^[A-Z]$')][string]$DriveLetter = 'D',
    [ValidateSet('TEST.WAV')][string]$FileName = 'TEST.WAV'
)
$ErrorActionPreference = 'Stop'

$partition = Get-Partition -DriveLetter $DriveLetter
$disk = $partition | Get-Disk
$volume = Get-Volume -DriveLetter $DriveLetter
if ($volume.FileSystem -ne 'FAT32' -or $volume.DriveType -ne 'Removable' -or $disk.BusType -ne 'USB' -or $disk.IsBoot -or $disk.IsSystem) {
    throw 'Expected a removable FAT32 USB card, distinct from the system disk.'
}
$imagePath = Join-Path ($DriveLetter + ':\') $FileName
$shortName = 'TEST    WAV'
$referencePath = Join-Path $PSScriptRoot '..\card_media\test.wav'
$expectedHash = (Get-FileHash -LiteralPath $referencePath -Algorithm SHA256).Hash
$actualHash = (Get-FileHash -LiteralPath $imagePath -Algorithm SHA256).Hash
if ($expectedHash -ne $actualHash) { throw 'WAV checksum mismatch against generated source.' }

$fileBytes = [IO.File]::ReadAllBytes($imagePath)
if ($fileBytes.Length -ne 768044) { throw "Unexpected WAV length: $($fileBytes.Length)." }
if ([Text.Encoding]::ASCII.GetString($fileBytes, 0, 4) -ne 'RIFF' -or
    [BitConverter]::ToUInt32($fileBytes, 4) -ne 768036 -or
    [Text.Encoding]::ASCII.GetString($fileBytes, 8, 4) -ne 'WAVE' -or
    [Text.Encoding]::ASCII.GetString($fileBytes, 12, 4) -ne 'fmt ' -or
    [BitConverter]::ToUInt32($fileBytes, 16) -ne 16 -or
    [BitConverter]::ToUInt16($fileBytes, 20) -ne 1 -or
    [BitConverter]::ToUInt16($fileBytes, 22) -ne 1 -or
    [BitConverter]::ToUInt32($fileBytes, 24) -ne 48000 -or
    [BitConverter]::ToUInt32($fileBytes, 28) -ne 96000 -or
    [BitConverter]::ToUInt16($fileBytes, 32) -ne 2 -or
    [BitConverter]::ToUInt16($fileBytes, 34) -ne 16 -or
    [Text.Encoding]::ASCII.GetString($fileBytes, 36, 4) -ne 'data' -or
    [BitConverter]::ToUInt32($fileBytes, 40) -ne 768000) {
    throw 'WAV is not canonical 44-byte-header 48 kHz, 16-bit mono PCM.'
}

# Open the volume read-only. All raw reads are aligned to complete 512-byte sectors.
$raw = [IO.FileStream]::new(('\\.\' + $DriveLetter + ':'), [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
try {
    function Read-Bytes([long]$Offset, [int]$Count) {
        if (($Offset % 512) -ne 0 -or ($Count % 512) -ne 0) { throw 'Raw volume read is not sector aligned.' }
        $buffer = [byte[]]::new($Count)
        $null = $raw.Seek($Offset, [IO.SeekOrigin]::Begin)
        $filled = 0
        while ($filled -lt $Count) {
            $n = $raw.Read($buffer, $filled, $Count - $filled)
            if ($n -eq 0) { throw 'Unexpected end of volume.' }
            $filled += $n
        }
        return ,$buffer
    }
    $bytesPerSector = 512
    $boot = Read-Bytes 0 512
    $bytesPerSector = [BitConverter]::ToUInt16($boot, 11)
    $sectorsPerCluster = [int]$boot[13]
    $reservedSectors = [BitConverter]::ToUInt16($boot, 14)
    $fatCount = [int]$boot[16]
    $sectorsPerFat = [BitConverter]::ToUInt32($boot, 36)
    $rootCluster = [BitConverter]::ToUInt32($boot, 44)
    if ($bytesPerSector -ne 512 -or $sectorsPerCluster -lt 1 -or $sectorsPerFat -eq 0 -or $boot[510] -ne 0x55 -or $boot[511] -ne 0xAA) {
        throw 'Unsupported or invalid FAT32 boot sector.'
    }
    $clusterBytes = $bytesPerSector * $sectorsPerCluster
    $dataStartSector = [long]$reservedSectors + [long]$fatCount * $sectorsPerFat
    $fatOffset = [long]$reservedSectors * $bytesPerSector
    function Get-NextCluster([long]$Cluster) {
        $entryOffset = $Cluster * 4
        $sectorOffset = [long][Math]::Floor($entryOffset / $bytesPerSector) * $bytesPerSector
        $fatSector = Read-Bytes ($fatOffset + $sectorOffset) $bytesPerSector
        return ([BitConverter]::ToUInt32($fatSector, [int]($entryOffset % $bytesPerSector)) -band 0x0FFFFFFF)
    }
    $dirCluster = [long]$rootCluster
    $found = $false
    for ($dirCount = 0; $dirCount -lt 128 -and -not $found; $dirCount++) {
        $dirSector = $dataStartSector + ($dirCluster - 2) * $sectorsPerCluster
        $entries = Read-Bytes ($dirSector * $bytesPerSector) $clusterBytes
        for ($pos = 0; $pos -lt $clusterBytes; $pos += 32) {
            if ($entries[$pos] -eq 0) { break }
            if ($entries[$pos] -eq 0xE5 -or $entries[$pos + 11] -eq 0x0F) { continue }
            $name = [Text.Encoding]::ASCII.GetString($entries, $pos, 11)
            if ($name -eq $shortName) {
                $firstCluster = ([long][BitConverter]::ToUInt16($entries, $pos + 20) * 65536) + [BitConverter]::ToUInt16($entries, $pos + 26)
                $fileSize = [BitConverter]::ToUInt32($entries, $pos + 28)
                $found = $true
                break
            }
        }
        if ($found) { break }
        $dirCluster = Get-NextCluster $dirCluster
        if ($dirCluster -ge 0x0FFFFFF8) { break }
        if ($dirCluster -lt 2) { throw 'Invalid root directory chain.' }
    }
    if (-not $found) { throw 'TEST.WAV was not found in the FAT32 root directory as short name TEST    WAV.' }
    if ($fileSize -ne 768044) { throw 'FAT directory length does not match the canonical WAV length.' }
    $clusterCount = [int][Math]::Ceiling($fileSize / $clusterBytes)
    $currentCluster = $firstCluster
    for ($i = 1; $i -lt $clusterCount; $i++) {
        $next = Get-NextCluster $currentCluster
        if ($next -ne $currentCluster + 1) { throw "WAV is fragmented at cluster $currentCluster -> $next." }
        $currentCluster = $next
    }
    if ((Get-NextCluster $currentCluster) -lt 0x0FFFFFF8) { throw 'Unexpected allocation chain length.' }
    $partitionStartSector = [long]($partition.Offset / $bytesPerSector)
    $partitionEndSector = $partitionStartSector + [long][Math]::Ceiling($partition.Size / $bytesPerSector) - 1
    if ($partitionStartSector -gt 131071) { throw 'Partition starts outside the FPGA scan range (first 64 MiB).' }
    $firstPhysicalSector = $partitionStartSector + $dataStartSector + ($firstCluster - 2) * $sectorsPerCluster
    $lastPhysicalSector = $firstPhysicalSector + [long][Math]::Ceiling($fileSize / $bytesPerSector) - 1
    if ($lastPhysicalSector -gt 131071) { throw 'WAV lies outside the FPGA scan range (first 64 MiB).' }
    [pscustomobject]@{
        FileName = $FileName
        DriveLetter = $DriveLetter
        DiskNumber = $disk.Number
        DiskSizeBytes = $disk.Size
        FileSystem = $volume.FileSystem
        PartitionOffsetBytes = $partition.Offset
        PartitionStartSector = $partitionStartSector
        PartitionEndSector = $partitionEndSector
        FileSizeBytes = $fileSize
        DataBytes = 768000
        SHA256 = $actualHash
        BytesPerSector = $bytesPerSector
        SectorsPerCluster = $sectorsPerCluster
        FirstCluster = $firstCluster
        ClusterCount = $clusterCount
        Contiguous = $true
        StartSector = $firstPhysicalSector
        FirstPhysicalSector = $firstPhysicalSector
        LastPhysicalSector = $lastPhysicalSector
        WithinScanRange = $true
    } | ConvertTo-Json
} finally {
    $raw.Dispose()
}
