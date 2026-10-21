// Passive proof of the production caller's compile-time header contract.
reg bmp_header_active=0;
reg [96:0] bmp_stable_header;
integer bmp_header_starts=0,bmp_row_checks=0,bmp_byte_checks=0;
wire [96:0] bmp_live_header={dut.u_bmp_file_player.u_scale.source_width,
 dut.u_bmp_file_player.u_scale.source_height,dut.u_bmp_file_player.u_scale.source_top_down,
 dut.u_bmp_file_player.u_scale.pixel_offset,dut.u_bmp_file_player.u_scale.file_size};
always @(posedge dut.sd_card_clk) begin
 if(dut.rst_all) bmp_header_active=0;
 else begin
  if(dut.u_bmp_file_player.scale_start) begin
   if(!dut.u_bmp_file_player.header_ok) $fatal(1,"BMP start without validated header");
   bmp_stable_header=bmp_live_header;bmp_header_active=1;bmp_header_starts=bmp_header_starts+1;
  end else if(dut.u_bmp_file_player.u_scale.state==0) bmp_header_active=0;
  if(bmp_header_active && bmp_stable_header!==bmp_live_header)
   $fatal(1,"BMP header changed while scaler active");
  if(dut.u_bmp_file_player.u_scale.state==3) begin
   if(dut.u_bmp_file_player.u_scale.src_w<1 || dut.u_bmp_file_player.u_scale.src_w>1024 ||
      dut.u_bmp_file_player.u_scale.src_h<1 || dut.u_bmp_file_player.u_scale.src_h>768 ||
      dut.u_bmp_file_player.u_scale.image_end>{1'b0,dut.u_bmp_file_player.file_size})
     $fatal(1,"BMP setup extent contract");
  end
  if(dut.u_bmp_file_player.u_scale.state==6) begin
   bmp_row_checks=bmp_row_checks+1;
   if(dut.u_bmp_file_player.u_scale.physical_row>=dut.u_bmp_file_player.u_scale.src_h ||
      dut.u_bmp_file_player.u_scale.row_address_wide[32]) $fatal(1,"BMP row extent contract");
  end
  if(dut.u_bmp_file_player.u_scale.state==7) begin
   bmp_byte_checks=bmp_byte_checks+1;
   if(dut.u_bmp_file_player.u_scale.src_col>=dut.u_bmp_file_player.u_scale.src_w ||
      dut.u_bmp_file_player.u_scale.component>2 || dut.u_bmp_file_player.u_scale.byte_address_wide[32] ||
      dut.u_bmp_file_player.u_scale.byte_address_wide[31:0]>=dut.u_bmp_file_player.file_size)
     $fatal(1,"BMP byte extent contract");
  end
 end
end
task check_bmp_header_contract;
begin
 if(bmp_header_starts<1 || bmp_row_checks<1 || bmp_byte_checks<1) $fatal(1,"BMP contract coverage");
 $display("BMP_HEADER_CONTRACT_PASS starts=%0d rows=%0d bytes=%0d",bmp_header_starts,bmp_row_checks,bmp_byte_checks);
end
endtask
