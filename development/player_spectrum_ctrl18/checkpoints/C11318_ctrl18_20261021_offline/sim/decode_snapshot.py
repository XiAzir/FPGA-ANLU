"""Decode the seven frozen eight-digit words displayed by C11312."""
import argparse,json,re
from pathlib import Path
def decode(words):
    values={}
    for word in words:
        word=word.strip().upper()
        if not re.fullmatch('[0-9A-F]{8}',word):raise ValueError('每个值必须是完整八位十六进制：'+word)
        if word[0] not in '6789ABC':continue
        if word[0] in values and values[word[0]]!=word:raise ValueError('同一快照页有不同值；请分开不同音源的记录')
        values[word[0]]=word
    if set(values)!=set('6789ABC'):raise ValueError('需要6、7、8、9、A、B、C七页完整值')
    data={k:int(v,16)&0xffffff for k,v in values.items()}
    for k in '789ABC':
        if int(values[k][1],16)!=8:raise ValueError(k+'页尚未捕获或页格式不正确')
    header=int(values['6'],16)&0xfffffff
    reason=(header>>24)&15
    if reason not in (1,2,3,4):raise ValueError('快照原因无效或尚未触发')
    prev_flags=(header>>12)&255;flags=(header>>4)&255
    def control(value):
        return dict(zip(('local_reset','source_change','timeout','capture_write','frame_done','band_valid','hann_seen','twiddle_seen'),(bool(value&(1<<i)) for i in range(7,-1,-1))))
    def progress(value):return {'state':value>>19,'sample_count':(value>>9)&1023,'window_low9':value&511}
    before=progress(data['7']);after=progress(data['8'])
    mismatch=data['A']!=min(data['9']+1,0xffffff) or after['sample_count']!=((before['sample_count']+1)&1023)
    if reason==4 and (not(prev_flags&16) or (prev_flags|flags)&0xe0 or not mismatch):raise ValueError('计数异常标志与快照内容不一致；请复核录像原始八位值')
    return {'build_id':'C11312','raw':values,'reason':{1:'锁定和FFT均已运行的参考快照；仍允许后续故障覆盖',2:'至少第四个视频帧起点时HDMI内核仍未锁定',3:'连续4096个输入有效样本期间FFT未完成一帧',4:'前一拍允许采样写入，下一拍的计数未满足增量关系'}[reason],
            'tone_mode':bool(header&(1<<23)),'hdmi_locked':bool(header&(1<<22)),
            'audio_valid':bool(header&(1<<21)),'fft_frame_seen':bool(header&(1<<20)),
            'before':{**before,'accepted':data['9'],'control':control(prev_flags)},
            'after':{**after,'accepted':data['A'],'control':control(flags)},
            'completed_frames':data['B'],'recovery_count':(data['C']>>8)&255,'source_changes':data['C']&255,
            'limit':'原子快照用于定位；不等于已确定电气或物理根因。'}
if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('words',nargs='+');parser.add_argument('--output',type=Path)
    args=parser.parse_args();result=decode(args.words);text=json.dumps(result,ensure_ascii=False,indent=2)
    if args.output:args.output.write_text(text,encoding='utf-8')
    print(text)
