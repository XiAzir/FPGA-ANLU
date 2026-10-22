from pathlib import Path
import hashlib,json

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
source = ROOT / 'development/player_video26_runtime_diag/src/user_source/hdl_source/SD/sd_card_cmd.v'
t = source.read_text(encoding='utf-8-sig')
old = "if((byte_cnt == 16'hffff) || (data_recv != cmd_r1 && data_recv[7] == 1'b0))"
assert t.count(old) == 1
t = t.replace(old, "if(byte_cnt < 16'd6)\n\t\t\t\t\tbegin\n\t\t\t\t\t\tbyte_cnt <= byte_cnt + 16'd1;\n\t\t\t\t\tend\n\t\t\t\t\telse " + old)
old_debug = "else if(state == S_CMD && spi_wr_ack == 1'b1) debug_last_r1 <= data_recv;"
assert t.count(old_debug) == 1
t = t.replace(old_debug, "else if(state == S_CMD && byte_cnt >= 16'd6 && spi_wr_ack == 1'b1) debug_last_r1 <= data_recv;")
out = HERE / 'sd_card_cmd.v'
out.write_text(t,encoding='utf-8')
(HERE/'source_delta.json').write_text(json.dumps({'base':str(source),'base_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'candidate_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'changes':['Complete all six command bytes before interpreting R1','Observe R1 only after the outgoing command phase']},indent=2)+'\n',encoding='utf-8')
