library verilog;
use verilog.vl_types.all;
entity jpeg_core is
    generic(
        SUPPORT_WRITABLE_DHT: integer := 0
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        inport_valid_i  : in     vl_logic;
        inport_data_i   : in     vl_logic_vector(31 downto 0);
        inport_strb_i   : in     vl_logic_vector(3 downto 0);
        inport_last_i   : in     vl_logic;
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SUPPORT_WRITABLE_DHT : constant is 1;
end jpeg_core;
