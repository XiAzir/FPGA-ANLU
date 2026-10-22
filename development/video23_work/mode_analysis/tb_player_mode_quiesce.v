`timescale 1ns/1ps
module tb_player_mode_quiesce;
  reg sd_clk=0, video_clk=0, rst=1;
  reg request_toggle=0, ack_toggle=0;
  reg physical_idle=1, mount_ready=0;
  wire gate_new_sector, commit_toggle, busy;
  reg mode=0;
  reg [1:0] commit_sync=0;
  reg commit_seen=0;
  integer i;

  always #10 sd_clk=~sd_clk;
  always #17 video_clk=~video_clk;
  always @(posedge video_clk) begin
    if (rst) begin commit_sync<=0; commit_seen<=0; end
    else commit_sync<={commit_sync[0],commit_toggle};
  end

  player_mode_quiesce dut(
    .clk(sd_clk),.rst(rst),.request_toggle_async(request_toggle),
    .ack_toggle_async(ack_toggle),.physical_idle(physical_idle),
    .mount_ready(mount_ready),.gate_new_sector(gate_new_sector),
    .commit_toggle(commit_toggle),.busy(busy));

  task do_switch;
    reg old_commit;
    begin
      old_commit=commit_toggle;
      @(negedge video_clk); request_toggle=~request_toggle;
      wait(gate_new_sector===1'b1);
      if (commit_toggle!==old_commit) begin $display("FAIL commit before drain"); $fatal(1); end
      physical_idle=0;
      repeat(5) @(posedge sd_clk);
      if (commit_toggle!==old_commit) begin $display("FAIL commit while physical sector active"); $fatal(1); end
      physical_idle=1;
      wait(commit_toggle!==old_commit);
      if (!gate_new_sector || !busy) begin $display("FAIL gate dropped before peer ack"); $fatal(1); end
      wait(commit_sync[1]!==commit_seen);
      mode=~mode;
      commit_seen=commit_sync[1];
      repeat(3) @(posedge video_clk);
      ack_toggle=commit_seen;
      wait(gate_new_sector===1'b0);
      if (busy) begin $display("FAIL busy after ack"); $fatal(1); end
    end
  endtask

  initial begin
    #80; @(negedge sd_clk); rst=0;
    // Request before mount: no physical request is gated until catalog ready.
    @(negedge video_clk); request_toggle=~request_toggle;
    repeat(6) @(posedge sd_clk);
    if (gate_new_sector || !busy) begin $display("FAIL pre-mount request policy"); $fatal(1); end
    mount_ready=1;
    wait(gate_new_sector);
    if (commit_toggle) begin $display("FAIL pre-mount commit polarity"); $fatal(1); end
    physical_idle=1;
    wait(commit_toggle);
    wait(commit_sync[1]!==commit_seen);
    mode=~mode; commit_seen=commit_sync[1]; ack_toggle=commit_seen;
    wait(!gate_new_sector);

    for (i=0;i<6;i=i+1) begin
      physical_idle=0;
      do_switch();
      $display("PASS quiesce phase=%0d mode=%0d commit=%0d",i,mode,commit_toggle);
    end
    if (mode!==1'b1) begin $display("FAIL expected six toggles to restore mode"); $fatal(1); end
    $display("PASS quiesce protocol: mount wait, drain gate, commit, peer ack");
    $finish;
  end
endmodule
