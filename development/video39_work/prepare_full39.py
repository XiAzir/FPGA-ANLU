from pathlib import Path
import hashlib
import json
import re
import shutil
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT/'development/player_video38_open_tx'
TARGET = ROOT/'development/player_video39_native1080p30'
OLD = 'AC201_video38_open_tx'
PROJECT = 'AC201_video39_native1080p30'
for path in (BASE/'src/user_source').rglob('*'):
    if path.is_file():
        destination = TARGET/path.relative_to(BASE)
        destination.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(path,destination)

hdl = TARGET/'src/user_source/hdl_source'
direct_serializer = ROOT/'development/video39_work/native_probe/serializer_direct/src/user_source/serializer.v'
assert direct_serializer.is_file()
shutil.copy2(direct_serializer,hdl/'lane_lvds_10_1.v')
top = (hdl/'top.v').read_text(encoding='utf-8')
top = top.replace('.H_ACTIVE(1920), .H_FRONT(8), .H_SYNC(8), .H_BACK(64)',
                  '.H_ACTIVE(1920), .H_FRONT(88), .H_SYNC(44), .H_BACK(148)')
top = top.replace('.V_ACTIVE(1080), .V_FRONT(4), .V_SYNC(5), .V_BACK(11)',
                  '.V_ACTIVE(1080), .V_FRONT(4), .V_SYNC(5), .V_BACK(36)')
top = top.replace(".HSYNC_ACTIVE_LOW(1'b1), .VSYNC_ACTIVE_LOW(1'b1)",
                  ".HSYNC_ACTIVE_LOW(1'b0), .VSYNC_ACTIVE_LOW(1'b0)")
top = top.replace('cx == 1999 && cy == 1099','cx == 2199 && cy == 1124')
top = top.replace('CLK_HZ(33000000)','CLK_HZ(74285714)').replace("32'h00C11338","32'h00C11339")
(hdl/'top.v').write_text(top,encoding='utf-8')

pll = (hdl/'IP/video_pll.v').read_text(encoding='utf-8')
for name,before,after in [('REFCLK_DIV',2,7),('FBCLK_DIV',33,104),
                          ('CLKC0_DIV',25,10),('CLKC0_CPHASE',24,9),
                          ('CLKC1_DIV',5,2),('CLKC1_CPHASE',4,1)]:
    old,new = f'.{name}({before})',f'.{name}({after})'
    assert old in pll
    pll = pll.replace(old,new)
pll = re.sub(r'// C33 diagnostic PLL configuration.*?// VCO = .*?\n',
             '// C39 native-IO evaluation: 50MHz reference, M=104, N=7.\n'
             '// VCO=742.857142857MHz, C0=10 -> 74.285714286MHz, C1=2 -> 371.428571429MHz.\n'
             '// Nominal CTA 1080p30 pixel clock is 74.25MHz; this candidate is +0.0481000481%.\n',
             pll,flags=re.S)
(hdl/'IP/video_pll.v').write_text(pll,encoding='utf-8')
ipc = ET.parse(hdl/'IP/video_pll.ipc')
ipc.find('Page3/multiplication_factor').text = '104'
ipc.find('Page3/division_factor').text = '7'
for clock,div,freq in zip(ipc.findall('Page3/clocks/clock'),(10,2),(74.28571428571429,371.42857142857144)):
    clock.find('clock_division_factor').text = str(div)
    clock.find('clock_frequency').text = f'{freq:.16f}MHz'
ET.indent(ipc,space='  ')
ipc.write(hdl/'IP/video_pll.ipc',encoding='utf-8',xml_declaration=True)

avi = hdl/'open_tx/auxiliary_video_information_info_frame.v'
avi.write_text('''// CTA AVI for 1920x1080 progressive / nominal 30Hz, VIC34.
// RGB and other fields match the frozen C38 default; checksum 0x45.
module auxiliary_video_information_info_frame (
    output wire [23:0] header,
    output wire [223:0] sub_flat
);
    assign header = 24'h0d0282;
    assign sub_flat = {168'd0, 8'd0, 8'd0, 8'd34, 8'd0,
                       8'd8, 8'd0, 8'h45};
endmodule
''',encoding='utf-8')
pins = TARGET/'src/user_source/constraints_source/pin.adc'
pin_text = pins.read_text(encoding='utf-8')
pin_text = pin_text.replace('# AC601 + AC201, same HDMI/clock/LED/74HC595 pins as C32.',
    '# C39 electrical/timing evaluation: native LVDS33 on P4 GPIO. These ports are not routed to J4.')
for port,ball in [('HDMI_CLK_P','K11'),('HDMI_D0_P','L14'),('HDMI_D1_P','K15'),('HDMI_D2_P','H13')]:
    pin_text,count = re.subn(r'set_pin_assignment \{ '+port+r' \} \{[^\n]+\}',
        'set_pin_assignment { '+port+' } { LOCATION = '+ball+'; IOSTANDARD = LVDS33; PULLTYPE = NONE; }',pin_text)
    assert count == 1
