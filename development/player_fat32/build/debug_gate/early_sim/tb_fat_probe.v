`timescale 1ns/1ps
`include "config.vh"
module tb_fat_probe;
parameter WIDTH=640, HEIGHT=480;
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
fat_probe dut(.clk(clk),.rst(rst),.init_done(init_done),.key_next(key_next),.key_auto(key_auto),
.card_data(card_data),.card_valid(card_valid),.card_end(card_end),.sample_take(sample_take),
.card_read(card_read),.card_addr(card_addr),.write_en(write_en),.write_data(write_data),
.primed(primed),.sample_available(sample_available),.sample_data(sample_data),
.fs_ready(fs_ready),.fs_error(fs_error),.bmp_error(bmp_error),.wav_error(wav_error),
.bmp_map_error(bmp_map_error),.wav_map_error(wav_map_error));
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
    wait(frame_pixels>=256 && samples>=1024);
    $display("PASS probe first256 pixels, samples=%0d",samples); $finish;
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
    end
    sample_take=primed && cycles%AUDIO_SAMPLE_CYCLES==0;
end
always @(posedge clk) begin
    if(!rst) begin
        cycles=cycles+1;
        if(cycles>1000000) $fatal(1,"global timeout bmp=%0d frames=%0d samples=%0d",bmp_state,frames,samples);
        if(fs_error||bmp_map_error||wav_map_error||bmp_error||wav_error)
            $fatal(1,"error: fs=%b bmpmap=%b wavmap=%b bmp=%b wav=%b",fs_error,bmp_map_error,wav_map_error,bmp_error,wav_error);
        
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
