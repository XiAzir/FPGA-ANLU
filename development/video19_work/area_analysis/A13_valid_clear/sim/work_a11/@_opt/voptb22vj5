library verilog;
use verilog.vl_types.all;
entity jpeg_idct_fifo is
    generic(
        WIDTH           : integer := 8;
        DEPTH           : integer := 4;
        ADDR_W          : integer := 2
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        data_in_i       : in     vl_logic_vector;
        push_i          : in     vl_logic;
        pop_i           : in     vl_logic;
        flush_i         : in     vl_logic;
        data_out_o      : out    vl_logic_vector;
        accept_o        : out    vl_logic;
        valid_o         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_W : constant is 1;
end jpeg_idct_fifo;
