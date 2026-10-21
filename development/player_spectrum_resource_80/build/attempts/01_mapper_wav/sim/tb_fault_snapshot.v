`timescale 1ns/1ps
module tb_fault_snapshot;
 reg clk=0,rst=1,tone_mode=0,audio_valid=0,axis_valid=0,axis_user=0,hdmi_locked=0;
 reg [23:0] progress=0,accepted=0,events=0,frames=0;
 reg [7:0] control=0;
 wire valid;
 wire [27:0] header;
 wire [23:0] pp,cp,pa,ca,sf,se;
 player_fault_snapshot #(.FFT_WAIT_SAMPLES(4)) dut(.clk(clk),.rst(rst),.tone_mode(tone_mode),.audio_valid(audio_valid),
 .axis_valid(axis_valid),.axis_user(axis_user),.hdmi_locked(hdmi_locked),.progress(progress),.accepted(accepted),
 .events(events),.frames(frames),.control(control),.snapshot_valid(valid),.snapshot_header(header),
 .snapshot_prev_progress(pp),.snapshot_progress(cp),.snapshot_prev_accepted(pa),.snapshot_accepted(ca),
 .snapshot_frames(sf),.snapshot_events(se));
 always #20 clk=~clk;
 integer i,n,checks=0;
 reg [9:0] start_count;
 reg [23:0] start_accepted;
 task tick;begin @(posedge clk);#1;checks=checks+1;@(negedge clk);end endtask
 task reset;
 begin rst=1;tone_mode=0;audio_valid=0;axis_valid=0;axis_user=0;hdmi_locked=0;control=0;progress=0;accepted=0;events=0;frames=0;tick();rst=0;tick();end
 endtask
 task sof;begin axis_valid=1;axis_user=1;tick();axis_valid=0;axis_user=0;tick();end endtask
 initial begin
  for(i=0;i<7;i=i+1)begin
   reset();
   case(i)0:start_count=0;1:start_count=14;2:start_count=15;3:start_count=255;4:start_count=511;5:start_count=1023;default:start_count=10;endcase
   start_accepted=(i==6)?24'hffffff:24'd1234;
   progress={5'd0,start_count,9'd0};accepted=start_accepted;control=8'h10;tick();
   progress={5'd0,(start_count+10'd1),9'd0};accepted=(start_accepted==24'hffffff)?start_accepted:start_accepted+1'b1;
   control=0;tick();
   if(valid)$fatal(1,"false mismatch at boundary i=%0d",i);
  end
  reset();
  progress={5'd0,10'd13,9'd7};accepted=0;control=8'h10;events=24'h000002;tick();
  progress={5'd0,10'd14,9'd7};control=0;tick();
  if(!valid || header[27:24]!=4 || pp!={5'd0,10'd13,9'd7} || cp!==progress || pa!==0 || ca!==0 || se!==events)
   $fatal(1,"mismatch snapshot not atomic header=%h",header);
  progress=24'h123456;accepted=123;events=55;repeat(5)tick();
  if(cp==progress || ca==accepted || se==events)$fatal(1,"frozen evidence changed");
  tone_mode=1;tick();
  if(valid || header!=0)$fatal(1,"source switch did not rearm");
  reset();
  progress={5'd0,10'd13,9'd0};accepted=13;control=8'h10;tick();
  progress=0;accepted=0;control=8'h80;tick();
  if(valid)$fatal(1,"local reset produced false invariant");
  control=0;tick();
  for(n=0;n<4;n=n+1)sof();
  if(!valid || header[27:24]!=2)$fatal(1,"HDMI lock deadline missing");
  reset();control=8'h80;audio_valid=1;repeat(4)tick();audio_valid=0;
  if(!valid || header[27:24]!=3 || header[11:4]!=8'h80)$fatal(1,"FFT reset-stuck deadline missing header=%h",header);
  reset();hdmi_locked=1;frames=2;for(n=0;n<4;n=n+1)sof();
  if(!valid || header[27:24]!=1 || sf!=2)$fatal(1,"healthy snapshot missing");
  hdmi_locked=0;sof();
  if(!valid || header[27:24]!=2)$fatal(1,"later fault did not replace healthy evidence");
  reset();hdmi_locked=1;audio_valid=1;repeat(2)tick();control=8'h08;tick();control=0;repeat(3)tick();
  if(valid)$fatal(1,"frame completion did not reset FFT deadline");
  $display("PASS fault_snapshot checks=%0d counter_boundaries=7 atomic_previous_current=1 freeze=1 source_rearm=1 reset_mask=1 hdmi_deadline=1 fft_deadline=1 healthy_then_fault=1",checks);$finish;
 end
 initial begin #200000;$fatal(1,"timeout");end
endmodule
