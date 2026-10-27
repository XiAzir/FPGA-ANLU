"""Prepare one protocol change on frozen C31, without changing the baseline."""
from pathlib import Path
import hashlib
import json
import re
import shutil

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'development/player_video31_audio_ablation'
CAND=ROOT/'development/player_video32_read_return'
assert not CAND.exists(), CAND
shutil.copytree(BASE/'src/user_source', CAND/'src/user_source')
shutil.copytree(BASE/'src/td_project/al_ip', CAND/'src/td_project/al_ip')
shutil.copy2(BASE/'src/td_project/AC201_tf_hdmi.al', CAND/'src/td_project/AC201_tf_hdmi.al')
shutil.copytree(BASE/'scripts',CAND/'scripts')
(CAND/'verification').mkdir()
for name in ('check_final_stages.ps1','normalize_project.tcl','dump_final_routed.tcl'):
    shutil.copy2(BASE/'verification'/name,CAND/'verification'/name)
for path in [CAND/'src/td_project/AC201_tf_hdmi.al',*(CAND/'scripts').iterdir(),*(CAND/'verification').iterdir()]:
    text=path.read_text(encoding='utf-8-sig').replace('player_video31_audio_ablation','player_video32_read_return')
    path.write_bytes(text.replace('\r\n','\n').replace('\n','\r\n').encode('utf-8'))
hdl=CAND/'src/user_source/hdl_source'
path=hdl/'SD/frame_fifo_read.v'
text=path.read_text(encoding='utf-8-sig')
text,n=re.subn(r'wire rd_vld;\s*reg \[3:0\] rd_delay;',
              'reg [BURST_BITS-1:0] returned_words;',text)
assert n==1
text,n=re.subn(r'assign rd_vld = \(state == S_READ_BURST && burst_cnt >= BURST_SIZE\);\s*','',text)
assert n==1
old="assign rd_burst_finish = (rd_vld && rd_delay == 4'd10);"
assert text.count(old)==1
text=text.replace(old,'''// A burst owns the read path until every requested word has returned.
// Refresh and bank changes may delay data beyond a fixed command-tail gap.
assign rd_burst_finish = (burst_cnt >= BURST_SIZE && returned_words >= BURST_SIZE);''')
text,n=re.subn(r'always\s*@\(posedge mem_clk or posedge rst\)\s*begin\s*if\(rst \|\| App_rd_en\)begin\s*rd_delay <= 4\'d0;\s*end\s*else if\(rd_delay < 4\'d10\)begin\s*rd_delay <= rd_delay \+ 1\'b1;\s*end\s*end',
'''always @(posedge mem_clk or posedge rst) begin
    if (rst) returned_words <= {BURST_BITS{1'b0}};
    else if (state == S_CHECK_FIFO) returned_words <= {BURST_BITS{1'b0}};
    else if (state == S_READ_BURST && Sdr_rd_en)
        returned_words <= returned_words + 1'b1;
end''',text)
assert n==1
text=text.replace('//burst_cnt代表发送的读指令\n//但rd_burst_finish需要在发送完十个时钟后拉高，此时数据全部读出',
                  '// burst_cnt counts issued requests; returned_words counts Sdr_rd_en responses.')
assert 'rd_delay' not in text and 'rd_vld' not in text
path.write_text(text,encoding='utf-8')
top=hdl/'top_tf_hdmi_audio.v'
text=top.read_text(encoding='utf-8-sig')
assert text.count("32'h00C11331")==1
top.write_text(text.replace("32'h00C11331","32'h00C11332"),encoding='utf-8')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
before={p.relative_to(BASE/'src/user_source').as_posix():sha(p) for p in (BASE/'src/user_source').rglob('*') if p.is_file()}
after={p.relative_to(CAND/'src/user_source').as_posix():sha(p) for p in (CAND/'src/user_source').rglob('*') if p.is_file()}
assert before.keys()==after.keys()
changed=sorted(name for name in before if before[name]!=after[name])
assert changed==['hdl_source/SD/frame_fifo_read.v','hdl_source/top_tf_hdmi_audio.v'],changed
assert sha(hdl/'player_audio_probe.v')==sha(BASE/'src/user_source/hdl_source/player_audio_probe.v')
result={'status':'PREPARED_PENDING_PROTOCOL_TEST','base':'C11331','build':'00C11332',
        'purpose':'Complete SDRAM read bursts from actual returned word count',
        'changed':changed,'source_inputs':after,'baseline_source_inputs':before,
        'board_causality':'Dynamic horizontal bands cause remains under investigation',
        'audio_source_identical_to_C31':True}
(CAND/'verification/preparation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print('C32_PREPARED_READ_RETURN_ACCOUNTING_ONLY')
