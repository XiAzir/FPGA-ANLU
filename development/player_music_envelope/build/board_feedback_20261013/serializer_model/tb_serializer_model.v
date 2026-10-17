`timescale 1ps/1ps
module EG_LOGIC_ODDR(input wire clk,input wire rst,input wire d1,input wire d0,output wire q);
  reg comp0=0,comp1=0,true0=0,clk_mux=0;
  always @(posedge clk or posedge rst) begin if(rst) begin comp0=0;true0=0;end else begin comp0=d1;true0=d0;end end
  always @(negedge clk or posedge rst) begin if(rst) comp1=0;else comp1=comp0;end
  always @(clk) clk_mux <= #100 clk;
  assign q=clk_mux ? true0 : comp1;
endmodule
module tb_serializer_model #(parameter integer TOGGLE_DELAY_PS=0,parameter integer CANDIDATE=0,parameter integer ODDR_D0_DELAY_PS=0,parameter integer ODDR_D1_DELAY_PS=0,parameter integer PAD_CLK_DELAY_PS=0);
  reg pixel_clk=0,serial_clk=0,rst=0;
  reg [9:0] c0=0,c1=0,c2=0,cc=0;
  wire o0,o1,o2,oc;
  integer phase_ps=0,seed=1,n=0,i,b,k,ch,align_bit=-1,align_word=-1,match_run,word_checks=0,word_errors=0,serial_bit_errors=0,target_errors=0,capture_errors=0,reset_count=0,source_sequence_errors=0,last_source_index=-1;
  integer nb[0:3],lc[0:3];
  reg [9:0] loaded[0:3][0:255];
  reg [4095:0] stream[0:3];
  hdmi_phy_wrapper #(.DEVICE("EG"),.TOGGLE_DELAY_PS(TOGGLE_DELAY_PS),.ODDR_D0_DELAY_PS(ODDR_D0_DELAY_PS),.ODDR_D1_DELAY_PS(ODDR_D1_DELAY_PS),.PAD_CLK_DELAY_PS(PAD_CLK_DELAY_PS)) dut(
    .I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),.I_tmds_channel_0(c0),.I_tmds_channel_1(c1),.I_tmds_channel_2(c2),.I_tmds_channel_clk(cc),
    .O_tmds_ch0_p(o0),.O_tmds_ch1_p(o1),.O_tmds_ch2_p(o2),.O_tmds_clk_p(oc));
  always #20000 pixel_clk=~pixel_clk;
  initial begin #1; if(!$value$plusargs("phase=%d",phase_ps)) phase_ps=0; if(!$value$plusargs("seed=%d",seed)) seed=1; #(20000+phase_ps); forever begin serial_clk=1; #4000 serial_clk=0; #4000; end end
  initial begin if(!$value$plusargs("seed=%d",seed)) seed=1; #(1000+(seed%17000)); rst=1; #137000 rst=0; #(200000+(seed%31000)); rst=1; #113000 rst=0; end
  function [9:0] pat(input integer x,input integer lane);
    integer z; begin z=(x*1664525+(lane+1)*1013904223+seed*69069); z=z^(z>>13); z=z^(z<<7); z=z^(z>>17);
      case(x%16) 0:pat=10'b1101010100;1:pat=10'b0010101011;2:pat=10'b0100110011;3:pat=10'b1011001100;4:pat=10'b0101100011;5:pat=10'b1010011100;default:pat=z[9:0];endcase end
  endfunction
  function [9:0] rev(input [9:0] x); integer q; begin for(q=0;q<10;q=q+1) rev[q]=x[9-q]; end endfunction
  always @(posedge rst) begin reset_count=reset_count+1; last_source_index=-1; for(ch=0;ch<4;ch=ch+1) begin nb[ch]=0;lc[ch]=0;end end
  always @(posedge pixel_clk) if(!rst) n=n+1;
  always @(posedge pixel_clk) if(!rst) begin #31; c0[0]=((pat(n,0) >> 0) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #228; c0[1]=((pat(n,0) >> 1) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #425; c0[2]=((pat(n,0) >> 2) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #622; c0[3]=((pat(n,0) >> 3) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #819; c0[4]=((pat(n,0) >> 4) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1016; c0[5]=((pat(n,0) >> 5) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1213; c0[6]=((pat(n,0) >> 6) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1410; c0[7]=((pat(n,0) >> 7) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1607; c0[8]=((pat(n,0) >> 8) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1804; c0[9]=((pat(n,0) >> 9) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #432; c1[0]=((pat(n,1) >> 0) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #629; c1[1]=((pat(n,1) >> 1) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #826; c1[2]=((pat(n,1) >> 2) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1023; c1[3]=((pat(n,1) >> 3) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1220; c1[4]=((pat(n,1) >> 4) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1417; c1[5]=((pat(n,1) >> 5) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1614; c1[6]=((pat(n,1) >> 6) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1811; c1[7]=((pat(n,1) >> 7) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #7; c1[8]=((pat(n,1) >> 8) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #204; c1[9]=((pat(n,1) >> 9) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #833; c2[0]=((pat(n,2) >> 0) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1030; c2[1]=((pat(n,2) >> 1) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1227; c2[2]=((pat(n,2) >> 2) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1424; c2[3]=((pat(n,2) >> 3) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1621; c2[4]=((pat(n,2) >> 4) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1818; c2[5]=((pat(n,2) >> 5) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #14; c2[6]=((pat(n,2) >> 6) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #211; c2[7]=((pat(n,2) >> 7) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #408; c2[8]=((pat(n,2) >> 8) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #605; c2[9]=((pat(n,2) >> 9) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1234; cc[0]=((pat(n,3) >> 0) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1431; cc[1]=((pat(n,3) >> 1) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1628; cc[2]=((pat(n,3) >> 2) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1825; cc[3]=((pat(n,3) >> 3) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #21; cc[4]=((pat(n,3) >> 4) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #218; cc[5]=((pat(n,3) >> 5) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #415; cc[6]=((pat(n,3) >> 6) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #612; cc[7]=((pat(n,3) >> 7) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #809; cc[8]=((pat(n,3) >> 8) & 1'b1); end
  always @(posedge pixel_clk) if(!rst) begin #1006; cc[9]=((pat(n,3) >> 9) & 1'b1); end
  generate if(CANDIDATE) begin:capture_check
    always @(negedge pixel_clk) if(!rst) begin #1; if(dut.tmds_word_0!==c0 || dut.tmds_word_1!==c1 || dut.tmds_word_2!==c2 || dut.tmds_word_clk!==cc) capture_errors=capture_errors+1; end
  end endgenerate
  always @(posedge serial_clk) if(!rst && dut.u0_lane_lvds_8_1.S_load_en_2d) begin #1;
    if(CANDIDATE) begin
      if(dut.u0_lane_lvds_8_1.S_shift_data!==rev(dut.tmds_word_0) || dut.u1_lane_lvds_8_1.S_shift_data!==rev(dut.tmds_word_1) || dut.u2_lane_lvds_8_1.S_shift_data!==rev(dut.tmds_word_2) || dut.u3_lane_lvds_8_1.S_shift_data!==rev(dut.tmds_word_clk)) target_errors=target_errors+1;
      // A load launched at pixel negedge captures the word sampled at the preceding negedge. n has advanced once at the intervening pixel posedge, hence expected source index n-1.
      if(dut.u0_lane_lvds_8_1.S_shift_data!==rev(pat(n-1,0)) || dut.u1_lane_lvds_8_1.S_shift_data!==rev(pat(n-1,1)) || dut.u2_lane_lvds_8_1.S_shift_data!==rev(pat(n-1,2)) || dut.u3_lane_lvds_8_1.S_shift_data!==rev(pat(n-1,3))) target_errors=target_errors+1;
      if(last_source_index>=0 && (n-1)!=(last_source_index+1)) source_sequence_errors=source_sequence_errors+1;
      last_source_index=n-1;
    end
    for(ch=0;ch<4;ch=ch+1) begin
      case(ch) 0:loaded[ch][lc[ch]]=dut.u0_lane_lvds_8_1.S_shift_data;1:loaded[ch][lc[ch]]=dut.u1_lane_lvds_8_1.S_shift_data;2:loaded[ch][lc[ch]]=dut.u2_lane_lvds_8_1.S_shift_data;3:loaded[ch][lc[ch]]=dut.u3_lane_lvds_8_1.S_shift_data;endcase
      lc[ch]=lc[ch]+1;
    end
  end
  always @(posedge serial_clk) begin #101; if(!rst) begin stream[0][nb[0]]=o0;nb[0]=nb[0]+1;stream[1][nb[1]]=o1;nb[1]=nb[1]+1;stream[2][nb[2]]=o2;nb[2]=nb[2]+1;stream[3][nb[3]]=oc;nb[3]=nb[3]+1;end end
  always @(negedge serial_clk) begin #101; if(!rst) begin stream[0][nb[0]]=o0;nb[0]=nb[0]+1;stream[1][nb[1]]=o1;nb[1]=nb[1]+1;stream[2][nb[2]]=o2;nb[2]=nb[2]+1;stream[3][nb[3]]=oc;nb[3]=nb[3]+1;end end
  function [9:0] getword(input integer lane,input integer start); integer q; begin for(q=0;q<10;q=q+1)getword[9-q]=stream[lane][start+q];end endfunction
  initial begin #8000000;
    for(i=0;i<200 && align_bit<0;i=i+1) for(k=0;k+4<lc[0] && align_bit<0;k=k+1) begin match_run=1;for(b=0;b<5;b=b+1) if(getword(0,i+10*b)!==loaded[0][k+b] || getword(1,i+10*b)!==loaded[1][k+b] || getword(2,i+10*b)!==loaded[2][k+b] || getword(3,i+10*b)!==loaded[3][k+b])match_run=0;if(match_run)begin align_bit=i;align_word=k;end end
    if(align_bit>=0) for(b=5;align_word+b<lc[0] && align_bit+10*(b+1)<=nb[0];b=b+1) begin word_checks=word_checks+1;for(ch=0;ch<4;ch=ch+1) begin if(getword(ch,align_bit+10*b)!==loaded[ch][align_word+b])word_errors=word_errors+1;for(i=0;i<10;i=i+1)if(stream[ch][align_bit+10*b+i]!==loaded[ch][align_word+b][9-i])serial_bit_errors=serial_bit_errors+1;end end else word_errors=1;
    $display("SUMMARY candidate=%0d phase_ps=%0d toggle_delay_ps=%0d d0_delay_ps=%0d d1_delay_ps=%0d pad_clk_delay_ps=%0d seed=%0d reset_count=%0d align_bit=%0d align_word=%0d captured_words=%0d,%0d,%0d,%0d word_checks=%0d word_errors=%0d serial_bit_errors=%0d target_errors=%0d capture_errors=%0d source_sequence_errors=%0d",CANDIDATE,phase_ps,TOGGLE_DELAY_PS,ODDR_D0_DELAY_PS,ODDR_D1_DELAY_PS,PAD_CLK_DELAY_PS,seed,reset_count,align_bit,align_word,lc[0],lc[1],lc[2],lc[3],word_checks,word_errors,serial_bit_errors,target_errors,capture_errors,source_sequence_errors);
    if(align_bit<0 || word_checks<10 || word_errors!=0 || serial_bit_errors!=0 || target_errors!=0 || capture_errors!=0 || source_sequence_errors!=0 ||lc[0]!=lc[1]||lc[0]!=lc[2]||lc[0]!=lc[3]||nb[0]!=nb[1]||nb[0]!=nb[2]||nb[0]!=nb[3])$fatal(1,"serializer sequence/data capture failure");$finish;
  end
endmodule













