from pathlib import Path
from datetime import datetime
import hashlib, json, shutil, subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
source = ROOT / 'development/player_video19/src/user_source/hdl_source/jpeg420_word_address.v'
out = HERE / 'address_unit' / datetime.now().strftime('%Y%m%d_%H%M%S')
out.mkdir(parents=True)
shutil.copy2(source, out / source.name)
tb = (HERE / 'tb_jpeg420_word_address.sv').read_text()
tb = tb.replace('module tb_jpeg420_word_address;', 'module tb_jpeg420_word_address;\n parameter FORMAT565=0;\n localparam WORDS=FORMAT565?153600:230400;')
tb = tb.replace('jpeg420_word_address dut(', 'jpeg420_word_address #(.RGB565(FORMAT565)) dut(')
tb = tb.replace('n<230400', 'n<WORDS')
tb = tb.replace('expect_addr=base+yy*480+xx*3+lane;', '''expect_addr=base+yy*480+xx*3+lane;
                if(FORMAT565)begin
                    my=n/5120;mx=(n%5120)/128;part=(n%128)/32;u=n%32;
                    yy=my*16+(part/2)*8+u/4;
                    expect_addr=base+yy*320+mx*8+(part%2)*4+u%4;
                end''')
tb = tb.replace("if(&seen!==1'b1)", "if((FORMAT565 && (&seen[153599:0]!==1'b1)) || (!FORMAT565 && (&seen!==1'b1)))")
tb = tb.replace('unique_addresses=460800', 'unique_addresses=checked')
(out / 'tb.sv').write_text(tb)
BIN = ROOT / 'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
results = []
for mode in [0, 1]:
    exe = out / f'mode{mode}.vvp'
    compile = subprocess.run([str(BIN/'iverilog.exe'), '-g2012', '-s', 'tb_jpeg420_word_address',
        '-Ptb_jpeg420_word_address.FORMAT565=' + str(mode), '-o', str(exe), str(out/'tb.sv'), str(out/source.name)], capture_output=True)
    assert compile.returncode == 0, compile.stderr
    run = subprocess.run([str(BIN/'vvp.exe'), str(exe)], capture_output=True, timeout=60)
    log = run.stdout.decode() + run.stderr.decode()
    (out / f'mode{mode}.log').write_text(log)
    assert run.returncode == 0 and 'JPEG420_ADDRESS_PASS' in log, log
    results.append(dict(mode='RGB565' if mode else 'RGB888', log=log))
(out/'result.json').write_text(json.dumps(dict(status='PASS', source=str(source),
    sha256=hashlib.sha256(source.read_bytes()).hexdigest(), cases=results), indent=2))
print(out, 'JPEG_ADDRESS_ABLATION_PASS')
