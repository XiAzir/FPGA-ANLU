$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$taskRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$taskWorkspace = (Resolve-Path (Join-Path $taskRoot '../..')).Path
$taskSrc = Join-Path $taskRoot 'src/user_source/hdl_source'
$taskSim = Join-Path $taskRoot 'sim/axis_protocol'
$taskOut = Join-Path $taskRoot 'build/axis_model'
New-Item -ItemType Directory -Force -Path $taskOut | Out-Null
$taskIcarus = (Resolve-AnluTool 'iverilog')
$taskVvp = (Resolve-AnluTool 'vvp')
$taskSources = @(
    (Join-Path $taskSrc 'SD/color_bar.v'),
    (Join-Path $taskSrc 'SD/video_timing_data.v'),
    (Join-Path $taskSrc 'SD/video_delay.v'),
    (Join-Path $taskSrc 'video_rgb_to_axis_640x480.v'),
    (Join-Path $taskSim 'video_rgb_to_axis_640x480_old.v'),
    (Join-Path $taskSim 'tb_axis_protocol_fix_audit.v')
)
$taskExe = Join-Path $taskOut 'axis_protocol.vvp'
& $taskIcarus -g2012 -I (Join-Path $taskSrc 'SD') -s tb_axis_protocol_fix_audit -o $taskExe @taskSources *> (Join-Path $taskOut 'compile.log')
if ($LASTEXITCODE -ne 0) { throw 'Actual candidate model compilation failed' }
& $taskVvp $taskExe *> (Join-Path $taskOut 'run.log')
if ($LASTEXITCODE -ne 0) { throw 'Actual candidate model execution failed' }
$taskRun = Get-Content -LiteralPath (Join-Path $taskOut 'run.log') -Raw
if ($taskRun -notmatch 'lines=960 pixels=614400 orig_last=0 fixed_last=960 sof=2 failures=0') { throw 'Missing complete model PASS evidence' }
$taskBindings = @($taskSources + (Join-Path $taskSrc 'SD/video_define.v') | ForEach-Object {
    [ordered]@{path=$_;sha256=(Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash}
})
$taskBindings | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $taskOut 'source_bindings.json') -Encoding utf8
Get-Content -LiteralPath (Join-Path $taskOut 'run.log')
