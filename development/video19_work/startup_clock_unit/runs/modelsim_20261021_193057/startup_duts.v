module startup_old(
    input clk, input sd_card_clk, input rst_n,
    input sys_pll_lock, input video_pll_lock,
    output [19:0] rst_cnt_o, output rst_all_reg_o
);
reg [19:0] rst_cnt = 20'd0;
reg rst_all_reg = 1'b1;
assign rst_cnt_o = rst_cnt;
assign rst_all_reg_o = rst_all_reg;
always @(posedge clk) begin
    if (!rst_n) begin
        rst_cnt <= 20'd0;
        rst_all_reg <= 1'b1;
    end else if (!rst_all_reg) begin
        // ?????????????? PLL ???????????????
        rst_all_reg <= 1'b0;
    end else if (sys_pll_lock && video_pll_lock) begin
        // ?? PLL ???? 20ms @ 50MHz
        if (rst_cnt < 20'd1_000_000) begin
            rst_cnt <= rst_cnt + 1'b1;
            rst_all_reg <= 1'b1;
        end else begin
            rst_all_reg <= 1'b0;
        end
    end else begin
        rst_cnt <= 20'd0;
        rst_all_reg <= 1'b1;
    end
end
endmodulemodule startup_new(
    input clk, input sd_card_clk, input rst_n,
    input sys_pll_lock, input video_pll_lock,
    output [19:0] rst_cnt_o, output rst_all_reg_o
);
reg [19:0] rst_cnt = 20'd0;
reg rst_all_reg = 1'b1;
assign rst_cnt_o = rst_cnt;
assign rst_all_reg_o = rst_all_reg;
always @(posedge sd_card_clk) begin
    if (!rst_n) begin
        rst_cnt <= 20'd0;
        rst_all_reg <= 1'b1;
    end else if (!rst_all_reg) begin
        // ?????????????? PLL ???????????????
        rst_all_reg <= 1'b0;
    end else if (sys_pll_lock && video_pll_lock) begin
        // ?? PLL ???? 20ms @ 50MHz
        if (rst_cnt < 20'd1_000_000) begin
            rst_cnt <= rst_cnt + 1'b1;
            rst_all_reg <= 1'b1;
        end else begin
            rst_all_reg <= 1'b0;
        end
    end else begin
        rst_cnt <= 20'd0;
        rst_all_reg <= 1'b1;
    end
end
endmodule
