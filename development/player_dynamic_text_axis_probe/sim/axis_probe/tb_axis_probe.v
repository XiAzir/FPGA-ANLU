`timescale 1ns/1ps
module tb_axis_probe;
  reg clk = 0;
  always #5 clk = ~clk;
  reg rst = 1;
  reg locked = 0;

  // Actual legacy RGB timing + data delay + AXI converter chain. SDRAM is
  // replaced only by a monotonically changing pixel source.
  wire req, hs0, vs0, de0;
  wire read_en, hs, vs, de;
  wire [23:0] rgb;
  reg [23:0] pixel = 0;
  video_timing_data timing(.video_clk(clk), .rst(rst), .read_req(req),
    .read_req_ack(1'b0), .hs(hs0), .vs(vs0), .de(de0));
  video_delay delay_line(.video_clk(clk), .rst(rst), .read_en(read_en),
    .read_data(pixel), .hs(hs0), .vs(vs0), .de(de0),
    .hs_r(hs), .vs_r(vs), .de_r(de), .vout_data(rgb));
  always @(posedge clk) if (!rst && read_en) pixel <= pixel + 24'd1;
  wire a_user, a_valid, a_last;
  wire [23:0] a_data;
  video_rgb_to_axis_640x480 converter(.I_clk(clk), .I_rst(rst),
    .I_vs(vs), .I_de(de), .I_rgb(rgb), .O_video_user(a_user),
    .O_video_valid(a_valid), .O_video_last(a_last), .O_video_data(a_data));
  wire [3:0] a_flags;
  wire [23:0] a_dims, a_period, a_pixels, a_bad, a_gap, a_last_count, a_users;
  player_axis_input_probe actual_observer(.clk(clk), .rst(rst), .valid(a_valid),
    .user(a_user), .last(a_last), .ready(1'b1), .locked(locked), .flags(a_flags),
    .dims(a_dims), .frame_period(a_period), .frame_pixels(a_pixels),
    .bad_counts(a_bad), .gap_ready(a_gap), .frame_last_count(a_last_count),
    .user_frames(a_users));

  reg d_valid=0, d_user=0, d_last=0, d_ready=1, d_locked=0, d_rst=1;
  wire [3:0] d_flags;
  wire [23:0] d_dims, d_period, d_pixels, d_bad, d_gap, d_last_count, d_users;
  player_axis_input_probe #(.WIDTH(4), .HEIGHT(2), .FRAME_CYCLES(20)) directed(
    .clk(clk), .rst(d_rst), .valid(d_valid), .user(d_user), .last(d_last),
    .ready(d_ready), .locked(d_locked), .flags(d_flags), .dims(d_dims),
    .frame_period(d_period), .frame_pixels(d_pixels), .bad_counts(d_bad),
    .gap_ready(d_gap), .frame_last_count(d_last_count), .user_frames(d_users));

  integer chain_users=0;
  always @(posedge clk) if (!rst && a_user && a_valid) chain_users <= chain_users+1;

  task tick;
    begin @(posedge clk); #1; end
  endtask
  task setbeat(input v, input u, input l, input r);
    begin @(negedge clk); d_valid=v; d_user=u; d_last=l; d_ready=r; tick(); end
  endtask
  task dreset;
    begin @(negedge clk); d_rst=1; d_valid=0; d_user=0; d_last=0; d_ready=1;
      repeat(2) tick(); @(negedge clk); d_rst=0; tick(); end
  endtask
  task check(input condition, input [8*100-1:0] label);
    begin if (!condition) begin $display("FAIL %0s", label); $fatal(1); end end
  endtask
  task frame_good(input integer extra_vertical_blank);
    integer k;
    begin
      for (k=0;k<20+extra_vertical_blank;k=k+1) begin
        if (k==0) setbeat(1,1,0,1);
        else if (k>=1 && k<=3) setbeat(1,0,0,1);
        else if (k>=6 && k<=9) setbeat(1,0,0,1);
        else setbeat(0,0,0,1);
      end
    end
  endtask

  integer i;
  initial begin
    repeat(5) tick(); @(negedge clk); rst=0; d_rst=0;
    repeat(120) tick();
    check(a_flags[1:0]==2'b00, "flags show no lock/traffic initially");
    locked=1; tick(); check(a_flags[3:2]==2'b11, "locked and locked_ever");
    locked=0; tick(); check(a_flags[3:2]==2'b01, "locked drops, sticky remains");

    // Two full-frame user boundaries publish the first complete frame.
    dreset();
    frame_good(0); frame_good(0); frame_good(0);
    check(d_dims==24'h004002, "good frame dims 4x2");
    check(d_period==20 && d_pixels==8, "good period and pixel count");
    check(d_bad==0, "good frame has no bad counters");
    check(d_gap[23:12]==2, "intra-frame blank is two cycles, vertical tail skipped");
    check(d_gap[11:0]==0, "ready low count zero");
    check(d_users==24'h000003, "valid frame user count");

    // TLAST is observed, never treated as a protocol requirement.
    dreset();
    setbeat(1,1,1,0); setbeat(1,0,1,1); setbeat(1,0,0,1); setbeat(1,0,0,1);
    setbeat(0,0,0,1); setbeat(0,0,0,1);
    setbeat(1,0,0,0); setbeat(1,0,0,0); setbeat(0,0,0,1);
    setbeat(1,0,0,1); setbeat(1,0,0,1); setbeat(0,0,0,1);
    repeat(6) setbeat(0,0,0,1);
    setbeat(1,1,0,1);
    check(d_last_count==2, "last count reported as observation");
    check(d_gap[11:0]==3, "valid and not-ready count includes SOF");

    // Frame pixel count error alone: 2 rows, one short row, correct period.
    dreset();
    setbeat(1,1,0,1); repeat(3) setbeat(1,0,0,1); setbeat(0,0,0,1);
    repeat(3) setbeat(1,0,0,1); setbeat(0,0,0,1);
    repeat(11) setbeat(0,0,0,1); setbeat(1,1,0,1);
    check(d_bad[11:0]==1 && d_bad[23:12]==1, "short row increments badline and badframe");
    check(d_pixels==7, "short row pixel count");

    // Row count error only, then frame period error only.
    dreset();
    setbeat(1,1,0,1); repeat(3) setbeat(1,0,0,1); setbeat(0,0,0,1);
    repeat(15) setbeat(0,0,0,1); setbeat(1,1,0,1);
    check(d_bad[11:0]==1 && d_pixels==4, "missing row increments badframe only");
    dreset(); frame_good(0); repeat(1) setbeat(0,0,0,1); frame_good(0);
    check(d_bad[11:0]==1 && d_pixels==8, "long frame period increments badframe");

    // Bad USER patterns are recorded while only valid USER delimits frames.
    dreset();
    setbeat(0,1,0,1); setbeat(1,1,0,1); setbeat(1,1,0,1);
    check(d_users[23:12]==2 && d_users[11:0]==2, "nonvalid and in-line user counted bad");

    // Saturation: one long malformed frame creates >4095 short lines and bad frames;
    // user events independently drive the bad-user counter to saturation.
    dreset();
    setbeat(1,1,0,1);
    for (i=0;i<4096;i=i+1) begin
      setbeat(1,0,0,1); setbeat(0,0,0,1);
    end
    repeat(2) setbeat(0,0,0,1); setbeat(1,1,0,1);
    for (i=0;i<4096;i=i+1) setbeat(0,1,0,1);
    check(d_bad[23:12]==12'hfff, "badline saturates at 4095");
    check(d_bad[11:0]==1, "badframe count is independent");
    check(d_users[23:12]==12'hfff, "baduser saturates at 4095");
    check(d_users[11:0]==2, "valid user frame counter remains independent");

    // Repeated malformed frame boundaries saturate badframe and valid user count.
    dreset();
    setbeat(1,1,0,1);
    for (i=0;i<4096;i=i+1) begin
      setbeat(1,0,0,1); setbeat(0,0,0,1); setbeat(1,1,0,1);
    end
    check(d_bad[11:0]==12'hfff, "badframe saturates at 4095");
    check(d_users[11:0]==12'hfff, "valid frame user count saturates at 4095");

    dreset();
    check(d_dims==0 && d_period==0 && d_pixels==0 && d_bad==0 && d_gap==0 &&
      d_last_count==0 && d_users==0 && d_flags==0, "reset clears outputs and sticky flags");

    wait(chain_users >= 3);
    tick();
    check(a_dims==24'h2801e0, "legacy chain dimensions 640x480");
    check(a_period==24'h0668a0, "legacy chain frame period 420000");
    check(a_pixels==24'h04b000, "legacy chain frame pixels 307200");
    check(a_last_count==0, "legacy converter last is observed zero");
    check(a_gap[23:12]==160, "legacy intra-line blank is 160 cycles");
    check(a_bad==0, "legacy chain expected frame has no observer errors");
    check(a_flags[1:0]==2'b11, "actual chain saw valid and user");
    $display("PASS axis observer direct tests and three-frame legacy chain");
    $finish;
  end
endmodule
