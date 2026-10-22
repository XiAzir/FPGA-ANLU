`timescale 1ns/1ps
module tb_video_system;
 parameter MAPPED_SECTORS=300, CHECK_FRAMES=2;
 reg clk=0,rst_n=0,key1=1,key2=1;
 always #10 clk=~clk;
 wire [3:0] led;
 wire seg_d,seg_s,seg_r,hclk,h0,h1,h2,ncs,sck,mosi,miso;
 top dut(.clk(clk),.rst_n(rst_n),.key1(key1),.key2(key2),.led(led),
 .seg7_dio(seg_d),.seg7_sclk(seg_s),.seg7_rclk(seg_r),
 .HDMI_CLK_P(hclk),.HDMI_D0_P(h0),.HDMI_D1_P(h1),.HDMI_D2_P(h2),
 .sd_ncs(ncs),.sd_dclk(sck),.sd_mosi(mosi),.sd_miso(miso));
 wire [31:0] card_commands,card_reads,last_lba;
 wire card_error;
 sd_spi_card_model #(.IMAGE_BYTES(67108864),.MAPPED_SECTORS(MAPPED_SECTORS)) card(
 .cs_n(ncs),.sck(sck),.mosi(mosi),.miso(miso),
 .command_count(card_commands),.read_count(card_reads),.last_lba(last_lba),.protocol_error(card_error));
 reg [15:0] pcm_gold[0:959999];
 reg [23:0] rgb_gold[0:CHECK_FRAMES*307200-1];
 integer consumed=0,pixels=0,commits=0,seen_frames=0;
 integer read_position=0,read_source=0,read_frames=0,ms;
 reg read_eligible=0;
 integer last_source=-1;
 time first_audio,first_display;
 initial begin
  $readmemh("pcm.mem",pcm_gold);$readmemh("rgb.mem",rgb_gold);
  repeat(100)@(negedge clk);rst_n=1;
  wait(!dut.rst_all_reg);
  @(negedge dut.video_clk);force dut.video_mode_press=1'b1;
  @(negedge dut.video_clk);release dut.video_mode_press;
 end
 always @(negedge dut.sd_card_clk) if(!dut.rst_all && dut.video_mode_sd)begin
  if(card_error || dut.fs_error || dut.video_reader_error || dut.bmp_map_error || dut.wav_error || dut.wav_map_error)
   $fatal(1,"video media error fs=%b reader=%b bmap=%b wav=%b wmap=%b",dut.fs_error,dut.video_reader_error,dut.bmp_map_error,dut.wav_error,dut.wav_map_error);
  if(dut.sd_card_write_en)begin
   if(pixels<CHECK_FRAMES*307200 && dut.sd_card_write_data!==rgb_gold[(pixels/307200)*307200+dut.video_pixel_y*640+dut.video_pixel_x])
    $fatal(1,"decoded pixel mismatch n=%0d x/y=%0d/%0d",pixels,dut.video_pixel_x,dut.video_pixel_y);
   pixels=pixels+1;
  end
 end
 always @(posedge dut.frame_write_finish)begin
  commits=commits+1;$display("VIDEO_MEMORY_COMMIT frame=%0d t=%0t pixels=%0d",commits-1,$time,pixels);
 end
 always @(negedge dut.video_clk)if(!dut.rst_all && dut.audio_valid)begin
  if(consumed==0)begin first_audio=$time;$display("VIDEO_AUDIO_START t=%0t",$time);end
  if(dut.audio_left_data!=={pcm_gold[consumed%960000],8'b0} || dut.audio_right_data!=={pcm_gold[consumed%960000],8'b0})
   $fatal(1,"original PCM mismatch n=%0d L=%h R=%h expected=%h",consumed,dut.audio_left_data,dut.audio_right_data,pcm_gold[consumed%960000]);
  consumed=consumed+1;
  if(dut.audio_underflow)$fatal(1,"PCM underflow");
 end
 // The OSD mailbox commits a buffer at the read-request boundary before VS.
 always @(posedge dut.vs)begin
  if(read_eligible && read_position!=307200)$fatal(1,"read frame length %0d",read_position);
  if(read_eligible)read_frames=read_frames+1;
  read_position=0;
  read_source=dut.u_video_schedule.displayed_frame;
  read_eligible=dut.osd_frame_valid && read_source<CHECK_FRAMES;
  if(read_eligible && read_source!=last_source)begin
   if(last_source<0)first_display=$time;
   last_source=read_source;seen_frames=seen_frames+1;
   $display("VIDEO_DISPLAY frame=%0d t=%0t samples=%0d buffer=%0d",read_source,$time,consumed,dut.osd_buffer_idx);
  end
 end
 always @(negedge dut.video_clk)if(!dut.rst_all && dut.de && read_eligible)begin
  if(dut.vout_data_raw!==rgb_gold[read_source*307200+read_position])
   $fatal(1,"framebuffer RGB mismatch frame=%0d pos=%0d got=%h expected=%h",read_source,read_position,dut.vout_data_raw,rgb_gold[read_source*307200+read_position]);
  read_position=read_position+1;
 end
 initial begin
  for(ms=0;ms<300;ms=ms+1)begin
   #1000000;
   if(ms%10==0)$display("VIDEO_PROGRESS ms=%0d state=%0d reader=%0d pixels=%0d commits=%0d display=%0d PCM=%0d sectors=%0d",ms,dut.video_state,dut.u_video_reader.state,pixels,commits,last_source,consumed,card_reads);
   if(seen_frames>=CHECK_FRAMES && read_frames>=5 && consumed>=6400 && read_position==307200)begin
    if(first_audio<first_display)$fatal(1,"audio precedes first visible frame");
    $display("VIDEO_SYSTEM_PASS decoded_pixels=%0d commits=%0d distinct_frames=%0d PCM=%0d underflow=0 late=%b",pixels,commits,seen_frames,consumed,dut.u_video_schedule.frame_late);
    $finish;
   end
  end
  $fatal(1,"video system timeout");
 end
endmodule
