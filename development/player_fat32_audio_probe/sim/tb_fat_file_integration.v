`timescale 1ns/1ps
`include "config.vh"
module tb_fat_file_integration;
parameter WIDTH=16, HEIGHT=64;
parameter CARD_BYTE_CYCLES=0, AUDIO_SAMPLE_CYCLES=64;
localparam PIXELS=WIDTH*HEIGHT;
reg clk=0; always #10 clk=~clk;
reg rst=1,init_done=0,key_next=1,key_auto=1;
wire fs_ready,fs_error,wav_found;
wire [7:0] fs_code;
wire [31:0] fat_lba,data_lba,cluster_count,wav_cluster,wav_size;
wire [3:0] cluster_shift;
wire [2:0] bmp_count;
wire [127:0] bmp_clusters,bmp_sizes;
wire mount_read; wire [31:0] mount_addr;
wire card_read; wire [31:0] card_addr;
reg [7:0] card_data=0;reg card_valid=0,card_end=0;
wire arb_read; wire [31:0] arb_addr;
wire bmp_phy_read,wav_phy_read;wire [31:0] bmp_phy_addr,wav_phy_addr;
wire [7:0] bmp_phy_data,wav_phy_data;
wire bmp_phy_valid,bmp_phy_end,wav_phy_valid,wav_phy_end;
wire bmp_read,wav_read;wire [31:0] bmp_addr,wav_addr;
wire [7:0] bmp_data,wav_data;wire bmp_valid,bmp_end,wav_valid,wav_end;
wire bmp_map_error,wav_map_error;wire [7:0] bmp_map_code,wav_map_code;
wire [31:0] bmp_cluster,bmp_size;
reg finish_toggle=0,write_ack=0;
wire write_req,write_en;wire [23:0] write_data;
wire [1:0] write_buf,disp_buf;wire display_valid,bmp_error;
wire [3:0] bmp_state;
reg sample_take=0;wire [15:0] sample_data;
wire sample_available,primed,wav_error;
assign card_read=fs_ready?arb_read:mount_read;
assign card_addr=fs_ready?arb_addr:mount_addr;
fat32_catalog u_cat(.clk(clk),.rst(rst),.sd_init_done(init_done),
    .sd_read(mount_read),.sd_addr(mount_addr),.sd_data(card_data),
    .sd_valid(!fs_ready&&card_valid),.sd_end(!fs_ready&&card_end),
    .ready(fs_ready),.error(fs_error),.error_code(fs_code),
    .fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),
    .sectors_per_cluster_shift(cluster_shift),.bmp_count(bmp_count),
    .bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),
    .wav_found(wav_found),.wav_cluster(wav_cluster),.wav_size(wav_size));
tf_bmp_file_player #(.CLK_FREQ_HZ(20000),.FRAME_WIDTH(WIDTH),.FRAME_HEIGHT(HEIGHT),.WAIT_LIMIT(1000000))
    u_bmp(.clk(clk),.rst(rst),.key_next(key_next),.key_auto(key_auto),
    .catalog_ready(fs_ready),.bmp_count(bmp_count),.bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),
    .file_cluster(bmp_cluster),.file_size(bmp_size),.card_read(bmp_read),.card_addr(bmp_addr),
    .card_data(bmp_data),.card_valid(bmp_valid),.card_end(bmp_end),.file_error(bmp_map_error),
    .write_finish_toggle(finish_toggle),.write_buf_idx(write_buf),.disp_buf_idx(disp_buf),
    .write_req(write_req),.write_req_ack(write_ack),.write_en(write_en),.write_data(write_data),
    .display_valid(display_valid),.error(bmp_error),.state_code(bmp_state));
fat32_file_sector u_bmp_map(.clk(clk),.rst(rst),.enable(fs_ready),
    .fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),.sectors_per_cluster_shift(cluster_shift),
    .start_cluster(bmp_cluster),.file_size(bmp_size),.file_read(bmp_read),.file_sector(bmp_addr),
    .file_data(bmp_data),.file_valid(bmp_valid),.file_end(bmp_end),.error(bmp_map_error),.error_code(bmp_map_code),
    .sd_read(bmp_phy_read),.sd_addr(bmp_phy_addr),.sd_data(bmp_phy_data),.sd_valid(bmp_phy_valid),.sd_end(bmp_phy_end));
fat32_file_sector u_wav_map(.clk(clk),.rst(rst),.enable(fs_ready&&wav_found),
    .fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),.sectors_per_cluster_shift(cluster_shift),
    .start_cluster(wav_cluster),.file_size(wav_size),.file_read(wav_read),.file_sector(wav_addr),
    .file_data(wav_data),.file_valid(wav_valid),.file_end(wav_end),.error(wav_map_error),.error_code(wav_map_code),
    .sd_read(wav_phy_read),.sd_addr(wav_phy_addr),.sd_data(wav_phy_data),.sd_valid(wav_phy_valid),.sd_end(wav_phy_end));
tf_wav_file_player #(.FIFO_DEPTH(2048),.WAIT_LIMIT(1000000)) u_wav
    (.clk(clk),.rst(rst),.sd_init_done(fs_ready&&wav_found),.file_size(wav_size),.file_error(wav_map_error),
    .sd_read(wav_read),.sd_addr(wav_addr),.sd_data(wav_data),.sd_valid(wav_valid),.sd_end(wav_end),
    .sample_take(sample_take),.sample_data(sample_data),.sample_available(sample_available),.primed(primed),.error(wav_error));
