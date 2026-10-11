`timescale 1ps/1ps
module EG_LOGIC_ODDR(input wire clk,input wire rst,input wire d1,input wire d0,output reg q);
    always @(posedge clk or posedge rst) if(rst) q<=1'b0; else q<=d1;
    always @(negedge clk or posedge rst) if(rst) q<=1'b0; else q<=d0;
endmodule
module tb_four_lane_restart;
    reg pixel_clk=0,serial_clk=0,rst=0;
    wire [3:0] serial_out;
    integer epoch=0,strobe_mismatches=0,load_word_mismatches=0,reset_clear_mismatches=0;
    integer pulses_epoch1=0,pulses_epoch2=0;
    reg did_load;
    reg [9:0] pre0,pre1,pre2,pre3;
    lane_lvds_10_1 #(.DEVICE("EG")) l0(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),.I_data_in(10'h155),.O_serial_out(serial_out[0]));
    lane_lvds_10_1 #(.DEVICE("EG")) l1(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),.I_data_in(10'h2a6),.O_serial_out(serial_out[1]));
    lane_lvds_10_1 #(.DEVICE("EG")) l2(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),.I_data_in(10'h0d3),.O_serial_out(serial_out[2]));
    lane_lvds_10_1 #(.DEVICE("EG")) l3(.I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),.I_data_in(10'h3c9),.O_serial_out(serial_out[3]));
    always #20000 pixel_clk=~pixel_clk;
    always #4000 serial_clk=~serial_clk;
    always @(posedge rst) epoch=epoch+1;
    always @(posedge rst) begin
        #1;
        if(l0.S_pending_data!==10'd0 || l1.S_pending_data!==10'd0 || l2.S_pending_data!==10'd0 || l3.S_pending_data!==10'd0 ||
           l0.S_shift_data!==10'd0 || l1.S_shift_data!==10'd0 || l2.S_shift_data!==10'd0 || l3.S_shift_data!==10'd0)
            reset_clear_mismatches=reset_clear_mismatches+1;
    end

    always @(posedge serial_clk) begin
        if(!rst) begin
            if(l0.S_load_en_2d!==l1.S_load_en_2d || l0.S_load_en_2d!==l2.S_load_en_2d || l0.S_load_en_2d!==l3.S_load_en_2d) strobe_mismatches=strobe_mismatches+1;
            did_load=(l0.S_load_en_2d===1'b1);
            pre0=l0.S_pending_data; pre1=l1.S_pending_data; pre2=l2.S_pending_data; pre3=l3.S_pending_data;
            #1;
            if(did_load) begin
                if(l0.S_shift_data!==pre0 || l1.S_shift_data!==pre1 || l2.S_shift_data!==pre2 || l3.S_shift_data!==pre3)
                    load_word_mismatches=load_word_mismatches+1;
                if(epoch==1) pulses_epoch1=pulses_epoch1+1;
                if(epoch==2) pulses_epoch2=pulses_epoch2+1;
            end
        end
    end
    initial begin
        #1 rst=1;
        #499999 rst=0;
        #810000 rst=1;
        #400000 rst=0;
        #800000;
        $display("FOUR_LANE_RESTART epochs=%0d pulses_first=%0d pulses_after_restart=%0d strobe_mismatches=%0d loaded_word_mismatches=%0d reset_clear_mismatches=%0d",epoch,pulses_epoch1,pulses_epoch2,strobe_mismatches,load_word_mismatches,reset_clear_mismatches);
        if(epoch<2 || pulses_epoch1<10 || pulses_epoch2<10 || strobe_mismatches!=0 || load_word_mismatches!=0 || reset_clear_mismatches!=0) $fatal(1,"restart/four-lane check failed");
        $finish;
    end
endmodule
