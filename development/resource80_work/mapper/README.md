# Mapper 状态消融

基线C11313，保持原API、SD握手、错误码和逐周期输出。四个单项和组合均通过13344拍边界差分；组合通过6381198拍、12295扇区最长链差分，含合法4096簇、回退/续读、4097簇、EOC和晚期环，Brent数值状态相同。日志与SHA见simulation.json。

1. `walk_count == walk_index`、`cache_walk_count == cache_index`：二者复位同为0；CHECK同时从成对缓存恢复或同时清0；每次FAT成功二者同时加1；每次数据成功二者同时缓存。CHECK保证目标0..4095，缓存仅在缓存index≤目标时恢复，故walk_index递增至目标就发数据，walk_count始终≤4095。删除两组重复存储与不可达的4096路径，保留同名wire供验证观察。
2. `current_cluster/cache_cluster/cache_start/brent_anchor/cache_brent_anchor`只保存已接受的28位簇值：首次赋值发生在原S_CHECK的簇上界验证通过后，后续值来自28位掩码并通过原FAT检查；缓存与anchor拷贝同一已验证值。缩至28位。原rq_start仍32位，原输入范围与错误检查保持。Brent power的可达最大值4096，13位足够；接收字节数在512时停止递增并报错，最大512，10位足够。
3. `(current_cluster-2)`只在current_cluster≥2的SELECT路径使用，以28位先减再补零替代44位先补零再减；保留live shift 0..15和44位地址/溢出检测。
4. FAT offset按4字节对齐且范围0..508，byte_count从0按每个有效字节加1。完整512字节必然采集四个目标字节；原got_mask缺位检查在byte_count=512时恒通过。其余长度已有原E_SHORT，删除四个冗余标志及判断，错误优先级保持。

复现：从工程根运行`python development/resource80_work/run_mapper.py`；面积消融由主线程协调TD槽后运行`python development/resource80_work/measure_mapper.py`，同EG4S20BG256/20ns/AreaOptimizeHigh，器件LUT与generic LUT分别记录。
