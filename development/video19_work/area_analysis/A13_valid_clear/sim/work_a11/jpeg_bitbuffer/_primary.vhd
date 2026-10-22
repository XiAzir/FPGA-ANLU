library verilog;
use verilog.vl_types.all;
entity jpeg_bitbuffer is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        img_start_i     : in     vl_logic;
        img_end_i       : in     vl_logic;
        inport_valid_i  : in     vl_logic;
        inport_data_i   : in     vl_logic_vector(7 downto 0);
        inport_last_i   : in     vl_logic;
        outport_pop_i   : in     vl_logic_vector(5 downto 0);
        inport_accept_o : out    vl_logic;
        outport_valid_o : out    vl_logic;
        outport_data_o  : out    vl_logic_vector(31 downto 0);
        outport_last_o  : out    vl_logic
    );
end jpeg_bitbuffer;
