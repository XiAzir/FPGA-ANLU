`timescale 1ns/1ps
module tb_ack_normalization;
    reg clk=0,rst=1,ack=0;
    integer high_cycles=0;
    integer cases=0;
    sdr_init_ref dut(.Sdr_clk(clk),.Rst(rst),.Sdr_init_req(1'b0),.Sdr_init_mode(4'd2),
      .App_ref_req(1'b0),.Sdr_ref_ack(ack),.Sdr_rw_vld(1'b0));
    always #10 clk=~clk;
    task ack_level;
      input integer width;
      integer i;
      begin
        high_cycles=0;
        @(negedge clk); ack=1;
        for(i=0;i<width;i=i+1) begin
          @(posedge clk); #1;
          high_cycles=high_cycles+dut.sdr_ref_ack_sft[0];
        end
        @(negedge clk); ack=0;
        repeat(3) begin
          @(posedge clk); #1;
          high_cycles=high_cycles+dut.sdr_ref_ack_sft[0];
        end
        if(high_cycles != 1) $fatal(1,"ACK level width=%0d generated %0d triggers",width,high_cycles);
        cases=cases+1;
      end
    endtask
    initial begin
      repeat(3) @(negedge clk);
      rst=0;
      ack_level(1);
      ack_level(2);
      ack_level(3);
      ack_level(8);
      @(negedge clk); rst=1;
      repeat(2) @(negedge clk);
      if(dut.sdr_ref_ack_sft !== 0) $fatal(1,"reset failed");
      rst=0;
      ack_level(2);
      $display("ACK_EDGE_PASS cases=%0d widths=1,2,3,8,reset2",cases);
      $finish;
    end
endmodule