sd_sector_arbiter u_arb(.clk(clk),.rst(rst||!fs_ready),
    .bmp_read(bmp_phy_read),.bmp_addr(bmp_phy_addr),.wav_read(wav_phy_read),.wav_addr(wav_phy_addr),
    .card_read(arb_read),.card_addr(arb_addr),.card_data(card_data),
    .card_valid(fs_ready&&card_valid),.card_end(fs_ready&&card_end),
    .bmp_data(bmp_phy_data),.bmp_valid(bmp_phy_valid),.bmp_end(bmp_phy_end),
    .wav_data(wav_phy_data),.wav_valid(wav_phy_valid),.wav_end(wav_phy_end));
reg [31:0] lbas[0:`FIXTURE_SECTORS-1];
reg [7:0] sector_mem[0:`FIXTURE_SECTORS*512-1];
reg [23:0] expected_pixels[0:PIXELS*2-1];
reg [15:0] expected_samples[0:2299];
reg [1023:0] fixture;
integer active=0,slot=0,pos=0,gap=0,tick=0,i,found;
integer frame_pixels=0,frames=0,samples=0,audio_streak=0,max_audio_streak=0;
integer bmp_transactions=0,wav_transactions=0,cycles=0;
initial begin
    if(!$value$plusargs("FIXTURE=%s",fixture)) $fatal(1,"Need FIXTURE directory");
    $readmemh({fixture,"/lbas.hex"},lbas);
    $readmemh({fixture,"/sectors.hex"},sector_mem);
    $readmemh({fixture,"/pixels.hex"},expected_pixels);
    $readmemh({fixture,"/samples.hex"},expected_samples);
    repeat(8) @(negedge clk);rst=0;repeat(4) @(negedge clk);init_done=1;
    wait(display_valid);if(bmp_count!=2 || !wav_found) $fatal(1,"catalog count");
    // Manual next then auto on/off, with distinct images and dual-buffer commits.
    @(negedge clk);key_next=0;repeat(1100) @(negedge clk);key_next=1;
    wait(disp_buf==1);if(frames!=2) $fatal(1,"manual commit mismatch");
    @(negedge clk);key_auto=0;repeat(1100) @(negedge clk);key_auto=1;
    wait(frames==3);wait(disp_buf==0);
    @(negedge clk);key_auto=0;repeat(1100) @(negedge clk);key_auto=1;
    wait(!u_bmp.auto_enabled);repeat(30000) @(negedge clk);
    if(frames!=3) $fatal(1,"auto off continued loading");
    if(samples<4600) begin wait(samples>=4600); end
    if(max_audio_streak>2) $fatal(1,"fairness exceeded");
    $display("PASS fat_file_integration %0dx%0d: 3 exact BMP frames, samples=%0d exact (loop length2300), BMP sectors=%0d WAV sectors=%0d, fairness max=%0d",WIDTH,HEIGHT,samples,bmp_transactions,wav_transactions,max_audio_streak);
    $finish;
end
// A card model which enforces completion and request spacing; arbitrary byte gaps.
always @(negedge clk) begin
    card_valid=0;card_end=0;
    if(rst) begin active=0;gap=0;pos=0;tick=0;end
    else if(active==1) begin
        tick=tick+1;
        if((CARD_BYTE_CYCLES==0 && tick%3!=0) ||
           (CARD_BYTE_CYCLES!=0 && tick%CARD_BYTE_CYCLES==0)) begin
            card_data=sector_mem[slot*512+pos];card_valid=1;pos=pos+1;
            if(pos==512) active=2;
        end
    end else if(active==2) begin card_end=1;active=0;gap=3;end
    else if(gap!=0) begin
        if(card_read) $fatal(1,"physical request gap shorter than three clocks");
        gap=gap-1;
    end
    else if(card_read) begin
        found=-1;for(i=0;i<`FIXTURE_SECTORS;i=i+1) if(lbas[i]==card_addr) found=i;
        if(found<0) $fatal(1,"invalid/unexpected LBA %0d",card_addr);
        slot=found;pos=0;tick=0;active=1;
        if(fs_ready) begin
            if(u_arb.owner==1) begin bmp_transactions=bmp_transactions+1;audio_streak=0;end
            else if(u_arb.owner==2) begin
                wav_transactions=wav_transactions+1;
                if(bmp_phy_read) begin audio_streak=audio_streak+1;if(audio_streak>max_audio_streak) max_audio_streak=audio_streak;end
                else audio_streak=0;
            end
        end
    end
    sample_take=primed && cycles%AUDIO_SAMPLE_CYCLES==0;
end
always @(posedge clk) begin
    if(!rst) begin
        cycles=cycles+1;
        if(cycles>12000000) $fatal(1,"global timeout bmp=%0d frames=%0d samples=%0d",bmp_state,frames,samples);
        if(fs_error||bmp_map_error||wav_map_error||bmp_error||wav_error)
            $fatal(1,"error: fs=%0h bmpmap=%0h wavmap=%0h bmp=%b wav=%b",fs_code,bmp_map_code,wav_map_code,bmp_error,wav_error);
        write_ack<=write_req;
        if(write_en) begin
            if(write_data!==expected_pixels[(frames%2)*PIXELS+frame_pixels])
                $fatal(1,"pixel mismatch frame%0d pixel%0d expected%h actual%h",frames,frame_pixels,expected_pixels[(frames%2)*PIXELS+frame_pixels],write_data);
            frame_pixels=frame_pixels+1;
            if(frame_pixels==PIXELS) begin frame_pixels=0;frames=frames+1;finish_toggle<=~finish_toggle;end
        end
        if(sample_take) begin
            if(!sample_available) $fatal(1,"audio underflow at sample%0d",samples);
            if(sample_data!==expected_samples[samples%2300]) $fatal(1,"sample%0d expected%h actual%h",samples,expected_samples[samples%2300],sample_data);
            samples=samples+1;
        end
    end
end
endmodule
