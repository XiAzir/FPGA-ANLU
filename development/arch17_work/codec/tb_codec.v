`timescale 1ns/1ps
module tb_codec;
reg clk=0;always #5 clk=~clk;
reg rst=1,clear=0,pixel_en=0,word_empty=0;
reg [31:0] word_data=0,lfsr=32'h734f19a7;
wire [23:0] rgb0,rgb1;wire pop0,pop1,under0,under1;
rgb888_unpack32_base a(clk,rst,clear,pixel_en,rgb0,word_empty,pop0,word_data,under0);
rgb888_unpack32_byte b(clk,rst,clear,pixel_en,rgb1,word_empty,pop1,word_data,under1);
integer cycles=0,pops=0,pixels=0,clears=0;
reg [8:0] levels=0;
always @(posedge clk) begin
    lfsr<={lfsr[30:0],lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
    if(pop0) begin word_data<=lfsr^32'h10238475;pops=pops+1;end
    #1;
    cycles=cycles+1;
    if({rgb0,pop0,under0}!=={rgb1,pop1,under1} ||
       a.reservoir!==b.reservoir || a.bit_count!=={b.byte_count,3'b000} ||
       a.pop_pending!==b.pop_pending)
        $fatal(1,"CODEC mismatch cycle=%0d count=%0d/%0d rgb=%h/%h pop=%b/%b",cycles,a.bit_count,b.byte_count,rgb0,rgb1,pop0,pop1);
    if(!rst && !clear) begin
        if(a.bit_count[2:0]!=0 || a.bit_count>64) $fatal(1,"byte alignment invariant");
        if(a.pop_pending && a.bit_count>32) $fatal(1,"in-flight capacity invariant");
        if((a.reservoir>>a.bit_count)!=0) $fatal(1,"unused reservoir tail invariant");
        levels[a.bit_count>>3]=1;
        if(pixel_en) pixels=pixels+1;
    end
end
integer n;
initial begin
    repeat(4) @(negedge clk);rst=0;word_empty=1;pixel_en=1;
    repeat(7) @(negedge clk);pixel_en=0;word_empty=0;
    repeat(8) @(negedge clk);
    for(n=0;n<1000000;n=n+1) begin
        @(negedge clk);
        rst=(n%31217==0);clear=(lfsr[15:0]==16'h17a3);
        if(clear) clears=clears+1;
        pixel_en=lfsr[3] | lfsr[7];
        word_empty=lfsr[0] && lfsr[1];
    end
    @(negedge clk);
    if(levels!==9'h1ff || pops<100000 || clears<1) $fatal(1,"coverage levels=%h pops=%0d clears=%0d",levels,pops,clears);
    $display("CODEC_EQUIV PASS cycles=%0d pops=%0d pixels=%0d clears=%0d levels=%h",cycles,pops,pixels,clears,levels);
    $finish;
end
endmodule
