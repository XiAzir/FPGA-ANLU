`timescale 1ps/1ps
`ifdef CANDIDATE
`define AUDIT_LOADED_WORD dut.S_pending_data
`else
`define AUDIT_LOADED_WORD data_in
`endif
module EG_LOGIC_ODDR(input wire clk, input wire rst, input wire d1, input wire d0, output reg q);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 1'b0; else q <= d1;
    end
    always @(negedge clk or posedge rst) begin
        if (rst) q <= 1'b0; else q <= d0;
    end
endmodule
module tb_delay_injection #(parameter integer INJECT_TOGGLE_DELAY_PS=800);
    reg pixel_clk=0, serial_clk=0, rst=0;
    reg [9:0] data_in=10'h155, next_word=10'h155;
    wire serial_out;
    integer phase_ps=100, skew_mode=97;
    integer pixel_index=0, load_count=0, target_errors=0;
    integer output_words=0, sequence_errors=0, bit_count=0, sampled_bits=0;
    integer align_bit=-1, align_load=-1, match_run;
    integer i,j,k,expected_index;
    integer sample_offset_ps, min_offset_ps=40000, max_offset_ps=0;
    reg [9:0] loaded_words[0:255];
    reg out_bits[0:5119];
    integer skew0,skew1,skew2,skew3,skew4,skew5,skew6,skew7,skew8,skew9;
    reg dump_enable=0;
    reg trace_enable=0;

    lane_lvds_10_1 #(.DEVICE("EG"),.TOGGLE_DELAY_PS(INJECT_TOGGLE_DELAY_PS)) dut(
        .I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),
        .I_data_in(data_in),.O_serial_out(serial_out)
    );
    always #20000 pixel_clk=~pixel_clk;

    initial begin
        if (!$value$plusargs("phase=%d",phase_ps)) phase_ps=100;
        if (!$value$plusargs("mode=%d",skew_mode)) skew_mode=97;
        if ($test$plusargs("dump")) dump_enable=1;
        if ($test$plusargs("trace")) trace_enable=1;
        skew0=50+((0*skew_mode)%951); skew1=50+((1*skew_mode)%951);
        skew2=50+((2*skew_mode)%951); skew3=50+((3*skew_mode)%951);
        skew4=50+((4*skew_mode)%951); skew5=50+((5*skew_mode)%951);
        skew6=50+((6*skew_mode)%951); skew7=50+((7*skew_mode)%951);
        skew8=50+((8*skew_mode)%951); skew9=50+((9*skew_mode)%951);
        #1 rst=1; #399999 rst=0;
        if(dump_enable) begin
            $dumpfile("development/player_osd/build/serializer_audit/delay_repro.vcd");
            $dumpvars(0,pixel_clk,serial_clk,rst,data_in,next_word,pixel_index,
                dut.S_odd_even,dut.S_odd_even_1d,dut.S_odd_even_2d,
                dut.S_load_en,dut.S_load_en_1d,dut.S_load_en_2d,
                dut.S_shift_data,dut.S_oddr_data,serial_out);
