$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '../../../scripts/anlu_tools.ps1')
$Work = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Project = (Resolve-Path (Join-Path $PSScriptRoot '../../player_spectrum_resource_fit')).Path
$OldTests = (Resolve-Path (Join-Path $PSScriptRoot '../../player_fat32_autoplay_keepaudio')).Path
$AudioTests = (Resolve-Path (Join-Path $PSScriptRoot '../../player_fat32_audio_probe')).Path
$Iverilog = Resolve-AnluTool -Name 'iverilog'
$Vvp = Resolve-AnluTool -Name 'vvp'
$Run = Join-Path $PSScriptRoot ('run_' + (Get-Date -Format 'yyyyMMdd_HHmmss_fff'))
New-Item -ItemType Directory -Path $Run -Force | Out-Null
$Ref = Join-Path $PSScriptRoot 'reference'
$Opt = Join-Path $PSScriptRoot 'timer_candidate'

function Invoke-Sim([string]$Name, [string[]]$Sources, [string]$Top) {
    $Image = Join-Path $Run "$Name.vvp"
    $Compile = Join-Path $Run "$Name.compile.log"
    $Log = Join-Path $Run "$Name.log"
    & $Iverilog -g2012 -Wall -s $Top -o $Image @Sources *> $Compile
    if ($LASTEXITCODE -ne 0) { throw "Compile failed: $Name ($Compile)" }
    & $Vvp $Image *> $Log
    if ($LASTEXITCODE -ne 0) { throw "Simulation failed: $Name ($Log)" }
    return $Log
}

function Compare-Pair([string]$Name, [string[]]$RefSources, [string[]]$OptSources, [string]$Top) {
    $RefLog = Invoke-Sim "$Name.reference" $RefSources $Top
    $OptLog = Invoke-Sim "$Name.timer_candidate" $OptSources $Top
    $RefLines = @(Get-Content -LiteralPath $RefLog)
    $OptLines = @(Get-Content -LiteralPath $OptLog)
    if (Compare-Object $RefLines $OptLines) { throw "Reference/candidate simulation output differs: $Name" }
    if (!$RefLines.Count) { throw "No public TB output: $Name" }
    Write-Output "PASS $Name output-identical lines=$($RefLines.Count)"
}

# Public BMP failure detail bench: WAIT_LIMIT=1000 and CLK_FREQ_HZ=1000,
# covering watchdog/auto/debounce parameterized paths and all 21 public cases.
$BmpTb = Join-Path $Project 'sim/tb_tf_bmp_failure_detail.v'
$RefBmp = @((Join-Path $Ref 'tf_bmp_file_player.v'),
            (Join-Path $Ref 'bmp_scale_engine.v'),
            (Join-Path $Ref 'SD/sd_card_bmp.v'), $BmpTb)
$OptBmp = @((Join-Path $Opt 'tf_bmp_file_player.v'),
            (Join-Path $Opt 'bmp_scale_engine.v'),
            (Join-Path $Opt 'SD/sd_card_bmp.v'), $BmpTb)
Compare-Pair 'bmp_failure_detail_21' $RefBmp $OptBmp 'tb_tf_bmp_failure_detail'

# Public mapper edge and maximum-chain benches expect these two module names.
$MapperRefText = (Get-Content -LiteralPath (Join-Path $Ref 'fat32_file_sector.v') -Raw).Replace(
    'module fat32_file_sector #(', 'module fat32_file_sector_reference #(')
$MapperOptText = (Get-Content -LiteralPath (Join-Path $Opt 'fat32_file_sector.v') -Raw).Replace(
    'module fat32_file_sector #(', 'module fat32_file_sector_proposal #(')
$MapperRefProposalText = (Get-Content -LiteralPath (Join-Path $Ref 'fat32_file_sector.v') -Raw).Replace(
    'module fat32_file_sector #(', 'module fat32_file_sector_proposal #(')
