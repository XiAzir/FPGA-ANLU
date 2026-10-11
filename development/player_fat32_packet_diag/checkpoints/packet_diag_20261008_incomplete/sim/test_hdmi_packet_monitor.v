`timescale 1ns/1ps
module test_hdmi_packet_monitor;
 reg clk=0,rst=1,tone_mode=0;
 reg [9:0] ch0=10'h29C,ch1=10'h29C,ch2=10'h29C;
 wire [23:0] audio_samples_sec,audio_packets_sec,bad_bch_sec,bad_terc_sec,tone_bad_sec;
 wire [19:0] acr_cts_last,acr_n_last;
 wire [3:0] probe_flags;
 integer cycles=0, errors=0, checks=0;
 reg [29:0] vector_words[0:31];
 localparam integer WINDOW=256;
 hdmi_packet_monitor #(.CLK_HZ(WINDOW),.TONE_AMP(24'd1000000)) dut(
  .clk(clk),.rst(rst),.tone_mode(tone_mode),.ch0(ch0),.ch1(ch1),.ch2(ch2),
  .audio_samples_sec(audio_samples_sec),.audio_packets_sec(audio_packets_sec),
  .bad_bch_sec(bad_bch_sec),.bad_terc_sec(bad_terc_sec),.tone_bad_sec(tone_bad_sec),
  .acr_cts_last(acr_cts_last),.acr_n_last(acr_n_last),.probe_flags(probe_flags));
 always #5 clk=~clk;
 always @(posedge clk) if(!rst) cycles<=cycles+1;

 function [9:0] terc(input [3:0] n);
  case(n)
   0:terc=10'h29C;1:terc=10'h263;2:terc=10'h2E4;3:terc=10'h2E2;
   4:terc=10'h171;5:terc=10'h11E;6:terc=10'h18E;7:terc=10'h13C;
   8:terc=10'h2CC;9:terc=10'h139;10:terc=10'h19C;11:terc=10'h2C6;
   12:terc=10'h28E;13:terc=10'h271;14:terc=10'h163;15:terc=10'h2C3;
  endcase
 endfunction
 function [7:0] ecc_bytes;
  input integer nbytes; input [55:0] data;
  integer i,j; reg [7:0] r; reg f; reg [7:0] e;
  begin
   r=0;
   for(i=0;i<nbytes*8;i=i+1) begin
    f=r[7]^data[i]; r={r[6:0],1'b0}; if(f) r=r^8'hC1;
   end
   e=0;
   for(i=0;i<8;i=i+1) begin e[i]=r[7]; r={r[6:0],1'b0}; end
   ecc_bytes=e;
  end
 endfunction
 task tick(input [9:0] a,input [9:0] b,input [9:0] c);
  begin @(negedge clk);ch0=a;ch1=b;ch2=c;@(posedge clk);#1; end
 endtask
 task idle_char;
  begin tick(10'h29C,10'h29C,10'h29C); end
 endtask
 task preamble_guard;
  integer i;
  begin
   for(i=0;i<8;i=i+1) tick(10'h354,10'h0AB,10'h0AB);
   tick(10'h28E,10'h133,10'h133);tick(10'h28E,10'h133,10'h133);
  end
 endtask
 task trailing_guard;
  begin tick(10'h28E,10'h133,10'h133);tick(10'h28E,10'h133,10'h133); end
 endtask
 task packet_words(input [7:0] hb1,input [7:0] hb2,input [7:0] hb0,
                   input [55:0] p0,input [55:0] p1,input [55:0] p2,input [55:0] p3,
                   input integer corrupt_kind,input integer corrupt_index);
  reg [31:0] hcode;
  reg [63:0] w0,w1,w2,w3;
  reg [55:0] q0,q1,q2,q3;
  reg [3:0] a,b,c;
  integer i;
  begin
   q0=p0;q1=p1;q2=p2;q3=p3;
   hcode={ecc_bytes(3,{32'd0,hb2,hb1,hb0}),hb2,hb1,hb0};
   w0={ecc_bytes(7,p0),p0};w1={ecc_bytes(7,p1),p1};w2={ecc_bytes(7,p2),p2};w3={ecc_bytes(7,p3),p3};
   if(corrupt_kind==1) w0[corrupt_index]=~w0[corrupt_index];
   if(corrupt_kind==2) w0[56+corrupt_index]=~w0[56+corrupt_index];
   if(corrupt_kind==3) hcode[24+corrupt_index]=~hcode[24+corrupt_index];
   if(corrupt_kind==4) w0[corrupt_index]=~w0[corrupt_index]; // payload bit error, ECC untouched
   if(corrupt_kind==5) w0[56+corrupt_index]=~w0[56+corrupt_index]; // parity bit error
   for(i=0;i<32;i=i+1) begin
    a={1'b0,hcode[i],2'b00};
    b={w3[2*i],w2[2*i],w1[2*i],w0[2*i]};
    c={w3[2*i+1],w2[2*i+1],w1[2*i+1],w0[2*i+1]};
    if(corrupt_kind==6 && i==corrupt_index) tick(10'h3FF,terc(b),terc(c));
    else tick(terc(a),terc(b),terc(c));
   end
  end
 endtask
 task vector_packet;
  integer j;
  begin
   for(j=0;j<32;j=j+1) tick(vector_words[j][29:20],vector_words[j][19:10],vector_words[j][9:0]);
  end
 endtask
 function [55:0] audio_payload(input [23:0] l,input [23:0] r);
  reg pl,pr;reg [7:0] b6;
  begin pl=^l;pr=^r;b6={pr,3'b000,pl,3'b000}; audio_payload={b6,r[23:16],r[15:8],r[7:0],l[23:16],l[15:8],l[7:0]}; end
 endfunction
 task audio_packet(input [3:0] present,input [3:0] flat,
                   input [23:0] l,input [23:0] r,input integer badkind);
  reg [55:0] p0,p1,p2,p3;reg [7:0] hdr1,hdr2;
  begin
   p0=audio_payload(l,r);p1=p0;p2=p0;p3=p0;
   hdr1={3'b000,1'b0,present};hdr2={4'b0000,flat};
   packet_words(hdr1,hdr2,8'h02,p0,p1,p2,p3,badkind,0);
  end
 endtask
 task acr_packet;
  reg [55:0] p;
  begin
   // SB0=0, CTS=25000 (0x061A8), N=6144 (0x01800).
   p={8'h00,8'h18,8'h00,8'hA8,8'h61,8'h00,8'h00};
   packet_words(0,0,8'h01,p,p,p,p,0,0);
  end
 endtask
 task acr_custom(input [7:0] hb1,input [7:0] hb2,input [19:0] cts,input [19:0] n);
  reg [55:0] p;
  begin
   p=0;
   p[11:8]=cts[19:16];p[23:16]=cts[15:8];p[31:24]=cts[7:0];
   p[35:32]=n[19:16];p[47:40]=n[15:8];p[55:48]=n[7:0];
   packet_words(hb1,hb2,8'h01,p,p,p,p,0,0);
  end
 endtask
 task reset_case;
  begin
   @(negedge clk);rst=1;tone_mode=0;ch0=10'h29C;ch1=10'h29C;ch2=10'h29C;
   repeat(3) @(posedge clk);#1; cycles=0; @(negedge clk);rst=0;
  end
 endtask
 task wait_snapshot;
  begin while(cycles < WINDOW) idle_char(); #1; end
 endtask
 task check_eq(input [255:0] label,input [31:0] got,input [31:0] exp);
  begin checks=checks+1;if(got!==exp) begin $display("FAIL %0s got=%0d expected=%0d",label,got,exp);errors=errors+1;end end
 endtask

 initial begin
  $readmemh("audio_packet_vector.mem",vector_words);
  reset_case();
  // Channel 0 must carry an H/V control symbol throughout the preamble.
  repeat(8) tick(10'h100,10'h0AB,10'h0AB);
  tick(10'h28E,10'h133,10'h133);tick(10'h28E,10'h133,10'h133);
  vector_packet();idle_char();
  check_eq("invalid control preamble ignored",probe_flags,0);
  reset_case();
  // Idle and RGB-like symbols must not look like TERC or a data island.
  repeat(12) tick(10'h100,10'h055,10'h2AA);
  preamble_guard();
  vector_packet();
  // A second packet in the same island begins immediately: no guard between packets.
  tone_mode=1;
  audio_packet(4'hF,0,24'h0F4240,24'hF0BDC0,0);
  acr_packet();trailing_guard();
  wait_snapshot();
  check_eq("window1 audio packets",audio_packets_sec,2);
  check_eq("window1 sample pairs",audio_samples_sec,8);
  check_eq("window1 BCH errors",bad_bch_sec,0);
  check_eq("window1 TERC errors",bad_terc_sec,0);
  check_eq("window1 tone errors",tone_bad_sec,0);
  check_eq("window1 flags",probe_flags,4'b1110);
  check_eq("ACR CTS",acr_cts_last,20'd25000);
  check_eq("ACR N",acr_n_last,20'd6144);

  // Present/nonflat: SP0/SP1 are present, SP1 flat; only two sample pairs count,
  // but only SP0 is compared as tone data. A deliberately wrong tone is one bad pair.
  reset_case();tone_mode=1;preamble_guard();audio_packet(4'h3,4'h2,24'h000001,24'h000001,0);trailing_guard();wait_snapshot();
  check_eq("present samples",audio_samples_sec,2);
  check_eq("flat excluded from tone comparison",tone_bad_sec,1);

  // A data-bit BCH fault and an ECC-bit BCH fault each reject exactly one packet.
  reset_case();preamble_guard();
  packet_words(8'h0F,0,8'h02,56'h0,56'h0,56'h0,56'h0,4,0);
  packet_words(8'h0F,0,8'h02,56'h0,56'h0,56'h0,56'h0,5,0);
  packet_words(8'h0F,0,8'h02,56'h0,56'h0,56'h0,56'h0,3,0);
  packet_words(8'h0F,0,8'h02,56'h0,56'h0,56'h0,56'h0,4,55);
  packet_words(8'h0F,0,8'h02,56'h0,56'h0,56'h0,56'h0,5,7);
  trailing_guard();wait_snapshot();
  check_eq("bad packet BCH count incl last data/parity bits",bad_bch_sec,5);
  check_eq("bad packets not audio",audio_packets_sec,0);
  check_eq("bad packet flags format stays clear",probe_flags[0],0);

  // Invalid TERC mid-packet aborts; a fresh preamble/guard must resynchronize.
  reset_case();preamble_guard();
  packet_words(8'h0F,0,8'h02,audio_payload(24'h0F4240,24'hF0BDC0),audio_payload(24'h0F4240,24'hF0BDC0),audio_payload(24'h0F4240,24'hF0BDC0),audio_payload(24'h0F4240,24'hF0BDC0),6,14);
  preamble_guard();audio_packet(4'h1,0,24'h0F4240,24'hF0BDC0,0);trailing_guard();wait_snapshot();
  check_eq("invalid TERC count",bad_terc_sec,1);
  check_eq("resync good packet",audio_packets_sec,1);
  check_eq("resync tone valid",tone_bad_sec,0);

  // Malformed leading guard then valid island; and malformed audio layout/present flags.
  reset_case();
  repeat(8) tick(10'h354,10'h0AB,10'h0AB);
  tick(10'h28E,10'h133,10'h133);tick(10'h28E,10'h139,10'h133);
  preamble_guard();audio_packet(4'h5,0,24'h0F4240,24'hF0BDC0,0);trailing_guard();wait_snapshot();
  check_eq("malformed preamble still no valid packet",audio_packets_sec,0);
  check_eq("malformed layout sticky format flag",probe_flags[0],1);
  check_eq("malformed leading guard TERC count",bad_terc_sec,1);

  // The packet-completion event on the terminal window clock belongs to that snapshot.
  reset_case();tone_mode=1;
  repeat(WINDOW-43) idle_char();
  preamble_guard();audio_packet(4'hF,0,24'h0F4240,24'hF0BDC0,0);
  check_eq("terminal-clock audio packet snapshot",audio_packets_sec,1);
  check_eq("terminal-clock sample snapshot",audio_samples_sec,4);

  // ACR HB1/HB2 are ignored; CTS=0 leaves the previous nonzero CTS intact.
  reset_case();preamble_guard();acr_custom(8'hA5,8'h5A,20'd25000,20'd6144);
  acr_custom(8'hFF,8'hFF,20'd0,20'd12288);trailing_guard();
  check_eq("ACR ignored HB1/HB2 and retained CTS=0",acr_cts_last,20'd25000);
  check_eq("ACR zero CTS still updates N",acr_n_last,20'd12288);
  check_eq("ACR ignored HB fields do not set format error",probe_flags[0],0);

  // Flat is meaningful only for present subpackets; absent flat bits are ignored.
  reset_case();tone_mode=1;preamble_guard();audio_packet(4'h1,4'hE,24'h0F4240,24'hF0BDC0,0);trailing_guard();wait_snapshot();
  check_eq("absent flat fields do not reject audio",audio_packets_sec,1);
  check_eq("absent flat fields do not count absent samples",audio_samples_sec,1);
  check_eq("absent flat fields do not set format error",probe_flags[0],0);

  // Seed the near-overflow state so the arithmetic boundary is tested directly.
  reset_case();dut.win_samples=16'hFFFE;preamble_guard();audio_packet(4'h1,0,24'h0F4240,24'hF0BDC0,0);trailing_guard();wait_snapshot();
  check_eq("sample counter saturates at 65535",audio_samples_sec,24'd65535);
  check_eq("sample counter output upper bits stay zero",audio_samples_sec[23:16],8'd0);
  reset_case();dut.win_samples=16'hFFFF;preamble_guard();audio_packet(4'h1,0,24'h0F4240,24'hF0BDC0,0);trailing_guard();wait_snapshot();
  check_eq("sample counter does not wrap after saturation",audio_samples_sec,24'd65535);
  $display("PASS: audio_packet_monitor directed functional tests; assertions=%0d failures=%0d",checks,errors);
  if(errors!=0) $fatal(1,"FAILURES=%0d",errors);
  $finish;
 end
endmodule
