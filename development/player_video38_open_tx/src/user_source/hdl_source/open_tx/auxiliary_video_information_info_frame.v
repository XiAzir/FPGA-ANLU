// Verilog-2001 VIC0 equivalent of hdl-util/hdmi's AVI InfoFrame generator.
// Frozen experiment defaults: RGB, no bars, default scan/color fields, VIC=0.
// PB0 checksum is 0x67; PB1=0, PB2=8, PB3=0, PB4(VIC)=0, PB5=0.
module auxiliary_video_information_info_frame (
    output wire [23:0] header,
    output wire [223:0] sub_flat
);
    assign header = 24'h0d0282;

    // Four 56-bit subpackets, each byte group ordered PB0 at bit [7:0].
    assign sub_flat = {168'd0, 8'd0, 8'd0, 8'd0, 8'd0,
                       8'd8, 8'd0, 8'h67};
endmodule
