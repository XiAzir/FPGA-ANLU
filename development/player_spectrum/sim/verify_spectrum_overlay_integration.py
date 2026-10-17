#!/usr/bin/env python3
"""Independent checks for PCM/analyzer-to-serial-overlay integration observations."""
from __future__ import annotations
import json,sys
from pathlib import Path
import spectrum_render_gold as pixels

BANDS=24
class Model:
    def __init__(self):
        self.ready=[0]*BANDS;self.snap=[0]*BANDS
        self.display=[0]*BANDS;self.peak=[0]*BANDS;self.hold=[0]*BANDS
        self.pending=False;self.freeze_req=False;self.frozen=False;self.tone=False;self.stale=False;self.source=False;self.update_state=0;self.snapshot_tone=False
        self.capture_bank=1;self.ready_bank=0;self.snapshot_bank=0;self.ready_valid=False;self.snapshot_valid=False
    def capture(self,raw):
        self.ready=[pixels.magnitude_height(v) for v in raw]
        self.ready_bank=self.capture_bank;self.capture_bank^=1;self.ready_valid=True;self.pending=True
    def update(self,target):
        self.snap=target.copy()
        for i in range(BANDS):
            h=pixels.smooth(self.display[i],target[i]);p=self.peak[i]
            if h>=p:p=h;self.hold[i]=0 if h==0 else 10
            elif self.hold[i]:self.hold[i]-=1
            else:p=max(h,p-2)
            self.display[i]=h;self.peak[i]=p
    def vs(self,tone=None):
        if self.source:
            old_hold=self.hold.copy()
            self.ready=[0]*BANDS;self.snap=[0]*BANDS
            self.display=[0]*BANDS;self.peak=[0]*BANDS;self.hold=old_hold
            self.pending=False;self.freeze_req=False;self.frozen=False;self.stale=False;self.source=False
            self.capture_bank=1;self.ready_bank=0;self.snapshot_bank=0;self.ready_valid=False;self.snapshot_valid=False
            if tone is not None:self.tone=tone
            self.update_state=1;self.snapshot_tone=self.tone
        elif self.freeze_req:self.frozen=True
        else:
            self.snapshot_bank=self.ready_bank;self.snapshot_valid=self.ready_valid and not self.stale
            target=self.ready.copy() if self.snapshot_valid else [0]*BANDS
            self.update(target)
            self.pending=False;self.frozen=False;self.update_state=0;self.snapshot_tone=self.tone
            if tone is not None:self.tone=tone
    def state(self):
        return [((self.ready[i] if self.ready_valid else 0),(self.snap[i] if self.snapshot_valid else 0),
                 self.display[i],self.peak[i],self.hold[i],int(self.pending),
                 int(self.freeze_req),int(self.frozen),int(self.tone),int(self.stale),int(self.source),
                 self.update_state,int(self.snapshot_tone),int(self.update_state!=0),self.ready_bank,
                 self.snapshot_bank,int(self.ready_valid),int(self.snapshot_valid),self.capture_bank) for i in range(BANDS)]

