# C11206 多尺寸 BMP / 最近邻首版规格

从 C11205 verified169 核验复制 src/scripts；不复制数据库。保持显示640×480、RGB888固定输出帧、双缓冲上下擦除/音频/OSD/波形/所有按键。FPGA在加载阶段缩放成640×480帧，显示读侧不改。不在PC预缩放素材。

## 格式与金值

只读FAT32根目录原最多4个短名BMP，24位BI_RGB、DIB>=40、正宽1..1024、height有符号绝对值1..768（正bottom-up/负top-down）。不再限制宽是4倍数；stride=(w*3+3)&~3，跳过真实padding。检查BM、planes1、bpp24、compression0、pixel_offset>=14+DIB、33bit offset+stride*abs(height)不溢出且<=file_size和declared_size，declared_size<=file_size；拒绝0维、INT_MIN高度、超界、短扇区/文件错误。头仍在首512字节前54字段；DIB扩展不解析，但边界检查不得放松。

等比居中，无裁剪，黑边：若w*OH>=h*OW，dw=OW，dh=max(1,floor(h*OW/w))；否则dh=OH，dw=max(1,floor(w*OH/h))。offx=floor((OW-dw)/2)、offy=floor((OH-dh)/2)。显示域内容点srcx=floor((x-offx)*w/dw)，srcy_top=floor((y-offy)*h/dh)，RGB金值由原BMP对应点生成，其他像素000000。默认OW640/OH480，TB可缩小输出尺寸但源范围同上。

现有frame_buffer WRITE_V_FLIP=1不改：engine输出bottom-up目标栅格（第0行对应显示y=OH-1），每行x正向；由旧writer翻转存到正常显示方向。bottom-based内容行j映射srcy_bottom=ceil((j+1)*h/dh)-1=floor(((j+1)*h-1)/dh)，BMP物理行正height取srcy_bottom，负height取h-1-srcy_bottom。不能用floor(j*h/dh)替代导致非整数缩放垂直偏一。

## 结构与接口

新增bmp_scale_engine：参数FRAME_WIDTH/FRAME_HEIGHT/MAX_SOURCE_WIDTH=1024/MAX_SOURCE_HEIGHT=768、PIXEL_INTERVAL=10；接口clk/rst/start，source_width[15:0]/source_height[15:0]/source_top_down，pixel_offset[31:0]/file_size[31:0]；card_read/card_addr[31:0]出，card_data[7:0]/card_valid/card_end/file_error入；pixel_ready入，pixel_valid/pixel_rgb[23:0]/done/error出。所有接口同50MHz SD域。start一次；EMIT以pixel_valid&&pixel_ready作为一次接收，valid在ready低时保持且RGB稳定，坐标仅在被接收后推进；成功done在最后像素已发出之后/同沿，只在源RGB输出有效完整后才允许COMMIT等待真实写完。

tf_bmp_file_player原端口新增write_ready输入并透传engine，所有控制/loader ownership保持：HEADER读0/校验、write_req/ACK、PAYLOAD启动engine并透传扇区请求、COMMIT等待write_finish toggle、WAIT_DISPLAY等待display_finish toggle。start不能早于write_req撤销；启动后留足原GAP3以便pack/FIFO清除撤销。next合并一项/AUTO/错误HALT保持；旧frame/identity在失败前台保持，不发布新图。可增加超时idle计数但不能因正常本地缩放计算而误触发旧“等待字节”watchdog。

engine内部：512字节同步读取扇区cache；按wanted byte地址所在逻辑扇区请求，只在card_end且恰512字节后置tag有效。整个512扇区收完才能暂停处理，不能逐字节反压SD。RGB三字节可跨扇区，已取B/G须保持；扇区请求撤销后至少3周期gap，以file_mapper armed/arbiter恢复。cache遇新图失效。

一条同步读取原始源RGB行缓存（最多1024像素），完整源行填充后按水平phase做最近邻读取；相同src物理行的后续输出行复用，避免放大重复行重复读卡。RAM不得异步读或用reset清数组；valid/tag控制旧数据不可见，RAM读延迟必须有真实WAIT。只缓存完整行；原图切换时失效。只有content行可记有效，黑边行不污染源行tag。源行缓存比最多640像素的已缩放缓存略大，资源由正式综合核准。

geometry只做setup：用迭代除法/移位除法，避免可变组合除法导致资源过大；逐像素源x及逐行源y用phase累加/反复减法（x初phase0、y初phase=h-1配src_bottom0，减dh直到phase<dh）。输出最短间隔10个clk（<=5Mpixel/s），额外实际write-clock域IP wrusedw<=480且非full/clear、两拍reset-release后ready；wrapper还要求非write_req/rst。FIFO511可用word，停发后预留30word覆盖engine/loader/pack在途（静态预计仅约2word），TB需强制读停验证不会写满或漏像素。不能仅凭平均供数率证明安全。

单sector cache允许跨行回访；top-down源以目标bottom-up生成会逆向读逻辑扇区，现有fat32_file_sector支持cache miss重新走链，但读取耗时可能更多。首版不承诺任意大图/卡/文件或最短加载时长。

## 验证/交付

独立host原始BMP+gold，原生640×480、320×240放大、800×600缩小、191×321奇数宽portrait/top-down、512×128横向；单位与生产像素TB覆盖padding、RGB跨512边界、同源行复用、非整数比例/黑边、短扇区/坏头/越界、完成/所有权时序。测试素材源尺寸必须保持，PC只生成preview gold，不把gold送板冒充缩放。

TD新工程正常时序/BRAM映射审核；使用C11205回退。不操作本机没有连接的板/TF/Flash。新测试素材可打包交同学，只复制BMP到根目录（备份旧图，最多4张），WAV保持；测试素材复制尚未执行。
