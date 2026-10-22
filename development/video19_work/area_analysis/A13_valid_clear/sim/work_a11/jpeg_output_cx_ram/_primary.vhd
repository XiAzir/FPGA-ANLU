library verilog;
use verilog.vl_types.all;
entity jpeg_output_cx_ram is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        wr_idx_i        : in     vl_logic_vector(5 downto 0);
        data_in_i       : in     vl_logic_vector(31 downto 0);
        push_i          : in     vl_logic;
        mode420_i       : in     vl_logic;
        pop_i           : in     vl_logic;
        flush_i         : in     vl_logic;
        data_out_o      : out    vl_logic_vector(31 downto 0);
        valid_o         : out    vl_logic;
        level_o         : out    vl_logic_vector(31 downto 0)
    );
end jpeg_output_cx_ram;
