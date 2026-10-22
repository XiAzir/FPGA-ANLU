`timescale 1ns/1ps
module tb_video_system;
parameter MAPPED_SECTORS=300,CHECK_FRAMES=2,IMAGE_BYTES=536870912;
reg clk=0,rst_n=0,key1=1,key2=1;
always #10 clk=~clk;
wire [3:0] led;wire seg_d,seg_s,seg_r,hclk,h0,h1,h2,ncs,sck,mosi,miso;
top dut(.clk(clk),.rst_n(rst_n),.key1(key1),.key2(key2),.led(led),
 .seg7_dio(seg_d),.seg7_sclk(seg_s),.seg7_rclk(seg_r),.HDMI_CLK_P(hclk),
 .HDMI_D0_P(h0),.HDMI_D1_P(h1),.HDMI_D2_P(h2),.sd_ncs(ncs),.sd_dclk(sck),.sd_mosi(mosi),.sd_miso(miso));
wire [31:0] commands,reads,last_lba;wire card_error;
sd_spi_card_model #(.IMAGE_BYTES(IMAGE_BYTES),.MAPPED_SECTORS(MAPPED_SECTORS)) card(
 .cs_n(ncs),.sck(sck),.mosi(mosi),.miso(miso),.command_count(commands),.read_count(reads),.last_lba(last_lba),.protocol_error(card_error));
reg [15:0] pcm_gold[0:959999];
integer pcm_in_session=0,pcm_total=0,session_count=0,cmd0_count=0,transitions=0,ms=0;
reg cmd_req_prev=0,mounted=0;reg [2:0] bmp_baseline;
reg [31:0] wav_cluster_baseline,video_cluster_baseline;
always @(posedge dut.sd_card_clk) begin
 cmd_req_prev<=dut.u_shared_card.cmd_req;
 if(dut.u_shared_card.cmd_req && !cmd_req_prev && dut.u_shared_card.cmd[47:40]==0)cmd0_count=cmd0_count+1;
 if(mounted) begin
  if(!dut.fs_ready || dut.fs_error || !dut.card_init_done)$fatal(1,"persistent mount/card dropped");
  if(dut.fs_bmp_count!==bmp_baseline || dut.fs_wav_cluster!==wav_cluster_baseline || dut.fs_video_cluster!==video_cluster_baseline)$fatal(1,"catalog metadata changed");
  if(dut.sd_crc_bad!=0 || card_error)$fatal(1,"card protocol/CRC failure");
  if(dut.media_reset_active && (dut.u_shared_card.rst || dut.u_catalog.rst))$fatal(1,"media reset reached card/catalog");
 end
 if(!dut.rst_all && (dut.bmp_map_error || dut.wav_map_error || dut.wav_error || dut.video_reader_error))$fatal(1,"consumer error");
end
always @(posedge dut.rst_all) begin pcm_in_session=0;session_count=session_count+1;end
always @(negedge dut.video_clk) if(!dut.rst_all && dut.audio_valid) begin
 if(dut.audio_left_data!=={pcm_gold[pcm_in_session%960000],8'd0} || dut.audio_right_data!=={pcm_gold[pcm_in_session%960000],8'd0})
  $fatal(1,"PCM mismatch session=%0d sample=%0d got=%h expected=%h",session_count,pcm_in_session,dut.audio_left_data,pcm_gold[pcm_in_session%960000]);
 if(dut.audio_underflow)$fatal(1,"PCM underflow");
 pcm_in_session=pcm_in_session+1;pcm_total=pcm_total+1;
end
task switch_mode;
 input wanted;
 begin
  wait(dut.u_shared_card.sd_card_cmd_m0.state==7 && dut.u_shared_card.sd_card_cmd_m0.byte_cnt==37);
  @(negedge dut.video_clk);force dut.video_mode_press=1'b1;
  @(negedge dut.video_clk);release dut.video_mode_press;
  wait(dut.media_reset_active);
  if(dut.video_mode!==wanted)$fatal(1,"wrong mode on commit");
  wait(!dut.rst_all);
  wait(dut.display_valid && pcm_in_session>=256);
  if(dut.video_mode_sd!==wanted || cmd0_count!=1)$fatal(1,"wrong mode or card reinitialized");
  transitions=transitions+1;
  $display("MODE_PASS transition=%0d video=%0d PCM=%0d total=%0d reads=%0d CMD0=%0d crc=%0d/%0d t=%0t",transitions,wanted,pcm_in_session,pcm_total,reads,cmd0_count,dut.sd_crc_checked,dut.sd_crc_bad,$time);
 end
endtask
initial begin
 $readmemh("pcm.mem",pcm_gold);
 repeat(100)@(negedge clk);rst_n=1;
 wait(dut.fs_ready);
 bmp_baseline=dut.fs_bmp_count;wav_cluster_baseline=dut.fs_wav_cluster;video_cluster_baseline=dut.fs_video_cluster;
 mounted=1;
 wait(dut.display_valid && pcm_in_session>=256);
 $display("MODE_COLD_PHOTO PCM=%0d reads=%0d CMD0=%0d t=%0t",pcm_in_session,reads,cmd0_count,$time);
 switch_mode(1);switch_mode(0);switch_mode(1);switch_mode(0);
 if(transitions!=4 || cmd0_count!=1 || pcm_total<1280)$fatal(1,"incomplete mode test");
 $display("VIDEO_SYSTEM_PASS mode_roundtrip transitions=%0d PCM=%0d CMD0=%0d CRC=%0d/%0d",transitions,pcm_total,cmd0_count,dut.sd_crc_checked,dut.sd_crc_bad);
 $finish;
end
initial begin
 for(ms=0;ms<900;ms=ms+1)begin
  #1000000;
  if(ms%25==0)$display("MODE_PROGRESS ms=%0d video=%b state=%d display=%b PCM=%0d gate=%b",ms,dut.video_mode,dut.state_code,dut.display_valid,pcm_in_session,dut.mode_gate_new_sector);
 end
 $fatal(1,"mode system timeout");
end
endmodule
