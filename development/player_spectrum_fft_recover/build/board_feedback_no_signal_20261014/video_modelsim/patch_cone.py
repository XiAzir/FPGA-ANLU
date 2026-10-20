from pathlib import Path
p=Path(r'E:\VSCODE-project\FPGA-ANLU\development\player_spectrum_fft_recover\build\board_feedback_no_signal_20261014\video_modelsim\cone_stats2.py')
ls=p.read_text(encoding='utf-8-sig').splitlines()
for i,line in enumerate(ls):
 if line.lstrip().startswith('if re.fullmatch') and "[bB][01]" in line:
  ls[i+1:i+2]=[
   " x=x.replace('\\\\','').strip()",
   " m=re.fullmatch(r'(.+?)\\s*\\[(\\d+):(\\d+)\]',x)",
   " if m:",
   "  name,hi,lo=m.group(1).strip(),int(m.group(2)),int(m.group(3))",
   "  step=-1 if hi>=lo else 1",
   "  return [name+f' [{j}]' for j in range(hi,lo+step,step)]",
   " return [re.sub(r'\\s+\\[', ' [', x)]",
  ]
  break
else: raise SystemExit('bit parser marker missing')
p.write_text('\n'.join(ls)+'\n',encoding='utf-8')
exec(compile(p.read_text(),str(p),'exec'))