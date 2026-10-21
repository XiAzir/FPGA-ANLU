`timescale 1ns/1ps

module tb_tf_bmp_failure_detail;
    localparam [3:0] WAIT_CATALOG=0, HEADER=2, WRITE_WAIT=4, COMMIT=7, HALT=8;
    localparam integer FW=32, FH=24, BMP_BYTES=54+96*24;
    localparam integer SC_VALID=0, SC_SHORT_HEADER=20, SC_LONG_HEADER=21,
        SC_MAPPER=22, SC_WATCHDOG=23, SC_ACK_TIMEOUT=24, SC_SCALE_SHORT=25;

    reg clk=0, rst=1, key_next=0, key_auto=0, catalog_ready=0;
    reg [2:0] bmp_count=1;
    reg [127:0] bmp_clusters=0, bmp_sizes=0;
    wire [31:0] file_cluster,file_size,card_addr;
    wire card_read;
    reg [7:0] card_data=0;
    reg card_valid=0,card_end=0,file_error=0;
    reg write_finish_toggle=0,display_finish_toggle=0;
    wire [1:0] write_buf_idx,disp_buf_idx,current_image_index;
    wire write_req,write_en,display_valid,error,auto_mode;
    wire [23:0] write_data,failure_detail;
    wire [3:0] state_code;
    wire [31:0] file_cluster_h,file_size_h,card_addr_h;
    wire card_read_h;
    wire [1:0] write_buf_idx_h,disp_buf_idx_h,current_image_index_h;
    wire write_req_h,write_en_h,display_valid_h,error_h,auto_mode_h;
    wire [23:0] write_data_h,failure_detail_h;
    wire [3:0] state_code_h;
    reg ack_mode=1;
    wire write_req_ack=ack_mode && write_req;
    reg [7:0] media[0:4095];
    integer scenario=SC_VALID;
    integer req_count=0, pixel_count=0;
    integer i,addr,nbytes,timeout_guard;
    reg [23:0] held_detail;
    reg [31:0] raw_header_w,raw_header_h,raw_header_declared,raw_header_filesz;

    always #5 clk=~clk;

    tf_bmp_file_player_base #(
        .CLK_FREQ_HZ(1000),.FRAME_WIDTH(FW),.FRAME_HEIGHT(FH),.WAIT_LIMIT(1000)
    ) dut (
        .clk(clk),.rst(rst),.key_next(key_next),.key_auto(key_auto),
        .catalog_ready(catalog_ready),.bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),
        .file_cluster(file_cluster),.file_size(file_size),
        .card_read(card_read),.card_addr(card_addr),.card_data(card_data),
        .card_valid(card_valid),.card_end(card_end),.file_error(file_error),
        .write_finish_toggle(write_finish_toggle),.display_finish_toggle(display_finish_toggle),
        .write_buf_idx(write_buf_idx),.disp_buf_idx(disp_buf_idx),
        .write_req(write_req),.write_req_ack(write_req_ack),.write_ready(1'b1),
        .write_en(write_en),.write_data(write_data),.display_valid(display_valid),
        .error(error),.state_code(state_code),.current_image_index(current_image_index),
        .auto_mode(auto_mode),.failure_detail(failure_detail)
    );

    tf_bmp_file_player_validated #(
        .CLK_FREQ_HZ(1000),.FRAME_WIDTH(FW),.FRAME_HEIGHT(FH),.WAIT_LIMIT(1000)
    ) dut_header (
        .clk(clk),.rst(rst),.key_next(key_next),.key_auto(key_auto),
        .catalog_ready(catalog_ready),.bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters),.bmp_sizes(bmp_sizes),
        .file_cluster(file_cluster_h),.file_size(file_size_h),
        .card_read(card_read_h),.card_addr(card_addr_h),.card_data(card_data),
        .card_valid(card_valid),.card_end(card_end),.file_error(file_error),
        .write_finish_toggle(write_finish_toggle),.display_finish_toggle(display_finish_toggle),
        .write_buf_idx(write_buf_idx_h),.disp_buf_idx(disp_buf_idx_h),
        .write_req(write_req_h),.write_req_ack(write_req_ack),.write_ready(1'b1),
        .write_en(write_en_h),.write_data(write_data_h),.display_valid(display_valid_h),
        .error(error_h),.state_code(state_code_h),.current_image_index(current_image_index_h),
        .auto_mode(auto_mode_h),.failure_detail(failure_detail_h)
    );

    always @(posedge clk) if(!rst) begin
        if(card_read!==card_read_h || card_addr!==card_addr_h || error!==error_h ||
           state_code!==state_code_h || failure_detail!==failure_detail_h ||
           write_en!==write_en_h || write_data!==write_data_h || display_valid!==display_valid_h)
            $fatal(1,"base/header parser public-output mismatch");
    end

    always @(negedge clk) if (!rst && write_en) pixel_count=pixel_count+1;

    task put16;
        input integer off; input [15:0] value;
        begin media[off]=value[7:0]; media[off+1]=value[15:8]; end
    endtask
    task put32;
        input integer off; input [31:0] value;
        begin
            media[off]=value[7:0]; media[off+1]=value[15:8];
            media[off+2]=value[23:16]; media[off+3]=value[31:24];
        end
    endtask

    task make_header;
        input integer variant;
        integer w,h,off,declared,filesz,planes,bits,compression,dib;
        begin
            for(i=0;i<4096;i=i+1) media[i]=0;
            w=32; h=24; off=54; declared=BMP_BYTES; filesz=BMP_BYTES;
            planes=1; bits=24; compression=0; dib=40;
            case(variant)
                0: media[0]=8'h43; // bad signature, bit 0 only
                1: dib=39; // bit 1 only
                2: off=53; // bit 2 only
                3: planes=2; // bit 3 only
                4: bits=16; // bit 4 only
                5: compression=1; // bit 5 only
                6: begin w=1025; declared=80000; filesz=80000; end
                7: begin h=769; declared=80000; filesz=80000; end
                8: begin declared=BMP_BYTES-1; filesz=BMP_BYTES-1; end // bits 8+9
                9: declared=BMP_BYTES-1; // bit 9 only
                10: declared=BMP_BYTES+1; // bit 10 only
                11: begin declared=BMP_BYTES+1; filesz=BMP_BYTES-1; end // bits 8+10
                12: begin w=32'h80000000; declared=80000; filesz=80000; end
                13: begin w=32'h00010000; declared=80000; filesz=80000; end
                14: begin h=32'hfffffcff; declared=80000; filesz=80000; end
                15: begin h=32'h80000000; declared=BMP_BYTES; filesz=BMP_BYTES; end
                16: begin w=1025; h=769; declared=3000000; filesz=3000000; planes=2; bits=16; compression=1; end
                17: begin w=raw_header_w; h=raw_header_h; declared=raw_header_declared; filesz=raw_header_filesz; end
                default: begin end
            endcase
            if(variant!=0) media[0]=8'h42;
            media[1]=8'h4d;
            put32(2,declared); put32(10,off); put32(14,dib);
            put32(18,w); put32(22,h); put16(26,planes); put16(28,bits);
            put32(30,compression);
            for(i=54;i<4096;i=i+1) media[i]=(i*13+7)&8'hff;
            // Reapply the header after filling deterministic payload bytes.
            if(variant==0 || variant==16) media[0]=8'h43;
            else media[0]=8'h42;
            media[1]=8'h4d;
            put32(2,declared); put32(10,off); put32(14,dib);
            put32(18,w); put32(22,h); put16(26,planes); put16(28,bits);
            put32(30,compression);
            bmp_sizes[31:0]=filesz;
        end
    endtask

    // Card model emits complete sector streams through the public player pins.
    // It does not peek or force any internal loader/scaler state.
    initial begin : card_model
        forever begin
            wait(card_read===1'b1);
            @(negedge clk);
            addr=card_addr; req_count=req_count+1;
            if(scenario==SC_MAPPER) begin
                file_error=1;
                @(negedge clk); file_error=0;
                wait(card_read===1'b0);
            end else if(scenario==SC_WATCHDOG) begin
                wait(card_read===1'b0);
            end else begin
                repeat(2) @(negedge clk);
                if(scenario==SC_SHORT_HEADER && addr==0) nbytes=511;
                else if(scenario==SC_LONG_HEADER && addr==0) nbytes=513;
                else if(scenario==SC_SCALE_SHORT && req_count>=2) nbytes=100;
                else nbytes=512;
                for(integer j=0;j<nbytes;j=j+1) begin
                    card_data=media[addr*512+j]; card_valid=1;
                    @(negedge clk);
                end
                card_valid=0; card_data=0; card_end=1;
                @(negedge clk); card_end=0;
                wait(card_read===1'b0);
            end
        end
    end

    task start_case;
        input integer new_scenario;
        input integer header_variant;
        input integer do_ack;
        begin
            rst=1; catalog_ready=0; file_error=0; card_valid=0; card_end=0;
            card_data=0; write_finish_toggle=0; display_finish_toggle=0;
            ack_mode=do_ack; scenario=new_scenario; req_count=0; pixel_count=0;
            bmp_count=1; bmp_clusters=0; bmp_sizes=0; bmp_clusters[31:0]=1;
            make_header(header_variant);
            repeat(5) @(negedge clk);
            rst=0; repeat(3) @(negedge clk);
            catalog_ready=1;
            wait(state_code==HEADER);
            @(negedge clk); catalog_ready=0;
        end
    endtask

    task expect_detail;
        input [23:0] expected;
        input [255:0] label;
        begin
            timeout_guard=0;
            while(!error && timeout_guard<30000) begin @(negedge clk); timeout_guard=timeout_guard+1; end
            if(!error) begin $display("FAIL timeout waiting error: %0s state=%0d",label,state_code); $fatal(1); end
            repeat(2) @(negedge clk);
            if(failure_detail!==expected) begin
                $display("FAIL detail %0s got=%06x expected=%06x state=%0d",label,failure_detail,expected,state_code);
                $fatal(1);
            end
            $display("CASE PASS %0s detail=%06x",label,failure_detail);
        end
    endtask

    task run_header_mask;
        input integer variant;
        input [15:0] mask;
        input [255:0] label;
        begin
            start_case(SC_VALID,variant,1);
            expect_detail({8'h02,mask},label);
        end
    endtask

    task run_raw_header;
        input [31:0] rw,rh,rd,rs;
        reg [31:0] abs_h;
        reg [11:0] stride;
        reg [21:0] image_bytes;
        reg [32:0] pixel_end;
        reg [15:0] expected_mask;
        begin
            raw_header_w=rw; raw_header_h=rh;
            raw_header_declared=rd; raw_header_filesz=rs;
            if ((rw!=0 && rw<=1024) &&
                ((rh[31] ? (~rh+32'd1) : rh)!=0) &&
                (rh!=32'h80000000) &&
                ((rh[31] ? (~rh+32'd1) : rh)<=768))
                raw_header_w=rw | 32'h80000000;
            abs_h=raw_header_h[31] ? (~raw_header_h+32'd1) : raw_header_h;
            stride=((({1'b0,raw_header_w[10:0]}*14'd3)+14'd3)>>2)<<2;
            image_bytes={10'd0,stride}*{12'd0,abs_h[9:0]};
            pixel_end={1'b0,32'd54}+{11'd0,image_bytes};
            expected_mask=0;
            expected_mask[10]=(raw_header_declared>raw_header_filesz);
            expected_mask[9]=({1'b0,raw_header_declared}<pixel_end);
            expected_mask[8]=(pixel_end>{1'b0,raw_header_filesz});
            expected_mask[7]=(abs_h==0 || raw_header_h==32'h80000000 || abs_h>768);
            expected_mask[6]=(raw_header_w==0 || raw_header_w>1024);
            start_case(SC_VALID,17,1);
            expect_detail({8'h02,expected_mask},"raw32_geometry_extent_crosscheck");
        end
    endtask

    initial begin : test_sequence
        integer raw_i;
        reg [31:0] random_state,random_w,random_h,random_declared,random_size;
        // 01: header stream length boundary, short and long.
        start_case(SC_SHORT_HEADER,-1,1); expect_detail(24'h0101ff,"short_header_sector");
        start_case(SC_LONG_HEADER,-1,1); expect_detail(24'h010201,"long_header_sector");

        // 02: all eleven independently reported header checks. Extent failure
        // necessarily overlaps declared-extent or declared-size-over-file.
        run_header_mask(0,16'h0001,"header_BM");
        run_header_mask(1,16'h0002,"header_DIB");
        run_header_mask(2,16'h0004,"header_offset");
        run_header_mask(3,16'h0008,"header_planes");
        run_header_mask(4,16'h0010,"header_bits");
        run_header_mask(5,16'h0020,"header_compression");
        run_header_mask(6,16'h0040,"header_width");
        run_header_mask(7,16'h0080,"header_height");
        run_header_mask(12,16'h0040,"header_width_signbit");
        run_header_mask(13,16'h0040,"header_width_middle_highbits");
        run_header_mask(14,16'h0080,"header_negative_height_minus769");
        run_header_mask(15,16'h0080,"header_int_min_height");
        run_header_mask(16,16'h00f9,"header_simultaneous_fixed_and_geometry_errors");

        random_state=32'h80c11314;
        for(raw_i=0;raw_i<512;raw_i=raw_i+1) begin
            random_state=random_state*32'd1664525+32'd1013904223; random_w=random_state;
            random_state=random_state*32'd1664525+32'd1013904223; random_h=random_state;
            random_state=random_state*32'd1664525+32'd1013904223; random_declared=random_state;
            random_state=random_state*32'd1664525+32'd1013904223; random_size=random_state;
            run_raw_header(random_w,random_h,random_declared,random_size);
        end
        $display("BMP_HEADER_MASK_EQ PASS random_raw_headers=512 extent_cross_terms=preserved");
        run_header_mask(8,16'h0300,"header_file_extent_and_declared_extent");
        run_header_mask(9,16'h0200,"header_declared_extent");
        run_header_mask(10,16'h0400,"header_declared_size_over_file");
        run_header_mask(11,16'h0500,"header_file_extent_and_declared_size_over_file");

        // 04 mapper error captures the state visible at the event (HEADER=2).
        start_case(SC_MAPPER,-1,1); expect_detail(24'h040002,"mapper_header");
        // 05 no response at all until HEADER watchdog fires.
        start_case(SC_WATCHDOG,-1,1); expect_detail(24'h050002,"watchdog_header");
        // 05 timeout waiting for write_req_ack after a fully valid header.
        start_case(SC_ACK_TIMEOUT,-1,0); expect_detail(24'h050004,"write_ack_timeout");
        // 03 scaler detects an incomplete payload sector (failure code 07).
        start_case(SC_SCALE_SHORT,-1,1); expect_detail(24'h030007,"scaler_short_payload");

        // First failure is sticky even if a later external mapper error arrives.
        start_case(SC_VALID,0,1); expect_detail(24'h020001,"sticky_first_header_error");
        held_detail=failure_detail; file_error=1; repeat(2) @(negedge clk); file_error=0;
        if(failure_detail!==held_detail) begin $display("FAIL first-error detail changed"); $fatal(1); end
        $display("CASE PASS first_error_sticky detail=%06x",failure_detail);

        // External reset clears both the sticky detail and error latch.
        rst=1; repeat(3) @(negedge clk);
        if(failure_detail!==24'd0 || error!==1'b0 || state_code!==WAIT_CATALOG) begin
            $display("FAIL reset did not clear detail/error: detail=%06x error=%b state=%0d",failure_detail,error,state_code); $fatal(1);
        end
        rst=0; $display("CASE PASS reset_clears_detail");

        // Valid 32x24 BMP: normal write handshake, full output frame, commit,
        // and no failure detail after successful display publication.
        start_case(SC_VALID,-1,1);
        timeout_guard=0;
        while(state_code!==COMMIT && timeout_guard<100000) begin @(negedge clk); timeout_guard=timeout_guard+1; end
        if(state_code!==COMMIT) begin $display("FAIL valid BMP never reached COMMIT state=%0d",state_code); $fatal(1); end
        write_finish_toggle=~write_finish_toggle;
        timeout_guard=0;
        while(!display_valid && timeout_guard<1000) begin @(negedge clk); timeout_guard=timeout_guard+1; end
        if(!display_valid || error || failure_detail!==24'd0 || pixel_count!=FW*FH) begin
            $display("FAIL valid commit display=%b error=%b detail=%06x pixels=%0d",display_valid,error,failure_detail,pixel_count); $fatal(1);
        end
        $display("CASE PASS valid_commit pixels=%0d detail=%06x",pixel_count,failure_detail);
        $display("BMP_FAILURE_DETAIL PASS cases=538 header_masks=529 sector_lengths=2 mapper=1 watchdogs=2 scaler=1 sticky=1 reset=1 valid_commit=1");
        $finish;
    end

    initial begin
        #300000000;
        $display("FAIL tb_tf_bmp_failure_detail global timeout state=%0d detail=%06x",state_code,failure_detail);
        $fatal(1);
    end
endmodule


