from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[2];W=Path(__file__).parent;D=W/'codec_hold';D.mkdir(exist_ok=True)
P=R/'development/player_spectrum_opt16/src/user_source/hdl_source/rgb888_word_codec.v'
s=P.read_text(encoding='utf-8-sig');offset=s.index('module rgb888_unpack32 (')
t=(W/'codec/byte.v').read_text().replace('module rgb888_unpack32_byte (','module rgb888_unpack32 (')
t=t.replace('reg [63:0] reservoir;', '''reg [31:0] reservoir_low;
    reg [31:0] reservoir_high;
    wire [63:0] reservoir={reservoir_high,reservoir_low};''')
t=t.replace('    always @* begin\n        merged=reservoir;', '''    // The normal FIFO holds word_data when re=0. If count>4, the high
    // reservoir bytes are the high suffix of that last FIFO response.
    // A new pop requires post-edge count<=4, so replacing word_data can
    // never invalidate a live high suffix. Keep only the low 32 bits here.
    always @* begin
        case(byte_count)
            5: reservoir_high={24'd0,word_data[31:24]};
            6: reservoir_high={16'd0,word_data[31:16]};
            7: reservoir_high={8'd0,word_data[31:8]};
            8: reservoir_high=word_data;
            default: reservoir_high=0;
        endcase
    end
    always @* begin
        merged=reservoir;''')
t=t.replace('reservoir<=0;byte_count<=0;', 'reservoir_low<=0;byte_count<=0;').replace('reservoir<=merged;byte_count<=merged_count;', 'reservoir_low<=merged[31:0];byte_count<=merged_count;')
assert 'reservoir<=' not in t
(D/'rgb888_word_codec.v').write_text(s[:offset]+t,encoding='utf-8')
(D/'base.v').write_bytes((W/'codec/base.v').read_bytes())
(D/'hold.v').write_text(t.replace('module rgb888_unpack32 (','module rgb888_unpack32_hold ('),encoding='utf-8')
(D/'tb_codec.v').write_text((W/'codec/tb_codec.v').read_text().replace('rgb888_unpack32_byte','rgb888_unpack32_hold'),encoding='utf-8')
sources=[P,R/'development/player_spectrum_opt16/src/user_source/hdl_source/SD/frame_read_write.v',R/'development/player_spectrum_opt16/src/user_source/hdl_source/IP/afifo_32_16_256.v']
receipt={'inputs':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sources],'candidate_sha256':hashlib.sha256((D/'rgb888_word_codec.v').read_bytes()).hexdigest(),'proof':'normal non-showahead FIFO re-gates synchronous dob_tmp, held until next pop; word_pop requires post-edge count<=4. For count5/6/7/8, high reservoir is last word_data high1/2/3/4 bytes. New response can replace word_data only when post-state high reservoir is empty. Exact same word_pop, occupancy, pixel/underflow/reset/clear behavior.'}
(D/'source_receipt.json').write_text(json.dumps(receipt,indent=2));print('32-bit local reservoir prepared')
