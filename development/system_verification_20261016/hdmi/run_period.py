"""Strict HDMI video-period/content tests. Keep prior exploratory logs intact."""
from pathlib import Path
from datetime import datetime
import sys,os,json,shutil,argparse
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'integration'))
from common import BASE,BIN,archived_sources,compile_sources,execute,sha
p=argparse.ArgumentParser();p.add_argument('--version',choices=['C11206','C11310'],default='C11206');p.add_argument('--case',choices=['positive','negative_rgb','negative_audio'],default='positive');p.add_argument('--phase-ps',type=int,choices=[0,1000,2000],default=0);p.add_argument('--sequence-audio',action='store_true');a=p.parse_args()
if not os.environ.get('MGLS_LICENSE_FILE'):raise SystemExit('Initialize license environment')
out=BASE/'hdmi'/('period_'+a.version+'_'+a.case+'_'+datetime.now().strftime('%Y%m%d_%H%M%S'));out.mkdir()
sources,flags,receipt=archived_sources(a.version,out)
names={'lane_lvds_10_1.v','hdmi_phy_warpper.v','audio_arc_calculate.v','hdmi_packet_monitor.v','video_rgb_to_axis_640x480.v','hdmi_1_4b_transmitter_core_wrapper.enc.v'}
sources=[p for p in sources if p.name in names]
if not any(p.name=='hdmi_packet_monitor.v' for p in sources):
 cp=Path(receipt['checkpoint']);monitor=cp/'src/user_source/hdl_source/hdmi_packet_monitor.v'
 manifest=json.loads((cp/'manifest.json').read_text(encoding='utf-8-sig'))
 digest=next(e['sha256'] for e in manifest if e['path'].lower()==monitor.relative_to(cp).as_posix().lower())
 if sha(monitor).lower()!=digest.lower():raise SystemExit('Frozen packet monitor SHA mismatch')
 sources.append(monitor)
