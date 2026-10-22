"""Exercise real key gestures through the complete top-level mode/reset path."""
from pathlib import Path
import hashlib
import importlib.util
import json
import re
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
PHOTO_RUNNER = ROOT.parent / "photo_regression/run_photo_system.py"
PARAM_OVERRIDE = "defparam dut.u_adjust_control.CLK_FREQ_HZ=1000, dut.u_adjust_control.DEBOUNCE_MS=2, dut.u_adjust_control.HOLD_MS=30, dut.u_adjust_control.PULSE_MS=2, dut.u_adjust_control.LEGACY_GAP_MS=2;"

TB_SOURCE = r'''`timescale 1ns/1ps
module tb_system;
 reg clk=0,rst_n=0,key1=1,key2=1;
 always #10 clk=~clk;
 wire [3:0] led;
 wire seg_d,seg_s,seg_r,hclk,h0,h1,h2,ncs,sck,mosi,miso;
 assign miso=1'b1;
 top dut(.clk(clk),.rst_n(rst_n),.key1(key1),.key2(key2),.led(led),
 .seg7_dio(seg_d),.seg7_sclk(seg_s),.seg7_rclk(seg_r),
 .HDMI_CLK_P(hclk),.HDMI_D0_P(h0),.HDMI_D1_P(h1),.HDMI_D2_P(h2),
 .sd_ncs(ncs),.sd_dclk(sck),.sd_mosi(mosi),.sd_miso(miso));
 defparam dut.u_adjust_control.CLK_FREQ_HZ=1000,
          dut.u_adjust_control.DEBOUNCE_MS=2,
          dut.u_adjust_control.HOLD_MS=30,
          dut.u_adjust_control.PULSE_MS=2,
          dut.u_adjust_control.LEGACY_GAP_MS=2;
 integer mode_pulses=0,next_events=0,auto_events=0,reset_events=0;
 integer reset_width=0,last_reset_width=0;
 reg media_reset_d=0;
 always @(posedge dut.video_clk) begin
  if(dut.video_mode_press) mode_pulses=mode_pulses+1;
  if(dut.media_reset_active && !media_reset_d) begin reset_events=reset_events+1;reset_width=1;end
  else if(dut.media_reset_active) reset_width=reset_width+1;
  if(!dut.media_reset_active && media_reset_d) last_reset_width=reset_width;
  media_reset_d<=dut.media_reset_active;
 end
 always @(posedge dut.sd_card_clk) begin
  if(dut.video_next_press) next_events=next_events+1;
  if(dut.video_auto_press) auto_events=auto_events+1;
 end
 task wait_mode;
  input expected;
  integer i;
  begin
   i=0;
   while(dut.video_mode!==expected && i<300) begin @(negedge dut.video_clk);i=i+1;end
   if(dut.video_mode!==expected) $fatal(1,"mode timeout wanted=%b got=%b",expected,dut.video_mode);
  end
 endtask
 task press_chord_long;
  input expected_before;
  begin
   key1=0;key2=0;repeat(70) @(negedge dut.video_clk);
   if(dut.video_mode!==expected_before) $fatal(1,"mode changed before chord release");
   key1=1;key2=1;
  end
 endtask
 task press_key1_short;
  begin key1=0;repeat(12) @(negedge dut.video_clk);key1=1;end
 endtask
 task press_key2_short;
  begin key2=0;repeat(12) @(negedge dut.video_clk);key2=1;end
 endtask
 task wait_count;
  input integer which;
  input integer wanted;
  integer i;
  begin
   i=0;
   while(((which==0 ? mode_pulses : which==1 ? next_events : which==2 ? auto_events : reset_events)<wanted) && i<500) begin
    @(negedge dut.video_clk);i=i+1;
   end
   if((which==0 ? mode_pulses : which==1 ? next_events : which==2 ? auto_events : reset_events)<wanted)
    $fatal(1,"event timeout which=%0d wanted=%0d",which,wanted);
  end
 endtask
 task wait_reset_finished;
  integer i;
  begin
   i=0;
   while(dut.media_reset_active!==1'b0 && i<200) begin @(negedge dut.video_clk);i=i+1;end
   if(dut.media_reset_active!==1'b0) $fatal(1,"media reset did not finish");
   repeat(2) @(negedge dut.video_clk);
  end
 endtask
 initial begin
  #500000000;$fatal(1,"VIDEO_CONTROL_WATCHDOG");
 end
 initial begin
  repeat(100) @(negedge clk);rst_n=1;
  wait(dut.rst_all_reg===1'b0);
  repeat(5) @(negedge dut.video_clk);
  if(dut.video_mode!==0 || dut.video_mode_sd!==0) $fatal(1,"startup mode was not photo");

  press_chord_long(0);
  wait_count(0,1);wait_mode(1);
  wait(dut.video_mode_sd===1'b1);
  wait_count(3,1);wait_reset_finished();
  if(last_reset_width<31 || last_reset_width>33) $fatal(1,"mode media reset width=%0d",last_reset_width);

  press_key1_short();wait_count(1,1);wait_count(3,2);wait_reset_finished();
  if(dut.video_mode!==1 || dut.video_mode_sd!==1) $fatal(1,"video next changed mode");
  press_key2_short();wait_count(2,1);
  if(dut.video_paused!==1) $fatal(1,"video pause action missing");
  press_key2_short();wait_count(2,2);
  if(dut.video_paused!==0) $fatal(1,"video resume action missing");

  press_chord_long(1);wait_count(0,2);wait_mode(0);
  wait(dut.video_mode_sd===1'b0);wait_count(3,3);wait_reset_finished();
  if(last_reset_width<31 || last_reset_width>33) $fatal(1,"return media reset width=%0d",last_reset_width);
  if(mode_pulses!=2 || next_events!=1 || auto_events!=2 || reset_events!=3)
   $fatal(1,"event counts mode=%0d next=%0d auto=%0d reset=%0d",mode_pulses,next_events,auto_events,reset_events);
  $display("VIDEO_CONTROL_PASS mode_pulses=%0d next=%0d auto=%0d resets=%0d last_reset_width=%0d mode=%b sd_mode=%b paused=%b",
   mode_pulses,next_events,auto_events,reset_events,last_reset_width,dut.video_mode,dut.video_mode_sd,dut.video_paused);
  $finish;
 end
endmodule
'''


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


