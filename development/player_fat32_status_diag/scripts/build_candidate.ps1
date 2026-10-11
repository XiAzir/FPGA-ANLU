param([ValidateSet('synthesis','physical','hold','bitstream')] [string]$Stage='synthesis')
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskTool=(Resolve-AnluTool 'td_commands_prompt')
$taskOutput=Join-Path $taskRoot 'build\manual'
New-Item -ItemType Directory -Force -Path $taskOutput | Out-Null
if($Stage -eq 'bitstream') {
    $taskTiming=Get-Content -Raw -LiteralPath (Join-Path $taskOutput 'AC201_tf_hdmi_phy.ts')
    $taskMatch=[regex]::Match($taskTiming,'SWNS:\s*([-\d.]+)ns, STNS:\s*([-\d.]+)ns\.\s*HWNS:\s*([-\d.]+)ns, HTNS:\s*([-\d.]+)ns\.')
    if(!$taskMatch.Success) { throw 'Missing recognizable final timing status; do not generate bitstream' }
    foreach($taskGroup in 1..4) {
        if([double]$taskMatch.Groups[$taskGroup].Value -lt 0) { throw 'Timing violation remains; do not generate bitstream' }
    }
}
$taskScript=@{synthesis='build_manual_syn.tcl';physical='build_manual_phy.tcl';hold='fix_hold.tcl';bitstream='generate_bit.tcl'}[$Stage]
$taskMarker=@{synthesis='SYNTHESIS_COMPLETE_WITH_GATE_DATABASE';physical='PLACE_ROUTE_COMPLETE_WITH_REPORTS';hold='POST_ROUTE_HOLD_FIX_COMPLETE';bitstream='BITSTREAM_GENERATED'}[$Stage]
$taskLog=Join-Path $taskOutput ($Stage+'_console.log')
$taskAlPath = Join-Path $taskRoot 'src/td_project/AC201_tf_hdmi.al'
$taskAlLocation = Get-AnluProjectLocation $taskAlPath
try {
    & $taskTool ((Join-Path $PSScriptRoot $taskScript).Replace('\','/')) *> $taskLog
    $taskExit=$LASTEXITCODE
} finally {
    # TD rewrites only this location during open_project; retain all other source guards.
    Restore-AnluProjectLocation $taskAlPath $taskAlLocation
}
Get-Content -LiteralPath $taskLog -Tail 12
if($taskExit -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch $taskMarker -Quiet)) {
    throw "TD $Stage failed; see $taskLog"
}

