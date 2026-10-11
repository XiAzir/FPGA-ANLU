param([ValidateSet('synthesis','physical','hold','bitstream')] [string]$Stage='synthesis')
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskTool='C:\Anlogic\TD_6.2.1_SP1_6.2.178.840\bin\td_commands_prompt.exe'
$taskOutput=Join-Path $taskRoot 'build\manual'
New-Item -ItemType Directory -Force -Path $taskOutput | Out-Null
$taskScript=@{synthesis='build_manual_syn.tcl';physical='build_manual_phy.tcl';hold='fix_hold.tcl';bitstream='generate_bit.tcl'}[$Stage]
$taskMarker=@{synthesis='SYNTHESIS_COMPLETE_WITH_GATE_DATABASE';physical='PLACE_ROUTE_COMPLETE_WITH_REPORTS';hold='POST_ROUTE_HOLD_FIX_COMPLETE';bitstream='BITSTREAM_GENERATED'}[$Stage]
$taskLog=Join-Path $taskOutput ($Stage+'_console.log')
& $taskTool ((Join-Path $PSScriptRoot $taskScript).Replace('\','/')) *> $taskLog
$taskExit=$LASTEXITCODE
Get-Content -LiteralPath $taskLog -Tail 12
if($taskExit -ne 0 -or !(Select-String -LiteralPath $taskLog -SimpleMatch $taskMarker -Quiet)) {
    throw "TD $Stage failed; see $taskLog"
}
