`timescale 1ns/1ps
`include "config.vh"
module tb_actual_card_replay;
parameter FRAME_TARGET=2;
parameter CARD_GAP=1;
parameter AUDIO_SAMPLE_CYCLES=64;
localparam WIDTH=640, HEIGHT=480, PIXELS=WIDTH*HEIGHT;
localparam EXPECTED_SAMPLES=1024;
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
reg [7:0] card_data=0; reg card_valid=0,card_end=0;
wire arb_read; wire [31:0] arb_addr;
wire bmp_phy_read,wav_phy_read; wire [31:0] bmp_phy_addr,wav_phy_addr;
wire [7:0] bmp_phy_data,wav_phy_data;
wire bmp_phy_valid,bmp_phy_end,wav_phy_valid,wav_phy_end;
wire bmp_read,wav_read; wire [31:0] bmp_addr,wav_addr;
wire [7:0] bmp_data,wav_data; wire bmp_valid,bmp_end,wav_valid,wav_end;
wire bmp_map_error,wav_map_error; wire [7:0] bmp_map_code,wav_map_code;
wire [31:0] bmp_cluster,bmp_size;
reg finish_toggle=0,write_ack=0;
wire write_req,write_en; wire [23:0] write_data;
wire [1:0] write_buf,disp_buf; wire display_valid,bmp_error;
wire [3:0] bmp_state;
reg sample_take=0; wire [15:0] sample_data;
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
tf_bmp_file_player #(.CLK_FREQ_HZ(20000),.FRAME_WIDTH(WIDTH),.FRAME_HEIGHT(HEIGHT),.WAIT_LIMIT(50000000))
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
tf_wav_file_player #(.FIFO_DEPTH(2048),.WAIT_LIMIT(50000000)) u_wav
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
reg [23:0] expected_pixels[0:4*PIXELS-1];
reg [15:0] expected_samples[0:383999];
reg [1023:0] fixture;
integer active=0,slot=0,pos=0,gap=0,tick=0,i,found;
integer frame_pixels=0,frames=0,samples=0,cycles=0;
integer bmp_transactions=0,wav_transactions=0,requests=0;
integer target_frame;
initial begin
    if(FRAME_TARGET<2 || FRAME_TARGET>4) $fatal(1,"FRAME_TARGET must be in 2..4");
    if(!$value$plusargs("FIXTURE=%s",fixture)) $fatal(1,"Need FIXTURE directory");
    $readmemh({fixture,"/lbas.hex"},lbas);
    $readmemh({fixture,"/sectors.hex"},sector_mem);
    $readmemh({fixture,"/pixels.hex"},expected_pixels);
    $readmemh({fixture,"/samples.hex"},expected_samples);
    repeat(8) @(negedge clk); rst=0; repeat(4) @(negedge clk); init_done=1;
    wait(fs_ready || fs_error);
    if(fs_error) $fatal(1,"mount error code=%02h cycle=%0d lba=%0d",fs_code,cycles,card_addr);
    if(bmp_count!=4 || !wav_found || cluster_shift!=6 || fat_lba!=64 || data_lba!=7444 ||
       bmp_clusters[31:0]!=6 || bmp_clusters[63:32]!=35 || bmp_clusters[95:64]!=64 || bmp_clusters[127:96]!=93 ||
       wav_cluster!=122 || wav_size!=768044)
        $fatal(1,"captured geometry/catalog mismatch cycle=%0d count=%0d wav=%b/%0d/%0d shift=%0d fat=%0d data=%0d",
               cycles,bmp_count,wav_found,wav_cluster,wav_size,cluster_shift,fat_lba,data_lba);
    wait(display_valid);
    wait(frames>=1);
    for(target_frame=2;target_frame<=FRAME_TARGET;target_frame=target_frame+1) begin
        @(negedge clk); key_next=0; repeat(1100) @(negedge clk); key_next=1;
        wait(frames>=target_frame);
    end
    if(samples<EXPECTED_SAMPLES) wait(samples>=EXPECTED_SAMPLES);
    repeat(100) @(negedge clk);
    $display("PASS actual_card_replay frames=%0d/4 exact_pixels=%0d samples=%0d exact WAV samples; SPC64 sectors=%0d bmp_reads=%0d wav_reads=%0d cycles=%0d CARD_GAP=%0d",
             frames,frames*PIXELS,samples,`FIXTURE_SECTORS,bmp_transactions,wav_transactions,cycles,CARD_GAP);
    $finish;
end

// Model only sectors captured from the real volume. A one-cycle invalid gap is
// inserted between bytes; completion is on a separate cycle followed by 3 idle clocks.
always @(negedge clk) begin
    card_valid=0; card_end=0;
    if(rst) begin active=0; gap=0; pos=0; tick=0; end
    else if(active==1) begin
        tick=tick+1;
        if(tick%(CARD_GAP+1)==0) begin
            card_data=sector_mem[slot*512+pos]; card_valid=1; pos=pos+1;
            if(pos==512) active=2;
        end
    end else if(active==2) begin card_end=1; active=0; gap=3; end
    else if(gap!=0) begin
        if(card_read) $fatal(1,"short physical gap cycle=%0d request=%b addr=%0d remaining=%0d pos=%0d",cycles,card_read,card_addr,gap,pos);
        gap=gap-1;
    end else if(card_read) begin
        found=-1;
        for(i=0;i<`FIXTURE_SECTORS;i=i+1) if(lbas[i]==card_addr) found=i;
        if(found<0) $fatal(1,"unmapped physical LBA=%0d cycle=%0d read=%b ready=%b owner=%0d bmp_state=%0d bmp_req=%0d wav_req=%0d bmp_map=%02h wav_map=%02h",
                           card_addr,cycles,card_read,fs_ready,u_arb.owner,bmp_state,bmp_phy_read,wav_phy_read,bmp_map_code,wav_map_code);
        slot=found; pos=0; tick=0; active=1; requests=requests+1;
        if(fs_ready) begin
            if(u_arb.owner==1) bmp_transactions=bmp_transactions+1;
            else if(u_arb.owner==2) wav_transactions=wav_transactions+1;
        end
    end
    sample_take=primed && cycles%AUDIO_SAMPLE_CYCLES==0;
