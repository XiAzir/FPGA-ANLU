`timescale 1ns/1ps
module tb_c23_mode_restart;
  reg video_clk=0, sd_clk=0, rst=1;
  reg mode_press=0, restart_toggle_async=0;
  reg commit_toggle=0, card_idle=0, mount_ready=0;
  reg mapper_request=0;
  reg [31:0] photo_sector=32'h00001234, video_sector=32'h00005678;
  wire request_toggle, ack_toggle, video_mode, media_reset;
  wire gate_new_sector, quiesce_commit, quiesce_busy;
  reg [1:0] video_mode_sd_sync=0;
  wire [31:0] selected_sector_addr=video_mode_sd_sync[1] ? video_sector : photo_sector;
  wire runtime_sector_read=mapper_request && !gate_new_sector;
  reg [1:0] req_sync=0, ack_sync=0;
  integer video_half_ns, sd_half_ns, video_phase_ns;
  integer n, reset_cycles, total_commits, total_media_resets;
  integer old_mode, old_req, old_commit, old_reset_count;
  reg commit_seen;

  initial begin
    if(!$value$plusargs("VHALF=%d",video_half_ns)) video_half_ns=20;
    if(!$value$plusargs("SHALF=%d",sd_half_ns)) sd_half_ns=10;
    if(!$value$plusargs("PHASE=%d",video_phase_ns)) video_phase_ns=0;
    fork
      begin forever #(sd_half_ns) sd_clk=~sd_clk; end
      begin #(video_phase_ns); forever #(video_half_ns) video_clk=~video_clk; end
    join
  end

  player_media_restart u_media_restart(
    .clk(video_clk),.rst(rst),.mode_press(mode_press),
    .restart_toggle_async(restart_toggle_async),.commit_toggle_async(quiesce_commit),
    .request_toggle(request_toggle),.ack_toggle(ack_toggle),
    .video_mode(video_mode),.media_reset(media_reset));
  player_mode_quiesce u_mode_quiesce(
    .clk(sd_clk),.rst(rst),.request_toggle_async(request_toggle),.ack_toggle_async(ack_toggle),
    .physical_idle(card_idle),.mount_ready(mount_ready),
    .gate_new_sector(gate_new_sector),.commit_toggle(quiesce_commit),.busy(quiesce_busy));

  always @(posedge media_reset) total_media_resets=total_media_resets+1;
  always @(posedge video_clk) begin
    if(rst) begin req_sync<=0;ack_sync<=0;video_mode_sd_sync<=0; end
    else begin
      req_sync<={req_sync[0],request_toggle};ack_sync<={ack_sync[0],ack_toggle};
      video_mode_sd_sync<={video_mode_sd_sync[0],video_mode};
    end
  end

  task fail;
    input [8*96-1:0] msg;
    begin $display("FAIL %0s t=%0t mode=%0d req/ack=%0d/%0d gate=%0d commit=%0d idle=%0d mount=%0d",
      msg,$time,video_mode,request_toggle,ack_toggle,gate_new_sector,quiesce_commit,card_idle,mount_ready);$fatal(1);end
  endtask

  task pulse_mode_press;
    begin
      @(negedge video_clk);mode_press=1;
      @(negedge video_clk);mode_press=0;
    end
  endtask

  task pulse_busy_mode_press;
    reg saved_req;
    begin
      saved_req=request_toggle;
      pulse_mode_press();
      @(negedge sd_clk);restart_toggle_async=~restart_toggle_async;
      repeat(5) @(posedge video_clk);
      if(request_toggle!==saved_req) fail("busy mode/restart event created duplicate request");
    end
  endtask

  task measure_reset_32;
    begin
      if(!media_reset) @(posedge media_reset);
      reset_cycles=0;
      while(media_reset) begin
        @(negedge video_clk);
        if(media_reset) reset_cycles=reset_cycles+1;
      end
      if(reset_cycles!=32) begin
        $display("RESET_WIDTH got=%0d video_half=%0d phase=%0d",reset_cycles,video_half_ns,video_phase_ns);
        fail("media reset did not span exactly 32 video cycles");
      end
    end
  endtask

  task trigger_and_complete;
    input integer is_mode;
    input integer expect_mode;
    input integer hold_busy_event;
    input integer is_restart;
    reg [31:0] accepted_sector_addr;
    begin
      old_mode=video_mode;old_req=request_toggle;old_commit=quiesce_commit;old_reset_count=total_media_resets;
      accepted_sector_addr=selected_sector_addr;
      if(is_restart) begin
        @(negedge sd_clk);restart_toggle_async=~restart_toggle_async;
      end else pulse_mode_press();
      n=0;
      while(request_toggle==old_req && n<100) begin @(posedge video_clk);n=n+1;end
      if(request_toggle==old_req) fail("media request toggle timeout");
      if(video_mode!==old_mode) fail("mode changed before drain commit");
      if(!mount_ready) begin
        repeat(6) @(posedge sd_clk);
        if(gate_new_sector || quiesce_commit!=old_commit || video_mode!==old_mode)
          fail("pre-mount request blocked catalog or committed early");
        card_idle=1;
        mount_ready=1;
        wait(gate_new_sector);
      end else wait(gate_new_sector);
      if(!quiesce_busy) fail("gate asserted without busy");
      if(card_idle===1'b0) begin
        repeat(6) @(posedge sd_clk);
        if(quiesce_commit!=old_commit || video_mode!==old_mode) fail("commit/mode changed while physical request active");
        if(selected_sector_addr!==accepted_sector_addr) fail("selected file sector changed while request active");
        if(!gate_new_sector) fail("gate dropped during physical drain");
        mapper_request=1;
        #1;
        if(runtime_sector_read) fail("runtime request passed while gate active");
        if(hold_busy_event) pulse_busy_mode_press();
        card_idle=1;
      end
      wait(quiesce_commit!=old_commit);
      total_commits=total_commits+1;
      measure_reset_32();
      if(!gate_new_sector) fail("gate dropped before peer reset/ack");
      if(video_mode!==expect_mode) fail("mode commit value mismatch");
      if(expect_mode!=old_mode) begin
        n=0;
        while(selected_sector_addr===accepted_sector_addr && n<20)begin @(posedge sd_clk);n=n+1;end
        if(selected_sector_addr!==(expect_mode ? video_sector : photo_sector)) fail("SD-domain file address did not follow committed mode");
        if(!gate_new_sector || runtime_sector_read) fail("new file address reached physical request before ack");
      end
      if(total_media_resets!=old_reset_count+1) fail("restart did not produce exactly one reset");
      if(!media_reset && ack_toggle==request_toggle) begin end
      else begin
        n=0;while(ack_toggle!=request_toggle && n<100)begin @(posedge video_clk);n=n+1;end
      end
      if(ack_toggle!==request_toggle) fail("media ack toggle timeout");
      n=0;while(gate_new_sector && n<100)begin @(posedge sd_clk);n=n+1;end
      if(gate_new_sector || quiesce_busy) fail("gate/busy did not release after ack");
      mapper_request=1;
      #1;
      if(!runtime_sector_read) fail("mapper request not forwarded after ack");
      mapper_request=0;
      repeat(10) @(posedge video_clk);
      if(request_toggle!==ack_toggle || quiesce_commit==old_commit) fail("delayed duplicate event after ack");
      $display("PASS mode_event=%0d restart=%0d mode=%0d reset_cycles=%0d half(video/sd)=%0d/%0d phase=%0d",
        is_mode,is_restart,video_mode,reset_cycles,video_half_ns,sd_half_ns,video_phase_ns);
    end
  endtask

  initial begin
    #1;total_commits=0;total_media_resets=0;reset_cycles=0;
    #250;@(negedge sd_clk);rst=0;
    // A request before catalog mount is retained, while catalog reads stay enabled.
    trigger_and_complete(1,1,0,0);
    // Video -> photo. Hold an in-flight sector and inject a duplicate event while busy.
    card_idle=0;
    trigger_and_complete(1,0,1,0);
    // Photo -> video, then a same-mode runtime restart from video.
    card_idle=0;
    trigger_and_complete(1,1,0,0);
    card_idle=0;
    trigger_and_complete(0,1,0,1);
    if(total_media_resets!=4 || total_commits!=4) fail("unexpected duplicate or missing commit/reset");
    $display("PASS C23 restart control: mount-pending, both directions, busy duplicate, same-mode restart, 32 cycles, mapper release");
    $finish;
  end
  initial begin #1000000; fail("global watchdog"); end
endmodule
