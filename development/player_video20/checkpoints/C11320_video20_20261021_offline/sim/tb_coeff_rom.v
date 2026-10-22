module tb_coeff_rom;
  reg clk = 1'b0;
  reg hann_en = 1'b0;
  reg [9:0] hann_addr = 10'd0;
  wire [15:0] hann_q;
  reg twiddle_en = 1'b0;
  reg [8:0] twiddle_addr = 9'd0;
  wire [31:0] twiddle_q;
  reg [15:0] hann_gold [0:1023];
  reg [31:0] twiddle_gold [0:511];
  integer i;

  always #5 clk = ~clk;

  spectrum_coeff_rom dut (
    .clk(clk), .hann_en(hann_en), .hann_addr(hann_addr), .hann_q(hann_q),
    .twiddle_en(twiddle_en), .twiddle_addr(twiddle_addr), .twiddle_q(twiddle_q)
  );

  initial begin
    $readmemh("spectrum_hann.mem", hann_gold);
    $readmemh("spectrum_twiddle.mem", twiddle_gold);
    for (i = 0; i < 1024; i = i + 1) begin
      @(negedge clk);
      hann_en = 1'b1;
      hann_addr = i[9:0];
      twiddle_en = (i < 512);
      twiddle_addr = i[8:0];
      @(posedge clk); #1;
      if (hann_q !== hann_gold[i]) $fatal(1, "Hann mismatch at %0d", i);
      if (i < 512 && twiddle_q !== twiddle_gold[i])
        $fatal(1, "Twiddle mismatch at %0d", i);
    end
    @(negedge clk);
    hann_en = 1'b0;
    twiddle_en = 1'b1;
    twiddle_addr = 9'd123;
    @(posedge clk); #1;
    if (hann_q !== hann_gold[1023]) $fatal(1, "Hann output changed while its enable was low");
    if (twiddle_q !== twiddle_gold[123]) $fatal(1, "Twiddle-only read mismatch");
    @(negedge clk);
    hann_en = 1'b0;
    twiddle_en = 1'b0;
    hann_addr = 10'd17;
    twiddle_addr = 9'd29;
    @(posedge clk); #1;
    if (hann_q !== hann_gold[1023]) $fatal(1, "Hann output did not hold when disabled");
    if (twiddle_q !== twiddle_gold[123]) $fatal(1, "Twiddle output did not hold when disabled");
    $display("PASS: 1024 Hann + 512 twiddle synchronous reads and disabled hold");
    $finish;
  end
endmodule
