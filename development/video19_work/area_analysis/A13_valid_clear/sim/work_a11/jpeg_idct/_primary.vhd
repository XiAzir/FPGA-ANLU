library verilog;
use verilog.vl_types.all;
entity jpeg_idct is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        img_start_i     : in     vl_logic;
        img_end_i       : in     vl_logic;
        inport_valid_i  : in     vl_logic;
        inport_data_i   : in     vl_logic_vector(15 downto 0);
        inport_idx_i    : in     vl_logic_vector(5 downto 0);
        inport_eob_i    : in     vl_logic;
        inport_id_i     : in     vl_logic_vector(31 downto 0);
        outport_accept_i: in     vl_logic;
        inport_accept_o : out    vl_logic;
        outport_valid_o : out    vl_logic;
        outport_data_o  : out    vl_logic_vector(31 downto 0);
        outport_idx_o   : out    vl_logic_vector(5 downto 0);
        outport_id_o    : out    vl_logic_vector(31 downto 0)
    );
end jpeg_idct;
