`timescale 1ns/1ps
module tb_hdmi_packet_monitor;
  localparam integer WINDOW=80;
  reg clk=0, rst=1, tone_mode=1;
  reg [9:0] ch0=10'h0AB,ch1=10'h0AB,ch2=10'h0AB;
  wire [23:0] samples,packets,bad_bch,bad_terc,tone_bad;
  wire [19:0] cts_last,n_last;
  wire [3:0] flags;
  integer tests=0;
  always #5 clk=~clk;

  hdmi_packet_monitor #(.CLK_HZ(WINDOW),.TONE_AMP(24'd1000000)) dut(
    .clk(clk),.rst(rst),.tone_mode(tone_mode),.ch0(ch0),.ch1(ch1),.ch2(ch2),
    .audio_samples_sec(samples),.audio_packets_sec(packets),.bad_bch_sec(bad_bch),
    .bad_terc_sec(bad_terc),.tone_bad_sec(tone_bad),.acr_cts_last(cts_last),
    .acr_n_last(n_last),.probe_flags(flags));

  function [7:0] bch_step;
    input [7:0] r; input d; reg f;
    begin f=r[7]^d; bch_step={r[6:0],1'b0}^(f?8'hC1:8'h00); end
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
      14:terc_encode=10'h163;default:terc_encode=10'h2C3;
    endcase end
  endfunction
  task symbol;
    input [3:0] a,b,c;
    input integer invalid;
    begin
      @(negedge clk);
      ch0=invalid?10'h000:terc_encode(a);
      ch1=terc_encode(b); ch2=terc_encode(c);
    end
  endtask
  task control_symbol;
    begin @(negedge clk);ch0=10'h0AB;ch1=10'h0AB;ch2=10'h0AB;end
  endtask
  task guard_symbol;
    begin @(negedge clk);ch0=terc_encode(4'hC);ch1=10'h133;ch2=10'h133;end
  endtask
  task island_start;
    integer k;
    begin
      for(k=0;k<8;k=k+1) control_symbol();
      guard_symbol();guard_symbol();
    end
  endtask
  task island_end;
    begin guard_symbol();guard_symbol();end
  endtask
  task send_packet;
    input [23:0] header;
    input [55:0] p0,p1,p2,p3;
    input integer flip_header_bch;
    input integer invalid_terc_at;
    reg [7:0] rh,r0,r1,r2,r3;
    reg [3:0] n0,n1,n2;
    integer k;
    begin
      rh=0;r0=0;r1=0;r2=0;r3=0;
      for(k=0;k<24;k=k+1) rh=bch_step(rh,header[k]);
      for(k=0;k<56;k=k+1) begin
        r0=bch_step(r0,p0[k]);r1=bch_step(r1,p1[k]);
        r2=bch_step(r2,p2[k]);r3=bch_step(r3,p3[k]);
      end
      for(k=0;k<32;k=k+1) begin
        n0=0;n1=0;n2=0;
        if(k<24) n0[2]=header[k];
        else begin
          n0[2]=rh[7-(k-24)];
          if(flip_header_bch!=0 && k==24) n0[2]=~n0[2];
        end
        if(k<28) begin
          n1[0]=p0[2*k];n2[0]=p0[2*k+1];
          n1[1]=p1[2*k];n2[1]=p1[2*k+1];
          n1[2]=p2[2*k];n2[2]=p2[2*k+1];
          n1[3]=p3[2*k];n2[3]=p3[2*k+1];
        end else begin
          n1[0]=r0[7-2*(k-28)];n2[0]=r0[6-2*(k-28)];
          n1[1]=r1[7-2*(k-28)];n2[1]=r1[6-2*(k-28)];
          n1[2]=r2[7-2*(k-28)];n2[2]=r2[6-2*(k-28)];
          n1[3]=r3[7-2*(k-28)];n2[3]=r3[6-2*(k-28)];
        end
        symbol(n0,n1,n2,(invalid_terc_at==k));
      end
    end
  endtask
  task audio_packet;
    input [23:0] sample_value;
    input integer flip_bch;
    input integer bad_terc;
    reg [55:0] payload;
    begin
      payload=56'd0;payload[23:0]=sample_value;payload[47:24]=sample_value;
      send_packet({8'h00,8'h01,8'h02},payload,56'd0,56'd0,56'd0,flip_bch,bad_terc);
    end
  endtask
  task acr_packet;
    reg [55:0] payload;
    begin
      payload=56'd0;
      payload[11:8]=4'h0;payload[23:16]=8'h61;payload[31:24]=8'hA8;
      payload[47:40]=8'h18; // N=0x01800=6144
      payload[55:48]=8'h00;
      send_packet({8'h00,8'h00,8'h01},payload,payload,payload,payload,0,-1);
    end
  endtask
  task reset_case;
    input integer mode;
    begin
      @(negedge clk);rst=1;tone_mode=mode;ch0=10'h000;ch1=10'h000;ch2=10'h000;
      repeat(3) @(negedge clk);
      rst=0;
    end
  endtask
  task wait_cycles;
    input integer n;
    begin repeat(n) @(negedge clk); end
  endtask
  task check_zero;
    begin
      if(samples!==0 || packets!==0 || bad_bch!==0 || bad_terc!==0 || tone_bad!==0)
        $fatal(1,"expected zero counters s=%0d p=%0d bch=%0d terc=%0d tone=%0d",samples,packets,bad_bch,bad_terc,tone_bad);
    end
  endtask
  initial begin
    // Legal positive/negative 1e6 SP1 packets, contiguous in one island.
    reset_case(1); island_start(); audio_packet(24'h0F4240,0,-1);
    audio_packet(24'hF0BDC0,0,-1); island_end(); wait_cycles(5);
    if(packets!==2 || samples!==2 || bad_bch!==0 || bad_terc!==0 || tone_bad!==0)
      $fatal(1,"legal +/- tone or same-island count failed p=%0d s=%0d bch=%0d terc=%0d tone=%0d flags=%h",packets,samples,bad_bch,bad_terc,tone_bad,flags);
    tests=tests+1;$display("PASS legal +/- tone, two consecutive packets in one island");

    // Wrong magnitude with valid recomputed BCH must be tone_bad, not BCH.
    reset_case(1); island_start(); audio_packet(24'd500000,0,-1); island_end(); wait_cycles(40);
    if(packets!==1 || samples!==1 || bad_bch!==0 || tone_bad!==1)
      $fatal(1,"wrong-amplitude tone control failed p=%0d s=%0d bch=%0d tone=%0d flags=%h",packets,samples,bad_bch,tone_bad,flags);
    tests=tests+1;$display("PASS wrong 500000 amplitude: tone_bad=1 and BCH=0");
    wait_cycles(WINDOW+3);check_zero();
    tests=tests+1;$display("PASS window rollover clears counters when no new packet arrives");

    // Original-audio mode must not enforce the built-in tone amplitude.
    reset_case(0); island_start(); audio_packet(24'd500000,0,-1); island_end(); wait_cycles(40);
    if(packets!==1 || samples!==1 || bad_bch!==0 || tone_bad!==0)
      $fatal(1,"original-audio mode incorrectly constrained: p=%0d s=%0d bch=%0d tone=%0d",packets,samples,bad_bch,tone_bad);
    tests=tests+1;$display("PASS original-audio mode does not impose tone amplitude");

    // BCH parity bit flip should be counted while no valid audio packet is counted.
    reset_case(1); island_start(); audio_packet(24'h0F4240,1,-1); island_end(); wait_cycles(40);
    if(packets!==0 || bad_bch!==1 || tone_bad!==0)
      $fatal(1,"BCH negative control failed p=%0d bch=%0d tone=%0d flags=%h",packets,bad_bch,tone_bad,flags);
    tests=tests+1;$display("PASS flipped header BCH parity detected");

    // Illegal TERC symbol inside packet should break parse and increment bad_terc.
    reset_case(1); island_start(); audio_packet(24'h0F4240,0,10); island_end(); wait_cycles(40);
    if(packets!==0 || bad_terc==0 || flags[0]!==1'b1)
      $fatal(1,"illegal TERC negative control failed p=%0d terc=%0d flags=%h",packets,bad_terc,flags);
    tests=tests+1;$display("PASS illegal TERC symbol detected");

    // Valid ACR packet and its four equal subpackets.
    reset_case(0); island_start(); acr_packet(); island_end(); wait_cycles(40);
    if(cts_last!==20'd25000 || n_last!==20'd6144 || flags[1]!==1'b1 || bad_bch!==0 || bad_terc!==0)
      $fatal(1,"ACR decode failed CTS=%0d N=%0d flags=%h BCH=%0d TERC=%0d",cts_last,n_last,flags,bad_bch,bad_terc);
    tests=tests+1;$display("PASS ACR N=6144 CTS=25000, four repeated subpackets");

    // No packet for a window remains zero after reset and rollover.
    reset_case(1);wait_cycles(WINDOW+3);check_zero();
    tests=tests+1;$display("PASS empty windows remain zero");

    $display("PACKET_MONITOR_PASS cases=%0d window=%0d",tests,WINDOW);
    $finish;
  end
  initial begin #1000000;$fatal(1,"test timeout");end
endmodule







