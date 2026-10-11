`timescale 1ns/1ps
module tb_player_status_monitor;
reg pixel_clk=0, sys_clk=0, rst=1, sys_rst=1;
always #5 pixel_clk=~pixel_clk;
always #4 sys_clk=~sys_clk;
reg [23:0] rgb=0, pcm=0;
reg valid=0, user=0, audio_valid=0, colored=1, changing=1;
reg [3:0] startup=4'hd;
reg [7:0] files=8'ha8;
wire [31:0] display;
integer stimulus_cycles=0, samples=0;
integer seen;
player_status_monitor #(.PIXEL_HZ(80),.SYS_HZ(100),.PAGE_SECONDS(1),.SHOW_SELF_TEST(0)) dut (
    .pixel_clk(pixel_clk),.sys_clk(sys_clk),.rst(rst),.sys_rst(sys_rst),
    .axis_rgb(rgb),.axis_valid(valid),.axis_user(user),.hdmi_locked(1'b1),
    .audio_valid(audio_valid),.tone_mode(1'b0),.underflow(1'b0),.audio_pcm(pcm),
    .startup_flags(startup),.file_flags(files),.fs_code(8'd0),.wav_map_code(8'd0),
    .hex_value(display)
);
// Independent source: 4 pixels/frame, 1 audio sample per 4 pixel cycles.
always @(negedge pixel_clk) begin
    if(rst) begin stimulus_cycles=0; samples=0; valid=0; user=0; audio_valid=0; pcm=0; end
    else begin
        valid=1; user=(stimulus_cycles%4==0); rgb=colored ? 24'hff0000 : 24'd0;
        audio_valid=(stimulus_cycles%4==0);
        if(audio_valid) begin samples=samples+1; pcm=changing ? samples : 24'd0; end
        stimulus_cycles=stimulus_cycles+1;
    end
end
task check_pages;
    input integer black;
    integer k;
    reg [31:0] expected;
    begin
        seen=0;
        for(k=0;k<650;k=k+1) begin
            @(negedge sys_clk);
            case(display[31:28])
                1: expected=32'h1da80000;
                2: expected=black ? 32'h23000000 : 32'h23000004;
                3: expected=32'h33000014;
                4: expected=black ? 32'h43000000 : 32'h43000014;
                5: expected=32'h53000004;
                default: $fatal(1,"invalid page %h",display);
            endcase
            if(display!==expected) $fatal(1,"wrong decoded observation: got %h expected %h",display,expected);
            seen=seen | (1<<display[31:28]);
        end
        if(seen!=62) $fatal(1,"did not observe all five pages");
    end
endtask
initial begin
    repeat(8) @(negedge sys_clk); sys_rst=0;
    #1 rst=0;
    repeat(400) @(negedge pixel_clk);
    check_pages(0);
    @(posedge sys_clk); colored=0; changing=0;
    repeat(400) @(negedge pixel_clk);
    check_pages(1);
    // The reference-clock display must continue while playback is in reset.
    rst=1; startup=4'he; files=0;
    repeat(650) begin
        @(negedge sys_clk);
        if(display[31:28]==1 && display!==32'h1e000000)
            $fatal(1,"startup observation was blocked by playback reset");
    end
    $display("PASS status_monitor: five decoded pages, exact sample/change counts, black/nonblack frames, independent startup observation");
    $finish;
end
initial begin #100000; $fatal(1,"status timeout"); end
endmodule
