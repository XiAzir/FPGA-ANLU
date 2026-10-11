param([ValidatePattern('^[A-Z]$')][string]$DriveLetter = 'D')
$ErrorActionPreference = 'Stop'
$partition = Get-Partition -DriveLetter $DriveLetter
$disk = $partition | Get-Disk
$volume = Get-Volume -DriveLetter $DriveLetter
if ($volume.FileSystem -ne 'FAT32' -or $volume.DriveType -ne 'Removable' -or $disk.BusType -ne 'USB' -or $disk.IsBoot -or $disk.IsSystem) {
    throw 'Expected a removable FAT32 USB card, distinct from the system disk.'
}
$imagePath = $DriveLetter + ':\00_apple.bmp'
$referencePath = Join-Path $PSScriptRoot '..\card_images\00_apple.bmp'
$expectedHash = (Get-FileHash -LiteralPath $referencePath -Algorithm SHA256).Hash
$actualHash = (Get-FileHash -LiteralPath $imagePath -Algorithm SHA256).Hash
if ($expectedHash -ne $actualHash) { throw 'Image checksum mismatch.' }

# Open the volume read-only. No raw writes, deletion, formatting or FAT changes.
$raw = [IO.FileStream]::new(('\\.\' + $DriveLetter + ':'), [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
try {
    function Read-Bytes([long]$Offset, [int]$Count) {
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
        # Read a whole sector to respect raw-volume sector alignment.
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
            if ($name -eq '00_APPLEBMP') {
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
    if (-not $found) { throw '00_apple.bmp was not found in FAT32 root directory.' }
    if ($fileSize -ne 921654) { throw 'Unexpected BMP file length.' }
    $clusterCount = [int][Math]::Ceiling($fileSize / $clusterBytes)
    $currentCluster = $firstCluster
    for ($i = 1; $i -lt $clusterCount; $i++) {
        $next = Get-NextCluster $currentCluster
        if ($next -ne $currentCluster + 1) { throw "BMP is fragmented at cluster $currentCluster -> $next." }
        $currentCluster = $next
    }
    if ((Get-NextCluster $currentCluster) -lt 0x0FFFFFF8) { throw 'Unexpected allocation chain length.' }
    $firstPhysicalSector = [long]($partition.Offset / $bytesPerSector) + $dataStartSector + ($firstCluster - 2) * $sectorsPerCluster
    $lastPhysicalSector = $firstPhysicalSector + [long][Math]::Ceiling($fileSize / $bytesPerSector) - 1
    if ($lastPhysicalSector -gt 131071) { throw 'BMP lies outside the FPGA scan range (first 64 MiB).' }
    [pscustomobject]@{
        DriveLetter = $DriveLetter
        DiskNumber = $disk.Number
        DiskSizeBytes = $disk.Size
        FileSystem = $volume.FileSystem
        PartitionOffsetBytes = $partition.Offset
        FileSizeBytes = $fileSize
        SHA256 = $actualHash
        BytesPerSector = $bytesPerSector
        SectorsPerCluster = $sectorsPerCluster
        FirstCluster = $firstCluster
        ClusterCount = $clusterCount
        Contiguous = $true
        FirstPhysicalSector = $firstPhysicalSector
        LastPhysicalSector = $lastPhysicalSector
        WithinScanRange = $true
    } | ConvertTo-Json
} finally {
    $raw.Dispose()
}
