`timescale 1ns/1ps
module tb_audio_metadata_patch;
  localparam integer MAX_WORDS=12000;
  reg clk=0, rst=1;
  always #5 clk=~clk;
  reg [9:0] stim0[0:MAX_WORDS-1],stim1[0:MAX_WORDS-1],stim2[0:MAX_WORDS-1],stimc[0:MAX_WORDS-1];
  reg [9:0] exp0[0:MAX_WORDS-1],exp1[0:MAX_WORDS-1],exp2[0:MAX_WORDS-1],expc[0:MAX_WORDS-1];
  integer words=0, drive_index=0, packet_id=0, audio_count=0, b_packet_start=-1, neg_target=-1;
  reg [7:0] c_phase=0;
  reg c_valid=0;
  reg compact_audio=0;
  reg [9:0] lane0_i=10'h354,lane1_i=10'h0AB,lane2_i=10'h0AB,clock_i=10'b0000011111;
  wire [9:0] lane0_o,lane1_o,lane2_o,clock_o;
  wire [9:0] neg_lane1;
  wire [4:0] neg_decode=terc_decode(lane1_o);
  wire [23:0] clean_samples,clean_packets,clean_bad_bch,clean_bad_terc,clean_tone;
  wire [23:0] neg_samples,neg_packets,neg_bad_bch,neg_bad_terc,neg_tone;
  wire [19:0] cts0,n0,cts1,n1;
  wire [3:0] flags0,flags1;
  integer clean_bch_seen=0,clean_terc_seen=0,negative_bch_seen=0,c_set_frames=0;
  integer i,j,s,pb_sum;
  reg [55:0] body_i[0:3],body_e[0:3];
  reg [7:0] pb_i[0:9],pb_e[0:9];
  reg [7:0] hb0,hb1,hb2;
  reg [23:0] left_pcm,right_pcm;
  reg [19:0] acr_cts,acr_n;
  reg [7:0] bh_i[0:3],bh_e[0:3],hh_i,hh_e;
  reg [3:0] a1i,a2i,a1e,a2e,a0i,a0e;
  reg hbbit_i,hbbit_e,bit_i,bit_e;
  reg [7:0] tmpb;
  reg [9:0] ci0,ci1,ci2,ei0,ei1,ei2;
  reg [9:0] guard0;
  reg [9:0] lane0_d,lane1_d,lane2_d,clock_d;
  reg [4:0] terc_tmp;
  reg [7:0] checker_header;
  integer neg_index;

  function [4:0] terc_decode;
    input [9:0] x;
    begin case(x)
      10'h29C:terc_decode=5'h10; 10'h263:terc_decode=5'h11; 10'h2E4:terc_decode=5'h12; 10'h2E2:terc_decode=5'h13;
      10'h171:terc_decode=5'h14; 10'h11E:terc_decode=5'h15; 10'h18E:terc_decode=5'h16; 10'h13C:terc_decode=5'h17;
      10'h2CC:terc_decode=5'h18; 10'h139:terc_decode=5'h19; 10'h19C:terc_decode=5'h1A; 10'h2C6:terc_decode=5'h1B;
      10'h28E:terc_decode=5'h1C; 10'h271:terc_decode=5'h1D; 10'h163:terc_decode=5'h1E; 10'h2C3:terc_decode=5'h1F;
      default:terc_decode=5'h00;
    endcase end
  endfunction
  function [9:0] terc_encode;
    input [3:0] n;
    begin case(n)
      0:terc_encode=10'h29C; 1:terc_encode=10'h263; 2:terc_encode=10'h2E4; 3:terc_encode=10'h2E2;
      4:terc_encode=10'h171; 5:terc_encode=10'h11E; 6:terc_encode=10'h18E; 7:terc_encode=10'h13C;
      8:terc_encode=10'h2CC; 9:terc_encode=10'h139; 10:terc_encode=10'h19C; 11:terc_encode=10'h2C6;
      12:terc_encode=10'h28E; 13:terc_encode=10'h271; 14:terc_encode=10'h163; 15:terc_encode=10'h2C3;
    endcase end
  endfunction
  function [7:0] bch_step;
    input [7:0] r; input d; reg f;
    begin f=r[7]^d; bch_step={r[6:0],1'b0}^(f?8'hC1:8'h00); end
  endfunction

  hdmi_audio_metadata_patch dut(.pixel_clk(clk),.reset(rst),
    .lane0_i(lane0_i),.lane1_i(lane1_i),.lane2_i(lane2_i),.clock_i(clock_i),
    .lane0_o(lane0_o),.lane1_o(lane1_o),.lane2_o(lane2_o),.clock_o(clock_o));
  assign neg_lane1=(drive_index>=9 && drive_index-9==neg_target && neg_decode[4]) ?
                   terc_encode(neg_decode[3:0]^4'h1) : lane1_o;
  hdmi_packet_monitor #(.CLK_HZ(1)) clean_checker(.clk(clk),.rst(rst),.tone_mode(1'b0),
    .ch0(lane0_o),.ch1(lane1_o),.ch2(lane2_o),.audio_samples_sec(clean_samples),
    .audio_packets_sec(clean_packets),.bad_bch_sec(clean_bad_bch),.bad_terc_sec(clean_bad_terc),
    .tone_bad_sec(clean_tone),.acr_cts_last(cts0),.acr_n_last(n0),.probe_flags(flags0));
  hdmi_packet_monitor #(.CLK_HZ(1)) negative_checker(.clk(clk),.rst(rst),.tone_mode(1'b0),
    .ch0(lane0_o),.ch1(neg_lane1),.ch2(lane2_o),.audio_samples_sec(neg_samples),
    .audio_packets_sec(neg_packets),.bad_bch_sec(neg_bad_bch),.bad_terc_sec(neg_bad_terc),
    .tone_bad_sec(neg_tone),.acr_cts_last(cts1),.acr_n_last(n1),.probe_flags(flags1));

  task append_word_pair;
    input [9:0] a0,a1,a2,e0,e1,e2;
    begin
      if(words>=MAX_WORDS) $fatal(1,"stimulus overflow");
      stim0[words]=a0;stim1[words]=a1;stim2[words]=a2;stimc[words]=10'b0000011111;
      exp0[words]=e0;exp1[words]=e1;exp2[words]=e2;expc[words]=10'b0000011111;
      words=words+1;
    end
  endtask
  task append_control;
    input integer count;
    integer q;
    begin for(q=0;q<count;q=q+1) append_word_pair(10'h354,10'h0AB,10'h0AB,10'h354,10'h0AB,10'h0AB); end
  endtask
  task append_guard;
    input integer count;
    integer q;
    begin for(q=0;q<count;q=q+1) append_word_pair(10'h28E,10'h133,10'h133,10'h28E,10'h133,10'h133); end
  endtask
  task serialize_current_packet;
    integer q,z;
    reg [3:0] n0a,n1a,n2a,n0b,n1b,n2b;
    reg [7:0] hv_i,hv_e;
    begin
      hh_i=0;hh_e=0;for(z=0;z<4;z=z+1) begin bh_i[z]=0;bh_e[z]=0;end
      for(q=0;q<32;q=q+1) begin
        n0a=0;n1a=0;n2a=0;n0b=0;n1b=0;n2b=0;
        if(q<24) begin
          hbbit_i=(q<8)?hb0[q]:((q<16)?hb1[q-8]:hb2[q-16]);
          hbbit_e=hbbit_i;
          n0a[2]=hbbit_i;n0b[2]=hbbit_e;
          hh_i=bch_step(hh_i,hbbit_i);hh_e=bch_step(hh_e,hbbit_e);
        end else begin
          n0a[2]=hh_i[7];n0b[2]=hh_e[7];hh_i={hh_i[6:0],1'b0};hh_e={hh_e[6:0],1'b0};
        end
        if(q<28) begin
          for(z=0;z<4;z=z+1) begin
            n1a[z]=body_i[z][2*q];n2a[z]=body_i[z][2*q+1];
            n1b[z]=body_e[z][2*q];n2b[z]=body_e[z][2*q+1];
            bh_i[z]=bch_step(bch_step(bh_i[z],n1a[z]),n2a[z]);
            bh_e[z]=bch_step(bch_step(bh_e[z],n1b[z]),n2b[z]);
          end
        end else begin
          for(z=0;z<4;z=z+1) begin
            n1a[z]=bh_i[z][7];n2a[z]=bh_i[z][6];bh_i[z]={bh_i[z][5:0],2'b00};
            n1b[z]=bh_e[z][7];n2b[z]=bh_e[z][6];bh_e[z]={bh_e[z][5:0],2'b00};
          end
        end
        append_word_pair(terc_encode(n0a),terc_encode(n1a),terc_encode(n2a),
                         terc_encode(n0b),terc_encode(n1b),terc_encode(n2b));
      end
    end
  endtask
  task append_packet;
    input [7:0] typ;
    input integer sample_number;
    integer q;
    begin
      if(!compact_audio) begin append_control(8);append_guard(2);end
      hb0=typ;hb1=(typ==8'h84)?8'h01:((typ==8'h02)?8'h01:8'h00);
      hb2=(typ==8'h84)?8'h0A:8'h00;
      for(q=0;q<4;q=q+1) begin body_i[q]=0;body_e[q]=0;end
      for(q=0;q<10;q=q+1) begin pb_i[q]=0;pb_e[q]=0;end
      if(typ==8'h84) begin
        pb_i[0]=8'h70;pb_i[1]=8'h90;pb_i[2]=8'h00;
        pb_e[0]=8'h61;pb_e[1]=8'h90;pb_e[2]=8'h0F;
        for(q=0;q<7;q=q+1) begin body_i[0][q*8 +: 8]=pb_i[q];body_e[0][q*8 +: 8]=pb_e[q];end
        for(q=7;q<10;q=q+1) begin body_i[1][(q-7)*8 +: 8]=pb_i[q];body_e[1][(q-7)*8 +: 8]=pb_e[q];end
        pb_sum=0;for(q=0;q<10;q=q+1) pb_sum=pb_sum+pb_i[q];if((pb_sum&255)!=0)$fatal(1,"input AIF checksum invalid");
        pb_sum=0;for(q=0;q<10;q=q+1) pb_sum=pb_sum+pb_e[q];if((pb_sum&255)!=0)$fatal(1,"expected AIF checksum invalid");
      end else if(typ==8'h01) begin
        acr_cts=20'd25000;acr_n=20'd6144;
        for(q=0;q<4;q=q+1) begin
          body_i[q][11:8]=acr_cts[19:16];body_i[q][23:16]=acr_cts[15:8];body_i[q][31:24]=acr_cts[7:0];
          body_i[q][35:32]=acr_n[19:16];body_i[q][47:40]=acr_n[15:8];body_i[q][55:48]=acr_n[7:0];
          body_e[q]=body_i[q];
        end
      end else if(typ==8'h02) begin
        if(sample_number==191) begin hb2=8'h10;b_packet_start=words;end
        left_pcm=24'h381247 ^ sample_number;right_pcm=24'hA42D91 + sample_number;
        body_i[0][23:0]=left_pcm;body_i[0][47:24]=right_pcm;
        body_i[0][51]=^left_pcm;body_i[0][55]=^right_pcm;
        body_e[0]=body_i[0];
        if(sample_number==191) begin c_valid=1;c_phase=0;end
        if(c_valid && (c_phase==25 || c_phase==32 || c_phase==33 || c_phase==35)) begin
          body_e[0][50]=1'b1;body_e[0][51]=~body_e[0][51];
          body_e[0][54]=1'b1;body_e[0][55]=~body_e[0][55];
          c_set_frames=c_set_frames+1;
        end
        if(c_valid) begin if(c_phase==191)c_phase=0;else c_phase=c_phase+1'b1;end
        audio_count=audio_count+1;
      end
      serialize_current_packet();
      if(!compact_audio && typ!=8'h02) append_guard(2);
      packet_id=packet_id+1;
    end
  endtask

  always @(posedge clk) begin
    if(!rst) begin
      if(clean_bad_bch!=0) clean_bch_seen=clean_bch_seen+clean_bad_bch;
      if(clean_bad_terc!=0) clean_terc_seen=clean_terc_seen+clean_bad_terc;
      if(neg_bad_bch!=0) negative_bch_seen=negative_bch_seen+neg_bad_bch;
    end
  end

  initial begin
    for(i=0;i<16;i=i+1)
      append_word_pair(10'h010+i,10'h100+i,10'h200+i,10'h010+i,10'h100+i,10'h200+i);
    append_packet(8'h84,0);
    append_packet(8'h01,0);
    compact_audio=0;append_packet(8'h02,0);
    compact_audio=1;for(i=1;i<228;i=i+1) append_packet(8'h02,i);
    append_guard(2);
    neg_target=b_packet_start+28;
    repeat(4) @(posedge clk); #1;rst=0;
    for(i=0;i<words+9;i=i+1) begin
      @(negedge clk);
      drive_index=i;
      if(i<words) begin lane0_i=stim0[i];lane1_i=stim1[i];lane2_i=stim2[i];clock_i=stimc[i];end
      else begin lane0_i=10'h000;lane1_i=10'h000;lane2_i=10'h000;clock_i=10'b0000011111;end
      @(posedge clk);#1;
      if(i<8 && clock_o!==10'b0000011111)$fatal(1,"clock reset fill must match physical 01F word");
      if(i>=8 && i-8<words) begin
        if(lane0_o!==exp0[i-8] || lane1_o!==exp1[i-8] || lane2_o!==exp2[i-8] || clock_o!==expc[i-8]) begin
          $display("RAW_WORD_MISMATCH src=%0d got=%03h/%03h/%03h/%03h exp=%03h/%03h/%03h/%03h in_state=%0d in_idx=%0d in_type=%02h tag=%b/%0d cphase=%0d",i-8,lane0_o,lane1_o,lane2_o,clock_o,exp0[i-8],exp1[i-8],exp2[i-8],expc[i-8],dut.in_state,dut.in_idx,dut.in_type,dut.packet_valid_pipe[7],dut.packet_index_pipe[7],dut.channel_status_index);
          $fatal(1,"TMDS stream mismatch");
        end
      end
    end
    repeat(10) @(posedge clk);#1;
    if(clean_bch_seen!=0 || clean_terc_seen!=0)$fatal(1,"patched raw stream failed original BCH/TERC checker: bch=%0d terc=%0d",clean_bch_seen,clean_terc_seen);
    if(negative_bch_seen==0)$fatal(1,"negative parity control was not detected by original BCH checker");
    if(cts0!=20'd25000 || n0!=20'd6144)$fatal(1,"ACR transparency/value check failed CTS=%0d N=%0d",cts0,n0);
    if(audio_count!=228 || b_packet_start<0)$fatal(1,"raw packet vector incomplete");
    if(c_set_frames!=4)$fatal(1,"192-frame C status reconstruction expected four indexed samples, got %0d",c_set_frames);
    $display("AIF_CHECKSUM_PASS input PB0=70 PB2=00 expected/output PB0=61 PB2=0F");
    $display("C_STATUS_PASS B_packet=191 C_indices=25,32,33,35 left/right P toggled with C; samples=228");
    $display("RAW_TMDSPATCH_PASS words=%0d delay=8 video/control/ACR unchanged, PCM unchanged, original_BCH_bad=%0d original_TERC_bad=%0d negative_BCH_detected=%0d",words,clean_bch_seen,clean_terc_seen,negative_bch_seen);
    $finish;
  end
endmodule

