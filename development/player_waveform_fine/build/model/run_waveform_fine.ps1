param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $ProjectRoot '../..')).Path
$model = Join-Path $ProjectRoot 'build/model'
$iv = Join-Path $root 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/iverilog.exe'
$vvp = Join-Path $root 'bringup/tf_wav_hdmi/tools/iverilog/app/bin/vvp.exe'
$rtl = Join-Path $ProjectRoot 'src/user_source/hdl_source/player_pcm_waveform.v'
$tb = Join-Path $model 'tb_waveform_fine.v'
$image = Join-Path $model 'wave_fine_sim.vvp'
$compileLog = Join-Path $model 'wave_fine_compile.log'
$log = Join-Path $model 'wave_fine_sim.log'
$report = Join-Path $model 'wave_fine_report.txt'
$receipt = Join-Path $model 'wave_fine_sources.json'
if (!(Test-Path -LiteralPath $iv)) { throw "iverilog missing: $iv" }
if (!(Test-Path -LiteralPath $vvp)) { throw "vvp missing: $vvp" }
Set-Content -LiteralPath $compileLog -Value '' -NoNewline
& $iv -g2012 -Wall -s tb_waveform_fine -o $image $rtl $tb 2>&1 | Tee-Object -FilePath $compileLog
if ($LASTEXITCODE -ne 0) { throw "iverilog exited with $LASTEXITCODE" }
& $vvp $image 2>&1 | Tee-Object -FilePath $log
if ($LASTEXITCODE -ne 0) { throw "vvp exited with $LASTEXITCODE" }
$passMatch = Select-String -LiteralPath $log -Pattern '^MODEL PASS ' | Select-Object -First 1
$result = if ($passMatch) { 'PASS' } else { 'FAIL' }
$rtlHash = (Get-FileHash -LiteralPath $rtl -Algorithm SHA256).Hash.ToLowerInvariant()
$tbHash = (Get-FileHash -LiteralPath $tb -Algorithm SHA256).Hash.ToLowerInvariant()
$manifest = [ordered]@{
    model = 'C11301 waveform fine independent integer gold'
    result = $result
    utc = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')
    rtl_path = [IO.Path]::GetRelativePath($root, $rtl).Replace('\','/')
    rtl_sha256 = $rtlHash
    testbench_path = [IO.Path]::GetRelativePath($root, $tb).Replace('\','/')
    testbench_sha256 = $tbHash
    compile_log = 'development/player_waveform_fine/build/model/wave_fine_compile.log'
    simulation_log = 'development/player_waveform_fine/build/model/wave_fine_sim.log'
}
$manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $receipt -Encoding utf8
$lines = @(
    "C11301 波形精细度模型结果：$result",
    '依据：build/waveform_spec.md；512列、每列2样本、图形横坐标x64..575为一列一点。',
    '极值：1024个有效样本逐点以独立数学floor(pcm16/64)+112并饱和到0..224计算；512个18-bit {max,min}值逐项对比。',
    '向量包含静音列、Q2负数向下取整边界、正负饱和与阶梯音阶电平。',
    '像素：完成57行×512列共29,184个实际DE图形采样；逐像素独立比较Q2区间、相邻中点连线扩展、四档精确颜色和中心背景线。',
    '控制：验证ready bank在VS前不变、活动bank保持完整、freeze丢弃较新ready窗、VS恢复捕获、音源切换原子换源与无替代窗清图；5周期参数化实例验证stale pending与VS清图。',
    "结果证据：仿真$($passMatch.Line)；颜色计数顺序为青/3⁄4/1⁄2/1⁄4。",
    "RTL SHA-256：$rtlHash",
    "TB SHA-256：$tbHash",
    "编译日志：wave_fine_compile.log",
    "仿真日志：wave_fine_sim.log",
    "源码绑定凭据：wave_fine_sources.json",
    '边界：模型验证RTL行为，不代替TD资源/时序映射与实板清晰度验证；生产默认stale门限未等待完整2.5M周期，由5周期参数实例等价验证控制路径。',
    '连线gold：按当前列[min,max]并入前列中点到当前列中点的闭区间；x64不取前列值；Q2垂直距离1/2/3映射3/4、1/2、1/4亮度。'
)
$lines | Set-Content -LiteralPath $report -Encoding utf8
if ($result -ne 'PASS') { throw "Simulation did not report MODEL PASS. See $log" }
Write-Output "MODEL PASS; report=$report; receipt=$receipt"
