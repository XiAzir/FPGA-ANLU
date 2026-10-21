`timescale 1ns/1ps
module tb_bmp_width_equiv;
    reg clk=0, rst=1, start=0;
    always #5 clk=~clk;
    reg [15:0] source_width=1, source_height=1;
    reg source_top_down=0;
    reg [31:0] pixel_offset=509, file_size=0;
    reg [7:0] card_data=0;
    reg card_valid=0, card_end=0, file_error=0;
    reg write_ready=1;
    wire read_ref, read_opt;
    wire [31:0] addr_ref, addr_opt;
    wire valid_ref, valid_opt, done_ref, done_opt, error_ref, error_opt;
    wire [23:0] rgb_ref, rgb_opt;
    wire [7:0] fail_ref, fail_opt;
    reg [15:0] lfsr=16'h1;
    wire pixel_ready = lfsr[0] | lfsr[2] | lfsr[3] | lfsr[5];
    integer fault_kind=0;
    integer service=0, byte_pos=0, wait_drop=0;
    reg [31:0] active_sector=0;
    integer cycle_count=0, pixel_count=0, request_count=0;
    integer case_no=0;

    bmp_scale_engine_ref #(.FRAME_WIDTH(32),.FRAME_HEIGHT(24),.PIXEL_INTERVAL(1)) ref_dut(
        .clk(clk),.rst(rst),.start(start),.source_width(source_width),
        .source_height(source_height),.source_top_down(source_top_down),
        .pixel_offset(pixel_offset),.file_size(file_size),.pixel_ready(pixel_ready),
        .card_read(read_ref),.card_addr(addr_ref),.card_data(card_data),
        .card_valid(card_valid),.card_end(card_end),.file_error(file_error),
        .pixel_valid(valid_ref),.pixel_rgb(rgb_ref),.done(done_ref),.error(error_ref),
        .failure_code(fail_ref));
    bmp_scale_engine_opt #(.FRAME_WIDTH(32),.FRAME_HEIGHT(24),.PIXEL_INTERVAL(1)) opt_dut(
        .clk(clk),.rst(rst),.start(start),.source_width(source_width),
        .source_height(source_height),.source_top_down(source_top_down),
        .pixel_offset(pixel_offset),.file_size(file_size),.pixel_ready(pixel_ready),
        .card_read(read_opt),.card_addr(addr_opt),.card_data(card_data),
        .card_valid(card_valid),.card_end(card_end),.file_error(file_error),
        .pixel_valid(valid_opt),.pixel_rgb(rgb_opt),.done(done_opt),.error(error_opt),
        .failure_code(fail_opt));

    function [7:0] rom_byte;
        input [31:0] address;
        reg [63:0] mixed;
        begin
            mixed = address * 64'd37 + (address >> 5) * 64'd13 + (address >> 11);
            rom_byte = mixed[7:0];
        end
    endfunction

    always @(posedge clk) begin
        cycle_count <= cycle_count+1;
        lfsr <= {lfsr[14:0],lfsr[15]^lfsr[13]^lfsr[12]^lfsr[10]};
        if (rst) begin
            service<=0; byte_pos<=0; active_sector<=0; wait_drop<=0;
            card_valid<=0; card_end<=0; file_error<=0; card_data<=0;
        end else begin
            card_valid<=0; card_end<=0; file_error<=0;
            if (wait_drop) begin
                if (!read_ref) wait_drop<=0;
            end else if (!service && read_ref) begin
                service<=1; byte_pos<=0; active_sector<=addr_ref;
                request_count<=request_count+1;
            end else if (service) begin
                if (!read_ref) service<=0;
                else if (fault_kind==2 && byte_pos==200) begin
                    file_error<=1;
                    card_valid<=1;
                    card_data<=rom_byte(active_sector*512+byte_pos);
                    byte_pos<=byte_pos+1;
                end else if (fault_kind==3 && byte_pos==511) begin
                    card_end<=1; service<=0; wait_drop<=1;
                end else if (byte_pos < (fault_kind==1 ? 513 : 512)) begin
                    card_valid<=1;
                    card_data<=rom_byte(active_sector*512+byte_pos);
                    byte_pos<=byte_pos+1;
                end else begin
                    card_end<=1; service<=0; wait_drop<=1;
                end
            end
        end

        if (!rst) begin
            if (read_ref!==read_opt || addr_ref!==addr_opt || valid_ref!==valid_opt ||
                rgb_ref!==rgb_opt || done_ref!==done_opt || error_ref!==error_opt ||
                fail_ref!==fail_opt || ref_dut.state!==opt_dut.state ||
                ref_dut.div_bit!==opt_dut.div_bit || ref_dut.dw!==opt_dut.dw ||
                ref_dut.dh!==opt_dut.dh || ref_dut.offx!==opt_dut.offx ||
                ref_dut.offy!==opt_dut.offy || ref_dut.out_x!==opt_dut.out_x ||
                ref_dut.out_y!==opt_dut.out_y || ref_dut.x_phase!==opt_dut.x_phase ||
                ref_dut.y_phase!==opt_dut.y_phase || ref_dut.x_src!==opt_dut.x_src ||
                ref_dut.src_col!==opt_dut.src_col || ref_dut.src_bottom!==opt_dut.src_bottom ||
                ref_dut.physical_row!==opt_dut.physical_row ||
                ref_dut.sector_count!==opt_dut.sector_count ||
                ref_dut.interval_count!==opt_dut.interval_count) begin
                $display("FAIL cycle=%0d case=%0d state=%0d/%0d rd=%b/%b addr=%h/%h pv=%b/%b rgb=%h/%h done=%b/%b err=%b/%b code=%h/%h",
                    cycle_count,case_no,ref_dut.state,opt_dut.state,read_ref,read_opt,
                    addr_ref,addr_opt,valid_ref,valid_opt,rgb_ref,rgb_opt,
                    done_ref,done_opt,error_ref,error_opt,fail_ref,fail_opt);
                $fatal(1,"per-cycle original/optimized mismatch");
            end
            if (valid_ref && pixel_ready) pixel_count<=pixel_count+1;
        end
    end

    task reset_case;
        begin
            @(negedge clk); rst=1; start=0; card_valid=0; card_end=0;
            fault_kind=0; pixel_count=0; request_count=0;
            repeat(4) @(negedge clk);
            rst=0;
            repeat(2) @(negedge clk);
        end
    endtask

    task run_valid;
        input integer w;
        input integer h;
        input integer top_down;
        integer stride;
        integer bytes;
        begin
            reset_case(); case_no=case_no+1;
            stride=((w*3+3)>>2)<<2;
            source_width=w; source_height=h; source_top_down=top_down;
            pixel_offset=509; file_size=509+stride*h;
            fault_kind=0; start=1;
            @(negedge clk); start=0;
            wait(done_ref || error_ref);
            @(negedge clk);
            if (error_ref || pixel_count!=32*24) begin
                $display("FAIL valid case=%0d size=%0dx%0d pixels=%0d error=%b code=%h",
                    case_no,w,h,pixel_count,error_ref,fail_ref);
                $fatal(1,"valid boundary case failed");
            end
            $display("BMP_EQ_VALID PASS size=%0dx%0d top_down=%0d cycles=%0d sectors=%0d",
                w,h,top_down,cycle_count,request_count);
        end
    endtask

    task run_bad;
        input integer w;
        input integer h;
        input integer fault;
        input integer expected_code;
        integer stride;
        begin
            reset_case(); case_no=case_no+1;
            stride=((w*3+3)>>2)<<2;
            source_width=w; source_height=h; source_top_down=0;
            pixel_offset=509; file_size=509+stride*h;
            if (fault==4) file_size=file_size-1;
            fault_kind=fault; start=1;
            @(negedge clk); start=0;
            wait(done_ref || error_ref);
            @(negedge clk);
            if (!error_ref || fail_ref!=expected_code) begin
                $display("FAIL bad case=%0d fault=%0d err=%b code=%h expected=%h",
                    case_no,fault,error_ref,fail_ref,expected_code);
                $fatal(1,"bad-input/error case failed");
            end
            $display("BMP_EQ_ERROR PASS fault=%0d code=%0d cycle=%0d",fault,expected_code,cycle_count);
        end
    endtask

    initial begin
        run_valid(1,1,0);
        run_valid(1024,768,0);
        run_valid(1024,1,1);
        run_valid(1,768,0);
        run_valid(1023,767,1);
        run_valid(191,321,1);
        run_valid(800,599,0);
        run_bad(0,1,0,2);
        run_bad(1025,1,0,2);
        run_bad(191,321,4,3);
        run_bad(32,24,1,6);
        run_bad(32,24,3,7);
        run_bad(32,24,2,1);
        $display("BMP_EQUIV PASS valid=7 errors=6 frame=32x24 pixels=%0d",32*24);
        $finish;
    end

    initial begin
        #500000000;
        $fatal(1,"global timeout");
    end
endmodule
