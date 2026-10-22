library verilog;
use verilog.vl_types.all;
entity jpeg_idct_transpose is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        img_start_i     : in     vl_logic;
        img_end_i       : in     vl_logic;
        inport_valid_i  : in     vl_logic;
        inport_data_i   : in     vl_logic_vector(31 downto 0);
        inport_idx_i    : in     vl_logic_vector(5 downto 0);
        outport_ready_i : in     vl_logic;
        inport_accept_o : out    vl_logic;
        outport_valid_o : out    vl_logic;
        outport_data0_o : out    vl_logic_vector(31 downto 0);
        outport_data1_o : out    vl_logic_vector(31 downto 0);
        outport_data2_o : out    vl_logic_vector(31 downto 0);
        outport_data3_o : out    vl_logic_vector(31 downto 0);
        outport_idx_o   : out    vl_logic_vector(2 downto 0)
    );
end jpeg_idct_transpose;
