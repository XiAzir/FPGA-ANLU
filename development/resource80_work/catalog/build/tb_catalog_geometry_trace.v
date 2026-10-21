`timescale 1ns/1ps
module tb_catalog_geometry;
  reg clk = 0;
  always #5 clk = ~clk;

  reg rst = 1;
  reg sd_init_done = 0;
  wire sd_read_ref, sd_read_dut;
  wire [31:0] sd_addr_ref, sd_addr_dut;
  reg [7:0] sd_data = 0;
  reg sd_valid = 0, sd_end = 0;
  wire ready_ref, ready_dut, error_ref, error_dut;
  wire [7:0] error_code_ref, error_code_dut;
  wire [31:0] fat_lba_ref, fat_lba_dut, data_lba_ref, data_lba_dut;
  wire [31:0] cluster_count_ref, cluster_count_dut;
  wire [3:0] shift_ref, shift_dut;
  wire [2:0] bmp_count_ref, bmp_count_dut;
  wire [127:0] bmp_clusters_ref, bmp_clusters_dut, bmp_sizes_ref, bmp_sizes_dut;
  wire wav_found_ref, wav_found_dut;
  wire [31:0] wav_cluster_ref, wav_cluster_dut, wav_size_ref, wav_size_dut;

  integer case_id = 0;
  integer cycle_count = 0;
  integer mismatch_count = 0;
  integer compared_cases = 0;
  integer root_seen = 0;
  integer serviced_lba0 = 0;
  reg [31:0] vol_base = 0;
  reg [7:0] part_type_cfg[0:3];
  reg [31:0] part_start_cfg[0:3], part_size_cfg[0:3];
  reg use_mbr = 0;
  reg [7:0] cfg_spc = 1, cfg_fats = 1;
  reg [31:0] cfg_total = 67000, cfg_fatsz = 520, cfg_reserved = 32;
  reg [31:0] cfg_root = 2;
  reg [15:0] cfg_extflags = 0;
  reg cfg_bad_bps = 0, cfg_bad_spc = 0, cfg_bad_fats = 0;
  reg cfg_bad_reserved = 0, cfg_bad_total = 0, cfg_bad_fatsz = 0;
  integer expected_enable = 0, expected_root = 0;
  reg [7:0] expected_error = 0;
  reg [31:0] expected_root_addr = 0;
  integer t;

  fat32_catalog_reference #(.MAX_ROOT_CLUSTERS(2), .SECTOR_TIMEOUT_CYCLES(20000)) ref_dut (
    .clk(clk), .rst(rst), .sd_init_done(sd_init_done), .sd_read(sd_read_ref), .sd_addr(sd_addr_ref),
    .sd_data(sd_data), .sd_valid(sd_valid), .sd_end(sd_end), .ready(ready_ref), .error(error_ref), .error_code(error_code_ref),
    .fat_lba(fat_lba_ref), .data_lba(data_lba_ref), .cluster_count(cluster_count_ref), .sectors_per_cluster_shift(shift_ref),
    .bmp_count(bmp_count_ref), .bmp_clusters(bmp_clusters_ref), .bmp_sizes(bmp_sizes_ref), .wav_found(wav_found_ref),
    .wav_cluster(wav_cluster_ref), .wav_size(wav_size_ref));

  fat32_catalog_reference #(.MAX_ROOT_CLUSTERS(2), .SECTOR_TIMEOUT_CYCLES(20000)) opt_dut (
    .clk(clk), .rst(rst), .sd_init_done(sd_init_done), .sd_read(sd_read_dut), .sd_addr(sd_addr_dut),
    .sd_data(sd_data), .sd_valid(sd_valid), .sd_end(sd_end), .ready(ready_dut), .error(error_dut), .error_code(error_code_dut),
    .fat_lba(fat_lba_dut), .data_lba(data_lba_dut), .cluster_count(cluster_count_dut), .sectors_per_cluster_shift(shift_dut),
    .bmp_count(bmp_count_dut), .bmp_clusters(bmp_clusters_dut), .bmp_sizes(bmp_sizes_dut), .wav_found(wav_found_dut),
    .wav_cluster(wav_cluster_dut), .wav_size(wav_size_dut));

  always @(posedge clk) begin
    #1;
    cycle_count = cycle_count + 1;
    if ({sd_read_ref,sd_addr_ref,ready_ref,error_ref,error_code_ref,fat_lba_ref,data_lba_ref,cluster_count_ref,
         shift_ref,bmp_count_ref,bmp_clusters_ref,bmp_sizes_ref,wav_found_ref,wav_cluster_ref,wav_size_ref} !==
        {sd_read_dut,sd_addr_dut,ready_dut,error_dut,error_code_dut,fat_lba_dut,data_lba_dut,cluster_count_dut,
         shift_dut,bmp_count_dut,bmp_clusters_dut,bmp_sizes_dut,wav_found_dut,wav_cluster_dut,wav_size_dut}) begin
      mismatch_count = mismatch_count + 1;
      $display("MISMATCH case=%0d cycle=%0d ref state=%0d opt state=%0d ref read=%b/%08x opt read=%b/%08x ref ready/error/code=%b/%b/%02x opt=%b/%b/%02x",
        case_id,cycle_count,ref_dut.state,opt_dut.state,sd_read_ref,sd_addr_ref,sd_read_dut,sd_addr_dut,
        ready_ref,error_ref,error_code_ref,ready_dut,error_dut,error_code_dut);
      $fatal(1, "catalog external output mismatch");
    end
  end

  function [7:0] byte32;
    input [31:0] x;
    input integer lane;
    begin byte32 = (x >> (lane*8)) & 8'hff; end
  endfunction

  function [7:0] sector_byte;
    input [31:0] lba;
    input integer pos;
    integer slot, off;
    begin
      sector_byte = 0;
      if (use_mbr && lba == 0) begin
        if (pos >= 446 && pos < 510) begin
          slot=(pos-446)/16; off=(pos-446)%16;
          if (off==4) sector_byte=part_type_cfg[slot];
          if (off>=8 && off<=11) sector_byte=byte32(part_start_cfg[slot],off-8);
          if (off>=12 && off<=15) sector_byte=byte32(part_size_cfg[slot],off-12);
        end
        if (pos == 510) sector_byte = 8'h55;
        if (pos == 511) sector_byte = 8'haa;
      end else if (lba == vol_base) begin
        case (pos)
          11: sector_byte = cfg_bad_bps ? 0 : 0;
          12: sector_byte = cfg_bad_bps ? 1 : 2;
          13: sector_byte = cfg_bad_spc ? 3 : cfg_spc;
          14: sector_byte = byte32(cfg_bad_reserved ? 0 : cfg_reserved,0);
          15: sector_byte = byte32(cfg_bad_reserved ? 0 : cfg_reserved,1);
          16: sector_byte = cfg_bad_fats ? 3 : cfg_fats;
          17: sector_byte = 0; 18: sector_byte = 0;
          19: sector_byte = 0; 20: sector_byte = 0;
          22: sector_byte = 0; 23: sector_byte = 0;
          32,33,34,35: sector_byte = byte32(cfg_bad_total ? 0 : cfg_total,pos-32);
          36,37,38,39: sector_byte = byte32(cfg_bad_fatsz ? 0 : cfg_fatsz,pos-36);
          40: sector_byte = cfg_extflags[7:0]; 41: sector_byte = cfg_extflags[15:8];
          42: sector_byte = 0; 43: sector_byte = 0;
          44,45,46,47: sector_byte = byte32(cfg_root,pos-44);
          510: sector_byte = 8'h55; 511: sector_byte = 8'haa;
          default: sector_byte = 0;
        endcase
        if (pos >= 446 && pos < 510) begin
          slot=(pos-446)/16; off=(pos-446)%16;
          if (off==4) sector_byte=part_type_cfg[slot];
          if (off>=8 && off<=11) sector_byte=byte32(part_start_cfg[slot],off-8);
          if (off>=12 && off<=15) sector_byte=byte32(part_size_cfg[slot],off-12);
        end
      end
    end
  endfunction

  task configure_case;
    integer k;
    input integer id;
    input integer mbr;
    input [31:0] base;
    input [31:0] pstart;
    input [31:0] psize;
    input [7:0] spc;
    input [7:0] nfats;
    input [31:0] total;
    input [31:0] fatsz;
    input [31:0] reserved;
    input [31:0] root;
    input [15:0] flags;
    input integer invalid_kind;
    begin
      case_id=id; use_mbr=mbr; vol_base=base;
      cfg_spc=spc; cfg_fats=nfats; cfg_total=total; cfg_fatsz=fatsz; cfg_reserved=reserved;
      cfg_root=root; cfg_extflags=flags;
      cfg_bad_bps=(invalid_kind==1); cfg_bad_spc=(invalid_kind==2); cfg_bad_fats=(invalid_kind==3);
      cfg_bad_reserved=(invalid_kind==4); cfg_bad_total=(invalid_kind==5); cfg_bad_fatsz=(invalid_kind==6);
      expected_enable=0; expected_root=0; expected_error=0; expected_root_addr=0;
      for (k=0;k<4;k=k+1) begin
        part_type_cfg[k]=0; part_start_cfg[k]=0; part_size_cfg[k]=0;
      end
      if (mbr) begin part_type_cfg[0]=8'h0c; part_start_cfg[0]=pstart; part_size_cfg[0]=psize; end
    end
  endtask

  task set_part;
    input integer slot;
    input [7:0] ptype;
    input [31:0] pstart;
    input [31:0] psize;
    begin part_type_cfg[slot]=ptype; part_start_cfg[slot]=pstart; part_size_cfg[slot]=psize; end
  endtask

  task expect_root_at;
    input [31:0] lba;
    begin expected_enable=1; expected_root=1; expected_error=0; expected_root_addr=lba; end
  endtask

  task expect_failure;
    input [7:0] code;
    begin expected_enable=1; expected_root=0; expected_error=code; expected_root_addr=0; end
  endtask

  task run_case;
    integer pos, serving, this_lba, clocks;
    reg done;
    begin
      rst=1; sd_init_done=0; sd_data=0; sd_valid=0; sd_end=0;
      repeat (3) @(negedge clk);
      rst=0; @(negedge clk); sd_init_done=1;
      serving=0; pos=0; this_lba=0; clocks=0; done=0;
      while (!done && clocks < 3000) begin
        @(negedge clk); clocks=clocks+1;
        sd_valid=0; sd_end=0;
        if (!serving && sd_read_ref) begin $display("TRACE REQ case=%0d lba=%08x",case_id,sd_addr_ref); serving=1; pos=0; this_lba=sd_addr_ref; end
        if (serving) begin
          if (pos < 512) begin sd_data=sector_byte(this_lba,pos); sd_valid=1; pos=pos+1; end
          else begin sd_end=1; serving=0; end
        end
        if (error_ref || (ref_dut.state==8 && sd_read_ref)) done=1;
      end
      @(negedge clk); sd_init_done=0; sd_valid=0; sd_end=0;
      if (!done) begin
        $display("TIMEOUT case=%0d state=%0d addr=%08x",case_id,ref_dut.state,sd_addr_ref);
        $fatal(1,"case failed to reach BPB decision");
      end
      if (ref_dut.state==8 && sd_read_ref && ready_ref==0 && error_ref==0) root_seen=root_seen+1;
      if (expected_enable) begin
        if (expected_root && !(ref_dut.state==8 && sd_read_ref && sd_addr_ref==expected_root_addr && !error_ref)) begin
          $display("EXPECT ROOT case=%0d want=%08x got state=%0d read=%b addr=%08x error=%b/%02x",case_id,expected_root_addr,ref_dut.state,sd_read_ref,sd_addr_ref,error_ref,error_code_ref);
          $fatal(1,"unexpected MBR selection result");
        end
        if (!expected_root && !(error_ref && error_code_ref==expected_error)) begin
          $display("EXPECT ERROR case=%0d want=%02x got error=%b/%02x state=%0d",case_id,expected_error,error_ref,error_code_ref,ref_dut.state);
          $fatal(1,"unexpected MBR selection error");
        end
      end
      $display("TRACE END case=%0d state=%0d read=%b/%08x ready=%b error=%b code=%02x fat=%08x data=%08x clusters=%08x shift=%0d bmpcount=%0d bmp0=%08x/%08x wav=%b/%08x/%08x",case_id,ref_dut.state,sd_read_ref,sd_addr_ref,ready_ref,error_ref,error_code_ref,fat_lba_ref,data_lba_ref,cluster_count_ref,shift_ref,bmp_count_ref,bmp_clusters_ref[31:0],bmp_sizes_ref[31:0],wav_found_ref,wav_cluster_ref,wav_size_ref);
      compared_cases=compared_cases+1;
    end
  endtask

  integer i;
  integer seed;
  integer r;
  integer spc_n, fats_n, cl_n;
  integer part_i, part_j, bad_variant, target_slot;
  reg [31:0] total_n, fatsz_n, base_n, psize_n;
  initial begin
    seed = 32'h61c0ffee;
    // Directed byte-stream cases: superfloppy, all SPC encodings, invalid BPB fields,
    // root high bits, extended flags, and partition-end arithmetic around 2^32.
    configure_case(0,0,0,0,0,1,1,67000,520,32,32'hf0000002,0,0); run_case();
    configure_case(1,0,0,0,0,2,2,132200,520,32,2,0,0); run_case();
    configure_case(2,0,0,0,0,4,1,265000,520,32,2,0,0); run_case();
    configure_case(3,0,0,0,0,8,2,526000,520,32,2,0,0); run_case();
    configure_case(4,0,0,0,0,16,1,1050000,520,32,2,0,0); run_case();
    configure_case(5,0,0,0,0,32,2,2100000,520,32,2,0,0); run_case();
    configure_case(6,0,0,0,0,64,1,4200000,520,32,2,0,0); run_case();
    configure_case(7,0,0,0,0,128,2,8400000,520,32,2,0,0); run_case();
    configure_case(8,0,0,0,0,1,1,67000,520,32,2,0,1); run_case();
    configure_case(9,0,0,0,0,1,1,67000,520,32,2,0,2); run_case();
    configure_case(10,0,0,0,0,1,1,67000,520,32,2,0,3); run_case();
    configure_case(11,0,0,0,0,1,1,67000,520,32,2,0,4); run_case();
    configure_case(12,0,0,0,0,1,1,67000,520,32,2,0,5); run_case();
    configure_case(13,0,0,0,0,1,1,67000,520,32,2,0,6); run_case();
    configure_case(14,0,0,0,0,1,1,67000,520,32,2,16'h0081,0); run_case();
    configure_case(15,0,0,0,0,1,1,67000,520,32,2,16'h0070,0); run_case();
    configure_case(16,1,100,100,71000,1,1,67000,520,32,2,0,0); run_case();
    configure_case(17,1,32'hffff0000,32'hffff0000,32'h00010000,1,1,67000,520,32,2,0,0); run_case();
    configure_case(18,1,32'hffff0000,32'hffff0000,32'h00010001,1,1,67000,520,32,2,0,0); run_case();
    configure_case(19,1,32'hfffffff0,32'hfffffff0,16,1,1,67000,520,32,2,0,0); run_case();
    configure_case(20,0,0,0,0,1,2,32'hffffffff,32'h80000000,32,2,0,0); run_case();

    // Deterministic randomized geometry. Legal capacities choose a cluster count
    // >= 65525 and FAT capacity >= cluster_count+2; invalid cases mutate one field
    // or partition/range data while retaining a realistic serialized BPB.
    for (i=0; i<360; i=i+1) begin
      r = $random(seed); spc_n = 1 << (r & 7);
      r = $random(seed); fats_n = ((r & 1) ? 1 : 2);
      r = $random(seed); cl_n = 65525 + ((r & 32'h7ff) % 4096);
      fatsz_n = (cl_n+2+127)/128 + (i%7);
      total_n = 32 + (fats_n*fatsz_n) + cl_n*spc_n + (i%spc_n);
      r = $random(seed);
      if ((i%4)==0) begin
        base_n = 0; psize_n = 0;
        configure_case(21+i,0,0,0,0,spc_n,fats_n,total_n,fatsz_n,32,2+((r>>4)&32'h00000fff),0,0);
      end else begin
        base_n = 100 + (r & 32'h000fffff);
        psize_n = total_n + ((i%3)==0 ? 0 : 1000);
        configure_case(21+i,1,base_n,base_n,psize_n,spc_n,fats_n,total_n,fatsz_n,32,2+((r>>4)&32'h00000fff),((i%11)==0)?16'h0080:0,0);
      end
      if ((i%13)==1) cfg_bad_spc=1;
      if ((i%17)==2) cfg_bad_fatsz=1;
      if ((i%19)==3) cfg_bad_total=1;
      if ((i%23)==4) cfg_extflags=16'h0070;
      if ((i%29)==5) begin
        use_mbr=1; set_part(0,8'h0c,32'hfffffff0,16);
        vol_base=32'hfffffff0;
      end
      if ((i%31)==6) begin
        use_mbr=1; set_part(0,8'h0c,32'hfffffff0,17);
        vol_base=32'hfffffff0;
      end
      run_case();
    end

    // Every MBR slot is selected in turn. Earlier non-FAT entries and later FAT
    // entries prove priority is the first matching slot, including byte lanes 2/3.
    for (part_i=0;part_i<4;part_i=part_i+1) begin
      base_n=32'h10203040 + part_i*32'h01000000;
      psize_n=32'h01020304;
      configure_case(500+part_i,1,base_n,base_n,psize_n,1,1,67000,520,32,2,0,0);
      for (part_j=0;part_j<4;part_j=part_j+1) begin
        if (part_j<part_i) set_part(part_j,8'h83,32'h13572468+part_j,32'h24681357+part_j);
        else if (part_j==part_i) set_part(part_j,(part_j[0]?8'h0b:8'h0c),base_n,psize_n);
        else set_part(part_j,8'h0b,base_n+32'h00100000+part_j,psize_n);
      end
      expect_root_at(base_n+552); run_case();
    end

    // A malformed first FAT partition wins selection and reports E_RANGE even
    // with a later valid FAT partition. Exercise zero start, zero size, and wrap.
    for (bad_variant=0;bad_variant<3;bad_variant=bad_variant+1) begin
      configure_case(510+bad_variant,1,32'h00123456,32'h00123456,32'h01000000,1,1,67000,520,32,2,0,0);
      for (part_j=0;part_j<4;part_j=part_j+1) begin
        if (part_j<bad_variant) set_part(part_j,8'h83,32'h00010000+part_j,32'h00020000);
        else if (part_j==bad_variant) begin
          if (bad_variant==0) set_part(part_j,8'h0b,0,32'h00020000);
          else if (bad_variant==1) set_part(part_j,8'h0c,32'h00123456,0);
          else set_part(part_j,8'h0b,32'hfffffff0,17);
        end else set_part(part_j,8'h0c,32'h00123456,32'h01000000);
      end
      expect_failure(8'h04); run_case();
    end

    // No FAT32 partition type and a valid superfloppy with misleading partition
    // bytes exercise the two opposite MBR/BPB decision paths.
    configure_case(520,1,0,0,0,1,1,67000,520,32,2,0,0);
    for (part_j=0;part_j<4;part_j=part_j+1) set_part(part_j,8'h83,32'h11112222+part_j,32'h33334444+part_j);
    expect_failure(8'h02); run_case();
    configure_case(521,0,0,0,0,1,1,67000,520,32,2,0,0);
    set_part(0,8'h0c,0,0); set_part(1,8'h0b,32'hf0000000,32'hffffffff);
    expect_root_at(552); run_case();

    // Full-width start and size lanes at slot 3, with three ignored entries.
    configure_case(522,1,32'h01234567,32'h01234567,32'h10203040,1,1,67000,520,32,2,0,0);
    set_part(0,8'h83,32'h8899aabb,32'hccddeeff);
    set_part(1,8'h83,32'h10293847,32'h56473829);
    set_part(2,8'h83,32'hfedcba98,32'h76543210);
    set_part(3,8'h0b,32'h01234567,32'h10203040);
    expect_root_at(32'h01234567+552); run_case();

    // 120 additional deterministic randomized MBR sector cases vary the chosen
    // slot, partition type, 32-bit address/size lanes, SPC, FAT count and capacity.
    for (i=0;i<120;i=i+1) begin
      r=$random(seed); spc_n=1 << (r & 7);
      r=$random(seed); fats_n=((r & 1)?1:2);
      r=$random(seed); cl_n=65525+((r & 32'h7ff)%4096);
      fatsz_n=(cl_n+2+127)/128+(i%5);
      total_n=32+(fats_n*fatsz_n)+cl_n*spc_n+(i%spc_n);
      r=$random(seed); base_n=32'h01000000+(r & 32'h0fffffff);
      psize_n=32'h02000000+(r & 32'h003fffff);
      target_slot=(r>>4)&3;
      configure_case(530+i,1,base_n,base_n,psize_n,spc_n,fats_n,total_n,fatsz_n,32,
                     2+((r>>8)&32'h00000fff),((i%9)==0)?16'h0080:0,0);
      for (part_j=0;part_j<4;part_j=part_j+1) begin
        if (part_j<target_slot) set_part(part_j,8'h83,32'h11000000+part_j,32'h22000000+part_j);
        else if (part_j==target_slot) set_part(part_j,(i[0]?8'h0c:8'h0b),base_n,psize_n);
        else set_part(part_j,(i[1]?8'h0b:8'h0c),base_n+32'h00100000+part_j,psize_n);
      end
      expect_root_at(base_n+32+fats_n*fatsz_n+(cfg_root-2)*spc_n); run_case();
    end

    if (compared_cases < 508 || root_seen < 130) $fatal(1,"coverage short cases=%0d root_accepts=%0d",compared_cases,root_seen);
    $display("PASS catalog geometry equivalence cases=%0d cycles=%0d root_accepts=%0d",compared_cases,cycle_count,root_seen);
    $finish;
  end
endmodule