sources += [Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/sim_release/eg4/eg_phy_glbl.v')]+[BASE/'hdmi'/name for name in ['hdmi_serial_receiver.v','hdmi_serial_packet_monitor.v','hdmi_video_period_receiver.v']]
for i,path in enumerate(sources):
 target=out/path.name;shutil.copy2(path,target);sources[i]=target
template=BASE/'hdmi/tb_hdmi_core_content.v'
text=template.read_text(encoding='utf-8-sig').replace('module tb_hdmi_core_content;','module tb_hdmi_period_content;')
text=text.replace('    reg audio_valid=0;', '''    reg audio_valid=0;
    reg sequence_audio_mode=0;
    integer audio_received=0,audio_mismatches=0;
    initial if($test$plusargs("sequence_audio"))sequence_audio_mode=1;
    function [23:0] pcm_l;input integer i;begin pcm_l=(i*24'h001135+24'h12ab34)&24'hffffff;end endfunction
    function [23:0] pcm_r;input integer i;begin pcm_r=(i*24'h003011)^24'h56cd78;end endfunction
''')
old_audio='''            if($test$plusargs("negative_audio") && accepted_audio==20)
                audio_left=24'd1000000 ^ 24'h000080;
            else audio_left=24'd1000000;
            audio_right=24'd1000000;'''
new_audio='''            audio_left=sequence_audio_mode?pcm_l(accepted_audio):24'd1000000;
            audio_right=sequence_audio_mode?pcm_r(accepted_audio):24'd1000000;
            if($test$plusargs("negative_audio") && accepted_audio==20)audio_left=audio_left^24'h000080;'''
if old_audio not in text:raise ValueError('Unexpected audio stimulus template')
text=text.replace(old_audio,new_audio).replace('.tone_mode(1\'b1)', '.tone_mode(!sequence_audio_mode)')
text=text.replace('initial begin #1; forever #20 pixel_clk=~pixel_clk; end',f'initial begin #{a.phase_ps/1000:.3f}; forever #20 pixel_clk=~pixel_clk; end')
text=text.replace('expected_rgb [0:307199]','expected_rgb [0:921599]').replace('sent_pixels<307200','sent_pixels<921600')
text=text.replace('wire rgb_pixel_valid;','wire rgb_pixel_valid;\n    wire [31:0] pixel_line,pixel_column,rows_completed,period_errors;')
start=text.index('    tmds_rgb_decode rgb_decode(')
end=text.index('    initial begin\n        repeat(20)',start)
observer='''    hdmi_video_period_receiver rgb_decode(.word_clk(rx_valid),.rst(rst),.ch0(rx0),.ch1(rx1),.ch2(rx2),
      .pixel_valid(rgb_pixel_valid),.rgb(decoded_rgb),.pixel_line(pixel_line),.pixel_column(pixel_column),
      .rows_completed(rows_completed),.protocol_errors(period_errors));
    always @(posedge rx_valid)begin
      #0.003;total_words=total_words+1;
      if(rgb_pixel_valid && pixel_line>=480 && pixel_line<960)begin
        found_index=307200+(pixel_line-480)*640+pixel_column;
        if(found_index>=sent_pixels)$fatal(1,"gold queue missing input index=%0d accepted=%0d",found_index,sent_pixels);
        if((pixel_line-480)*640+pixel_column!=compared_pixels)$fatal(1,"pixel order/count gap");
        expected_pixel=expected_rgb[found_index];
        if(^expected_pixel===1'bx)$fatal(1,"unknown gold pixel");
        if(decoded_rgb!==expected_pixel)begin
          mismatched_pixels=mismatched_pixels+1;
          if(mismatch_prints<8)begin
            $display("STRICT_RGB_MISMATCH index=%0d got=%06x want=%06x",found_index,decoded_rgb,expected_pixel);
            mismatch_prints=mismatch_prints+1;
          end
        end
        compared_pixels=compared_pixels+1;
      end
    end

    // Reconstruct complete subpacket zero through the existing TERC/BCH parser.
    // At this sample cadence the tested core emits one stereo pair per packet;
    // reject other packetization rather than silently ignoring extra pairs.
    always @(posedge pin_packets.monitor_clk)if(!rst && sequence_audio_mode && pin_packets.packet_monitor.audio_good)begin
      if(pin_packets.packet_monitor.sp!==4'b0001)$fatal(1,"Ordered PCM checker requires one stereo pair per packet");
      if(pin_packets.packet_monitor.body0_complete[23:0]!==pcm_l(audio_received) ||
         pin_packets.packet_monitor.body0_complete[47:24]!==pcm_r(audio_received))begin
        audio_mismatches=audio_mismatches+1;
        if(audio_mismatches<=4)$display("ORDERED_PCM_MISMATCH index=%0d L=%06h/%06h R=%06h/%06h",audio_received,
          pin_packets.packet_monitor.body0_complete[23:0],pcm_l(audio_received),
          pin_packets.packet_monitor.body0_complete[47:24],pcm_r(audio_received));
      end
      audio_received=audio_received+1;
    end

'''
text=text[:start]+observer+text[end:]
start=text.index('        if($test$plusargs("probe")) begin',text.index('        repeat(20)'))
end=text.index('        $display("RGB_SUMMARY',start)
text=text[:start]+'''        wait(rows_completed>=960);
        repeat(10)@(posedge pixel_clk);
'''+text[end:]
text=text.replace('if(sent_pixels==0 || compared_pixels==0)', 'if(sent_pixels<614400 || compared_pixels!=307200 || period_errors!=0 || dropped_pixels!=0)')
text=text.replace('        if(!rx_locked', '        $display("PERIOD_SUMMARY rows=%0d errors=%0d",rows_completed,period_errors);\n        if(!rx_locked')
text=text.replace('if(mismatched_pixels==0) $fatal(1,"negative RGB control was not detected");','if(mismatched_pixels!=1) $fatal(1,"negative RGB must produce exactly one mismatch");')
text=text.replace('PASS: actual encrypted HDMI core through EG PHY pins, independent RGB/PCM goldens','STRICT_PERIOD_CONTENT_PASS second complete frame 307200 exact pixels; constant PCM amplitude plus BCH/TERC only')
old_check='''        if($test$plusargs("negative_audio")) begin
            if(pin_packets.packet_monitor.win_tone_bad==0) $fatal(1,"negative audio sample was not detected");
        end else if(pin_packets.packet_monitor.win_tone_bad!=0) $fatal(1,"audio PCM content mismatch");'''
new_check='''        if(sequence_audio_mode)begin
          $display("ORDERED_PCM_SUMMARY sent=%0d received=%0d mismatches=%0d",accepted_audio,audio_received,audio_mismatches);
          if(audio_received<1500 || accepted_audio-audio_received>4)$fatal(1,"Ordered PCM coverage/tail incomplete");
          if($test$plusargs("negative_audio"))begin
            if(audio_mismatches!=1)$fatal(1,"One changed PCM sample must cause exactly one mismatch");
          end else if(audio_mismatches!=0)$fatal(1,"Ordered PCM mismatch");
        end else begin
'''+old_check+'''
        end'''
if old_check not in text:raise ValueError('Unexpected audio assertion template')
text=text.replace(old_check,new_check)
text=text.replace('constant PCM amplitude plus BCH/TERC only','PCM payload checks plus BCH/TERC (see test mode)')
text=text.replace('#25000000;','#55000000;')
tb=out/'tb_hdmi_period_content.v';tb.write_text(text,encoding='utf-8')
compile=compile_sources(out,sources,flags,tb)
(out/'run.do').write_text('onerror {quit -code 2 -f}\nonbreak {quit -code 3 -f}\nrun -all\nquit -code 0 -f\n')
print(out,flush=True)
case=[] if a.case=='positive' else ['+'+a.case]
if a.sequence_audio:case+=['+sequence_audio']
result=execute([BIN/'vsim.exe','-modelsimini','modelsim.ini','-c','-novopt','-lic_noqueue','-L','work','-L','eg4','-L','hdmi','work.tb_hdmi_period_content','work.glbl']+case+['-do','run.do','-l','run.log'],out,'console.log',600)
log=(out/'console.log').read_text(errors='replace')
ok=result['exit_code']==0 and 'STRICT_PERIOD_CONTENT_PASS' in log and '** Error' not in log and '** Fatal' not in log and 'FATAL' not in log
summary=dict(status='PASS_SCOPE' if ok else 'NOT_PASSED',version=a.version,case=a.case,pixel_phase_ps=a.phase_ps,sequence_audio=a.sequence_audio,simulation=result,template_sha256=sha(template),inputs=[dict(path=str(p),sha256=sha(p)) for p in sources+[tb]],scope='Second complete decoded video frame, accepted-input golden queue; '+('ordered distinct 24-bit stereo PCM patterns' if a.sequence_audio else 'constant-amplitude PCM')+' and packet BCH/TERC. No first-frame pixel guarantee, whole media path, or physical timing claim.')
(out/'summary.json').write_text(json.dumps(summary,indent=2));print(log[-5000:],flush=True)
raise SystemExit(0 if ok else 2)
