`timescale 1ns/1ps

module tb_rgb888_word_codec;
    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst = 1'b1;
    reg pack_clear = 1'b0;
    reg pack_pixel_en = 1'b0;
    reg [23:0] pack_pixel_rgb = 24'b0;
    wire pack_word_en;
    wire [31:0] pack_word_data;

    reg unpack_clear = 1'b0;
    reg unpack_pixel_en = 1'b0;
    wire [23:0] unpack_pixel_rgb;
    wire unpack_word_pop;
    wire unpack_underflow;
    reg fifo_empty = 1'b1;
    reg [31:0] fifo_data = 32'b0;

    rgb888_pack32 u_pack (
        .clk(clk), .rst(rst), .clear(pack_clear),
        .pixel_en(pack_pixel_en), .pixel_rgb(pack_pixel_rgb),
        .word_en(pack_word_en), .word_data(pack_word_data)
    );

    rgb888_unpack32 u_unpack (
        .clk(clk), .rst(rst), .clear(unpack_clear),
        .pixel_en(unpack_pixel_en), .pixel_rgb(unpack_pixel_rgb),
        .word_empty(fifo_empty), .word_pop(unpack_word_pop),
        .word_data(fifo_data), .underflow(unpack_underflow)
    );

    reg [23:0] pixels [0:15];
    reg [31:0] reference_words [0:11];
    reg [31:0] fifo_mem [0:31];
    integer fifo_rd = 0;
    integer fifo_count = 0;
    integer fifo_pop_total = 0;
    integer pop_start;
    integer i, j, bit_index, out_index, emitted, expected_count;
    reg expected_valid;
    reg [31:0] expected_word;
    reg [23:0] expected_pixel;

    // A normal synchronous FIFO: pop is sampled at this edge and its data
    // register changes after the edge. The codec consumes it on the next edge.
    always @(posedge clk) begin
        if (rst) begin
            fifo_rd <= 0;
            fifo_data <= 32'b0;
            fifo_pop_total <= 0;
        end else if (unpack_word_pop) begin
            if (fifo_rd >= fifo_count) begin
                $display("FAIL codec popped empty FIFO at time=%0t", $time);
                $fatal(1);
            end
            fifo_data <= fifo_mem[fifo_rd];
            fifo_rd <= fifo_rd + 1;
            fifo_pop_total <= fifo_pop_total + 1;
        end
    end

    // The incoming read response and the next reservation must always fit in
    // the 64-bit reservoir. A pending response implies at most 32 stored bits.
    always @(posedge clk) begin
        #1;
        if (!rst && !unpack_clear) begin
            if (u_unpack.merged_count > 7'd64 || u_unpack.bit_count > 7'd64) begin
                $display("FAIL unpack reservoir count exceeded 64 bits at time=%0t", $time);
                $fatal(1);
            end
            if (u_unpack.pop_pending && (u_unpack.bit_count > 7'd32)) begin
                $display("FAIL pending FIFO response has insufficient reserved room at time=%0t", $time);
                $fatal(1);
            end
            if ((u_unpack.bit_count + (u_unpack.pop_pending ? 7'd32 : 7'd0)) > 7'd64) begin
                $display("FAIL FIFO pending reservation exceeds 64-bit reservoir at time=%0t", $time);
                $fatal(1);
            end
        end
    end

    always @* begin
        fifo_empty = (fifo_rd >= fifo_count);
    end

    task pack_cycle;
        input en;
        input [23:0] rgb;
        input exp_valid;
        input [31:0] exp_word;
        begin
            @(negedge clk);
            pack_pixel_en = en;
            pack_pixel_rgb = rgb;
            @(posedge clk);
            #1;
            if (pack_word_en !== exp_valid) begin
                $display("FAIL pack word_en expected=%b got=%b time=%0t", exp_valid, pack_word_en, $time);
                $fatal(1);
            end
            if (exp_valid && pack_word_data !== exp_word) begin
                $display("FAIL pack word expected=%08x got=%08x time=%0t", exp_word, pack_word_data, $time);
                $fatal(1);
            end
        end
    endtask

    task unpack_cycle;
        input en;
        input clear_now;
        input check_pixel;
        input [23:0] exp_pixel;
        begin
            @(negedge clk);
            unpack_clear = clear_now;
            unpack_pixel_en = en;
            @(posedge clk);
            #1;
            if (check_pixel && unpack_pixel_rgb !== exp_pixel) begin
                $display("FAIL unpack pixel expected=%06x got=%06x time=%0t", exp_pixel, unpack_pixel_rgb, $time);
                $fatal(1);
            end
            if (!en && unpack_pixel_rgb !== 24'b0) begin
                $display("FAIL unpack idle output not zero: %06x", unpack_pixel_rgb);
                $fatal(1);
            end
        end
    endtask

    initial begin
        // Deterministic but channel-distinct values expose byte and bit-order errors.
        for (i = 0; i < 16; i = i + 1)
            pixels[i] = {8'(8'h31 + i*7), 8'(8'hA2 - i*3), 8'(8'h5D ^ (i*11))};

        // Independent reference: each output bit is the corresponding bit in
        // the concatenated P0, P1, ... LSB-first stream.
        for (i = 0; i < 12; i = i + 1) begin
            reference_words[i] = 32'b0;
            for (j = 0; j < 32; j = j + 1) begin
                bit_index = i*32 + j;
                if (pixels[bit_index/24][bit_index%24])
                    reference_words[i][j] = 1'b1;
            end
        end

        repeat (3) @(posedge clk);
        @(negedge clk);
        rst = 1'b0;

        // Exercise arbitrary gaps while comparing exact packed words.
        out_index = 0;
        expected_count = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if ((i % 3) == 1)
                pack_cycle(1'b0, 24'b0, 1'b0, 32'b0);
            expected_count = expected_count + 24;
            expected_valid = (expected_count >= 32);
            expected_word = expected_valid ? reference_words[out_index] : 32'b0;
            if (expected_valid) begin
                expected_count = expected_count - 32;
                out_index = out_index + 1;
            end
            pack_cycle(1'b1, pixels[i], expected_valid, expected_word);
        end
        if (out_index != 12) begin
            $display("FAIL pack reference emitted %0d words", out_index);
            $fatal(1);
        end
        pack_cycle(1'b0, 24'b0, 1'b0, 32'b0);

        // Begin a second frame from a deliberately partial prior group.
        pack_cycle(1'b1, 24'hD3A57C, 1'b0, 32'b0);
        @(negedge clk);
        pack_clear = 1'b1;
        pack_pixel_en = 1'b0;
        @(posedge clk);
        #1;
        if (pack_word_en !== 1'b0 || pack_word_data !== 32'b0) begin
            $display("FAIL pack clear did not discard the partial group");
            $fatal(1);
        end
        @(negedge clk);
        pack_clear = 1'b0;
        out_index = 0;
        expected_count = 0;
        for (i = 0; i < 16; i = i + 1) begin
            expected_count = expected_count + 24;
            expected_valid = (expected_count >= 32);
            expected_word = expected_valid ? reference_words[out_index] : 32'b0;
            if (expected_valid) begin
                expected_count = expected_count - 32;
                out_index = out_index + 1;
            end
            pack_cycle(1'b1, pixels[i], expected_valid, expected_word);
        end

        for (i = 0; i < 12; i = i + 1)
            fifo_mem[i] = reference_words[i];
        fifo_count = 12;
        fifo_rd = 0;

        // Prefetch while paused, then consume the full stream with gaps and
        // a continuous run long enough to require consecutive FIFO pops.
        pop_start = fifo_pop_total;
        repeat (6) unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
        emitted = 0;
        for (i = 0; i < 16; i = i + 1) begin
            if ((i % 5) == 2)
                unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
            unpack_cycle(1'b1, 1'b0, 1'b1, pixels[emitted]);
            emitted = emitted + 1;
        end
        repeat (3) unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
        if (emitted != 16 || unpack_underflow !== 1'b0) begin
            $display("FAIL normal unpack emitted=%0d underflow=%b", emitted, unpack_underflow);
            $fatal(1);
        end
        if (fifo_rd != 12 || (fifo_pop_total - pop_start) != 12) begin
            $display("FAIL first frame consumed %0d FIFO words (expected 12)", fifo_pop_total - pop_start);
            $fatal(1);
        end

        // A gap-free frame checks the sustained 3-words-per-4-pixels rate.
        unpack_cycle(1'b0, 1'b1, 1'b0, 24'b0);
        fifo_rd = 0;
        fifo_count = 12;
        pop_start = fifo_pop_total;
        repeat (4) unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
        for (i = 0; i < 16; i = i + 1)
            unpack_cycle(1'b1, 1'b0, 1'b1, pixels[i]);
        repeat (3) unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
        if (unpack_underflow !== 1'b0) begin
            $display("FAIL continuous-rate frame underflowed");
            $fatal(1);
        end
        if (fifo_rd != 12 || (fifo_pop_total - pop_start) != 12) begin
            $display("FAIL continuous frame consumed %0d FIFO words (expected 12)", fifo_pop_total - pop_start);
            $fatal(1);
        end

        // Clear in the middle of a packed group and with reads potentially in
        // flight. Restarting must begin at pixel zero with no stale bits.
        unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
        unpack_cycle(1'b0, 1'b1, 1'b0, 24'b0);
        fifo_rd = 0;
        fifo_count = 12;
        repeat (4) unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
        for (i = 0; i < 4; i = i + 1)
            unpack_cycle(1'b1, 1'b0, 1'b1, pixels[i]);

        // Empty FIFO request returns zero and latches underflow. Add a word;
        // recovery still returns its first pixel, and underflow remains sticky.
        unpack_cycle(1'b0, 1'b1, 1'b0, 24'b0);
        fifo_rd = 0;
        fifo_count = 0;
        unpack_cycle(1'b1, 1'b0, 1'b1, 24'b0);
        if (unpack_underflow !== 1'b1 || unpack_word_pop !== 1'b0) begin
            $display("FAIL starvation did not latch underflow or popped empty FIFO");
            $fatal(1);
        end
        fifo_mem[0] = reference_words[0];
        fifo_rd = 0;
        fifo_count = 1;
        unpack_cycle(1'b0, 1'b0, 1'b0, 24'b0);
        unpack_cycle(1'b1, 1'b0, 1'b1, pixels[0]);
        if (unpack_underflow !== 1'b1) begin
            $display("FAIL underflow sticky flag cleared without reset");
            $fatal(1);
        end

        $display("PASS tb_rgb888_word_codec: 12 packed words, 16 pixels, stalls, reset/clear, starvation recovery");
        $finish;
    end
endmodule
