`timescale 1ns/1ps
module tb_yuv_scan_arbiter;
    localparam integer W=32, H=32, MCU_COUNT=4;
    localparam integer Y_WORDS=MCU_COUNT*64, C_WORDS=MCU_COUNT*16;
    localparam integer FRAME_WORDS=Y_WORDS+2*C_WORDS;
    reg clk=0,pixel_clk=0;
    always #5 clk=~clk;
    initial begin #3; forever #15 pixel_clk=~pixel_clk; end
    reg rst=1,pixel_rst=1,init_done=0,refresh_valid=0,sdr_busy=0;

    reg frame_start_mem=0,frame_start_pixel=0;
    reg [20:0] frame_base=0;
    wire scan_cmd_valid,scan_cmd_ready;
    wire [20:0] scan_cmd_addr;
    wire scan_rd_valid;
    wire [31:0] scan_rd_data;
    wire scan_frame_done;
    reg [15:0] in_x=0,in_y=0;
    reg in_de=0;
    wire [15:0] out_x,out_y;
    wire out_de,out_bank_ready,underflow;
    wire [7:0] out_y_sample,out_cb_sample,out_cr_sample;
    wire [1:0] bank_ready;

    wire rd_cmd_ready,rd_valid,wr_ready,arb_idle;
    wire [31:0] rd_data;
    wire app_rd_en,app_wr_en;
    wire [20:0] app_rd_address,app_wr_address;
    wire [31:0] app_wr_data;
    wire [3:0] app_wr_mask;
    reg sdr_rd_valid=0;
    reg [31:0] sdr_rd_data=0;
    assign scan_cmd_ready=rd_cmd_ready;
    assign scan_rd_valid=rd_valid;
    assign scan_rd_data=rd_data;

    integer writer_enable=0,write_count=0;
    wire wr_valid=writer_enable && write_count<16;
    wire [20:0] wr_address=FRAME_WORDS+write_count;
    wire [31:0] wr_data=writer_word(write_count);

    yuv420_scan_cache #(.FRAME_WIDTH(W),.FRAME_HEIGHT(H),.ADDR_BITS(21)) scan_cache(
        .mem_clk(clk),.mem_rst(rst),.frame_start_mem(frame_start_mem),
        .frame_base_word(frame_base),.rd_cmd_valid(scan_cmd_valid),
        .rd_cmd_ready(scan_cmd_ready),.rd_cmd_addr(scan_cmd_addr),
        .rd_valid(scan_rd_valid),.rd_data(scan_rd_data),.frame_done_mem(scan_frame_done),
        .pixel_clk(pixel_clk),.pixel_rst(pixel_rst),.frame_start_pixel(frame_start_pixel),
        .in_pixel_x(in_x),.in_pixel_y(in_y),.in_pixel_de(in_de),
        .out_pixel_x(out_x),.out_pixel_y(out_y),.out_pixel_de(out_de),
        .out_y(out_y_sample),.out_cb(out_cb_sample),.out_cr(out_cr_sample),
        .out_bank_ready(out_bank_ready),.pixel_bank_ready(bank_ready),.pixel_underflow(underflow));

    yuv_sdram_burst_arbiter #(.ADDR_BITS(21),.SDR_READ_DATA_DELAY(1)) arbiter(
        .clk(clk),.rst(rst),.init_done(init_done),.refresh_valid(refresh_valid),.sdr_busy(sdr_busy),
        .rd_cmd_valid(scan_cmd_valid),.rd_cmd_ready(rd_cmd_ready),.rd_cmd_address(scan_cmd_addr),
        .rd_valid(rd_valid),.rd_data(rd_data),.wr_valid(wr_valid),.wr_ready(wr_ready),
        .wr_address(wr_address),.wr_data(wr_data),.idle(arb_idle),
        .app_rd_en(app_rd_en),.app_rd_address(app_rd_address),
        .app_wr_en(app_wr_en),.app_wr_address(app_wr_address),.app_wr_data(app_wr_data),
        .app_wr_mask(app_wr_mask),.sdr_rd_valid(sdr_rd_valid),.sdr_rd_data(sdr_rd_data));

    reg [31:0] override_data [0:15];
    reg [15:0] override_valid=0;
    integer cycle=0,write_busy_left=0;
    integer queue_addr [0:2047];
    integer queue_due [0:2047];
    integer tail=0,response_head=0,return_head=0;
    integer issued_words=0,returned_words=0,read_commands=0;
    integer gate_wait_cycles=0,refresh_wait_cycles=0,busy_wait_cycles=0;
    integer issue_in_command=0,read_base=0,last_read_cycle=-1;
    integer command_pending=0;
    integer response_gap=0,response_beats_scheduled=0;
    integer response_gaps_inserted=0;
    reg data_lead_pending=0;
    integer writes_in_block=0,last_write_cycle=-1;
    reg held_scan_cmd=0;
    reg [20:0] held_scan_addr=0;
    integer frame_done_count=0,pixel_count=0,underflow_count=0;
    integer frame0_pixels_at_first_write=-1;
    integer frame_tag=0;

    function [31:0] writer_word;
        input integer index;
        begin writer_word=32'hA5000000 ^ (index*32'h0103070B);end
    endfunction

    function [31:0] memory_word;
        input [20:0] address;
        integer lane,byte_addr,index;
        reg [7:0] value;
        begin
            if(address>=FRAME_WORDS && address<FRAME_WORDS+16 && override_valid[address-FRAME_WORDS])
                memory_word=override_data[address-FRAME_WORDS];
            else begin
                memory_word=32'd0;
                for(lane=0;lane<4;lane=lane+1) begin
                    byte_addr=address*4+lane;
                    value=(byte_addr*37+11)&255;
                    memory_word[lane*8 +: 8]=value;
                end
            end
        end
    endfunction

    always @(posedge clk) begin
        if(rst) begin
            cycle<=0;write_busy_left<=0;
            issued_words<=0;returned_words<=0;read_commands<=0;
            gate_wait_cycles<=0;refresh_wait_cycles<=0;busy_wait_cycles<=0;
            issue_in_command<=0;read_base<=0;command_pending<=0;
            last_read_cycle<=-1;held_scan_cmd<=0;held_scan_addr<=0;
            writes_in_block<=0;last_write_cycle<=-1;
            frame_done_count<=0;
        end else begin
            cycle<=cycle+1;
            if(write_busy_left>0) write_busy_left<=write_busy_left-1;
            if(scan_frame_done) frame_done_count<=frame_done_count+1;

            if(held_scan_cmd && (!scan_cmd_valid || scan_cmd_addr !== held_scan_addr))
                $fatal(1,"SCAN_COMMAND_CHANGED_WHILE_NOT_READY");
            held_scan_cmd<=scan_cmd_valid && !rd_cmd_ready;
            if(scan_cmd_valid && !rd_cmd_ready) held_scan_addr<=scan_cmd_addr;

            if(scan_cmd_valid && rd_cmd_ready) begin
                if(command_pending!=0 || (read_commands!=0 && issue_in_command!=4))
                    $fatal(1,"READ_COMMAND_BEFORE_4_RETURNS pending=%0d issued=%0d",command_pending,issue_in_command);
                $display("CMD %0d %0d",frame_tag,scan_cmd_addr);
                read_commands<=read_commands+1;
                command_pending<=4;
                issue_in_command<=0;
                read_base<=scan_cmd_addr;
            end

            if(app_rd_en) begin
                if(app_wr_en) $fatal(1,"READ_WRITE_OVERLAP");
                if(issue_in_command>=4) $fatal(1,"MORE_THAN_4_READ_ISSUES");
                if(issue_in_command>0 && cycle!=last_read_cycle+1)
                    $fatal(1,"BL4_READ_REQUEST_GAP");
                if(app_rd_address !== read_base+issue_in_command)
                    $fatal(1,"READ_ADDR expected=%0d got=%0d",read_base+issue_in_command,app_rd_address);
                if(issue_in_command>0 && app_rd_address !== queue_addr[tail-1]+1)
                    $fatal(1,"BL4 requests were not consecutive");
                queue_addr[tail]=app_rd_address;
                queue_due[tail]=cycle+2+(issued_words%7);
                tail=tail+1;
                issued_words<=issued_words+1;
                issue_in_command<=issue_in_command+1;
                last_read_cycle<=cycle;
            end

            if(rd_valid) begin
                if(return_head>=tail) $fatal(1,"UNREQUESTED_READ_RETURN");
                if(rd_data !== memory_word(queue_addr[return_head]))
                    $fatal(1,"READ_DATA_DELAY_OR_ORDER expected=%08x got=%08x address=%0d",
                           memory_word(queue_addr[return_head]),rd_data,queue_addr[return_head]);
                return_head=return_head+1;
                returned_words<=returned_words+1;
                if(command_pending<=0) $fatal(1,"RETURN_WITHOUT_PENDING_COMMAND");
                command_pending<=command_pending-1;
            end

            if(app_wr_en) begin
                if(app_rd_en) $fatal(1,"READ_WRITE_OVERLAP");
                if(returned_words != issued_words)
                    $fatal(1,"WRITE_BEFORE_READ_RETURNS pending=%0d",issued_words-returned_words);
                if(app_wr_mask!=0) $fatal(1,"WRITE_MASK");
                if(app_wr_address !== FRAME_WORDS+write_count || app_wr_data !== writer_word(write_count))
                    $fatal(1,"WRITE_DATA expected_addr=%0d got_addr=%0d",FRAME_WORDS+write_count,app_wr_address);
                if(writes_in_block>0 && cycle!=last_write_cycle+1)
                    $fatal(1,"WRITE_BLOCK_GAP index=%0d",writes_in_block);
                if(write_count>=16) $fatal(1,"EXTRA_WRITE");
                override_data[write_count]=app_wr_data;
                override_valid[write_count]=1'b1;
                write_count<=write_count+1;
                writes_in_block<=writes_in_block+1;
                last_write_cycle<=cycle;
                write_busy_left<=3;
                if(frame0_pixels_at_first_write<0 && pixel_count>0)
                    frame0_pixels_at_first_write<=pixel_count;
                if(writes_in_block==15) begin
                    writes_in_block<=0;
                    last_write_cycle<=-1;
                end
            end

            if((refresh_valid || sdr_busy) && (scan_cmd_valid || wr_valid) &&
               !rd_cmd_ready && !wr_ready) gate_wait_cycles<=gate_wait_cycles+1;
            if(refresh_valid && (scan_cmd_valid || wr_valid) && !rd_cmd_ready && !wr_ready)
                refresh_wait_cycles<=refresh_wait_cycles+1;
            if(sdr_busy && (scan_cmd_valid || wr_valid) && !rd_cmd_ready && !wr_ready)
                busy_wait_cycles<=busy_wait_cycles+1;
        end
    end

    // The APUG011 model accepts all four consecutive app_rd_en requests, then
    // returns words in order with variable latency and gaps. Data is driven a
    // full mem_clk before sdr_rd_valid to model DATA_DELAY=1.
    always @(negedge clk) begin
        if(rst) begin
            sdr_rd_valid=0;sdr_rd_data=0;data_lead_pending=0;
            response_head=0;response_gap=0;response_beats_scheduled=0;response_gaps_inserted=0;
            refresh_valid=0;sdr_busy=0;
        end else begin
            sdr_rd_valid=data_lead_pending;
            data_lead_pending=0;
            if(response_gap>0)
                response_gap=response_gap-1;
            else if(response_head<tail && queue_due[response_head]<=cycle) begin
                sdr_rd_data=memory_word(queue_addr[response_head]);
                response_head=response_head+1;
                data_lead_pending=1;
                response_beats_scheduled=response_beats_scheduled+1;
                if(response_beats_scheduled%3==2)
                begin
                    response_gap=1+(response_beats_scheduled%2);
                    response_gaps_inserted=response_gaps_inserted+response_gap;
                end
            end
            refresh_valid=(cycle%53>=48);
            sdr_busy=(cycle%37>=33) || (write_busy_left>0);
        end
    end

    always @(negedge clk) begin
        if(rst) begin
            init_done=0;writer_enable=0;
        end else begin
            init_done=1;
            if(returned_words>=8 && frame0_pixels_at_first_write<0)
                writer_enable=1;
        end
    end

    always @(posedge pixel_clk) begin
        if(!pixel_rst && out_de) begin
            $display("PIX %0d %0d %0d %0d %0d %0d %0d %0d",
                     frame_tag,out_x,out_y,out_y_sample,out_cb_sample,out_cr_sample,
                     out_bank_ready,underflow);
            pixel_count<=pixel_count+1;
            if(underflow) underflow_count<=underflow_count+1;
        end
    end

    task automatic begin_frame;
        input integer tag;
        input integer base;
        begin
            frame_tag=tag;
            @(negedge pixel_clk);frame_start_pixel=1;in_de=0;
            @(negedge pixel_clk);frame_start_pixel=0;
            repeat(2) @(posedge pixel_clk);
            @(negedge clk);frame_base=base;frame_start_mem=1;
            @(negedge clk);frame_start_mem=0;
        end
    endtask

    task automatic wait_bank;
        input integer bank;
        integer timeout;
        begin
            timeout=0;
            while(!bank_ready[bank] && timeout<100000) begin
                @(posedge pixel_clk);timeout=timeout+1;
            end
            if(timeout>=100000) $fatal(1,"BANK_TIMEOUT bank=%0d",bank);
        end
    endtask

    task automatic scan_frame;
        integer g,x,y;
        begin
            for(g=0;g<H/4;g=g+1) begin
                wait_bank(g&1);
                for(y=g*4;y<g*4+4;y=y+1)
                    for(x=0;x<W;x=x+1) begin
                        @(negedge pixel_clk);in_x=x;in_y=y;in_de=1;
                    end
                @(negedge pixel_clk);in_de=0;
            end
            repeat(3) @(posedge pixel_clk);
        end
    endtask

    initial begin
        repeat(5) @(negedge clk);rst=0;
        @(negedge pixel_clk);pixel_rst=0;
        begin_frame(0,0);
        scan_frame();
        wait(write_count==16);
        wait(frame_done_count==1);
        repeat(6) @(posedge clk);
        if(!arb_idle) $fatal(1,"ARB_NOT_IDLE_BEFORE_FRAME_SWITCH");
        if(frame0_pixels_at_first_write<=0 || frame0_pixels_at_first_write>=W*H)
            $fatal(1,"BACKGROUND_WRITE_NOT_INTERLEAVED_WITH_FRAME0 pixels_at_write=%0d",frame0_pixels_at_first_write);
        if(returned_words!=issued_words || command_pending!=0)
            $fatal(1,"FRAME0_READS_NOT_DRAINED");

        begin_frame(1,FRAME_WORDS);
        scan_frame();
        wait(frame_done_count==2);
        repeat(6) @(posedge clk);
        if(!arb_idle) $fatal(1,"ARB_NOT_IDLE_AT_END");
        if(read_commands!=192 || issued_words!=768 || returned_words!=768)
            $fatal(1,"READ_COUNTS cmds=%0d issued=%0d returned=%0d",read_commands,issued_words,returned_words);
        if(write_count!=16) $fatal(1,"WRITE_COUNT=%0d",write_count);
        if(pixel_count!=2*W*H) $fatal(1,"PIXELS=%0d expected=%0d",pixel_count,2*W*H);
        if(underflow_count!=0) $fatal(1,"UNDERFLOWS=%0d",underflow_count);
        if(gate_wait_cycles==0 || refresh_wait_cycles==0 || busy_wait_cycles==0)
            $fatal(1,"PAUSE_COVERAGE gate=%0d refresh=%0d busy=%0d",gate_wait_cycles,refresh_wait_cycles,busy_wait_cycles);
        if(response_gaps_inserted==0 || response_beats_scheduled!=768)
            $fatal(1,"RETURN_GAP_COVERAGE gaps=%0d beats=%0d",response_gaps_inserted,response_beats_scheduled);
        $display("DONE reads=%0d words=%0d returns=%0d writes=%0d pixels=%0d underflows=%0d write_pixel=%0d gate_wait=%0d refresh_wait=%0d busy_wait=%0d return_gaps=%0d",
                 read_commands,issued_words,returned_words,write_count,pixel_count,underflow_count,
                 frame0_pixels_at_first_write,gate_wait_cycles,refresh_wait_cycles,busy_wait_cycles,
                 response_gaps_inserted);
        $finish;
    end
    initial begin #20000000; $fatal(1,"GLOBAL_TIMEOUT"); end
endmodule
