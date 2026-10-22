library verilog;
use verilog.vl_types.all;
entity jpeg_mcu_proc is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        img_start_i     : in     vl_logic;
        img_end_i       : in     vl_logic;
        img_width_i     : in     vl_logic_vector(15 downto 0);
        img_height_i    : in     vl_logic_vector(15 downto 0);
        img_mode_i      : in     vl_logic_vector(1 downto 0);
        inport_valid_i  : in     vl_logic;
        inport_data_i   : in     vl_logic_vector(31 downto 0);
        inport_last_i   : in     vl_logic;
        lookup_valid_i  : in     vl_logic;
        lookup_width_i  : in     vl_logic_vector(4 downto 0);
        lookup_value_i  : in     vl_logic_vector(7 downto 0);
        outport_blk_space_i: in     vl_logic;
        inport_pop_o    : out    vl_logic_vector(5 downto 0);
        lookup_req_o    : out    vl_logic;
        lookup_table_o  : out    vl_logic_vector(1 downto 0);
        lookup_input_o  : out    vl_logic_vector(15 downto 0);
        outport_valid_o : out    vl_logic;
        outport_data_o  : out    vl_logic_vector(15 downto 0);
        outport_idx_o   : out    vl_logic_vector(5 downto 0);
        outport_id_o    : out    vl_logic_vector(31 downto 0);
        outport_eob_o   : out    vl_logic
    );
end jpeg_mcu_proc;
