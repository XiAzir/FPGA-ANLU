`include "global_def.v"
module tb_sdram_macros;
initial begin
  $display("SDR_CLK_PERIOD=%0d", `SDR_CLK_PERIOD);
  $display("SELF_REFRESH_INTERVAL_EXPANDED=%0d", `SELF_REFRESH_INTERVAL);
  $display("PARENTHESIZED_TARGET=%0d", 64000000/(`SDR_CLK_PERIOD)/2**(`ROW_WIDTH));
  $finish;
end
endmodule
