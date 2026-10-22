library verilog;
use verilog.vl_types.all;
entity jpeg_input is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        inport_valid_i  : in     vl_logic;
        inport_data_i   : in     vl_logic_vector(31 downto 0);
        inport_strb_i   : in     vl_logic_vector(3 downto 0);
        inport_last_i   : in     vl_logic;
        dqt_cfg_accept_i: in     vl_logic;
        dht_cfg_accept_i: in     vl_logic;
        data_accept_i   : in     vl_logic;
        inport_accept_o : out    vl_logic;
        img_start_o     : out    vl_logic;
        img_end_o       : out    vl_logic;
        img_width_o     : out    vl_logic_vector(15 downto 0);
        img_height_o    : out    vl_logic_vector(15 downto 0);
        img_mode_o      : out    vl_logic_vector(1 downto 0);
        img_dqt_table_y_o: out    vl_logic_vector(1 downto 0);
        img_dqt_table_cb_o: out    vl_logic_vector(1 downto 0);
        img_dqt_table_cr_o: out    vl_logic_vector(1 downto 0);
        dqt_cfg_valid_o : out    vl_logic;
        dqt_cfg_data_o  : out    vl_logic_vector(7 downto 0);
        dqt_cfg_last_o  : out    vl_logic;
        dht_cfg_valid_o : out    vl_logic;
        dht_cfg_data_o  : out    vl_logic_vector(7 downto 0);
        dht_cfg_last_o  : out    vl_logic;
        data_valid_o    : out    vl_logic;
        data_data_o     : out    vl_logic_vector(7 downto 0);
        data_last_o     : out    vl_logic
    );
end jpeg_input;
