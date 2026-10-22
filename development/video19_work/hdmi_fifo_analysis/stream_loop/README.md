# MJP 全片读取与回环验证

日期：2026-10-21。测试 live `mjp_file_reader`，没有加载 JPEG core；输入媒体和播放器源码均只读，运行快照与证据保存在本目录。

## 输入绑定

- `VIDEO.MJP`：`stream_frontend/output/VIDEO.MJP`，11,755,520 bytes，SHA256 `2AABDD0AB590D742167AA82D69FF3B34687BC9B4D087B0B6981138FA182EFB09`。
- `index.json`：`stream_frontend/output/index.json`，SHA256 `4D0E3DBDC870B5A45E28EBCCB8D12F86DBEF81EFD53E5A89479B4AE9DEA78517`；300帧，512-byte sector。
- `TEST.WAV`：`stream_frontend/output/TEST.WAV`，SHA256 `30EAF10A6FF1800163CECB3225CCE685873B38C9A8E42635F1E5C92B0E95B5DE`。
- 独立 JPEG 参考：从原始MOV提取 MJPEG 文件 `development/video_codec_trial_20261021/media/letterbox640_q95_420.mjpg`，SHA256 `CF7E303FD31321DC5C3C29136F622EF286E730EA4BAF0C1431A32DEB5B38DEF3`。运行脚本独立按 JPEG SOI/EOI 切出300帧，逐项核对索引长度及 CRC32 后写入 `jpeg_reference/frame_000.jpg`…`frame_299.jpg` 和 reference manifest。
- reader：live `development/player_video19/src/user_source/hdl_source/mjp_file_reader.v`，SHA256 `CAD1B31DE5C3B62F482EC5BED8DB8ECA802621F315D5D4A525DB3411BF737018`；run copy 哈希相同。

## 验证

ModelSim SE-64 10.1c compile与仿真均 exit 0。测试按实际 `next_frame` 接口依次读取帧0至299，读取下一帧得到index 0；随后对reader复位、重新读文件头并读取frame 0。数据口每个已接受JPEG byte按低lane优先计算CRC32，与MOV提取的原始JPEG CRC逐帧比较；同时逐帧核长度、index、连续有效strb、非有效高lane零填充、单独空tail beat、`jpeg_valid && !jpeg_accept`时字段稳定。

结果：`STREAM_LOOP_PASS frames=302 full_loop=301 reset_frame0=1 requests=23111 card_gaps=381102 jpeg_stall_cycles=5832 max_stall=23 empty_last=302 error=1`。302条frame trace的长度/CRC/index与MOV参考完全匹配；23111个sector LBA请求与MJP索引布局完全匹配。300帧常规播放及首轮回环请求23035 sector；第二次复位播放请求header、record和frame0 JPEG共76 sector。随机card_valid间隙合计381102 cycle；随机ready叠加周期性18拍长暂停，观测到最大连续stall 23拍，输出保持断言通过。接着注入`file_error`，reader sticky error拉高并停止请求，PASS。

frame0 CRC32=`2e7f68e2`、长度37704 bytes；frame299 CRC32=`67460fca`、长度35721 bytes。frame trace最后三行显示frame299、loop frame0和复位后frame0的CRC/长度均正确。

## 复跑与证据

复跑入口：`python development/video19_work/hdmi_fifo_analysis/stream_loop/run_stream_loop_modelsim.py`。脚本只读取既有MJP/WAV/index/MOV MJPEG，生成隔离 run 输入副本、300帧JPEG reference、`card.hex`、expected length/CRC mem 文件，再用 ModelSim 编译 live reader 和 `tb_mjp_stream_loop.sv`。

PASS run：`runs/stream_loop_20261021_192331_482173/`。

- `result.json` SHA256 `09C8B666B75E709EE339B389A95383F64C2646399DF36B15F5C5B5C8EB36CBA8`
- `frame_reference_manifest.json` SHA256 `3C2E411B5F8A829D1B43CE001EE65860D30552E66E6EC0FD768920E775B3F8AE`
- `frame_trace.csv` SHA256 `808F2429EFDD9D93F5157242AB25D80DFBFAA2C22AC20FA23ADA3B389F55AEC3`
- `sector_requests.csv` SHA256 `3D29EC23AA589C30738AE2B3B627B9E47EE430FB8BECFFBB38A547498115F45F`
- `source_receipt.json`、`compile.log`、`console.log`、`run.log`同时保留，记录源/工具绑定和完整命令。

此结果验证MJP file reader的完整字节流、索引/长度、回环及错误接口；不覆盖JPEG解码像素、PCM播放节拍、HDMI包/串行内容、实际SD卡或板级行为。先前修正TB时的失败试验也保留在相邻timestamp run目录中；以本节指定PASS run为准。
