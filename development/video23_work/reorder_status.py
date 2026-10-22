from pathlib import Path
p=Path('E:/QQ CACHE/Download/安路资料/开发记录/当前状态.md')
t=p.read_text(encoding='utf-8')
a=t.index('## C11323模式控制独立审查与控制TB')
b=t.index('## C11323 扇区边界切换候选已交付',a)
c=t.index('## 最新板测：C21可播',b)
control=t[a:b].replace('C23 top完整SD/card集成仿真和实板仍待父任务完成。','后续C23完整SD/card与top往返仿真已完成，结果见上节；实板仍待用户反馈。')
t=t[:a]+t[b:c]+control+t[c:]
p.write_text(t,encoding='utf-8')
