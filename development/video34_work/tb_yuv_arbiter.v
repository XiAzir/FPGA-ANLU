`timescale 1ns/1ps
module tb_yuv_arbiter;
    reg clk=0,rst=1;always #5 clk=~clk;
    integer cycle=0;
    reg init_done=0,refresh=0,busy=0;
    reg cmd_valid=0;
    reg [20:0] cmd_address=0;
    wire cmd_ready,rd_valid;
    wire [31:0] rd_data;
    reg wr_valid=0;
    wire wr_ready;
    reg [20:0] wr_address=21'h10000;
    wire [31:0] wr_data=32'hdead0000^wr_address;
    wire idle,app_rd,app_wr;
    wire [20:0] app_raddr,app_waddr;
    wire [31:0] app_wdata;
    wire [3:0] app_mask;
    reg sdr_valid=0;
    reg [31:0] sdr_data=0;
    yuv_sdram_burst_arbiter dut(
        .clk(clk),.rst(rst),.init_done(init_done),.refresh_valid(refresh),.sdr_busy(busy),
        .rd_cmd_valid(cmd_valid),.rd_cmd_ready(cmd_ready),.rd_cmd_address(cmd_address),
        .rd_valid(rd_valid),.rd_data(rd_data),.wr_valid(wr_valid),.wr_ready(wr_ready),
        .wr_address(wr_address),.wr_data(wr_data),.idle(idle),
        .app_rd_en(app_rd),.app_rd_address(app_raddr),.app_wr_en(app_wr),.app_wr_address(app_waddr),
        .app_wr_data(app_wdata),.app_wr_mask(app_mask),.sdr_rd_valid(sdr_valid),.sdr_rd_data(sdr_data));
    integer q_addr[0:1023],q_due[0:1023],head=0,tail=0;
    integer issue_count=0,return_count=0,command_count=0,writes=0;
    integer command_pending=0,burst_position=0;
    reg leading_pending=0;
    integer write_gap=0;
    function [31:0] memory_word;
        input [20:0] address;
        begin memory_word=32'h5a3c0000^{11'b0,address};end
    endfunction
    initial begin
        repeat(4) @(negedge clk);rst=0;
        repeat(3) @(negedge clk);init_done=1;
        repeat(3) @(negedge clk);wr_valid=1;
        wait(writes==256 && return_count==128);
        repeat(6) @(negedge clk);
        if(tail!=head || command_pending!=0 || !idle) $fatal(1,"DRAIN_FAIL");
        $display("PASS commands=%0d reads=%0d returns=%0d writes=%0d",command_count,issue_count,return_count,writes);
        $finish;
    end
    always @(posedge clk) if(!rst) begin
        cycle<=cycle+1;
        if(app_rd && app_wr) $fatal(1,"READ_WRITE_OVERLAP");
        if(!init_done && (app_rd||app_wr)) $fatal(1,"EARLY_REQUEST");
        if(cmd_valid && cmd_ready) begin
            if(command_pending!=0) $fatal(1,"NEW_READ_BEFORE_RETURNS");
            command_count=command_count+1;command_pending=4;burst_position=0;
        end
        if(app_rd) begin
            if(app_raddr!==cmd_address+burst_position) $fatal(1,"READ_ADDRESS");
            q_addr[tail]=app_raddr;q_due[tail]=cycle+6+(issue_count%19);tail=tail+1;
            issue_count=issue_count+1;burst_position=burst_position+1;
        end
        if(rd_valid) begin
            if(rd_data!==memory_word(q_addr[head])) $fatal(1,"READ_DATA head=%0d actual=%08x expected=%08x",head,rd_data,memory_word(q_addr[head]));
            head=head+1;return_count=return_count+1;command_pending=command_pending-1;
        end
        if(app_wr) begin
            if(command_pending!=0) $fatal(1,"WRITE_BEFORE_READ_RETURNS pending=%0d",command_pending);
            if(app_waddr!==21'h10000+writes || app_wdata!==(32'hdead0000^(21'h10000+writes)) || app_mask!=0)
                $fatal(1,"WRITE_DATA");
            writes=writes+1;
        end
        if(cycle>20000) $fatal(1,"TIMEOUT reads=%0d writes=%0d",return_count,writes);
    end
    always @(negedge clk) if(!rst) begin
        refresh=(cycle%101>=94);
        busy=(cycle%67>=61);
        if(cmd_valid && cmd_ready) begin end
        if(command_count<32 && command_pending==0 && cycle%57==0) begin
            cmd_valid=1;cmd_address=21'h1000+command_count*64;
        end else if(command_pending!=0) cmd_valid=0;
        if(writes<256) begin
            wr_address=21'h10000+writes;
            wr_valid=1;
        end else wr_valid=0;
        if(leading_pending) begin
            sdr_valid=1;leading_pending=0;
            if(head+1<tail && q_due[head+1]<=cycle+1) begin
                sdr_data=memory_word(q_addr[head+1]);leading_pending=1;
            end
        end else begin
            sdr_valid=0;
            if(head<tail && q_due[head]<=cycle) begin
                sdr_data=memory_word(q_addr[head]);leading_pending=1;
            end
        end
    end
endmodule
