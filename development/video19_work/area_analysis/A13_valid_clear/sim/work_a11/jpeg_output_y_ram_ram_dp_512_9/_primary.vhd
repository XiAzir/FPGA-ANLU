library verilog;
use verilog.vl_types.all;
entity jpeg_output_y_ram_ram_dp_512_9 is
    port(
        clk0_i          : in     vl_logic;
        rst0_i          : in     vl_logic;
        addr0_i         : in     vl_logic_vector(8 downto 0);
        data0_i         : in     vl_logic_vector(31 downto 0);
        wr0_i           : in     vl_logic;
        clk1_i          : in     vl_logic;
        rst1_i          : in     vl_logic;
        addr1_i         : in     vl_logic_vector(8 downto 0);
        data1_i         : in     vl_logic_vector(31 downto 0);
        wr1_i           : in     vl_logic;
        data0_o         : out    vl_logic_vector(31 downto 0);
        data1_o         : out    vl_logic_vector(31 downto 0)
    );
end jpeg_output_y_ram_ram_dp_512_9;
