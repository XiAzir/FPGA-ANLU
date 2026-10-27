param([string]$OutputPath = 'E:/VSCODE-project/FPGA-ANLU/development/video33_work/edid/current.json')

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class AnluDisplayInventory {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct Device {
        public int cb;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string DeviceName;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceString;
        public uint StateFlags;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceID;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)] public string DeviceKey;
    }
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern bool EnumDisplayDevices(string device, uint index, ref Device result, uint flags);
}
'@

$adapters = @()
for ($index = 0; ; $index++) {
    $adapter = New-Object AnluDisplayInventory+Device
    $adapter.cb = [Runtime.InteropServices.Marshal]::SizeOf($adapter)
    if (-not [AnluDisplayInventory]::EnumDisplayDevices($null, $index, [ref]$adapter, 0)) { break }
    $monitors = @()
    for ($monitorIndex = 0; ; $monitorIndex++) {
        $monitor = New-Object AnluDisplayInventory+Device
        $monitor.cb = [Runtime.InteropServices.Marshal]::SizeOf($monitor)
        if (-not [AnluDisplayInventory]::EnumDisplayDevices($adapter.DeviceName, $monitorIndex, [ref]$monitor, 1)) { break }
        $monitors += [pscustomobject]@{
            name = $monitor.DeviceName
            description = $monitor.DeviceString
            state_flags = $monitor.StateFlags
            device_id = $monitor.DeviceID
            device_key = $monitor.DeviceKey
        }
    }
    $adapters += [pscustomobject]@{
        name = $adapter.DeviceName
        description = $adapter.DeviceString
        state_flags = $adapter.StateFlags
        monitors = $monitors
    }
}

$cachedEdids = @()
$displayRoot = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\DISPLAY'
foreach ($modelKey in Get-ChildItem -LiteralPath $displayRoot) {
    foreach ($instanceKey in Get-ChildItem -LiteralPath $modelKey.PSPath) {
        $parameters = Join-Path $instanceKey.PSPath 'Device Parameters'
        $edidValue = Get-ItemProperty -LiteralPath $parameters -Name EDID -ErrorAction SilentlyContinue
        if ($edidValue) {
            $cachedEdids += [pscustomobject]@{
                model_key = $modelKey.PSChildName
                instance_key = $instanceKey.PSChildName
                edid_hex = [Convert]::ToHexString($edidValue.EDID)
            }
        }
    }
}
$result = [pscustomobject]@{
    recorded_at = (Get-Date).ToString('o')
    adapters = $adapters
    cached_edids = $cachedEdids
}
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) | Out-Null
$result | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath $OutputPath -Encoding utf8
$result | ConvertTo-Json -Depth 7
