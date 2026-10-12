// Black-box interface follows the installed ChipWatcher_1.0/cwc.atpl.
// synthesis syn_black_box
module cw_smoke_ip(input [15:0] probe0, input clk);
 localparam string IP_TYPE = "ChipWatcher";
 localparam CWC_BUS_NUM = 1;
 localparam INPUT_PIPE_NUM = 0;
 localparam OUTPUT_PIPE_NUM = 0;
 localparam RAM_DATA_DEPTH = 128;
 localparam CAPTURE_CONTROL = 0;
 localparam integer CWC_BUS_WIDTH [CWC_BUS_NUM-1:0] = {16};
 localparam integer CWC_DATA_ENABLE [CWC_BUS_NUM-1:0] = {1};
 localparam integer CWC_TRIG_ENABLE [CWC_BUS_NUM-1:0] = {1};
endmodule
module cw_smoke_top(input clk, input rst, output led);
 reg [15:0] count;
 always @(posedge clk or posedge rst)
   if (rst) count <= 0;
   else count <= count + 1'b1;
 assign led = count[15];
 cw_smoke_ip u_watch(.clk(clk), .probe0(count));
endmodule
