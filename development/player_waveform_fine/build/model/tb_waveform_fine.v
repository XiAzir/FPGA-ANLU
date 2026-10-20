`timescale 1ns/1ps
// Independent integer reference for the C11301 512 x 2 waveform candidate.
// Pixel expectations are derived from the input stream, never from DUT state.
module tb_waveform_fine;
    reg clk = 0, rst = 1, vs = 0, de = 0;
    reg [23:0] rgb_in = 24'h13579b;
    reg audio_valid = 0;
    reg [23:0] audio_pcm = 0;
    reg tone_mode = 0, freeze_toggle = 0;
    wire [23:0] rgb_out;
    reg stale_audio_valid=0;
    reg [23:0] stale_audio_pcm=0;
    wire [23:0] stale_rgb_out;
    integer gmin[0:511], gmax[0:511];
    integer samples, checks, failures, i, b, s, raw, code;
    integer old_min[0:511], old_max[0:511];
    reg [23:0] expected;
    integer qrow, xnow, ynow, binidx, subx;
    integer mid_prev, mid_cur, lo, hi, gapdist;
    integer tiers[0:3];
    reg [31:0] rng = 32'h6d2b79f5;

    always #5 clk = ~clk;
    player_pcm_waveform dut(
        .clk(clk), .rst(rst), .vs(vs), .de(de), .rgb_in(rgb_in),
        .audio_valid(audio_valid), .audio_pcm(audio_pcm), .tone_mode(tone_mode),
        .freeze_toggle(freeze_toggle), .rgb_out(rgb_out)
    );
    player_pcm_waveform #(.CLK_FREQ_HZ(1000),.SAMPLES_PER_BIN(2),.STALE_MS(5)) stale_dut(
        .clk(clk),.rst(rst),.vs(vs),.de(1'b0),.rgb_in(rgb_in),
        .audio_valid(stale_audio_valid),.audio_pcm(stale_audio_pcm),
        .tone_mode(1'b0),.freeze_toggle(1'b0),.rgb_out(stale_rgb_out)
    );

    // Verilog division truncates toward zero, so spell out mathematical floor.
    function integer q2_code;
        input integer pcm;
        integer scaled;
        begin
            if (pcm >= 0) scaled = pcm / 64;
            else scaled = - ((-pcm + 63) / 64);
            scaled = scaled + 112;
            if (scaled < 0) scaled = 0;
            if (scaled > 224) scaled = 224;
            q2_code = scaled;
        end
    endfunction

    function [23:0] shade;
        input integer amount;
        begin
            case (amount)
                0: shade = 24'h00ffff;
                1: shade = 24'h00bfbf;
                2: shade = 24'h007f7f;
                3: shade = 24'h003f3f;
                default: shade = 24'h000000;
            endcase
        end
    endfunction

    task tick;
        begin @(posedge clk); #1; end
    endtask

    task check;
        input condition;
        input [8*180-1:0] msg;
        begin
            checks = checks + 1;
            if (condition !== 1'b1) begin
                failures = failures + 1;
                if (failures <= 40) $display("FAIL %0s at %0t", msg, $time);
            end
        end
    endtask

    function integer sample_for;
        input integer column;
        input integer lane;
        integer v, degree, base_code;
        begin
            // Exercise clip endpoints, negative floor boundaries, silence,
            // narrow ranges, wide ranges, and irregular full-window data.
            if (column == 0) begin
                if (lane == 0) sample_for = -32768; else sample_for = -32705;
            end else if (column == 1) begin
                if (lane == 0) sample_for = 32767; else sample_for = 32640;
            end else if (column == 2) sample_for = 0;
            else if (column == 3) sample_for = (lane == 0) ? -1 : 63;
            else if (column >= 4 && column <= 27) begin
                // A stepped major-scale-like fixture, with adjacent columns
                // changing pitch level and a narrow two-sample range.
                degree = ((column-4)/3) % 8;
                case(degree)
                    0: base_code=80; 1: base_code=92; 2: base_code=100; 3: base_code=112;
                    4: base_code=124; 5: base_code=132; 6: base_code=144; default: base_code=152;
                endcase
                sample_for = (base_code - 112 + lane) * 64;
            end
            else if ((column % 31) == 0) sample_for = 0;
            else if ((column % 31) == 1) sample_for = (lane == 0) ? 64 : 127;
            else begin
                rng = rng ^ (rng << 13);
                rng = rng ^ (rng >> 17);
                rng = rng ^ (rng << 5);
                v = (rng & 32'h0000ffff) - 32768;
                if (lane == 1 && (column % 7) == 0) v = v / 8;
                sample_for = v;
            end
        end
    endfunction

    task send_pcm;
        input integer pcm;
        begin
            @(negedge clk); audio_pcm = {pcm[15:0], 8'hA5}; audio_valid = 1;
            tick;
            @(negedge clk); audio_valid = 0;
        end
    endtask

    task init_gold;
        integer n;
        begin
            for (n=0; n<512; n=n+1) begin gmin[n]=999; gmax[n]=-1; end
            samples=0;
        end
    endtask

    task capture_full;
        integer c, lane, p, q;
        begin
            init_gold;
            for (c=0; c<512; c=c+1) begin
                for (lane=0; lane<2; lane=lane+1) begin
                    p=sample_for(c,lane); q=q2_code(p);
                    if(q<gmin[c]) gmin[c]=q;
                    if(q>gmax[c]) gmax[c]=q;
                    send_pcm(p); samples=samples+1;
                end
            end
        end
    endtask

    task compare_bank;
        integer c;
        begin
            check(samples==1024, "exactly 1024 accepted source events sent");
            check(dut.capture_ready===1'b1, "full capture waits ready for VS");
            for(c=0;c<512;c=c+1) begin
                // Bank 1 is first capture after reset in the established lifecycle.
                check(dut.trace_mem[512+c] === {gmax[c][8:0],gmin[c][8:0]},
                      "all 512 packed Q2 min/max pairs match independent integer gold");
            end
        end
    endtask

    task start_frame;
        begin
            @(negedge clk); vs=0; de=0; tick;
            @(negedge clk); vs=1; tick;
            @(negedge clk); vs=0; tick;
        end
    endtask

    function integer interpolate_floor;
        input integer a;
        input integer z;
        input integer k;
        integer n;
        begin
            n = a*(4-k) + z*k;
            if(n>=0) interpolate_floor=n/4;
            else interpolate_floor=-((-n+3)/4);
        end
    endfunction

    task scan_graph;
        integer row, col;
        integer observed;
        begin
            // DUT begins y=0 after VS and advances one row after each DE burst.
            // Scan every graph pixel in every graph row and exact RGB shades.
            for(row=0; row<=412; row=row+1) begin
                @(negedge clk); de=1;
                for(col=1; col<=640; col=col+1) begin
                    tick;
                    xnow=dut.x_pos; ynow=dut.y_pos;
                    if(xnow>=64 && xnow<=575 && ynow>=356 && ynow<=412) begin
                        binidx=xnow-64;
                        qrow=(412-ynow)*4;
                        mid_cur=(gmin[binidx]+gmax[binidx])/2;
                        lo=gmin[binidx]; hi=gmax[binidx];
                        if(binidx==0) begin mid_prev=mid_cur; end
                        else begin
                            mid_prev=(gmin[binidx-1]+gmax[binidx-1])/2;
                            // The column owns the full closed join from the
                            // previous midpoint to this column's midpoint.
                            if(mid_prev<lo) lo=mid_prev;
                            if(mid_prev>hi) hi=mid_prev;
                        end
                        if(qrow>=lo && qrow<=hi) expected=shade(0);
                        else if(qrow<lo) begin gapdist=lo-qrow; expected=shade(gapdist); end
                        else begin gapdist=qrow-hi; expected=shade(gapdist); end
                        if(ynow==384 && expected==24'h000000) expected=24'h404040;
                        check(rgb_out === expected, "actual DE graph scan RGB equals independent Q2 geometry and shade");
                        if(expected==24'h00ffff) tiers[0]=tiers[0]+1;
                        else if(expected==24'h00bfbf) tiers[1]=tiers[1]+1;
                        else if(expected==24'h007f7f) tiers[2]=tiers[2]+1;
                        else if(expected==24'h003f3f) tiers[3]=tiers[3]+1;
                        if ((xnow==64 || xnow==575) && (ynow==356 || ynow==384 || ynow==412))
                            $display("EDGE x=%0d y=%0d rgb=%06x",xnow,ynow,rgb_out);
                    end
                end
                @(negedge clk); de=0; tick;
            end
            check(tiers[0]>0 && tiers[1]>0 && tiers[2]>0 && tiers[3]>0,
                  "all four exact intensity tiers exercised by scan");
        end
    endtask

    task pulse_source;
        input tone;
        begin
            @(negedge clk); tone_mode=tone; tick;
            @(negedge clk); tone_mode=tone;
        end
    endtask

    task pulse_freeze;
        begin
            @(negedge clk); freeze_toggle=1; tick;
            @(negedge clk); freeze_toggle=0; tick;
        end
    endtask

    task pulse_stale_sample;
        input integer pcm;
        begin
            @(negedge clk); stale_audio_pcm={pcm[15:0],8'h00}; stale_audio_valid=1; tick;
            @(negedge clk); stale_audio_valid=0;
        end
    endtask

    initial begin
        checks=0; failures=0;
        for(i=0;i<4;i=i+1) tiers[i]=0;
        repeat(4) tick; @(negedge clk); rst=0; tick;
        check(rgb_out===24'h13579b,"reset blank passthrough");
        capture_full;
        compare_bank;
        // No PCM event may alter a full bank while capture waits for vertical sync.
        raw=sample_for(0,0); send_pcm(raw);
        check(dut.trace_mem[512] === {gmax[0][8:0],gmin[0][8:0]},"ready bank immutable before VS");
        start_frame;
        check(dut.front_valid===1'b1 && dut.display_bank===1'b1,"VS swaps full bank atomically");
        scan_graph;

        // Verify first and last bank sentinels still match after a complete DE scan.
        check(dut.trace_mem[512] === {gmax[0][8:0],gmin[0][8:0]},"leftmost capture pair retained");
        check(dut.trace_mem[1023] === {gmax[511][8:0],gmin[511][8:0]},"rightmost capture pair retained");

        // Freeze must hold the visible bank even if a newer complete back bank
        // is ready. Resume is committed at VS and preserves the old front.
        for(i=0;i<512;i=i+1) begin old_min[i]=gmin[i]; old_max[i]=gmax[i]; end
        capture_full;
        check(dut.capture_ready===1'b1,"second full back bank ready before freeze commit");
        for(i=0;i<512;i=i+1)
            check(dut.trace_mem[512+i] === {old_max[i][8:0],old_min[i][8:0]},
                  "displayed bank immutable during full back-bank capture");
        pulse_freeze;
        start_frame;
        check(dut.frozen_front===1'b1 && dut.display_bank===1'b1 &&
              dut.capture_ready===1'b0 && dut.front_valid===1'b1,
              "freeze at VS holds current front and discards newer ready window");
        pulse_freeze;
        start_frame;
        check(dut.frozen_front===1'b0 && dut.display_bank===1'b1 &&
              dut.front_valid===1'b1 && dut.capture_active===1'b1,
              "resume at VS keeps old front while restarting capture");

        pulse_source(1'b1);
        check(dut.invalidate_pending===1'b1 && dut.front_valid===1'b1 &&
              dut.display_bank===1'b1,"source change holds current front until VS");
        for(i=0;i<1024;i=i+1) send_pcm(0);
        check(dut.capture_ready===1'b1 && dut.front_valid===1'b1 &&
              dut.display_bank===1'b1,"new-source complete bank isolated before VS");
        start_frame;
        check(dut.front_valid===1'b1 && dut.display_bank===1'b0 &&
              dut.frame_tone_mode===1'b1 && dut.invalidate_pending===1'b0,
              "source replacement becomes visible atomically at VS");
        pulse_source(1'b0);
        check(dut.front_valid===1'b1 && dut.invalidate_pending===1'b1,
              "second source change preserves active frame until VS");
        start_frame;
        check(dut.front_valid===1'b0 && dut.invalidate_pending===1'b0,
              "source change without ready window clears stale front at VS");

        // Scaled stale instance reaches timeout in five cycles, then clears a
        // previously visible complete front only at the following VS.
        for(i=0;i<1024;i=i+1) pulse_stale_sample(0);
        check(stale_dut.capture_ready===1'b1,"stale DUT accepted a complete 512x2 window");
        start_frame;
        check(stale_dut.front_valid===1'b1,"stale DUT displays completed capture");
        repeat(5) tick;
        check(stale_dut.stale_pending===1'b1,"scaled idle timeout sets stale pending");
        start_frame;
        check(stale_dut.front_valid===1'b0 && stale_dut.stale_pending===1'b0,
              "stale expiry clears front and resumes capture at VS");
        // Unknown pixels or RAM bits fail case equality comparisons above.
        check(^rgb_out !== 1'bx,"RGB output contains no unknown bits at end of scan");
        if(failures==0) $display("MODEL PASS checks=%0d samples=%0d tiers=%0d/%0d/%0d/%0d",checks,samples,tiers[0],tiers[1],tiers[2],tiers[3]);
        else $display("MODEL FAIL checks=%0d failures=%0d samples=%0d",checks,failures,samples);
        $finish;
    end

    initial begin #100000000; $display("MODEL TIMEOUT"); $finish; end
endmodule

