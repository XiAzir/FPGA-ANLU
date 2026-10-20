`timescale 1ns/1ps
// Stateless inverse of the active-video TMDS transition-minimized symbol.
// Control, guard-band and TERC4 characters are excluded from pixel_valid.
module tmds_rgb_decode(
    input wire [9:0] ch0, input wire [9:0] ch1, input wire [9:0] ch2,
    output wire pixel_valid, output wire [23:0] rgb
);
    function is_control;
        input [9:0] x;
        begin
            is_control=(x==10'h354)||(x==10'h0AB)||(x==10'h154)||(x==10'h2AB);
        end
    endfunction
    function is_terc4;
        input [9:0] x;
        begin
            case(x)
                10'h29C,10'h263,10'h2E4,10'h2E2,10'h171,10'h11E,10'h18E,10'h13C,
                10'h2CC,10'h139,10'h19C,10'h2C6,10'h28E,10'h271,10'h163,10'h2C3:
                    is_terc4=1'b1;
                default: is_terc4=1'b0;
            endcase
        end
    endfunction
    function [7:0] decode_byte;
        input [9:0] x;
        reg [7:0] qm;
        reg [7:0] d;
        integer i;
        begin
            qm=x[7:0] ^ {8{x[9]}};
            d[0]=qm[0];
            for(i=1;i<8;i=i+1)
                d[i]=qm[i] ^ qm[i-1] ^ ~x[8];
            decode_byte=d;
        end
    endfunction
    wire lane0_data=!is_control(ch0)&&!is_terc4(ch0);
    wire lane1_data=!is_control(ch1)&&!is_terc4(ch1)&&(ch1!=10'h133);
    wire lane2_data=!is_control(ch2)&&!is_terc4(ch2)&&(ch2!=10'h133);
    assign pixel_valid=lane0_data&&lane1_data&&lane2_data;
    // HDMI data lane mapping is ch0=blue, ch1=green, ch2=red.
    assign rgb={decode_byte(ch2),decode_byte(ch1),decode_byte(ch0)};
endmodule
