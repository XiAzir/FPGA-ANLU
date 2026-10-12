`timescale 1ns/1ps
`ifndef FIFO_TEST_DEPTH
`define FIFO_TEST_DEPTH 256
`endif
module tb_fifo_bram_equivalence #(parameter integer TEST_DEPTH=`FIFO_TEST_DEPTH);
  localparam integer DEPTH=TEST_DEPTH;
  reg clk=0,rst=1,sample_take=0,drive_push=0;
  reg [15:0] drive_word=0;
  wire [15:0] old_data,new_data;
  wire old_available,new_available,old_primed,new_primed,old_error,new_error;
  wire old_push,new_push,old_read,new_read;
  wire [31:0] old_addr,new_addr;
  integer errors=0,pushes=0,pops=0,empty_bypass=0,one_item_bypass=0,full_pop_push=0,wr_wraps=0,rd_wraps=0;
  integer q_wr=0,q_rd=0,occ=0,i,round;
  reg [15:0] expected[0:8191];
  reg do_pop,do_push;

  always #10 clk=~clk;
  tf_wav_file_player_old #(.FIFO_DEPTH(DEPTH),.WAIT_LIMIT(100)) old_dut(
    .clk(clk),.rst(rst),.sd_init_done(1'b0),.file_size(32'd4096),.file_error(1'b0),
    .sd_read(old_read),.sd_addr(old_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0),
    .sample_take(sample_take),.sample_data(old_data),.sample_available(old_available),
    .primed(old_primed),.error(old_error),.debug_state(),.debug_phase(),.debug_scan_pos(),.debug_scan_byte(),
    .debug_sample_push(old_push),.debug_push_data(),.debug_push_pos(),.debug_data_offset()
  );
  tf_wav_file_player #(.FIFO_DEPTH(DEPTH),.WAIT_LIMIT(100)) new_dut(
    .clk(clk),.rst(rst),.sd_init_done(1'b0),.file_size(32'd4096),.file_error(1'b0),
    .sd_read(new_read),.sd_addr(new_addr),.sd_data(8'd0),.sd_valid(1'b0),.sd_end(1'b0),
    .sample_take(sample_take),.sample_data(new_data),.sample_available(new_available),
    .primed(new_primed),.error(new_error),.debug_state(),.debug_phase(),.debug_scan_pos(),.debug_scan_byte(),
    .debug_sample_push(new_push),.debug_push_data(),.debug_push_pos(),.debug_data_offset()
  );

  initial begin
    // Force only the request/data input. The actual accepted play_push full/pop
    // gate and all old/new FIFO pointers/count/RAM/head logic remain under RTL.
    force old_dut.play_push_req=drive_push; force new_dut.play_push_req=drive_push;
    force old_dut.prefetch_value=drive_word; force new_dut.prefetch_value=drive_word;
    repeat(3) @(posedge clk); #1; rst=0;
    repeat(2) @(posedge clk); #1;
    if(old_available||new_available) fail("reset empty");

    // Empty->one: same-address RAM read/write is hidden by fresh-data bypass.
    push_word(16'h1111,0); check_head(16'h1111,"empty first write");
    if(empty_bypass!=1) fail("empty bypass not exercised");
    // One-item pop+push: next head is the new word at the read address.
    push_word(16'h2222,1); check_head(16'h2222,"one-item pop+push");
    if(one_item_bypass!=1) fail("one-item bypass not exercised");
    pop_only(); if(old_available||new_available) fail("drain empty");

    // Empty after pointer advance, then refill and wrap read/write pointers.
    push_word(16'h3333,0); pop_only();
    for(i=0;i<DEPTH;i=i+1) push_word(16'h4000+i,0);
    if(occ!=DEPTH) fail("fill depth");
    push_word(16'h7eee,0);
    if(old_push||new_push) fail("full write must be rejected");
    push_word(16'h7fff,1);
    if(full_pop_push!=1) fail("full pop+push not exercised");
    for(i=1;i<DEPTH;i=i+1) pop_only();
    check_head(16'h7fff,"full pop+push preserves tail"); pop_only();
    if(occ!=0||old_available||new_available) fail("full drain");
    if(wr_wraps<1 || rd_wraps<1) fail("pointer wrap missing");
    // Repeated wraps with bursty write/read and simultaneous transfer.
    for(round=0;round<5;round=round+1) begin
      for(i=0;i<73;i=i+1) push_word((round*73+i)^16'h5a00,0);
      for(i=0;i<29;i=i+1) pop_only();
      for(i=0;i<29;i=i+1) push_word((round*73+i)^16'ha500,1);
      while(occ>0) pop_only();
    end

    // Reset with live contents; stale RAM q must not become valid.
    for(i=0;i<9;i=i+1) push_word(16'h9000+i,0);
    @(negedge clk); rst=1; sample_take=0; drive_push=0;
    repeat(2) @(posedge clk); #1; rst=0;
    q_wr=0;q_rd=0;occ=0;
    repeat(2) @(posedge clk); #1;
    if(old_available||new_available) fail("reset nonempty");
    push_word(16'hcafe,0); check_head(16'hcafe,"post-reset first word"); pop_only();

    if(errors==0)
      $display("PASS tb_fifo_bram_equivalence depth=%0d pushes=%0d pops=%0d empty_bypass=%0d one_item_bypass=%0d full_pop_push=%0d wr_wraps=%0d rd_wraps=%0d",DEPTH,pushes,pops,empty_bypass,one_item_bypass,full_pop_push,wr_wraps,rd_wraps);
    else $fatal(1,"FAIL tb_fifo_bram_equivalence errors=%0d",errors);
    $finish;
  end

  task fail(input [8*100-1:0] msg);
    begin
      $display("FAIL %0s old(av=%b data=%04h push=%b) new(av=%b data=%04h push=%b) occ=%0d",msg,old_available,old_data,old_push,new_available,new_data,new_push,occ);
      errors=errors+1;
    end
  endtask
  task check_pair(input [8*100-1:0] msg);
    begin
      if(old_available!==new_available) fail({"available ",msg});
      if(old_available && old_data!==new_data) fail({"head ",msg});
      if(old_push!==new_push) fail({"push ",msg});
    end
  endtask
  task tick(input [8*100-1:0] msg);
    begin
      #1; check_pair(msg);
      do_pop=sample_take && old_available;
      do_push=old_push;
      if(do_push && (old_dut.prefetch_needed && old_dut.fifo_next_count!=0) && old_dut.wr_ptr==old_dut.prefetch_ptr) begin
        if(occ==0) empty_bypass=empty_bypass+1;
        else if(do_pop && occ==1) one_item_bypass=one_item_bypass+1;
      end
      if(do_push && old_dut.wr_ptr==DEPTH-1) wr_wraps=wr_wraps+1;
      if(do_pop && old_dut.rd_ptr==DEPTH-1) rd_wraps=rd_wraps+1;
      if(do_push && do_pop && occ==DEPTH) full_pop_push=full_pop_push+1;
      if(do_pop) begin
        if(occ==0) fail("scoreboard underflow");
        else begin
          if(old_data!==expected[q_rd]) fail("old sequence vs scoreboard");
          if(new_data!==expected[q_rd]) fail("new sequence vs scoreboard");
          q_rd=q_rd+1;occ=occ-1;pops=pops+1;
        end
      end
      if(do_push) begin expected[q_wr]=drive_word;q_wr=q_wr+1;occ=occ+1;pushes=pushes+1;end
      @(posedge clk); #1; check_pair(msg);
      if(old_dut.fifo_count!==new_dut.fifo_count || old_dut.wr_ptr!==new_dut.wr_ptr || old_dut.rd_ptr!==new_dut.rd_ptr) fail("internal count/pointer mismatch");
      if((occ==0)!==(!old_available) || (occ==0)!==(!new_available)) fail({"valid/count ",msg});
      if(occ>0) begin
        if(old_data!==expected[q_rd]) fail("old next word vs scoreboard");
        if(new_data!==expected[q_rd]) fail("new next word vs scoreboard");
      end
    end
  endtask
  task push_word(input [15:0] w,input pop_current);
    begin
      @(negedge clk); drive_word=w;drive_push=1;sample_take=pop_current;
      tick("push");
      @(negedge clk);drive_push=0;sample_take=0;
    end
  endtask
  task pop_only;
    begin
      @(negedge clk);drive_push=0;sample_take=1;
      tick("pop");
      @(negedge clk);sample_take=0;
    end
  endtask
  task check_head(input [15:0] want,input [8*100-1:0] msg);
    begin
      #1;check_pair(msg);
      if(!old_available||!new_available||old_data!==want||new_data!==want) fail({"expected ",msg});
    end
  endtask
endmodule


