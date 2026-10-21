`timescale 1ns/1ps
module tb_fat32_dual_file_sector;
    reg clk=0, rst=1;
    always #5 clk=~clk;
    reg bmp_enable=1, wav_enable=1;
    reg [31:0] bmp_start=2, wav_start=2;
    reg [31:0] bmp_size=512, wav_size=1536;
    reg bmp_read=0, wav_read=0;
    reg [31:0] bmp_sector=0, wav_sector=2;
    wire [7:0] bmp_data, wav_data;
    wire bmp_valid, wav_valid, bmp_end, wav_end, bmp_error, wav_error;
    wire [7:0] bmp_error_code, wav_error_code;
    wire sd_read;
    wire [31:0] sd_addr;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;
    integer txn_count=0, wav_bytes=0, bmp_bytes=0, ticks=0;
    reg [31:0] txn_addr[0:3];
    reg wav_first_ok=0, bmp_first_ok=0, saw_wav_end=0, saw_bmp_end=0;

    fat32_dual_file_sector #(.WAIT_LIMIT(2000),.AUDIO_BURST_MAX(2)) dut(
        .clk(clk),.rst(rst),.fat_lba(32'd200),.data_lba(32'd100),
        .cluster_count(32'd20),.sectors_per_cluster_shift(4'd0),
        .bmp_enable(bmp_enable),.bmp_start_cluster(bmp_start),.bmp_file_size(bmp_size),
        .bmp_file_read(bmp_read),.bmp_file_sector(bmp_sector),
        .bmp_file_data(bmp_data),.bmp_file_valid(bmp_valid),.bmp_file_end(bmp_end),
        .bmp_error(bmp_error),.bmp_error_code(bmp_error_code),
        .wav_enable(wav_enable),.wav_start_cluster(wav_start),.wav_file_size(wav_size),
        .wav_file_read(wav_read),.wav_file_sector(wav_sector),
        .wav_file_data(wav_data),.wav_file_valid(wav_valid),.wav_file_end(wav_end),
        .wav_error(wav_error),.wav_error_code(wav_error_code),
        .sd_read(sd_read),.sd_addr(sd_addr),.sd_data(sd_data),
        .sd_valid(sd_valid),.sd_end(sd_end)
    );

    // Deterministic 512-byte card model. FAT[2]=3, FAT[3]=4.
    initial begin
        forever begin
            wait(sd_read===1'b1);
            if (txn_count < 4) txn_addr[txn_count]=sd_addr;
            txn_count=txn_count+1;
            for (integer n=0;n<512;n=n+1) begin
                @(negedge clk);
                sd_valid=1;
                if (sd_addr==200 && n==8) sd_data=8'd3;
                else if (sd_addr==200 && n==12) sd_data=8'd4;
                else if (sd_addr==100) sd_data=8'h22;
                else if (sd_addr==102) sd_data=8'h11;
                else sd_data=0;
            end
            @(negedge clk); sd_valid=0; sd_end=1;
            @(negedge clk); sd_end=0;
            wait(sd_read===1'b0);
        end
    end

    always @(posedge clk) begin
        ticks <= ticks+1;
        if (wav_valid) begin
            wav_bytes <= wav_bytes+1;
            if (!wav_first_ok) wav_first_ok <= (wav_data==8'h11);
        end
        if (bmp_valid) begin
            bmp_bytes <= bmp_bytes+1;
            if (!bmp_first_ok) bmp_first_ok <= (bmp_data==8'h22);
        end
        if (wav_end) saw_wav_end<=1;
        if (bmp_end) saw_bmp_end<=1;
        if (ticks>5000) begin $display("FAIL timeout tx=%0d addrs=%0d,%0d,%0d,%0d state=%0d bc=%0d off=%0d cluster=%0d walk=%0d target=%0d queued=%b%b busy=%b%b end=%b%b bytes=%0d/%0d err=%b/%h",txn_count,txn_addr[0],txn_addr[1],txn_addr[2],txn_addr[3],dut.core_state,dut.byte_count,dut.wanted_offset,dut.current_cluster[1],dut.walk_index[1],dut.target_index[1],dut.queued[1],dut.queued[0],dut.busy[1],dut.busy[0],saw_wav_end,saw_bmp_end,wav_bytes,bmp_bytes,wav_error,wav_error_code); $fatal(1); end
    end

    initial begin
        repeat(4) @(negedge clk); rst=0;
        repeat(3) @(negedge clk);
        bmp_read=1; wav_read=1;
        wait(saw_wav_end && saw_bmp_end);
        repeat(3) @(negedge clk);
        if (wav_error || bmp_error) begin
            $display("FAIL sticky errors wav=%h bmp=%h",wav_error_code,bmp_error_code); $fatal(1);
        end
        if (wav_bytes!=512 || bmp_bytes!=512 || !wav_first_ok || !bmp_first_ok) begin
            $display("FAIL stream bytes wav=%0d bmp=%0d first=%b/%b",wav_bytes,bmp_bytes,wav_first_ok,bmp_first_ok); $fatal(1);
        end
        if (txn_count!=4 || txn_addr[0]!=200 || txn_addr[1]!=200 ||
            txn_addr[2]!=100 || txn_addr[3]!=102) begin
            $display("FAIL arbitration count=%0d addresses=%0d,%0d,%0d,%0d",txn_count,txn_addr[0],txn_addr[1],txn_addr[2],txn_addr[3]); $fatal(1);
        end
        $display("PASS shared mapper, 2-sector WAV burst cap, independent walk contexts");
        $finish;
    end
endmodule
