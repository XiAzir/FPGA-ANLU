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
    reg ack_mode=1;
    wire write_req_ack=ack_mode && write_req;
    reg [7:0] media[0:4095];
    integer scenario=SC_VALID;
    integer req_count=0, pixel_count=0;
    integer i,addr,nbytes,timeout_guard;
    reg [23:0] held_detail;

    always #5 clk=~clk;

    tf_bmp_file_player #(
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
                default: begin end
            endcase
            if(variant!=0) media[0]=8'h42;
            media[1]=8'h4d;
            put32(2,declared); put32(10,off); put32(14,dib);
            put32(18,w); put32(22,h); put16(26,planes); put16(28,bits);
            put32(30,compression);
            for(i=54;i<4096;i=i+1) media[i]=(i*13+7)&8'hff;
            // Reapply the header after filling deterministic payload bytes.
            if(variant==0) media[0]=8'h43;
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

    initial begin : test_sequence
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
        $display("BMP_FAILURE_DETAIL PASS cases=21 header_masks=12 sector_lengths=2 mapper=1 watchdogs=2 scaler=1 sticky=1 reset=1 valid_commit=1");
        $finish;
    end

    initial begin
        #300000000;
        $display("FAIL tb_tf_bmp_failure_detail global timeout state=%0d detail=%06x",state_code,failure_detail);
        $fatal(1);
    end
endmodule
