from pathlib import Path
p=Path('development/video23_work/run_video_system.py')
t=p.read_text(encoding='utf-8-sig')
t=t.replace("parser.add_argument('--compile-only'", "parser.add_argument('--mode-switch',action='store_true')\nparser.add_argument('--compile-only'")
t=t.replace("shutil.copy2(HERE / 'tb_video_system.v', tb)","shutil.copy2(HERE / ('tb_mode_system.v' if args.mode_switch else 'tb_video_system.v'), tb)")
p.write_text(t,encoding='utf-8')
