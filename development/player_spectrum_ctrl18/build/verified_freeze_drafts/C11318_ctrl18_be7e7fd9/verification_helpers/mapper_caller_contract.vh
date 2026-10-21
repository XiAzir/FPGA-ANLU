// Observe the public caller protocol independently of mapper implementation.
reg bmp_req_active=0,wav_req_active=0,wav_desc_active=0;
reg bmp_req_armed=0,wav_req_armed=0;
reg [95:0] bmp_request,wav_request;
reg [63:0] wav_descriptor;
integer bmp_request_checks=0,wav_request_checks=0;
always @(posedge dut.sd_card_clk) begin
 if(dut.rst_all) begin
  bmp_req_active=0;wav_req_active=0;wav_desc_active=0;
  bmp_req_armed=0;wav_req_armed=0;
 end else begin
  if(!dut.fs_ready || dut.fs_error) begin bmp_req_active=0;bmp_req_armed=0;end
  else begin
   if(dut.fs_cluster_shift>7 || dut.fs_cluster_count==0 ||
      dut.fs_cluster_count>32'h0ffffff5 || dut.fs_fat_lba==32'hffffffff ||
      dut.fs_data_lba==32'hffffffff) $fatal(1,"BMP catalog geometry contract");
   if(bmp_req_active && bmp_request!=={dut.bmp_file_cluster,dut.bmp_file_size,dut.bmp_card_addr})
      $fatal(1,"BMP request stability contract");
   if(dut.bmp_card_end) bmp_req_active=0;
   if(!bmp_req_active && !dut.bmp_card_read) bmp_req_armed=1;
   if(!bmp_req_active && bmp_req_armed && dut.bmp_card_read && !dut.bmp_map_error) begin
    bmp_req_active=1;bmp_req_armed=0;
    bmp_request={dut.bmp_file_cluster,dut.bmp_file_size,dut.bmp_card_addr};
    bmp_request_checks=bmp_request_checks+1;
   end
  end
  if(!dut.fs_ready || !dut.fs_wav_found || dut.fs_error) begin
   wav_req_active=0;wav_req_armed=0;wav_desc_active=0;
  end else begin
   if(wav_desc_active && wav_descriptor!=={dut.fs_wav_cluster,dut.fs_wav_size})
      $fatal(1,"WAV static descriptor contract");
   wav_desc_active=1;wav_descriptor={dut.fs_wav_cluster,dut.fs_wav_size};
   if(wav_req_active && wav_request!=={dut.fs_wav_cluster,dut.fs_wav_size,dut.wav_card_addr})
      $fatal(1,"WAV request stability contract");
   if(dut.wav_card_end) wav_req_active=0;
   if(!wav_req_active && !dut.wav_card_read) wav_req_armed=1;
   if(!wav_req_active && wav_req_armed && dut.wav_card_read && !dut.wav_map_error) begin
    wav_req_active=1;wav_req_armed=0;
    wav_request={dut.fs_wav_cluster,dut.fs_wav_size,dut.wav_card_addr};
    wav_request_checks=wav_request_checks+1;
   end
  end
 end
end
task check_mapper_contracts;
begin
 if(bmp_request_checks<2 || wav_request_checks<2) $fatal(1,"Insufficient mapper request coverage");
 $display("MAPPER_CONTRACT_PASS BMP_requests=%0d WAV_requests=%0d",bmp_request_checks,wav_request_checks);
end
endtask