spec = importlib.util.spec_from_file_location("photo_runner", PHOTO_RUNNER)
if spec is None or spec.loader is None:
    raise SystemExit(f"cannot load existing integration runner: {PHOTO_RUNNER}")
photo = importlib.util.module_from_spec(spec)
spec.loader.exec_module(photo)
photo.HERE = ROOT
original_compile = photo.compile_sources
original_execute = photo.execute
simulation_result = None


def compile_with_controls(cwd, sources, flags, top_tb):
    top_tb.write_text(TB_SOURCE, encoding="utf-8")
    receipt = {
        "status": "prepared",
        "testbench": str(top_tb),
        "testbench_sha256": sha(top_tb),
        "top_source_sha256": next(item["source_sha256"] for item in json.loads(
            (cwd / "source_receipt.json").read_text(encoding="utf-8"))["inputs"]
            if item["source"].endswith("top_tf_hdmi_audio.v")),
        "parameter_override": PARAM_OVERRIDE,
        "key_drive": "active-low physical KEY1/KEY2 pins only",
        "scope": "isolated controls-to-top mode/reset/mailbox simulation",
    }
    (cwd / "video_controls_receipt.json").write_text(json.dumps(receipt, indent=2) + "\n",
                                                        encoding="utf-8")
    return original_compile(cwd, sources, flags, top_tb)


def capture_simulation(command, cwd, log, timeout=240):
    global simulation_result
    simulation_result = original_execute(command, cwd, log, timeout)
    return simulation_result


photo.compile_sources = compile_with_controls
photo.execute = capture_simulation
sys.argv = [str(PHOTO_RUNNER)]
before = set((ROOT / "runs").glob("photo_system_*"))
try:
    photo.main()
except SystemExit:
    pass

created = sorted(set((ROOT / "runs").glob("photo_system_*")) - before,
                 key=lambda item: item.stat().st_mtime)
if not created:
    raise SystemExit("photo runner did not create a control experiment run")
run = created[-1]
log_path = run / "console.log"
log = log_path.read_text(encoding="utf-8", errors="replace") if log_path.exists() else ""
sim_exit = simulation_result.get("exit_code") if simulation_result else None
match = re.search(r"VIDEO_CONTROL_PASS[^\r\n]*", log)
result = {
    "status": "PASS" if sim_exit == 0 and match else "FAILED",
    "run_dir": str(run),
    "simulator_exit_code": sim_exit,
    "pass_line": match.group(0) if match else None,
    "fatal_lines": [line for line in log.splitlines() if "Fatal" in line or "Error" in line][-20:],
}
(run / "video_controls_result.json").write_text(json.dumps(result, indent=2) + "\n",
                                                 encoding="utf-8")
print(json.dumps(result, indent=2), flush=True)
if result["status"] != "PASS":
    raise SystemExit(3)
