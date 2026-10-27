`timescale 1ns/1ps
module tb_video_source_ablation;
  reg clk=0;
  always #5 clk=~clk;
  reg rst=1;
  reg key0_n=1; // Match C29 top's constant-high tie.
  reg tone_press=0;
  reg vs=0;
  reg bmp_valid=0;
  reg [1:0] image_index=0;
  reg [23:0] bmp_rgb=0;

  wire old_probe_mode, old_tone_toggle, old_key0_active;
  wire [23:0] old_rgb;
  player_video_source_probe old_dut (
    .clk(clk), .rst(rst), .key0_n_async(key0_n), .tone_press(tone_press),
    .vs(vs), .bmp_valid(bmp_valid), .image_index(image_index), .bmp_rgb(bmp_rgb),
    .probe_mode(old_probe_mode), .tone_toggle(old_tone_toggle),
    .key0_active(old_key0_active), .rgb_out(old_rgb)
  );

  // C30 top replacement as wired: key0_n_async is constant 1, hence
  // probe_mode=0, tone_toggle=tone_press, and RGB is gated by bmp_valid.
  wire new_probe_mode=1'b0;
  wire new_tone_toggle=tone_press;
  wire [23:0] new_rgb=bmp_valid ? bmp_rgb : 24'd0;

  // Deliberately incorrect gate, used only as a mutation/negative control.
  wire [23:0] negative_rgb=bmp_valid ? 24'd0 : bmp_rgb;

  integer cycles=0, neg_control_mismatches=0;
  reg [31:0] lfsr=32'h30c0ffee;
  always @(posedge clk) begin
    #1;
    if (!rst) begin
      cycles=cycles+1;
      if (old_tone_toggle !== new_tone_toggle ||
          old_probe_mode !== new_probe_mode || old_rgb !== new_rgb ||
          old_key0_active !== 1'b0) begin
        $display("FAIL cycle=%0d tone old/new=%b/%b probe old/new=%b/%b rgb old/new=%h/%h key_active=%b",
                 cycles, old_tone_toggle,new_tone_toggle,old_probe_mode,new_probe_mode,old_rgb,new_rgb,old_key0_active);
        $fatal(1);
      end
      if (old_rgb !== negative_rgb) neg_control_mismatches=neg_control_mismatches+1;
    end
  end

  integer i;
  initial begin
    repeat (3) @(negedge clk);
    rst=0;
    for (i=0; i<256; i=i+1) begin
      @(negedge clk);
      lfsr={lfsr[30:0],lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
      key0_n=1'b1;
      vs=(i%19==0) ? ~vs : vs;
      bmp_valid=lfsr[0] | (i%7==0);
      image_index=lfsr[3:2];
      bmp_rgb=lfsr[23:0] ^ (24'h9e3779 * i);
      tone_press=(i%13==2 || i%29==11);
    end
    @(negedge clk);
    tone_press=0; bmp_valid=0;
    repeat (3) @(posedge clk);
    #2;
    if (cycles < 256 || neg_control_mismatches == 0) begin
      $display("FAIL coverage cycles=%0d negative mismatches=%0d",cycles,neg_control_mismatches);
      $fatal(1);
    end
    $display("PASS source-probe ablation: cycles=%0d, negative-control mismatches=%0d",cycles,neg_control_mismatches);
    $finish;
  end
endmodule
