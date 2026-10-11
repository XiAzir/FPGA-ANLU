// Directory-driven, logical-sector BMP loader. The frame buffer owns flipping.
// Scope: bottom-up RGB888 BI_RGB, width multiple of four (no row padding).
module tf_bmp_file_player #(
    parameter integer CLK_FREQ_HZ=50000000,
    parameter integer FRAME_WIDTH=640,
    parameter integer FRAME_HEIGHT=480,
    parameter integer WAIT_LIMIT=50000000
)(
    input clk, rst, key_next, key_auto,
    input catalog_ready, input [2:0] bmp_count,
    input [127:0] bmp_clusters, bmp_sizes,
    output reg [31:0] file_cluster, file_size,
    output reg card_read, output reg [31:0] card_addr,
    input [7:0] card_data, input card_valid, card_end, file_error,
    input write_finish_toggle,
    output reg [1:0] write_buf_idx, disp_buf_idx,
    output reg write_req, input write_req_ack,
    output reg write_en, output reg [23:0] write_data,
    output reg display_valid, output reg error,
    output [3:0] state_code
);
localparam [3:0] WAIT_CATALOG=0, IDLE=1, HEADER=2, CHECK=3,
                  WRITE_WAIT=4, PAYLOAD=5, GAP=6, COMMIT=7, HALT=8;
