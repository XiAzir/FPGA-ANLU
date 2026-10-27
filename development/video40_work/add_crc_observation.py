"""Restore only C29's passive SD read CRC counters for the TF25 board test."""
from pathlib import Path
import hashlib
import json
import shutil

ROOT=Path(__file__).resolve().parents[2]
CAND=ROOT/'development/player_video40_spi25'
H=CAND/'src/user_source/hdl_source'
OLD=ROOT/'development/player_video29_media_flow/src/user_source/hdl_source/SD/sd_card_cmd.v'
reference=OLD.read_text(encoding='utf-8-sig')
function=reference.split('function [15:0] crc16_ccitt_byte;',1)[1].split('endfunction',1)[0]
monitor='// Passive CRC-16/CCITT'+reference.split('// Passive CRC-16/CCITT',1)[1].rsplit('endmodule',1)[0]
cmd_path=H/'SD/sd_card_cmd.v'
cmd=cmd_path.read_text(encoding='utf-8-sig')
assert 'read_crc_checked' not in cmd
cmd=cmd.replace('\toutput wire [4:0]           debug_state,', '\toutput reg [15:0]           read_crc_checked,\n\toutput reg [15:0]           read_crc_bad,\n\toutput wire [4:0]           debug_state,')
assert cmd.count('reg[9:0]                      wr_data_cnt;')==1
cmd=cmd.replace('reg[9:0]                      wr_data_cnt;', 'reg[9:0]                      wr_data_cnt;\nreg [15:0] read_crc16;\nreg [7:0] read_crc_hi;\nfunction [15:0] crc16_ccitt_byte;'+function+'endfunction\n')
cmd=cmd.rsplit('endmodule',1)[0]+monitor+'\nendmodule\n'
cmd_path.write_text(cmd,encoding='utf-8')

card_path=H/'SD/sd_card_top.v'
card=card_path.read_text(encoding='utf-8-sig')
card=card.replace('\toutput wire [15:0] debug_state,', '\toutput wire [15:0] read_crc_checked,\n\toutput wire [15:0] read_crc_bad,\n\toutput wire [15:0] debug_state,')
card=card.replace('\t.debug_last_r1                 (cmd_debug_last_r1      )', '\t.debug_last_r1                 (cmd_debug_last_r1      ),\n\t.read_crc_checked               (read_crc_checked       ),\n\t.read_crc_bad                   (read_crc_bad           )')
assert card.count('.read_crc_checked')==1 and card.count('output wire [15:0] read_crc_checked')==1
card_path.write_text(card,encoding='utf-8')

top_path=H/'top_tf_hdmi_audio.v'
top=top_path.read_text(encoding='utf-8-sig')
top=top.replace('sd_card_top #(.SPI_HIGH_SPEED_DIV(0), .SPI_FAST_DIV0(1))', 'wire [15:0] tf_crc_checked, tf_crc_bad;\nsd_card_top #(.SPI_HIGH_SPEED_DIV(0), .SPI_FAST_DIV0(1))')
top=top.replace('    .debug_state(), .debug_command(),', '    .debug_state(), .debug_command(),\n    .read_crc_checked(tf_crc_checked), .read_crc_bad(tf_crc_bad),')
prefix=top.split('// Fixed build identifier; no runtime diagnostic page counters.')[0]
top=prefix+'''// TF25 test pages share the 50MHz SD domain with the CRC counters.
reg [25:0] tf_page_count;
reg [1:0] tf_page;
always @(posedge sd_card_clk or posedge rst_all) begin
    if (rst_all) begin tf_page_count <= 0; tf_page <= 0; end
    else if (tf_page_count == 26'd49999999) begin
        tf_page_count <= 0;
        tf_page <= tf_page == 2 ? 0 : tf_page + 1'b1;
    end else tf_page_count <= tf_page_count + 1'b1;
end
wire [31:0] tf_page_word = tf_page == 0 ? 32'h00C11340 :
                            tf_page == 1 ? {16'hC000,tf_crc_checked} :
                                           {16'hE000,tf_crc_bad};
status_hex595 #(.CLK_HZ(50000000)) u_status_hex (
    .clk(sd_card_clk),.rst(rst_all),.hex_value(tf_page_word),
    .seg7_dio(seg7_dio),.seg7_sclk(seg7_sclk),.seg7_rclk(seg7_rclk)
);
endmodule
'''
top_path.write_text(top,encoding='utf-8')
shutil.copytree(ROOT/'development/player_video32_read_return/src/td_project/al_ip',CAND/'src/td_project/al_ip')

baseline=CAND/'verification/preparation.json'
prep=json.loads(baseline.read_text(encoding='utf-8'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
current={p.relative_to(CAND/'src/user_source').as_posix():sha(p) for p in sorted((CAND/'src/user_source').rglob('*')) if p.is_file()}
prep.update({'state':'SPI25_AND_PASSIVE_CRC_INTEGRATED_TEST_PENDING','user_source_sha256':current,'changed':[k for k in current if current[k]!=prep['baseline_user_sources'][k]],'crc_reference':str(OLD),'crc_reference_sha256':sha(OLD),'pages':{'00C11340':'build','C000xxxx':'CRC checked blocks (16-bit saturating)','E000xxxx':'CRC bad blocks (16-bit saturating)'}})
baseline.write_text(json.dumps(prep,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'state':prep['state'],'changed':prep['changed'],'CRC_control_flow':'passive only'},ensure_ascii=False,indent=2))
