import runpy,re
from pathlib import Path
p=Path(__file__).resolve().parent
d=runpy.run_path(str(p/'extract_gate_video_cone.py'))
s=d['s'];cells=d['cells'];ids=d['included']
decls=re.findall(r'^  wire[^\n]+',s,re.M)
body=[chr(96)+'timescale 1ns/1ps','module video_ctrl_cone(input clk,input core_reset,input de_prev,input axis_user,output locked,output pause,output sof,output sol);']+decls
body+=['assign \\u_status_monitor/sys_clk = clk;',
'assign \\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_edid_wrapper/u_iic_master_wrapper/u_iic_receiver_controller/I_rst = core_reset;',
'assign \\u_adjust_osd/de_prev = de_prev;','assign axis_s_user=axis_user;']
for i in sorted(ids):body.append(cells[i]['raw']+';')
pre='\\u_hdmi_1_4b_transmitter_core_wrapper/u_hdmi_tx_controller_wrapper/u_video_axi_stream_receiver/'
body+=['assign locked=hdmi_video_locked;',f'assign pause={pre}O_video_source_pause ;',f'assign sof={pre}I_video_source_sof ;',f'assign sol={pre}I_video_source_sol ;','endmodule']
(p/'gate_video_cone.v').write_text('\n'.join(body)+'\n')
t=(p/'tb_video_core.v').read_text().replace('tb_video_core','tb_video_cone')
lines=t.splitlines()
for i,line in enumerate(lines):
 if line.strip().startswith('hdmi_1_4b_transmitter_core_wrapper #'):
  lines[i]="  wire pause,core_sof,core_sol; assign ready=1'b1; video_ctrl_cone dut(.clk(clk),.core_reset(rst),.de_prev(valid),.axis_user(user),.locked(locked),.pause(pause),.sof(core_sof),.sol(core_sol));"
(p/'tb_video_cone.v').write_text('\n'.join(lines)+'\n')
print('EMITTED',len(ids),'original cells; boundary reset/clock/valid/user only')
