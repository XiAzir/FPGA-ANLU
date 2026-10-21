// Brent cycle tracking is carried with the sequential cluster cache. The first
// repeated anchor may be reported after a short transient; every walk is also
// bounded by 4096 FAT hops, and files requiring more than 4096 clusters fail early.
module fat32_file_sector #(
    parameter [31:0] WAIT_LIMIT = 32'd50000000,
    parameter integer CATALOG_GEOMETRY = 0,
    parameter integer STATIC_FILE = 0,
    parameter integer REQUEST_STABLE = 0
)(
    input wire clk, input wire rst, input wire enable,
    input wire [31:0] fat_lba, input wire [31:0] data_lba,
    input wire [31:0] cluster_count, input wire [3:0] sectors_per_cluster_shift,
    input wire [31:0] start_cluster, input wire [31:0] file_size,
    input wire file_read, input wire [31:0] file_sector,
    output reg [7:0] file_data, output reg file_valid, output reg file_end,
    output reg error, output reg [7:0] error_code,
    output reg sd_read, output reg [31:0] sd_addr,
    input wire [7:0] sd_data, input wire sd_valid, input wire sd_end
);
    localparam S_IDLE = 0, S_CHECK = 1, S_SELECT = 2, S_FAT_WAIT = 3,
               S_DATA_WAIT = 4, S_GAP = 5, S_FAT_EVAL = 6, S_FAIL = 7;
    localparam E_RANGE = 8'h01, E_GEOM = 8'h02, E_CLUSTER = 8'h03,
               E_ADDR = 8'h04, E_SHORT = 8'h05, E_FAT = 8'h06,
               E_EOC = 8'h07, E_LOOP = 8'h08, E_LIMIT = 8'h09,
               E_TIMEOUT = 8'h0a;

    reg [3:0] state;
    reg armed;
    // Specialization modes are elaboration-time contracts. Zero keeps the
    // original request snapshots, geometry checks and file identity tags.
    reg [31:0] rq_sector_q, rq_start_q, rq_size_q;
    wire [31:0] rq_sector = REQUEST_STABLE ? file_sector : rq_sector_q;
    wire [31:0] rq_start = (STATIC_FILE || REQUEST_STABLE) ? start_cluster : rq_start_q;
    wire [31:0] rq_size = (STATIC_FILE || REQUEST_STABLE) ? file_size : rq_size_q;
    reg [27:0] current_cluster;
    reg [11:0] target_index, walk_index;
    reg [27:0] cache_cluster, cache_start;
    reg [31:0] cache_size;
    reg [11:0] cache_index;
    reg cache_valid;
    wire [12:0] walk_count = {1'b0, walk_index};
    wire [12:0] cache_walk_count = {1'b0, cache_index};

    // Brent's O(1)-storage cycle tracker. State describes current_cluster.
    // Safe bound: accepted files are limited to 4096 clusters/hops; Brent power <= 4096.
    // Keep 13 bits for length+1 so the boundary comparison can represent 4096.
    reg [27:0] brent_anchor, cache_brent_anchor;
    reg [12:0] brent_power, cache_brent_power;
    reg [12:0] brent_length, cache_brent_length;

    reg [9:0] byte_count;
    reg [8:0] wanted_offset;
    reg [7:0] fat_b0, fat_b1, fat_b2, fat_b3;
    reg [1:0] gap_count;
    reg gap_return_fat;
    reg [31:0] next_cluster;
    reg [31:0] wait_count;
    wire [43:0] data_addr_tmp = {12'd0, data_lba} +
        (({16'd0, (current_cluster[27:0] - 28'd2)} <<
          sectors_per_cluster_shift) |
         (rq_sector & ((32'd1 << sectors_per_cluster_shift) - 32'd1)));
    wire [32:0] fat_addr_tmp = {1'b0, fat_lba} +
        {12'd0, current_cluster[27:7]};

    // ceil(file_size/512), represented exactly for every 32-bit input.
    wire [23:0] sectors_needed =
        {1'b0, rq_size[31:9]} + {23'd0, (|rq_size[8:0])};

    wire catalog_geometry_bad;
    wire catalog_cluster_limit_bad;
    generate
        if (CATALOG_GEOMETRY != 0) begin : g_catalog_geometry
            assign catalog_geometry_bad = 1'b0;
            assign catalog_cluster_limit_bad = 1'b0;
        end else begin : g_generic_geometry
            assign catalog_geometry_bad = (sectors_per_cluster_shift > 7) ||
                (cluster_count == 0) || (fat_lba == 32'hffffffff) ||
                (data_lba == 32'hffffffff);
            assign catalog_cluster_limit_bad = (cluster_count > 32'h0ffffff5);
        end
    endgenerate

    task fail;
        input [7:0] code;
        begin
            error <= 1'b1;
            error_code <= code;
            file_end <= 1'b1;
            sd_read <= 1'b0;
            wait_count <= 0;
            state <= S_FAIL;
        end
    endtask

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            armed <= 0;
            rq_sector_q <= 0;
            rq_start_q <= 0;
            rq_size_q <= 0;
            current_cluster <= 0;
            target_index <= 0;
            walk_index <= 0;
            cache_cluster <= 0;
            cache_index <= 0;
            cache_start <= 0;
            cache_size <= 0;
            cache_valid <= 0;


            brent_anchor <= 0;
            brent_power <= 1;
            brent_length <= 0;
            cache_brent_anchor <= 0;
            cache_brent_power <= 1;
            cache_brent_length <= 0;
            byte_count <= 0;
            wanted_offset <= 0;

            fat_b0 <= 0;
            fat_b1 <= 0;
            fat_b2 <= 0;
            fat_b3 <= 0;
            gap_count <= 0;
            gap_return_fat <= 0;
            next_cluster <= 0;
            wait_count <= 0;
            file_data <= 0;
            file_valid <= 0;
            file_end <= 0;
            error <= 0;
            error_code <= 0;
            sd_read <= 0;
            sd_addr <= 0;
        end else begin
            file_valid <= 0;
            file_end <= 0;

            if (!enable) begin
                state <= S_IDLE;
                armed <= 0;
                sd_read <= 0;
                cache_valid <= 0;
                wait_count <= 0;
            end else if (state == S_FAIL) begin
                sd_read <= 0;
            end else if (state == S_IDLE) begin
                sd_read <= 0;
                if (!file_read)
                    armed <= 1;
                if (file_read && armed && !error) begin
                    armed <= 0;
                    if (!REQUEST_STABLE) rq_sector_q <= file_sector;
                    if (!STATIC_FILE && !REQUEST_STABLE) begin
                        rq_start_q <= start_cluster;
                        rq_size_q <= file_size;
                    end
                    state <= S_CHECK;
                end
            end else if (state == S_CHECK) begin
                if ((rq_size == 0) || ({1'b0, rq_sector} >= sectors_needed)) begin
                    fail(E_RANGE);
                end else if (catalog_geometry_bad) begin
                    fail(E_GEOM);
                end else if (sectors_needed >
                             (33'd4096 << sectors_per_cluster_shift)) begin
                    fail(E_LIMIT);
                end else if ((rq_start < 2) || (rq_start > cluster_count + 1) ||
                             catalog_cluster_limit_bad) begin
                    fail(E_CLUSTER);
                end else begin
                    target_index <= rq_sector >> sectors_per_cluster_shift;
                    if (cache_valid && (STATIC_FILE ||
                        ((cache_start == rq_start) && (cache_size == rq_size))) &&
                        ((rq_sector >> sectors_per_cluster_shift) >= cache_index)) begin
                        current_cluster <= cache_cluster;
                        walk_index <= cache_index;

                        brent_anchor <= cache_brent_anchor;
                        brent_power <= cache_brent_power;
                        brent_length <= cache_brent_length;
                    end else begin
                        current_cluster <= rq_start;
                        walk_index <= 0;

                        brent_anchor <= rq_start;
                        brent_power <= 1;
                        brent_length <= 0;
                    end
                    if (cache_valid && !STATIC_FILE &&
                        ((cache_start != rq_start) || (cache_size != rq_size)))
                        cache_valid <= 0;
                    state <= S_SELECT;
                end
            end else if (state == S_SELECT) begin
                if (walk_index == target_index) begin
                    if (|data_addr_tmp[43:32]) begin
                        fail(E_ADDR);
                    end else begin
                        sd_addr <= data_addr_tmp[31:0];
                        sd_read <= 1;
                        byte_count <= 0;
                        wait_count <= 0;
                        state <= S_DATA_WAIT;
                    end
                end else begin
                    if (fat_addr_tmp[32]) begin
                        fail(E_ADDR);
                    end else begin
                        sd_addr <= fat_addr_tmp[31:0];
                        wanted_offset <= {current_cluster[6:0], 2'b00};

                        byte_count <= 0;
                        fat_b0 <= 0;
                        fat_b1 <= 0;
                        fat_b2 <= 0;
                        fat_b3 <= 0;
                        sd_read <= 1;
                        wait_count <= 0;
                        state <= S_FAT_WAIT;
                    end
                end
            end else if (state == S_FAT_WAIT) begin
                if (sd_valid) begin
                    if (byte_count >= 11'd512) begin
                        fail(E_SHORT);
                    end else begin
                        if (byte_count == wanted_offset) begin fat_b0 <= sd_data; end
                        if (byte_count == wanted_offset + 1'b1) begin fat_b1 <= sd_data; end
                        if (byte_count == wanted_offset + 2'd2) begin fat_b2 <= sd_data; end
                        if (byte_count == wanted_offset + 2'd3) begin fat_b3 <= sd_data; end
                        byte_count <= byte_count + 1'b1;
                        wait_count <= 0;
                    end
                end
                if (sd_end) begin
                    sd_read <= 0;
                    gap_count <= 0;
                    gap_return_fat <= 1;
                    state <= S_GAP;
                    wait_count <= 0;
                    if ((byte_count != 11'd512)) begin
                        error <= 1;
                        error_code <= E_SHORT;
                        file_end <= 1;
                        state <= S_FAIL;
                    end
                end else if (!sd_valid && (wait_count >= WAIT_LIMIT - 1'b1)) begin
                    fail(E_TIMEOUT);
                end else if (!sd_valid) begin
                    wait_count <= wait_count + 1'b1;
                end
            end else if (state == S_DATA_WAIT) begin
                if (sd_valid) begin
                    if (byte_count >= 11'd512) begin
                        fail(E_SHORT);
                    end else begin
                        file_data <= sd_data;
                        file_valid <= 1;
                        byte_count <= byte_count + 1'b1;
                        wait_count <= 0;
                    end
                end
                if (sd_end) begin
                    sd_read <= 0;
                    gap_count <= 0;
                    gap_return_fat <= 0;
                    state <= S_GAP;
                    wait_count <= 0;
                    if (byte_count != 11'd512) begin
                        error <= 1;
                        error_code <= E_SHORT;
                        file_end <= 1;
                        state <= S_FAIL;
                    end else begin
                        file_end <= 1;
                        cache_valid <= 1;
                        cache_cluster <= current_cluster;
                        cache_index <= target_index;
                        if (!STATIC_FILE) begin
                            cache_start <= rq_start;
                            cache_size <= rq_size;
                        end

                        cache_brent_anchor <= brent_anchor;
                        cache_brent_power <= brent_power;
                        cache_brent_length <= brent_length;
                        state <= S_IDLE;
                    end
                end else if (!sd_valid && (wait_count >= WAIT_LIMIT - 1'b1)) begin
                    fail(E_TIMEOUT);
                end else if (!sd_valid) begin
                    wait_count <= wait_count + 1'b1;
                end
            end else if (state == S_GAP) begin
                sd_read <= 0;
                if (gap_count == 2) begin
                    if (gap_return_fat)
                        state <= S_FAT_EVAL;
                    else
                        state <= S_IDLE;
                    gap_count <= 0;
                end else begin
                    gap_count <= gap_count + 1'b1;
                end
            end else if (state == S_FAT_EVAL) begin
                next_cluster = {fat_b3, fat_b2, fat_b1, fat_b0} & 32'h0fffffff;
                if ((next_cluster == 0) || (next_cluster == 1)) begin
                    fail(E_FAT);
                end else if (next_cluster == 32'h0ffffff7) begin
                    fail(E_FAT);
                end else if ((next_cluster >= 32'h0ffffff0) && (next_cluster <= 32'h0ffffff6)) begin
                    fail(E_FAT);
                end else if (next_cluster >= 32'h0ffffff8) begin
                    fail(E_EOC);
                end else if ((next_cluster < 2) || (next_cluster > cluster_count + 1)) begin
                    fail(E_CLUSTER);
                end else if (next_cluster == brent_anchor) begin
                    fail(E_LOOP);
                end else begin
                    current_cluster <= next_cluster;
                    walk_index <= walk_index + 1'b1;

                    if (brent_length + 1'b1 == brent_power) begin
                        brent_anchor <= next_cluster;
                        brent_power <= brent_power << 1;
                        brent_length <= 0;
                    end else begin
                        brent_length <= brent_length + 1'b1;
                    end
                    state <= S_SELECT;
                end
            end
        end
    end
endmodule
