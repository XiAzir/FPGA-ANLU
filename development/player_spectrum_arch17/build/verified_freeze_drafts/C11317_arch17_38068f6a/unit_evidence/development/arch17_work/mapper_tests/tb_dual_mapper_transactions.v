`timescale 1ns/1ps
`ifndef DUAL_DUT
`define DUAL_DUT fat32_dual_file_sector_ref
`endif
module tb_dual_mapper_transactions;
    reg clk=0, rst=1;
    reg [31:0] fat_lba=10, data_lba=1000, cluster_count=65525;
    reg [3:0] sectors_per_cluster_shift=0;
    reg bmp_enable=1, wav_enable=1;
    reg [31:0] bmp_start_cluster=2, bmp_file_size=4096*512, bmp_file_sector=4095;
    reg bmp_file_read=0;
    reg [31:0] wav_start_cluster=6000, wav_file_size=4*512, wav_file_sector=0;
    reg wav_file_read=0;
    wire [7:0] bmp_file_data, wav_file_data, bmp_error_code, wav_error_code;
    wire bmp_file_valid, bmp_file_end, bmp_error, wav_file_valid, wav_file_end, wav_error;
    wire sd_read; wire [31:0] sd_addr; reg [7:0] sd_data=0; reg sd_valid=0, sd_end=0;

    `DUAL_DUT #(.WAIT_LIMIT(3000), .AUDIO_BURST_MAX(2)) dut (
        .clk(clk), .rst(rst), .fat_lba(fat_lba), .data_lba(data_lba),
        .cluster_count(cluster_count), .sectors_per_cluster_shift(sectors_per_cluster_shift),
        .bmp_enable(bmp_enable), .bmp_start_cluster(bmp_start_cluster), .bmp_file_size(bmp_file_size),
        .bmp_file_read(bmp_file_read), .bmp_file_sector(bmp_file_sector),
        .bmp_file_data(bmp_file_data), .bmp_file_valid(bmp_file_valid), .bmp_file_end(bmp_file_end),
        .bmp_error(bmp_error), .bmp_error_code(bmp_error_code),
        .wav_enable(wav_enable), .wav_start_cluster(wav_start_cluster), .wav_file_size(wav_file_size),
        .wav_file_read(wav_file_read), .wav_file_sector(wav_file_sector),
        .wav_file_data(wav_file_data), .wav_file_valid(wav_file_valid), .wav_file_end(wav_file_end),
        .wav_error(wav_error), .wav_error_code(wav_error_code),
        .sd_read(sd_read), .sd_addr(sd_addr), .sd_data(sd_data), .sd_valid(sd_valid), .sd_end(sd_end)
    );

    localparam integer MODE_NORMAL=0, MODE_SHORT=1, MODE_TIMEOUT=2, MODE_SIMULTANEOUS=6;
    integer card_mode=MODE_NORMAL, short_bytes=128;
    integer card_active=0, card_index=0, card_addr=0;
    integer bmp_walk_cluster=2;
    integer wav_card_count=0, bmp_card_count=0, bmp_data_transactions=0;
    integer consecutive_wav=0, max_consecutive_wav=0;
    integer bmp_bytes=0, bmp_payload_total=0, wav_bytes=0, wav_payload_total=0, bmp_ends=0, wav_ends=0;
    integer bmp_expected_data_addr=5095, wav_expected_data_addr=6998, wav_walk_cluster=6000;
    integer wav_fat_transactions=0;
    integer cycle_count=0, failed=0, txn_count=0;
    reg last_sd_read=0, scoreboard_active=0, payload_score_active=0;
    integer watchdog, bmp_end_base;
    reg bmp_seen_data=0;

    always #5 clk=~clk;

    function [31:0] fat_link;
        input integer c;
        begin
            case (card_mode)
                3: fat_link = (c==2) ? 0 : c+1;                 // invalid FAT value
                4: fat_link = (c==2) ? 3 : ((c==3) ? 32'h0ffffff8 : c+1); // EOC
                5: fat_link = (c==2) ? 3 : ((c==3) ? 2 : c+1); // cycle
                default: fat_link = c+1;
            endcase
        end
    endfunction

    function [7:0] card_byte;
        input integer addr;
        input integer idx;
        integer relative_sector, entry_cluster, lane;
        reg [31:0] entry;
        begin
            relative_sector = addr-fat_lba;
            if ((relative_sector>=0) && (relative_sector<512)) begin
                entry_cluster=(relative_sector*128)+(idx/4);
                lane=idx%4;
                entry=fat_link(entry_cluster);
                card_byte=(entry>>(lane*8))&8'hff;
            end else card_byte=(addr+idx)&8'hff;
        end
    endfunction

    // Single-card model: all ordinary transactions carry 512 sequential bytes.
    // MODE_SHORT and MODE_TIMEOUT inject physical card failures for error tests.
    always @(negedge clk) begin
        sd_valid <= 0;
        sd_end <= 0;
        if (!card_active && sd_read) begin
            card_active <= 1;
            card_index <= 0;
            card_addr <= sd_addr;
        end else if (!sd_read) begin
            card_active <= 0;
        end else if (card_active) begin
            if (card_mode==MODE_TIMEOUT) begin
                // No response; the mapper's bounded wait must classify timeout.
            end else if ((card_mode==MODE_SIMULTANEOUS) && (card_index==511)) begin
                sd_valid <= 1;
                sd_data <= card_byte(card_addr,card_index);
                sd_end <= 1;
                card_index <= 512;
                card_active <= 0;
            end else if (card_index < ((card_mode==MODE_SHORT) ? short_bytes : 512)) begin
                sd_valid <= 1;
                sd_data <= card_byte(card_addr,card_index);
                card_index <= card_index+1;
            end else begin
                sd_end <= 1;
                card_active <= 0;
            end
        end
    end

    // Transaction scoreboard validates the full 4096-hop BMP address sequence,
    // each physical sector boundary, and bounded WAV service while BMP is pending.
    always @(posedge clk) begin
        cycle_count <= cycle_count+1;
        last_sd_read <= sd_read;
        
        if (scoreboard_active && sd_read && !last_sd_read) begin
            txn_count <= txn_count+1;
            if ((sd_addr==6998) || (sd_addr==6999)) begin
                wav_card_count <= wav_card_count+1;
                consecutive_wav <= consecutive_wav+1;
                if (consecutive_wav+1>max_consecutive_wav) max_consecutive_wav<=consecutive_wav+1;
                if (!bmp_seen_data && consecutive_wav>=2) begin
                    $display("FAIL WAV burst exceeded two sectors while BMP pending at txn=%0d",txn_count);
                    failed<=1;
                end
            end else if (sd_addr==56) begin
                if (wav_walk_cluster!=6000 || wav_fat_transactions!=0) begin $display("FAIL WAV FAT continuation addr=%0d cluster=%0d",sd_addr,wav_walk_cluster); failed<=1; end
                wav_walk_cluster<=wav_walk_cluster+1; wav_fat_transactions<=wav_fat_transactions+1;
                wav_card_count<=wav_card_count+1;
                consecutive_wav<=consecutive_wav+1;
                if (consecutive_wav+1>max_consecutive_wav) max_consecutive_wav<=consecutive_wav+1;
                if (!bmp_seen_data && consecutive_wav>=2) begin $display("FAIL WAV burst exceeded two sectors while BMP pending"); failed<=1; end
            end else if (sd_addr==5095) begin
                bmp_card_count <= bmp_card_count+1;
                bmp_data_transactions <= bmp_data_transactions+1;
                consecutive_wav <= 0;
                bmp_seen_data <= 1;
            end else if (card_mode==MODE_NORMAL) begin
                if (sd_addr !== (fat_lba+(bmp_walk_cluster>>7))) begin
                    $display("FAIL unexpected SD address txn=%0d addr=%0d expected FAT=%0d bmp_cluster=%0d",txn_count,sd_addr,fat_lba+(bmp_walk_cluster>>7),bmp_walk_cluster);
                    failed<=1;
                end
                bmp_walk_cluster <= bmp_walk_cluster+1;
                bmp_card_count <= bmp_card_count+1;
                consecutive_wav <= 0;
            end
        end
        #1;
        if (payload_score_active && bmp_file_valid) begin
            if (bmp_file_data !== ((bmp_expected_data_addr+bmp_bytes)&8'hff)) begin
                $display("FAIL BMP payload idx=%0d data=%02x",bmp_bytes,bmp_file_data);
                failed<=1;
            end
            bmp_bytes<=bmp_bytes+1;
            bmp_payload_total<=bmp_payload_total+1;
        end
        if (payload_score_active && wav_file_valid) begin
            if (wav_file_data !== ((wav_expected_data_addr+wav_bytes)&8'hff)) begin
                $display("FAIL WAV payload idx=%0d data=%02x",wav_bytes,wav_file_data);
                failed<=1;
            end
            wav_bytes<=wav_bytes+1;
            wav_payload_total<=wav_payload_total+1;
        end
        if (bmp_file_end) begin $display("BMP END err=%b code=%02x cycle=%0d",bmp_error,bmp_error_code,cycle_count); bmp_ends<=bmp_ends+1; end
        if (wav_file_end) begin $display("WAV END err=%b code=%02x cycle=%0d",wav_error,wav_error_code,cycle_count); wav_ends<=wav_ends+1; end

    end

    task pulse_bmp;
        begin
            @(negedge clk); bmp_file_read=0;
            repeat(2) @(negedge clk);
            bmp_file_read=1;
            @(negedge clk); bmp_file_read=0;
        end
    endtask
    task pulse_wav;
        begin
            @(negedge clk); wav_file_read=0;
            repeat(2) @(negedge clk);
            wav_file_read=1;
            @(negedge clk); wav_file_read=0;
        end
    endtask
    task do_reset;
        begin
            @(negedge clk); bmp_file_read=0; wav_file_read=0; rst=1;
            card_active=0; sd_valid=0; sd_end=0;
            repeat(5) @(negedge clk);
            rst=0;
            repeat(4) @(negedge clk);
        end
    endtask
    task wait_wav_end;
        input integer limit;
        integer n;
        begin
            n=0;
            while ((wav_ends==0) && (n<limit)) begin @(negedge clk); n=n+1; end
            if (n>=limit) begin $display("FAIL WAV completion timeout"); failed=1; end
        end
    endtask

    initial begin
        // Concurrent long BMP traversal and repeated low-water WAV service.
        repeat(5) @(negedge clk); rst=0; repeat(4) @(negedge clk);
        scoreboard_active=1; payload_score_active=1;
        pulse_bmp();
        // Launch WAV during the long BMP FAT walk, then re-arm after each sector.
        repeat(1800) @(negedge clk);
        pulse_wav();
        watchdog=0;
        while (wav_ends<1 && watchdog<6000) begin @(negedge clk); watchdog=watchdog+1; end
        if (wav_ends<1) begin $display("FAIL first concurrent WAV did not complete"); failed=1; end
        repeat(4) @(negedge clk); wav_file_sector=1; wav_expected_data_addr=6999; wav_bytes=0; pulse_wav();
        watchdog=0;
        while (wav_ends<2 && watchdog<6000) begin @(negedge clk); watchdog=watchdog+1; end
        if (wav_ends<2) begin $display("FAIL second concurrent WAV did not complete"); failed=1; end
        watchdog=0;
        while (bmp_ends<1 && watchdog<3000000) begin @(negedge clk); watchdog=watchdog+1; end
        if (bmp_ends<1) begin $display("FAIL 4096-cluster BMP request timeout"); failed=1; end
        bmp_bytes=0; pulse_bmp(); watchdog=0;
        while (bmp_ends<2 && watchdog<3000) begin @(negedge clk); watchdog=watchdog+1; end
        if (bmp_ends<2 || bmp_error || bmp_bytes!=512) begin $display("FAIL BMP cache hit repeat"); failed=1; end
        if (bmp_payload_total!=1024 || wav_payload_total!=1024 || bmp_data_transactions!=2 || wav_card_count!=3 || wav_fat_transactions!=1) begin
            $display("FAIL concurrent counts bmp_total=%0d wav_total=%0d bmp_data=%0d wav_txn=%0d wav_fat=%0d",bmp_payload_total,wav_payload_total,bmp_data_transactions,wav_card_count,wav_fat_transactions);
            failed=1;
        end
        if (bmp_walk_cluster!=4097 || max_consecutive_wav>2) begin
            $display("FAIL transaction scoreboard final cluster=%0d max WAV burst=%0d",bmp_walk_cluster,max_consecutive_wav);
            failed=1;
        end
        $display("PASS concurrent 4096-cluster BMP plus cached BMP repeat and WAV seek; transactions=%0d BMP FAT hops=%0d WAV burst max=%0d cycles=%0d",txn_count,bmp_walk_cluster-2,max_consecutive_wav,cycle_count);
        scoreboard_active=0; payload_score_active=0;

        // Disable during an armed request aborts work; re-enable requires a fresh low/high arm.
        do_reset();
        bmp_end_base=bmp_ends; bmp_file_sector=0; bmp_file_size=512; bmp_file_read=0;
        pulse_bmp();
        repeat(20) @(negedge clk);
        bmp_enable=0; repeat(540) @(negedge clk); bmp_enable=1;
        bmp_file_read=0; repeat(3) @(negedge clk); pulse_bmp();
        watchdog=0;
        while ((bmp_ends<3) && (watchdog<5000)) begin @(negedge clk); watchdog=watchdog+1; end
        if (bmp_ends<3) begin $display("FAIL disable/rearm short BMP read timeout"); failed=1; end

        do_reset();
        // Changing file identity and seeking back must start from the new context.
        bmp_end_base=bmp_ends; bmp_start_cluster=7000; bmp_file_size=3*512; bmp_file_sector=2; bmp_expected_data_addr=8000; bmp_bytes=0; payload_score_active=1;
        pulse_bmp(); watchdog=0;
        while ((bmp_ends<=bmp_end_base) && (watchdog<3000)) begin @(negedge clk); watchdog=watchdog+1; end
        repeat(3) @(negedge clk);
        if (bmp_ends<=bmp_end_base || bmp_error || bmp_bytes!=512) begin $display("FAIL changed-file seek payload/end count=%0d bytes=%0d",bmp_ends,bmp_bytes); failed=1; end
        bmp_end_base=bmp_ends; bmp_start_cluster=7100; bmp_file_size=512; bmp_file_sector=0; bmp_expected_data_addr=8098; bmp_bytes=0;
        pulse_bmp(); watchdog=0;
        while ((bmp_ends<=bmp_end_base) && (watchdog<5000)) begin @(negedge clk); watchdog=watchdog+1; end
        if (bmp_ends<=bmp_end_base || bmp_error || bmp_bytes!=512) begin $display("FAIL second file switch failed"); failed=1; end
        payload_score_active=0;
        $display("PASS disable/rearm, seek and file identity switching with payload checks");

        // Error-class contracts use isolated requests and reset the sticky state between cases.
        do_reset(); card_mode=4; bmp_start_cluster=2; bmp_file_size=4*512; bmp_file_sector=2;
        pulse_bmp(); watchdog=0;
        while ((bmp_file_end!==1'b1) && watchdog<3000) begin @(negedge clk); watchdog=watchdog+1; end
        if (!bmp_error || bmp_error_code!==8'h07) begin $display("FAIL EOC classification got %b/%02x",bmp_error,bmp_error_code); failed=1; end

        do_reset(); card_mode=5; bmp_start_cluster=2; bmp_file_size=5*512; bmp_file_sector=3;
        pulse_bmp(); watchdog=0;
        while ((bmp_file_end!==1'b1) && watchdog<6000) begin @(negedge clk); watchdog=watchdog+1; end
        if (!bmp_error || bmp_error_code!==8'h08) begin $display("FAIL loop classification got %b/%02x",bmp_error,bmp_error_code); failed=1; end

        do_reset(); card_mode=3; bmp_start_cluster=2; bmp_file_size=2*512; bmp_file_sector=1;
        pulse_bmp(); watchdog=0;
        while ((bmp_file_end!==1'b1) && watchdog<3000) begin @(negedge clk); watchdog=watchdog+1; end
        if (!bmp_error || bmp_error_code!==8'h06) begin $display("FAIL bad-FAT classification got %b/%02x",bmp_error,bmp_error_code); failed=1; end

        do_reset(); card_mode=MODE_SHORT; short_bytes=127; bmp_start_cluster=2; bmp_file_size=512; bmp_file_sector=0;
        pulse_bmp(); watchdog=0;
        while ((bmp_file_end!==1'b1) && watchdog<5000) begin @(negedge clk); watchdog=watchdog+1; end
        if (!bmp_error || bmp_error_code!==8'h05) begin $display("FAIL short-sector classification got %b/%02x",bmp_error,bmp_error_code); failed=1; end

        do_reset(); card_mode=MODE_SIMULTANEOUS; bmp_start_cluster=2; bmp_file_size=512; bmp_file_sector=0;
        pulse_bmp(); watchdog=0;
        while ((bmp_file_end!==1'b1) && watchdog<2000) begin @(negedge clk); watchdog=watchdog+1; end
        if (!bmp_error || bmp_error_code!==8'h05) begin $display("FAIL simultaneous data final-byte/end classification %b/%02x",bmp_error,bmp_error_code); failed=1; end

        do_reset(); card_mode=MODE_SIMULTANEOUS; bmp_start_cluster=2; bmp_file_size=2*512; bmp_file_sector=1;
        pulse_bmp(); watchdog=0;
        while ((bmp_file_end!==1'b1) && watchdog<2000) begin @(negedge clk); watchdog=watchdog+1; end
        if (!bmp_error || bmp_error_code!==8'h05) begin $display("FAIL simultaneous FAT final-byte/end classification %b/%02x",bmp_error,bmp_error_code); failed=1; end
        do_reset(); card_mode=MODE_TIMEOUT; bmp_start_cluster=2; bmp_file_size=512; bmp_file_sector=0;
        pulse_bmp(); watchdog=0;
        while ((bmp_file_end!==1'b1) && watchdog<5000) begin @(negedge clk); watchdog=watchdog+1; end
        if (!bmp_error || bmp_error_code!==8'h0a) begin $display("FAIL timeout classification got %b/%02x",bmp_error,bmp_error_code); failed=1; end

        // Both clients retain independent watchdogs while the card owner hangs.
        do_reset(); card_mode=MODE_TIMEOUT; bmp_start_cluster=2; bmp_file_size=512; bmp_file_sector=0;
        wav_start_cluster=6000; wav_file_size=512; wav_file_sector=0;
        begin : both_timeout_case
            integer bmp_base, wav_base, n;
            bmp_base=bmp_ends; wav_base=wav_ends;
            pulse_bmp(); pulse_wav();
            n=0;
            while (((bmp_ends==bmp_base) || (wav_ends==wav_base)) && (n<7000)) begin @(negedge clk); n=n+1; end
            if (bmp_ends==bmp_base || wav_ends==wav_base || !bmp_error || bmp_error_code!==8'h0a || !wav_error || wav_error_code!==8'h0a) begin
                $display("FAIL dual pending timeout bmp=%b/%02x wav=%b/%02x",bmp_error,bmp_error_code,wav_error,wav_error_code);
                failed=1;
            end else $display("PASS independent timeout classification for both pending clients");
        end

        // Reset during an owned sector cancels old ownership; fresh requests receive fresh bytes.
        do_reset(); card_mode=MODE_NORMAL; bmp_file_size=512; bmp_file_sector=0; wav_file_size=512; wav_file_sector=0;
        begin : reset_abort_case
            integer bmp_base, wav_base, n;
            bmp_base=bmp_ends; wav_base=wav_ends;
            pulse_bmp(); pulse_wav(); repeat(40) @(negedge clk);
            do_reset(); bmp_file_read=0; wav_file_read=0;
            bmp_base=bmp_ends; wav_base=wav_ends;
            pulse_bmp(); pulse_wav();
            n=0;
            while (((bmp_ends==bmp_base) || (wav_ends==wav_base)) && (n<7000)) begin @(negedge clk); n=n+1; end
            if (bmp_ends==bmp_base || wav_ends==wav_base || bmp_error || wav_error) begin
                $display("FAIL reset-abort/rearm result bmp_end=%0d wav_end=%0d errors=%b/%b",bmp_ends-bmp_base,wav_ends-wav_base,bmp_error,wav_error);
                failed=1;
            end else $display("PASS reset aborts in-flight owner and fresh dual requests complete");
        end
`ifdef TEST_SHARED_CORE
        // Real simultaneous request acceptance; only seed the queued BMP timer at its edge.
        do_reset(); card_mode=MODE_NORMAL; bmp_start_cluster=2; bmp_file_size=512; bmp_file_sector=0;
        wav_start_cluster=6000; wav_file_size=512; wav_file_sector=0;
        begin : same_cycle_timeout_dispatch_case
            integer bmp_base, wav_base, n;
            bmp_base=bmp_ends; wav_base=wav_ends;
            @(negedge clk); bmp_file_read=0; wav_file_read=0;
            repeat(2) @(negedge clk);
            bmp_file_read=1; wav_file_read=1;
            @(negedge clk); bmp_file_read=0; wav_file_read=0;
            n=0;
            while (!(dut.core_state==dut.C_IDLE && dut.queued[0] && dut.queued[1]) && n<20) begin @(negedge clk); n=n+1; end
            if (n>=20) begin $display("FAIL could not establish simultaneous pending requests"); failed=1; end
            else begin
                dut.wait_count[0]=32'd2999;
                @(posedge clk); #2;
                if (!bmp_error || bmp_error_code!==8'h0a || wav_error || !dut.busy[1]) begin
                    $display("FAIL same-cycle timeout/scheduler state bmp=%b/%02x wav=%b busy_wav=%b queued_wav=%b state=%0d active=%0d",bmp_error,bmp_error_code,wav_error,dut.busy[1],dut.queued[1],dut.core_state,dut.active_client);
                    failed=1;
                end
            end
            n=0;
            while ((wav_ends==wav_base) && n<2500) begin @(negedge clk); n=n+1; end
            if (wav_ends==wav_base || wav_error || bmp_ends==bmp_base) begin
                $display("FAIL same-cycle timeout dispatch recovery bmp_end_delta=%0d wav_end_delta=%0d errors=%b/%b",bmp_ends-bmp_base,wav_ends-wav_base,bmp_error,wav_error);
                failed=1;
            end else $display("PASS BMP watchdog edge concurrent with WAV dispatch preserves WAV transaction");
        end
`endif
        if (failed) $fatal(1,"dual mapper transaction regression failed cycles=%0d",cycle_count);
        $display("PASS: reference contract suite complete");
        $finish;
    end
    initial begin #100000000; $fatal(1,"global watchdog"); end
endmodule



















