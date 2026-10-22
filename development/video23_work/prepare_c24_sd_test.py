from pathlib import Path
p=Path('development/video23_work/mode_analysis')
t=(p/'tb_sd_quiesce_integration.v').read_text(encoding='utf-8-sig').replace('.SPI_HIGH_SPEED_DIV(0)','.SPI_HIGH_SPEED_DIV(2)')
insert='''
  time previous_runtime_edge=0;
  integer runtime_period_checks=0;
  always @(posedge SD_DCLK) begin
    if(card_controller.sd_card_cmd_m0.state==7) begin
      if(previous_runtime_edge!=0) begin
        if($time-previous_runtime_edge!=160) $fatal(1,"SPI period expected160ns actual%0t",$time-previous_runtime_edge);
        runtime_period_checks=runtime_period_checks+1;
      end
      previous_runtime_edge=$time;
    end else previous_runtime_edge=0;
  end
'''
t=t.replace('  integer phase, target_state',insert+'\n  integer phase, target_state')
t=t.replace('$display("PASS negative control: injected one payload bit; CRC bad incremented to 1");','$display("PASS negative control: injected one payload bit; CRC bad incremented to 1");\n    if(runtime_period_checks<1000)$fatal(1,"insufficient SPI period coverage");\n    $display("PASS SPI6.25 periods160ns checks=%0d",runtime_period_checks);')
(p/'tb_sd_quiesce_c24_spi6p25.v').write_text(t,encoding='utf-8')
t=(p/'run_sd_quiesce_c23_actual.ps1').read_text(encoding='utf-8-sig').replace('player_video23_mode_switch','player_video24_spi6p25_diag').replace('tb_sd_quiesce_integration.v\'','tb_sd_quiesce_c24_spi6p25.v\'').replace('tb_sd_quiesce_c23_actual.vvp','tb_sd_quiesce_c24_spi6p25.vvp').replace('sd_quiesce_c23_actual.log','sd_quiesce_c24_spi6p25.log')
(p/'run_sd_quiesce_c24_spi6p25.ps1').write_text(t,encoding='utf-8')
