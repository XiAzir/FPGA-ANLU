// Verilog netlist created by Tang Dynasty v6.2.178840
// Tue Oct 13 20:14:23 2026

`timescale 1ns / 1ps
module top  // ../hdl/rom_probe.v(53)
  (
  addr,
  clk,
  y_case,
  y_explicit,
  y_literal,
  y_param
  );

  input [3:0] addr;  // ../hdl/rom_probe.v(53)
  input clk;  // ../hdl/rom_probe.v(53)
  output [7:0] y_case;  // ../hdl/rom_probe.v(53)
  output [7:0] y_explicit;  // ../hdl/rom_probe.v(53)
  output [7:0] y_literal;  // ../hdl/rom_probe.v(53)
  output [7:0] y_param;  // ../hdl/rom_probe.v(53)

  wire \addr[3]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \addr[2]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \addr[1]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \addr[0]_syn_2 ;  // ../hdl/rom_probe.v(53)
  wire \addr[0]_dup_3 ;  // ../hdl/rom_probe.v(53)
  wire clk_dup_1;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[7]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[6]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[5]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[4]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[3]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[2]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[1]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_explicit[0]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[7]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[6]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[5]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[4]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[3]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[2]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[1]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_literal[0]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[7]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[6]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[5]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[4]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[3]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[2]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[1]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \y_param[0]_dup_1 ;  // ../hdl/rom_probe.v(53)
  wire \d/mux0_syn_14 ;  // ../hdl/rom_probe.v(34)
  wire \d/mux0_syn_32 ;  // ../hdl/rom_probe.v(34)
  wire \d/mux0_syn_56 ;  // ../hdl/rom_probe.v(34)

  // address_offset=0;data_offset=0;depth=16;width=8;num_section=1;width_per_section=8;section_size=8;working_depth=1024;working_width=9;working_numbyte=1;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // a/ramread0_syn_4_16x8
  EG_PHY_BRAM #(
    .CEAMUX("1"),
    .CEBMUX("0"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h00000000000000000000000000000000D22DB44BE112AA55788769960FF03CA5),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .MODE("SP8K"),
    .OCEAMUX("1"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    \a/ramread0_syn_5  (
    .addra({6'b000000,\addr[3]_dup_1 ,\addr[2]_dup_1 ,\addr[1]_dup_1 ,\addr[0]_dup_3 ,3'b111}),
    .clka(clk_dup_1),
    .dia({open_n22,8'b00000000}),
    .doa({open_n38,\y_param[7]_dup_1 ,\y_param[6]_dup_1 ,\y_param[5]_dup_1 ,\y_param[4]_dup_1 ,\y_param[3]_dup_1 ,\y_param[2]_dup_1 ,\y_param[1]_dup_1 ,\y_param[0]_dup_1 }));  // ../hdl/rom_probe.v(4)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \addr[0]_syn_4  (
    .ipad(addr[0]),
    .di(\addr[0]_dup_3 ));  // ../hdl/rom_probe.v(53)
  AL_MAP_LUT1 #(
    .EQN("(~A)"),
    .INIT(2'h1))
    \addr[0]_syn_5  (
    .a(\addr[0]_dup_3 ),
    .o(\addr[0]_syn_2 ));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \addr[1]_syn_2  (
    .ipad(addr[1]),
    .di(\addr[1]_dup_1 ));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \addr[2]_syn_2  (
    .ipad(addr[2]),
    .di(\addr[2]_dup_1 ));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    \addr[3]_syn_2  (
    .ipad(addr[3]),
    .di(\addr[3]_dup_1 ));  // ../hdl/rom_probe.v(53)
  // address_offset=0;data_offset=0;depth=16;width=8;num_section=1;width_per_section=8;section_size=8;working_depth=1024;working_width=9;working_numbyte=1;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // b/ramread0_syn_4_16x8
  EG_PHY_BRAM #(
    .CEAMUX("1"),
    .CEBMUX("0"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h00000000000000000000000000000000404F4E4D4C4B4A494847464544434241),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .MODE("SP8K"),
    .OCEAMUX("1"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    \b/ramread0_syn_5  (
    .addra({6'b000000,\addr[3]_dup_1 ,\addr[2]_dup_1 ,\addr[1]_dup_1 ,\addr[0]_dup_3 ,3'b111}),
    .clka(clk_dup_1),
    .dia({open_n138,8'b00000000}),
    .doa({open_n154,\y_literal[7]_dup_1 ,\y_literal[6]_dup_1 ,\y_literal[5]_dup_1 ,\y_literal[4]_dup_1 ,\y_literal[3]_dup_1 ,\y_literal[2]_dup_1 ,\y_literal[1]_dup_1 ,\y_literal[0]_dup_1 }));  // ../hdl/rom_probe.v(9)
  // address_offset=0;data_offset=0;depth=16;width=8;num_section=1;width_per_section=8;section_size=8;working_depth=1024;working_width=9;working_numbyte=1;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  // c/ramread0_syn_4_16x8
  EG_PHY_BRAM #(
    .CEAMUX("1"),
    .CEBMUX("0"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h00000000000000000000000000000000808F8E8D8C8B8A898887868584838281),
    .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .MODE("SP8K"),
    .OCEAMUX("1"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .WEAMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    \c/ramread0_syn_5  (
    .addra({6'b000000,\addr[3]_dup_1 ,\addr[2]_dup_1 ,\addr[1]_dup_1 ,\addr[0]_dup_3 ,3'b111}),
    .clka(clk_dup_1),
    .dia({open_n186,8'b00000000}),
    .doa({open_n202,\y_explicit[7]_dup_1 ,\y_explicit[6]_dup_1 ,\y_explicit[5]_dup_1 ,\y_explicit[4]_dup_1 ,\y_explicit[3]_dup_1 ,\y_explicit[2]_dup_1 ,\y_explicit[1]_dup_1 ,\y_explicit[0]_dup_1 }));  // ../hdl/rom_probe.v(31)
  EG_PHY_PAD #(
    //.HYSTERESIS("OFF"),
    //.PCICLAMP("OFF"),
    //.PULLMODE("PULLUP"),
    .IOTYPE("LVCMOS25"),
    .MODE("IN"),
    .TSMUX("1"))
    clk_syn_2 (
    .ipad(clk),
    .di(clk_dup_1));  // ../hdl/rom_probe.v(53)
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  AL_MAP_LUT2 #(
    .EQN("(B@A)"),
    .INIT(4'h6))
    \d/mux0_syn_57  (
    .a(\addr[1]_dup_1 ),
    .b(\addr[0]_dup_3 ),
    .o(\d/mux0_syn_14 ));  // ../hdl/rom_probe.v(34)
  AL_MAP_LUT3 #(
    .EQN("(A@(C*B))"),
    .INIT(8'h6a))
    \d/mux0_syn_58  (
    .a(\addr[2]_dup_1 ),
    .b(\addr[1]_dup_1 ),
    .c(\addr[0]_dup_3 ),
    .o(\d/mux0_syn_32 ));  // ../hdl/rom_probe.v(34)
  AL_MAP_LUT4 #(
    .EQN("(A@(D*C*B))"),
    .INIT(16'h6aaa))
    \d/mux0_syn_59  (
    .a(\addr[3]_dup_1 ),
    .b(\addr[2]_dup_1 ),
    .c(\addr[1]_dup_1 ),
    .d(\addr[0]_dup_3 ),
    .o(\d/mux0_syn_56 ));  // ../hdl/rom_probe.v(34)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    \y_case[0]_syn_6  (
    .do({open_n277,open_n278,open_n279,\addr[0]_syn_2 }),
    .osclk(clk_dup_1),
    .opad(y_case[0]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    \y_case[1]_syn_6  (
    .do({open_n293,open_n294,open_n295,\d/mux0_syn_14 }),
    .osclk(clk_dup_1),
    .opad(y_case[1]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    \y_case[2]_syn_6  (
    .do({open_n309,open_n310,open_n311,\d/mux0_syn_32 }),
    .osclk(clk_dup_1),
    .opad(y_case[2]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DO_DFFMODE("FF"),
    .DO_REGSET("RESET"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .ODDRMODE("OFF"),
    .OUTCEMUX("1"),
    .OUTRSTMUX("0"),
    .OUTSCLKMUX("CLK"),
    .SRMODE("ASYNC"),
    .TSMUX("0"))
    \y_case[3]_syn_6  (
    .do({open_n325,open_n326,open_n327,\d/mux0_syn_56 }),
    .osclk(clk_dup_1),
    .opad(y_case[3]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_case[4]_syn_1  (
    .do({open_n341,open_n342,open_n343,1'b0}),
    .opad(y_case[4]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_case[5]_syn_1  (
    .do({open_n358,open_n359,open_n360,1'b0}),
    .opad(y_case[5]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_case[6]_syn_1  (
    .do({open_n375,open_n376,open_n377,1'b1}),
    .opad(y_case[6]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_case[7]_syn_1  (
    .do({open_n392,open_n393,open_n394,1'b1}),
    .opad(y_case[7]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[0]_syn_2  (
    .do({open_n409,open_n410,open_n411,\y_explicit[0]_dup_1 }),
    .opad(y_explicit[0]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[1]_syn_2  (
    .do({open_n426,open_n427,open_n428,\y_explicit[1]_dup_1 }),
    .opad(y_explicit[1]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[2]_syn_2  (
    .do({open_n443,open_n444,open_n445,\y_explicit[2]_dup_1 }),
    .opad(y_explicit[2]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[3]_syn_2  (
    .do({open_n460,open_n461,open_n462,\y_explicit[3]_dup_1 }),
    .opad(y_explicit[3]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[4]_syn_2  (
    .do({open_n477,open_n478,open_n479,\y_explicit[4]_dup_1 }),
    .opad(y_explicit[4]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[5]_syn_2  (
    .do({open_n494,open_n495,open_n496,\y_explicit[5]_dup_1 }),
    .opad(y_explicit[5]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[6]_syn_2  (
    .do({open_n511,open_n512,open_n513,\y_explicit[6]_dup_1 }),
    .opad(y_explicit[6]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_explicit[7]_syn_2  (
    .do({open_n528,open_n529,open_n530,\y_explicit[7]_dup_1 }),
    .opad(y_explicit[7]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[0]_syn_2  (
    .do({open_n545,open_n546,open_n547,\y_literal[0]_dup_1 }),
    .opad(y_literal[0]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[1]_syn_2  (
    .do({open_n562,open_n563,open_n564,\y_literal[1]_dup_1 }),
    .opad(y_literal[1]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[2]_syn_2  (
    .do({open_n579,open_n580,open_n581,\y_literal[2]_dup_1 }),
    .opad(y_literal[2]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[3]_syn_2  (
    .do({open_n596,open_n597,open_n598,\y_literal[3]_dup_1 }),
    .opad(y_literal[3]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[4]_syn_2  (
    .do({open_n613,open_n614,open_n615,\y_literal[4]_dup_1 }),
    .opad(y_literal[4]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[5]_syn_2  (
    .do({open_n630,open_n631,open_n632,\y_literal[5]_dup_1 }),
    .opad(y_literal[5]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[6]_syn_2  (
    .do({open_n647,open_n648,open_n649,\y_literal[6]_dup_1 }),
    .opad(y_literal[6]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_literal[7]_syn_2  (
    .do({open_n664,open_n665,open_n666,\y_literal[7]_dup_1 }),
    .opad(y_literal[7]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[0]_syn_2  (
    .do({open_n681,open_n682,open_n683,\y_param[0]_dup_1 }),
    .opad(y_param[0]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[1]_syn_2  (
    .do({open_n698,open_n699,open_n700,\y_param[1]_dup_1 }),
    .opad(y_param[1]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[2]_syn_2  (
    .do({open_n715,open_n716,open_n717,\y_param[2]_dup_1 }),
    .opad(y_param[2]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[3]_syn_2  (
    .do({open_n732,open_n733,open_n734,\y_param[3]_dup_1 }),
    .opad(y_param[3]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[4]_syn_2  (
    .do({open_n749,open_n750,open_n751,\y_param[4]_dup_1 }),
    .opad(y_param[4]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[5]_syn_2  (
    .do({open_n766,open_n767,open_n768,\y_param[5]_dup_1 }),
    .opad(y_param[5]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[6]_syn_2  (
    .do({open_n783,open_n784,open_n785,\y_param[6]_dup_1 }),
    .opad(y_param[6]));  // ../hdl/rom_probe.v(53)
  EG_PHY_PAD #(
    //.PCICLAMP("OFF"),
    //.PULLMODE("NONE"),
    //.SLEWRATE("SLOW"),
    .DRIVE("8"),
    .IOTYPE("LVCMOS25"),
    .MODE("OUT"),
    .TSMUX("0"))
    \y_param[7]_syn_2  (
    .do({open_n800,open_n801,open_n802,\y_param[7]_dup_1 }),
    .opad(y_param[7]));  // ../hdl/rom_probe.v(53)

endmodule 

