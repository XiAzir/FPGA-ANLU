`timescale 1ns/1ps
`include "config.vh"

// End-to-end catalog/mapper/BMP/frame-buffer integration. Only the SD card
// sector source and encrypted SDRAM controller/device are application models.
module tb_fat_frame_integration;
    parameter WIDTH = 16;
    parameter HEIGHT = 64;
    parameter CARD_BYTE_CYCLES = 32;
    parameter FRAME_COUNT = 2;
    parameter FRAME_WORDS = (WIDTH/4)*3*HEIGHT;
    localparam PIXELS = WIDTH * HEIGHT;
    localparam LINE_WORDS = (WIDTH/4)*3;

    reg clk=0, read_clk=0;
    always #10 clk=~clk;
    always #20 read_clk=~read_clk;
    reg rst=1, init_done=0, key_next=1, key_auto=1;

    wire fs_ready, fs_error, wav_found;
    wire [7:0] fs_code;
    wire [31:0] fat_lba, data_lba, cluster_count, wav_cluster, wav_size;
    wire [3:0] cluster_shift;
    wire [2:0] bmp_count;
    wire [127:0] bmp_clusters, bmp_sizes;
    wire mount_read;
    wire [31:0] mount_addr;
    wire bmp_phy_read;
    wire [31:0] bmp_phy_addr;
    wire [7:0] bmp_phy_data;
    wire bmp_phy_valid, bmp_phy_end;
    wire bmp_read;
    wire [31:0] bmp_addr;
    wire [7:0] bmp_data;
    wire bmp_valid, bmp_end, bmp_map_error;
    wire [7:0] bmp_map_code;
    wire [31:0] bmp_cluster, bmp_size;

    wire write_req, write_req_ack, write_en;
    wire [23:0] write_data;
    wire [1:0] write_buf, disp_buf;
    wire display_valid, bmp_error;
    wire [3:0] bmp_state;
    wire write_finish;
    reg write_finish_toggle=0;

    reg [7:0] card_data=0;
    reg card_valid=0, card_end=0;
    wire card_read;
    wire [31:0] card_addr;

    assign card_read = fs_ready ? bmp_phy_read : mount_read;
    assign card_addr = fs_ready ? bmp_phy_addr : mount_addr;
    assign bmp_phy_data = card_data;
    assign bmp_phy_valid = fs_ready && card_valid;
    assign bmp_phy_end = fs_ready && card_end;

    fat32_catalog u_cat (
        .clk(clk), .rst(rst), .sd_init_done(init_done),
        .sd_read(mount_read), .sd_addr(mount_addr), .sd_data(card_data),
        .sd_valid(!fs_ready && card_valid), .sd_end(!fs_ready && card_end),
        .ready(fs_ready), .error(fs_error), .error_code(fs_code),
        .fat_lba(fat_lba), .data_lba(data_lba), .cluster_count(cluster_count),
        .sectors_per_cluster_shift(cluster_shift), .bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters), .bmp_sizes(bmp_sizes),
        .wav_found(wav_found), .wav_cluster(wav_cluster), .wav_size(wav_size)
    );

    tf_bmp_file_player #(
        .CLK_FREQ_HZ(20000), .FRAME_WIDTH(WIDTH), .FRAME_HEIGHT(HEIGHT),
        .WAIT_LIMIT(1000000)
    ) u_bmp (
        .clk(clk), .rst(rst), .key_next(key_next), .key_auto(key_auto),
        .catalog_ready(fs_ready), .bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters), .bmp_sizes(bmp_sizes),
        .file_cluster(bmp_cluster), .file_size(bmp_size),
        .card_read(bmp_read), .card_addr(bmp_addr), .card_data(bmp_data),
        .card_valid(bmp_valid), .card_end(bmp_end), .file_error(bmp_map_error),
        .write_finish_toggle(write_finish_toggle),
        .write_buf_idx(write_buf), .disp_buf_idx(disp_buf),
        .write_req(write_req), .write_req_ack(write_req_ack),
        .write_en(write_en), .write_data(write_data),
        .display_valid(display_valid), .error(bmp_error), .state_code(bmp_state)
    );

    fat32_file_sector u_bmp_map (
        .clk(clk), .rst(rst), .enable(fs_ready),
        .fat_lba(fat_lba), .data_lba(data_lba), .cluster_count(cluster_count),
        .sectors_per_cluster_shift(cluster_shift), .start_cluster(bmp_cluster),
        .file_size(bmp_size), .file_read(bmp_read), .file_sector(bmp_addr),
        .file_data(bmp_data), .file_valid(bmp_valid), .file_end(bmp_end),
        .error(bmp_map_error), .error_code(bmp_map_code),
        .sd_read(bmp_phy_read), .sd_addr(bmp_phy_addr), .sd_data(bmp_phy_data),
        .sd_valid(bmp_phy_valid), .sd_end(bmp_phy_end)
    );

    reg read_req=0;
    wire read_req_ack;
    reg read_pixel_en=0;
    reg [1:0] read_buf=0;
    wire [23:0] read_pixel_rgb;
    frame_buffer_rgb888 #(
        .FRAME_WIDTH(WIDTH), .FRAME_HEIGHT(HEIGHT), .WRITE_V_FLIP(1),
        .SDR_READ_CAPTURE_DELAY(0), .SDR_READ_DATA_DELAY(1)
    ) u_frame (
        .rst(rst), .mem_clk(clk), .mem_clk_shift(clk),
        .write_clk(clk), .write_req(write_req), .write_req_ack(write_req_ack),
        .write_frame_index(write_buf), .write_pixel_en(write_en),
        .write_pixel_rgb(write_data), .write_finish(write_finish),
        .read_clk(read_clk), .read_req(read_req), .read_req_ack(read_req_ack),
        .read_frame_index(read_buf), .read_pixel_en(read_pixel_en),
        .read_pixel_rgb(read_pixel_rgb)
    );

    reg [31:0] lbas [0:`FIXTURE_SECTORS-1];
    reg [7:0] sector_mem [0:`FIXTURE_SECTORS*512-1];
    reg [23:0] expected_pixels [0:PIXELS*2-1];
    reg [1023:0] fixture;
    integer active=0, slot=0, pos=0, gap=0, tick=0, i, found;
    integer card_transactions=0;
    integer write_count=0, frame_pixels=0, frame_finishes=0;
    integer buffer_for_frame[0:1];
    integer cycles=0;
    reg previous_write_req=0;
    reg read_request_active=0;
    reg [1:0] read_buf_lock=0;

    integer a, f, p, bx, by, got_count;
    reg [31:0] exp_word;

    function [31:0] expected_word;
        input integer image;
        input integer address;
        integer j, source_y, word_x, byte_index, pixel_index;
        reg [23:0] rgb;
        begin
            expected_word=0;
            source_y=HEIGHT-1-(address/LINE_WORDS);
            word_x=address%LINE_WORDS;
            for(j=0;j<4;j=j+1) begin
                byte_index=word_x*4+j;
                pixel_index=image*PIXELS+source_y*WIDTH+(byte_index/3);
                rgb=expected_pixels[pixel_index];
                case(byte_index%3)
                    0: expected_word[j*8 +: 8]=rgb[7:0];
                    1: expected_word[j*8 +: 8]=rgb[15:8];
                    2: expected_word[j*8 +: 8]=rgb[23:16];
                endcase
            end
        end
    endfunction

    task verify_memory;
        input integer image;
        input integer buffer_index;
        integer word_index, base, other_base;
        reg [31:0] expected;
        begin
            base=buffer_index*FRAME_WORDS;
            other_base=(1-buffer_index)*FRAME_WORDS;
            for(word_index=0;word_index<FRAME_WORDS;word_index=word_index+1) begin
                expected=expected_word(image,word_index);
                if(u_frame.u_sdram.mem[base+word_index] !== expected)
                    $fatal(1,"SDRAM mismatch image=%0d buffer=%0d word=%0d expected=%h got=%h",
                        image,buffer_index,word_index,expected,u_frame.u_sdram.mem[base+word_index]);
                if(u_frame.u_sdram.write_hits[base+word_index] != 1)
                    $fatal(1,"SDRAM address missing/duplicate image=%0d buffer=%0d word=%0d hits=%0d",
                        image,buffer_index,word_index,u_frame.u_sdram.write_hits[base+word_index]);
                if(image==0 && buffer_index==0 &&
                   (u_frame.u_sdram.mem[other_base+word_index] !== 32'hdeadbeef ||
                    u_frame.u_sdram.write_hits[other_base+word_index] != 0))
                    $fatal(1,"write escaped into the inactive frame at word %0d",word_index);
            end
            $display("SDRAM_FRAME_PASS image=%0d buffer=%0d words=%0d vertical_flip=exact",image,buffer_index,FRAME_WORDS);
        end
    endtask

    task read_back_frame;
        input integer image;
        input integer buffer_index;
        integer x, y, index, timeout;
        reg [23:0] expected;
        begin
            @(negedge read_clk);
            read_buf=buffer_index;
            read_buf_lock=buffer_index;
            read_request_active=1;
            read_req=1;
            timeout=0;
            while(!read_req_ack && timeout<2000) begin @(negedge read_clk); timeout=timeout+1; end
            if(!read_req_ack) $fatal(1,"frame read request was not acknowledged");
            // Keep index and request stable through acknowledgement, then release.
            @(negedge read_clk); read_req=0; read_request_active=0;
            wait(!u_frame.u_legacy_frame_backend.read_fifo_clear);
            repeat(700) @(negedge read_clk);
            index=0;
            for(y=0;y<HEIGHT;y=y+1) begin
                for(x=0;x<WIDTH;x=x+1) begin
                    @(negedge read_clk); read_pixel_en=1;
                    @(posedge read_clk); #1;
                    expected=expected_pixels[image*PIXELS+(HEIGHT-1-y)*WIDTH+x];
                    if(read_pixel_rgb !== expected)
                        $fatal(1,"frame readback mismatch image=%0d x=%0d y=%0d expected=%h got=%h",
                            image,x,y,expected,read_pixel_rgb);
                    index=index+1;
                end
            end
            @(negedge read_clk); read_pixel_en=0;
            repeat(40) @(negedge read_clk);
            if(u_frame.u_unpack.underflow) $fatal(1,"frame readback underflow");
            $display("FRAME_READBACK_PASS image=%0d buffer=%0d pixels=%0d",image,buffer_index,index);
        end
    endtask

    initial begin
        if(!$value$plusargs("FIXTURE=%s",fixture)) $fatal(1,"Need FIXTURE directory");
        $readmemh({fixture,"/lbas.hex"},lbas);
        $readmemh({fixture,"/sectors.hex"},sector_mem);
        $readmemh({fixture,"/pixels.hex"},expected_pixels);
        repeat(8) @(negedge clk); rst=0;
        repeat(4) @(negedge clk); init_done=1;
        wait(fs_ready);
        if(fs_error || bmp_count!=2 || !wav_found) $fatal(1,"catalog fixture mismatch");
        wait(display_valid);
        repeat(4) @(negedge clk);
        if(frame_finishes!=1 || buffer_for_frame[0]!=0 || disp_buf!=0)
            $fatal(1,"first frame did not use/commit buffer 0");
        verify_memory(0,0);
        if(write_count!=PIXELS || frame_pixels!=0) $fatal(1,"first source pixel count mismatch");
        read_back_frame(0,0);

        if(FRAME_COUNT>1) begin
            // Use the real debouncer to request the second catalog BMP.
            @(negedge clk); key_next=0; repeat(1100) @(negedge clk); key_next=1;
            wait(frame_finishes==2 && display_valid && disp_buf==1);
            repeat(4) @(negedge clk);
            if(buffer_for_frame[1]!=1) $fatal(1,"second frame did not target buffer 1");
            verify_memory(1,1);
            if(write_count!=PIXELS*2 || frame_pixels!=0) $fatal(1,"second source pixel count mismatch");
            read_back_frame(1,1);
        end

        if(card_transactions==0) $fatal(1,"no card sectors were read");
        $display("PASS tb_fat_frame_integration %0dx%0d: %0d exact BMP frame(s) through FAT32, codec, generated FIFOs and SDRAM backend; sectors=%0d",
            WIDTH,HEIGHT,FRAME_COUNT,card_transactions);
        $finish;
    end

    // Physical sector source: 512 valid bytes at a fixed 32-cycle byte period,
    // followed by end and a mandatory three-clock request gap.
    always @(negedge clk) begin
        card_valid=0; card_end=0;
        if(rst) begin active=0; gap=0; pos=0; tick=0; end
        else if(active==1) begin
            tick=tick+1;
            if(tick % CARD_BYTE_CYCLES == 0) begin
                card_data=sector_mem[slot*512+pos];
                card_valid=1; pos=pos+1;
                if(pos==512) active=2;
            end
        end else if(active==2) begin
            card_end=1; active=0; gap=3;
        end else if(gap!=0) begin
            if(card_read) $fatal(1,"physical request gap shorter than three clocks");
            gap=gap-1;
        end else if(card_read) begin
            found=-1;
            for(i=0;i<`FIXTURE_SECTORS;i=i+1) if(lbas[i]==card_addr) found=i;
            if(found<0) $fatal(1,"unexpected LBA %0d",card_addr);
            slot=found; pos=0; tick=0; active=1; card_transactions=card_transactions+1;
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            write_finish_toggle<=0;
            previous_write_req<=0;
        end else begin
            if(write_finish) begin
                write_finish_toggle<=~write_finish_toggle;
                if(frame_pixels!=PIXELS)
                    $fatal(1,"frame backend finished with only %0d/%0d source pixels",frame_pixels,PIXELS);
                frame_finishes=frame_finishes+1;
                frame_pixels=0;
            end
            if(write_req && !previous_write_req && frame_finishes<FRAME_COUNT)
                buffer_for_frame[frame_finishes]=write_buf;
            previous_write_req<=write_req;
            if(write_en) begin
                if(frame_finishes>=FRAME_COUNT) $fatal(1,"extra frame pixel");
                if(write_data !== expected_pixels[frame_finishes*PIXELS+frame_pixels])
                    $fatal(1,"BMP->frame pixel mismatch frame=%0d pixel=%0d expected=%h actual=%h",
                        frame_finishes,frame_pixels,
                        expected_pixels[frame_finishes*PIXELS+frame_pixels],write_data);
                frame_pixels=frame_pixels+1;
                write_count=write_count+1;
                if(frame_pixels>PIXELS) $fatal(1,"extra source pixel in frame");
            end
            if(fs_error || bmp_error || bmp_map_error)
                $fatal(1,"pipeline error cat=%h map=%h bmp=%b state=%0d",fs_code,bmp_map_code,bmp_error,bmp_state);
            cycles=cycles+1;
            if(cycles>100000000) $fatal(1,"global timeout state=%0d frames=%0d pixels=%0d",bmp_state,frame_finishes,frame_pixels);
        end
    end

    always @(posedge read_clk) begin
        if(read_request_active && read_buf !== read_buf_lock)
            $fatal(1,"read frame index changed during active request");
    end
endmodule

// Same application-level contract model as the compact frame-buffer test.
// DATA_LAG=-1 makes the data word lead its valid by one mem_clk edge.
module sdram #(
    parameter integer DATA_LAG=-1
)(
    input Clk, Clk_sft, Rst,
    output Sdr_init_done, Sdr_init_ref_vld, Sdr_busy,
    input App_wr_en, input [20:0] App_wr_addr,
    input [3:0] App_wr_dm, input [31:0] App_wr_din,
    input App_rd_en, input [20:0] App_rd_addr,
    output reg Sdr_rd_en=0, output reg [31:0] Sdr_rd_dout=0
);
    localparam CAPACITY=2*640*480*3/4;
    reg [31:0] mem[0:CAPACITY-1];
    integer write_hits[0:CAPACITY-1];
    integer write_count=0, read_count=0, i;
    reg [10:0] rd_pending=0;
    reg [20:0] rd_addr[0:10];
    integer pipeline_index;
    assign Sdr_init_done=!Rst;
    assign Sdr_init_ref_vld=1'b0;
    assign Sdr_busy=1'b0;
    initial begin
        for(i=0;i<CAPACITY;i=i+1) begin mem[i]=32'hdeadbeef; write_hits[i]=0; end
        for(i=0;i<11;i=i+1) rd_addr[i]=0;
    end
    always @(posedge Clk) begin
        if(Rst) begin rd_pending<=0; Sdr_rd_en<=0; end
        else begin
            if(App_wr_en && App_rd_en) $fatal(1,"simultaneous SDRAM read/write");
            if(App_wr_en) begin
                if(App_wr_addr>=2*tb_fat_frame_integration.FRAME_WORDS) $fatal(1,"SDRAM write outside two frames");
                if(App_wr_dm!=0) $fatal(1,"unexpected partial-word SDRAM write");
                mem[App_wr_addr]<=App_wr_din;
                write_hits[App_wr_addr]=write_hits[App_wr_addr]+1;
                write_count=write_count+1;
            end
            rd_pending<={rd_pending[9:0],App_rd_en};
            rd_addr[0]<=App_rd_addr;
            for(pipeline_index=1;pipeline_index<11;pipeline_index=pipeline_index+1)
                rd_addr[pipeline_index]<=rd_addr[pipeline_index-1];
            if(App_rd_en) begin
                if(App_rd_addr>=2*tb_fat_frame_integration.FRAME_WORDS) $fatal(1,"SDRAM read outside two frames");
                read_count=read_count+1;
            end
            Sdr_rd_en<=rd_pending[9];
            if(rd_pending[9+DATA_LAG]) Sdr_rd_dout<=mem[rd_addr[9+DATA_LAG]];
            else Sdr_rd_dout<=32'hdeadbeef;
        end
    end
endmodule
