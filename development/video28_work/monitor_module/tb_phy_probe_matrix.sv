`timescale 1ns/1ps
// C28 PHY plus real EG ODDR and passive runtime probe. Inputs change on
// pixel posedges, matching the transmitter's registered TMDS outputs.
module phy_startup_case #(
    parameter integer ID=0, PHASE_PS=0, RELEASE_PS=0,
    parameter integer NEGATIVE=0,
    parameter [9:0] CLOCK_WORD=10'b1111100000
)(output reg done=0);
    reg pixel_clk=0, serial_clk=0, rst=1;
    reg [9:0] in0=0,in1=0,in2=0;
    wire out0,out1,out2,outclk,clock_bit_probe,valid,locked;
    wire [9:0] ch0,ch1,ch2,chclk;
    wire [31:0] malformed;
    wire [31:0] page_e,page_f;
    reg corrupt=0;
    integer sent=0,received=0,errors=0,first_index=-1,k,epoch;
    integer seed;
    reg [31:0] random_word;
    reg [9:0] exp0[0:511],exp1[0:511],exp2[0:511];
    realtime release_time;
    always #4 serial_clk=~serial_clk;
    initial begin
        #(PHASE_PS*0.001);
        forever #20 pixel_clk=~pixel_clk;
    end
    hdmi_phy_wrapper #(.DEVICE("EG")) dut(
        .I_pixel_clk(pixel_clk),.I_serial_clk(serial_clk),.I_rst(rst),
        .I_tmds_channel_0(in0),.I_tmds_channel_1(in1),
        .I_tmds_channel_2(in2),.I_tmds_channel_clk(CLOCK_WORD),
        .O_tmds_ch0_p(out0),.O_tmds_ch1_p(out1),
        .O_tmds_ch2_p(out2),.O_tmds_clk_p(outclk),
        .O_clock_bit_probe(clock_bit_probe));
    player_hdmi_runtime_probe probe(
        .pixel_clk(pixel_clk),.serial_clk(serial_clk),.cold_rst(rst),.media_rst(1'b0),
        .locked(locked),.axis_ready(1'b1),.axis_valid(1'b0),.axis_user(1'b0),
        .hs(1'b0),.vs(1'b0),.de(1'b0),.serial_clock_out(clock_bit_probe),
        .tmds_clock_word(CLOCK_WORD),.page_e(page_e),.page_f(page_f));
    hdmi_serial_receiver #(.CLOCK_WORD(CLOCK_WORD)) rx(
        .serial_clk(serial_clk),.pixel_clk(pixel_clk),.rst(rst),
        .tmds_clk(outclk),.tmds_d0(out0^corrupt),.tmds_d1(out1),.tmds_d2(out2),
        .symbol_valid(valid),.ch0(ch0),.ch1(ch1),.ch2(ch2),.chclk(chclk),
        .alignment_locked(locked),.malformed_words(malformed));
    always @(posedge pixel_clk) begin
        if (!rst && sent<450) begin
            random_word=$random(seed);in0<=random_word[9:0];exp0[sent]=random_word[9:0];
            random_word=$random(seed);in1<=random_word[9:0];exp1[sent]=random_word[9:0];
            random_word=$random(seed);in2<=random_word[9:0];exp2[sent]=random_word[9:0];
            sent=sent+1;
        end
    end
    always @(posedge valid) begin
        if (!rst && $realtime-release_time>240 && sent<450) begin
            if (chclk!==CLOCK_WORD) errors=errors+1;
            if (first_index<0) begin
                for(k=0;k<sent;k=k+1)
                    if(first_index<0 && ch0===exp0[k] && ch1===exp1[k] && ch2===exp2[k])
                        first_index=k;
                if(first_index<0) $fatal(1,"first word missing id=%0d epoch=%0d",ID,epoch);
            end else if(first_index+received>=sent ||
                ch0!==exp0[first_index+received] || ch1!==exp1[first_index+received] ||
                ch2!==exp2[first_index+received]) errors=errors+1;
            received=received+1;
        end
    end
    initial begin
        // Three independent reset releases; 20ms startup wait is intentionally
        // reduced to >=500ns after real primitive GSR for this PHY-only test.
        #500;
        for(epoch=0;epoch<3;epoch=epoch+1) begin
            rst=1;corrupt=0;
            #200;
            sent=0;received=0;errors=0;first_index=-1;seed=32'h7351a29d+ID+epoch;
            #(RELEASE_PS*0.001+epoch*0.001);
            release_time=$realtime;rst=0;
            #2000;
            if(NEGATIVE) begin corrupt=1;#4;corrupt=0;end
            wait(sent>=450);
            #1;
            if(!locked || malformed!=0 || received<430)
                $fatal(1,"lock/count id=%0d epoch=%0d received=%0d malformed=%0d",ID,epoch,received,malformed);
            if(page_f[31:28]!==4'hF || page_f[27:18]!==CLOCK_WORD || page_f[7:0]!==8'd0)
                $fatal(1,"probe page id=%0d epoch=%0d F=%h",ID,epoch,page_f);
            if(page_f[17:8]<10'd254 || page_f[17:8]>10'd258)
                $fatal(1,"probe clock delta id=%0d epoch=%0d delta=%0d timer=%0d",ID,epoch,page_f[17:8],probe.window_timer);
            if((NEGATIVE && errors==0)||(!NEGATIVE && errors!=0))
                $fatal(1,"content id=%0d epoch=%0d errors=%0d negative=%0d",ID,epoch,errors,NEGATIVE);
    $display("CASE id=%0d phase_ps=%0d release_ps=%0d epoch=%0d cw=%03h received=%0d errors=%0d negative=%0d Fdelta=%0d PASS",
                ID,PHASE_PS,RELEASE_PS,epoch,CLOCK_WORD,received,errors,NEGATIVE,page_f[17:8]);
        end
        done=1;
    end
endmodule

module tb_phy_probe_matrix #(
    parameter [9:0] CLOCK_WORD=10'b1111100000
);
    wire [64:0] done;
    genvar p,r;
    generate for(p=0;p<8;p=p+1) begin:phases
        for(r=0;r<8;r=r+1) begin:releases
            phy_startup_case #(.ID(p*8+r),.PHASE_PS(p*1000),
                .RELEASE_PS(r*1000),.CLOCK_WORD(CLOCK_WORD)) c(.done(done[p*8+r]));
        end
    end endgenerate
    phy_startup_case #(.ID(64),.PHASE_PS(1000),.RELEASE_PS(3001),.NEGATIVE(1),.CLOCK_WORD(CLOCK_WORD))
        negative_control(.done(done[64]));
    initial begin
        wait(&done);#1;
        $display("PASS: CLOCK_WORD=%03h; 64 phase/reset pairs x3 sessions; ODDR input probe delta 254..258; 3 serial pin bit-flip negative controls detected",CLOCK_WORD);
        $finish;
    end
    initial begin #500000;$fatal(1,"matrix timeout");end
endmodule
