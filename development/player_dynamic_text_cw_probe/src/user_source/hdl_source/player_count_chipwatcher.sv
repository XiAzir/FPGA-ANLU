// Interface generated from the installed official ChipWatcher IP template.
// TD insert_debugger resolves this black box before optimize_rtl.
// synthesis syn_black_box
module player_count_chipwatcher(input [31:0] probe0, input [0:0] probe1, input clk);
    localparam string IP_TYPE = "ChipWatcher";
    localparam CWC_BUS_NUM = 2;
    localparam INPUT_PIPE_NUM = 0;
    localparam OUTPUT_PIPE_NUM = 0;
    localparam RAM_DATA_DEPTH = 1024;
    localparam CAPTURE_CONTROL = 0;
    localparam integer CWC_BUS_WIDTH [CWC_BUS_NUM-1:0] = '{32,1};
    localparam integer CWC_DATA_ENABLE [CWC_BUS_NUM-1:0] = '{1,0};
    localparam integer CWC_TRIG_ENABLE [CWC_BUS_NUM-1:0] = '{0,1};
endmodule


