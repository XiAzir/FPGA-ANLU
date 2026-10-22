`timescale 1ns/1ps
// Experimental HDMI metadata patch between the encrypted core and TMDS PHY.
// Supported domain: 48-kHz, 24-bit LPCM, stereo. Symbol lanes are pre-PHY 10-bit words.
module hdmi_audio_metadata_patch (
  input wire pixel_clk,
  input wire reset,
  input wire [9:0] lane0_i, lane1_i, lane2_i, clock_i,
  output reg [9:0] lane0_o, lane1_o, lane2_o, clock_o
);
  localparam [2:0] ST_SEARCH=0, ST_GUARD=1, ST_PACKET=2,
                   ST_BOUNDARY1=3, ST_BOUNDARY2=4;
  localparam [9:0] CTRL01=10'h0AB, ISLAND_GB=10'h133;
  reg [9:0] p0[0:7],p1[0:7],p2[0:7],pc[0:7];

  function [4:0] terc_decode;
    input [9:0] x;
    begin case(x)
      10'h29C:terc_decode=5'h10; 10'h263:terc_decode=5'h11;
      10'h2E4:terc_decode=5'h12; 10'h2E2:terc_decode=5'h13;
      10'h171:terc_decode=5'h14; 10'h11E:terc_decode=5'h15;
      10'h18E:terc_decode=5'h16; 10'h13C:terc_decode=5'h17;
      10'h2CC:terc_decode=5'h18; 10'h139:terc_decode=5'h19;
      10'h19C:terc_decode=5'h1A; 10'h2C6:terc_decode=5'h1B;
      10'h28E:terc_decode=5'h1C; 10'h271:terc_decode=5'h1D;
      10'h163:terc_decode=5'h1E; 10'h2C3:terc_decode=5'h1F;
      default:terc_decode=5'h00;
    endcase end
  endfunction
  function [9:0] terc_encode;
    input [3:0] n;
    begin case(n)
      0:terc_encode=10'h29C; 1:terc_encode=10'h263;
      2:terc_encode=10'h2E4; 3:terc_encode=10'h2E2;
      4:terc_encode=10'h171; 5:terc_encode=10'h11E;
      6:terc_encode=10'h18E; 7:terc_encode=10'h13C;
      8:terc_encode=10'h2CC; 9:terc_encode=10'h139;
      10:terc_encode=10'h19C;11:terc_encode=10'h2C6;
      12:terc_encode=10'h28E;13:terc_encode=10'h271;
      14:terc_encode=10'h163;15:terc_encode=10'h2C3;
    endcase end
  endfunction
  function [7:0] bch_step;
    input [7:0] r; input d; reg f;
    begin f=r[7]^d; bch_step={r[6:0],1'b0}^(f?8'hC1:8'h00); end
  endfunction

  reg [2:0] in_state;
  reg [3:0] in_pre;
  reg in_guard2;
  reg [4:0] in_idx;
  reg [7:0] in_hb0,in_type;
  reg [7:0] out_bch;
  reg [7:0] channel_status_index;
  reg channel_status_valid;
  reg [7:0] packet_valid_pipe;
  reg [4:0] packet_index_pipe[0:7];
  wire [4:0] id0=terc_decode(lane0_i),id1=terc_decode(lane1_i),id2=terc_decode(lane2_i);
  wire ig=(id0[4]&&id0[3:2]==2'b11&&lane1_i==ISLAND_GB&&lane2_i==ISLAND_GB);
  wire ictrl=((lane0_i==10'h354)||(lane0_i==10'h0AB)||(lane0_i==10'h154)||(lane0_i==10'h2AB))&&lane1_i==CTRL01&&lane2_i==CTRL01;
  wire [9:0] o0raw=p0[7],o1raw=p1[7],o2raw=p2[7];
  wire [4:0] a1=terc_decode(o1raw),a2=terc_decode(o2raw);
  reg [3:0] n1,n2;
  reg [7:0] next_bch;
  reg [7:0] bch_base;
  integer k;

  always @* begin
    n1=a1[3:0]; n2=a2[3:0]; next_bch=out_bch;
    bch_base=(packet_index_pipe[7]==0)?8'd0:out_bch;
    if(packet_valid_pipe[7] && in_type==8'h84 && packet_index_pipe[7]<28) begin
      // InfoFrame PB0 checksum changes from 0x70 to 0x61; PB2 changes 0x00 to 0x0f.
      case(packet_index_pipe[7])
        0: begin n1[0]=1'b1; n2[0]=1'b0; end // PB0 bits 0,1: 0 -> 1,0 (bit0 of delta 0x11)
        2: begin n1[0]=1'b0; n2[0]=1'b1; end // PB0 bit 4 clears; bit 5 stays set
        8: begin n1[0]=1'b1; n2[0]=1'b1; end // PB2 bits 0,1
        9: begin n1[0]=1'b1; n2[0]=1'b1; end // PB2 bits 2,3
        10:begin n1[0]=1'b0; n2[0]=1'b0; end // PB2 bits 4,5
        11:begin n1[0]=1'b0; n2[0]=1'b0; end // PB2 bits 6,7
        default: begin end
      endcase
      next_bch=bch_step(bch_step(bch_base,n1[0]),n2[0]);
    end else if(packet_valid_pipe[7] && in_type==8'h84 && packet_index_pipe[7]>=28) begin
      n1[0]=out_bch[7]; n2[0]=out_bch[6];
      next_bch={out_bch[5:0],2'b00};
    end else if(packet_valid_pipe[7] && in_type==8'h02 && packet_index_pipe[7]<28) begin
      if(channel_status_valid && packet_index_pipe[7]==25 &&
         (channel_status_index==25 || channel_status_index==32 ||
          channel_status_index==33 || channel_status_index==35)) begin
        n2[0]=n2[0]^(~n1[0]); n1[0]=1'b1;
      end
      if(channel_status_valid && packet_index_pipe[7]==27 &&
         (channel_status_index==25 || channel_status_index==32 ||
          channel_status_index==33 || channel_status_index==35)) begin
        n2[0]=n2[0]^(~n1[0]); n1[0]=1'b1;
      end
      next_bch=bch_step(bch_step(bch_base,n1[0]),n2[0]);
    end else if(packet_valid_pipe[7] && in_type==8'h02 && packet_index_pipe[7]>=28) begin
      n1[0]=out_bch[7]; n2[0]=out_bch[6];
      next_bch={out_bch[5:0],2'b00};
    end
  end

  always @(posedge pixel_clk) begin
    if(reset) begin
      for(k=0;k<8;k=k+1) begin p0[k]<=10'h000;p1[k]<=10'h000;p2[k]<=10'h000;pc[k]<=10'b0000011111; end
      lane0_o<=10'h000;lane1_o<=10'h000;lane2_o<=10'h000;clock_o<=10'b0000011111;
      in_state<=ST_SEARCH;in_pre<=0;
      in_guard2<=0;in_idx<=0;
      in_hb0<=0;in_type<=0;out_bch<=0;
      channel_status_index<=0;channel_status_valid<=0;
      packet_valid_pipe<=0;
      for(k=0;k<8;k=k+1) packet_index_pipe[k]<=0;
    end else begin
      p0[0]<=lane0_i;p1[0]<=lane1_i;p2[0]<=lane2_i;pc[0]<=clock_i;
      packet_valid_pipe[0]<=(in_state==ST_PACKET);
      packet_index_pipe[0]<=in_idx;
      for(k=1;k<8;k=k+1) begin p0[k]<=p0[k-1];p1[k]<=p1[k-1];p2[k]<=p2[k-1];pc[k]<=pc[k-1];packet_valid_pipe[k]<=packet_valid_pipe[k-1];packet_index_pipe[k]<=packet_index_pipe[k-1]; end
      lane0_o<=o0raw;lane1_o<=a1[4]?terc_encode(n1):o1raw;lane2_o<=a2[4]?terc_encode(n2):o2raw;clock_o<=pc[7];
      if(packet_valid_pipe[7]) out_bch<=next_bch;

      if(in_state==ST_PACKET) begin
        if(in_idx<8) in_hb0<={id0[2],in_hb0[7:1]};
        if(in_idx==7) in_type<={id0[2],in_hb0[7:1]};
        if(in_idx==20 && in_type==8'h02 && id0[2]) begin
          channel_status_index<=0;
          channel_status_valid<=1;
        end
        // The delayed output's C/P nibble is emitted at lookahead packet clocks 0..3.
        // Advance only after both channel subframes of that sample have passed.
        if(in_idx==4 && channel_status_valid && in_type==8'h02) begin
          if(channel_status_index==191) channel_status_index<=0;
          else channel_status_index<=channel_status_index+1'b1;
        end
        if(in_idx==31) begin in_state<=ST_BOUNDARY1;in_idx<=0;end else in_idx<=in_idx+1'b1;
      end else if(in_state==ST_SEARCH) begin
        if(ictrl) begin if(in_pre==7) begin in_state<=ST_GUARD;in_guard2<=0;in_pre<=0;end else in_pre<=in_pre+1'b1;end else in_pre<=0;
      end else if(in_state==ST_GUARD) begin
        if(ig) begin if(in_guard2) begin in_state<=ST_PACKET;in_guard2<=0;in_idx<=0;in_hb0<=0;end else in_guard2<=1;end
        else begin in_state<=ST_SEARCH;in_guard2<=0;in_pre<=0;end
      end else if(in_state==ST_BOUNDARY1) begin
        if(ig) in_state<=ST_BOUNDARY2;
        else if(id0[4]&&id1[4]&&id2[4]) begin in_state<=ST_PACKET;in_idx<=0;in_hb0<=0;end
        else begin in_state<=ST_SEARCH;in_pre<=0;end
      end else if(in_state==ST_BOUNDARY2) begin
        if(ig) begin in_state<=ST_SEARCH;in_guard2<=0;in_pre<=0;end
        else begin in_state<=ST_SEARCH;in_guard2<=0;in_pre<=0;end
      end
    end
  end

endmodule



