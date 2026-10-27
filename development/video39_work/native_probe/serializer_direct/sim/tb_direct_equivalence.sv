`timescale 1ns/1ps
module phase_case #(parameter integer PHASE_PS=0, parameter integer CASE_ID=0)(output reg done);
  localparam real PIXEL_HALF_NS=6.73076925;
  localparam real SERIAL_HALF_NS=1.34615385;
  reg pixel_clk=0, serial_clk=0, rst=1;
  reg [9:0] data_in[0:3];
  integer seeds[0:3];
  integer word_count=0, compare_count=0, lane;
  wire [3:0] q_reference, q_direct;
  initial begin
    done=0;
    seeds[0]=101+CASE_ID*31; seeds[1]=213+CASE_ID*37;
    seeds[2]=317+CASE_ID*41; seeds[3]=419+CASE_ID*43;
    for(lane=0;lane<4;lane=lane+1) data_in[lane]=10'h000;
    forever #(PIXEL_HALF_NS) pixel_clk=~pixel_clk;
  end
  initial begin
    #(PHASE_PS/1000.0);
    forever #(SERIAL_HALF_NS) serial_clk=~serial_clk;
  end
  always @(posedge pixel_clk) begin
    word_count=word_count+1;
    for(lane=0;lane<4;lane=lane+1) data_in[lane] <= $random(seeds[lane]);
  end
  genvar i;
  generate for(i=0;i<4;i=i+1) begin: lanes
    lane_lvds_10_1_reference #(.DEVICE("EG")) reference_lane(
      .I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),
      .I_data_in(data_in[i]),.O_serial_out(q_reference[i]));
    lane_lvds_10_1 #(.DEVICE("EG")) direct_lane(
      .I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),
      .I_data_in(data_in[i]),.O_serial_out(q_direct[i]));
  end endgenerate
  always @(serial_clk) begin
    #0.2;
    if (q_reference !== q_direct) begin
      $display("FIRST_MISMATCH case=%0d phase_ps=%0d time_ns=%0t ref=%b direct=%b reset=%b words=%0d",CASE_ID,PHASE_PS,$time,q_reference,q_direct,rst,word_count);
      $fatal(1,"Physical q mismatch");
    end
    compare_count=compare_count+1;
  end
  initial begin
    // Initial async reset covers several complete serial periods.
    #40.0 rst=0;
    // Playback reset asserted on a pixel edge and held longer than one serial period.
    repeat(52) @(posedge pixel_clk);
    rst=1; #3.2 rst=0;
    // Async reset occurs between clock edges and also spans more than one serial period.
    #689.123 rst=1; #3.2 rst=0;
    #750.0;
    if(word_count < 32) $fatal(1,"Insufficient random words: %0d",word_count);
    if(compare_count < 1000) $fatal(1,"Insufficient physical q comparisons: %0d",compare_count);
    $display("PHASE_CASE_PASS case=%0d phase_ps=%0d words_per_lane=%0d q_samples=%0d",CASE_ID,PHASE_PS,word_count,compare_count);
    done=1;
  end
endmodule

module tb_direct_equivalence;
  wire [2:0] done;
  phase_case #(.PHASE_PS(0),.CASE_ID(0)) p0(done[0]);
  phase_case #(.PHASE_PS(400),.CASE_ID(1)) p1(done[1]);
  phase_case #(.PHASE_PS(1000),.CASE_ID(2)) p2(done[2]);
  initial begin
    wait(&done);
    $display("DIRECT_SERIALIZER_Q_EQUIVALENCE_PASS cases=3 lanes_per_case=4 random_words_per_lane>=32");
    $finish;
  end
endmodule
