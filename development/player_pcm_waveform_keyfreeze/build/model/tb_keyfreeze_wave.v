`timescale 1ns/1ps
module tb_keyfreeze_wave;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg vs = 1'b0;
    reg de = 1'b0;
    reg [23:0] rgb_in = 24'h123456;
    reg audio_valid = 1'b0;
    reg [23:0] audio_pcm = 24'd0;
    reg tone_mode = 1'b0;
    reg freeze_toggle = 1'b0;
    wire [23:0] rgb_out;

    reg dense_rst = 1'b1;
    reg dense_vs = 1'b0;
    reg dense_audio_valid = 1'b0;
    reg [23:0] dense_audio_pcm = 24'h001234;
    wire [23:0] dense_rgb_out;
    integer checks = 0;
    integer failures = 0;
    integer i;
    integer j;
    integer front_bank_snapshot;
    integer back_bank_snapshot;
    reg [13:0] saved_front [0:127];
    reg [13:0] saved_back [0:127];

    always #5 clk = ~clk;

    player_pcm_waveform #(
        .CLK_FREQ_HZ(1000), .SAMPLES_PER_BIN(1), .STALE_MS(1000)
    ) dut (
        .clk(clk), .rst(rst), .vs(vs), .de(de), .rgb_in(rgb_in),
        .audio_valid(audio_valid), .audio_pcm(audio_pcm),
        .tone_mode(tone_mode), .freeze_toggle(freeze_toggle), .rgb_out(rgb_out)
    );

    // Exact default RTL parameters; 144000 continuous audio-valid clocks must
    // never synthesize a key request or freeze on their own.
    player_pcm_waveform dense_audio_dut (
        .clk(clk), .rst(dense_rst), .vs(dense_vs), .de(1'b0), .rgb_in(rgb_in),
        .audio_valid(dense_audio_valid), .audio_pcm(dense_audio_pcm),
        .tone_mode(1'b0), .freeze_toggle(1'b0), .rgb_out(dense_rgb_out)
    );

    task tick;
        begin @(posedge clk); #1; end
    endtask

    task check;
        input condition;
        input [8*120-1:0] label_text;
        begin
            checks = checks + 1;
            if (condition !== 1'b1) begin
                failures = failures + 1;
                $display("FAIL %0s at %0t", label_text, $time);
            end
        end
    endtask

    task reset_dut;
        begin
            @(negedge clk);
            rst = 1'b1; vs = 1'b0; audio_valid = 1'b0;
            freeze_toggle = 1'b0; tone_mode = 1'b0;
            tick;
            @(negedge clk); rst = 1'b0;
            tick;
        end
    endtask

    task send_capture;
        input integer signed pcm;
        integer n;
        begin
            @(negedge clk);
            audio_pcm = {pcm[15:0], 8'h00};
            audio_valid = 1'b1;
            for (n = 0; n < 128; n = n + 1) tick;
            @(negedge clk); audio_valid = 1'b0;
            #1;
        end
    endtask

    task send_partial;
        input integer signed pcm;
        input integer count;
        integer n;
        begin
            @(negedge clk);
            audio_pcm = {pcm[15:0], 8'h00};
            audio_valid = 1'b1;
            for (n = 0; n < count; n = n + 1) tick;
            @(negedge clk); audio_valid = 1'b0;
            #1;
        end
    endtask

    task pulse_vs;
        begin
            @(negedge clk); vs = 1'b0; tick;
            @(negedge clk); vs = 1'b1; tick;
            @(negedge clk); vs = 1'b0; tick;
        end
    endtask

    task pulse_toggle;
        begin
            @(negedge clk); freeze_toggle = 1'b1; tick;
            @(negedge clk); freeze_toggle = 1'b0;
        end
    endtask

    task make_front;
        input integer signed pcm;
        begin
            send_capture(pcm);
            check(dut.capture_ready, "完整窗口已等待 VS 提交");
            pulse_vs;
            check(dut.front_valid, "首个完整窗口已成为 front");
            check(dut.display_bank == 1'b1, "首个完整窗口交换到 bank1");
        end
    endtask

    task snapshot_banks;
        begin
            front_bank_snapshot = dut.display_bank;
            back_bank_snapshot = dut.capture_bank;
            for (j = 0; j < 128; j = j + 1) begin
                saved_front[j] = dut.trace_mem[{front_bank_snapshot[0], j[6:0]}];
                saved_back[j] = dut.trace_mem[{back_bank_snapshot[0], j[6:0]}];
            end
        end
    endtask

    task check_snapshot_banks;
        input [8*120-1:0] label_text;
        begin
            check(dut.display_bank == front_bank_snapshot[0], {label_text, " bank 未交换"});
            check(dut.capture_bank == back_bank_snapshot[0], {label_text, " capture bank 未交换"});
            for (j = 0; j < 128; j = j + 1) begin
                check(dut.trace_mem[{front_bank_snapshot[0], j[6:0]}] === saved_front[j],
                      {label_text, " front RAM 保持"});
                check(dut.trace_mem[{back_bank_snapshot[0], j[6:0]}] === saved_back[j],
                      {label_text, " back RAM 保持"});
            end
        end
    endtask

    initial begin
        #1;
        // A visible front exists while a different complete back window waits.
        reset_dut;
        make_front(-20000);
        send_capture(20000);
        check(dut.capture_ready, "新 back 窗口已完整就绪");
        snapshot_banks;
        pulse_toggle;
        pulse_vs;
        check(dut.frozen_front && dut.freeze_requested, "有 front 时按键在 VS 冻结");
        check(!dut.capture_ready, "冻结取消 ready back，避免后续替换 front");
        check_snapshot_banks("刚冻结");

        // Multiple VS events, new extreme samples and silence cannot write or
        // exchange either bank while frozen. Stale counting is paused too.
        for (i = 0; i < 3; i = i + 1) begin
            @(negedge clk); audio_valid = 1'b1; audio_pcm = {16'h7fff, 8'h00};
            repeat (4) tick;
            @(negedge clk); audio_valid = 1'b0;
            repeat (3) tick;
            pulse_vs;
        end
        repeat (1100) tick;
        check(dut.frozen_front && dut.front_valid, "静音跨过 stale 门限仍保持 frozen front");
        check(dut.stale_count == 0 && !dut.stale_pending, "冻结期间 stale 状态不推进/不清 front");
        check_snapshot_banks("冻结多帧与新极值");

        // Resume is committed at VS, drops partial state and retains the old
        // front until all 128 new bins have arrived and a later VS swaps them.
        pulse_toggle;
        pulse_vs;
        check(!dut.frozen_front && !dut.freeze_requested, "第二次按键在 VS 恢复");
        check(dut.capture_active && !dut.capture_ready, "恢复后重开新 capture");
        check(dut.capture_bin == 0 && dut.samples_in_bin == 0, "恢复丢弃部分 back 并从 bin0 重采");
        check(dut.display_bank == front_bank_snapshot[0], "恢复时保留旧 front bank");
        for (j = 0; j < 128; j = j + 1)
            check(dut.trace_mem[{front_bank_snapshot[0], j[6:0]}] === saved_front[j],
                  "恢复后的新窗口未覆盖旧 front RAM");
        send_capture(32767);
        check(dut.capture_ready, "恢复后新极值窗口完整");
        check(dut.trace_mem[{dut.capture_bank, 7'd0}][13:7] == 7'd56 &&
              dut.trace_mem[{dut.capture_bank, 7'd0}][6:0] == 7'd56,
              "恢复后极值写入新 back");
        pulse_vs;
        check(dut.front_valid && dut.display_bank != front_bank_snapshot[0],
              "新完整窗口才替换旧 front");

        // Freeze with a genuinely partial back capture. The partial progress
        // must be discarded at resume while the current front remains intact.
        reset_dut;
        make_front(-22000);
        snapshot_banks;
        send_partial(22000, 19);
        check(dut.capture_bin == 19 && !dut.capture_ready, "冻结前 back 已有真实 partial 进度");
        pulse_toggle;
        pulse_vs;
        check(dut.frozen_front && dut.capture_bin == 19, "冻结保留待丢弃的 partial 元数据");
        pulse_toggle;
        pulse_vs;
        check(!dut.frozen_front && dut.capture_bin == 0 && dut.samples_in_bin == 0,
              "恢复时清除 partial capture 元数据");
        check(dut.display_bank == front_bank_snapshot[0], "partial 恢复仍显示旧 front");
        for (j = 0; j < 128; j = j + 1)
            check(dut.trace_mem[{front_bank_snapshot[0], j[6:0]}] === saved_front[j],
                  "partial 丢弃时旧 front RAM 未变");

        // With no front, a request remains pending while capture proceeds;
        // first full capture is submitted and frozen on VS.
        reset_dut;
        pulse_toggle;
        pulse_vs;
        check(!dut.front_valid && !dut.frozen_front && dut.freeze_requested,
              "无 front 时请求等待完整 capture");
        send_capture(-32768);
        check(dut.capture_ready && dut.capture_active == 1'b0,
              "等待期间完整窗口可正常完成");
        pulse_vs;
        check(dut.front_valid && dut.frozen_front && dut.freeze_requested,
              "無 front 请求在首次提交时冻结");

        // Two toggles before VS cancel. A normal ready exchange still happens.
        reset_dut;
        make_front(-10000);
        send_capture(12000);
        pulse_toggle;
        pulse_toggle;
        check(!dut.freeze_requested, "VS 前双 toggle 互相抵消");
        pulse_vs;
        check(!dut.frozen_front && dut.display_bank == 1'b0,
              "快速取消后 ready back 正常交换");

        // A toggle on the exact VS sampling edge is registered after the
        // current VS decision; it may take effect at the following VS.
        reset_dut;
        make_front(-18000);
        send_capture(18000);
        @(negedge clk); vs = 1'b1; freeze_toggle = 1'b1; tick;
        check(!dut.frozen_front && dut.display_bank == 1'b0 && dut.freeze_requested,
              "同沿 toggle/VS 按旧 request 先提交 ready back");
        @(negedge clk); freeze_toggle = 1'b0; vs = 1'b0; tick;
        pulse_vs;
        check(dut.frozen_front && dut.display_bank == 1'b0,
              "同沿 toggle 在后续 VS 冻结当前 front");

        // Tone-mode changes override a simultaneous toggle and VS; while
        // already frozen, tone changes cancel hold and follow invalidation.
        reset_dut;
        make_front(-18000);
        @(negedge clk); vs = 1'b1; tone_mode = 1'b1; freeze_toggle = 1'b1; tick;
        check(!dut.freeze_requested && !dut.frozen_front && !dut.front_valid,
              "tone+toggle+VS 优先清请求并失效 front");
        @(negedge clk); vs = 1'b0; freeze_toggle = 1'b0; tick;

        reset_dut;
        make_front(-18000);
        pulse_toggle;
        pulse_vs;
        check(dut.frozen_front && dut.front_valid, "tone 优先级测试前已冻结");
        @(negedge clk); tone_mode = 1'b1; tick;
        check(!dut.frozen_front && !dut.freeze_requested && dut.invalidate_pending,
              "冻结时 tone 切换立即取消 hold 并排队失效");
        pulse_vs;
        check(!dut.front_valid && !dut.frozen_front && dut.capture_active,
              "tone 切换后的 VS 恢复原 invalidate/capture 流程");

        // A default-parameter DUT receives exactly 144000 dense audio events.
        // VS pulses every 4096 clocks to allow regular front submissions.
        @(negedge clk); dense_rst = 1'b0; dense_audio_valid = 1'b1;
        for (i = 0; i < 144000; i = i + 1) begin
            if ((i % 4096) == 2048) dense_vs = 1'b1;
            else if ((i % 4096) == 2050) dense_vs = 1'b0;
            tick;
        end
        @(negedge clk); dense_audio_valid = 1'b0; dense_vs = 1'b0;
        check(!dense_audio_dut.freeze_requested && !dense_audio_dut.frozen_front,
              "默认参数 144000 密集音频事件无自动 freeze");
        check(dense_audio_dut.front_valid, "密集音频测试期间默认 DUT 持续正常出 front");

        if (failures == 0)
            $display("KEYFREEZE PASS checks=%0d failures=0 dense_audio_events=144000", checks);
        else
            $display("KEYFREEZE FAIL checks=%0d failures=%0d dense_audio_events=144000", checks, failures);
        $finish;
    end
endmodule
