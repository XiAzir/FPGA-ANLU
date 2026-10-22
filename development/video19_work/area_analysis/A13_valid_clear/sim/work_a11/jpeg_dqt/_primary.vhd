library verilog;
use verilog.vl_types.all;
entity jpeg_dqt is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        img_start_i     : in     vl_logic;
        img_end_i       : in     vl_logic;
        img_dqt_table_y_i: in     vl_logic_vector(1 downto 0);
        img_dqt_table_cb_i: in     vl_logic_vector(1 downto 0);
        img_dqt_table_cr_i: in     vl_logic_vector(1 downto 0);
        cfg_valid_i     : in     vl_logic;
        cfg_data_i      : in     vl_logic_vector(7 downto 0);
        cfg_last_i      : in     vl_logic;
        inport_valid_i  : in     vl_logic;
        inport_data_i   : in     vl_logic_vector(15 downto 0);
        inport_idx_i    : in     vl_logic_vector(5 downto 0);
        inport_id_i     : in     vl_logic_vector(31 downto 0);
        inport_eob_i    : in     vl_logic;
        outport_accept_i: in     vl_logic;
        cfg_accept_o    : out    vl_logic;
        inport_blk_space_o: out    vl_logic;
        outport_valid_o : out    vl_logic;
        outport_data_o  : out    vl_logic_vector(15 downto 0);
        outport_idx_o   : out    vl_logic_vector(5 downto 0);
        outport_id_o    : out    vl_logic_vector(31 downto 0);
        outport_eob_o   : out    vl_logic
    );
end jpeg_dqt;
