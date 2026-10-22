`timescale 1ns/1ps
module tb_rgb;
reg [23:0] rgb;
reg [3:0] brightness;
reg [2:0] contrast;
wire [23:0] ref_rgb,got_rgb;
player_rgb_adjust_reference ref_dut(rgb,brightness,contrast,ref_rgb);
player_rgb_adjust dut(rgb,brightness,contrast,got_rgb);
integer b,c,p,checks;
initial begin
 checks=0;
 for(b=0;b<16;b=b+1)
  for(c=0;c<8;c=c+1)
   for(p=0;p<256;p=p+1) begin
    brightness=b;contrast=c;
    rgb={8'(p),8'(255-p),8'(p*73)};
    #1;
    if(got_rgb !== ref_rgb)
      $fatal(1,"RGB_DIFF b=%0d c=%0d p=%0d got=%h ref=%h",b,c,p,got_rgb,ref_rgb);
    checks=checks+1;
   end
 $display("RGB_EXHAUSTIVE_PASS triples=%0d channels=%0d selectors=128",checks,checks*3);
 $finish;
end
endmodule
