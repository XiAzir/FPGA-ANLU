`timescale 1ns/1ps
// Passive HDMI data-island monitor. Functional diagnostic model only.
// Tap the three core TMDS parallel words before the PHY wrapper bit reversal.
module hdmi_packet_monitor #(
    parameter integer CLK_HZ = 25000000,
    parameter [23:0] TONE_AMP = 24'd1000000
)(
    input wire clk, input wire rst, input wire tone_mode,
    input wire [9:0] ch0, input wire [9:0] ch1, input wire [9:0] ch2,
    output reg [23:0] audio_samples_sec,
    output reg [23:0] audio_packets_sec,
    output reg [23:0] bad_bch_sec,
    output reg [23:0] bad_terc_sec,
    output reg [23:0] tone_bad_sec,
    output reg [19:0] acr_cts_last,
    output reg [19:0] acr_n_last,
    output reg [3:0] probe_flags
);

localparam [2:0] ST_SEARCH=3'd0, ST_GUARD=3'd1, ST_PACKET=3'd2,
                 ST_BOUNDARY1=3'd3, ST_BOUNDARY2=3'd4;
localparam [9:0] CTRL_01=10'h0AB, ISLAND_GB=10'h133;

reg [2:0] state;
reg [3:0] preamble_count;
reg guard_second;
reg [4:0] packet_clock;
reg [23:0] header_shift;
// One payload is enough for ACR CTS/N. The other three are checked online.
reg [55:0] body0;
reg [55:0] body1,body2,body3;
reg acr_equal_bad;
reg [3:0] tone_pos_match,tone_neg_match,tone_payload_bad;
reg [7:0] bch_header,bch0,bch1,bch2,bch3;
reg header_bad,body_bad;
localparam integer SEC_BITS=(CLK_HZ<=1)?1:$clog2(CLK_HZ);
reg [SEC_BITS-1:0] sec_clock;
reg [15:0] win_samples,win_packets,win_bad_bch,win_bad_terc,win_tone_bad;

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
 default:terc_decode=5'h00; endcase end
endfunction
function [7:0] bch_step;
 input [7:0] r; input d; reg f;
 begin f=r[7]^d; bch_step={r[6:0],1'b0}^(f?8'hC1:8'h00); end
endfunction
function [15:0] sat_add;
 input [15:0] a; input [3:0] b; reg [16:0] sum;
 begin sum={1'b0,a}+b; sat_add=sum[16]?16'hFFFF:sum[15:0]; end
endfunction
function prefix_present;
 input [3:0] p;
 begin case(p)
 4'b0000,4'b0001,4'b0011,4'b0111,4'b1111:prefix_present=1'b1;
 default:prefix_present=1'b0; endcase end
endfunction
function [1:0] amp_pair;
 input [4:0] clock_index; input [23:0] amp;
 begin case(clock_index)
  0,12:amp_pair=amp[1:0];   1,13:amp_pair=amp[3:2];
  2,14:amp_pair=amp[5:4];   3,15:amp_pair=amp[7:6];
  4,16:amp_pair=amp[9:8];   5,17:amp_pair=amp[11:10];
  6,18:amp_pair=amp[13:12]; 7,19:amp_pair=amp[15:14];
  8,20:amp_pair=amp[17:16]; 9,21:amp_pair=amp[19:18];
 10,22:amp_pair=amp[21:20];11,23:amp_pair=amp[23:22];
 default:amp_pair=2'b00; endcase end
endfunction

wire [4:0] d0=terc_decode(ch0), d1=terc_decode(ch1), d2=terc_decode(ch2);
wire dv0=d0[4],dv1=d1[4],dv2=d2[4];
wire [3:0] n0=d0[3:0],n1=d1[3:0],n2=d2[3:0];
wire control0=(ch0==10'h354)||(ch0==10'h0AB)||
              (ch0==10'h154)||(ch0==10'h2AB);
// Data-island guard-band symbols on lanes 1/2 are fixed 10-bit characters,
// not TERC4 characters. Only lane 0 is decoded as TERC4 nibble C..F.
wire guard_word=dv0 && n0[3:2]==2'b11 && ch1==ISLAND_GB && ch2==ISLAND_GB;
wire symbol_bad=((state==ST_PACKET) && !(dv0&&dv1&&dv2)) ||
 (state==ST_GUARD && !guard_word) ||
 ((state==ST_BOUNDARY1 || state==ST_BOUNDARY2) && !guard_word && !(dv0&&dv1&&dv2));
wire start_packet=(state==ST_BOUNDARY1) && !guard_word && (dv0&&dv1&&dv2);
wire packet_active=(state==ST_PACKET) || start_packet;
wire [4:0] idx=start_packet?5'd0:packet_clock;
wire [7:0] hbase=start_packet?8'd0:bch_header;
// All payload/header bits are overwritten before packet_done. Clearing them
// at packet boundaries would only add wide muxes to these shift registers.
wire [7:0] b0base=start_packet?8'd0:bch0;
wire [7:0] b1base=start_packet?8'd0:bch1;
wire [7:0] b2base=start_packet?8'd0:bch2;
wire [7:0] b3base=start_packet?8'd0:bch3;
wire [7:0] hnext=(idx<24)?bch_step(hbase,n0[2]):{hbase[6:0],1'b0};
wire [7:0] b0mid=(idx<28)?bch_step(b0base,n1[0]):{b0base[6:0],1'b0};
wire [7:0] b0next=(idx<28)?bch_step(b0mid,n2[0]):{b0mid[6:0],1'b0};
wire [7:0] b1mid=(idx<28)?bch_step(b1base,n1[1]):{b1base[6:0],1'b0};
wire [7:0] b1next=(idx<28)?bch_step(b1mid,n2[1]):{b1mid[6:0],1'b0};
wire [7:0] b2mid=(idx<28)?bch_step(b2base,n1[2]):{b2base[6:0],1'b0};
wire [7:0] b2next=(idx<28)?bch_step(b2mid,n2[2]):{b2mid[6:0],1'b0};
wire [7:0] b3mid=(idx<28)?bch_step(b3base,n1[3]):{b3base[6:0],1'b0};
wire [7:0] b3next=(idx<28)?bch_step(b3mid,n2[3]):{b3mid[6:0],1'b0};
wire hbit_bad=(idx>=24) && n0[2]!=hbase[7];
wire bodybit_bad=(idx>=28) &&
 (n1[0]!=b0base[7] || n2[0]!=b0mid[7] || n1[1]!=b1base[7] || n2[1]!=b1mid[7] ||
  n1[2]!=b2base[7] || n2[2]!=b2mid[7] || n1[3]!=b3base[7] || n2[3]!=b3mid[7]);
wire packet_done=packet_active && idx==5'd31 && dv0 && dv1 && dv2;
wire packet_bad_now=header_bad || body_bad || hbit_bad || bodybit_bad;
wire packet_good=packet_done && !packet_bad_now;

// Payload data is already complete before clock 31, which carries only BCH
// parity. Keep the data registers unchanged during the parity clocks.
wire [23:0] header_complete=header_shift;
wire [55:0] body0_complete=body0;
wire [55:0] body1_complete=body1;
wire [55:0] body2_complete=body2;
wire [55:0] body3_complete=body3;
wire [7:0] hb0=header_complete[7:0], hb1=header_complete[15:8], hb2=header_complete[23:16];
wire is_audio=(hb0==8'h02), is_acr=(hb0==8'h01);
wire [3:0] sp=hb1[3:0], flat=hb2[3:0];
wire audio_fmt_bad=(hb1[7:5]!=0) || hb1[4] || !prefix_present(sp);
wire [2:0] pair_count=sp[3]?3'd4:sp[2]?3'd3:sp[1]?3'd2:sp[0]?3'd1:3'd0;
wire audio_good=packet_good && is_audio && !audio_fmt_bad;
wire [23:0] neg_amp=(~TONE_AMP)+24'd1;
wire [1:0] pos_pair=amp_pair(idx,TONE_AMP),neg_pair=amp_pair(idx,neg_amp);
wire [3:0] pos_equal=~((n1^{4{pos_pair[0]}})|(n2^{4{pos_pair[1]}}));
wire [3:0] neg_equal=~((n1^{4{neg_pair[0]}})|(n2^{4{neg_pair[1]}}));
wire sample_first=(idx==0)||(idx==12);
wire [3:0] pos_match_now=(sample_first?4'hF:tone_pos_match)&pos_equal;
wire [3:0] neg_match_now=(sample_first?4'hF:tone_neg_match)&neg_equal;
wire [3:0] sample_bad_now=~(pos_match_now|neg_match_now);
wire [3:0] tone_bad_present=tone_payload_bad&sp&~flat;
wire [2:0] tone_bad_pairs={2'd0,tone_bad_present[0]}+{2'd0,tone_bad_present[1]}+
                         {2'd0,tone_bad_present[2]}+{2'd0,tone_bad_present[3]};
wire [55:0] payload0=body0_complete;
wire acr_mismatch_now=(n1[3:1]!={3{n1[0]}})||(n2[3:1]!={3{n2[0]}});
wire acr_equal=!acr_equal_bad;
wire acr_reserved_bad=(payload0[7:0]!=0)||(payload0[15:12]!=0)||(payload0[39:36]!=0);
wire acr_fmt_bad=!acr_equal||acr_reserved_bad;
wire acr_good=packet_good && is_acr && !acr_fmt_bad;
wire [19:0] cts_val={payload0[11:8],payload0[23:16],payload0[31:24]};
wire [19:0] n_val={payload0[35:32],payload0[47:40],payload0[55:48]};
wire [3:0] ev_samples=(audio_good?{1'b0,pair_count}:4'd0);
wire [3:0] ev_packets=audio_good?4'd1:4'd0;
wire [3:0] ev_bch=(packet_done&&packet_bad_now)?4'd1:4'd0;
wire [3:0] ev_tone=(audio_good&&tone_mode)?{1'b0,tone_bad_pairs}:4'd0;
wire ev_format=packet_good && ((is_audio&&audio_fmt_bad)||(is_acr&&acr_fmt_bad));
wire ev_island=(state==ST_GUARD)&&guard_second&&guard_word;

always @(posedge clk) begin
 if(rst) begin
  state<=ST_SEARCH; preamble_count<=0; guard_second<=0; packet_clock<=0;
  acr_equal_bad<=0;tone_pos_match<=0;tone_neg_match<=0;tone_payload_bad<=0;
  bch_header<=0;bch0<=0;bch1<=0;bch2<=0;bch3<=0;header_bad<=0;body_bad<=0;
  sec_clock<=0;win_samples<=0;win_packets<=0;win_bad_bch<=0;win_bad_terc<=0;win_tone_bad<=0;
  audio_samples_sec<=0;audio_packets_sec<=0;bad_bch_sec<=0;bad_terc_sec<=0;tone_bad_sec<=0;
  acr_cts_last<=0;acr_n_last<=0;probe_flags<=0;
 end else begin
  // Sticky observations; flags are {island_seen,audio_seen,acr_seen,format_error_seen}.
  if(ev_island) probe_flags[3]<=1'b1;
  if(audio_good) probe_flags[2]<=1'b1;
  if(acr_good) probe_flags[1]<=1'b1;
  if(ev_format || symbol_bad || (state==ST_BOUNDARY2 && !guard_word)) probe_flags[0]<=1'b1;

  if(state==ST_SEARCH) begin
   if(control0 && ch1==CTRL_01 && ch2==CTRL_01) begin
    if(preamble_count==4'd7) begin state<=ST_GUARD; guard_second<=0; preamble_count<=0; end
    else preamble_count<=preamble_count+1'b1;
   end else preamble_count<=0;
  end else if(state==ST_GUARD) begin
   if(guard_word) begin
    if(guard_second) begin
     state<=ST_PACKET; guard_second<=0; packet_clock<=0;
     bch_header<=0;bch0<=0;bch1<=0;bch2<=0;bch3<=0;header_bad<=0;body_bad<=0;
    end else guard_second<=1;
   end else begin state<=ST_SEARCH;guard_second<=0;preamble_count<=0; end
  end else if(state==ST_BOUNDARY1) begin
   if(guard_word) begin state<=ST_BOUNDARY2; end
   else if(dv0&&dv1&&dv2) begin
    // No guard means this symbol is clock 0 of the next packet in the same island.
    state<=ST_PACKET;packet_clock<=0;
    bch_header<=0;bch0<=0;bch1<=0;bch2<=0;bch3<=0;header_bad<=0;body_bad<=0;
   end else begin state<=ST_SEARCH;preamble_count<=0; end
  end else if(state==ST_BOUNDARY2) begin
   if(guard_word) begin state<=ST_SEARCH;guard_second<=0;preamble_count<=0; end
   else begin state<=ST_SEARCH;guard_second<=0;preamble_count<=0;probe_flags[0]<=1'b1; end
  end

  if(packet_active) begin
   if(!(dv0&&dv1&&dv2)) begin
    state<=ST_SEARCH;preamble_count<=0;packet_clock<=0;header_bad<=0;body_bad<=0;
   end else begin
    if(idx<24) begin
     header_shift<={n0[2],header_shift[23:1]};
     // idx 11/23 includes the current final two bits of the L/R sample.
     tone_pos_match<=pos_match_now;tone_neg_match<=neg_match_now;
     if(idx==11) tone_payload_bad<=sample_bad_now;
     if(idx==23) tone_payload_bad<=tone_payload_bad|sample_bad_now;
    end
    if(idx<28) begin
     body0<={n2[0],n1[0],body0[55:2]};
     body1<={n2[1],n1[1],body1[55:2]};
     body2<={n2[2],n1[2],body2[55:2]};
     body3<={n2[3],n1[3],body3[55:2]};
     // All four ACR subpackets must repeat the same 56 data bits. The
     // first pair initializes the flag including its own possible mismatch.
     acr_equal_bad<=(idx==0)?acr_mismatch_now:(acr_equal_bad|acr_mismatch_now);
    end
    bch_header<=hnext;bch0<=b0next;bch1<=b1next;bch2<=b2next;bch3<=b3next;
    header_bad<=((start_packet?1'b0:header_bad)||hbit_bad);
    body_bad<=((start_packet?1'b0:body_bad)||bodybit_bad);
    if(idx==5'd31) begin
     state<=ST_BOUNDARY1;packet_clock<=0;
    end else begin state<=ST_PACKET;packet_clock<=idx+1'b1; end
   end
  end

  if(packet_done && packet_good && is_acr && !acr_fmt_bad) begin
   if(cts_val!=0) acr_cts_last<=cts_val;
   acr_n_last<=n_val;
  end

  if(CLK_HZ<=1 || sec_clock==CLK_HZ-1) begin
   audio_samples_sec<={8'd0,sat_add(win_samples,ev_samples)};
   audio_packets_sec<={8'd0,sat_add(win_packets,ev_packets)};
   bad_bch_sec<={8'd0,sat_add(win_bad_bch,ev_bch)};
   bad_terc_sec<={8'd0,sat_add(win_bad_terc,symbol_bad?4'd1:4'd0)};
   tone_bad_sec<={8'd0,sat_add(win_tone_bad,ev_tone)};
   win_samples<=0;win_packets<=0;win_bad_bch<=0;win_bad_terc<=0;win_tone_bad<=0;sec_clock<=0;
  end else begin
   sec_clock<=sec_clock+1'b1;
   win_samples<=sat_add(win_samples,ev_samples);
   win_packets<=sat_add(win_packets,ev_packets);
   win_bad_bch<=sat_add(win_bad_bch,ev_bch);
   win_tone_bad<=sat_add(win_tone_bad,ev_tone);
   if(symbol_bad) win_bad_terc<=sat_add(win_bad_terc,4'd1);
  end
 end
end
endmodule
