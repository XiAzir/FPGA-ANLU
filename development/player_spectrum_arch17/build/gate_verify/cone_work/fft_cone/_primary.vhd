library verilog;
use verilog.vl_types.all;
entity fft_cone is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        audio_valid     : in     vl_logic;
        tone_mode       : in     vl_logic;
        audio_pcm       : in     vl_logic_vector(23 downto 0);
        band_valid      : out    vl_logic;
        frame_done      : out    vl_logic;
        band_index      : out    vl_logic_vector(4 downto 0);
        band_value      : out    vl_logic_vector(15 downto 0)
    );
end fft_cone;
