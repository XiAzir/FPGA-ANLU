`timescale 1ns/1ps
// SPI-mode-3 SDHC read-only card model for the production sd_card_top.
// Compact sector records plus an explicit LBA table keep simulator array
// overhead bounded. Unmapped LBAs and any X byte are fatal.
module sd_spi_card_model #(
    parameter IMAGE_BYTES = 67108864,
    parameter MAPPED_SECTORS = 2073,
    parameter IMAGE_FILE = "packed_mem.mem",
    parameter LBA_MAP_FILE = "lba_map.mem"
)(
    input wire cs_n,
    input wire sck,
    input wire mosi,
    output reg miso,
    output integer command_count,
    output integer read_count,
    output reg [31:0] last_lba,
    output reg protocol_error
);
    reg [4095:0] image [0:MAPPED_SECTORS-1];
    reg [31:0] lba_map [0:MAPPED_SECTORS-1];
    reg [7:0] tx_queue [0:520];
    integer tx_len, tx_byte;
    reg tx_active;
    reg [7:0] rx_shift;
    integer bit_count;
    reg [7:0] cmd_bytes [0:5];
    integer cmd_count;
    reg initialized;
    integer app_cmd_pending;
    integer i, k, found_idx;
    reg [7:0] cmd_index;
    reg [31:0] arg;
    reg [15:0] crc;
    reg [7:0] b;

    function [15:0] crc16_byte;
        input [15:0] ci;
        input [7:0] d;
        reg [15:0] c;
        integer n;
        begin
            c = ci ^ {d,8'h00};
            for (n=0;n<8;n=n+1)
                if (c[15]) c=(c<<1)^16'h1021; else c=c<<1;
            crc16_byte=c;
        end
    endfunction

    task queue_byte;
        input [7:0] value;
        begin tx_queue[tx_len]=value; tx_len=tx_len+1; end
    endtask

    task queue_r1;
        input [7:0] value;
        begin
            tx_len=0; tx_byte=0; tx_active=1;
            queue_byte(value);
        end
    endtask

    task process_command;
        begin
            command_count = command_count + 1;
            cmd_index = cmd_bytes[0] & 8'h3f;
            arg = {cmd_bytes[1],cmd_bytes[2],cmd_bytes[3],cmd_bytes[4]};
            case (cmd_index)
                0: begin // CMD0: idle
                    initialized=0; app_cmd_pending=0; queue_r1(8'h01);
                end
                8: begin // CMD8: R7 (2.7-3.6V, check pattern AA)
                    queue_r1(8'h01); queue_byte(8'h00); queue_byte(8'h00);
                    queue_byte(8'h01); queue_byte(8'haa);
                end
                55: begin // CMD55: application-command prefix
                    app_cmd_pending=1;
                    if (initialized) queue_r1(8'h00); else queue_r1(8'h01);
                end
                41: begin // ACMD41: ready immediately after one valid request
                    if (!app_cmd_pending) begin
                        protocol_error=1; queue_r1(8'h04);
                    end else begin
                        initialized=1; app_cmd_pending=0; queue_r1(8'h00);
                    end
                end
                16: begin // CMD16: accept 512-byte block length
                    if (arg != 512) begin protocol_error=1; queue_r1(8'h40); end
                    else if (initialized) queue_r1(8'h00);
                    else begin protocol_error=1; queue_r1(8'h04); end
                end
                17: begin // CMD17: SDHC block-addressed read
                    if (!initialized) begin protocol_error=1; queue_r1(8'h04); end
                    else if (arg > (IMAGE_BYTES/512)-1) begin
                        protocol_error=1; queue_r1(8'h20);
                    end else begin
                        found_idx=-1;
                        for (k=0;k<MAPPED_SECTORS;k=k+1)
                            if (lba_map[k] === arg) found_idx=k;
                        if (found_idx<0) begin
                            $display("FATAL: SD LBA %0d is not present in explicit LBA map %0s",arg,LBA_MAP_FILE);
                            $fatal(1);
                        end
                        last_lba=arg; read_count=read_count+1;
                        tx_len=0; tx_byte=0; tx_active=1;
                        queue_byte(8'h00); queue_byte(8'hff); queue_byte(8'hff); queue_byte(8'hfe);
                        crc=16'h0000;
                        for (k=0;k<512;k=k+1) begin
                            b=(image[found_idx] >> ((511-k)*8)) & 8'hff;
                            if ((^b) === 1'bx) begin
                                $display("FATAL: SD image byte X at LBA %0d offset %0d",arg,k);
                                $fatal(1);
                            end
                            queue_byte(b); crc=crc16_byte(crc,b);
                        end
                        queue_byte(crc[15:8]); queue_byte(crc[7:0]);
                    end
                end
                default: begin
                    protocol_error=1; queue_r1(8'h04);
                    $display("SD model unsupported CMD%0d arg=%08x",cmd_index,arg);
                end
            endcase
        end
    endtask

    initial begin
        miso=1'b1; command_count=0; read_count=0; last_lba=0;
        protocol_error=0; initialized=0; app_cmd_pending=0;
        tx_len=0; tx_byte=0; tx_active=0; bit_count=0; rx_shift=0; cmd_count=0;
        for (i=0;i<=520;i=i+1) tx_queue[i]=8'hff;
        $display("SD model loading %0d mapped sectors from %0s and %0s (geometry %0d bytes)",MAPPED_SECTORS,IMAGE_FILE,LBA_MAP_FILE,IMAGE_BYTES);
        $readmemh(IMAGE_FILE,image);
        $readmemh(LBA_MAP_FILE,lba_map);
    end

    // Production spi_master is CPOL=1, CPHA=1: receive on rising SCK,
    // present the following MISO bit on falling SCK.
    always @(posedge sck or posedge cs_n) begin
        if (cs_n) begin
            bit_count=0; rx_shift=0; cmd_count=0;
            tx_len=0; tx_byte=0; tx_active=0; miso=1'b1;
        end else begin
            rx_shift={rx_shift[6:0],mosi};
            bit_count=bit_count+1;
            if (bit_count==8) begin
                bit_count=0;
                if (tx_active && tx_byte < tx_len) tx_byte=tx_byte+1;
                if (cmd_count==0) begin
                    if ((rx_shift & 8'hc0)==8'h40) begin
                        cmd_bytes[0]=rx_shift; cmd_count=1;
                    end
                end else begin
                    cmd_bytes[cmd_count]=rx_shift; cmd_count=cmd_count+1;
                    if (cmd_count==6) begin cmd_count=0; process_command; end
                end
            end
        end
    end

    always @(negedge sck or posedge cs_n) begin
        if (cs_n) miso=1'b1;
        else if (tx_byte>=tx_len || !tx_active) miso=1'b1;
        else miso=tx_queue[tx_byte][7-bit_count];
    end
endmodule
