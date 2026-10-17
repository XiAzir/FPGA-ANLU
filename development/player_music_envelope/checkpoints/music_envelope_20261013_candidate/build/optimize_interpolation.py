from pathlib import Path
import hashlib,json,re,shutil
p=Path(__file__).resolve().parents[1]
f=p/'src/user_source/hdl_source/player_pcm_waveform.v'
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest().upper()
manual=p/'build/manual';archive=p/'build/initial_dsp_mapping'
assert not archive.exists()
shutil.copytree(manual,archive)
shutil.copy2(f,archive/'pre_shift_model_source.v')
old_hash=sha(f)
s=f.read_text(encoding='utf-8-sig')
start=s.index('    reg signed [21:0] interp_num;')
mark='''    // Signed constant shifts preserve the exact Catmull-Rom numerator while
    // preventing TD from mapping these small coefficients to extra DSPs.
    wire signed [21:0] c0=$signed({6'b0,p0});
    wire signed [21:0] c1=$signed({6'b0,p1});
    wire signed [21:0] c2=$signed({6'b0,p2});
    wire signed [21:0] c3=$signed({6'b0,p3});
    wire signed [21:0] c0x9=(c0<<<3)+c0;
    wire signed [21:0] c0x3=(c0<<<1)+c0;
    wire signed [21:0] c1x111=(c1<<<7)-(c1<<<4)-c1;
    wire signed [21:0] c1x29=(c1<<<5)-(c1<<<1)-c1;
    wire signed [21:0] c1x72=(c1<<<6)+(c1<<<3);
    wire signed [21:0] c2x111=(c2<<<7)-(c2<<<4)-c2;
    wire signed [21:0] c2x29=(c2<<<5)-(c2<<<1)-c2;
    wire signed [21:0] c2x72=(c2<<<6)+(c2<<<3);
    wire signed [21:0] c3x9=(c3<<<3)+c3;
    wire signed [21:0] c3x3=(c3<<<1)+c3;
'''
s=s[:start]+mark+s[start:]
replacement='''        case(pixel_in_segment)
            0: interp_num=c1<<<7;
            1: interp_num=-c0x9+c1x111+c2x29-c3x3;
            2: interp_num=-(c0<<<3)+c1x72+c2x72-(c3<<<3);
            default: interp_num=-c0x3+c1x29+c2x111-c3x9;
        endcase'''
s,n=re.subn(r'        case\(pixel_in_segment\).*?        endcase',lambda m:replacement,s,count=1,flags=re.S)
assert n==1 and "*22'sd" not in s
f.write_text(s,encoding='utf-8')
(p/'build/audit/interpolation_optimization.json').write_text(json.dumps({'reason':'TD mapped 10 additional DSPs for constant interpolation weights; first synthesis total18 instead of target8','archive':str(archive),'oldWaveformSha256':old_hash,'newWaveformSha256':sha(f),'identities':['9=8+1','3=2+1','111=128-16-1','29=32-2-1','72=64+8'],'width':'Signed22: p0..p3 in[0,832], conservative full numerator absolute bound126464<2^21','functionalIntent':'Numerator exact algebraic equivalence; old production PASS must be preserved under old hash, new model binds new source'},indent=2),encoding='utf-8')
print('INTERPOLATION_MULTIPLIERS_REPLACED_WITH_EXACT_SIGNED_SHIFTS')
