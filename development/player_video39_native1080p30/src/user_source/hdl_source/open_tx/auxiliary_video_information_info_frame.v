// CTA AVI for 1920x1080 progressive / nominal 30Hz, VIC34.
// RGB and other fields match the frozen C38 default; checksum 0x45.
module auxiliary_video_information_info_frame (
    output wire [23:0] header,
    output wire [223:0] sub_flat
);
    assign header = 24'h0d0282;
    assign sub_flat = {168'd0, 8'd0, 8'd0, 8'd34, 8'd0,
                       8'd8, 8'd0, 8'h45};
endmodule
