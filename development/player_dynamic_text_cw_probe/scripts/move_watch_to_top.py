"""Place the source-IP instance at top level; expose passive monitor outputs."""
from pathlib import Path
import json
root=Path(__file__).resolve().parent.parent
base=root.parent/'player_dynamic_text_cadence_probe/src/user_source/hdl_source'
hdl=root/'src/user_source/hdl_source'
monitor=(base/'player_status_monitor.v').read_text(encoding='utf-8-sig')
assert monitor.count('output reg [31:0] hex_value')==1
monitor=monitor.replace('output reg [31:0] hex_value',
'''output reg [31:0] hex_value,
    output wire [31:0] cw_count_data,
    output wire cw_count_trigger''')
monitor=monitor.replace('endmodule', '''    // Passive observation; no path back into player control or media data.
    assign cw_count_data={tone_mode,audio_valid,page,self_test,ack_toggle,
                          ack_sync1,request_toggle,hex_value[17],received[17],
                          mailbox[17],audio_count[17:0]};
    assign cw_count_trigger=request_toggle;
endmodule''')
(hdl/'player_status_monitor.v').write_text(monitor,encoding='utf-8')
top=(base/'top_tf_hdmi_audio.v').read_text(encoding='utf-8-sig')
top=top.replace('wire [31:0] status_hex;', '''wire [31:0] status_hex;
wire [31:0] cw_count_data;
wire cw_count_trigger;''')
top=top.replace('.hex_value(status_hex),', '''.hex_value(status_hex),
    .cw_count_data(cw_count_data),.cw_count_trigger(cw_count_trigger),''',1)
top=top.replace('endmodule', '''// ChipWatcher source IP kept at top level for TD discovery.
player_count_chipwatcher u_count_watch (
    .clk(video_clk),.probe0(cw_count_data),.probe1(cw_count_trigger)
);
endmodule''')
(hdl/'top_tf_hdmi_audio.v').write_text(top,encoding='utf-8')
scope_path=root/'build/preflight/candidate_scope.json'
scope=json.loads(scope_path.read_text(encoding='utf-8'))
if 'user_source/hdl_source/top_tf_hdmi_audio.v' not in scope['changed_user_source_files']:
    scope['changed_user_source_files'].append('user_source/hdl_source/top_tf_hdmi_audio.v')
scope['capture']['instance']='u_count_watch'
scope_path.write_text(json.dumps(scope,indent=2,ensure_ascii=False),encoding='utf-8')
print('TOP_LEVEL_WATCH_SOURCE_PREPARED')
