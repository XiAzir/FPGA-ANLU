`timescale 1ns/1ps
module ready_model #(
  parameter RAW_GATE = 1,
  parameter OMIT_RELEASE = 0
) (
  input rst, input fifo_aclr, input write_clk,
  input full, input [8:0] used,
  output ready
);
  wire ready_reset = rst | fifo_aclr;
  reg [1:0] release_pipe;
  always @(posedge write_clk or posedge ready_reset) begin
    if (ready_reset) release_pipe <= 2'b00;
    else release_pipe <= {release_pipe[0], 1'b1};
  end
  generate
    if (OMIT_RELEASE) begin
      assign ready = (RAW_GATE ? !ready_reset : 1'b1) && !full && (used <= 9'd480);
    end else begin
      assign ready = (RAW_GATE ? !ready_reset : 1'b1) && release_pipe[1] &&
                     !full && (used <= 9'd480);
    end
  endgenerate
endmodule

module tb_write_fifo_ready;
  reg mem_clk=0, write_clk=0;
  reg rst=0, fifo_aclr=0, full=0, write_en=1;
  reg [8:0] used=0;
  wire ready_gated, ready_candidate;
  integer edge_count=0, reset_epoch=0;

  always #5 mem_clk=~mem_clk;
  initial begin #5; forever #10 write_clk=~write_clk; end
  initial begin #1; rst=1; end

  ready_model #(.RAW_GATE(1)) gated (
    .rst(rst), .fifo_aclr(fifo_aclr), .write_clk(write_clk),
    .full(full), .used(used), .ready(ready_gated));
`ifdef NEGATIVE_CONTROL
  ready_model #(.RAW_GATE(1), .OMIT_RELEASE(1)) candidate (
`else
  ready_model #(.RAW_GATE(0)) candidate (
`endif
    .rst(rst), .fifo_aclr(fifo_aclr), .write_clk(write_clk),
    .full(full), .used(used), .ready(ready_candidate));

  // The acceptance decision is sampled by the write-clock domain. #2 checks
  // the settled post-edge value separately from the active-region sample.
  always @(posedge write_clk) begin : sample_ready
    reg accepted_gated, accepted_candidate;
    accepted_gated = write_en && ready_gated;
    accepted_candidate = write_en && ready_candidate;
    edge_count = edge_count + 1;
    if (accepted_gated !== accepted_candidate) begin
      $display("SAMPLED_MISMATCH edge=%0d rst=%b aclr=%b gated=%b candidate=%b", edge_count,rst,fifo_aclr,accepted_gated,accepted_candidate);
      $fatal(1);
    end
    #2;
    if ((rst || fifo_aclr || gated.release_pipe != 2'b11) && write_en && ready_candidate) begin
      $display("EARLY_ACCEPT edge=%0d epoch=%0d rst=%b aclr=%b release=%b",edge_count,reset_epoch,rst,fifo_aclr,candidate.release_pipe);
      $fatal(1);
    end
    if (rst || fifo_aclr) begin
      if (ready_gated || ready_candidate) $fatal(1,"ready asserted during reset");
    end else if (ready_gated !== ready_candidate) begin
      $fatal(1,"settled ready mismatch");
    end
  end

  task automatic pulse_reset(input integer source, input integer phase);
    begin
      // phase 0: one ns before a write edge; 1: same simulation edge;
      // 2: one ns after a write edge; 3: aligned 100 MHz mem edge.
      case (phase)
        0: begin @(negedge write_clk); #9; end
        1: begin @(posedge write_clk); #0; end
        2: begin @(posedge write_clk); #1; end
        3: begin @(posedge mem_clk); #0; end
      endcase
      if (source == 0) rst=1; else fifo_aclr=1;
      reset_epoch=reset_epoch+1;
      #2;
      if (ready_gated || ready_candidate) $fatal(1,"ready not suppressed after reset assertion");
      repeat (3) @(posedge write_clk);
      if (phase == 1) begin
        @(posedge write_clk); #0;
      end else if (phase == 3) begin
        @(posedge mem_clk); #0;
      end else begin
        @(negedge write_clk);
      end
      if (source == 0) rst=0; else fifo_aclr=0;
      // Test release edges in the write domain. Ready must stay low on the
      // first edge and become eligible after the second release edge. A sink
      // sampling on that second edge still sees the pre-edge low value.
      @(posedge write_clk); #1;
      if (ready_candidate) $fatal(1,"ready before first release edge completed");
      @(posedge write_clk); #1;
      if (!ready_candidate || !ready_gated) $fatal(1,"ready failed to recover after two release stages");
    end
  endtask

  initial begin
    repeat (3) @(posedge write_clk);
    #1; rst=0;
    repeat (4) @(posedge write_clk);
    #1;
    if (!ready_gated || !ready_candidate) $fatal(1,"initial ready did not release");
    pulse_reset(0,0);
    pulse_reset(1,1);
    pulse_reset(0,2);
    pulse_reset(1,3);
    full=1; #1;
    if (ready_gated || ready_candidate) $fatal(1,"full FIFO must suppress ready");
    full=0; used=9'd481; #1;
    if (ready_gated || ready_candidate) $fatal(1,"high occupancy must suppress ready");
    used=9'd480; #1;
    if (!ready_gated || !ready_candidate) $fatal(1,"capacity boundary should be ready");
`ifdef NEGATIVE_CONTROL
    $fatal(1,"negative control escaped detection");
`else
    $display("PASS: reset-gate deletion preserves write-clock acceptance and release timing; edges=%0d epochs=%0d",edge_count,reset_epoch);
    $finish;
`endif
  end
endmodule
