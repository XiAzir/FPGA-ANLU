`timescale 1ns/1ps

module scaler_bad_case #(
    parameter NAME = "bad_case",
    parameter integer KIND = 0,
    parameter BAD_MEM = "",
    parameter integer BAD_BYTES = 230454
)(input wire clk, input wire rst, output reg finished=0);
    localparam integer FW=32, FH=24, GOOD_BYTES=230454, PIXELS=FW*FH;
    reg [7:0] good_bytes[0:GOOD_BYTES-1];
    reg [7:0] bad_bytes[0:230453];
    reg key_next=0, key_auto=0, catalog_ready=0;
    reg [2:0] bmp_count=2;
    reg [127:0] bmp_clusters=0, bmp_sizes=0;
    wire [31:0] file_cluster, file_size, card_addr;
    wire card_read;
    reg [7:0] card_data=0;
    reg card_valid=0, card_end=0, file_error=0;
    reg write_finish_toggle=0, display_finish_toggle=0;
    wire [1:0] write_buf_idx, disp_buf_idx, current_image_index;
    wire write_req, write_en, display_valid, error, auto_mode;
    reg write_req_ack=0, write_ready=1;
    wire [23:0] write_data;
    wire [3:0] state_code;
    integer all_words=0, first_words=0, second_words=0;
    integer card_requests=0, first_card_requests=0;
    integer i, sector_addr, byte_no, source_pos, selected_kind;
    reg [1:0] old_buf;
    reg [1:0] old_image;

    initial begin
        $readmemh("test_media/bmp_320x240_bottomup_source_bytes.mem", good_bytes, 0, GOOD_BYTES-1);
        $readmemh(BAD_MEM, bad_bytes, 0, BAD_BYTES-1);
        bmp_clusters[31:0]=1; bmp_clusters[63:32]=2;
        bmp_sizes[31:0]=GOOD_BYTES; bmp_sizes[63:32]=GOOD_BYTES;
    end

    tf_bmp_file_player #(.CLK_FREQ_HZ(1000),.FRAME_WIDTH(FW),.FRAME_HEIGHT(FH),.WAIT_LIMIT(10000000)) dut(
        .clk(clk),.rst(rst),.key_next(key_next),.key_auto(key_auto),
        .catalog_ready(catalog_ready),.bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),
        .file_cluster(file_cluster),.file_size(file_size),.card_read(card_read),.card_addr(card_addr),
        .card_data(card_data),.card_valid(card_valid),.card_end(card_end),.file_error(file_error),
        .write_finish_toggle(write_finish_toggle),.display_finish_toggle(display_finish_toggle),
        .write_buf_idx(write_buf_idx),.disp_buf_idx(disp_buf_idx),.write_req(write_req),
        .write_req_ack(write_req_ack),.write_ready(write_ready),.write_en(write_en),.write_data(write_data),
        .display_valid(display_valid),.error(error),.state_code(state_code),
        .current_image_index(current_image_index),.auto_mode(auto_mode)
    );

    always @(negedge clk) if (!rst && write_en) begin
        all_words=all_words+1;
        if (current_image_index==0 && state_code!=4'd9) first_words=first_words+1;
        else second_words=second_words+1;
    end

    // Real 512-byte sector framing with byte gaps; modes 0/1/2/3 exercise
    // zero dimension / unsupported width / short first sector / truncation.
    initial begin : card_model
        forever begin
            wait(card_read===1'b1);
            @(negedge clk);
            sector_addr=card_addr;
            selected_kind=(file_cluster==2) ? KIND : -1;
            card_requests=card_requests+1;
            if (file_cluster==1) first_card_requests=first_card_requests+1;
            repeat(3) @(negedge clk);
            byte_no=0;
            while (byte_no<512) begin
                if ((byte_no%41)==9) repeat(2) @(negedge clk);
                source_pos=sector_addr*512+byte_no;
                if (selected_kind==2 && sector_addr==0 && byte_no==511) begin
                    card_end=1;
                    @(negedge clk);
                    card_end=0;
                    wait(card_read===1'b0);
                    byte_no=512;
                end else if (selected_kind==3 && source_pos>=BAD_BYTES) begin
                    file_error=1;
                    card_end=1;
                    @(negedge clk);
                    file_error=0; card_end=0;
                    wait(card_read===1'b0);
                    byte_no=512;
                end else begin
                    if (file_cluster==1) card_data=good_bytes[source_pos];
                    else if (selected_kind==3) card_data=bad_bytes[source_pos];
                    else card_data=bad_bytes[source_pos];
                    card_valid=1;
                    @(negedge clk);
                    card_valid=0;
                    byte_no=byte_no+1;
                end
            end
            if (!(selected_kind==2 && sector_addr==0) && !(selected_kind==3 && source_pos>=BAD_BYTES)) begin
                card_end=1;
                @(negedge clk);
                card_end=0; card_data=0;
                wait(card_read===1'b0);
            end else begin
                card_data=0;
            end
        end
    end

    initial begin : write_ack_model
        forever begin
            wait(write_req===1'b1);
            repeat(6) @(negedge clk);
            write_req_ack=1;
            @(negedge clk); write_req_ack=0;
            wait(write_req===1'b0);
        end
    end

    initial begin
        repeat(6) @(negedge clk);
        catalog_ready=1;
        wait(first_words==PIXELS);
        wait(state_code==4'd7);
        repeat(300) @(negedge clk);
        write_finish_toggle=~write_finish_toggle;
        wait(state_code==4'd9 && display_valid);
        old_buf=disp_buf_idx; old_image=current_image_index;
        if (old_image!=0 || first_words!=PIXELS || error) begin
            $display("FAIL %0s initial image not committed image=%0d pixels=%0d",NAME,old_image,first_words);
            $fatal(1);
        end
        // Queue a real key request while display ownership is still retained.
        key_next=1; repeat(70) @(negedge clk); key_next=0; repeat(70) @(negedge clk);
        if (state_code!=4'd9 || card_requests!=first_card_requests) begin
            $display("FAIL %0s started before display finish",NAME); $fatal(1);
        end
        display_finish_toggle=~display_finish_toggle;
        wait(state_code==4'd2);
        wait(error && state_code==4'd8);
        repeat(10) @(negedge clk);
        if (!display_valid || disp_buf_idx!=old_buf || current_image_index!=old_image || second_words!=0) begin
            $display("FAIL %0s error published target: display=%b buf=%0d/%0d image=%0d/%0d words2=%0d",
                     NAME,display_valid,disp_buf_idx,old_buf,current_image_index,old_image,second_words);
            $fatal(1);
        end
        $display("SCALER_BAD_CASE PASS name=%0s retained_image=%0d retained_buf=%0d card_requests=%0d",
                 NAME,current_image_index,disp_buf_idx,card_requests);
        finished=1;
    end
endmodule

module tb_scaler_bad_inputs;
    reg clk=0, rst=1;
    always #5 clk=~clk;
    wire [3:0] done;
    scaler_bad_case #(.NAME("zero_dimension"),.KIND(0),
        .BAD_MEM("test_media/bad_zero_width_source_bytes.mem"),.BAD_BYTES(230454)) c0(clk,rst,done[0]);
    scaler_bad_case #(.NAME("unsupported_width"),.KIND(1),
        .BAD_MEM("test_media/bad_unsupported_width_source_bytes.mem"),.BAD_BYTES(230454)) c1(clk,rst,done[1]);
    scaler_bad_case #(.NAME("short_header_sector"),.KIND(2),
        .BAD_MEM("test_media/bmp_320x240_bottomup_source_bytes.mem"),.BAD_BYTES(230454)) c2(clk,rst,done[2]);
    scaler_bad_case #(.NAME("truncated_payload"),.KIND(3),
        .BAD_MEM("test_media/bad_truncated_payload_source_bytes.mem"),.BAD_BYTES(17054)) c3(clk,rst,done[3]);
    initial begin
        repeat(8) @(negedge clk); rst=0;
        wait(&done);
        $display("SCALER_ERRORS PASS cases=4 retained=4 types=zero,unsupported,short_sector,truncation");
        $finish;
    end
    initial begin
        #200000000;
        $display("FAIL tb_scaler_bad_inputs timeout"); $fatal(1);
    end
endmodule
