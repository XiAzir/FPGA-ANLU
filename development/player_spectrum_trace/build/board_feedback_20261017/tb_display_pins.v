`timescale 1ns/1ps
module tb_display_pins;
reg clk=0, rst=1;
reg [31:0] hex_value=0;
wire dio,sclk,rclk;
display_cone dut(.clk(clk),.rst(rst),.hex_value(hex_value),
                 .seg7_dio(dio),.seg7_sclk(sclk),.seg7_rclk(rclk));
always #10 clk=~clk;
reg [15:0] serial=0;
integer bits_seen=0,digits=0,blanks=0,errors=0,checks=0,case_id=0,i;
reg active=0,negative=0;
reg [7:0] masks[0:15];
reg [15:0] expected;
reg [3:0] nibble;
always @(posedge sclk) if(active && !rst) begin
    serial={serial[14:0],dio ^ (negative && digits==0 && bits_seen==0 && blanks==1)};
    bits_seen=bits_seen+1;
end
always @(posedge rclk) if(active && !rst) begin
    if(bits_seen!==16) begin
        $display("FAIL edge count case=%0d count=%0d",case_id,bits_seen);$finish;
    end
    bits_seen=0;
    if(serial===16'hff00) blanks=blanks+1;
    else begin
        nibble=(hex_value>>(digits*4))&15;
        expected={masks[nibble],(8'b1<<digits)};
        checks=checks+1;
        if(serial!==expected) begin
            errors=errors+1;
            $display("MISMATCH case=%0d digit=%0d input=%h actual=%h expected=%h negative=%0d",
                     case_id,digits,hex_value,serial,expected,negative);
            if(!negative) begin $display("FAIL display pins");$finish;end
        end
        digits=digits+1;
    end
end
task check_word;
input [31:0] value;
begin
    @(negedge clk);active=0;rst=1;hex_value=value;
    repeat(12) @(negedge clk);
    digits=0;blanks=0;bits_seen=0;serial=0;active=1;rst=0;
    wait(digits==8);
    @(negedge clk);active=0;
    if(blanks!=8)begin $display("FAIL blank count %0d",blanks);$finish;end
    $display("WORD_PASS case=%0d word=%h negative=%0d time=%t",case_id,value,negative,$time);
    case_id=case_id+1;
end
endtask
initial begin
    // Independently specified active-low segment bytes, bit7=decimal point off.
    masks[0]=8'hc0;masks[1]=8'hf9;masks[2]=8'ha4;masks[3]=8'hb0;
    masks[4]=8'h99;masks[5]=8'h92;masks[6]=8'h82;masks[7]=8'hf8;
    masks[8]=8'h80;masks[9]=8'h90;masks[10]=8'h88;masks[11]=8'h83;
    masks[12]=8'hc6;masks[13]=8'ha1;masks[14]=8'h86;masks[15]=8'h8e;
    #1000;
    $display("BOUNDARY ideal 50MHz and reset copies; actual routed primitive/PAD parameters; no SDF/external 595 electrical model");
    check_word(32'hdfc11312);
    if($test$plusargs("quick"))begin $display("PASS sdf_display_fixed digit_checks=%0d",checks);$finish;end
    check_word(32'h88888888);
    check_word(32'h01234567);
    check_word(32'h89abcdef);
    check_word(32'h64a10100);check_word(32'h78000000);check_word(32'h88000200);
    check_word(32'h98000000);check_word(32'ha8000000);check_word(32'hb8000000);check_word(32'hc8000001);
    for(i=0;i<32;i=i+1)check_word(32'b1<<i);
    negative=1;check_word(32'hdfc11312);
    if(errors!=1)begin $display("FAIL negative control errors=%0d",errors);$finish;end
    $display("PASS routed_display_pins cases=%0d digit_checks=%0d detected_injected_errors=%0d",case_id,checks,errors);
    $finish;
end
initial begin #1000000000;$display("FAIL timeout case=%0d",case_id);$finish;end
endmodule
