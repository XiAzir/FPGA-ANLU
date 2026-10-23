`timescale 1ns/1ps
module tb_photo_regression;
    parameter integer SRC_WIDTH=640;
    parameter integer SRC_HEIGHT=480;
    localparam integer STRIDE=((SRC_WIDTH*3+3)/4)*4;
    localparam integer FILE_SIZE=54+STRIDE*SRC_HEIGHT;

    reg clk=0, rst=1;
    always #10 clk=~clk;
    reg [7:0] card_data=0;
    reg card_valid=0, card_end=0;
    reg write_req_ack=0;
    reg write_ready=1;
    wire card_read;
    wire [31:0] card_addr, file_cluster, file_size;
    wire [1:0] write_buf_idx, disp_buf_idx;
    wire write_req, write_en, display_valid, error;
    wire [23:0] write_data;
    wire [3:0] state_code;
    wire [23:0] failure_detail;
`ifdef CANDIDATE
    wire [23:0] debug_progress;
`endif
    reg [127:0] clusters=0, sizes=0;

    integer cycle_count=0, writes=0, read_count=0, ready_stalls=0;
    integer transfer_active=0, transfer_pos=0, transfer_addr=0, transfer_age=0;
    integer x, y, expected_col, expected_row, expected_rgb;
    reg prev_stall=0;
    reg [23:0] prev_rgb=0;
    reg [31:0] pixel_crc=32'h811c9dc5, cycle_crc=32'h811c9dc5;
    integer watchdog=0;

    tf_bmp_file_player #(.CLK_FREQ_HZ(1000),.FRAME_WIDTH(640),.FRAME_HEIGHT(480),.WAIT_LIMIT(50000000)) dut (
        .clk(clk),.rst(rst),
        .key_next_req_toggle(1'b0),.key_auto_req_toggle(1'b0),
        .key_next_ack_toggle(),.key_auto_ack_toggle(),
        .catalog_ready(1'b1),.bmp_count(3'd1),.bmp_clusters(clusters),.bmp_sizes(sizes),
        .file_cluster(file_cluster),.file_size(file_size),.card_read(card_read),.card_addr(card_addr),
        .card_data(card_data),.card_valid(card_valid),.card_end(card_end),.file_error(1'b0),
        .write_finish_toggle(1'b0),.display_finish_toggle(1'b0),
        .write_buf_idx(write_buf_idx),.disp_buf_idx(disp_buf_idx),
        .write_req(write_req),.write_req_ack(write_req_ack),.write_ready(write_ready),
        .write_en(write_en),.write_data(write_data),.display_valid(display_valid),.error(error),
        .state_code(state_code),.current_image_index(),.auto_mode(),.failure_detail(failure_detail)
`ifdef CANDIDATE
        ,.debug_progress(debug_progress)
`endif
    );

    function automatic [7:0] bmp_byte(input integer address);
        integer p, row, col;
        reg [31:0] declared_size;
        begin
            declared_size=FILE_SIZE;
            if(address<54) begin
                case(address)
                    0: bmp_byte=8'h42; 1: bmp_byte=8'h4d;
                    2: bmp_byte=declared_size[7:0]; 3: bmp_byte=declared_size[15:8];
                    4: bmp_byte=declared_size[23:16]; 5: bmp_byte=declared_size[31:24];
                    10: bmp_byte=8'd54; 11: bmp_byte=0; 12: bmp_byte=0; 13: bmp_byte=0;
                    14: bmp_byte=40; 15: bmp_byte=0; 16: bmp_byte=0; 17: bmp_byte=0;
                    18: bmp_byte=SRC_WIDTH[7:0]; 19: bmp_byte=(SRC_WIDTH>>8)&8'hff;
                    20: bmp_byte=0; 21: bmp_byte=0;
                    22: bmp_byte=SRC_HEIGHT[7:0]; 23: bmp_byte=(SRC_HEIGHT>>8)&8'hff;
                    24: bmp_byte=0; 25: bmp_byte=0;
                    26: bmp_byte=1; 27: bmp_byte=0; 28: bmp_byte=24; 29: bmp_byte=0;
                    default: bmp_byte=0;
                endcase
            end else begin
                p=address-54; row=p/STRIDE; col=(p%STRIDE)/3;
                if(row>=SRC_HEIGHT || col>=SRC_WIDTH) bmp_byte=0;
                else case(p%3)
                    0: bmp_byte=(col*3+row*5+17)&255;
                    1: bmp_byte=(col*7 ^ row*11 ^ ((col+row)>>1))&255;
                    default: bmp_byte=(col*13+row*17+(col>>2))&255;
                endcase
            end
        end
    endfunction

    function automatic [23:0] expected_pixel(input integer out_x, input integer out_y);
        integer left_edge, draw_width, src_x, src_y;
        reg [7:0] red, green, blue;
        begin
            // 16x16 input is centered horizontally as 480x480; 640x480 is full-frame.
            left_edge=(SRC_WIDTH==16 && SRC_HEIGHT==16) ? 80 : 0;
            draw_width=(SRC_WIDTH==16 && SRC_HEIGHT==16) ? 480 : 640;
            if(out_x<left_edge || out_x>=left_edge+draw_width) expected_pixel=24'h000000;
            else begin
                src_x=((out_x-left_edge)*SRC_WIDTH)/draw_width;
                src_y=(out_y*SRC_HEIGHT)/480;
                blue=(src_x*3+src_y*5+17)&255;
                green=(src_x*7 ^ src_y*11 ^ ((src_x+src_y)>>1))&255;
                red=(src_x*13+src_y*17+(src_x>>2))&255;
                expected_pixel={red,green,blue};
            end
        end
    endfunction

    initial begin
        sizes[31:0]=FILE_SIZE;
        repeat(8) @(negedge clk);
        rst=0;
        wait(dut.u_scale.done);
        repeat(5) @(negedge clk);
        if(error) $fatal(1,"loader error state=%0d detail=%h",state_code,failure_detail);
        if(writes!=307200) $fatal(1,"write count=%0d expected=307200",writes);
        if(read_count!=((SRC_WIDTH==640 && SRC_HEIGHT==480)?1802:3))
            $fatal(1,"sector read count=%0d expected=%0d",read_count,(SRC_WIDTH==640 && SRC_HEIGHT==480)?1802:3);
        if(ready_stalls==0) $fatal(1,"write_ready stall stimulus was not exercised");
`ifdef CANDIDATE
        $display("RESULT width=%0d height=%0d file_size=%0d writes=%0d cycles=%0d reads=%0d ready_stalls=%0d pixel_crc=%08x cycle_crc=%08x debug=%06x",
            SRC_WIDTH,SRC_HEIGHT,FILE_SIZE,writes,cycle_count,read_count,ready_stalls,pixel_crc,cycle_crc,debug_progress);
