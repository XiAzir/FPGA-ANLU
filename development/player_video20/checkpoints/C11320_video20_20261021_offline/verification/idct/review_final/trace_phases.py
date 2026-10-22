from pathlib import Path
import shutil,subprocess
root=Path(__file__).resolve().parent
src=root/'positive54/frozen';out=root/'phase_trace';dst=out/'frozen';dst.mkdir(parents=True,exist_ok=True)
for p in src.iterdir():
 if p.is_file():shutil.copy2(p,dst/p.name)
tb=dst/'tb_shared.sv';s=tb.read_text(encoding='utf-8-sig')
probe='''integer phase_trace_cycle=0;
integer phase_seen=0;
always @(posedge clk) begin
 phase_trace_cycle=phase_trace_cycle+1;
 if(phase_seen<8 && dut.input_y_q && dut.input_beat_q==6'd62 && dut.y_valid) begin
  $display("PHASE_Y62_X_LAUNCH cycle=%0d yvalid=%b xlaunch=%b xreserved=%b",phase_trace_cycle,dut.y_valid,dut.x_launch,dut.x_reserved_q); phase_seen=phase_seen+1;
 end
 if(phase_seen<8 && dut.input_y_q && dut.input_beat_q==6'd63 && dut.input_valid_w) begin
  $display("PHASE_Y63_LAST cycle=%0d yvalid=%b xvalid=%b input_valid=%b",phase_trace_cycle,dut.y_valid,dut.x_valid,dut.input_valid_w); phase_seen=phase_seen+1;
 end
 if(phase_seen<8 && !dut.input_y_q && dut.x_valid && dut.input_valid_w && dut.input_beat_q==0) begin
  $display("PHASE_X0_ACCEPT cycle=%0d xvalid=%b xidx=%0d reserved=%b",phase_trace_cycle,dut.x_valid,dut.x_idx,dut.x_reserved_q); phase_seen=phase_seen+1;
 end
end
'''
needle='always @(posedge clk) begin\n if(rst||start) begin'
assert needle in s;s=s.replace(needle,probe+'\n'+needle,1);tb.write_text(s,encoding='ascii')
repo=root.parents[4];bin=repo/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
files=sorted(dst.glob('*'));cmd=[str(bin/'iverilog.exe'),'-g2012','-s','tb_shared','-o',str(out/'simv'),*[str(p) for p in files if p.suffix in ('.v','.sv')]]
comp=subprocess.run(cmd,cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);(out/'compile.log').write_bytes(comp.stdout)
if comp.returncode:raise SystemExit(comp.stdout.decode(errors='replace'))
sim=subprocess.run([str(bin/'vvp.exe'),str(out/'simv')],cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);(out/'run.log').write_bytes(sim.stdout);text=sim.stdout.decode(errors='replace')
for line in text.splitlines():
 if line.startswith('PHASE_') or line.startswith('SHARED_IDCT_PASS'):print(line)
if sim.returncode or 'SHARED_IDCT_PASS' not in text:raise SystemExit('phase trace candidate failed')