def main():
    obs=Path(sys.argv[1]) if len(sys.argv)>1 else Path(__file__).resolve().parents[1]/'build'/'model'/'spectrum_overlay_integration_observed.log'
    oracle=Path(__file__).with_name('vectors')/'oracle.json';lines=obs.read_text(encoding='utf-8').splitlines()
    bands={};states={};pixels_seen=[];stable=[];commits=[];snapshot_stable=[];timeout=None
    for line in lines:
        q=line.split()
        if not q:continue
        if q[0]=='BAND':bands.setdefault(int(q[1]),[]).append((int(q[2]),int(q[3])))
        elif q[0]=='STATE':states.setdefault(q[1],{})[int(q[2])]=tuple(map(int,q[3:22]))
        elif q[0]=='PIX':pixels_seen.append(tuple(q[1:]))
        elif q[0]=='STABLE':stable.append((q[1],int(q[2])))
        elif q[0]=='SNAPSTABLE':snapshot_stable.append((q[1],int(q[2])))
        elif q[0]=='COMMIT':commits.append(tuple(map(int,q[1:])))
        elif q[0]=='TIMEOUT':timeout=int(q[1])
    cases=json.loads(oracle.read_text(encoding='utf-8'));expected_by_id={0:cases[0]['fixed_bands'],5:cases[5]['fixed_bands'],12:cases[12]['fixed_bands']}
    for fid,expected in expected_by_id.items():
        actual=sorted(bands.get(fid,[]));assert [k for k,v in actual]==list(range(24)),f'frame {fid}: missing or unordered bands'
        assert [v for k,v in actual]==expected,f'frame {fid}: actual analyzer disagrees with fixed-point gold'
    raw0=expected_by_id[0];raw5=expected_by_id[5];raw12=expected_by_id[12]
    m=Model();expected_states={}
    def snap(label):expected_states[label]=m.state()
    m.capture(raw0);snap('after_tone')
    m.vs(tone=False);m.capture(raw5);snap('tone_commit')
    m.vs(tone=False);snap('silence_commit')
    m.freeze_req=True;m.vs();snap('held')
    m.capture(raw12);snap('held_new_frame_pending')
    m.vs();snap('held_still')
    m.freeze_req=False;m.vs(tone=False);snap('thawed_commit')
    m.stale=True;m.vs(tone=False);snap('stale_commit')
    # Source change cancels an in-flight update; source VS atomically clears visible state.
    m.source=True;m.vs(tone=True);m.update_state=1;snap('source_clear')
    m.hold=[0]*BANDS;m.update_state=0
    snap('source_init_done')
    m.__init__();snap('reset_init_done')
    for label,wants in expected_states.items():
        got=states.get(label,{})
        assert sorted(got)==list(range(BANDS)),f'{label}: missing state rows'
        for i,want in enumerate(wants):
            row=got[i]
            if label=='source_clear':row=row[:4]+row[5:]
            if label=='source_clear':want=want[:4]+want[5:]
            assert row==want,(label,i,row,want)
            assert row[3]>=row[2],f'{label} band {i}: peak below bar'
    for label,n in stable:
        assert n==24 and label in ('rise_mid','silence_mid','thaw_mid','stale_mid','source_cancel'),(label,n)
    assert {'rise_mid','silence_mid','thaw_mid','stale_mid','source_cancel'} <= {x for x,n in stable},'missing front-stability window'
    assert snapshot_stable==[('real_pcm_frame',24)],'active target snapshot changed on overlapping real frame_done'
    assert len(commits)>=4,'expected completed atomic commits'
    assert timeout is not None and 2_400_000<=timeout<=2_500_000,f'100ms stale timeout outside expected range: {timeout}'
    assert len(pixels_seen)==2
    for label,x,y,de,rgbin,rgbout,held,tone in pixels_seen:
        source='silence_commit' if label=='silence_live' else 'source_clear';row=states[source]
        disp=[row[i][2] for i in range(BANDS)];peak=[row[i][3] for i in range(BANDS)]
        want=pixels.pixel(int(x),int(y),bool(int(de)),int(rgbin,16),disp,peak,bool(int(held)),bool(int(tone)))
        assert int(rgbout,16)==want,(label,'RGB mismatch',rgbout,hex(want))
    pixel_count=json.loads((Path(__file__).with_name('vectors')/'render_gold.json').read_text(encoding='utf-8'))['pixel_samples']
    report={'status':'PASS','actual_pcm_frames':3,'actual_band_frames':3,'band_outputs_checked':72,
        'renderer_states_checked':sum(map(len,states.values())),'atomic_commits_observed':len(commits),
        'front_stability_windows':stable,'snapshot_stability_windows':snapshot_stable,'pixel_samples_checked':pixel_count+len(pixels_seen),
        'checks':['actual PCM to analyzer band values versus independent fixed-point oracle','serial updater front unchanged before update_done and atomic commit','same-cycle frame_done/VS consumes previous ready frame and retains new frame_pending','attack/release, peak hold/decay and peak>=bar','HOLD freezes front while accepting frames; thaw updates latest ready frame','100ms stale zero-target update','source change cancels in-flight update and source VS clears all visible bands/title','asynchronous reset clears front and restarts private state initialization','actual analyzer-driven RGB pixel'],
        'timeout_cycles':timeout,'limits':['Production 1024-point analyzer arithmetic is used; integrated audio capture is accelerated to one valid per clock.','Icarus ROM loading and this state model do not prove TD/FPGA hardware initialization.','Internal state arrays and update_done are inspected to check sequential control; no board display/audio test is included.']}
    out=obs.with_name('spectrum_overlay_integration_result.json');out.write_text(json.dumps(report,indent=2),encoding='utf-8');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