localparam [31:0] PIXEL_BYTES=FRAME_WIDTH*FRAME_HEIGHT*3;
reg [3:0] state;
reg [2:0] gap_count;
reg [31:0] watchdog, auto_count, byte_pos, pixel_seen;
reg [9:0] sector_bytes;
reg [1:0] byte_phase, image_index, load_index, pending_buffer;
reg auto_enabled, next_pending, write_done;
reg [2:0] finish_sync;
reg [15:0] magic, planes, bit_count;
reg [31:0] declared_size, dib_size, pixel_offset, width, height, compression;
wire next_press, auto_press;
wire finish_pulse=finish_sync[2]^finish_sync[1];
wire [1:0] next_image=({1'b0,image_index}+3'd1 >= bmp_count) ? 2'd0 : image_index+2'd1;
wire auto_tick=(auto_count == CLK_FREQ_HZ-1);
wire [32:0] pixel_end={1'b0,pixel_offset}+{1'b0,PIXEL_BYTES};
wire header_ok=(magic==16'h4d42) && (dib_size>=40) &&
    ({1'b0,pixel_offset} >= 33'd14+{1'b0,dib_size}) &&
    (planes==1) && (bit_count==24) && (compression==0) &&
    (width==FRAME_WIDTH) && (height==FRAME_HEIGHT) &&
    !pixel_end[32] && pixel_end <= {1'b0,file_size} &&
    (declared_size>=pixel_end) && (declared_size<=file_size);
assign state_code=state;
key_press_debounce #(.CLK_FREQ_HZ(CLK_FREQ_HZ),.DEBOUNCE_MS(50)) u_next
    (.clk(clk),.rst(rst),.button_in(key_next),.press_pulse(next_press));
key_press_debounce #(.CLK_FREQ_HZ(CLK_FREQ_HZ),.DEBOUNCE_MS(50)) u_auto
    (.clk(clk),.rst(rst),.button_in(key_auto),.press_pulse(auto_press));

always @(posedge clk or posedge rst) begin
    if(rst) begin
        state<=WAIT_CATALOG; gap_count<=0; watchdog<=0; auto_count<=0;
        byte_pos<=0; sector_bytes<=0; pixel_seen<=0; byte_phase<=0;
        image_index<=0; load_index<=0; pending_buffer<=0;
        auto_enabled<=0; next_pending<=0; write_done<=0; finish_sync<=0;
        magic<=0; planes<=0; bit_count<=0; declared_size<=0; dib_size<=0;
        pixel_offset<=0; width<=0; height<=0; compression<=0;
        file_cluster<=0; file_size<=0; card_read<=0; card_addr<=0;
        write_buf_idx<=0; disp_buf_idx<=0; write_req<=0; write_en<=0;
        write_data<=0; display_valid<=0; error<=0;
    end else begin
        finish_sync<={finish_sync[1:0],write_finish_toggle};
        write_en<=0;
        if(next_press && catalog_ready && bmp_count!=0) next_pending<=1;
        if(auto_press && catalog_ready && bmp_count>1) begin
            auto_enabled<=~auto_enabled; auto_count<=0;
        end else if(state==IDLE && display_valid && auto_enabled) begin
            if(auto_tick) auto_count<=0; else auto_count<=auto_count+1'b1;
        end else auto_count<=0;
        if(finish_pulse && state!=IDLE && state!=WAIT_CATALOG) write_done<=1;
        if(state==HEADER || state==WRITE_WAIT || state==PAYLOAD || state==COMMIT) begin
            if(card_valid || card_end || (state==WRITE_WAIT && write_req_ack)) watchdog<=0;
            else watchdog<=watchdog+1'b1;
        end else watchdog<=0;
        case(state)
            WAIT_CATALOG: if(catalog_ready) state<=IDLE;
            IDLE: begin
                card_read<=0; write_req<=0;
                if(catalog_ready && bmp_count!=0 && (!display_valid || next_pending ||
                    (auto_enabled && auto_tick && bmp_count>1))) begin
                    load_index<=display_valid ? next_image : 2'd0;
                    file_cluster<=display_valid ? (bmp_clusters >> (next_image*32)) : bmp_clusters[31:0];
                    file_size<=display_valid ? (bmp_sizes >> (next_image*32)) : bmp_sizes[31:0];
                    pending_buffer<=display_valid ? {1'b0,~disp_buf_idx[0]} : 2'd0;
                    write_buf_idx<=display_valid ? {1'b0,~disp_buf_idx[0]} : 2'd0;
                    next_pending<=0; auto_count<=0; write_done<=0;
                    magic<=0; planes<=0; bit_count<=0; declared_size<=0;
                    dib_size<=0; pixel_offset<=0; width<=0; height<=0; compression<=0;
                    card_addr<=0; sector_bytes<=0; byte_pos<=0; pixel_seen<=0;
                    byte_phase<=0; state<=HEADER;
                end
            end
            HEADER: begin
                card_read<=1;
                if(card_valid) begin
                    case(sector_bytes)
                        0: magic[7:0]<=card_data; 1: magic[15:8]<=card_data;
                        2: declared_size[7:0]<=card_data; 3: declared_size[15:8]<=card_data;
                        4: declared_size[23:16]<=card_data; 5: declared_size[31:24]<=card_data;
                        10: pixel_offset[7:0]<=card_data; 11: pixel_offset[15:8]<=card_data;
                        12: pixel_offset[23:16]<=card_data; 13: pixel_offset[31:24]<=card_data;
                        14: dib_size[7:0]<=card_data; 15: dib_size[15:8]<=card_data;
                        16: dib_size[23:16]<=card_data; 17: dib_size[31:24]<=card_data;
                        18: width[7:0]<=card_data; 19: width[15:8]<=card_data;
                        20: width[23:16]<=card_data; 21: width[31:24]<=card_data;
                        22: height[7:0]<=card_data; 23: height[15:8]<=card_data;
                        24: height[23:16]<=card_data; 25: height[31:24]<=card_data;
                        26: planes[7:0]<=card_data; 27: planes[15:8]<=card_data;
                        28: bit_count[7:0]<=card_data; 29: bit_count[15:8]<=card_data;
                        30: compression[7:0]<=card_data; 31: compression[15:8]<=card_data;
                        32: compression[23:16]<=card_data; 33: compression[31:24]<=card_data;
                    endcase
                    // Keep 513 as an overlength sentinel instead of allowing
                    // the counter to wrap and accidentally accept long sectors.
                    if(sector_bytes<10'd513) sector_bytes<=sector_bytes+1'b1;
                end
                if(card_end) begin
                    card_read<=0;
                    if(sector_bytes!=512) begin error<=1; state<=HALT; end
                    else state<=CHECK;
                end
            end
            CHECK: begin
                if(!header_ok || FRAME_WIDTH%4!=0) begin error<=1; state<=HALT; end
                else begin write_req<=1; state<=WRITE_WAIT; end
            end
            WRITE_WAIT: if(write_req_ack) begin
                write_req<=0; card_addr<=0; byte_pos<=0; sector_bytes<=0;
                gap_count<=3; state<=GAP;
            end
            GAP: begin
                card_read<=0;
                if(gap_count!=0) gap_count<=gap_count-1'b1; else state<=PAYLOAD;
            end
            PAYLOAD: begin
                card_read<=1;
                if(card_valid) begin
                    byte_pos<=byte_pos+1'b1;
                    if(sector_bytes<10'd513) sector_bytes<=sector_bytes+1'b1;
                    if(byte_pos>=pixel_offset && pixel_seen<PIXEL_BYTES) begin
                        pixel_seen<=pixel_seen+1'b1;
                        case(byte_phase)
                            0: begin write_data[7:0]<=card_data; byte_phase<=1; end
                            1: begin write_data[15:8]<=card_data; byte_phase<=2; end
                            2: begin write_data[23:16]<=card_data; byte_phase<=0; write_en<=1; end
                        endcase
                    end
                end
                if(card_end) begin
                    card_read<=0; sector_bytes<=0;
                    if(sector_bytes!=512) begin error<=1; state<=HALT; end
                    else if(pixel_seen==PIXEL_BYTES) state<=COMMIT;
                    else begin card_addr<=card_addr+1'b1; gap_count<=3; state<=GAP; end
                end
            end
            COMMIT: if(write_done || finish_pulse) begin
                disp_buf_idx<=pending_buffer; image_index<=load_index;
                display_valid<=1; state<=IDLE;
            end
            HALT: begin card_read<=0; write_req<=0; end
            default: begin error<=1; state<=HALT; end
        endcase
        if((file_error && state!=WAIT_CATALOG) || watchdog>=WAIT_LIMIT) begin
            error<=1; state<=HALT; card_read<=0; write_req<=0; write_en<=0;
        end
    end
end
endmodule
