`timescale 1ns/1ps
module tb_audio_crc_snapshot;
    reg video_clk=0;
    always #5 video_clk=~video_clk;
    reg rst_all=1;
    reg [7:0] file_flags=8'hB6;
    reg [3:0] photo_state=4'h1,video_state=4'h2;
    reg [7:0] fs_error_code=0;
    reg [3:0] file_error_flags=0;
    reg [15:0] sd_crc_checked=0,sd_crc_bad=0;
    reg audio_underflow=0;
    reg [23:0] spectrum_frames=0;
    reg [31:0] diag4=32'hD1040004,diag5=32'hD1050005,diag6=32'hD1060006,diag7=32'hD1070007;
    reg [31:0] diag8=32'hD1080008,diag9=32'hD1090009,diag10=32'hD10A000A,diag11=32'hD10B000B;
    reg [31:0] diag12=32'hD10C000C,diag13=32'hD10D000D,diag14=32'hD10E000E,diag15=32'hD10F000F;
    wire [31:0] hex_value;
    wire [3:0] page_index;

    player_compact_status_pages #(.PAGE_CYCLES(3)) u_pages (
        .clk(video_clk),.rst(rst_all),.file_flags(file_flags),
        .photo_state(photo_state),.video_state(video_state),.fs_error_code(fs_error_code),
        .file_error_flags(file_error_flags),.sd_crc_checked(sd_crc_checked),.sd_crc_bad(sd_crc_bad),
        .audio_underflow(audio_underflow),.spectrum_frames(spectrum_frames),
        .diag4(diag4),.diag5(diag5),.diag6(diag6),.diag7(diag7),.diag8(diag8),
        .diag9(diag9),.diag10(diag10),.diag11(diag11),.diag12(diag12),.diag13(diag13),
        .diag14(diag14),.diag15(diag15),.hex_value(hex_value),.page_index(page_index)
    );

    reg [15:0] pcm_last_crc=0,pcm_crc_block=0;
    reg [23:0] pcm_observed_samples=0,audio_underflow_count=0;
    wire [15:0] pcm_crc_snapshot,pcm_block_snapshot;
    wire [23:0] pcm_count_snapshot,underflow_count_snapshot;
    crc_snapshot_observer dut (
        .video_clk(video_clk),.rst_all(rst_all),.compact_status_page(page_index),
        .pcm_last_crc(pcm_last_crc),.pcm_crc_block(pcm_crc_block),
        .pcm_observed_samples(pcm_observed_samples),.audio_underflow_count(audio_underflow_count),
        .pcm_crc_snapshot(pcm_crc_snapshot),.pcm_block_snapshot(pcm_block_snapshot),
        .pcm_count_snapshot(pcm_count_snapshot),.underflow_count_snapshot(underflow_count_snapshot)
    );

    reg [31:0] lfsr=32'h1ACEB00C;
    integer subcycle=0;
    always @(negedge video_clk) begin
        if (!rst_all) begin
            subcycle=subcycle+1;
            if (subcycle==5) begin
                subcycle=0;
                lfsr={lfsr[30:0],lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
                pcm_last_crc=lfsr[15:0];
                pcm_crc_block=lfsr[31:16];
                pcm_observed_samples={lfsr[7:0],lfsr[23:8]};
                audio_underflow_count=audio_underflow_count+{20'd0,lfsr[3:0]}+1'b1;
            end
        end
    end

    reg [3:0] page_seen=0;
    reg [15:0] exp_crc=0,exp_block=0;
    reg [23:0] exp_samples=0,exp_uf=0;
    integer captures=0;
    integer checks=0;
    always @(posedge video_clk) begin
        if (rst_all) begin
            page_seen=0; exp_crc=0; exp_block=0; exp_samples=0; exp_uf=0; captures=0; checks=0;
            #1;
            if (pcm_crc_snapshot!==0 || pcm_block_snapshot!==0 || pcm_count_snapshot!==0 || underflow_count_snapshot!==0)
                $fatal(1,"FAIL reset did not clear CRC snapshots");
        end else begin
            if (page_index==4'd7 && page_seen!=4'd7) begin
                exp_crc=pcm_last_crc; exp_block=pcm_crc_block;
                exp_samples=pcm_observed_samples; exp_uf=audio_underflow_count;
                captures=captures+1;
            end
            page_seen=page_index;
            #1;
            if (pcm_crc_snapshot!==exp_crc || pcm_block_snapshot!==exp_block ||
                pcm_count_snapshot!==exp_samples || underflow_count_snapshot!==exp_uf) begin
                $display("FAIL snapshot page=%x crc=%04x/%04x block=%04x/%04x count=%06x/%06x uf=%06x/%06x",
                    page_index,pcm_crc_snapshot,exp_crc,pcm_block_snapshot,exp_block,
                    pcm_count_snapshot,exp_samples,underflow_count_snapshot,exp_uf);
                $fatal(1);
            end
            checks=checks+1;
        end
    end

    integer cycles=0;
    initial begin
        @(posedge video_clk); @(negedge video_clk); rst_all=0;
        while (captures<3 && cycles<180) begin @(negedge video_clk); cycles=cycles+1; end
        if (captures<3) begin $display("FAIL too few page-7 capture events: %0d",captures); $fatal(1); end

        // Reset while the page ring is active; all snapshots must clear and recapture only at page 7.
        rst_all=1; @(posedge video_clk); @(negedge video_clk);
        rst_all=0; cycles=0;
        while (captures<2 && cycles<120) begin @(negedge video_clk); cycles=cycles+1; end
        if (captures<2) begin $display("FAIL page-7 capture did not resume after reset"); $fatal(1); end
        $display("PASS CRC snapshot: randomized inputs every 5 clocks, page-7 entry capture, hold through 8/9/A/D, reset");
        $finish;
    end
endmodule
