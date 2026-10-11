module player_dynamic_text #(
    parameter integer CLK_FREQ_HZ = 25000000
) (
    input  wire        clk,
    input  wire        rst,
    input  wire        vs,
    input  wire        de,
    input  wire [23:0] rgb_in,
    output wire [23:0] rgb_out
);
    localparam integer TICK_WIDTH = (CLK_FREQ_HZ > 1) ? $clog2(CLK_FREQ_HZ) : 1;

    reg [TICK_WIDTH-1:0] second_tick;
    reg [3:0] minute_tens;
    reg [3:0] minute_ones;
    reg [3:0] second_tens;
    reg [3:0] second_ones;
    reg [3:0] display_minute_tens;
    reg [3:0] display_minute_ones;
    reg [3:0] display_second_tens;
    reg [3:0] display_second_ones;

    reg [9:0] x_pos;
    reg [8:0] y_pos;
    reg de_prev;
    reg vs_prev;
    reg arm_first_line;
    reg [9:0] scroll_phase;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            second_tick        <= {TICK_WIDTH{1'b0}};
            minute_tens        <= 4'd0;
            minute_ones        <= 4'd0;
            second_tens        <= 4'd0;
            second_ones        <= 4'd0;
            display_minute_tens  <= 4'd0;
            display_minute_ones  <= 4'd0;
            display_second_tens <= 4'd0;
            display_second_ones <= 4'd0;
            x_pos              <= 10'd0;
            y_pos              <= 9'd0;
            de_prev            <= 1'b0;
            vs_prev            <= 1'b0;
            arm_first_line     <= 1'b1;
            scroll_phase       <= 10'd0;
        end else begin
            if (second_tick == CLK_FREQ_HZ - 1) begin
                second_tick <= {TICK_WIDTH{1'b0}};
                if (second_ones == 4'd9) begin
                    second_ones <= 4'd0;
                    if (second_tens == 4'd5) begin
                        second_tens <= 4'd0;
                        if (minute_ones == 4'd9) begin
                            minute_ones <= 4'd0;
                            if (minute_tens == 4'd9)
                                minute_tens <= 4'd0;
                            else
                                minute_tens <= minute_tens + 4'd1;
                        end else begin
                            minute_ones <= minute_ones + 4'd1;
                        end
                    end else begin
                        second_tens <= second_tens + 4'd1;
                    end
                end else begin
                    second_ones <= second_ones + 4'd1;
                end
            end else begin
                second_tick <= second_tick + {{(TICK_WIDTH-1){1'b0}}, 1'b1};
            end

            de_prev <= de;
            vs_prev <= vs;
            if (vs != vs_prev) begin
                x_pos <= 10'd0;
                y_pos <= 9'd0;
                arm_first_line <= 1'b1;
                display_minute_tens  <= minute_tens;
                display_minute_ones  <= minute_ones;
                display_second_tens <= second_tens;
                display_second_ones <= second_ones;
                if (vs && scroll_phase == 10'd879)
                    scroll_phase <= 10'd0;
                else if (vs)
                    scroll_phase <= scroll_phase + 10'd1;
            end else if (de) begin
                x_pos <= x_pos + 10'd1;
                if (!de_prev && arm_first_line) begin
                    y_pos <= 9'd0;
                    arm_first_line <= 1'b0;
                end
            end else begin
                x_pos <= 10'd0;
                if (de_prev && y_pos != 9'd511)
                    y_pos <= y_pos + 9'd1;
            end
        end
    end

    function [4:0] glyph_row;
        input [7:0] character;
        input [2:0] row;
        begin
            glyph_row = 5'b00000;
            case (character)
                "A": case (row)
                    0:glyph_row=5'b01110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b11111; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "D": case (row)
                    0:glyph_row=5'b11110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b10001; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b11110; default:glyph_row=5'b00000;
                endcase
                "E": case (row)
                    0:glyph_row=5'b11111; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b11111; default:glyph_row=5'b00000;
                endcase
                "F": case (row)
                    0:glyph_row=5'b11111; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b10000; default:glyph_row=5'b00000;
                endcase
                "G": case (row)
                    0:glyph_row=5'b01111; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b10111; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b01111; default:glyph_row=5'b00000;
                endcase
                "I": case (row)
                    0:glyph_row=5'b11111; 1:glyph_row=5'b00100; 2:glyph_row=5'b00100;
                    3:glyph_row=5'b00100; 4:glyph_row=5'b00100; 5:glyph_row=5'b00100;
                    6:glyph_row=5'b11111; default:glyph_row=5'b00000;
                endcase
                "L": case (row)
                    0:glyph_row=5'b10000; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b10000; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b11111; default:glyph_row=5'b00000;
                endcase
                "M": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b11011; 2:glyph_row=5'b10101;
                    3:glyph_row=5'b10101; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "N": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b11001; 2:glyph_row=5'b10101;
                    3:glyph_row=5'b10011; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "P": case (row)
                    0:glyph_row=5'b11110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b10000; 5:glyph_row=5'b10000;
                    6:glyph_row=5'b10000; default:glyph_row=5'b00000;
                endcase
                "R": case (row)
                    0:glyph_row=5'b11110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b10100; 5:glyph_row=5'b10010;
                    6:glyph_row=5'b10001; default:glyph_row=5'b00000;
                endcase
                "U": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b10001; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b01110; default:glyph_row=5'b00000;
                endcase
                "Y": case (row)
                    0:glyph_row=5'b10001; 1:glyph_row=5'b10001; 2:glyph_row=5'b01010;
                    3:glyph_row=5'b00100; 4:glyph_row=5'b00100; 5:glyph_row=5'b00100;
                    6:glyph_row=5'b00100; default:glyph_row=5'b00000;
                endcase
                "0": case (row)
                    0:glyph_row=5'b01110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10011;
                    3:glyph_row=5'b10101; 4:glyph_row=5'b11001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b01110; default:glyph_row=5'b00000;
                endcase
                "1": case (row)
                    0:glyph_row=5'b00100; 1:glyph_row=5'b01100; 2:glyph_row=5'b00100;
                    3:glyph_row=5'b00100; 4:glyph_row=5'b00100; 5:glyph_row=5'b00100;
                    6:glyph_row=5'b01110; default:glyph_row=5'b00000;
                endcase
                "2": case (row)
                    0:glyph_row=5'b01110; 1:glyph_row=5'b10001; 2:glyph_row=5'b00001;
                    3:glyph_row=5'b00010; 4:glyph_row=5'b00100; 5:glyph_row=5'b01000;
                    6:glyph_row=5'b11111; default:glyph_row=5'b00000;
                endcase
                "3": case (row)
                    0:glyph_row=5'b11110; 1:glyph_row=5'b00001; 2:glyph_row=5'b00001;
                    3:glyph_row=5'b01110; 4:glyph_row=5'b00001; 5:glyph_row=5'b00001;
                    6:glyph_row=5'b11110; default:glyph_row=5'b00000;
                endcase
                "4": case (row)
                    0:glyph_row=5'b10010; 1:glyph_row=5'b10010; 2:glyph_row=5'b10010;
                    3:glyph_row=5'b11111; 4:glyph_row=5'b00010; 5:glyph_row=5'b00010;
                    6:glyph_row=5'b00010; default:glyph_row=5'b00000;
                endcase
                "5": case (row)
                    0:glyph_row=5'b11111; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b00001; 5:glyph_row=5'b00001;
                    6:glyph_row=5'b11110; default:glyph_row=5'b00000;
                endcase
                "6": case (row)
                    0:glyph_row=5'b01111; 1:glyph_row=5'b10000; 2:glyph_row=5'b10000;
                    3:glyph_row=5'b11110; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b01110; default:glyph_row=5'b00000;
                endcase
                "7": case (row)
                    0:glyph_row=5'b11111; 1:glyph_row=5'b00001; 2:glyph_row=5'b00010;
                    3:glyph_row=5'b00100; 4:glyph_row=5'b01000; 5:glyph_row=5'b01000;
                    6:glyph_row=5'b01000; default:glyph_row=5'b00000;
                endcase
                "8": case (row)
                    0:glyph_row=5'b01110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b01110; 4:glyph_row=5'b10001; 5:glyph_row=5'b10001;
                    6:glyph_row=5'b01110; default:glyph_row=5'b00000;
                endcase
                "9": case (row)
                    0:glyph_row=5'b01110; 1:glyph_row=5'b10001; 2:glyph_row=5'b10001;
                    3:glyph_row=5'b01111; 4:glyph_row=5'b00001; 5:glyph_row=5'b00001;
                    6:glyph_row=5'b11110; default:glyph_row=5'b00000;
                endcase
                ":": case (row)
                    2:glyph_row=5'b00100; 3:glyph_row=5'b00100; 5:glyph_row=5'b00100;
                    6:glyph_row=5'b00100; default:glyph_row=5'b00000;
                endcase
                default: glyph_row = 5'b00000;
            endcase
        end
    endfunction

    reg [7:0] glyph_character;
    reg [2:0] time_glyph_row_index;
    reg [2:0] time_glyph_column;
    reg [4:0] time_glyph_bits;
    reg [2:0] scroll_glyph_row_index;
    reg [2:0] scroll_glyph_column;
    reg [4:0] scroll_glyph_bits;
    reg top_glyph_on;
    reg bottom_glyph_on;
    reg [3:0] time_character_index;
    reg [7:0] time_character;
    wire [9:0] time_text_x = x_pos - 10'd456;
    wire [8:0] time_text_y = y_pos - 9'd24;
    wire [10:0] scroll_sum = {1'b0, x_pos} + {1'b0, scroll_phase};
    wire scroll_text_visible = (scroll_sum >= 11'd624) &&
                               (scroll_sum < 11'd896);
    wire [8:0] scroll_text_x = scroll_sum - 11'd624;
    wire [8:0] scroll_text_y = y_pos - 9'd440;

    always @* begin
        time_character_index = time_text_x[7:4];
        time_character = 8'h20;
        time_glyph_row_index = 3'd0;
        time_glyph_column = 3'd0;
        time_glyph_bits = 5'd0;
        case (time_character_index)
            0: time_character = "R";
            1: time_character = "U";
            2: time_character = "N";
            3: time_character = 8'h20;
            4: time_character = {4'h3, display_minute_tens};
            5: time_character = {4'h3, display_minute_ones};
            6: time_character = ":";
            7: time_character = {4'h3, display_second_tens};
            8: time_character = {4'h3, display_second_ones};
            default: time_character = 8'h20;
        endcase

        top_glyph_on = 1'b0;
        if (time_text_x < 10'd144 && time_text_y < 9'd16) begin
            time_glyph_row_index = time_text_y[3:1];
            time_glyph_column = time_text_x[3:1];
            time_glyph_bits = glyph_row(time_character, time_glyph_row_index);
            if (time_glyph_column < 3'd5 && time_glyph_row_index < 3'd7)
                top_glyph_on = time_glyph_bits[4 - time_glyph_column];
        end
    end

    reg [4:0] bottom_character_index;
    always @* begin
        bottom_character_index = scroll_text_x[8:4];
        glyph_character = 8'h20;
        scroll_glyph_row_index = 3'd0;
        scroll_glyph_column = 3'd0;
        scroll_glyph_bits = 5'd0;
        case (bottom_character_index)
            0:glyph_character="F"; 1:glyph_character="P"; 2:glyph_character="G";
            3:glyph_character="A"; 4:glyph_character=8'h20; 5:glyph_character="M";
            6:glyph_character="E"; 7:glyph_character="D"; 8:glyph_character="I";
            9:glyph_character="A"; 10:glyph_character=8'h20; 11:glyph_character="P";
            12:glyph_character="L"; 13:glyph_character="A"; 14:glyph_character="Y";
            15:glyph_character="E"; 16:glyph_character="R";
            default:glyph_character=8'h20;
        endcase

        bottom_glyph_on = 1'b0;
        if (scroll_text_visible && scroll_text_y < 9'd16) begin
            scroll_glyph_row_index = scroll_text_y[3:1];
            scroll_glyph_column = scroll_text_x[3:1];
            scroll_glyph_bits = glyph_row(glyph_character, scroll_glyph_row_index);
            if (scroll_glyph_column < 3'd5 && scroll_glyph_row_index < 3'd7)
                bottom_glyph_on = scroll_glyph_bits[4 - scroll_glyph_column];
        end
    end

    wire in_time_box = (x_pos >= 10'd448) && (x_pos < 10'd624) &&
                       (y_pos >= 9'd16) && (y_pos < 9'd48);
    wire in_scroll_box = (x_pos >= 10'd16) && (x_pos < 10'd624) &&
                         (y_pos >= 9'd432) && (y_pos < 9'd464);
    wire in_time_text = (x_pos >= 10'd456) && (x_pos < 10'd600) &&
                        (y_pos >= 9'd24) && (y_pos < 9'd40);
    wire in_scroll_text = (y_pos >= 9'd440) && (y_pos < 9'd456);

    assign rgb_out = (!de) ? rgb_in :
                     (in_time_box ? ((in_time_text && top_glyph_on) ? 24'hffffff : 24'h000000) :
                      (in_scroll_box ? ((in_scroll_text && bottom_glyph_on) ? 24'hffffff : 24'h000000) :
                       rgb_in));
endmodule