$MapperRefAlias = Join-Path $Run 'mapper_reference.v'
$MapperRefProposalAlias = Join-Path $Run 'mapper_reference_proposal.v'
$MapperOptAlias = Join-Path $Run 'mapper_timer_candidate.v'
Set-Content -LiteralPath $MapperRefAlias -Value $MapperRefText -Encoding utf8NoBOM
Set-Content -LiteralPath $MapperRefProposalAlias -Value $MapperRefProposalText -Encoding utf8NoBOM
Set-Content -LiteralPath $MapperOptAlias -Value $MapperOptText -Encoding utf8NoBOM
foreach ($TbName in @('tb_mapper_edges', 'tb_mapper_long_equiv')) {
    $Tb = Join-Path $Work "$TbName.v"
    Compare-Pair $TbName @($MapperRefAlias,$MapperRefProposalAlias,$Tb) `
        @($MapperRefAlias,$MapperOptAlias,$Tb) $TbName
}

# Existing public mapper interface/timeout bench.
$LegacyMapperTb = Join-Path $AudioTests 'sim/tb_fat32_file_sector.v'
Compare-Pair 'mapper_public' @((Join-Path $Ref 'fat32_file_sector.v'),$LegacyMapperTb) `
    @((Join-Path $Opt 'fat32_file_sector.v'),$LegacyMapperTb) 'tb_fat32_file_sector'

# Existing key/audio-control and audio-probe public benches.
$KeyControlTb = Join-Path $OldTests 'sim/tb_autoplay_audio_key.v'
$AudioTb = Join-Path $AudioTests 'sim/tb_player_audio_probe.v'
$AudioDeps = @((Join-Path $AudioTests 'src/user_source/hdl_source/wav_pcm_bridge.v'),
               (Join-Path $AudioTests 'src/user_source/hdl_source/hdmi_audio_tone_pcm_scale.v'),
               (Join-Path $AudioTests 'src/user_source/hdl_source/audio_arc_calculate.v'))
$RefKeyAudio = @($KeyControlTb,(Join-Path $Ref 'SD/sd_card_bmp.v'),
                 (Join-Path $Ref 'player_audio_probe.v')) + $AudioDeps
$OptKeyAudio = @($KeyControlTb,(Join-Path $Opt 'SD/sd_card_bmp.v'),
                 (Join-Path $Opt 'player_audio_probe.v')) + $AudioDeps
Compare-Pair 'key_debounce_audio_control' $RefKeyAudio $OptKeyAudio 'tb_autoplay_audio_key'
$RefAudio = @($AudioTb,(Join-Path $Ref 'player_audio_probe.v')) + $AudioDeps
$OptAudio = @($AudioTb,(Join-Path $Opt 'player_audio_probe.v')) + $AudioDeps
Compare-Pair 'audio_probe' $RefAudio $OptAudio 'tb_player_audio_probe'

# Small-parameter paired cycle checks exercise timer wrap/reset edges quickly.
$KeyStartText = (Get-Content -LiteralPath (Join-Path $Ref 'SD/sd_card_bmp.v') -Raw)
$KeyStart = $KeyStartText.IndexOf('module key_press_debounce #(')
$KeyText = $KeyStartText.Substring($KeyStart)
$RefKeyAlias = Join-Path $Run 'key_debounce_reference.v'
$OptKeyAlias = Join-Path $Run 'key_debounce_timer_candidate.v'
Set-Content -LiteralPath $RefKeyAlias -Value $KeyText.Replace(
    'module key_press_debounce #(', 'module key_press_debounce_reference #(') -Encoding utf8NoBOM
$OptKeyText = (Get-Content -LiteralPath (Join-Path $Opt 'SD/sd_card_bmp.v') -Raw)
$OptKeyStart = $OptKeyText.IndexOf('module key_press_debounce #(')
Set-Content -LiteralPath $OptKeyAlias -Value $OptKeyText.Substring($OptKeyStart) -Encoding utf8NoBOM
$KeyEqTb = Join-Path $PSScriptRoot 'tb_key_debounce_equiv.v'
Compare-Pair 'key_debounce_small_cycle_diff' @($RefKeyAlias,$OptKeyAlias,$KeyEqTb) `
    @($RefKeyAlias,$OptKeyAlias,$KeyEqTb) 'tb_key_debounce_equiv'

$RefAudioAlias = Join-Path $Run 'player_audio_probe_reference.v'
$OptAudioAlias = Join-Path $Run 'player_audio_probe_timer_candidate.v'
Set-Content -LiteralPath $RefAudioAlias -Value (Get-Content -LiteralPath (Join-Path $Ref 'player_audio_probe.v') -Raw).Replace(
    'module player_audio_probe #(', 'module player_audio_probe_reference #(') -Encoding utf8NoBOM
Set-Content -LiteralPath $OptAudioAlias -Value (Get-Content -LiteralPath (Join-Path $Opt 'player_audio_probe.v') -Raw) -Encoding utf8NoBOM
$BlinkEqTb = Join-Path $PSScriptRoot 'tb_audio_blink_equiv.v'
$BlinkDeps = @((Join-Path $AudioTests 'src/user_source/hdl_source/wav_pcm_bridge.v'),
               (Join-Path $AudioTests 'src/user_source/hdl_source/hdmi_audio_tone_pcm_scale.v'),
               (Join-Path $AudioTests 'src/user_source/hdl_source/audio_arc_calculate.v'))
Compare-Pair 'audio_blink_small_cycle_diff' (@($RefAudioAlias,$OptAudioAlias,$BlinkEqTb) + $BlinkDeps) `
    (@($RefAudioAlias,$OptAudioAlias,$BlinkEqTb) + $BlinkDeps) 'tb_audio_blink_equiv'

Write-Output "TIMER_PUBLIC_TB_PASS run=$Run"
