`timescale 1ns/1ps
// Integration test uses the actual generated FIFO RTL and frame controllers.
// Only the encrypted SDRAM controller/device is replaced by an application model.
module tb_compact_frame_buffer;
    parameter WIDTH = 16;
    parameter HEIGHT = 64;
    parameter FLIP = 1;
    // Signed relative latency: -1=data leads valid, +1=data lags valid.
    parameter DATA_LAG = -1;
    parameter CAPTURE_DELAY = 0;
    parameter DATA_DELAY = 1;
    localparam WORDS = WIDTH * HEIGHT * 3 / 4;
    reg rst = 1;
    reg mem_clk = 0, write_clk = 0, read_clk = 0;
    always #10 mem_clk = ~mem_clk;
    always #7 write_clk = ~write_clk;
    always #20 read_clk = ~read_clk;
    reg write_req = 0, write_pixel_en = 0;
    reg [1:0] write_frame_index = 0;
    reg [23:0] write_pixel_rgb = 0;
    wire write_req_ack, write_finish;
    reg read_req = 0, read_pixel_en = 0;
    reg [1:0] read_frame_index = 0;
    wire read_req_ack;
    wire [23:0] read_pixel_rgb;
    integer writes_done = 0;
    integer capture_count = 0;
    frame_buffer_rgb888 #(.FRAME_WIDTH(WIDTH), .FRAME_HEIGHT(HEIGHT),
        .WRITE_V_FLIP(FLIP), .SDR_READ_CAPTURE_DELAY(CAPTURE_DELAY),
        .SDR_READ_DATA_DELAY(DATA_DELAY)) dut (
        .rst(rst), .mem_clk(mem_clk), .mem_clk_shift(mem_clk),
        .write_clk(write_clk), .write_req(write_req),
        .write_req_ack(write_req_ack), .write_frame_index(write_frame_index),
        .write_pixel_en(write_pixel_en), .write_pixel_rgb(write_pixel_rgb),
        .write_finish(write_finish), .read_clk(read_clk), .read_req(read_req),
        .read_req_ack(read_req_ack), .read_frame_index(read_frame_index),
        .read_pixel_en(read_pixel_en), .read_pixel_rgb(read_pixel_rgb)
    );
    always @(posedge mem_clk) if (write_finish) writes_done = writes_done + 1;

    function [23:0] pattern;
        input integer frame, x, y;
        begin
            pattern[23:16] = (frame * 83 + x * 7 + y * 3) & 255;
            pattern[15:8] = (frame * 31 + x * 11 + y * 13) & 255;
            pattern[7:0] = (frame * 127 + x * 17 + y * 23) & 255;
        end
    endfunction
    function [31:0] expected_word;
        input integer frame, address;
        integer byte_no, x, y, j;
        reg [23:0] rgb;
        begin
            // Independent byte-index reference over a top-down memory frame.
            expected_word = 0;
            for (j = 0; j < 4; j = j + 1) begin
                byte_no = address * 4 + j;
                x = (byte_no / 3) % WIDTH;
                y = (byte_no / 3) / WIDTH;
                rgb = pattern(frame, x, FLIP ? HEIGHT - 1 - y : y);
                case (byte_no % 3)
                    0: expected_word[j*8 +: 8] = rgb[7:0];
                    1: expected_word[j*8 +: 8] = rgb[15:8];
                    2: expected_word[j*8 +: 8] = rgb[23:16];
                endcase
            end
        end
    endfunction
    // Verify each FIFO capture, including first/last words of every burst.
    always @(posedge mem_clk) begin
        if (rst || dut.read_fifo_clear) capture_count = 0;
        else if (dut.u_legacy_frame_backend.read_capture_valid) begin
            if (capture_count >= WORDS) $fatal(1,"extra FIFO capture after frame end");
            if (dut.u_legacy_frame_backend.read_capture_data !==
                expected_word(read_frame_index,capture_count))
                $fatal(1,"capture mismatch frame=%0d word=%0d burst_offset=%0d expected=%h got=%h",
                    read_frame_index,capture_count,capture_count%256,
                    expected_word(read_frame_index,capture_count),
                    dut.u_legacy_frame_backend.read_capture_data);
            capture_count = capture_count + 1;
        end
    end
    task write_frame;
        input integer frame;
        integer x, y, previous_done, a;
        begin
            previous_done = writes_done;
            @(negedge write_clk);
            write_frame_index = frame;
            write_req = 1;
            wait (write_req_ack);
            @(negedge write_clk); write_req = 0;
            wait (!dut.write_fifo_clear);
            repeat (6) @(negedge write_clk);
            for (y = 0; y < HEIGHT; y = y + 1)
                for (x = 0; x < WIDTH; x = x + 1) begin
                    @(negedge write_clk);
                    write_pixel_en = 1;
                    write_pixel_rgb = pattern(frame, x, y);
                    @(negedge write_clk); write_pixel_en = 0;
                    // Faster than actual SPI image input, with extra sector-like gaps.
                    repeat (5 + ((x % 37 == 0) ? 8 : 0)) @(negedge write_clk);
                end
            wait (writes_done > previous_done);
            repeat (4) @(negedge mem_clk);
            for (a = 0; a < WORDS; a = a + 1) begin
                if (dut.u_sdram.mem[frame * WORDS + a] !== expected_word(frame, a))
                    $fatal(1, "memory mismatch frame=%0d word=%0d expected=%h got=%h",
                        frame, a, expected_word(frame,a), dut.u_sdram.mem[frame*WORDS+a]);
                if (dut.u_sdram.write_hits[frame*WORDS+a] != 1)
                    $fatal(1, "missing/duplicate memory write frame=%0d word=%0d", frame,a);
            end
            $display("MEMORY_PASS frame=%0d words=%0d width=%0d flip=%0d", frame, WORDS, WIDTH, FLIP);
        end
    endtask
    task read_frame;
        input integer frame, gaps;
        integer x, y, pixel_no, words_before;
        reg [23:0] expected;
        begin
            @(negedge read_clk);
            read_frame_index = frame;
            read_req = 1;
            wait(read_req_ack);
            @(negedge read_clk); read_req = 0;
            wait(!dut.read_fifo_clear);
            words_before = dut.u_sdram.read_count;
            // Real video has a long vertical blanking interval for prefill.
            repeat(700) @(negedge read_clk);
            pixel_no = 0;
            for (y=0; y<HEIGHT; y=y+1) begin
                for (x=0; x<WIDTH; x=x+1) begin
                    @(negedge read_clk);
                    read_pixel_en = 1;
                    expected = pattern(frame, x, FLIP ? HEIGHT-1-y : y);
                    @(posedge read_clk); #1;
                    if (read_pixel_rgb !== expected)
                        $fatal(1,"pixel mismatch frame=%0d x=%0d y=%0d expected=%h got=%h",
                            frame,x,y,expected,read_pixel_rgb);
                    pixel_no = pixel_no + 1;
                    if (gaps && (x%11 == 5)) begin
                        @(negedge read_clk); read_pixel_en=0;
                        repeat(3) @(negedge read_clk);
                    end
                end
                if (gaps) begin
                    @(negedge read_clk); read_pixel_en=0;
                    repeat(17) @(negedge read_clk);
                end
            end
            @(negedge read_clk); read_pixel_en = 0;
            repeat(40) @(negedge read_clk);
            if (capture_count != WORDS) $fatal(1,"FIFO capture count mismatch");
            if (dut.read_underflow) $fatal(1,"read underflow during valid frame");
            if (dut.u_sdram.read_count-words_before != WORDS)
                $fatal(1,"read command count expected=%0d got=%0d",WORDS,dut.u_sdram.read_count-words_before);
            if (dut.u_unpack.bit_count != 0 || dut.u_unpack.pop_pending)
                $fatal(1,"frame tail has residual bits/pending read");
            $display("PIXEL_PASS frame=%0d pixels=%0d gaps=%0d",frame,pixel_no,gaps);
        end
    endtask
    initial begin
        repeat(10) @(negedge mem_clk);
        rst=0;
        write_frame(0);
        fork
            write_frame(1);
            read_frame(0,0);
        join
        read_frame(1,1);
        read_frame(0,1);
        if (dut.u_sdram.write_count != 2*WORDS) $fatal(1,"write count mismatch");
        $display("PASS tb_compact_frame_buffer width=%0d height=%0d flip=%0d dual frames, concurrent read/write, exact word/pixel data", WIDTH,HEIGHT,FLIP);
        $finish;
    end
    initial begin #200000000; $fatal(1,"integration timeout"); end
endmodule

// Application-side SDRAM contract model. The real encrypted controller and
// SDRAM electrical timing are outside this simulation's verification scope.
module sdram (
    input Clk, Clk_sft, Rst,
    output Sdr_init_done, Sdr_init_ref_vld, Sdr_busy,
    input App_wr_en, input [20:0] App_wr_addr,
    input [3:0] App_wr_dm, input [31:0] App_wr_din,
    input App_rd_en, input [20:0] App_rd_addr,
    output reg Sdr_rd_en = 0, output reg [31:0] Sdr_rd_dout = 0
);
    localparam CAPACITY = 2 * 640 * 480 * 3 / 4;
    reg [31:0] mem[0:CAPACITY-1];
    integer write_hits[0:CAPACITY-1];
    integer write_count=0, read_count=0, i;
    reg [10:0] rd_pending=0;
    reg [20:0] rd_addr[0:10];

    integer pipeline_index;
    assign Sdr_init_done=!Rst;
    assign Sdr_init_ref_vld=1'b0;
    assign Sdr_busy=1'b0;
    initial for(i=0;i<CAPACITY;i=i+1) write_hits[i]=0;
    always @(posedge Clk) begin
        if (Rst) begin
            rd_pending<=0; Sdr_rd_en<=0;
        end else begin
            if (App_wr_en && App_rd_en) $fatal(1,"simultaneous read/write commands");
            // Actual WRITE FIFO is show-ahead; data is valid at command edge.
            if(App_wr_en) begin
                if (App_wr_addr >= 2*tb_compact_frame_buffer.WORDS) $fatal(1,"write outside two frames");
                if (App_wr_dm != 0) $fatal(1,"unexpected partial-word write mask");
                mem[App_wr_addr] <= App_wr_din;
                write_hits[App_wr_addr] = write_hits[App_wr_addr]+1;
                write_count=write_count+1;
            end
            rd_pending <= {rd_pending[9:0],App_rd_en};
            rd_addr[0]<=App_rd_addr;
            for(pipeline_index=1;pipeline_index<11;pipeline_index=pipeline_index+1)
                rd_addr[pipeline_index]<=rd_addr[pipeline_index-1];
            if(App_rd_en) begin
                if(App_rd_addr >= 2*tb_compact_frame_buffer.WORDS) $fatal(1,"read outside two frames");
                read_count=read_count+1;
            end
            Sdr_rd_en<=rd_pending[9];
            if(rd_pending[9 + tb_compact_frame_buffer.DATA_LAG]) Sdr_rd_dout<=mem[rd_addr[9 + tb_compact_frame_buffer.DATA_LAG]];
            // Poison invalid cycles to expose boundary sampling mistakes.
            else Sdr_rd_dout<=32'hdeadbeef;
        end
    end
endmodule
