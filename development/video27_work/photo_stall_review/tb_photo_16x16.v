`timescale 1ns/1ps
module tb_photo_16x16;
    reg clk=0, rst=1;
    always #10 clk=~clk;
    reg [7:0] card_data=0;
    reg card_valid=0, card_end=0;
    reg write_finish_toggle=0, display_finish_toggle=0;
    reg write_req_ack=0;
    wire card_read;
    wire [31:0] card_addr;
    wire [31:0] file_cluster, file_size;
    wire [1:0] write_buf_idx, disp_buf_idx;
    wire write_req, write_en, display_valid, error;
    wire [23:0] write_data;
    wire [3:0] state_code;
    wire [23:0] failure_detail;
    reg [127:0] clusters=0, sizes=0;
    reg [7:0] media[0:1023];
    integer i, row, col, byte_pos;
    integer transfer_active=0, transfer_index=0, transfer_sector=0;
    integer writes=0, cycles=0;
    tf_bmp_file_player #(.CLK_FREQ_HZ(1000),.FRAME_WIDTH(640),.FRAME_HEIGHT(480),.WAIT_LIMIT(50000000)) dut (
        .clk(clk),.rst(rst),
        .key_next_req_toggle(1'b0),.key_auto_req_toggle(1'b0),
        .key_next_ack_toggle(),.key_auto_ack_toggle(),
        .catalog_ready(1'b1),.bmp_count(3'd1),.bmp_clusters(clusters),.bmp_sizes(sizes),
        .file_cluster(file_cluster),.file_size(file_size),.card_read(card_read),.card_addr(card_addr),
        .card_data(card_data),.card_valid(card_valid),.card_end(card_end),.file_error(1'b0),
        .write_finish_toggle(write_finish_toggle),.display_finish_toggle(display_finish_toggle),
        .write_buf_idx(write_buf_idx),.disp_buf_idx(disp_buf_idx),
        .write_req(write_req),.write_req_ack(write_req_ack),.write_ready(1'b1),
        .write_en(write_en),.write_data(write_data),.display_valid(display_valid),.error(error),
        .state_code(state_code),.current_image_index(),.auto_mode(),.failure_detail(failure_detail)
    );

    // A 16x16, 24-bit BI_RGB BMP: 54-byte header, 48-byte padded rows, 2 sectors.
    initial begin
        for(i=0;i<1024;i=i+1) media[i]=0;
        media[0]=8'h42; media[1]=8'h4d;
        media[2]=8'h36; media[3]=8'h03; media[4]=0; media[5]=0; media[6]=0; media[7]=0;
        media[8]=0; media[9]=0; media[10]=54; media[11]=0; media[12]=0; media[13]=0;
        media[14]=40; media[15]=0; media[16]=0; media[17]=0;
        media[18]=16; media[19]=0; media[20]=0; media[21]=0;
        media[22]=16; media[23]=0; media[24]=0; media[25]=0;
        media[26]=1; media[27]=0; media[28]=24; media[29]=0;
        media[30]=0; media[31]=0; media[32]=0; media[33]=0;
        media[34]=0; media[35]=3; media[36]=0; media[37]=0;
        media[38]=0; media[39]=0; media[40]=0; media[41]=0;
        media[42]=0; media[43]=0; media[44]=0; media[45]=0;
        media[46]=0; media[47]=0; media[48]=0; media[49]=0;
        media[50]=0; media[51]=0; media[52]=0; media[53]=0;
        for(row=0;row<16;row=row+1)
            for(col=0;col<16;col=col+1) begin
                byte_pos=54+row*48+col*3;
                media[byte_pos]=8'h56; media[byte_pos+1]=8'h34; media[byte_pos+2]=8'h12;
            end
        sizes[31:0]=822;
        repeat(8) @(negedge clk); rst=0;
        wait(write_req);
        repeat(6) @(negedge clk); write_req_ack=1;
        wait(!write_req); @(negedge clk); write_req_ack=0;
        wait(dut.u_scale.done);
        repeat(4) @(posedge clk);
        if(error) $fatal(1,"loader error detail=%h",failure_detail);
        if(writes!=307200) $fatal(1,"write count got=%0d expected=307200",writes);
        if(state_code!=7) $fatal(1,"unexpected terminal loader state=%0d",state_code);
        $display("PHOTO16_PASS writes=%0d scale_state=%0d dw=%0d dh=%0d offx=%0d offy=%0d requests=%0d",
            writes,dut.u_scale.state,dut.u_scale.dw,dut.u_scale.dh,dut.u_scale.offx,dut.u_scale.offy,transfer_sector);
        $finish;
    end

    // Sector responder: exactly 512 valid bytes, then one separate end cycle.
    always @(negedge clk) begin
        if(rst) begin
            card_valid=0; card_end=0; card_data=0; transfer_active=0; transfer_index=0;
        end else if(transfer_active==0 && card_read) begin
            transfer_active=1; transfer_index=0; transfer_sector=transfer_sector+1;
        end else if(transfer_active==1) begin
            card_valid=1;
            card_data=media[(card_addr*512)+transfer_index];
            if(transfer_index==511) begin
                transfer_active=2; transfer_index=0;
            end else transfer_index=transfer_index+1;
        end else if(transfer_active==2) begin
            card_valid=0; card_end=1; transfer_active=0;
        end else begin card_valid=0; card_end=0; end
    end

    always @(posedge clk) begin
        if(rst) begin writes=0; cycles=0; end
        else begin
            cycles=cycles+1;
            if(write_en) begin
                if(writes>=307200) $fatal(1,"too many output pixels");
                if((writes%640)>=80 && (writes%640)<560) begin
                    if(write_data!==24'h123456) $fatal(1,"content mismatch n=%0d data=%h",writes,write_data);
                end else if(write_data!==24'h000000) $fatal(1,"letterbox mismatch n=%0d data=%h",writes,write_data);
                writes=writes+1;
            end
            if(error) $fatal(1,"loader error state=%0d detail=%h",state_code,failure_detail);
            if(cycles>5000000) $fatal(1,"timeout state=%0d scale=%0d valid=%b ready=1 writes=%0d sector=%0d",state_code,dut.u_scale.state,dut.scale_pixel_valid,writes,transfer_sector);
        end
    end
endmodule
