`timescale 1ns/1ps

module tb_bmp_file_negative;
    localparam integer W = 4;
    localparam integer H = 2;
    localparam integer PIXELS = W*H*3;

    reg clk = 0;
    always #10 clk = ~clk;
    reg rst, catalog_ready, key_next, key_auto;
    reg [2:0] bmp_count;
    reg [127:0] bmp_clusters, bmp_sizes;
    wire [31:0] file_cluster, file_size;
    wire card_read;
    wire [31:0] card_addr;
    reg [7:0] card_data;
    reg card_valid, card_end, file_error;
    reg write_finish_toggle;
    wire [1:0] write_buf_idx, disp_buf_idx;
    wire write_req, write_en;
    reg write_req_ack;
    wire [23:0] write_data;
    wire display_valid, error;
    wire [3:0] state_code;

    tf_bmp_file_player #(.CLK_FREQ_HZ(1000), .FRAME_WIDTH(W), .FRAME_HEIGHT(H), .WAIT_LIMIT(80)) dut (
        .clk(clk), .rst(rst), .key_next(key_next), .key_auto(key_auto),
        .catalog_ready(catalog_ready), .bmp_count(bmp_count),
        .bmp_clusters(bmp_clusters), .bmp_sizes(bmp_sizes),
        .file_cluster(file_cluster), .file_size(file_size),
        .card_read(card_read), .card_addr(card_addr), .card_data(card_data),
        .card_valid(card_valid), .card_end(card_end), .file_error(file_error),
        .write_finish_toggle(write_finish_toggle), .write_buf_idx(write_buf_idx),
        .disp_buf_idx(disp_buf_idx), .write_req(write_req), .write_req_ack(write_req_ack),
        .write_en(write_en), .write_data(write_data), .display_valid(display_valid),
        .error(error), .state_code(state_code)
    );

    reg [7:0] fixture [0:1023];
    integer scenario, write_count, response_index, response_limit, ack_wait;
    integer response_active, gap_count, total_responses;
    reg [23:0] observed [0:7];
    reg [23:0] expected [0:7];
    reg feed_enabled;

    always @(posedge clk) begin
        if (rst) begin
            write_count <= 0;
            total_responses <= 0;
        end else begin
            if (write_en) begin
                if (write_count < 8) observed[write_count] <= write_data;
                write_count <= write_count + 1;
            end
            if (write_req && !write_req_ack && (card_read || write_en))
                $fatal(1,"player started frame I/O before write request acknowledgement");
            if (card_end) total_responses <= total_responses + 1;
        end
    end

    // Respond with a complete logical sector, with gaps between bytes. The
    // shortened-sector and timeout cases intentionally violate that contract.
    always @(negedge clk) begin
        card_valid = 0;
        card_end = 0;
        write_req_ack = 0;
        if (rst || !write_req) ack_wait = 0;
        else begin
            ack_wait = ack_wait + 1;
            if (ack_wait >= 4) write_req_ack = 1;
        end
        if (rst || !feed_enabled || !card_read) begin
            response_active = 0;
            response_index = 0;
            gap_count = 0;
        end else if (scenario != 8) begin
            if (!response_active) begin
                response_active = 1;
                response_index = 0;
                gap_count = 0;
            end else if (gap_count != 0) begin
                gap_count = gap_count - 1;
            end else if (response_index < response_limit) begin
                card_data = fixture[(card_addr*512 + response_index) & 1023];
                card_valid = 1;
                response_index = response_index + 1;
                gap_count = (response_index % 7 == 0) ? 2 : 0;
            end else begin
                card_end = 1;
                response_active = 0;
            end
        end
    end

    task put32;
        input integer at;
        input [31:0] value;
        begin
            fixture[at] = value[7:0]; fixture[at+1] = value[15:8];
            fixture[at+2] = value[23:16]; fixture[at+3] = value[31:24];
        end
    endtask

    task build_fixture;
        input integer kind;
        integer i;
        reg [31:0] off, declared, fw, fh, comp;
        begin
            for (i=0; i<1024; i=i+1) fixture[i] = 8'he7;
            off=70; declared=off+PIXELS; fw=W; fh=H; comp=0;
            case(kind)
                1: off=20;                       // pixels overlap DIB header
                2: declared=off+PIXELS-1;        // declared image truncated
                3: declared=off+PIXELS+1;        // declared file exceeds descriptor
                4: fw=W+1;                       // wrong geometry
                5: comp=1;                        // compressed data
                6: off=32'hfffffff0;              // pixel end overflows 32 bits
                default: begin end
            endcase
            fixture[0]="B"; fixture[1]="M";
            put32(2, declared);
            put32(10, off);
            put32(14, 40);
            put32(18, fw);
            put32(22, fh);
            fixture[26]=1; fixture[27]=0;
            fixture[28]=24; fixture[29]=0;
            put32(30, comp);
            // The eight source pixels encode distinct B,G,R bytes.
            for (i=0; i<8; i=i+1) begin
                fixture[off+i*3]   = 8'h10+i;
                fixture[off+i*3+1] = 8'h40+i;
                fixture[off+i*3+2] = 8'h80+i;
                expected[i] = {fixture[off+i*3+2],fixture[off+i*3+1],fixture[off+i*3]};
            end
        end
    endtask

    task reset_case;
        begin
            rst=1; catalog_ready=0; key_next=0; key_auto=0;
            card_data=0; card_valid=0; card_end=0; file_error=0;
            write_finish_toggle=0; write_req_ack=0; feed_enabled=1;
            bmp_count=1; bmp_clusters=128'd2; bmp_sizes=128'd94;
            repeat(4) @(negedge clk);
            rst=0; catalog_ready=1;
            repeat(3) @(negedge clk);
        end
    endtask

    task await_error;
        input [255:0] label_text;
        integer n;
        begin
            n=0;
            while (!error && n<3000) begin @(negedge clk); n=n+1; end
            if (!error) $fatal(1,"%0s: expected sticky error, state=%0d",label_text,state_code);
            if (write_req || write_count!=0 || display_valid || disp_buf_idx!=0)
                $fatal(1,"%0s: invalid image escaped into write/display path",label_text);
        end
    endtask

    integer n, i;
    initial begin
        scenario=0; response_active=0; response_index=0; response_limit=512; ack_wait=0;
        gap_count=0; total_responses=0; feed_enabled=1;
        // Valid image: offset is 70 (not 54), sector gaps are fragmented,
        // BGR bytes become RGB words, and display ownership waits for commit.
        scenario=0; response_limit=512; build_fixture(0); reset_case();
        n=0;
        while (write_count<8 && !error && n<5000) begin @(negedge clk); n=n+1; end
        if (write_count!=8 || error) $fatal(1,"valid non-54 BMP did not emit exactly 8 pixels");
        for (i=0;i<8;i=i+1) if (observed[i]!==expected[i])
            $fatal(1,"BGR conversion mismatch at pixel %0d: got %h expected %h",i,observed[i],expected[i]);
        if (display_valid || disp_buf_idx!=0) $fatal(1,"display buffer flipped before writer completion");
        n=0;
        while (state_code!=7 && !error && n<5000) begin @(negedge clk); n=n+1; end
        if (state_code!=7 || error) $fatal(1,"valid payload did not reach commit state");
        write_finish_toggle=1;
        n=0;
        while (!display_valid && n<20) begin @(negedge clk); n=n+1; end
        if (!display_valid || disp_buf_idx!=0) $fatal(1,"valid frame did not commit after finish toggle");

        // Invalid header variants all fail before requesting the frame buffer.
        for (scenario=1; scenario<=6; scenario=scenario+1) begin
            response_limit=512; build_fixture(scenario==6 ? 0 : scenario);
            if (scenario==6) begin // offset+frame extent overflow
                put32(10,32'hfffffff0); put32(2,32'hffffffff);
                bmp_sizes=128'hffffffff;
            end else bmp_sizes=128'd94;
            reset_case(); await_error("invalid header");
        end

        // A physical sector with only 511 bytes must be rejected.
        scenario=7; response_limit=511; build_fixture(0); reset_case();
        await_error("short sector");

        scenario=9; response_limit=513; build_fixture(0); reset_case();
        await_error("overlong sector");

        // A stalled card read must trip the watchdog and leave the buffers alone.
        scenario=8; response_limit=512; build_fixture(0); reset_case(); feed_enabled=0;
        await_error("card timeout");

        $display("PASS tb_bmp_file_negative");
        $finish;
    end
endmodule

// The dedicated bench never drives the UI buttons; keep their pulse source
// inert and isolated from the board debounce implementation.
module key_press_debounce #(parameter integer CLK_FREQ_HZ=50000000, parameter integer DEBOUNCE_MS=50)(
    input clk, input rst, input button_in, output wire press_pulse
);
    assign press_pulse = 1'b0;
endmodule