`ifdef CANDIDATE
            $dumpvars(0,dut.S_pending_data);
`endif
        end
    end
    initial begin
        #1;
        #(19999+phase_ps);
        forever begin serial_clk=1; #4000 serial_clk=0; #4000; end
    end
    always @(posedge pixel_clk) begin
        if(!rst) begin
            pixel_index=pixel_index+1;
            next_word=pattern(pixel_index);
            if(trace_enable) $display("PIXEL t=%0t idx=%0d next=%03x data=%03x",$time,pixel_index,next_word,data_in);
        end
    end
    always @(posedge pixel_clk) if(!rst) begin #(skew0); data_in[0]=next_word[0]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew1); data_in[1]=next_word[1]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew2); data_in[2]=next_word[2]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew3); data_in[3]=next_word[3]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew4); data_in[4]=next_word[4]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew5); data_in[5]=next_word[5]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew6); data_in[6]=next_word[6]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew7); data_in[7]=next_word[7]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew8); data_in[8]=next_word[8]; end
    always @(posedge pixel_clk) if(!rst) begin #(skew9); data_in[9]=next_word[9]; end

    function [9:0] pattern(input integer n);
        begin
            case(n%3)
                0: pattern=10'b0000000000;
                1: pattern=10'b1111100000;
                default: pattern=10'b0000011111;
            endcase
        end
    endfunction
    function [9:0] sampled_word(input integer start_bit);
        integer b;
        reg [9:0] w;
        begin w=0; for(b=0;b<10;b=b+1) w={w[8:0],out_bits[start_bit+b]}; sampled_word=w; end
    endfunction
    initial begin
        #4405000;
        for(i=0;i<=120 && align_bit<0;i=i+1) begin
            for(j=0;j<=20 && align_bit<0;j=j+1) begin
                if(i+49>=sampled_bits || j+4>=load_count) match_run=0;
                else match_run=1;
                for(k=0;k<5;k=k+1)
                    if(match_run && sampled_word(i+10*k) !== loaded_words[j+k]) match_run=0;
                if(match_run && align_bit<0) begin align_bit=i; align_load=j; end
            end
        end
        if(align_bit>=0) begin
            output_words=(sampled_bits-align_bit)/10;
            $display("OUTPUT_ALIGN bit_index=%0d load_index=%0d bit_phase_mod10=%0d",align_bit,align_load,align_bit%10);
            for(k=5;k<output_words;k=k+1) begin
                expected_index=align_load+k;
                if(expected_index<load_count && sampled_word(align_bit+10*k) !== loaded_words[expected_index]) begin
                    sequence_errors=sequence_errors+1;
                    if(sequence_errors<=5) $display("SERIAL_WORD_MISMATCH out_n=%0d got=%03x captured=%03x index=%0d",k,sampled_word(align_bit+10*k),loaded_words[expected_index],expected_index);
                end
            end
        end else begin
            sequence_errors=1;
            $display("OUTPUT_ALIGN_NONE: no five-word 10-bit run matched captured load words");
        end
        $display("SUMMARY phase_ps=%0d toggle_delay_ps=%0d skew_mode=%0d loads=%0d target_word_errors=%0d output_words=%0d output_sequence_errors=%0d sample_offset_ps=%0d..%0d",phase_ps,INJECT_TOGGLE_DELAY_PS,skew_mode,load_count,target_errors,output_words,sequence_errors,min_offset_ps,max_offset_ps);
        $finish;
    end
    always @(posedge serial_clk) begin
        if(trace_enable && dut.S_load_en_1d) $display("EARLY_SAMPLE t=%0t pix=%0d data=%03x sampled=%03x",$time,pixel_index,data_in,`AUDIT_LOADED_WORD);
        if (!rst && dut.S_load_en_2d) begin
            if(trace_enable) $display("SHIFT_LOAD t=%0t pix=%0d data=%03x sampled=%03x",$time,pixel_index,data_in,`AUDIT_LOADED_WORD);
            sample_offset_ps=($time-20000)%40000;
            if(sample_offset_ps<min_offset_ps) min_offset_ps=sample_offset_ps;
            if(sample_offset_ps>max_offset_ps) max_offset_ps=sample_offset_ps;
            if(load_count<256) loaded_words[load_count]=`AUDIT_LOADED_WORD;
            if(`AUDIT_LOADED_WORD !== pattern(load_count+1)) begin
                target_errors=target_errors+1;
                if(target_errors<=5) $display("TARGET_WORD_MISMATCH phase=%0d toggle=%0d mode=%0d n=%0d got=%03x expected=%03x",phase_ps,INJECT_TOGGLE_DELAY_PS,skew_mode,load_count,`AUDIT_LOADED_WORD,pattern(load_count+1));
            end
            load_count=load_count+1;
        end
        #1;
        if(!rst) begin out_bits[sampled_bits]=serial_out; sampled_bits=sampled_bits+1; end
    end
    always @(negedge serial_clk) begin
        #1;
        if(!rst) begin out_bits[sampled_bits]=serial_out; sampled_bits=sampled_bits+1; end
    end
endmodule
