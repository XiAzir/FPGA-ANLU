`timescale 1ns/1ps

module tb_rgb565_normal_fifo;
    localparam integer FIFO_DEPTH = 512;
    reg clk = 1'b0;
    always #10 clk = ~clk;

    reg rst = 1'b1;
    reg clear = 1'b0;
    reg pack_pixel_en = 1'b0;
    reg [23:0] pack_pixel_rgb = 24'd0;
    wire word_en;
    wire [31:0] packed_word;
    reg read_pixel_en = 1'b0;
    wire [23:0] read_pixel_rgb;
    wire word_pop;
    wire word_empty;
    reg [31:0] fifo_mem [0:FIFO_DEPTH-1];
    integer fifo_count = 0;
    integer write_pointer = 0;
    integer read_pointer = 0;
    reg [31:0] fifo_word_data = 32'd0;
    wire underflow;
    integer random_state = 32'h168b_52f3;
    integer packet_count = 0;
    integer cycle_count = 0;
    integer source_pixel_count = 0;
    integer output_pixel_count = 0;
    integer packet_id;
    integer pixel_index;
    integer gap_count;
    integer p;
    integer i;

    rgb565_pack32 packer (
        .clk(clk), .rst(rst), .clear(clear), .pixel_en(pack_pixel_en),
        .pixel_rgb(pack_pixel_rgb), .word_en(word_en), .word_data(packed_word)
    );
    rgb565_unpack32 unpacker (
        .clk(clk), .rst(rst), .clear(clear), .pixel_en(read_pixel_en),
        .pixel_rgb(read_pixel_rgb), .word_empty(word_empty), .word_pop(word_pop),
        .word_data(fifo_word_data), .underflow(underflow)
    );
    assign word_empty = (fifo_count == 0);

    function [23:0] source_rgb;
        input integer packet;
        input integer index;
        begin
            source_rgb[23:16] = (packet * 41 + index * 37 + (index >> 3) * 11) & 255;
            source_rgb[15:8] = (packet * 73 + index * 19 + 17) & 255;
            source_rgb[7:0] = (packet * 29 + index * 53 + 91) & 255;
        end
    endfunction

    function [23:0] quantized_rgb;
        input [23:0] value;
        reg [4:0] red, blue;
        reg [5:0] green;
        begin
            red = value[23:19];
            green = value[15:10];
            blue = value[7:3];
            quantized_rgb = {red, red[4:2], green, green[5:4], blue, blue[4:2]};
        end
    endfunction

    always @(posedge clk) begin
        if (rst || clear) begin
            fifo_count <= 0;
            write_pointer <= 0;
            read_pointer <= 0;
            fifo_word_data <= 0;
        end else begin
            if (word_en) begin
                if (fifo_count >= FIFO_DEPTH) $fatal(1, "normal FIFO overflow");
                fifo_mem[write_pointer] <= packed_word;
                write_pointer <= (write_pointer + 1) % FIFO_DEPTH;
            end
            if (word_pop && !word_empty) begin
                fifo_word_data <= fifo_mem[read_pointer];
                read_pointer <= (read_pointer + 1) % FIFO_DEPTH;
            end
            case ({word_en, (word_pop && !word_empty)})
                2'b10: fifo_count <= fifo_count + 1;
                2'b01: fifo_count <= fifo_count - 1;
                default: fifo_count <= fifo_count;
            endcase
        end
        cycle_count <= cycle_count + 1;
        if (cycle_count > 200000) $fatal(1, "normal FIFO test timeout");
        if (underflow) $fatal(1, "unpacker underflow packet=%0d output=%0d", packet_count, output_pixel_count);
    end

    task clear_packet_state;
        begin
            @(negedge clk);
            clear = 1'b1;
            pack_pixel_en = 1'b0;
            read_pixel_en = 1'b0;
            @(negedge clk);
            clear = 1'b0;
        end
    endtask

    task send_packet;
        input integer id;
        input integer pixels;
        input integer continuous_input;
        input integer continuous_read;
        integer k;
        begin
            packet_id = id;
            source_pixel_count = 0;
            output_pixel_count = 0;
            for (k = 0; k < pixels; k = k + 1) begin
                if (!continuous_input) begin
                    random_state = $random(random_state);
                    gap_count = (random_state & 3);
                    repeat (gap_count) begin
                        @(negedge clk);
                        pack_pixel_en = 1'b0;
                    end
                end
                @(negedge clk);
                pack_pixel_rgb = source_rgb(id, k);
                pack_pixel_en = 1'b1;
                @(posedge clk);
                source_pixel_count = source_pixel_count + 1;
                if (!continuous_input) begin
                    @(negedge clk);
                    pack_pixel_en = 1'b0;
                end
            end
            @(negedge clk);
            pack_pixel_en = 1'b0;

            repeat (4) @(posedge clk);
            repeat (8) @(posedge clk);
            for (k = 0; k < pixels; k = k + 1) begin
                if (!continuous_read) begin
                    random_state = $random(random_state);
                    gap_count = (random_state & 3);
                    repeat (gap_count) begin
                        @(negedge clk);
                        read_pixel_en = 1'b0;
                    end
                end
                @(negedge clk);
                read_pixel_en = 1'b1;
                @(posedge clk);
                #1;
                if (read_pixel_rgb !== quantized_rgb(source_rgb(id, k)))
                    $fatal(1, "packet=%0d pixel=%0d got=%06x expected=%06x",
                        id, k, read_pixel_rgb, quantized_rgb(source_rgb(id, k)));
                output_pixel_count = output_pixel_count + 1;
                if (!continuous_read) begin
                    @(negedge clk);
                    read_pixel_en = 1'b0;
                end
            end
            @(negedge clk);
            read_pixel_en = 1'b0;
            repeat (8) @(posedge clk);
            if (fifo_count != 0) $fatal(1, "packet=%0d FIFO remaining words=%0d", id, fifo_count);
            if (source_pixel_count != pixels || output_pixel_count != pixels)
                $fatal(1, "packet=%0d count mismatch source=%0d output=%0d expected=%0d",
                    id, source_pixel_count, output_pixel_count, pixels);
            packet_count = packet_count + 1;
            $display("PACKET_PASS id=%0d pixels=%0d", id, pixels);
        end
    endtask

    initial begin
        repeat (4) @(negedge clk);
        rst = 1'b0;
        clear_packet_state();

        // Discard a lone first halfword at a packet boundary.
        @(negedge clk);
        pack_pixel_rgb = 24'hd39a71;
        pack_pixel_en = 1'b1;
        @(posedge clk);
        clear_packet_state();

        send_packet(0, 128, 1, 1);
        clear_packet_state();
        send_packet(1, 86, 0, 0);
        clear_packet_state();
        send_packet(2, 64, 0, 0);

        $display("PASS rgb565_normal_fifo packets=%0d cycles=%0d random_blank=1 normal_read_latency=1", packet_count, cycle_count);
        $finish;
    end
endmodule
