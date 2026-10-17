`timescale 1ns/1ps
module tb_spectrum_overlay_pixels;
    reg clk=0,rst=1,vs=0,de=0,audio_valid=0,tone_mode=0,freeze_toggle=0;
    reg [23:0] rgb_in=0;
    wire [23:0] rgb_out;
    reg [77:0] pixmem[0:649];
    reg [1023:0] pix_file;
    integer i,j,x,y,scenario,held,tone,valid,expected,errors=0,pixel_count=650;
    // Pixel-gold test injects renderer state and does not validate the
    // production FFT sample watchdog.
    player_pcm_waveform #(.FFT_TIMEOUT_SAMPLES(0)) dut(.clk(clk),.rst(rst),.vs(vs),.de(de),.rgb_in(rgb_in),
        .audio_valid(audio_valid),.audio_pcm(24'd0),.tone_mode(tone_mode),
        .freeze_toggle(freeze_toggle),.rgb_out(rgb_out));
    task set_profile(input integer profile);
        begin
            for(j=0;j<24;j=j+1) begin
                case(profile)
                    1: begin dut.display_height[j]=(j*3+8)%85; dut.peak_height[j]=((j*3+8)%85>5)?((j*3+8)%85)-5:0; end
                    2: begin dut.display_height[j]=84; dut.peak_height[j]=84; end
                    default: begin dut.display_height[j]=0; dut.peak_height[j]=0; end
                endcase
            end
        end
    endtask
    initial begin
        if(!$value$plusargs("PIX=%s",pix_file)) $fatal(1,"missing +PIX");
        if(!$value$plusargs("COUNT=%d",pixel_count)) pixel_count=650;
        $readmemh(pix_file,pixmem);
        scenario=-1;
        for(i=0;i<pixel_count;i=i+1) begin
            scenario=pixmem[i][77:70]; held=pixmem[i][69]; tone=pixmem[i][68]; valid=pixmem[i][67];
            x=pixmem[i][66:57]; y=pixmem[i][56:48]; rgb_in=pixmem[i][47:24]; expected=pixmem[i][23:0];
            set_profile(scenario);
            dut.frozen_front=held; dut.frame_tone_mode=tone;
            dut.x_pos=x; dut.y_pos=y; de=valid;
            #1;
            if(rgb_out !== expected[23:0]) begin
                $display("FAIL pixel i=%0d sc=%0d x=%0d y=%0d de=%0d held=%0d tone=%0d got=%06x expected=%06x",i,scenario,x,y,valid,held,tone,rgb_out,expected[23:0]); errors=errors+1;
            end
        end
        if(errors) $fatal(1,"pixel gold mismatches=%0d",errors);
        $display("PASS spectrum_overlay_pixel_gold samples=%0d title=SPEC-WAV/TONE,HOLD-WAV/TONE boundaries=panel,column,bar,peak,grid,legend passthrough=de/outside",pixel_count);
        $finish;
    end
endmodule


