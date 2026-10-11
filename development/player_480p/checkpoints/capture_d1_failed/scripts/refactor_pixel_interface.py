from pathlib import Path

root = Path(__file__).resolve().parent.parent
top = root / 'src/user_source/hdl_source/top_tf_hdmi_audio.v'
text = top.read_text(encoding='utf-8-sig')
old_params = '''parameter MEM_DATA_BITS = 32;
parameter ADDR_BITS     = 21;
parameter BUSRT_BITS    = 10;
parameter FRAME_PIXELS  = 24'd307200;   // 640*480
parameter BUF0_ADDR     = 24'd0;
parameter BUF1_ADDR     = FRAME_PIXELS;'''
assert text.count(old_params) == 1
text = text.replace(old_params, 'localparam DISPLAY_WIDTH = 640;\nlocalparam DISPLAY_HEIGHT = 480;')
text = text.replace('wire Sdr_init_done;\nwire Sdr_init_ref_vld;\nwire Sdr_busy;\n', '')
text = text.replace('wire [31:0] video_read_data;', 'wire [23:0] video_read_data;')
text = text.replace('wire [31:0] sd_card_write_data;', 'wire [23:0] sd_card_write_data;')
first = text.index('wire App_rd_en;')
last = text.index('wire hs_0;', first)
text = text[:first] + text[last:]
text = text.replace('.bmp_width         (16\'d640)', '.bmp_width         (DISPLAY_WIDTH[15:0])')
text = text.replace('.bmp_height        (16\'d480)', '.bmp_height        (DISPLAY_HEIGHT[15:0])')
text = text.replace('.read_data         (video_read_data[31:8])', '.read_data         (video_read_data)')
first = text.index('frame_read_write #(\n')
last = text.index('// Card sector address', first)
text = text[:first] + '''// RGB888 pixel API; SDRAM word layout is owned by the frame buffer.
frame_buffer_rgb888 #(
    .FRAME_WIDTH       (DISPLAY_WIDTH),
    .FRAME_HEIGHT      (DISPLAY_HEIGHT),
    .WRITE_V_FLIP      (1)
) u_frame_buffer (
    .rst               (rst_all),
    .mem_clk           (ext_mem_clk),
    .mem_clk_shift     (ext_mem_clk_sft),
    .write_clk         (sd_card_clk),
    .write_req         (sd_card_write_req),
    .write_req_ack     (sd_card_write_req_ack),
    .write_frame_index (write_buf_idx),
    .write_pixel_en    (sd_card_write_en),
    .write_pixel_rgb   (sd_card_write_data),
    .write_finish      (frame_write_finish),
    .read_clk          (video_clk),
    .read_req          (video_read_req),
    .read_req_ack      (video_read_req_ack),
    .read_frame_index  (disp_buf_idx),
    .read_pixel_en     (video_read_en),
    .read_pixel_rgb    (video_read_data)
);

''' + text[last:]
top.write_text(text, encoding='utf-8')

project = root / 'src/td_project/AC201_tf_hdmi.al'
text = project.read_text(encoding='utf-8-sig')
assert 'frame_buffer_rgb888.v' not in text
entry = '''            <File Path="../user_source/hdl_source/frame_buffer_rgb888.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="40"/>
                </FileInfo>
            </File>
'''
assert text.count('        </Verilog>') == 1
text = text.replace('        </Verilog>', entry + '        </Verilog>')
project.write_text(text, encoding='utf-8')
print('RGB888_PIXEL_INTERFACE_REFACTOR_APPLIED')
