library verilog;
use verilog.vl_types.all;
entity jpeg_idct_x is
    generic(
        OUT_SHIFT       : integer := 11;
        INPUT_WIDTH     : integer := 16
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        img_start_i     : in     vl_logic;
        img_end_i       : in     vl_logic;
        inport_valid_i  : in     vl_logic;
        inport_data0_i  : in     vl_logic_vector(15 downto 0);
        inport_data1_i  : in     vl_logic_vector(15 downto 0);
        inport_data2_i  : in     vl_logic_vector(15 downto 0);
        inport_data3_i  : in     vl_logic_vector(15 downto 0);
        inport_idx_i    : in     vl_logic_vector(2 downto 0);
        outport_valid_o : out    vl_logic;
        outport_data_o  : out    vl_logic_vector(31 downto 0);
        outport_idx_o   : out    vl_logic_vector(5 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of OUT_SHIFT : constant is 1;
    attribute mti_svvh_generic_type of INPUT_WIDTH : constant is 1;
end jpeg_idct_x;