`else
        $display("RESULT width=%0d height=%0d file_size=%0d writes=%0d cycles=%0d reads=%0d ready_stalls=%0d pixel_crc=%08x cycle_crc=%08x",
            SRC_WIDTH,SRC_HEIGHT,FILE_SIZE,writes,cycle_count,read_count,ready_stalls,pixel_crc,cycle_crc);
`endif
        $finish;
    end

    // A single deterministic responder per simulation. It returns complete
    // 512-byte logical sectors and inserts bounded byte-valid bubbles.
    always @(negedge clk) begin
        if(rst) begin
            card_valid=0; card_end=0; card_data=0;
            transfer_active=0; transfer_pos=0; transfer_addr=0; transfer_age=0;
            write_req_ack=0; write_ready=1;
        end else begin
            write_req_ack=write_req;
            write_ready=!((watchdog%67)>=11 && (watchdog%67)<=19);
            card_valid=0; card_end=0; card_data=0;
            if(transfer_active==0 && card_read) begin
                transfer_active=1; transfer_pos=0; transfer_addr=card_addr;
                transfer_age=0; read_count=read_count+1;
            end else if(transfer_active==1) begin
                transfer_age=transfer_age+1;
                if(transfer_pos<512 && ((watchdog+transfer_pos*3)%17)!=0) begin
                    card_valid=1;
                    card_data=bmp_byte(transfer_addr*512+transfer_pos);
                    transfer_pos=transfer_pos+1;
                end else if(transfer_pos==512) begin
                    card_end=1; transfer_active=0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            prev_stall=0; prev_rgb=0; watchdog=0;
        end else begin
            watchdog=watchdog+1;
            if(watchdog>12000000) $fatal(1,"timeout state=%0d scale=%0d writes=%0d reads=%0d",state_code,dut.u_scale.state,writes,read_count);
            if(prev_stall && (dut.scale_pixel_valid!==1'b1 || dut.scale_pixel_rgb!==prev_rgb))
                $fatal(1,"pixel changed while stalled: valid=%b old=%h new=%h",dut.scale_pixel_valid,prev_rgb,dut.scale_pixel_rgb);
            prev_stall=dut.scale_pixel_valid && !write_ready;
            if(prev_stall) prev_rgb=dut.scale_pixel_rgb;
`ifdef CANDIDATE
            if(debug_progress!=={dut.u_scale.state,dut.u_scale.out_y[8:0],dut.u_scale.out_x[9:0]})
                $fatal(1,"debug_progress encoding mismatch %h",debug_progress);
`endif
            if(error) $fatal(1,"loader error state=%0d detail=%h scale=%0d",state_code,failure_detail,dut.u_scale.state);
        end
    end

    always @(negedge clk) begin
        if(!rst) begin
            cycle_count=cycle_count+1;
            if(write_en) begin
                if(writes>=307200) $fatal(1,"too many writes");
                x=writes%640; y=writes/640;
                expected_rgb=expected_pixel(x,y);
                if(write_data!==expected_rgb[23:0])
                    $fatal(1,"pixel mismatch n=%0d xy=%0d,%0d got=%06x expected=%06x",writes,x,y,write_data,expected_rgb[23:0]);
                pixel_crc=(pixel_crc ^ write_data)*32'h01000193;
                writes=writes+1;
            end
            cycle_crc=(cycle_crc ^ {7'd0,write_en,write_data})*32'h01000193;
            if(!write_ready && dut.scale_pixel_valid) ready_stalls=ready_stalls+1;
        end
    end
endmodule
