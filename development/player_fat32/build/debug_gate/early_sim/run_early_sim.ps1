$ErrorActionPreference='Stop'
$simRoot=(Resolve-Path $PSScriptRoot).Path
$taskBin='E:\VSCODE-project\FPGA-ANLU\bringup\tf_wav_hdmi\tools\iverilog\app\bin'
$taskFixture=Join-Path $simRoot 'fixture'

& python (Join-Path $simRoot 'prepare_early_sim.py')
if($LASTEXITCODE -ne 0){throw 'Early-simulation preparation failed'}

# Only plain probe RTL, the extracted clear AL_* modules, and local RAM models
# are supplied. No sim_release/eg4 or encrypted library is included.
$taskOut=Join-Path $simRoot 'probe_early'
$taskSources=@((Join-Path $simRoot 'tb_fat_probe.v'),
              (Join-Path $simRoot 'probe_rtl.v'),
              (Join-Path $simRoot 'al_map_basic_subset.v'),
              (Join-Path $simRoot 'ram_models.v'))
& (Join-Path $taskBin 'iverilog.exe') -g2005 -D FORMAL_VERIFICATION -Wall -s tb_fat_probe `
    -I $taskFixture -o ($taskOut+'.vvp') @taskSources *> ($taskOut+'_compile.log')
if($LASTEXITCODE -ne 0){Get-Content ($taskOut+'_compile.log');throw 'Early-netlist compile failed'}

& (Join-Path $taskBin 'vvp.exe') ($taskOut+'.vvp') "+FIXTURE=$($taskFixture.Replace('\','/'))" *> ($taskOut+'.log')
$taskExit=$LASTEXITCODE
Get-Content ($taskOut+'.log')
if($taskExit -ne 0 -or !(Select-String -LiteralPath ($taskOut+'.log') -Pattern '^PASS probe first256 pixels, samples=' -Quiet)){
    throw "Early-netlist simulation failed (exit=$taskExit)"
}
