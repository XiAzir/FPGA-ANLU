`timescale 1ns/1ps
// C31 production frame_buffer_rgb888 + encrypted sdr_as_ram/wr_rd/init_ref
// + precompiled EG4_PHY_SDRAM_2M_32. No application-side SDRAM model.
module tb_real_sdram_frame_buffer;
    localparam WIDTH = 16;
    localparam HEIGHT = 64;
    localparam LINE_WORDS = WIDTH / 4 * 3;
    localparam WORDS = LINE_WORDS * HEIGHT;
    localparam PIXELS = WIDTH * HEIGHT;

    reg rst=1'b1;
    reg mem_clk=1'b0, mem_clk_shift=1'b0;
    reg write_clk=1'b0, read_clk=1'b0;
    always #10 mem_clk=~mem_clk;                 // 50 MHz
    initial begin #8; forever #10 mem_clk_shift=~mem_clk_shift; end // +8 ns, 144 degrees
    initial begin #2; forever #10 write_clk=~write_clk; end // 50 MHz
    always #20 read_clk=~read_clk;               // 25 MHz

    reg write_req=0, write_jpeg420=0, write_pixel_en=0;
    reg [1:0] write_frame_index=0;
    reg [23:0] write_pixel_rgb=0;
    wire write_req_ack, write_pixel_ready, write_finish;
    reg read_req=0, read_jpeg420=0, read_pixel_en=0;
    reg [1:0] read_frame_index=0;
    reg read_wipe_active=0;
    reg [8:0] read_wipe_rows=0;
    reg [1:0] read_wipe_new_index=0;
    wire read_req_ack;
    wire [15:0] debug_memory;
    wire [23:0] read_pixel_rgb;

    integer write_finishes=0;
    integer app_read_total=0, sdr_valid_total=0, capture_total=0;
    integer capture_word=0;
    integer read_frame_for_capture=0;
    integer wipe_for_capture=0, wipe_rows_for_capture=0, wipe_new_for_capture=0;
    integer first_read_command_time=-1, first_sdr_valid_time=-1;
    integer burst_command_count=0, burst_valid_count=0, burst_id=0;
    integer burst_last_issue_time=-1, burst_last_valid_time=-1;
    integer relation_samples=0;
    reg burst_open=0;

    frame_buffer_rgb888 #(
        .FRAME_WIDTH(WIDTH), .FRAME_HEIGHT(HEIGHT), .WRITE_V_FLIP(1),
        .SDR_READ_CAPTURE_DELAY(0), .SDR_READ_DATA_DELAY(1)
    ) dut (
        .rst(rst), .mem_clk(mem_clk), .mem_clk_shift(mem_clk_shift),
        .write_clk(write_clk), .write_req(write_req), .write_req_ack(write_req_ack),
        .write_frame_index(write_frame_index), .write_jpeg420(write_jpeg420),
        .write_pixel_en(write_pixel_en), .write_pixel_rgb(write_pixel_rgb),
        .write_pixel_ready(write_pixel_ready), .write_finish(write_finish),
        .read_clk(read_clk), .read_req(read_req), .read_req_ack(read_req_ack),
        .read_frame_index(read_frame_index), .read_jpeg420(read_jpeg420),
        .read_wipe_active(read_wipe_active), .read_wipe_rows(read_wipe_rows),
        .read_wipe_new_index(read_wipe_new_index), .read_pixel_en(read_pixel_en),
        .debug_memory(debug_memory), .read_pixel_rgb(read_pixel_rgb)
    );

    function [23:0] pattern;
        input integer frame, x, y;
        begin
            pattern[23:16]=(frame*83+x*7+y*3)&255;
            pattern[15:8]=(frame*31+x*11+y*13)&255;
            pattern[7:0]=(frame*127+x*17+y*23)&255;
        end
    endfunction

    function [31:0] expected_word;
        input integer frame, address;
        integer b, x, y, j;
        reg [23:0] rgb;
        begin
            expected_word=0;
            for(j=0;j<4;j=j+1) begin
                b=address*4+j;
                x=(b/3)%WIDTH;
                y=(b/3)/WIDTH;
                rgb=pattern(frame,x,HEIGHT-1-y);
                case(b%3)
                    0: expected_word[j*8 +: 8]=rgb[7:0];
                    1: expected_word[j*8 +: 8]=rgb[15:8];
                    2: expected_word[j*8 +: 8]=rgb[23:16];
                endcase
            end
        end
    endfunction

    always @(posedge mem_clk) begin
        if(rst) begin
            write_finishes=0;
            app_read_total=0; sdr_valid_total=0; capture_total=0;
            capture_word=0; first_read_command_time=-1; first_sdr_valid_time=-1;
            burst_command_count=0; burst_valid_count=0; burst_id=0;
            burst_last_issue_time=-1; burst_last_valid_time=-1; burst_open=0;
            relation_samples=0;
        end else begin
            if(write_finish) write_finishes=write_finishes+1;

            if(dut.app_read_en) begin
                app_read_total=app_read_total+1;
                if(first_read_command_time<0) first_read_command_time=$time;
                if(!burst_open && (dut.app_read_addr[7:0]==0)) begin
                    burst_open=1;
                    burst_id=burst_id+1;
                    burst_command_count=0;
                    burst_valid_count=0;
                    burst_last_issue_time=-1;
                    burst_last_valid_time=-1;
                end
                burst_command_count=burst_command_count+1;
                if(dut.app_read_addr[7:0]==255) begin
                    burst_last_issue_time=$time;
                    $display("BURST_ISSUE_END id=%0d addr=%0d t=%0t issued=%0d",burst_id,dut.app_read_addr,$time,burst_command_count);
                end
            end

            if(dut.mem_read_valid) begin
                sdr_valid_total=sdr_valid_total+1;
                if(first_sdr_valid_time<0) begin
                    first_sdr_valid_time=$time;
                    $display("READ_REL_FIRST app_t=%0t valid_t=%0t delta_ns=%0d app_addr=%0d data=%h",first_read_command_time,$time,$time-first_read_command_time,dut.app_read_addr,dut.mem_read_word);
                end
                if(burst_open) begin
                    burst_valid_count=burst_valid_count+1;
                    burst_last_valid_time=$time;
                    if(burst_valid_count==256) begin
                        $display("BURST_RETURN_END id=%0d cmds=%0d valids=%0d issue_tail_to_valid_tail_ns=%0d t=%0t",burst_id,burst_command_count,burst_valid_count,burst_last_valid_time-burst_last_issue_time,$time);
                        burst_open=0;
                    end
                end
                if(relation_samples<16) begin
                    $display("READ_REL_SAMPLE n=%0d app_en=%b app_addr=%0d sdr_valid=%b sdr_data=%h cap_valid=%b cap_data=%h busy=%b",relation_samples,dut.app_read_en,dut.app_read_addr,dut.mem_read_valid,dut.mem_read_word,dut.u_legacy_frame_backend.read_capture_valid,dut.u_legacy_frame_backend.read_capture_data,dut.mem_busy);
                    relation_samples=relation_samples+1;
                end
            end

            if(dut.u_legacy_frame_backend.read_capture_valid) begin
                if(capture_word>=WORDS) $fatal(1,"extra real-IP capture word=%0d",capture_word);
                begin : compare_capture
                    integer storage_row, expected_frame;
                    reg [31:0] expected;
                    storage_row=capture_word/LINE_WORDS;
                    expected_frame=read_frame_for_capture;
                    if(wipe_for_capture && storage_row<wipe_rows_for_capture)
                        expected_frame=wipe_new_for_capture;
                    expected=expected_word(expected_frame,capture_word);
                    if(dut.u_legacy_frame_backend.read_capture_data!==expected)
                        $fatal(1,"REAL_DUT_CAPTURE_MISMATCH frame=%0d wipe=%0d word=%0d row=%0d expected_frame=%0d expected=%h got=%h valid=%b data_delay=%0d",read_frame_for_capture,wipe_for_capture,capture_word,storage_row,expected_frame,expected,dut.u_legacy_frame_backend.read_capture_data,dut.u_legacy_frame_backend.read_capture_valid,1);
                end
                capture_word=capture_word+1;
                capture_total=capture_total+1;
            end
        end
    end

    task write_frame;
        input integer frame;
        integer x,y,old_finishes;
        begin
            old_finishes=write_finishes;
            @(negedge write_clk); write_frame_index=frame; write_req=1;
            wait(write_req_ack===1'b1);
            @(negedge write_clk); write_req=0;
            wait(dut.write_fifo_clear===1'b0);
            for(y=0;y<HEIGHT;y=y+1) begin
                for(x=0;x<WIDTH;x=x+1) begin
                    @(negedge write_clk);
                    while(write_pixel_ready!==1'b1) @(negedge write_clk);
                    write_pixel_rgb=pattern(frame,x,y);
                    write_pixel_en=1;
                    @(negedge write_clk); write_pixel_en=0;
                end
            end
            wait(write_finishes>old_finishes);
            $display("WRITE_DONE bank=%0d pixels=%0d words=%0d t=%0t busy=%b",frame,PIXELS,WORDS,$time,dut.mem_busy);
        end
    endtask

    task tick_read_cycles;
        input integer n;
        integer k;
        begin
            for(k=0;k<n;k=k+1) begin
                @(negedge read_clk);
                read_pixel_en=0;
            end
        end
    endtask

    task read_frame;
        input integer frame, use_wipe, rows, new_frame, continuous;
        integer x,y,cycle_no,pixels_before,captures_before;
        reg [23:0] expected;
        integer source_frame;
        begin
            pixels_before=0;
            captures_before=capture_total;
            capture_word=0;
            read_frame_for_capture=frame;
            wipe_for_capture=use_wipe;
            wipe_rows_for_capture=rows;
            wipe_new_for_capture=new_frame;
            @(negedge read_clk);
            read_frame_index=frame;
            read_wipe_active=use_wipe;
            read_wipe_rows=rows;
            read_wipe_new_index=new_frame;
            read_req=1;
            wait(read_req_ack===1'b1);
            @(negedge read_clk); read_req=0;
            wait(dut.read_fifo_clear===1'b0);

            // 45 vertical-blank lines. Standard cadence uses 16 active + 4
            // blank clocks (80% DE, matching 640/800); pressure mode removes
            // horizontal blanking and streams all active pixels continuously.
            if(continuous) tick_read_cycles(45*WIDTH);
            else tick_read_cycles(45*20);
            for(y=0;y<HEIGHT;y=y+1) begin
                for(cycle_no=0;cycle_no<(continuous ? WIDTH : 20);cycle_no=cycle_no+1) begin
                    @(negedge read_clk);
                    read_pixel_en=(cycle_no<WIDTH);
                    if(cycle_no<WIDTH) begin
                        x=cycle_no;
                        source_frame=frame;
                        if(use_wipe && y<rows) source_frame=new_frame;
                        expected=pattern(source_frame,x,HEIGHT-1-y);
                        @(posedge read_clk); #1;
                        if(read_pixel_rgb!==expected)
                            $fatal(1,"REAL_DUT_PIXEL_MISMATCH frame=%0d wipe=%0d x=%0d y=%0d expected=%h got=%h underflow=%b",frame,use_wipe,x,y,expected,read_pixel_rgb,dut.u_unpack.underflow);
                        pixels_before=pixels_before+1;
                    end else begin
                        @(posedge read_clk);
                    end
                end
            end
            @(negedge read_clk); read_pixel_en=0;
            repeat(40) @(negedge mem_clk);
            if(capture_word!=WORDS)
                $fatal(1,"CAPTURE_COUNT_MISMATCH frame=%0d expected=%0d got=%0d",frame,WORDS,capture_word);
            if(capture_total-captures_before!=WORDS)
                $fatal(1,"CAPTURE_TOTAL_MISMATCH frame=%0d expected=%0d got=%0d",frame,WORDS,capture_total-captures_before);
            if(dut.u_unpack.underflow)
                $fatal(1,"PIXEL_UNDERFLOW frame=%0d wipe=%0d",frame,use_wipe);
            if(dut.u_unpack.byte_count!=0 || dut.u_unpack.pop_pending)
                $fatal(1,"UNPACK_TAIL frame=%0d bytes=%0d pending=%b",frame,dut.u_unpack.byte_count,dut.u_unpack.pop_pending);
            $display("READ_DONE bank=%0d wipe=%0d rows=%0d new=%0d continuous=%0d pixels=%0d captures=%0d app_reads=%0d sdr_valids=%0d t=%0t busy=%b",frame,use_wipe,rows,new_frame,continuous,pixels_before,capture_total-captures_before,app_read_total,sdr_valid_total,$time,dut.mem_busy);
        end
    endtask

    initial begin
        repeat(12) @(negedge mem_clk);
        rst=0;
        wait(dut.init_done===1'b1);
        $display("SDRAM_INIT_DONE t=%0t clk_period_ns=20 shift_offset_ns=8 read_pixel_ns=40 model=EG_PHY_SDRAM_2M_32",$time);
        write_frame(0);
        fork
            write_frame(1);
            read_frame(0,0,0,0,0);
        join
        read_frame(1,0,0,0,0);
        read_frame(0,1,32,1,0);
        read_frame(0,0,0,0,1);
        $display("PASS REAL_SDRAM width=%0d height=%0d words_per_bank=%0d total_app_reads=%0d total_sdr_valid=%0d total_capture=%0d",WIDTH,HEIGHT,WORDS,app_read_total,sdr_valid_total,capture_total);
        $finish;
    end

    initial begin #20000000; $fatal(1,"REAL_SDRAM_TEST_TIMEOUT"); end
endmodule
