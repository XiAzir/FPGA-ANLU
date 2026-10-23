`timescale 1ns/1ps
module tb_player_memory_runtime_probe;
    reg mem_clk=0, pixel_clk=0, rst=1;
    always #5 mem_clk=~mem_clk;
    initial begin #2; forever #7 pixel_clk=~pixel_clk; end

    reg mem_app_read=0, mem_read_valid=0, mem_app_write=0;
    reg [31:0] mem_read_word=0, mem_write_word=0;
    reg mem_read_ack=0;
    reg [3:0] mem_read_state=0;
    reg source_valid_async=0, osd_valid=0, read_req=0, read_ack_async=0;
    reg read_fifo_clear=0, pixel_underflow=0, pixel_de=0;
    reg [23:0] raw_rgb=0, gated_rgb=0;
    wire [31:0] page5;
    wire [11:0] page6_tail;

    player_memory_runtime_probe dut(.*);

    task automatic pulse_app_read;
        begin @(negedge mem_clk); mem_app_read=1; @(negedge mem_clk); mem_app_read=0; end
    endtask
    task automatic pulse_read_return(input [31:0] data);
        begin @(negedge mem_clk); mem_read_word=data; mem_read_valid=1; @(negedge mem_clk); mem_read_valid=0; mem_read_word=0; end
    endtask
    task automatic pulse_app_write(input [31:0] data);
        begin @(negedge mem_clk); mem_write_word=data; mem_app_write=1; @(negedge mem_clk); mem_app_write=0; mem_write_word=0; end
    endtask
    task automatic pulse_read_ack;
        begin @(negedge mem_clk); mem_read_ack=1; @(negedge mem_clk); mem_read_ack=0; end
    endtask
    task automatic wait_mailbox;
        begin repeat(12) @(posedge pixel_clk); #1; end
    endtask
    task automatic check(input condition, input [255:0] message);
        begin if (!condition) begin $display("FAIL: %0s page5=%h page6_tail=%h",message,page5,page6_tail); $fatal(1); end end
    endtask

    initial begin
        #19; rst=0;
        repeat(5) @(posedge pixel_clk);

        // First ACK seeds a session; its counts are intentionally not reported.
        pulse_read_ack();
        pulse_app_read(); pulse_app_read();
        pulse_read_return(32'h12345678); pulse_read_return(32'h00000000);
        pulse_app_write(32'hA5A55A5A);
        pulse_read_ack(); wait_mailbox();
        check(page5[31:28]==4'h5, "page5 tag");
        check(page5[27:20]==8'hF8, "equal session flags including nonzero read/write");
        check(page5[19:1]==19'd2 && page5[0]==1'b0, "equal session returned count");

        // Unequal counts and zero-only returned data must be observable.
        pulse_app_read(); pulse_app_read(); pulse_app_read();
        pulse_read_return(32'h00000000); pulse_read_return(32'h00000000);
        pulse_read_ack(); wait_mailbox();
        check(page5[27:20]==8'hC4, "mismatch and zero-data flags");
        check(page5[19:1]==19'd2, "mismatch session returned count");

        // Exercise pixel-domain source gate evidence and live state with no ACK.
        @(negedge pixel_clk); source_valid_async=1; osd_valid=0;
        pixel_de=1; pixel_underflow=1;
        raw_rgb=24'h102030; gated_rgb=24'h000000;
        @(negedge mem_clk); mem_read_state=4'hA;
        repeat(8) @(posedge pixel_clk); #1;
        check(page6_tail[11:8]==4'hA, "live synchronized read state without read ACK");
        check(page6_tail[7:0]==8'h46, "source gate, underflow, raw and gated RGB flags");

        // Negative control: an invalid OSD frame with leaked gated RGB must
        // set the gated-nonzero observer bit even though the source is invalid.
        @(negedge pixel_clk); gated_rgb=24'h000001;
        repeat(3) @(posedge pixel_clk); #1;
        check(page6_tail[7:0]==8'h47, "negative control detects nonzero gated RGB with osd_valid low");

        $display("PASS sessions and negative control page5=%h page6_tail=%h",page5,page6_tail);

        // Asynchronous reset clears both diagnostic pages and sticky history.
        #1 rst=1; #1;
        check(page5==32'h50000000, "reset page5");
        check(page6_tail==12'h000, "reset page6 tail");
        $display("PASS asynchronous reset page5=%h page6_tail=%h",page5,page6_tail);
        $finish;
    end
endmodule




