from pathlib import Path
p=Path(__file__).resolve().parent
f=p/'tb_keyfreeze_wave.v'
s=f.read_text(encoding='utf-8-sig')
s=s.replace('[13:0] saved_', '[17:0] saved_').replace('[0:127]', '[0:511]')
s=s.replace('< 128', '< 512').replace('all 128 new bins', 'all 512 new bins').replace('j[6:0]', 'j[8:0]')
s=s.replace("7'd0}][13:7] == 7'd56", "9'd0}][17:9] == 9'd224")
s=s.replace("7'd0}][6:0] == 7'd56", "9'd0}][8:0] == 9'd224")
f.write_text(s,encoding='utf-8')
f=p/'tb_waveform_integration.v'
s=f.read_text(encoding='utf-8-sig')
s=s.replace('reg [13:0] gold_bins[0:127]', 'reg [17:0] gold_bins[0:511]')
s=s.replace('integer code_lo,code_hi,bin,acc=0,waitcycles;', 'integer code_lo,code_hi,bin,acc=0,waitcycles,mid,prev_mid,low,high,rowcode,distance,raw,q0,q1;')
s=s.replace(' initial begin\n $readmemh("music_pcm.hex",pcm);$readmemh("music_bins.hex",gold_bins);', ''' function integer q2;
 input integer sample16; integer value;
 begin
 if(sample16>=0)value=sample16/64;else value=-((-sample16+63)/64);
 value=value+112;q2=value<0?0:value>224?224:value;
 end endfunction
 initial begin
 $readmemh("music_pcm.hex",pcm);
 for(i=0;i<512;i=i+1)begin
 raw=$signed(pcm[2*i]);q0=q2(raw);
 raw=$signed(pcm[2*i+1]);q1=q2(raw);
 gold_bins[i]={9'(q0>q1?q0:q1),9'(q0<q1?q0:q1)};
 end'''.replace('\n+','\n'))
s=s.replace('bin=(x-64)/4;code_lo=gold_bins[bin][13:7];code_hi=gold_bins[bin][6:0];\n expected=(y>=412-code_hi && y<=412-code_lo)?24\'h00ffff:(y==384?24\'h404040:24\'h000000);', '''bin=x-64;high=gold_bins[bin][17:9];low=gold_bins[bin][8:0];
 mid=(high+low)/2;
 if(bin>0)begin
 prev_mid=(gold_bins[bin-1][17:9]+gold_bins[bin-1][8:0])/2;
 if(prev_mid<low)low=prev_mid;if(prev_mid>high)high=prev_mid;
 end
 code_lo=low;code_hi=high;rowcode=(412-y)*4;
 distance=rowcode<low?low-rowcode:rowcode>high?rowcode-high:0;
 case(distance)
 0:expected=24'h00ffff;1:expected=24'h00bfbf;
 2:expected=24'h007f7f;3:expected=24'h003f3f;
 default:expected=(y==384?24'h404040:24'h000000);
 endcase'''.replace('\n+','\n'))
s=s.replace('128 min/max gold_bins', '512 Q2 min/max/connection gold_bins')
f.write_text(s,encoding='utf-8')
print('C11301_INHERITED_FREEZE_AND_LAYER_MODELS_ADAPTED')
