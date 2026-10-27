"""Run actual FIFO, codec, read/write backend with an explicit app-level model."""
from pathlib import Path
import hashlib
import json
import subprocess

ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent/'frame_integration'
WORK.mkdir(exist_ok=True)
HDL=ROOT/'development/player_video32_read_return/src/user_source/hdl_source'
legacy=ROOT/'development/player_480p/sim/tb_compact_frame_buffer.v'
text=legacy.read_text(encoding='utf-8-sig')
text=text.replace('parameter DATA_LAG = -1;', 'parameter DATA_LAG = -1;\n    parameter RESPONSE_LATENCY = 10;')
text=text.replace('always #7 write_clk','always #10 write_clk')
text=text.replace('.write_req_ack(write_req_ack), .write_frame_index(write_frame_index),',
''' .write_req_ack(write_req_ack), .write_frame_index(write_frame_index),
        .write_jpeg420(1'b0), .write_pixel_ready(),''')
text=text.replace('.read_req_ack(read_req_ack), .read_frame_index(read_frame_index),',
''' .read_req_ack(read_req_ack), .read_frame_index(read_frame_index),
        .read_jpeg420(1'b0), .read_wipe_active(1'b0), .read_wipe_rows(9'd0), .read_wipe_new_index(2'd0),''')
text=text.replace('dut.u_unpack.bit_count', 'dut.u_unpack.byte_count')
text=text.replace('module sdram (', 'module sdram #(parameter CAPACITY=1536, parameter LATENCY=10) (')
text=text.replace('localparam CAPACITY = 2 * 640 * 480 * 3 / 4;', '')
text=text.replace('    always @(posedge mem_clk) if (write_finish)',
'''    defparam dut.u_sdram.CAPACITY = 2 * WORDS;
    defparam dut.u_sdram.LATENCY = RESPONSE_LATENCY;
    always @(posedge mem_clk) if (write_finish)''')
text=text.replace('reg [10:0] rd_pending=0;', 'reg [LATENCY:0] rd_pending=0;')
text=text.replace('rd_addr[0:10]', 'rd_addr[0:LATENCY]')
text=text.replace('rd_pending[9:0]', 'rd_pending[LATENCY-1:0]')
text=text.replace('pipeline_index<11', 'pipeline_index<LATENCY+1')
text=text.replace('rd_pending[9]', 'rd_pending[LATENCY-1]')
text=text.replace('9 + tb_compact_frame_buffer.DATA_LAG', 'LATENCY-1 + tb_compact_frame_buffer.DATA_LAG')
tb=WORK/'tb_compact_frame_buffer.v'
tb.write_text(text,encoding='utf-8')
tools=ROOT/'bringup/tf_wav_hdmi/tools/iverilog/app/bin'
sources=[tb]+[HDL/p for p in ('frame_buffer_rgb888.v','rgb888_word_codec.v','rgb565_word_codec.v',
    'player_wipe_address.v','jpeg420_word_address.v','SD/frame_read_write.v','SD/frame_fifo_read.v',
    'SD/frame_fifo_write.v','IP/afifo_32_16_256.v','IP/afifo_16_32_256.v')]
cases=[]
for latency in (2,10,32,64):
    tag=f'latency_{latency}'
    output=WORK/f'{tag}.vvp'
    compile_cmd=[str(tools/'iverilog.exe'),'-g2012','-s','tb_compact_frame_buffer',
                 f'-Ptb_compact_frame_buffer.RESPONSE_LATENCY={latency}','-o',str(output),*map(str,sources)]
    cp=subprocess.run(compile_cmd,capture_output=True,text=True)
    (WORK/f'{tag}_compile.log').write_text(cp.stdout+cp.stderr,encoding='utf-8')
    assert cp.returncode==0,cp.stderr
    run=subprocess.run([str(tools/'vvp.exe'),str(output)],capture_output=True,text=True,timeout=60)
    (WORK/f'{tag}_run.log').write_text(run.stdout+run.stderr,encoding='utf-8')
    assert run.returncode==0 and 'PASS tb_compact_frame_buffer' in run.stdout,run.stdout+run.stderr
    cases.append({'response_latency_mem_clocks':latency,'status':'PASS','log':f'{tag}_run.log'})
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
result={'status':'PASS','cases':cases,
        'coverage':'Two exact RGB888 frames, actual generated FIFO RTL, concurrent background write/display read, uninterrupted pixels and gapped pixels, exact stored/captured word and output pixel checks',
        'scope':'Application SDRAM model with configurable latency and data-leading-valid 1; no real encrypted controller/device or SDF',
        'inputs':[{'path':p.relative_to(ROOT).as_posix(),'sha256':sha(p)} for p in sources],
        'generator_sha256':sha(Path(__file__))}
(WORK/'summary.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print('FRAME_INTEGRATION_PASS latencies=2,10,32,64 cases=4 exact_pixels=12288')
