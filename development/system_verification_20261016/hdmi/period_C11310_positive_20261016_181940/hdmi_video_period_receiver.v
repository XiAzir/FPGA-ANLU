`timescale 1ns/1ps
// Verification receiver for the configured 640-pixel HDMI active line.
// Determine period from control preamble and video guard bands. During active
// video do not filter symbols by TERC4/control-code membership: those overlap.
module hdmi_video_period_receiver # (parameter HACTIVE=640)(
 input word_clk,rst,input [9:0] ch0,ch1,ch2,
 output reg pixel_valid,output reg [23:0] rgb,
 output reg [31:0] pixel_line,pixel_column,
 output reg [31:0] rows_completed,protocol_errors);
 localparam SEARCH=0,GUARD1=1,GUARD2=2,VIDEO=3,POST=4;
 reg [2:0] state;
 integer preamble_count,column;
 function control;input[9:0] x;begin
  control=x==10'h354 || x==10'h0ab || x==10'h154 || x==10'h2ab;
 end endfunction
 function [7:0] byte_decode;input[9:0] x;reg[7:0] qm;integer k;begin
  qm=x[7:0]^{8{x[9]}};byte_decode[0]=qm[0];
  for(k=1;k<8;k=k+1)byte_decode[k]=qm[k]^qm[k-1]^~x[8];
 end endfunction
 wire preamble=control(ch0) && ch1==10'h0ab && ch2==10'h354;
 wire video_guard=ch0==10'h2cc && ch1==10'h133 && ch2==10'h2cc;
 wire all_control=control(ch0)&&control(ch1)&&control(ch2);
 always @(posedge word_clk or posedge rst)begin
  if(rst)begin
   state<=SEARCH;preamble_count<=0;column<=0;pixel_valid<=0;
   rgb<=0;pixel_line<=0;pixel_column<=0;rows_completed<=0;protocol_errors<=0;
  end else begin
   pixel_valid<=0;
   case(state)
    SEARCH:begin
     if(preamble)begin
      // The core can retain the video-control value for longer than eight
      // words. Saturate until the actual first guard, rather than predicting
      // a guard immediately after the eighth control word.
      if(preamble_count<8)preamble_count<=preamble_count+1;
     end else if(preamble_count>=8 && video_guard)begin
      state<=GUARD2;preamble_count<=0;
     end else preamble_count<=0;
    end
    GUARD1:begin
     if(video_guard)state<=GUARD2;
     else begin
      if(protocol_errors<4)$display("VIDEO_PERIOD_ERROR guard1 words=%03h/%03h/%03h",ch0,ch1,ch2);
      protocol_errors<=protocol_errors+1;state<=SEARCH;preamble_count<=0;
     end
    end
    GUARD2:begin
     if(video_guard)begin state<=VIDEO;column<=0;end
     else begin
      if(protocol_errors<4)$display("VIDEO_PERIOD_ERROR guard2 words=%03h/%03h/%03h",ch0,ch1,ch2);
      protocol_errors<=protocol_errors+1;state<=SEARCH;preamble_count<=0;
     end
    end
    VIDEO:begin
     if((^ch0===1'bx)||(^ch1===1'bx)||(^ch2===1'bx))protocol_errors<=protocol_errors+1;
     pixel_valid<=1;rgb<={byte_decode(ch2),byte_decode(ch1),byte_decode(ch0)};
     pixel_column<=column;pixel_line<=rows_completed;
     if(column==HACTIVE-1)begin rows_completed<=rows_completed+1;state<=POST;end
     else column<=column+1;
    end
    POST:begin
     if(!all_control)begin
      if(protocol_errors<4)$display("VIDEO_PERIOD_ERROR post rows=%0d words=%03h/%03h/%03h",rows_completed,ch0,ch1,ch2);
      protocol_errors<=protocol_errors+1;
     end
     state<=SEARCH;preamble_count<=preamble?1:0;
    end
    default:begin state<=SEARCH;protocol_errors<=protocol_errors+1;end
   endcase
  end
 end
endmodule