pins.write_text(pin_text,encoding='utf-8')
sdc = TARGET/'src/user_source/constraints_source/timing.sdc'
sdc.write_text('''# AC601 50MHz reference; actual PLL M=104, N=7, C0=10, C1=2.
create_clock -name clk -period 20.000 -waveform {0.000 10.000} [get_ports {clk}]
create_generated_clock -name pixel_clk -source [get_ports {clk}] -master_clock {clk} -multiply_by 1.4857142857142858 [get_pins {u_video_pll/pll_inst.clkc[0]}]
create_generated_clock -name hdmi_5x_clk -source [get_ports {clk}] -master_clock {clk} -multiply_by 7.428571428571429 [get_pins {u_video_pll/pll_inst.clkc[1]}]
# Related 5:1 clocks, with 50% duty cycle and zero phase from the PLL configuration.
# Receiver and board-level external delays remain uncharacterized.
''',encoding='utf-8')

project_dir = TARGET/'src/td_project'
project_dir.mkdir(parents=True,exist_ok=True)
project = (BASE/f'src/td_project/{OLD}.al').read_text(encoding='utf-8')
project = project.replace(BASE.as_posix(),TARGET.as_posix()).replace(OLD,PROJECT)
(project_dir/f'{PROJECT}.al').write_text(project,encoding='utf-8')
(TARGET/'scripts').mkdir(exist_ok=True)
(TARGET/'build/manual').mkdir(parents=True,exist_ok=True)
for name in ('build_manual_syn.tcl','build_manual_phy.tcl','fix_hold.tcl','generate_bit.tcl'):
    text = (BASE/'scripts'/name).read_text(encoding='utf-8')
    text = text.replace(BASE.as_posix(),TARGET.as_posix()).replace(OLD,PROJECT).replace('C11338','C11339')
    (TARGET/'scripts'/name).write_text(text,encoding='utf-8')
runner = (ROOT/'development/video37_work/run_td.ps1').read_text(encoding='utf-8')
runner = runner.replace('ValidateSet(37,38)','ValidateSet(39)')
runner = runner.replace('player_video${Version}_open_tx','player_video${Version}_native1080p30')
runner = runner.replace('AC201_video${Version}_open_tx','AC201_video${Version}_native1080p30')
runner = runner.replace('$complete = $output.Contains($spec[1])',
    "$complete = $output.Contains($spec[1]) -and ($output -notmatch 'USR-8157|USR-8159')")
(ROOT/'development/video39_work/run_full_tx.ps1').write_text(runner,encoding='utf-8')
pin_runner = (ROOT/'development/video37_work/run_pin.ps1').read_text(encoding='utf-8')
pin_runner = pin_runner.replace('ValidateSet(37,38)','ValidateSet(39)')
pin_runner = pin_runner.replace('player_video${Version}_open_tx','player_video${Version}_native1080p30')
pin_runner = pin_runner.replace('AC201_video${Version}_open_tx','AC201_video${Version}_native1080p30')
pin_runner = pin_runner.replace('check_pin_stream.py','check_native_pin_stream.py')
(ROOT/'development/video39_work/run_native_pin.ps1').write_text(pin_runner,encoding='utf-8')
checker = (ROOT/'development/video37_work/check_pin_stream.py').read_text(encoding='utf-8')
checker = checker.replace('(640,1000,96) if args.version == 37 else (1920,2000,8)', '(1920,2200,2156)')
checker = checker.replace("body[4] == 0,'AVI VIC is not zero'", "body[4] == 34,'AVI VIC is not 34'")
checker = checker.replace('choices=(37,38)','choices=(39,)')
(ROOT/'development/video39_work/check_native_pin_stream.py').write_text(checker,encoding='utf-8')
shutil.copy2(ROOT/'development/video37_work/tb_gate_pins.sv',ROOT/'development/video39_work/tb_gate_pins.sv')
manifest = {file.relative_to(TARGET).as_posix():hashlib.sha256(file.read_bytes()).hexdigest()
            for file in sorted((TARGET/'src/user_source').rglob('*')) if file.is_file()}
(ROOT/'development/video39_work/full_tx_preparation.json').write_text(json.dumps({
    'state':'SOURCE_PREPARED_NO_BITSTREAM','baseline':BASE.as_posix(),'candidate':TARGET.as_posix(),
    'geometry':[1920,1080,2200,1125],'pixel_clock_hz':50e6*104/7/10,
    'serial_clock_hz':50e6*104/7/2,'refresh_hz':50e6*104/7/10/(2200*1125),
    'AVI_VIC':34,'source_binding':manifest,
    'hardware_scope':'Native Bank1 P4 signals; physical HDMI adapter electrical/routing validation pending.'
},indent=2)+'\n',encoding='utf-8')
print(json.dumps({'candidate':TARGET.as_posix(),'state':'SOURCE_PREPARED_NO_BITSTREAM','active':[1920,1080],'total':[2200,1125]}))
