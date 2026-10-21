`timescale 1ns/1ps
module tb_fat32_catalog;
reg clk=0; always #10 clk=~clk;
reg rst=1, sd_init_done=0;
wire sd_read; wire [31:0] sd_addr;
reg [7:0] sd_data=0; reg sd_valid=0,sd_end=0;
wire ready,error; wire [7:0] error_code;
wire [31:0] fat_lba,data_lba,cluster_count;
wire [3:0] spc_shift; wire [2:0] bmp_count; wire [127:0] bmp_clusters,bmp_sizes;
wire wav_found; wire [31:0] wav_cluster,wav_size;
integer mode=0; // 0 superfloppy; 1 MBR cross-cluster; 2 bad geometry; 3 bad active FAT; 4 bad root link; 5 bounded loop
integer serving=0, stream_pos=0, gap_phase=0;
reg prev_read=0;
reg [31:0] serving_lba=0;
integer tests=0;

fat32_catalog #(.MAX_ROOT_CLUSTERS(2),.SECTOR_TIMEOUT_CYCLES(50000)) dut(
 .clk(clk),.rst(rst),.sd_init_done(sd_init_done),.sd_read(sd_read),.sd_addr(sd_addr),
 .sd_data(sd_data),.sd_valid(sd_valid),.sd_end(sd_end),.ready(ready),.error(error),.error_code(error_code),
 .fat_lba(fat_lba),.data_lba(data_lba),.cluster_count(cluster_count),.sectors_per_cluster_shift(spc_shift),
 .bmp_count(bmp_count),.bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),.wav_found(wav_found),.wav_cluster(wav_cluster),.wav_size(wav_size));

function [7:0] vbr_byte;
 input integer n;
 begin
  vbr_byte=0;
  case(n)
   11:vbr_byte=0; 12:vbr_byte=2; 13:vbr_byte=1;
   14:vbr_byte=32; 15:vbr_byte=0; 16:vbr_byte=2;
   17:vbr_byte=0; 18:vbr_byte=0;
   19:vbr_byte=0; 20:vbr_byte=0; 22:vbr_byte=0; 23:vbr_byte=0;
   32:vbr_byte=70000 & 255; 33:vbr_byte=(70000>>8)&255; 34:vbr_byte=(70000>>16)&255; 35:vbr_byte=(70000>>24)&255;
   36:vbr_byte=600 & 255; 37:vbr_byte=(600>>8)&255; 38:vbr_byte=(600>>16)&255; 39:vbr_byte=(600>>24)&255;
   40:vbr_byte=(mode==3)?8'h82:((mode==9)?8'h81:0);
   42:vbr_byte=0; 43:vbr_byte=0;
   44:vbr_byte=2; 45:vbr_byte=0; 46:vbr_byte=0; 47:vbr_byte=0;
   510:vbr_byte=8'h55; 511:vbr_byte=8'haa;
   default:vbr_byte=0;
  endcase
  if(mode==2 && n>=32 && n<=35) vbr_byte=0;
 end
endfunction

function [7:0] entry_byte;
 input integer slot; input integer off; input integer is_wav;
 reg [7:0] nm;
 integer cl,sz;
 begin
  entry_byte=0; cl=is_wav?8:5; sz=(mode==6 && !is_wav)?0:(is_wav?1234:1000);
  if(is_wav) begin
   case(off)
    0:entry_byte="T";1:entry_byte="E";2:entry_byte="S";3:entry_byte="T";
    4:entry_byte=" ";5:entry_byte=" ";6:entry_byte=" ";7:entry_byte=" ";
    8:entry_byte="W";9:entry_byte="A";10:entry_byte="V";
    11:entry_byte=8'h20;20:entry_byte=0;21:entry_byte=0;
    26:entry_byte=cl&255;27:entry_byte=(cl>>8)&255;28:entry_byte=sz&255;29:entry_byte=(sz>>8)&255;30:entry_byte=(sz>>16)&255;31:entry_byte=(sz>>24)&255;
    default:entry_byte=0;
   endcase
  end else begin
   case(off)
    0:entry_byte="P";1:entry_byte="I";2:entry_byte="C";3:entry_byte=" ";4:entry_byte=" ";5:entry_byte=" ";6:entry_byte=" ";7:entry_byte=" ";
    8:entry_byte="B";9:entry_byte="M";10:entry_byte="P";11:entry_byte=8'h20;
    20:entry_byte=0;21:entry_byte=0;26:entry_byte=cl&255;27:entry_byte=(cl>>8)&255;
    28:entry_byte=sz&255;29:entry_byte=(sz>>8)&255;30:entry_byte=(sz>>16)&255;31:entry_byte=(sz>>24)&255;
    default:entry_byte=0;
   endcase
  end
 end
endfunction

function [7:0] sector_byte;
 input [31:0] lba; input integer n;
 integer base, data_base, slot, off, cross;
 begin
  base=(mode==1)?100:((mode==8)?32'hfffffff0:0); data_base=base+32+1200; sector_byte=0;
  if((mode==1 || mode==8) && lba==0) begin
   case(n)
    11:sector_byte=(mode==1)?8'h90:0; 12:sector_byte=(mode==1)?8'he9:0;
    450:sector_byte=(mode==15)?8'h0b:8'h0c;
    454:sector_byte=(mode==8)?8'hf0:((mode==15)?8'hde:100);455:sector_byte=(mode==8)?8'hff:((mode==15)?8'had:0);456:sector_byte=(mode==8)?8'hff:((mode==15)?8'hbe:0);457:sector_byte=(mode==8)?8'hff:((mode==15)?8'hef:0);
    458:sector_byte=(mode==15)?8'h01:(71000&255);459:sector_byte=(mode==15)?8'h02:((71000>>8)&255);460:sector_byte=(mode==15)?8'h03:((71000>>16)&255);461:sector_byte=(mode==15)?8'h04:((71000>>24)&255);
    510:sector_byte=8'h55;511:sector_byte=8'haa;
    default:sector_byte=0;
   endcase
  end else if(lba==base) sector_byte=vbr_byte(n);
  else if(lba==base+32 || (mode==9 && lba==base+632)) begin
   if(n==8) sector_byte=(mode==4)?0:((mode==5)?2:((mode==1)?3:8'hf8));
   if(n==9) sector_byte=(mode==0 || mode==9)?8'hff:0;
   if(n==10) sector_byte=(mode==0 || mode==9)?8'hff:0;
   if(n==11) sector_byte=(mode==0 || mode==9)?8'h0f:0;
   if(n==12) sector_byte=(mode==1)?8'hf8:((mode==5)?2:0);
   if(n==13) sector_byte=(mode==1)?8'hff:0;
   if(n==14) sector_byte=(mode==1)?8'hff:0;
   if(n==15) sector_byte=(mode==1)?8'h0f:0;
  end else if(lba==data_base || lba==data_base+1) begin
   cross=(mode==1);
    if(mode==10) sector_byte=0;
    else if(mode==1 && lba==data_base) begin
     // Deleted and LFN records prove they are skipped; PIC.BMP is in slot 2.
     if(n<32) sector_byte=8'he5;
     else if(n<64) begin off=n%32; sector_byte=(off==0)?"L":(off==11)?8'h0f:0; end
     else if(n<96) sector_byte=entry_byte(2,n%32,0);
     else sector_byte=(n%32==0)?8'he5:0;
   end else if(mode==1 && lba==data_base+1) begin
     if(n<32) sector_byte=entry_byte(0,n%32,1);
   end else begin
     if(n<32) sector_byte=entry_byte(0,n%32,0);
     else if(n<64) sector_byte=entry_byte(1,n%32,1);
     else if((mode==4 || mode==5) && n%32==0) sector_byte=8'he5;
   end
  end
 end
endfunction

always @(posedge clk) begin
 if(rst) begin serving<=0; stream_pos<=0; gap_phase<=0; sd_valid<=0; sd_end<=0; sd_data<=0; prev_read<=0; end
 else begin
  sd_valid<=0; sd_end<=0;
  prev_read<=sd_read;
  if(!serving && sd_read && !prev_read) begin $display("TRACE REQ mode=%0d lba=%08x",mode,sd_addr); serving<=1; serving_lba<=sd_addr; stream_pos<=0; gap_phase<=0; end
  else if(serving) begin
   if(mode==7) begin sd_valid<=0; end
   else if(mode==16 && stream_pos==512) begin
    if(dut.wait_count==49999) begin sd_end<=1; serving<=0; end
   end
   else if(mode==12 && stream_pos==100) begin sd_end<=1; serving<=0; end
   else if(stream_pos<512) begin
    if(mode==16) begin sd_valid<=1; sd_data<=sector_byte(serving_lba,stream_pos); stream_pos<=stream_pos+1; end
    else if(gap_phase==2) gap_phase<=0;
    else begin sd_valid<=1; sd_data<=sector_byte(serving_lba,stream_pos); stream_pos<=stream_pos+1; gap_phase<=gap_phase+1; end
   end else begin sd_end<=1; if(mode==13) begin sd_valid<=1; sd_data<=0; end serving<=0; end
  end
 end
end

task reset_case;
 input integer new_mode;
 begin
  mode=new_mode; rst=1; sd_init_done=0; repeat(4) @(posedge clk); rst=0; @(posedge clk); sd_init_done=1;
 end
endtask
task wait_terminal;
 integer t;
 begin
  t=0; while(!ready && !error && t<300000) begin @(posedge clk); t=t+1; end
  if(t>=300000) $fatal(1,"timeout mode=%0d state=%0d addr=%0d",mode,dut.state,sd_addr);
  $display("TRACE END mode=%0d ready=%b error=%b code=%02x fat=%08x data=%08x clusters=%08x shift=%0d bmpcount=%0d bmp0=%08x/%08x wav=%b/%08x/%08x",mode,ready,error,error_code,fat_lba,data_lba,cluster_count,spc_shift,bmp_count,bmp_clusters[31:0],bmp_sizes[31:0],wav_found,wav_cluster,wav_size);
 end
endtask
task check_mount;
 begin
  wait_terminal(); if(error) $fatal(1,"unexpected catalog error mode=%0d code=%h",mode,error_code);
  if(!ready || bmp_count!=1 || bmp_clusters[31:0]!=5 || bmp_sizes[31:0]!=1000 || !wav_found || wav_cluster!=8 || wav_size!=1234) $fatal(1,"catalog mismatch mode=%0d bmp=%0d cl=%0d wav=%0d",mode,bmp_count,bmp_clusters[31:0],wav_found);
  tests=tests+1;
 end
endtask
task check_error;
 input [7:0] want;
 integer k;
 begin
  wait_terminal(); if(!error || error_code!=want || ready || dut.state!=11) $fatal(1,"expected sticky error %h got ready=%b error=%b code=%h state=%0d mode=%0d",want,ready,error,error_code,dut.state,mode);
  repeat(4) begin @(posedge clk); if(ready || sd_read || !error || error_code!=want) $fatal(1,"error did not remain quiescent mode=%0d ready=%b read=%b error=%b code=%h",mode,ready,sd_read,error,error_code); end
  tests=tests+1;
 end
endtask
task check_empty_catalog;
 begin
  wait_terminal();
  if(error || !ready || bmp_count!=0 || wav_found) $fatal(1,"empty directory should mount cleanly");
  tests=tests+1;
 end
endtask

initial begin
 reset_case(0); check_mount();
 reset_case(1); wait_terminal();
 if(error || !ready || bmp_count!=1 || bmp_clusters[31:0]!=5 || !wav_found || wav_cluster!=8) $fatal(1,"MBR/cross-cluster catalog mismatch"); tests=tests+1;
 reset_case(2); check_error(8'h02);
 reset_case(3); check_error(8'h02);
 reset_case(4); check_error(8'h05);
 reset_case(5); check_error(8'h06);
 if(dut.root_clusters_read!=2) $fatal(1,"root scan limit off by one: scanned=%0d",dut.root_clusters_read);
 reset_case(6); check_error(8'h07);
 reset_case(7); check_error(8'h08);
 reset_case(16); check_error(8'h08);
 reset_case(9); check_mount();
 if(fat_lba!=632) $fatal(1,"active FAT selection mismatch: fat_lba=%0d",fat_lba);
 reset_case(8); check_error(8'h04);
 reset_case(10); check_empty_catalog();
 reset_case(12); check_error(8'h01);
 reset_case(13); check_error(8'h01);
 reset_case(15); check_mount();
 $display("PASS fat32_catalog cases=%0d",tests); $finish;
end
endmodule
