`timescale 1ns/1ps
module tb_native_yuv420_frame_buffer;
    localparam integer W=32,H=32,MCU_COLUMNS=2,MCU_ROWS=2;
    localparam integer Y_WORDS=256,C_WORDS=64,FRAME_WORDS=384,TOTAL_WORDS=768;
    reg mem_clk=0,pixel_clk=0;
    always #5 mem_clk=~mem_clk;
    initial begin #3; forever #15 pixel_clk=~pixel_clk; end
    reg mem_rst=1,pixel_rst=1,init_done=0,refresh_valid=0,sdr_busy=0;

    reg write_frame_start=0,write_frame_index=0,decode_idle=0;
    wire decode_block_space;
    reg native_valid=0;
    reg signed [31:0] native_sample=0;
    reg [5:0] native_index=0;
    reg [31:0] native_id=0;
    wire write_frame_done;

    reg read_frame_start_mem=0,read_frame_index=0,read_frame_start_pixel=0;
    reg [15:0] pixel_x=0,pixel_y=0;
    reg pixel_de=0;
    wire rgb_valid;
    wire [15:0] rgb_x,rgb_y;
    wire [23:0] rgb;
    wire pixel_underflow;
    wire [1:0] pixel_bank_ready;
    wire prefetch_frame_done;
    wire app_rd_en,app_wr_en;
    wire [20:0] app_rd_address,app_wr_address;
    wire [31:0] app_wr_data;
    wire [3:0] app_wr_mask;
    reg sdr_rd_valid=0;
    reg [31:0] sdr_rd_data=0;

    native_yuv420_frame_buffer #(
        .FRAME_WIDTH(W),.FRAME_HEIGHT(H),.ADDR_BITS(21),.SDR_READ_DATA_DELAY(1)
    ) dut(
        .mem_clk(mem_clk),.mem_rst(mem_rst),.pixel_clk(pixel_clk),.pixel_rst(pixel_rst),
        .init_done(init_done),.refresh_valid(refresh_valid),.sdr_busy(sdr_busy),
        .write_frame_start(write_frame_start),.write_frame_index(write_frame_index),
        .decode_idle(decode_idle),.decode_block_space(decode_block_space),
        .native_valid(native_valid),.native_sample(native_sample),.native_index(native_index),
        .native_id(native_id),.write_frame_done(write_frame_done),
        .read_frame_start_mem(read_frame_start_mem),.read_frame_index(read_frame_index),
        .read_frame_start_pixel(read_frame_start_pixel),.pixel_x(pixel_x),.pixel_y(pixel_y),
        .pixel_de(pixel_de),.rgb_valid(rgb_valid),.rgb_x(rgb_x),.rgb_y(rgb_y),.rgb(rgb),
        .pixel_underflow(pixel_underflow),.pixel_bank_ready(pixel_bank_ready),
        .prefetch_frame_done(prefetch_frame_done),.app_rd_en(app_rd_en),
        .app_rd_address(app_rd_address),.app_wr_en(app_wr_en),.app_wr_address(app_wr_address),
        .app_wr_data(app_wr_data),.app_wr_mask(app_wr_mask),
        .sdr_rd_valid(sdr_rd_valid),.sdr_rd_data(sdr_rd_data));

    reg [31:0] memory[0:TOTAL_WORDS-1];
    reg [TOTAL_WORDS-1:0] memory_valid=0;
    integer writes_per_frame[0:1];
    integer frame_done_count=0,prefetch_done_count=0;
    integer mem_cycle=0,write_busy_left=0,frame_done_pulses=0;
    integer read_queue[0:4095],read_due[0:4095];
    integer read_tail=0,read_lead_head=0,read_return_head=0;
    integer read_issue_count=0,read_return_count=0,read_command_word_index=0;
    integer write_burst_index=0,last_write_cycle=-1;
    integer input_frame=0,output_frame=0;
    integer rgb_count=0,underflow_count=0;
    integer frame0_rgb_count=0,frame1_first_write_at_rgb=-1,frame1_last_write_at_rgb=-1;
    integer response_gap=0,response_beats=0,response_gaps=0;
    reg response_data_lead=0;

    function integer centered_value;
        input integer frame,plane,sample_x,sample_y;
        begin centered_value=((sample_x*7+sample_y*11+frame*37+plane*53)%511)-255; end
    endfunction
    function [7:0] stored_byte;
        input integer frame,plane,sample_x,sample_y;
        integer q;
        begin
            q=centered_value(frame,plane,sample_x,sample_y)+128;
            if(q<0) stored_byte=0;
            else if(q>255) stored_byte=255;
            else stored_byte=q[7:0];
        end
    endfunction
    function [31:0] expected_word;
        input integer frame,local_address;
        integer mcu,block,word_in_block,sample_no,plane,sx,sy,mx,my,bx,by,lane;
        reg [31:0] word;
        begin
            word=0;
            if(local_address<Y_WORDS) begin
                plane=0;mcu=local_address/64;block=(local_address%64)/16;
                word_in_block=local_address%16;mx=mcu%MCU_COLUMNS;my=mcu/MCU_COLUMNS;
                bx=block%2;by=block/2;
                for(lane=0;lane<4;lane=lane+1) begin
                    sample_no=word_in_block*4+lane;
                    sx=mx*16+bx*8+(sample_no%8);
                    sy=my*16+by*8+(sample_no/8);
                    word[lane*8 +: 8]=stored_byte(frame,plane,sx,sy);
                end
            end else begin
                if(local_address<Y_WORDS+C_WORDS) begin
                    plane=1;mcu=(local_address-Y_WORDS)/16;word_in_block=(local_address-Y_WORDS)%16;
                end else begin
                    plane=2;mcu=(local_address-Y_WORDS-C_WORDS)/16;
                    word_in_block=(local_address-Y_WORDS-C_WORDS)%16;
                end
                mx=mcu%MCU_COLUMNS;my=mcu/MCU_COLUMNS;
                for(lane=0;lane<4;lane=lane+1) begin
                    sample_no=word_in_block*4+lane;
                    sx=mx*8+(sample_no%8);sy=my*8+(sample_no/8);
                    word[lane*8 +: 8]=stored_byte(frame,plane,sx,sy);
                end
            end
            expected_word=word;
        end
    endfunction
    function [31:0] read_memory_word;
        input [20:0] address;
        begin
            if(address>=TOTAL_WORDS || !memory_valid[address])
                read_memory_word=32'hxxxxxxxx;
            else
                read_memory_word=memory[address];
        end
    endfunction

    integer mx,my,block_id,plane,seq,idx,sx,sy,block_timeout;
    task automatic emit_block;
        input integer frame,block_plane,block_mx,block_my,block_id_in;
        integer seq_i,idx_i,sample_x,sample_y;
        reg [31:0] id_value;
        begin
            block_timeout=0;
            @(negedge mem_clk);
            while(!decode_block_space && block_timeout<200000) begin
                @(negedge mem_clk);block_timeout=block_timeout+1;
            end
            if(block_timeout>=200000) $fatal(1,"BLOCK_SPACE_TIMEOUT");
            if(block_id_in<0 || block_id_in>3) $fatal(1,"BAD_BLOCK_ID");
            id_value=(block_plane<<30)|(block_my<<17)|((block_id_in/2)<<16)|
                     (block_mx<<1)|(block_id_in%2);
            for(seq_i=0;seq_i<64;seq_i=seq_i+1) begin
                idx_i=((seq_i%8)*8)+(seq_i/8); // native IDCT index permutation {seq[2:0],seq[5:3]}
                if(block_plane==0) begin
                    sample_x=block_mx*16+(block_id_in%2)*8+(idx_i%8);
                    sample_y=block_my*16+(block_id_in/2)*8+(idx_i/8);
                end else begin
                    sample_x=block_mx*8+(idx_i%8);
                    sample_y=block_my*8+(idx_i/8);
                end
                native_valid=1;
                native_index=idx_i[5:0];
                native_id=id_value;
                native_sample=centered_value(frame,block_plane,sample_x,sample_y);
                @(negedge mem_clk);
            end
            native_valid=0;
        end
    endtask

    integer i;
    always @(posedge mem_clk) begin
        if(mem_rst) begin
            mem_cycle<=0;write_busy_left<=0;read_issue_count<=0;read_return_count<=0;
            read_command_word_index<=0;read_tail<=0;read_lead_head<=0;read_return_head<=0;
            write_burst_index<=0;last_write_cycle<=-1;frame_done_pulses<=0;prefetch_done_count<=0;
            writes_per_frame[0]<=0;writes_per_frame[1]<=0;
        end else begin
            mem_cycle<=mem_cycle+1;
            if(write_busy_left>0) write_busy_left<=write_busy_left-1;
            if(write_frame_done) begin
                frame_done_pulses<=frame_done_pulses+1;
                if(writes_per_frame[write_frame_index]!=FRAME_WORDS)
                    $fatal(1,"WRITE_DONE_EARLY frame=%0d words=%0d",
                           write_frame_index,writes_per_frame[write_frame_index]);
                $display("WD %0d %0d",write_frame_index,writes_per_frame[write_frame_index]);
            end
            if(prefetch_frame_done) prefetch_done_count<=prefetch_done_count+1;

            if(app_rd_en) begin
                if(app_wr_en) $fatal(1,"READ_WRITE_OVERLAP");
                $display("R %0d",app_rd_address);
                if(app_rd_address[1:0]!=0 && read_command_word_index==0)
                    $fatal(1,"UNALIGNED_BL4_ADDRESS %0d",app_rd_address);
                if(read_command_word_index>0 && app_rd_address!==read_queue[read_tail-1]+1)
                    $fatal(1,"BL4_READ_ADDRESS_GAP");
                read_queue[read_tail]=app_rd_address;
                read_due[read_tail]=mem_cycle+2+(read_issue_count%7);
                read_tail=read_tail+1;
                read_issue_count<=read_issue_count+1;
                read_command_word_index<=read_command_word_index+1;
                if(read_command_word_index==3) read_command_word_index<=0;
            end

            if(dut.read_valid) begin
                if(read_return_head>=read_tail) $fatal(1,"RETURN_WITHOUT_APP_RD");
                if(dut.read_data!==read_memory_word(read_queue[read_return_head]))
                    $fatal(1,"READ_RETURN_DATA_MISMATCH addr=%0d got=%08x exp=%08x",
                           read_queue[read_return_head],dut.read_data,read_memory_word(read_queue[read_return_head]));
                read_return_head=read_return_head+1;
                read_return_count<=read_return_count+1;
            end

            if(app_wr_en) begin
                if(app_rd_en) $fatal(1,"READ_WRITE_OVERLAP");
                if(read_return_count!=read_issue_count)
                    $fatal(1,"WRITE_BEFORE_READ_RETURNS pending=%0d",read_issue_count-read_return_count);
                if(app_wr_mask!=0) $fatal(1,"WRITE_MASK");
                if(app_wr_address>=TOTAL_WORDS) $fatal(1,"WRITE_ADDRESS_RANGE %0d",app_wr_address);
                if(memory_valid[app_wr_address]) $fatal(1,"DUPLICATE_WRITE_ADDRESS %0d",app_wr_address);
                if(app_wr_data!==expected_word(app_wr_address/FRAME_WORDS,app_wr_address%FRAME_WORDS))
                    $fatal(1,"NATIVE_REORDER_OR_BYTE_LANE_MISMATCH addr=%0d got=%08x expected=%08x",
                           app_wr_address,app_wr_data,expected_word(app_wr_address/FRAME_WORDS,app_wr_address%FRAME_WORDS));
                memory[app_wr_address]=app_wr_data;
                memory_valid[app_wr_address]=1'b1;
                writes_per_frame[app_wr_address/FRAME_WORDS]<=writes_per_frame[app_wr_address/FRAME_WORDS]+1;
                if(write_burst_index>0 && mem_cycle!=last_write_cycle+1)
                    $fatal(1,"WRITE_BLOCK_GAP word=%0d",write_burst_index);
                write_burst_index<=write_burst_index+1;
                last_write_cycle<=mem_cycle;
                write_busy_left<=3;
                $display("W %0d %08x",app_wr_address,app_wr_data);
                if(app_wr_address>=FRAME_WORDS && output_frame==0 && frame0_rgb_count>0) begin
                    if(frame1_first_write_at_rgb<0) frame1_first_write_at_rgb<=frame0_rgb_count;
                    frame1_last_write_at_rgb<=frame0_rgb_count;
                end
                if(write_burst_index==15) begin
                    write_burst_index<=0;
                    last_write_cycle<=-1;
                end
            end
        end
    end

    integer frame0_rgb_count_reg;
    always @(negedge mem_clk) begin
        if(mem_rst) begin
            sdr_rd_valid=0;sdr_rd_data=0;response_data_lead=0;
            read_lead_head=0;response_gap=0;response_beats=0;response_gaps=0;
            refresh_valid=0;sdr_busy=0;init_done=0;
        end else begin
            sdr_rd_valid=response_data_lead;
            response_data_lead=0;
            if(response_gap>0)
                response_gap=response_gap-1;
            else if(read_lead_head<read_tail && read_due[read_lead_head]<=mem_cycle) begin
                if(read_queue[read_lead_head]>=TOTAL_WORDS || !memory_valid[read_queue[read_lead_head]])
                    $fatal(1,"READ_UNINITIALIZED_ADDRESS %0d",read_queue[read_lead_head]);
                sdr_rd_data=memory[read_queue[read_lead_head]];
                read_lead_head=read_lead_head+1;
                response_data_lead=1;
                response_beats=response_beats+1;
                if(response_beats%3==2) begin
                    response_gap=1+(response_beats%2);
                    response_gaps=response_gaps+response_gap;
                end
            end
            refresh_valid=(mem_cycle%53>=48);
            sdr_busy=(mem_cycle%37>=33)||(write_busy_left>0);
            init_done=1;
        end
    end

    integer rgb_frame_count[0:1];
    always @(posedge pixel_clk) begin
        if(pixel_rst) begin
            rgb_count<=0;underflow_count<=0;rgb_frame_count[0]<=0;rgb_frame_count[1]<=0;
            frame0_rgb_count<=0;
        end else begin
            if(pixel_de && pixel_underflow) underflow_count<=underflow_count+1;
            if(rgb_valid) begin
                $display("RGB %0d %0d %0d %06x",output_frame,rgb_x,rgb_y,rgb);
                rgb_count<=rgb_count+1;
                rgb_frame_count[output_frame]<=rgb_frame_count[output_frame]+1;
                if(output_frame==0) frame0_rgb_count<=frame0_rgb_count+1;
            end
        end
    end

    task automatic write_frame;
        input integer frame;
        integer yy,xx,bb,timeout;
        begin
            decode_idle=0;write_frame_index=frame[0];
            @(negedge mem_clk);write_frame_start=1;
            @(negedge mem_clk);write_frame_start=0;
            for(yy=0;yy<MCU_ROWS;yy=yy+1)
                for(xx=0;xx<MCU_COLUMNS;xx=xx+1) begin
                    for(bb=0;bb<4;bb=bb+1) emit_block(frame,0,xx,yy,bb);
                    emit_block(frame,1,xx,yy,0);
                    emit_block(frame,2,xx,yy,0);
                end
            @(negedge mem_clk);native_valid=0;decode_idle=1;
            timeout=0;
            while(frame_done_pulses<frame+1 && timeout<300000) begin
                @(negedge mem_clk);timeout=timeout+1;
            end
            if(timeout>=300000) $fatal(1,"WRITE_DONE_TIMEOUT frame=%0d",frame);
        end
    endtask

    task automatic begin_read;
        input integer frame;
        begin
            output_frame=frame;read_frame_index=frame[0];
            @(negedge pixel_clk);read_frame_start_pixel=1;pixel_de=0;
            @(negedge pixel_clk);read_frame_start_pixel=0;
            repeat(2) @(posedge pixel_clk);
            @(negedge mem_clk);read_frame_start_mem=1;
            @(negedge mem_clk);read_frame_start_mem=0;
        end
    endtask

    task automatic wait_bank;
        input integer bank;
        integer timeout;
        begin
            timeout=0;
            while(!pixel_bank_ready[bank] && timeout<200000) begin
                @(posedge pixel_clk);timeout=timeout+1;
            end
            if(timeout>=200000) $fatal(1,"BANK_READY_TIMEOUT bank=%0d",bank);
        end
    endtask

    task automatic display_frame;
        integer g,x,y;
        begin
            for(g=0;g<H/4;g=g+1) begin
                wait_bank(g&1);
                for(y=g*4;y<g*4+4;y=y+1)
                    for(x=0;x<W;x=x+1) begin
                        @(negedge pixel_clk);pixel_x=x;pixel_y=y;pixel_de=1;
                    end
                @(negedge pixel_clk);pixel_de=0;
            end
            repeat(10) @(posedge pixel_clk);
        end
    endtask

    integer timeout;
    initial begin
        repeat(5) @(negedge mem_clk);mem_rst=0;
        @(negedge pixel_clk);pixel_rst=0;

        write_frame(0);
        if(writes_per_frame[0]!=FRAME_WORDS || frame_done_pulses!=1)
            $fatal(1,"FRAME0_WRITE_COMPLETE words=%0d done=%0d",writes_per_frame[0],frame_done_pulses);

        begin_read(0);
        wait_bank(0);
        fork
            display_frame();
            write_frame(1);
        join
        if(writes_per_frame[1]!=FRAME_WORDS || frame_done_pulses!=2)
            $fatal(1,"FRAME1_WRITE_COMPLETE words=%0d done=%0d",writes_per_frame[1],frame_done_pulses);
        if(frame1_first_write_at_rgb<=0 || frame1_last_write_at_rgb>=W*H)
            $fatal(1,"FRAME1_WRITE_NOT_CONCURRENT first=%0d last=%0d",
                   frame1_first_write_at_rgb,frame1_last_write_at_rgb);
        if(prefetch_done_count!=1) $fatal(1,"FRAME0_PREFETCH_DONE=%0d",prefetch_done_count);

        repeat(8) @(negedge mem_clk);
        begin_read(1);
        display_frame();
        timeout=0;
        while(prefetch_done_count<2 && timeout<200000) begin
            @(negedge mem_clk);timeout=timeout+1;
        end
        repeat(8) @(posedge pixel_clk);
        if(prefetch_done_count!=2) $fatal(1,"PREFETCH_DONE=%0d",prefetch_done_count);
        if(rgb_count!=2*W*H || rgb_frame_count[0]!=W*H || rgb_frame_count[1]!=W*H)
            $fatal(1,"RGB_COUNTS total=%0d f0=%0d f1=%0d",rgb_count,rgb_frame_count[0],rgb_frame_count[1]);
        if(underflow_count!=0) $fatal(1,"UNDERFLOW=%0d",underflow_count);
        if(read_issue_count!=768 || read_return_count!=768)
            $fatal(1,"READ_COUNTS issue=%0d return=%0d",read_issue_count,read_return_count);
        if(response_beats!=768 || response_gaps==0) $fatal(1,"RESPONSE_MODEL beats=%0d gaps=%0d",response_beats,response_gaps);
        if(write_burst_index!=0 || writes_per_frame[0]!=FRAME_WORDS || writes_per_frame[1]!=FRAME_WORDS)
            $fatal(1,"WRITE_TOTALS f0=%0d f1=%0d burst=%0d",writes_per_frame[0],writes_per_frame[1],write_burst_index);
        for(i=0;i<TOTAL_WORDS;i=i+1)
            if(!memory_valid[i]) $fatal(1,"MISSING_FRAME_WORD %0d",i);
        $display("DONE rgb=%0d f0=%0d f1=%0d underflow=%0d writes=%0d/%0d reads=%0d returns=%0d done=%0d prefetch=%0d overlap=%0d-%0d gaps=%0d",
                 rgb_count,rgb_frame_count[0],rgb_frame_count[1],underflow_count,
                 writes_per_frame[0],writes_per_frame[1],read_issue_count,read_return_count,
                 frame_done_pulses,prefetch_done_count,frame1_first_write_at_rgb,
                 frame1_last_write_at_rgb,response_gaps);
        $finish;
    end
    initial begin #50000000;$fatal(1,"GLOBAL_TIMEOUT");end
endmodule
