from pathlib import Path
import shutil,subprocess
root=Path(__file__).resolve().parent
src=root/'negative53/frozen'
out=root/'negative53_trace';dst=out/'frozen';dst.mkdir(parents=True,exist_ok=True)
for p in src.iterdir():
 if p.is_file():shutil.copy2(p,dst/p.name)
tb=dst/'tb_shared.sv';s=tb.read_text(encoding='utf-8-sig')
probe='''integer trace_cycle=0;
always @(posedge clk) begin
 trace_cycle=trace_cycle+1;
 if(dut.u_transpose.inport_valid_i && dut.u_transpose.inport_idx_i[3:0]>=4'd53 && dut.u_transpose.inport_idx_i[3:0]<=4'd56)
  $display("TRACE_INPUT cycle=%0d idx=%0d wr_ptr=%0d wr3=%b block_wr=%b",trace_cycle,dut.u_transpose.inport_idx_i,dut.u_transpose.wr_ptr_w,dut.u_transpose.wr3_w,dut.u_transpose.block_wr_q);
 if(dut.u_transpose.state_q==2'd1)
  $display("TRACE_SETUP_READ cycle=%0d read_addr=%0d block_rd=%b rd_idx=%0d",trace_cycle,transpose_read_addr,dut.u_transpose.block_rd_q,dut.u_transpose.rd_idx_q);
end
'''
needle='always @(posedge clk) begin\n if(rst||start) begin'
assert needle in s
s=s.replace(needle,probe+'\n'+needle,1)
tb.write_text(s,encoding='ascii')
repo=root.parents[4];bin=repo/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
files=sorted(dst.glob('*'))
cmd=[str(bin/'iverilog.exe'),'-g2012','-s','tb_shared','-o',str(out/'simv'),*[str(p) for p in files if p.suffix in ('.v','.sv')]]
comp=subprocess.run(cmd,cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);(out/'compile.log').write_bytes(comp.stdout)
if comp.returncode:raise SystemExit(comp.stdout.decode(errors='replace'))
sim=subprocess.run([str(bin/'vvp.exe'),str(out/'simv')],cwd=out,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);(out/'run.log').write_bytes(sim.stdout)
print(sim.stdout.decode(errors='replace')[-4000:])
if 'READ_BEFORE_X_WRITE' not in sim.stdout.decode(errors='replace'):raise SystemExit('expected negative-control fatal missing')
