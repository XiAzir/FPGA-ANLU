module player_osd (
    input  wire        clk,
    input  wire        rst,
    input  wire        vs,
    input  wire        de,
    input  wire [23:0] rgb_in,
    input  wire [1:0]  image_index,
    input  wire [2:0]  image_count,
    input  wire        auto_mode,
    input  wire        image_valid,
    output wire [23:0] rgb_out
);
    localparam [3:0] GLYPH_BLANK = 4'd0;
    localparam [3:0] GLYPH_I     = 4'd1;
    localparam [3:0] GLYPH_M     = 4'd2;
    localparam [3:0] GLYPH_G     = 4'd3;
    localparam [3:0] GLYPH_1     = 4'd4;
    localparam [3:0] GLYPH_SLASH = 4'd5;
    localparam [3:0] GLYPH_4     = 4'd6;
    localparam [3:0] GLYPH_A     = 4'd7;
    localparam [3:0] GLYPH_U     = 4'd8;
    localparam [3:0] GLYPH_T     = 4'd9;
    localparam [3:0] GLYPH_O     = 4'd10;
    localparam [3:0] GLYPH_N     = 4'd11;
    localparam [3:0] GLYPH_L     = 4'd12;
    localparam [3:0] GLYPH_0     = 4'd13;
    localparam [3:0] GLYPH_2     = 4'd14;
    localparam [3:0] GLYPH_3     = 4'd15;

    reg [9:0] x_pos;
    reg [8:0] y_pos;
    reg       de_prev;
    reg       vs_prev;
    reg       arm_first_line;

    // Track coordinates from active-video edges. VS polarity is irrelevant:
    // either transition arms the next active line at y=0.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_pos          <= 10'd0;
            y_pos          <= 9'd0;
            de_prev        <= 1'b0;
            vs_prev        <= 1'b0;
            arm_first_line <= 1'b1;
        end else begin
            de_prev <= de;
            vs_prev <= vs;

            if (vs != vs_prev) begin
                x_pos          <= 10'd0;
                y_pos          <= 9'd0;
                arm_first_line <= 1'b1;
            end else if (de) begin
                x_pos <= x_pos + 10'd1;
                if (!de_prev && arm_first_line) begin
                    y_pos          <= 9'd0;
                    arm_first_line <= 1'b0;
                end
            end else begin
                x_pos <= 10'd0;
                if (de_prev && y_pos != 9'd511)
                    y_pos <= y_pos + 9'd1;
            end
        end
    end

    reg [3:0] current_symbol;
    reg [3:0] total_symbol;
    reg [3:0] glyph_symbol;
    reg [2:0] glyph_row_index;
    reg [2:0] glyph_column;
    reg [7:0] glyph_row_bits;
    reg       glyph_on;
    wire [9:0] text_x = x_pos - 10'd24;
    wire [8:0] text_y = y_pos - 9'd24;
    wire [3:0] character_index = text_x[7:4];

    // Preserve any supported total even when no image is currently valid.
    // Unsupported counts and count=0 display 0/0.
    always @* begin
        current_symbol = GLYPH_0;
        total_symbol   = GLYPH_0;
        case (image_count)
            3'd1: total_symbol = GLYPH_1;
            3'd2: total_symbol = GLYPH_2;
            3'd3: total_symbol = GLYPH_3;
            3'd4: total_symbol = GLYPH_4;
            default: total_symbol = GLYPH_0;
        endcase

        if (image_valid) begin
            case (image_index)
                2'd0: current_symbol = GLYPH_1;
                2'd1: current_symbol = GLYPH_2;
                2'd2: current_symbol = GLYPH_3;
                2'd3: current_symbol = GLYPH_4;
                default: current_symbol = GLYPH_0;
            endcase
            if (image_index >= image_count || image_count == 3'd0 ||
                image_count > 3'd4)
                current_symbol = GLYPH_0;
        end
    end

    always @* begin
        glyph_symbol = GLYPH_BLANK;
        case (character_index)
            4'd0: glyph_symbol = GLYPH_I;
            4'd1: glyph_symbol = GLYPH_M;
            4'd2: glyph_symbol = GLYPH_G;
            4'd4: glyph_symbol = current_symbol;
            4'd5: glyph_symbol = GLYPH_SLASH;
            4'd6: glyph_symbol = total_symbol;
            4'd8: glyph_symbol = auto_mode ? GLYPH_A : GLYPH_M;
            4'd9: glyph_symbol = auto_mode ? GLYPH_U : GLYPH_A;
            4'd10: glyph_symbol = auto_mode ? GLYPH_T : GLYPH_N;
            4'd11: glyph_symbol = auto_mode ? GLYPH_O : GLYPH_U;
            4'd12: glyph_symbol = auto_mode ? GLYPH_BLANK : GLYPH_A;
            4'd13: glyph_symbol = auto_mode ? GLYPH_BLANK : GLYPH_L;
            default: glyph_symbol = GLYPH_BLANK;
        endcase

        glyph_row_index = text_y[3:1];
        glyph_column    = text_x[3:1];
        glyph_row_bits  = 8'd0;
        case ({glyph_symbol, glyph_row_index})
            // I
            {GLYPH_I,3'd0}: glyph_row_bits = 8'b11111000;
            {GLYPH_I,3'd1}: glyph_row_bits = 8'b00100000;
            {GLYPH_I,3'd2}: glyph_row_bits = 8'b00100000;
            {GLYPH_I,3'd3}: glyph_row_bits = 8'b00100000;
            {GLYPH_I,3'd4}: glyph_row_bits = 8'b00100000;
            {GLYPH_I,3'd5}: glyph_row_bits = 8'b00100000;
            {GLYPH_I,3'd6}: glyph_row_bits = 8'b11111000;
            // M
            {GLYPH_M,3'd0}: glyph_row_bits = 8'b10001000;
            {GLYPH_M,3'd1}: glyph_row_bits = 8'b11011000;
            {GLYPH_M,3'd2}: glyph_row_bits = 8'b10101000;
            {GLYPH_M,3'd3}: glyph_row_bits = 8'b10101000;
            {GLYPH_M,3'd4}: glyph_row_bits = 8'b10001000;
            {GLYPH_M,3'd5}: glyph_row_bits = 8'b10001000;
            {GLYPH_M,3'd6}: glyph_row_bits = 8'b10001000;
            // G
            {GLYPH_G,3'd0}: glyph_row_bits = 8'b01110000;
            {GLYPH_G,3'd1}: glyph_row_bits = 8'b10001000;
            {GLYPH_G,3'd2}: glyph_row_bits = 8'b10000000;
            {GLYPH_G,3'd3}: glyph_row_bits = 8'b10111000;
            {GLYPH_G,3'd4}: glyph_row_bits = 8'b10001000;
            {GLYPH_G,3'd5}: glyph_row_bits = 8'b10001000;
            {GLYPH_G,3'd6}: glyph_row_bits = 8'b01110000;
            // 1
            {GLYPH_1,3'd0}: glyph_row_bits = 8'b00100000;
            {GLYPH_1,3'd1}: glyph_row_bits = 8'b01100000;
            {GLYPH_1,3'd2}: glyph_row_bits = 8'b00100000;
            {GLYPH_1,3'd3}: glyph_row_bits = 8'b00100000;
            {GLYPH_1,3'd4}: glyph_row_bits = 8'b00100000;
            {GLYPH_1,3'd5}: glyph_row_bits = 8'b00100000;
            {GLYPH_1,3'd6}: glyph_row_bits = 8'b01110000;
            // /
            {GLYPH_SLASH,3'd0}: glyph_row_bits = 8'b00001000;
            {GLYPH_SLASH,3'd1}: glyph_row_bits = 8'b00010000;
            {GLYPH_SLASH,3'd2}: glyph_row_bits = 8'b00100000;
            {GLYPH_SLASH,3'd3}: glyph_row_bits = 8'b01000000;
            {GLYPH_SLASH,3'd4}: glyph_row_bits = 8'b10000000;
            {GLYPH_SLASH,3'd5}: glyph_row_bits = 8'b00000000;
            {GLYPH_SLASH,3'd6}: glyph_row_bits = 8'b00000000;
            // 4
            {GLYPH_4,3'd0}: glyph_row_bits = 8'b10010000;
            {GLYPH_4,3'd1}: glyph_row_bits = 8'b10010000;
            {GLYPH_4,3'd2}: glyph_row_bits = 8'b10010000;
            {GLYPH_4,3'd3}: glyph_row_bits = 8'b11111000;
            {GLYPH_4,3'd4}: glyph_row_bits = 8'b00010000;
            {GLYPH_4,3'd5}: glyph_row_bits = 8'b00010000;
            {GLYPH_4,3'd6}: glyph_row_bits = 8'b00010000;
            // A
            {GLYPH_A,3'd0}: glyph_row_bits = 8'b01110000;
            {GLYPH_A,3'd1}: glyph_row_bits = 8'b10001000;
            {GLYPH_A,3'd2}: glyph_row_bits = 8'b10001000;
            {GLYPH_A,3'd3}: glyph_row_bits = 8'b11111000;
            {GLYPH_A,3'd4}: glyph_row_bits = 8'b10001000;
            {GLYPH_A,3'd5}: glyph_row_bits = 8'b10001000;
            {GLYPH_A,3'd6}: glyph_row_bits = 8'b10001000;
            // U
            {GLYPH_U,3'd0}: glyph_row_bits = 8'b10001000;
            {GLYPH_U,3'd1}: glyph_row_bits = 8'b10001000;
            {GLYPH_U,3'd2}: glyph_row_bits = 8'b10001000;
            {GLYPH_U,3'd3}: glyph_row_bits = 8'b10001000;
            {GLYPH_U,3'd4}: glyph_row_bits = 8'b10001000;
            {GLYPH_U,3'd5}: glyph_row_bits = 8'b10001000;
            {GLYPH_U,3'd6}: glyph_row_bits = 8'b01110000;
            // T
            {GLYPH_T,3'd0}: glyph_row_bits = 8'b11111000;
            {GLYPH_T,3'd1}: glyph_row_bits = 8'b00100000;
            {GLYPH_T,3'd2}: glyph_row_bits = 8'b00100000;
            {GLYPH_T,3'd3}: glyph_row_bits = 8'b00100000;
            {GLYPH_T,3'd4}: glyph_row_bits = 8'b00100000;
            {GLYPH_T,3'd5}: glyph_row_bits = 8'b00100000;
            {GLYPH_T,3'd6}: glyph_row_bits = 8'b00100000;
            // O
            {GLYPH_O,3'd0}: glyph_row_bits = 8'b01110000;
            {GLYPH_O,3'd1}: glyph_row_bits = 8'b10001000;
            {GLYPH_O,3'd2}: glyph_row_bits = 8'b10001000;
            {GLYPH_O,3'd3}: glyph_row_bits = 8'b10001000;
            {GLYPH_O,3'd4}: glyph_row_bits = 8'b10001000;
            {GLYPH_O,3'd5}: glyph_row_bits = 8'b10001000;
            {GLYPH_O,3'd6}: glyph_row_bits = 8'b01110000;
            // N
            {GLYPH_N,3'd0}: glyph_row_bits = 8'b10001000;
            {GLYPH_N,3'd1}: glyph_row_bits = 8'b11001000;
            {GLYPH_N,3'd2}: glyph_row_bits = 8'b10101000;
            {GLYPH_N,3'd3}: glyph_row_bits = 8'b10011000;
            {GLYPH_N,3'd4}: glyph_row_bits = 8'b10001000;
            {GLYPH_N,3'd5}: glyph_row_bits = 8'b10001000;
            {GLYPH_N,3'd6}: glyph_row_bits = 8'b10001000;
            // L
            {GLYPH_L,3'd0}: glyph_row_bits = 8'b10000000;
            {GLYPH_L,3'd1}: glyph_row_bits = 8'b10000000;
            {GLYPH_L,3'd2}: glyph_row_bits = 8'b10000000;
            {GLYPH_L,3'd3}: glyph_row_bits = 8'b10000000;
            {GLYPH_L,3'd4}: glyph_row_bits = 8'b10000000;
            {GLYPH_L,3'd5}: glyph_row_bits = 8'b10000000;
            {GLYPH_L,3'd6}: glyph_row_bits = 8'b11111000;
            // 0
            {GLYPH_0,3'd0}: glyph_row_bits = 8'b01110000;
            {GLYPH_0,3'd1}: glyph_row_bits = 8'b10001000;
            {GLYPH_0,3'd2}: glyph_row_bits = 8'b10011000;
            {GLYPH_0,3'd3}: glyph_row_bits = 8'b10101000;
            {GLYPH_0,3'd4}: glyph_row_bits = 8'b11001000;
            {GLYPH_0,3'd5}: glyph_row_bits = 8'b10001000;
            {GLYPH_0,3'd6}: glyph_row_bits = 8'b01110000;
            // 2
            {GLYPH_2,3'd0}: glyph_row_bits = 8'b01110000;
            {GLYPH_2,3'd1}: glyph_row_bits = 8'b10001000;
            {GLYPH_2,3'd2}: glyph_row_bits = 8'b00001000;
            {GLYPH_2,3'd3}: glyph_row_bits = 8'b00010000;
            {GLYPH_2,3'd4}: glyph_row_bits = 8'b00100000;
            {GLYPH_2,3'd5}: glyph_row_bits = 8'b01000000;
            {GLYPH_2,3'd6}: glyph_row_bits = 8'b11111000;
            // 3
            {GLYPH_3,3'd0}: glyph_row_bits = 8'b11110000;
            {GLYPH_3,3'd1}: glyph_row_bits = 8'b00001000;
            {GLYPH_3,3'd2}: glyph_row_bits = 8'b00001000;
            {GLYPH_3,3'd3}: glyph_row_bits = 8'b01110000;
            {GLYPH_3,3'd4}: glyph_row_bits = 8'b00001000;
            {GLYPH_3,3'd5}: glyph_row_bits = 8'b00001000;
            {GLYPH_3,3'd6}: glyph_row_bits = 8'b11110000;
            default: glyph_row_bits = 8'd0;
        endcase
    end

    always @* begin
        glyph_on = 1'b0;
        if (glyph_column < 3'd5 && glyph_row_index < 3'd7)
            glyph_on = glyph_row_bits[3'd7 - glyph_column];
    end

    wire in_box = (x_pos >= 10'd16) && (x_pos < 10'd256) &&
                  (y_pos >= 9'd16) && (y_pos < 9'd48);
    wire in_text = (x_pos >= 10'd24) && (x_pos < 10'd248) &&
                   (y_pos >= 9'd24) && (y_pos < 9'd40);

    // Keep blanking RGB and every non-OSD active pixel exactly as received.
    assign rgb_out = (!de) ? rgb_in :
                     (in_box ? ((in_text && glyph_on) ? 24'hffffff : 24'h000000)
                             : rgb_in);
endmodule
