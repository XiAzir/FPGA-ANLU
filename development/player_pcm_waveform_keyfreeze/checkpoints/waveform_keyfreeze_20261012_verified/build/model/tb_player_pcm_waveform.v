`timescale 1ns/1ps
module tb_player_pcm_waveform;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg vs = 1'b0;
    reg de = 1'b0;
    reg [23:0] rgb_in = 24'h123456;
    reg audio_valid = 1'b0;
    reg [23:0] audio_pcm = 24'd0;
    reg tone_mode = 1'b0;
    wire [23:0] rgb_out;

    reg tiny_audio_valid = 1'b0;
    reg [23:0] tiny_audio_pcm = 24'd0;
    wire [23:0] tiny_rgb_out;
    wire [23:0] tiny_rgb_passthrough;

    integer gold_min [0:127];
    integer gold_max [0:127];
    integer sent_samples;
    integer i;
    integer b;
    integer s;
    integer raw_sample;
    integer sample_code;
    integer checks;
    reg failed;

    always #5 clk = ~clk;

    player_pcm_waveform dut (
        .clk(clk), .rst(rst), .vs(vs), .de(de), .rgb_in(rgb_in),
        .audio_valid(audio_valid), .audio_pcm(audio_pcm), .tone_mode(tone_mode), .freeze_toggle(1'b0),
        .rgb_out(rgb_out)
    );

    player_pcm_waveform #(
        .CLK_FREQ_HZ(1000), .SAMPLES_PER_BIN(8), .STALE_MS(5)
    ) tiny_stale_dut (
        .clk(clk), .rst(rst), .vs(vs), .de(1'b0), .rgb_in(rgb_in),
        .audio_valid(tiny_audio_valid), .audio_pcm(tiny_audio_pcm),
        .tone_mode(1'b0), .freeze_toggle(1'b0), .rgb_out(tiny_rgb_out)
    );

    function integer make_sample;
        input integer bin_index;
        input integer sample_index;
        integer code;
        begin
            if (bin_index == 8 && sample_index == 7)
                make_sample = -32768;
            else if (bin_index == 9 && sample_index == 7)
                make_sample = 32767;
            else if (bin_index == 0)
                make_sample = (sample_index % 3 - 1) * 256 + 12*256;
            else if (bin_index == 1)
                make_sample = (sample_index % 3 - 1) * 256 - 8*256;
            else if (bin_index == 127)
                make_sample = (sample_index % 3 - 1) * 256 + 12*256;
            else begin
                code = 5 + ((bin_index * 7 + sample_index * 3) % 46);
                make_sample = (code - 28) * 256;
                if (sample_index == 2)
                    make_sample = make_sample - 1;
            end
        end
    endfunction

    function integer pcm_to_code;
        input integer pcm;
        integer q;
        begin
            // Independent integer golden arithmetic: explicit floor division.
            if (pcm >= 0)
                q = pcm / 256;
            else
                q = - ((-pcm + 255) / 256);
            q = q + 28;
            if (q < 0) q = 0;
            if (q > 56) q = 56;
            pcm_to_code = q;
        end
    endfunction

    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task send_sample;
        input integer pcm;
        begin
            @(negedge clk);
            audio_pcm = {pcm[15:0], 8'h00};
            audio_valid = 1'b1;
            tick;
            @(negedge clk);
            audio_valid = 1'b0;
        end
    endtask

    task check_value;
        input condition;
        input [8*160-1:0] label_text;
        begin
            checks = checks + 1;
            if (!condition) begin
                $display("FAIL: %0s (time=%0t)", label_text, $time);
                failed = 1'b1;
            end
        end
    endtask

    task begin_scan;
        begin
            de = 1'b0;
            @(negedge clk); vs = ~vs;
            tick;
        end
    endtask

    task pulse_vs_rising;
        begin
            @(negedge clk); vs = 1'b0;
            tick;
            @(negedge clk); vs = 1'b1;
            tick;
        end
    endtask

    task scan_to_row;
        input integer target_row;
        input integer sample_graph;
        integer row;
        integer col;
        begin
            begin_scan;
            for (row = 0; row <= target_row; row = row + 1) begin
                @(negedge clk); de = 1'b1;
                for (col = 1; col <= 640; col = col + 1) begin
                    tick;
                    if (row == 328 && dut.x_pos == 10'd24)
                        check_value(rgb_out === 24'hffffff, "PCM WAV 标题首点白字");
                    if (row == 328 && dut.x_pos == 10'd16)
                        check_value(rgb_out === 24'h000000, "面板左边界优先黑色");
                    if (row == 328 && dut.x_pos == 10'd630)
                        check_value(rgb_out === rgb_in, "面板外活动像素 RGB 原样透传");
                    if (row == 328 && dut.x_pos == 10'd90 && sample_graph == 2)
                        check_value(rgb_out === 24'hffffff, "VS 锁存 PCM TONE 标题字形");
                    if (row == 371 && sample_graph == 1) begin
                        case (dut.x_pos)
                            10'd63: check_value(rgb_out === 24'h000000, "x=63 图形左界外黑色");
                            10'd64: check_value(rgb_out === 24'h00ffff, "x=64 bin0首像素青色");
                            10'd67: check_value(rgb_out === 24'h00ffff, "x=67 bin0末像素青色");
                            10'd68: check_value(rgb_out === 24'h000000, "x=68 切到bin1同步读对齐");
                            10'd575: check_value(rgb_out === 24'h00ffff, "x=575 bin127尾像素青色");
                            10'd576: check_value(rgb_out === 24'h000000, "x=576 图形右界外黑色");
                            default: begin end
                        endcase
                    end
                    if (row == 356 && sample_graph == 1 && dut.x_pos == 10'd100)
                        check_value(rgb_out === 24'h00ffff, "y=356 波形上边界包含饱和值");
                    if (row == 384 && sample_graph == 1 && dut.x_pos == 10'd64)
                        check_value(rgb_out === 24'h404040, "无波形处中心参考线灰色");
                    if (row == 384 && sample_graph == 2) begin
                        if (dut.x_pos == 10'd64 || dut.x_pos == 10'd68)
                            check_value(rgb_out === 24'h00ffff, "PCM 零静音窗绘为青色中心线");
                    end
                    if (row == 412 && sample_graph == 1 && dut.x_pos == 10'd96)
                        check_value(rgb_out === 24'h00ffff, "y=412 波形下边界包含饱和值");
                end
                @(negedge clk); de = 1'b0;
                tick;
            end
        end
    endtask

    initial begin
        checks = 0;
        failed = 1'b0;
        sent_samples = 0;
        for (i = 0; i < 128; i = i + 1) begin
            gold_min[i] = 127;
            gold_max[i] = 0;
        end
        repeat (4) tick;
        @(negedge clk); rst = 1'b0;
        tick;
        check_value(rgb_out === 24'h123456, "blank RGB passthrough");
        check_value(dut.STALE_CYCLES_64 == 2500000, "默认 stale 周期为 2,500,000");
        check_value(dut.capture_bin === 0 && dut.front_valid === 0, "复位不依赖未初始化 RAM");

        // Full 128 x 8 capture through the actual audio interface. Sparse valid
        // pulses exercise event-only sampling and leave the final slot as an
        // extremum in bins 8 and 9.
        for (i = 0; i < 1024; i = i + 1) begin
            b = i / 8;
            s = i % 8;
            raw_sample = make_sample(b, s);
            sample_code = pcm_to_code(raw_sample);
            if (sample_code < gold_min[b]) gold_min[b] = sample_code;
            if (sample_code > gold_max[b]) gold_max[b] = sample_code;
            send_sample(raw_sample);
            sent_samples = sent_samples + 1;
            if ((i % 11) == 4) begin
                tick;
                tick;
            end
        end
        check_value(sent_samples == 1024, "整窗真实接收 1024 个有效事件");
        check_value(dut.capture_ready === 1'b1 && dut.capture_bin == 128,
                    "第 1024 样本后整窗 ready 并暂停捕获");
        for (i = 0; i < 128; i = i + 1) begin
            check_value(dut.trace_mem[128+i] === {gold_max[i][6:0],gold_min[i][6:0]},
                        "BRAM bank1 每个 bin 与整数 min/max 黄金值一致");
        end

        // Extra valid events while waiting for VS must be dropped, without
        // changing the completed capture.
        send_sample(-32768);
        check_value(dut.trace_mem[255] === {gold_max[127][6:0],gold_min[127][6:0]},
                    "窗口完成后等待 VS 时忽略 PCM 事件");
        @(negedge clk); vs = ~vs;
        tick;
        check_value(dut.front_valid === 1'b1 && dut.display_bank === 1'b1 &&
                    dut.capture_bank === 1'b0, "VS 上升沿原子切换 front/back bank");
        check_value(dut.trace_mem[128] === {gold_max[0][6:0],gold_min[0][6:0]},
                    "开始下一窗不改写显示 bank");
        check_value(dut.display_bank === 1'b1, "下一窗期间显示 bank 固定");

        scan_to_row(412, 1);
        check_value(tiny_rgb_out === 24'h123456, "tiny stale DUT blanking passthrough");

        // A non-VS source change flushes the capture state while preserving
        // the currently displayed bank for the rest of this frame.
        @(negedge clk); tone_mode = 1'b1;
        tick;
        check_value(dut.front_valid === 1'b1 && dut.display_bank === 1'b1 &&
                    dut.invalidate_pending === 1'b1 && dut.capture_bin === 0,
                    "非 VS 音源变化保留当前帧 front 和 bank");
        for (i = 0; i < 1024; i = i + 1)
            send_sample(0);
        check_value(dut.capture_ready === 1'b1 && dut.front_valid === 1'b1 &&
                    dut.display_bank === 1'b1 && dut.invalidate_pending === 1'b1,
                    "新音源整窗 ready 前旧图稳定保留");
        for (i = 0; i < 128; i = i + 1)
            check_value(dut.trace_mem[i] === {7'd28,7'd28},
                        "新源静音窗全部 bin 平为 code 28");
        pulse_vs_rising;
        check_value(dut.front_valid === 1'b1 && dut.display_bank === 1'b0 &&
                    dut.invalidate_pending === 1'b0 && dut.frame_tone_mode === 1'b1,
                    "VS 显示完整新源 bank 并清除 invalidate_pending");
        scan_to_row(384, 2);

        // A source change without a ready replacement clears the old picture
        // on the next VS. The intervening partial bin is discarded on a second
        // source change, while the active-frame front stays stable.
        @(negedge clk); tone_mode = 1'b0;
        tick;
        check_value(dut.front_valid === 1'b1 && dut.display_bank === 1'b0 &&
                    dut.invalidate_pending === 1'b1,
                    "非 VS source clear 请求不撕裂当前显示帧");
        send_sample(4096);
        send_sample(4352);
        @(negedge clk); tone_mode = 1'b1;
        tick;
        check_value(dut.front_valid === 1'b1 && dut.display_bank === 1'b0 &&
                    dut.capture_bin === 0 && dut.samples_in_bin === 0,
                    "半个 bin 的旧源事件被丢弃且 front 保持");
        pulse_vs_rising;
        check_value(dut.front_valid === 1'b0 && dut.display_bank === 1'b0 &&
                    dut.invalidate_pending === 0,
                    "无 ready 替代窗时下一个 VS 清图但不换 bank");

        // A simultaneous source change, VS edge, and audio event clears the
        // picture immediately and must not write that coincident event.
        @(negedge clk); vs = 1'b0;
        tick;
        @(negedge clk); tone_mode = 1'b0; audio_valid = 1'b1;
        audio_pcm = {16'h7fff,8'h00}; vs = 1'b1;
        tick;
        @(negedge clk); audio_valid = 1'b0;
        check_value(dut.front_valid === 1'b0 && dut.capture_ready === 1'b0 &&
                    dut.capture_bin === 0 && dut.samples_in_bin === 0,
                    "tone 与 VS 同沿优先清空 partial/ready 窗");
        check_value(dut.trace_mem[128] === {gold_max[0][6:0],gold_min[0][6:0]},
                    "tone+VS 同沿 PCM 事件不会写 BRAM");

        // Scaled timeout: a valid sample arriving exactly at the expiry count
        // suppresses expiry, resets the timer, and is still captured.
        @(negedge clk); tiny_audio_valid = 1'b1; tiny_audio_pcm = 24'd0;
        tick;
        @(negedge clk); tiny_audio_valid = 1'b0;
        repeat (4) tick;
        check_value(tiny_stale_dut.stale_count === 4 &&
                    tiny_stale_dut.stale_pending === 1'b0,
                    "stale 门限前累计四个空闲周期");
        @(negedge clk); tiny_audio_valid = 1'b1;
        tick;
        @(negedge clk); tiny_audio_valid = 1'b0;
        check_value(tiny_stale_dut.stale_count === 0 &&
                    tiny_stale_dut.stale_pending === 1'b0 &&
                    tiny_stale_dut.samples_in_bin === 2,
                    "门限沿有效 PCM 被采样且不会触发 stale");
        repeat (5) tick;
        check_value(tiny_stale_dut.stale_pending === 1'b1 &&
                    tiny_stale_dut.stale_count === 4,
                    "缩放 stale 参数在准确第五个空闲周期置位");
        pulse_vs_rising;
        check_value(tiny_stale_dut.front_valid === 1'b0 &&
                    tiny_stale_dut.stale_pending === 1'b0,
                    "stale 请求的 VS 清图并恢复捕获");
        @(negedge clk); tiny_audio_valid = 1'b1;
        tick;
        @(negedge clk); tiny_audio_valid = 1'b0;
        check_value(tiny_stale_dut.samples_in_bin === 1,
                    "stale 清理后可重新接收 PCM");

        // Fill one tiny-instance window, display it, then make a second window
        // ready and let stale expiry coincide with VS. Stale must clear the old
        // front instead of swapping in the expired ready bank.
        for (i = 0; i < 1023; i = i + 1) begin
            @(negedge clk); tiny_audio_valid = 1'b1; tiny_audio_pcm = 24'd0;
            tick;
        end
        @(negedge clk); tiny_audio_valid = 1'b0;
        check_value(tiny_stale_dut.capture_ready === 1'b1,
                    "tiny 实例第一完整窗口 ready");
        pulse_vs_rising;
        check_value(tiny_stale_dut.front_valid === 1'b1 &&
                    tiny_stale_dut.display_bank === 1'b1,
                    "tiny 实例先显示有效 bank");
        for (i = 0; i < 1024; i = i + 1) begin
            @(negedge clk); tiny_audio_valid = 1'b1; tiny_audio_pcm = 24'd0;
            tick;
        end
        @(negedge clk); tiny_audio_valid = 1'b0; vs = 1'b0;
        check_value(tiny_stale_dut.capture_ready === 1'b1 &&
                    tiny_stale_dut.front_valid === 1'b1,
                    "stale 前 replacement ready 不扰动旧 front");
        tick;
        repeat (3) tick;
        check_value(tiny_stale_dut.stale_count === 4 &&
                    tiny_stale_dut.stale_pending === 1'b0,
                    "ready replacement 已累计四个空闲周期");
        @(negedge clk); vs = 1'b1;
        tick;
        check_value(tiny_stale_dut.front_valid === 1'b0 &&
                    tiny_stale_dut.display_bank === 1'b1 &&
                    tiny_stale_dut.capture_ready === 1'b0,
                    "stale+VS 同沿清 front 并丢弃 ready bank，不交换");

        // Reset with a valid event must never perform an independent BRAM write.
        @(negedge clk); rst = 1'b1; audio_valid = 1'b1;
        tick;
        check_value(dut.trace_mem[128] === {gold_max[0][6:0],gold_min[0][6:0]},
                    "复位期间 audio_valid 不触发 BRAM 写");
        @(negedge clk); audio_valid = 1'b0; rst = 1'b0;
        tick;

        if (failed) begin
            $display("MODEL FAIL checks=%0d", checks);
            $fatal(1);
        end else begin
            $display("MODEL PASS checks=%0d full_window_samples=%0d", checks, sent_samples);
            $finish;
        end
    end
endmodule
