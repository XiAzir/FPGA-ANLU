library verilog;
use verilog.vl_types.all;
entity jpeg_dht is
    generic(
        SUPPORT_WRITABLE_DHT: integer := 0
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        cfg_valid_i     : in     vl_logic;
        cfg_data_i      : in     vl_logic_vector(7 downto 0);
        cfg_last_i      : in     vl_logic;
        lookup_req_i    : in     vl_logic;
        lookup_table_i  : in     vl_logic_vector(1 downto 0);
        lookup_input_i  : in     vl_logic_vector(15 downto 0);
        cfg_accept_o    : out    vl_logic;
        lookup_valid_o  : out    vl_logic;
        lookup_width_o  : out    vl_logic_vector(4 downto 0);
        lookup_value_o  : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SUPPORT_WRITABLE_DHT : constant is 1;
end jpeg_dht;
