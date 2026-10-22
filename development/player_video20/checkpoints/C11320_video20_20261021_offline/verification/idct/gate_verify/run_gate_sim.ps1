$ErrorActionPreference = 'Stop'
$root = (Resolve-Path $PSScriptRoot).Path
$model = 'C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release'
$sim = 'E:/ModelsimSE/win64'
Push-Location $root
try {
    if (Test-Path -LiteralPath (Join-Path $root 'work')) { & (Join-Path $sim 'vdel.exe') -lib work -all *> (Join-Path $root 'vdel.log') }
    & (Join-Path $sim 'vlib.exe') work *> (Join-Path $root 'vlib.log')
    $sources = @(
        (Join-Path $model 'common/al_map_lut.v'),
        (Join-Path $model 'common/al_map_seq.v'),
        (Join-Path $model 'eg4/eg_phy_mslice.v'),
        (Join-Path $model 'eg4/eg_phy_lslice.v'),
        (Join-Path $model 'eg4/eg_phy_mult18.v'),
        (Join-Path $model 'eg4/eg_phy_pad.v'),
        (Join-Path $model 'eg4/eg_phy_config.v'),
        (Join-Path $model 'eg4/eg_phy_dff.v'),
        (Join-Path $model 'eg4/eg_logic_io.v'),
        (Join-Path $model 'eg4/eg_phy_glbl.v'),
        (Join-Path $root 'reports/idct_y_gate.v'),
        (Join-Path $root 'src_v/jpeg_idct_y_reference.v'),
        (Join-Path $root 'tb_gate_compare.sv')
    )
    & (Join-Path $sim 'vlog.exe') -work work @sources *> (Join-Path $root 'compile.log')
    if ($LASTEXITCODE -ne 0) { throw "ModelSim vlog failed with exit $LASTEXITCODE" }
    & (Join-Path $sim 'vsim.exe') -c -lic_noqueue -novopt -do 'run -all; quit -f' work.tb_gate_compare work.glbl *> (Join-Path $root 'sim.log')
    if ($LASTEXITCODE -ne 0) { throw "ModelSim simulation failed with exit $LASTEXITCODE" }
    if (!(Select-String -LiteralPath (Join-Path $root 'sim.log') -SimpleMatch 'GATE_Y_RESULT sent=768 ref=768 gate=768 errors=0' -Quiet)) { throw 'Expected exact 768-sample PASS receipt is absent' }
    Write-Output 'EG4_GATE_Y_MODELsim_PASS samples=768'
}
finally { Pop-Location }
