$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../scripts/anlu_tools.ps1')
$taskIverilog = Resolve-AnluTool -Name iverilog
$taskVvp = Resolve-AnluTool -Name vvp
$taskCandidate = Join-Path $PSScriptRoot '../player_video34_1080p15/src/user_source/hdl_source/jpeg420_word_address.v'
$taskBaseline = Join-Path $PSScriptRoot '../player_video32_read_return/src/user_source/hdl_source/jpeg420_word_address.v'
$taskBench = Join-Path $PSScriptRoot 'tb_jpeg420_geometry.v'
$taskOutput = Join-Path $PSScriptRoot 'geometry'
New-Item -ItemType Directory -Force -Path $taskOutput | Out-Null
$taskCases = @(
    @{Name='c32_640_565';Width=640;Height=480;RGB565=1;Old=1;Pass=$true},
    @{Name='c34_640_565';Width=640;Height=480;RGB565=1;Old=0;Pass=$true},
    @{Name='c32_640_888';Width=640;Height=480;RGB565=0;Old=1;Pass=$true},
    @{Name='c34_640_888';Width=640;Height=480;RGB565=0;Old=0;Pass=$true},
    @{Name='c32_1080_negative';Width=1920;Height=1080;RGB565=1;Old=1;Pass=$false},
    @{Name='c34_1080_565';Width=1920;Height=1080;RGB565=1;Old=0;Pass=$true}
)
$taskResults = foreach ($taskCase in $taskCases) {
    $taskProgram = Join-Path $taskOutput ($taskCase.Name+'.vvp')
    $taskLog = Join-Path $taskOutput ($taskCase.Name+'.log')
    $taskSource = if ($taskCase.Old) {$taskBaseline} else {$taskCandidate}
    & $taskIverilog -g2012 -s tb_jpeg420_geometry -o $taskProgram `
        ('-Ptb_jpeg420_geometry.WIDTH='+$taskCase.Width) `
        ('-Ptb_jpeg420_geometry.HEIGHT='+$taskCase.Height) `
        ('-Ptb_jpeg420_geometry.RGB565='+$taskCase.RGB565) `
        ('-Ptb_jpeg420_geometry.OLD_SOURCE='+$taskCase.Old) $taskBench $taskSource
    if ($LASTEXITCODE -ne 0) {throw "Compile failed: $($taskCase.Name)"}
    & $taskVvp $taskProgram *> $taskLog
    $taskExit = $LASTEXITCODE
    $taskText = Get-Content -LiteralPath $taskLog -Raw
    if ($taskCase.Pass) {
        if ($taskExit -ne 0 -or $taskText -notmatch '^PASS geometry=') {throw "Positive failed: $taskLog"}
    } elseif ($taskExit -eq 0 -or $taskText -notmatch 'ADDRESS_MISMATCH') {
        throw "Negative control missed: $taskLog"
    }
    Write-Host (Get-Content -LiteralPath $taskLog -TotalCount 1)
    [ordered]@{case=$taskCase;exit=$taskExit;log=$taskLog;source_sha256=(Get-FileHash -LiteralPath $taskSource).Hash}
}
$taskResults | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $taskOutput 'summary.json') -Encoding utf8
