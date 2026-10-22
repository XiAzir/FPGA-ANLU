library verilog;
use verilog.vl_types.all;
entity jpeg_mcu_id is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        img_start_i     : in     vl_logic;
        img_end_i       : in     vl_logic;
        img_width_i     : in     vl_logic_vector(15 downto 0);
        img_height_i    : in     vl_logic_vector(15 downto 0);
        img_mode_i      : in     vl_logic_vector(1 downto 0);
        start_of_block_i: in     vl_logic;
        end_of_block_i  : in     vl_logic;
        block_id_o      : out    vl_logic_vector(31 downto 0);
        block_type_o    : out    vl_logic_vector(1 downto 0);
        end_of_image_o  : out    vl_logic
    );
end jpeg_mcu_id;
