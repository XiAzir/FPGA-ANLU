本轮 gate 结果使用完整输入检查，仍可引用。routed 结果不作为被测设计结论：本轮通用化错误地将所有 I_rst_dup_* 都作为外部 rst，部分实际为局部同步复位寄存器输出，改变了复位释放逻辑。修正后另跑 attempt_3_reset_closure。审计见总报告根目录 video/cone_audit_note.md。
