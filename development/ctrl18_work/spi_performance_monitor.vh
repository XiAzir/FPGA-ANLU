// Passive measurement of the actual controller/arbiter/caller chain, in ns.
time perf_init=0,perf_fs=0,perf_primed=0,perf_first_pixel=0,perf_commit=0;
time perf_card_start=0,perf_card_max=0,perf_card_total=0;
time perf_bmp_start=0,perf_bmp_max=0,perf_bmp_total=0;
time perf_wav_start=0,perf_wav_max=0,perf_wav_total=0;
time perf_last_sclk=0,perf_min_sclk=0;
time perf_data_first=0,perf_data_last=0;
integer perf_card_count=0,perf_card_bytes=0,perf_sector_bytes=0;
integer perf_bmp_count=0,perf_wav_count=0,perf_underruns=0,perf_fifo_min=8192;
integer perf_log,perf_json;
reg perf_card_pending=0,perf_bmp_pending=0,perf_wav_pending=0;
initial perf_log=$fopen("spi_service.csv","w");
always @(posedge dut.sd_dclk) if(!dut.rst_all && !dut.sd_ncs &&
 dut.u_shared_card.sd_card_sec_read_write_m0.state==6) begin
 if(perf_last_sclk!=0) begin
  if(perf_min_sclk==0 || $time-perf_last_sclk<perf_min_sclk) perf_min_sclk=$time-perf_last_sclk;
  if($time-perf_last_sclk<EXPECTED_SCLK_NS) $fatal(1,"SPI clock too fast/glitch");
 end
 perf_last_sclk=$time;
end
always @(posedge dut.frame_write_finish) if(perf_commit==0) perf_commit=$time;
always @(negedge dut.sd_card_clk) if(!dut.rst_all) begin
 if(dut.card_init_done && perf_init==0) perf_init=$time;
 if(dut.fs_ready && perf_fs==0) perf_fs=$time;
 if(dut.wav_primed && perf_primed==0) perf_primed=$time;
 if(dut.sd_card_write_en && perf_first_pixel==0) perf_first_pixel=$time;
 if(dut.audio_underflow) $fatal(1,"SPI performance audio underflow flag");
 if(dut.wav_primed) begin
  if(dut.u_wav_player.fifo_count<perf_fifo_min) perf_fifo_min=dut.u_wav_player.fifo_count;
  if(dut.wav_sample_take && !dut.wav_sample_available) perf_underruns=perf_underruns+1;
 end
 if(!perf_card_pending && dut.shared_card_read) begin
  perf_card_pending=1;perf_card_start=$time;perf_sector_bytes=0;
 end
 if(dut.shared_card_valid) begin
  perf_card_bytes=perf_card_bytes+1;perf_sector_bytes=perf_sector_bytes+1;
  if(perf_data_first==0)perf_data_first=$time;perf_data_last=$time;
 end
 if(perf_card_pending && dut.shared_card_end) begin
  if(perf_sector_bytes!=512) $fatal(1,"SPI sector byte count=%0d",perf_sector_bytes);
  perf_card_count=perf_card_count+1;
  perf_card_total=perf_card_total+($time-perf_card_start);
  if($time-perf_card_start>perf_card_max)perf_card_max=$time-perf_card_start;
  $fdisplay(perf_log,"CARD,%0d,%0d,%0d,%0d",dut.shared_card_addr,perf_card_start,$time,perf_sector_bytes);
  perf_card_pending=0;
 end
 if(!perf_bmp_pending && dut.bmp_phy_read)begin perf_bmp_pending=1;perf_bmp_start=$time;end
 if(perf_bmp_pending && dut.bmp_phy_end) begin
  perf_bmp_count=perf_bmp_count+1;perf_bmp_total=perf_bmp_total+($time-perf_bmp_start);
  if($time-perf_bmp_start>perf_bmp_max)perf_bmp_max=$time-perf_bmp_start;
  $fdisplay(perf_log,"BMP,%0d,%0d,%0d",dut.bmp_phy_addr,perf_bmp_start,$time);
  perf_bmp_pending=0;
 end
 if(!perf_wav_pending && dut.wav_phy_read)begin perf_wav_pending=1;perf_wav_start=$time;end
 if(perf_wav_pending && dut.wav_phy_end) begin
  perf_wav_count=perf_wav_count+1;perf_wav_total=perf_wav_total+($time-perf_wav_start);
  if($time-perf_wav_start>perf_wav_max)perf_wav_max=$time-perf_wav_start;
  $fdisplay(perf_log,"WAV,%0d,%0d,%0d",dut.wav_phy_addr,perf_wav_start,$time);
  perf_wav_pending=0;
 end
end
task check_spi_performance;
begin
 if(dut.sd_crc_bad!=0 || dut.sd_crc_checked<perf_card_count) $fatal(1,"CRC check coverage or bad block");
 if(perf_min_sclk!=EXPECTED_SCLK_NS || perf_underruns!=0) $fatal(1,"SPI rate/underrun");
 if(perf_card_count<3 || perf_bmp_count<1 || perf_wav_count<1) $fatal(1,"SPI service coverage");
 perf_json=$fopen("spi_performance.json","w");
 $fdisplay(perf_json,"{");
 $fdisplay(perf_json,"\"status\":\"PASS\",\"time_unit\":\"ns\",");
 $fdisplay(perf_json,"\"init_ns\":%0d,\"fs_ns\":%0d,\"primed_ns\":%0d,\"first_pixel_ns\":%0d,\"commit_ns\":%0d,",perf_init,perf_fs,perf_primed,perf_first_pixel,perf_commit);
 $fdisplay(perf_json,"\"card_sectors\":%0d,\"card_bytes\":%0d,\"card_max_service_ns\":%0d,\"card_total_service_ns\":%0d,",perf_card_count,perf_card_bytes,perf_card_max,perf_card_total);
 $fdisplay(perf_json,"\"bmp_sectors\":%0d,\"bmp_max_service_ns\":%0d,\"bmp_total_service_ns\":%0d,",perf_bmp_count,perf_bmp_max,perf_bmp_total);
 $fdisplay(perf_json,"\"wav_sectors\":%0d,\"wav_max_service_ns\":%0d,\"wav_total_service_ns\":%0d,",perf_wav_count,perf_wav_max,perf_wav_total);
 $fdisplay(perf_json,"\"crc_checked\":%0d,\"crc_bad\":%0d,\"fifo_min_after_prime\":%0d,\"underruns\":%0d,",dut.sd_crc_checked,dut.sd_crc_bad,perf_fifo_min,perf_underruns);
 $fdisplay(perf_json,"\"first_data_ns\":%0d,\"last_data_ns\":%0d,\"min_sclk_period_ns\":%0d}",perf_data_first,perf_data_last,perf_min_sclk);
 $fclose(perf_json);$fclose(perf_log);
 $display("SPI_PERFORMANCE_PASS sectors=%0d CRC=%0d/%0d underruns=%0d commit_ns=%0d minSCLK_ns=%0d",perf_card_count,dut.sd_crc_checked,dut.sd_crc_bad,perf_underruns,perf_commit,perf_min_sclk);
end
endtask
