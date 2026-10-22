library verilog;
use verilog.vl_types.all;
entity jpeg_output is
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
        inport_idx_i    : in     vl_logic_vector(5 downto 0);
        inport_id_i     : in     vl_logic_vector(31 downto 0);
        outport_accept_i: in     vl_logic;
        inport_accept_o : out    vl_logic;
        outport_valid_o : out    vl_logic;
        outport_width_o : out    vl_logic_vector(15 downto 0);
        outport_height_o: out    vl_logic_vector(15 downto 0);
        outport_pixel_x_o: out    vl_logic_vector(15 downto 0);
        outport_pixel_y_o: out    vl_logic_vector(15 downto 0);
        outport_pixel_r_o: out    vl_logic_vector(7 downto 0);
        outport_pixel_g_o: out    vl_logic_vector(7 downto 0);
        outport_pixel_b_o: out    vl_logic_vector(7 downto 0);
        idle_o          : out    vl_logic
    );
end jpeg_output;
