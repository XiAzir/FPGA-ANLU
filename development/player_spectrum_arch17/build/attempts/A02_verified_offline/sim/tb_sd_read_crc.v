`timescale 1ns/1ps

module tb_sd_read_crc;
	reg sys_clk = 1'b0;
	always #5 sys_clk = ~sys_clk;

	reg rst = 1'b1;
	reg [15:0] spi_clk_div = 16'd0;
	reg cmd_req = 1'b0;
	wire cmd_req_ack;
	wire cmd_req_error;
	reg [47:0] cmd = 48'd0;
	reg [7:0] cmd_r1 = 8'h01;
	reg [15:0] cmd_data_len = 16'd0;
	reg block_read_req = 1'b0;
	wire block_read_valid;
	wire [7:0] block_read_data;
	wire block_read_req_ack;
	reg block_write_req = 1'b0;
	reg [7:0] block_write_data = 8'd0;
	wire block_write_data_rd;
	wire block_write_req_ack;
	wire nCS_ctrl;
	wire [15:0] clk_div;
	wire spi_wr_req;
	reg spi_wr_ack = 1'b0;
	wire [7:0] spi_data_in;
	reg [7:0] spi_data_out = 8'hff;
	wire [15:0] read_crc_checked;
	wire [15:0] read_crc_bad;

	sd_card_cmd dut(
		.sys_clk(sys_clk), .rst(rst), .spi_clk_div(spi_clk_div),
		.cmd_req(cmd_req), .cmd_req_ack(cmd_req_ack), .cmd_req_error(cmd_req_error),
		.cmd(cmd), .cmd_r1(cmd_r1), .cmd_data_len(cmd_data_len),
		.block_read_req(block_read_req), .block_read_valid(block_read_valid),
		.block_read_data(block_read_data), .block_read_req_ack(block_read_req_ack),
		.block_write_req(block_write_req), .block_write_data(block_write_data),
		.block_write_data_rd(block_write_data_rd), .block_write_req_ack(block_write_req_ack),
		.nCS_ctrl(nCS_ctrl), .clk_div(clk_div), .spi_wr_req(spi_wr_req),
		.spi_wr_ack(spi_wr_ack), .spi_data_in(spi_data_in), .spi_data_out(spi_data_out),
		.read_crc_checked(read_crc_checked), .read_crc_bad(read_crc_bad)
	);

	function [15:0] crc16_ccitt_byte;
		input [15:0] crc_in;
		input [7:0] data_in;
		reg [15:0] work;
		integer k;
		begin
			work = crc_in ^ {data_in, 8'h00};
			for(k = 0; k < 8; k = k + 1)
				if(work[15]) work = (work << 1) ^ 16'h1021;
				else work = work << 1;
			crc16_ccitt_byte = work;
		end
	endfunction

	task spi_byte;
		input [7:0] rx_byte;
		begin
			wait(spi_wr_req === 1'b1);
			@(negedge sys_clk);
			spi_data_out = rx_byte;
			spi_wr_ack = 1'b1;
			@(negedge sys_clk);
			spi_wr_ack = 1'b0;
			spi_data_out = 8'hff;
		end
	endtask

	task power_on_init;
		integer n;
		begin
			for(n = 0; n < 11; n = n + 1)
				spi_byte(8'hff);
		end
	endtask

	task read_sector;
		input integer corruption;
		integer n;
		reg [7:0] payload;
		reg [15:0] calculated_crc;
		reg [15:0] wire_crc;
		begin
			@(negedge sys_clk);
			block_read_req = 1'b1;
			@(negedge sys_clk);
			block_read_req = 1'b0;
			spi_byte(8'hfe);
			calculated_crc = 16'h0000;
			for(n = 0; n < 512; n = n + 1)
			begin
				payload = (n * 7 + 8'h35) & 8'hff;
				calculated_crc = crc16_ccitt_byte(calculated_crc, payload);
				if(corruption == 1 && n == 173)
					payload = payload ^ 8'h01;
				spi_byte(payload);
			end
			wire_crc = calculated_crc;
			if(corruption == 2)
				wire_crc = calculated_crc ^ 16'h0001;
			spi_byte(wire_crc[15:8]);
			spi_byte(wire_crc[7:0]);
		end
	endtask

	task check_counts;
		input [15:0] expected_checked;
		input [15:0] expected_bad;
		begin
			if(read_crc_checked !== expected_checked || read_crc_bad !== expected_bad)
			begin
				$display("FAIL counts checked=%0d expected=%0d bad=%0d expected=%0d",
					read_crc_checked, expected_checked, read_crc_bad, expected_bad);
				$fatal(1);
			end
		end
	endtask

	integer i;
	reg [15:0] known_crc;
	initial begin
		known_crc = 16'h0000;
		known_crc = crc16_ccitt_byte(known_crc, "1");
		known_crc = crc16_ccitt_byte(known_crc, "2");
		known_crc = crc16_ccitt_byte(known_crc, "3");
		known_crc = crc16_ccitt_byte(known_crc, "4");
		known_crc = crc16_ccitt_byte(known_crc, "5");
		known_crc = crc16_ccitt_byte(known_crc, "6");
		known_crc = crc16_ccitt_byte(known_crc, "7");
		known_crc = crc16_ccitt_byte(known_crc, "8");
		known_crc = crc16_ccitt_byte(known_crc, "9");
		if(known_crc !== 16'h31c3) begin $display("FAIL reference CRC=%04x", known_crc); $fatal(1); end

		repeat(3) @(negedge sys_clk);
		rst = 1'b0;
		power_on_init();
		check_counts(16'd0, 16'd0);

		// Exercise the normal command path; command responses must not be counted.
		@(negedge sys_clk);
		cmd = 48'h400000000095;
		cmd_req = 1'b1;
		@(negedge sys_clk);
		cmd_req = 1'b0;
		spi_byte(8'hff); // S_CMD_PRE
		spi_byte(8'h01); // R1 response in S_CMD
		check_counts(16'd0, 16'd0);

		read_sector(0);
		check_counts(16'd1, 16'd0);
		read_sector(1);
		check_counts(16'd2, 16'd1);
		read_sector(2);
		check_counts(16'd3, 16'd2);
		read_sector(0);
		check_counts(16'd4, 16'd2);
		read_sector(0);
		check_counts(16'd5, 16'd2);

		// Asynchronous reset clears both lifetime counters and the partial CRC state.
		@(negedge sys_clk);
		rst = 1'b1;
		@(negedge sys_clk);
		check_counts(16'd0, 16'd0);
		rst = 1'b0;
		power_on_init();
		check_counts(16'd0, 16'd0);
		$display("PASS tb_sd_read_crc blocks=5 injected_corruptions=2 reference_crc=31C3 reset_checked=%0d reset_bad=%0d", read_crc_checked, read_crc_bad);
		$finish;
	end

	initial begin
		#2000000;
		$display("FAIL timeout");
		$fatal(1);
	end
endmodule
