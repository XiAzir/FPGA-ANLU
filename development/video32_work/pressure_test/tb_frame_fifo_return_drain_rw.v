`timescale 1ns/1ps
module variable_delay_read_service(
  input wire clk, rst, app_rd_en, sdr_busy, sdr_ref,
  output wire sdr_rd_en,
  output reg [15:0] outstanding,
  output reg [15:0] returned_words
);
  integer cycle_no;
  integer startup_count;
  integer gap_count;
  reg seen_issue;
  wire periodic_stall = (cycle_no % 37 >= 31) ||
                        (cycle_no % 101 >= 75 && cycle_no % 101 < 86);
  assign sdr_rd_en = seen_issue && startup_count == 0 && outstanding != 0 &&
                     !sdr_busy && !sdr_ref && !periodic_stall && gap_count == 0;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      cycle_no <= 0; startup_count <= 0; gap_count <= 0;
      seen_issue <= 0; outstanding <= 0; returned_words <= 0;
    end else begin
      cycle_no <= cycle_no + 1;
      if (!seen_issue && app_rd_en) begin
        seen_issue <= 1;
        startup_count <= 32;
      end else if (seen_issue && startup_count > 0) begin
        startup_count <= startup_count - 1;
      end
      if (gap_count > 0) gap_count <= gap_count - 1;
      case ({app_rd_en, sdr_rd_en})
        2'b10: outstanding <= outstanding + 1'b1;
        2'b01: begin
          outstanding <= outstanding - 1'b1;
          returned_words <= returned_words + 1'b1;
          if (((returned_words + 1'b1) % 256) == 0) gap_count <= 7;
        end
        2'b11: begin
          returned_words <= returned_words + 1'b1;
          if (((returned_words + 1'b1) % 256) == 0) gap_count <= 7;
        end
        default: begin end
      endcase
    end
  end
endmodule

module tb_frame_fifo_return_drain;
  reg rst=1'b1, mem_clk=1'b0;
  always #5 mem_clk=~mem_clk;
  reg Sdr_init_done=1'b0;
  integer cycle_no=0;
  always @(posedge mem_clk) cycle_no<=cycle_no+1;
  wire Sdr_busy = (cycle_no % 107 >= 78 && cycle_no % 107 < 90);
  wire Sdr_init_ref_vld = (cycle_no % 193 >= 132 && cycle_no % 193 < 150);

  reg req_base=0, req_candidate=0;
  reg [20:0] read_len=512;
  reg [9:0] wrusedw=0;
  wire rd_en_base, rd_en_candidate;
  reg write_req_base=0, write_req_candidate=0;
  wire write_ack_base, write_ack_candidate, write_finish_base, write_finish_candidate;
  wire write_en_base, write_en_candidate, write_busy_base, write_busy_candidate;
  wire [20:0] write_addr_base, write_addr_candidate;
  wire write_fifo_clear_base, write_fifo_clear_candidate;
  reg overlap_base=0, overlap_candidate=0;
  reg clear_base_prev=0, clear_candidate_prev=0;
  reg [15:0] pending_at_overlap_base=0, pending_at_overlap_candidate=0;
  reg [15:0] pending_at_clear_base=0, pending_at_clear_candidate=0;
  wire [20:0] rd_addr_base, rd_addr_candidate;
  wire ack_base, ack_candidate, finish_base, finish_candidate;
  wire clear_base, clear_candidate;
  wire busy_base, busy_candidate, refill_base, refill_candidate;
  wire [15:0] outstanding_base, outstanding_candidate;
  wire [15:0] returned_base, returned_candidate;
  wire sdr_valid_base, sdr_valid_candidate;
  reg early_base=0, early_candidate=0;
  reg clear_with_pending_base=0, clear_with_pending_candidate=0;

  variable_delay_read_service service_base(
    .clk(mem_clk),.rst(rst),.app_rd_en(rd_en_base),.sdr_busy(Sdr_busy),.sdr_ref(Sdr_init_ref_vld),
    .sdr_rd_en(sdr_valid_base),.outstanding(outstanding_base),.returned_words(returned_base));
  variable_delay_read_service service_candidate(
    .clk(mem_clk),.rst(rst),.app_rd_en(rd_en_candidate),.sdr_busy(Sdr_busy),.sdr_ref(Sdr_init_ref_vld),
    .sdr_rd_en(sdr_valid_candidate),.outstanding(outstanding_candidate),.returned_words(returned_candidate));

  frame_fifo_read #(.ADDR_BITS(21),.BURST_BITS(9),.FIFO_DEPTH(512),.BURST_SIZE(256)) baseline(
    .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(Sdr_init_done),.Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy),.Sdr_rd_en(sdr_valid_base),.App_wr_busy(write_busy_base),.O_rd_busy(busy_base),
    .read_refill_request(refill_base),.App_rd_en(rd_en_base),.App_rd_addr(rd_addr_base),
    .read_req(req_base),.read_req_ack(ack_base),.read_finish(finish_base),
    .read_addr_0(21'd0),.read_addr_1(21'd230400),.read_addr_2(21'd0),.read_addr_3(21'd0),
    .read_addr_index(2'd0),.read_len(read_len),.fifo_aclr(clear_base),.wrusedw(wrusedw));
  frame_fifo_read_c32_candidate #(.ADDR_BITS(21),.BURST_BITS(9),.FIFO_DEPTH(512),.BURST_SIZE(256)) candidate(
    .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(Sdr_init_done),.Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy),.Sdr_rd_en(sdr_valid_candidate),.App_wr_busy(write_busy_candidate),.O_rd_busy(busy_candidate),
    .read_refill_request(refill_candidate),.App_rd_en(rd_en_candidate),.App_rd_addr(rd_addr_candidate),
    .read_req(req_candidate),.read_req_ack(ack_candidate),.read_finish(finish_candidate),
    .read_addr_0(21'd0),.read_addr_1(21'd230400),.read_addr_2(21'd0),.read_addr_3(21'd0),
    .read_addr_index(2'd0),.read_len(read_len),.fifo_aclr(clear_candidate),.wrusedw(wrusedw));

  wire app_rd_busy_base = busy_base || refill_base;
  wire app_rd_busy_candidate = busy_candidate || refill_candidate;
  frame_fifo_write #(.ADDR_BITS(21),.BURST_BITS(9),.BURST_SIZE(256),.FRAME_WIDTH(640),.FRAME_HEIGHT(480)) writer_base(
    .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(Sdr_init_done),.Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy),.App_rd_busy(app_rd_busy_base),.O_wr_busy(write_busy_base),
    .App_wr_en(write_en_base),.App_wr_addr(write_addr_base),.write_req(write_req_base),.write_jpeg420(1'b1),
    .write_req_ack(write_ack_base),.write_finish(write_finish_base),
    .write_addr_0(21'd0),.write_addr_1(21'd230400),.write_addr_2(21'd0),.write_addr_3(21'd0),
    .write_addr_index(2'd1),.write_len(21'd512),.fifo_aclr(write_fifo_clear_base),.rdusedw(10'd400));
  frame_fifo_write #(.ADDR_BITS(21),.BURST_BITS(9),.BURST_SIZE(256),.FRAME_WIDTH(640),.FRAME_HEIGHT(480)) writer_candidate(
    .rst(rst),.mem_clk(mem_clk),.Sdr_init_done(Sdr_init_done),.Sdr_init_ref_vld(Sdr_init_ref_vld),
    .Sdr_busy(Sdr_busy),.App_rd_busy(app_rd_busy_candidate),.O_wr_busy(write_busy_candidate),
    .App_wr_en(write_en_candidate),.App_wr_addr(write_addr_candidate),.write_req(write_req_candidate),.write_jpeg420(1'b1),
    .write_req_ack(write_ack_candidate),.write_finish(write_finish_candidate),
    .write_addr_0(21'd0),.write_addr_1(21'd230400),.write_addr_2(21'd0),.write_addr_3(21'd0),
    .write_addr_index(2'd1),.write_len(21'd512),.fifo_aclr(write_fifo_clear_candidate),.rdusedw(10'd400));
  always @(posedge mem_clk) if (!rst) begin
    if (write_en_base && outstanding_base!=0 && !overlap_base) begin overlap_base<=1; pending_at_overlap_base<=outstanding_base; end
    if (write_en_candidate && outstanding_candidate!=0 && !overlap_candidate) begin overlap_candidate<=1; pending_at_overlap_candidate<=outstanding_candidate; end
    if (baseline.state==3 && baseline.rd_burst_finish && outstanding_base!=0) begin
      early_base<=1;
      $display("BASELINE early finish at cycle %0d with %0d requested words still pending",cycle_no,outstanding_base);
    end
    if (candidate.state==3 && candidate.rd_burst_finish && outstanding_candidate!=0) begin
      early_candidate<=1;
      $display("CANDIDATE early finish at cycle %0d with %0d requested words still pending",cycle_no,outstanding_candidate);
    end
    clear_base_prev <= clear_base;
    clear_candidate_prev <= clear_candidate;
    if (clear_base && !clear_base_prev) begin
      pending_at_clear_base <= outstanding_base;
      if (outstanding_base!=0) clear_with_pending_base<=1;
    end
    if (clear_candidate && !clear_candidate_prev) begin
      pending_at_clear_candidate <= outstanding_candidate;
      if (outstanding_candidate!=0) clear_with_pending_candidate<=1;
    end
  end

  initial begin
    repeat(5) @(negedge mem_clk);
    rst=0; Sdr_init_done=1; write_req_base=1; write_req_candidate=1;
    wait(write_ack_base && write_ack_candidate);
    @(negedge mem_clk); write_req_base=0; write_req_candidate=0;
    wait(write_en_base && write_en_candidate);
    req_base=1; req_candidate=1;
    wait(ack_base && ack_candidate);
    @(negedge mem_clk); req_base=0; req_candidate=0;

    wait(early_base && overlap_base);
    @(negedge mem_clk); req_base=1; req_candidate=1;
    wait(ack_base && ack_candidate && clear_base && clear_candidate);
    #1;
    if (!clear_with_pending_base || pending_at_clear_base==0) $fatal(1,"baseline did not first-clear with pending returns");
    if (clear_with_pending_candidate || pending_at_clear_candidate!=0) $fatal(1,"candidate clear snapshot should be empty");
    if (overlap_candidate) $fatal(1,"candidate allowed JPEG writes while old read returns were pending");
    if (early_candidate)
      $fatal(1,"return-count candidate completed before BURST_SIZE returns");
    $display("PASS: first JPEG BL4 write overlapped pending returns baseline=%0d, candidate=%0d",pending_at_overlap_base,pending_at_overlap_candidate);
    $display("PASS: first FIFO clear snapshots baseline pending=%0d, candidate pending=%0d",pending_at_clear_base,pending_at_clear_candidate);
    $display("PASS: baseline_early=%0d candidate_early=%0d baseline_reset_pending=%0d candidate_reset_pending=%0d",early_base,early_candidate,clear_with_pending_base,clear_with_pending_candidate);
    $finish;
  end
  initial begin #100000; $fatal(1,"timeout"); end
endmodule




