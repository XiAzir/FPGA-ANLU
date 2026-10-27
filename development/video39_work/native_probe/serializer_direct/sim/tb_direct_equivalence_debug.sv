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
  always @(negedge serial_clk) if(CASE_ID==1 && $realtime>=58.0 && $realtime<=61.0) begin
    $display("NEGEDGE t=%0t rst=%b q=%b/%b shift=%b/%b oddr=%b load=%b/%b/%b pending=%b primitive_ref=%b/%b direct=%b/%b",$realtime,rst,q_reference[0],q_direct[0],lanes[0].reference_lane.S_shift_data,lanes[0].direct_lane.S_shift_data,lanes[0].reference_lane.S_oddr_data,lanes[0].reference_lane.S_load_en,lanes[0].reference_lane.S_load_en_1d,lanes[0].reference_lane.S_load_en_2d,lanes[0].reference_lane.S_pending_data,lanes[0].reference_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[0].reference_lane.genblk1.U_EG4_ODDR.true_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.true_reg);
  end
  always @(posedge serial_clk) if(CASE_ID==1 && $realtime>=58.0 && $realtime<=61.0) begin
    $display("POSEDGE_ACTIVE t=%0t rst=%b q=%b/%b shift=%b/%b oddr=%b load=%b/%b/%b pending=%b primitive_ref=%b/%b direct=%b/%b",$realtime,rst,q_reference[0],q_direct[0],lanes[0].reference_lane.S_shift_data,lanes[0].direct_lane.S_shift_data,lanes[0].reference_lane.S_oddr_data,lanes[0].reference_lane.S_load_en,lanes[0].reference_lane.S_load_en_1d,lanes[0].reference_lane.S_load_en_2d,lanes[0].reference_lane.S_pending_data,lanes[0].reference_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[0].reference_lane.genblk1.U_EG4_ODDR.true_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.true_reg);
    #0.001;
    $display("POSEDGE_POST1PS t=%0t rst=%b q=%b/%b shift=%b/%b oddr=%b load=%b/%b/%b pending=%b primitive_ref=%b/%b direct=%b/%b",$realtime,rst,q_reference[0],q_direct[0],lanes[0].reference_lane.S_shift_data,lanes[0].direct_lane.S_shift_data,lanes[0].reference_lane.S_oddr_data,lanes[0].reference_lane.S_load_en,lanes[0].reference_lane.S_load_en_1d,lanes[0].reference_lane.S_load_en_2d,lanes[0].reference_lane.S_pending_data,lanes[0].reference_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[0].reference_lane.genblk1.U_EG4_ODDR.true_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.true_reg);
  end  always @(serial_clk) begin
    #0.2;
    if (q_reference !== q_direct) begin
      $display("FIRST_MISMATCH case=%0d phase_ps=%0d time_ns=%0t ref=%b direct=%b reset=%b words=%0d",CASE_ID,PHASE_PS,$time,q_reference,q_direct,rst,word_count);
      $display("lane0 ref shift=%b pending=%b odd_even=%b load=%b/%b/%b oddr=%b direct shift=%b",lanes[0].reference_lane.S_shift_data,lanes[0].reference_lane.S_pending_data,lanes[0].reference_lane.S_odd_even,lanes[0].reference_lane.S_load_en,lanes[0].reference_lane.S_load_en_1d,lanes[0].reference_lane.S_load_en_2d,lanes[0].reference_lane.S_oddr_data,lanes[0].direct_lane.S_shift_data);
      $display("states: i qref qdir shift odshift oddata reftrue dirtrue refcomp dircomp");
      $display("0 %b %b %b %b %b %b %b %b %b",q_reference[0],q_direct[0],lanes[0].direct_lane.S_shift_data,lanes[0].reference_lane.S_oddr_data,lanes[0].reference_lane.genblk1.U_EG4_ODDR.true_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.true_reg,lanes[0].reference_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[0].direct_lane.genblk1.U_EG4_ODDR.comp_reg);
      $display("1 %b %b %b %b %b %b %b %b %b",q_reference[1],q_direct[1],lanes[1].direct_lane.S_shift_data,lanes[1].reference_lane.S_oddr_data,lanes[1].reference_lane.genblk1.U_EG4_ODDR.true_reg,lanes[1].direct_lane.genblk1.U_EG4_ODDR.true_reg,lanes[1].reference_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[1].direct_lane.genblk1.U_EG4_ODDR.comp_reg);
      $display("2 %b %b %b %b %b %b %b %b %b",q_reference[2],q_direct[2],lanes[2].direct_lane.S_shift_data,lanes[2].reference_lane.S_oddr_data,lanes[2].reference_lane.genblk1.U_EG4_ODDR.true_reg,lanes[2].direct_lane.genblk1.U_EG4_ODDR.true_reg,lanes[2].reference_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[2].direct_lane.genblk1.U_EG4_ODDR.comp_reg);
      $display("3 %b %b %b %b %b %b %b %b %b",q_reference[3],q_direct[3],lanes[3].direct_lane.S_shift_data,lanes[3].reference_lane.S_oddr_data,lanes[3].reference_lane.genblk1.U_EG4_ODDR.true_reg,lanes[3].direct_lane.genblk1.U_EG4_ODDR.true_reg,lanes[3].reference_lane.genblk1.U_EG4_ODDR.comp_reg,lanes[3].direct_lane.genblk1.U_EG4_ODDR.comp_reg);
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
