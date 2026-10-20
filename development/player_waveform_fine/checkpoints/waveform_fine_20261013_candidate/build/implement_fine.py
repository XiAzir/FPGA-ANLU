from pathlib import Path
import re

p = Path(__file__).resolve().parents[1]
f = p/'src/user_source/hdl_source/player_pcm_waveform.v'
s = f.read_text(encoding='utf-8-sig')
s = s.replace('parameter integer SAMPLES_PER_BIN = 8','parameter integer SAMPLES_PER_BIN = 2')
s = s.replace('localparam integer BINS = 128','localparam integer BINS = 512')
s = s.replace('// Each bank stores 128 {maximum,minimum} pairs, each 7 bits.',
              '// Each bank stores 512 {maximum,minimum} Q2 pairs, each 9 bits.')
s = s.replace('reg [13:0] trace_mem [0:255]','reg [17:0] trace_mem [0:1023]')
s = s.replace('reg [13:0] trace_read_data','reg [17:0] trace_read_data')
for n in ['bin_min','bin_max','sample_code','next_min','next_max']:
    s = s.replace('reg [6:0] '+n, 'reg [8:0] '+n)
s = s.replace('reg signed [8:0] sample_code_signed', 'reg signed [10:0] sample_code_signed')
s = s.replace('reg [13:0] completed_bin_data','reg [17:0] completed_bin_data')
s = s.replace("sample_code_signed = (pcm16 >>> 8) + 9'sd28;", "sample_code_signed = (pcm16 >>> 6) + 11'sd112;")
s = s.replace('// values. One displayed code is 256 PCM counts (4x vs +/-1024 FS).',
              '// values. One Q2 unit is 64 PCM counts; four units are one pixel.\n        // Same 4x display gain and 57 physical rows as the parent.')
s = s.replace("sample_code = 7'd0", "sample_code = 9'd0")
s = s.replace("sample_code_signed > 9'sd56", "sample_code_signed > 11'sd224")
s = s.replace("sample_code = 7'd56", "sample_code = 9'd224")
s = s.replace('sample_code_signed[6:0]', 'sample_code_signed[8:0]')
s = s.replace("bin_min       <= 7'd0", "bin_min       <= 9'd0").replace("bin_max       <= 7'd0", "bin_max       <= 9'd0")
s = s.replace("bin_min        <= 7'd0", "bin_min        <= 9'd0").replace("bin_max        <= 7'd0", "bin_max        <= 9'd0")
s = s.replace("bin_min <= 7'd0", "bin_min <= 9'd0").replace("bin_max <= 7'd0", "bin_max <= 9'd0")
s = s.replace('capture_bin[6:0]', 'capture_bin[8:0]')
s = re.sub(r'    wire \[6:0\] predicted_bin =.*?;\n', '''    wire [8:0] predicted_bin = (next_x_pos <= 11'd64) ? 9'd0 :
                               (next_x_pos >= 11'd576) ? 9'd511 :
                               (next_x_pos - 11'd64);
'''.replace('\n+','\n'), s, count=1, flags=re.S)
start=s.index('    wire [6:0] display_max =')
end=s.index('    assign rgb_out =',start)
s=s[:start]+'''    wire [8:0] display_max = trace_read_data[17:9];
    wire [8:0] display_min = trace_read_data[8:0];
    wire [9:0] midpoint_sum = {1'b0, display_max} + {1'b0, display_min};
    wire [8:0] display_mid = midpoint_sum[9:1];
    reg [8:0] previous_mid;
    reg previous_valid;

    // At the next pixel edge the synchronous read advances to column N+1,
    // while this register captures column N. Reset the neighbor at each row
    // and keep column zero independent of blanking/clamped RAM reads.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_mid <= 9'd0;
            previous_valid <= 1'b0;
        end else if (!de || !in_graph || vs != vs_prev) begin
            previous_valid <= 1'b0;
        end else begin
            previous_mid <= display_mid;
            previous_valid <= front_valid;
        end
    end
    wire use_previous = previous_valid && x_pos != 10'd64;
    // Draw each connecting segment in its right-hand column exactly once.
    wire [8:0] join_min = use_previous && previous_mid < display_mid ? previous_mid : display_mid;
    wire [8:0] join_max = use_previous && previous_mid > display_mid ? previous_mid : display_mid;
    wire [8:0] line_min = join_min < display_min ? join_min : display_min;
    wire [8:0] line_max = join_max > display_max ? join_max : display_max;
    wire [8:0] row_code = (9'd412 - y_pos) << 2;
    wire [8:0] edge_distance = row_code < line_min ? line_min - row_code :
                              row_code > line_max ? row_code - line_max : 9'd0;
    wire bar_pixel = front_valid && edge_distance < 9'd4;
    wire [23:0] trace_rgb = edge_distance == 0 ? 24'h00ffff :
                           edge_distance == 1 ? 24'h00bfbf :
                           edge_distance == 2 ? 24'h007f7f : 24'h003f3f;

'''+s[end:]
s=s.replace("bar_pixel ? 24'h00ffff", 'bar_pixel ? trace_rgb')
f.write_text(s,encoding='utf-8')
assert '128' not in s and '[6:0]' not in s
print('C11301_FINE_RTL_WRITTEN')
