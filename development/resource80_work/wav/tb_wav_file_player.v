`timescale 1ns/1ps
module tb_wav_file_player;
    reg clk=0, rst=1, sd_init_done=0, file_error=0;
    reg [31:0] file_size=0;
    wire sd_read;
    wire [31:0] sd_addr;
    reg [7:0] sd_data=0;
    reg sd_valid=0, sd_end=0;
    reg capture_enable=0, service_enable=1;
    integer service_bytes=512;
    wire [15:0] sample_data;
    wire sample_available, primed, error;
    wire ref_sd_read, ref_sample_available, ref_primed, ref_error;
    wire [31:0] ref_sd_addr, ref_scan_pos, ref_push_pos, ref_data_offset;
    wire [7:0] ref_scan_byte;
    wire [15:0] ref_sample_data, ref_push_data;
    wire [3:0] ref_debug_state, ref_debug_phase;
    wire ref_debug_sample_push;
    reg [2:0] sample_div=0;
    reg invalid_init=0;
    wire invalid_error, invalid_sd_read;
    wire sample_take = capture_enable && primed && sample_available && (sample_div==0);
    reg [7:0] image [0:4095];
    reg [15:0] expected [0:2047];
    integer expected_n=0, expected_base_n=1, got_n=0, errors=0;
    integer concurrent_pop_push=0;
    integer servicing=0;
    integer k, idx;
    reg [31:0] service_sector;
    integer pos;
    integer scenario;
    integer n;

    always #10 clk=~clk;

    always @(posedge clk) begin
        if (rst) sample_div<=0;
        else sample_div<=sample_div+1'b1;
    end

    tf_wav_file_player #(.FIFO_DEPTH(2048), .WAIT_LIMIT(32'd100)) dut (
        .clk(clk), .rst(rst), .sd_init_done(sd_init_done), .file_size(file_size),
        .file_error(file_error), .sd_read(sd_read), .sd_addr(sd_addr),
        .sd_data(sd_data), .sd_valid(sd_valid), .sd_end(sd_end),
        .sample_take(sample_take), .sample_data(sample_data),
        .sample_available(sample_available), .primed(primed), .error(error)
    );

    tf_wav_file_player_reference #(.FIFO_DEPTH(2048), .WAIT_LIMIT(32'd100)) reference_dut (
        .clk(clk), .rst(rst), .sd_init_done(sd_init_done), .file_size(file_size),
        .file_error(file_error), .sd_read(ref_sd_read), .sd_addr(ref_sd_addr),
        .sd_data(sd_data), .sd_valid(sd_valid), .sd_end(sd_end),
        .sample_take(sample_take), .sample_data(ref_sample_data),
        .sample_available(ref_sample_available), .primed(ref_primed), .error(ref_error),
        .debug_state(ref_debug_state), .debug_phase(ref_debug_phase),
        .debug_scan_pos(ref_scan_pos), .debug_scan_byte(ref_scan_byte),
        .debug_sample_push(ref_debug_sample_push), .debug_push_data(ref_push_data),
        .debug_push_pos(ref_push_pos), .debug_data_offset(ref_data_offset)
    );

    tf_wav_file_player #(.FIFO_DEPTH(300), .WAIT_LIMIT(32'd100)) invalid_fifo_dut (
        .clk(clk), .rst(rst), .sd_init_done(invalid_init), .file_size(32'd64),
        .file_error(1'b0), .sd_read(invalid_sd_read), .sd_addr(),
        .sd_data(8'd0), .sd_valid(1'b0), .sd_end(1'b0),
        .sample_take(1'b0), .sample_data(), .sample_available(),
        .primed(), .error(invalid_error)
    );

    // Fragmented sector responder. Bytes beyond logical file_size are poison
    // so the output check catches accidental final-sector padding.
    always begin
        @(posedge clk);
        if (service_enable && sd_read && !servicing) begin
            servicing=1;
            service_sector=sd_addr;
            for (k=0;k<service_bytes;k=k+1) begin
                if ((k%17)==5) begin
                    @(negedge clk); sd_valid=0;
                    @(negedge clk); sd_valid=0;
                end
                @(negedge clk);
                sd_valid=1;
                idx=service_sector*512+k;
                if (idx<4096) sd_data=image[idx]; else sd_data=8'he7;
            end
            @(negedge clk); sd_valid=0; sd_end=1;
            @(negedge clk); sd_end=0; servicing=0;
        end
    end

    always @(posedge clk) begin
        if (!rst && ({sd_read,sd_addr,sample_available,primed,error,
                      dut.debug_state,dut.debug_phase,dut.debug_scan_pos,dut.debug_scan_byte,
                      dut.debug_sample_push,dut.debug_push_data,dut.debug_push_pos,dut.debug_data_offset} !==
                     {ref_sd_read,ref_sd_addr,ref_sample_available,ref_primed,ref_error,
                      ref_debug_state,ref_debug_phase,ref_scan_pos,ref_scan_byte,
                      ref_debug_sample_push,ref_push_data,ref_push_pos,ref_data_offset})) begin
            $display("DIFFERENTIAL SIGNAL MISMATCH candidate state=%0d pos=%0d ref state=%0d pos=%0d",
                     dut.debug_state,dut.debug_scan_pos,ref_debug_state,ref_scan_pos);
            errors=errors+1;
        end
        if (!rst && sample_available && (sample_data !== ref_sample_data)) begin
            $display("DIFFERENTIAL SAMPLE HEAD MISMATCH candidate=%04h reference=%04h",sample_data,ref_sample_data);
            errors=errors+1;
        end
        if (!rst && dut.fifo_pop && dut.play_push) concurrent_pop_push=concurrent_pop_push+1;
        if (!rst && sample_take) begin
            if (got_n>=expected_n || sample_data!==expected[got_n%expected_base_n]) begin
                $display("SAMPLE MISMATCH got=%0d value=%04h expected=%04h",got_n,sample_data,
                         got_n<expected_n ? expected[got_n%expected_base_n] : 16'hxxxx);
                errors=errors+1;
            end
            got_n=got_n+1;
        end
    end

    task putb(input [7:0] b);
        begin image[pos]=b; pos=pos+1; end
    endtask
    task put32(input [31:0] v);
        begin putb(v[7:0]); putb(v[15:8]); putb(v[23:16]); putb(v[31:24]); end
    endtask
    task begin_riff;
        begin pos=0; putb("R"); putb("I"); putb("F"); putb("F"); put32(0); putb("W"); putb("A"); putb("V"); putb("E"); end
    endtask
    task add_junk(input integer bytes);
        integer j;
        begin putb("J"); putb("U"); putb("N"); putb("K"); put32(bytes);
            for(j=0;j<bytes;j=j+1) putb(8'h80+j[7:0]);
            if(bytes%2) putb(8'h00);
        end
    endtask
    task add_fmt(input integer bytes, input integer rate);
        integer j;
        begin putb("f"); putb("m"); putb("t"); putb(" "); put32(bytes);
            putb(1); putb(0); putb(1); putb(0); put32(rate); put32(rate*2);
            putb(2); putb(0); putb(16); putb(0);
            for(j=16;j<bytes;j=j+1) putb(8'h5a);
            if(bytes%2) putb(0);
        end
    endtask
    task add_data(input integer samples);
        integer j;
        begin putb("d"); putb("a"); putb("t"); putb("a"); put32(samples*2);
            for(j=0;j<samples;j=j+1) begin
                expected[j]=16'h3100+j;
                putb(expected[j][7:0]); putb(expected[j][15:8]);
            end
        end
    endtask
    task finish_riff;
        begin
            image[4]=(pos-8); image[5]=(pos-8)>>8;
            image[6]=(pos-8)>>16; image[7]=(pos-8)>>24;
            file_size=pos;
        end
    endtask
    task clear_image;
        integer j;
        begin for(j=0;j<4096;j=j+1) image[j]=8'he7; end
    endtask
    task build_valid(input integer which, input integer samples);
        begin
            clear_image(); begin_riff();
            case(which)
                0: begin add_fmt(16,48000); add_data(samples); end // canonical 44-byte layout
                1: begin add_junk(3); add_fmt(18,48000); add_data(samples); end
                2: begin add_junk(489); add_fmt(18,48000); add_data(samples); end // fields cross LBA sector
                3: begin add_data(samples); add_junk(1); add_fmt(20,48000); end // data precedes fmt
                4: begin add_junk(3); add_fmt(1024,48000); add_data(samples); end // large fmt extension is skipped
                default: begin add_fmt(16,48000); add_data(samples); end
            endcase
            finish_riff(); expected_base_n=samples; expected_n=samples*2; got_n=0;
        end
    endtask
    task start_case;
        begin
            @(negedge clk); rst=1; sd_init_done=0; file_error=0; service_bytes=512;
            capture_enable=0; service_enable=1; sd_valid=0; sd_end=0;
            repeat(3) @(negedge clk);
            rst=0; sd_init_done=1; capture_enable=1;
        end
    endtask
    task run_valid(input integer which, input integer samples);
        integer cycles;
        begin
            build_valid(which,samples); start_case(); cycles=0;
            while(got_n<expected_n && !error && cycles<500000) begin @(posedge clk); cycles=cycles+1; end
            if(error) begin $display("VALID CASE %0d raised error state=%0d pos=%0d phase=%0d riff_end=%0d id=%h size=%0d fmt=%0d data=%0d img0=%h%h%h%h cache0=%h%h%h%h img=%h%h%h%h cache=%h%h%h%h sd=%b addr=%0d service=%0d servicing=%0d",which,dut.state,dut.scan_pos,dut.scan_phase,dut.riff_end,dut.chunk_id,dut.current_chunk_size,dut.fmt_found,dut.data_found,image[3],image[2],image[1],image[0],dut.sector_mem[3],dut.sector_mem[2],dut.sector_mem[1],dut.sector_mem[0],image[7],image[6],image[5],image[4],dut.sector_mem[7],dut.sector_mem[6],dut.sector_mem[5],dut.sector_mem[4],sd_read,sd_addr,service_sector,servicing); errors=errors+1; end
            if(got_n!=expected_n) begin $display("VALID CASE %0d samples %0d/%0d",which,got_n,expected_n); errors=errors+1; end
            if(!primed) begin $display("VALID CASE %0d did not prime",which); errors=errors+1; end
            $display("valid case %0d: got %0d samples in %0d cycles",which,got_n,cycles);
            capture_enable=0; service_enable=0;
            while(servicing) @(posedge clk);
            rst=1; sd_init_done=0; repeat(4) @(posedge clk);
        end
    endtask
    task run_bad(input integer kind);
        integer cycles;
        begin
            clear_image(); begin_riff();
            if(kind==0) begin add_fmt(14,48000); add_data(2); finish_riff(); end
            else if(kind==1) begin add_fmt(16,44100); add_data(2); finish_riff(); end
            else if(kind==2) begin add_fmt(16,48000); putb("d");putb("a");putb("t");putb("a");put32(3);putb(1);putb(2);putb(3); finish_riff(); end
            else if(kind==3) begin add_fmt(16,48000); add_data(2); finish_riff(); file_size=file_size-2; end
            else if(kind==4) begin add_fmt(16,48000); add_data(2); finish_riff(); image[4]=8'hff;image[5]=8'hff;image[6]=8'hff;image[7]=8'h7f; end
            else begin add_fmt(16,48000); add_data(2); putb("X"); putb("Y"); finish_riff(); end
            expected_base_n=1; expected_n=0; got_n=0; start_case(); cycles=0;
            while(!error && cycles<300000) begin @(posedge clk); cycles=cycles+1; end
            if(!error) begin $display("BAD CASE %0d failed to reject",kind); errors=errors+1; end
            else $display("bad case %0d rejected in %0d cycles",kind,cycles);
            capture_enable=0; service_enable=0;
            while(servicing) @(posedge clk);
            rst=1; sd_init_done=0; repeat(4) @(posedge clk);
        end
    endtask

    initial begin
        // Short payloads loop and prime at their actual sample count; long
        // payload checks exercise every byte of several sectors plus padding.
        run_valid(0,3);
        run_valid(1,5);
        run_valid(2,260);
        run_valid(0,1024); // exact FIFO prime threshold
        run_valid(2,1150); // threshold crossed with multi-sector chunk offset
        run_valid(3,4);
        run_valid(4,4);
        run_bad(0); // fmt payload shorter than PCM base structure
        run_bad(1); // incorrect sample rate
        run_bad(2); // odd PCM data length
        run_bad(3); // file truncates before RIFF extent
        run_bad(4); // RIFF size overflows file extent
        run_bad(5); // RIFF ends with a partial chunk header

        // Logical file sectors must be exactly 512 bytes, including their
        // final sector; short and overlong responders are both fatal.
        clear_image(); begin_riff(); add_fmt(16,48000); add_data(2); finish_riff();
        expected_base_n=1; expected_n=0; got_n=0;
        start_case();
        service_bytes=511;
        begin : short_sector_wait
            integer cycles;
            cycles=0;
            while(!error && cycles<10000) begin @(posedge clk); cycles=cycles+1; end
        end
        if(!error) begin $display("SHORT SECTOR failed to reject"); errors=errors+1; end
        else $display("short sector rejected at byte count %0d",service_bytes);
        capture_enable=0; service_enable=0;
        while(servicing) @(posedge clk);
        rst=1; sd_init_done=0; repeat(4) @(posedge clk);

        clear_image(); begin_riff(); add_fmt(16,48000); add_data(2); finish_riff();
        expected_base_n=1; expected_n=0; got_n=0;
        start_case();
        service_bytes=513;
        begin : long_sector_wait
            integer cycles;
            cycles=0;
            while(!error && cycles<10000) begin @(posedge clk); cycles=cycles+1; end
        end
        if(!error) begin $display("LONG SECTOR failed to reject"); errors=errors+1; end
        else $display("overlong sector rejected at byte count %0d",service_bytes);
        capture_enable=0; service_enable=0;
        while(servicing) @(posedge clk);
        rst=1; sd_init_done=0; repeat(4) @(posedge clk);

        @(negedge clk); rst=0;
        invalid_init=1;
        repeat(3) @(posedge clk);
        if(!invalid_error || invalid_sd_read) begin
            $display("INVALID FIFO_DEPTH was not rejected safely"); errors=errors+1;
        end else $display("invalid FIFO_DEPTH rejected");

        // A mapper fault asserted with startup must win over state progress
        // and remain sticky when the input fault is removed.
        rst=1; invalid_init=0; repeat(3) @(negedge clk);
        rst=0; sd_init_done=1; file_error=1;
        repeat(2) @(posedge clk);
        file_error=0;
        if(!error || sd_read) begin
            $display("same-cycle mapper fault did not halt parser"); errors=errors+1;
        end else $display("same-cycle mapper fault halted parser");

        // No response must terminate via the bounded request watchdog.
        clear_image(); begin_riff(); add_fmt(16,48000); add_data(2); finish_riff();
        start_case(); service_enable=0; got_n=0; expected_n=0;
        repeat(3000) @(posedge clk);
        if(!error) begin $display("NO RESPONSE failed to time out"); errors=errors+1; end
        else $display("no-response request timed out");

        if(concurrent_pop_push==0) begin
            $display("FIFO simultaneous pop/push path was not exercised"); errors=errors+1;
        end else $display("FIFO simultaneous pop/push observed %0d cycles",concurrent_pop_push);

        if(errors==0) $display("PASS: all WAV file player self-checks passed");
        else $display("FAIL: %0d self-check errors",errors);
        $finish;
    end
endmodule