end

always @(posedge clk) begin
    if(!rst) begin
        cycles=cycles+1;
        if(cycles>50000000) $fatal(1,"global timeout cycle=%0d fs=%b/%02h bmp=%0d frames=%0d pixels_in_frame=%0d samples=%0d primed=%b card=%b/%0d active=%0d pos=%0d gap=%0d bmp_req=%b/%0d wav_req=%b/%0d",
             cycles,fs_ready,fs_code,bmp_state,frames,frame_pixels,samples,primed,card_read,card_addr,active,pos,gap,bmp_phy_read,bmp_phy_addr,wav_phy_read,wav_phy_addr);
        if(fs_error||bmp_map_error||wav_map_error||bmp_error||wav_error)
            $fatal(1,"RTL error cycle=%0d fs=%b/%02h bmpmap=%b/%02h wavmap=%b/%02h bmperr=%b waverr=%b card=%b/%0d active=%0d pos=%0d",
                   cycles,fs_error,fs_code,bmp_map_error,bmp_map_code,wav_map_error,wav_map_code,bmp_error,wav_error,card_read,card_addr,active,pos);
        write_ack<=write_req;
        if(write_en) begin
            if(write_data!==expected_pixels[(frames%4)*PIXELS+frame_pixels])
                $fatal(1,"pixel mismatch cycle=%0d frame=%0d pixel=%0d expected=%06h actual=%06h card=%b/%0d active=%0d pos=%0d",
                       cycles,frames,frame_pixels,expected_pixels[(frames%4)*PIXELS+frame_pixels],write_data,card_read,card_addr,active,pos);
            frame_pixels=frame_pixels+1;
            if(frame_pixels==PIXELS) begin
                frame_pixels=0; frames=frames+1; finish_toggle<=~finish_toggle;
            end
        end
        if(sample_take) begin
            if(!sample_available) $fatal(1,"audio underflow cycle=%0d sample=%0d primed=%b card=%b/%0d wav_map=%b/%02h",
                                         cycles,samples,primed,card_read,card_addr,wav_map_error,wav_map_code);
            if(sample_data!==expected_samples[samples])
                $fatal(1,"WAV mismatch cycle=%0d sample=%0d expected=%04h actual=%04h card=%b/%0d wav_state=%0d",
                       cycles,samples,expected_samples[samples],sample_data,card_read,card_addr,u_wav.state);
            samples=samples+1;
        end
    end
end
endmodule
