`timescale 1ns/1ps
module tb_prefix_refresh_req;
  parameter integer EXPECTED_PULSES = 0;
  reg clk = 0;
  reg rst = 1;
  reg init_req = 0;
  wire init_done;
  wire init_ref_vld;
  wire init_ref_ras, init_ref_cas, init_ref_we;
  wire [1:0] init_ref_ba;
  wire [11:0] init_ref_addr;
  wire ref_req;
  integer cycle;
  integer pulse_count = 0;

  always #10 clk = ~clk;

  sdr_init_ref #(.self_refresh_open(1)) dut (
    .Sdr_clk(clk), .Rst(rst), .Sdr_init_req(init_req), .Sdr_init_mode(4'd0),
    .Sdr_init_done(init_done), .App_ref_req(1'b0), .Sdr_ref_req(ref_req),
    .Sdr_ref_ack(1'b0), .Sdr_rw_vld(1'b0), .Sdr_init_ref_vld(init_ref_vld),
    .Sdr_init_ref_ras(init_ref_ras), .Sdr_init_ref_cas(init_ref_cas),
    .Sdr_init_ref_we(init_ref_we), .Sdr_init_ref_ba(init_ref_ba),
    .Sdr_init_ref_addr(init_ref_addr)
  );

  initial begin
    $display("SDR_CLK_PERIOD=%0d SELF_REFRESH_INTERVAL=%0d PARENTHESIZED_TARGET=%0d",
      `SDR_CLK_PERIOD, `SELF_REFRESH_INTERVAL,
      64000000/(`SDR_CLK_PERIOD)/2**(`ROW_WIDTH));
    repeat (3) @(posedge clk);
    #1 rst = 0;
    force dut.init_done = 1'b1; // isolate the public refresh prefix from init latency
    for (cycle = 1; cycle <= 5000; cycle = cycle + 1) begin
      @(posedge clk);
      #1;
      if (ref_req) begin
        pulse_count = pulse_count + 1;
        $display("REF_REQ_PULSE cycle=%0d", cycle);
      end
    end
    release dut.init_done;
    $display("PULSE_COUNT=%0d EXPECTED=%0d", pulse_count, EXPECTED_PULSES);
    if (pulse_count != EXPECTED_PULSES) $fatal(1, "unexpected public-prefix pulse count");
    $display("PUBLIC_PREFIX_PASS");
    $finish;
  end
endmodule
