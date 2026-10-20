module top (
  input wire clk,
  input wire hann_en,
  input wire [9:0] hann_addr,
  output wire [15:0] hann_q,
  input wire twiddle_en,
  input wire [8:0] twiddle_addr,
  output wire [31:0] twiddle_q
);
  spectrum_coeff_rom u_coefficients (
    .clk(clk), .hann_en(hann_en), .hann_addr(hann_addr), .hann_q(hann_q),
    .twiddle_en(twiddle_en), .twiddle_addr(twiddle_addr), .twiddle_q(twiddle_q)
  );
endmodule
