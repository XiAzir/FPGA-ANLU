# C11205 本地验证范围

由 C11204 verified158 文件逐项 SHA 核验后隔离复制；原控制/亮度对比度、波形/冻结、字幕、音频/SD 仲裁/PHY/PLL/约束未改的文件通过 parent_source_audit.json 继承父证据。复制的旧 TB/review 是父版本材料，不把未重跑模型写成本版新增验证。

- run_wipe_address.ps1：全部61个8行边界、两buffer方向、四个整帧地址流、批次停顿及中途metadata变化，922360检查通过；独立host地址金值，非真实SDRAM。
- run_wipe_rgb888.ps1：模拟两个图像区的独立RGB字节编码，经实际rgb888_unpack32，四个640×480帧（8/472行、两方向），1228800像素通过，每帧230400 words、无underflow；模拟FIFO注册读延迟，未含实际FIFO IP或SDRAM。初版TB过早撤销FIFO clear导致预取旧context；匹配真实backend S_ACK清FIFO后通过，旧失败日志另存，非RTL修复。
- run_display_ownership.ps1：实际OSD/mailbox与loader逻辑通过。OSD缩小16行/step8、异步时钟、首图/旧身份/延迟ACK/释放一次/同身份；loader通过层级注入COMMIT/pending状态后测试完成toggle同步、WAIT_DISPLAY、队列/计时/看门狗和错误不发布。未包含完整BMP解析和真实payload。
- run_wipe_backend.ps1：生产640×480/step8、实际frame_fifo_read与OSD/router联动握手。最终121个整帧（首图和两方向各60帧）通过，每帧230400 words；总App读命令28109056（含定向重叠用例），3次release toggle。旧burst期间新请求等待到S_ACK且burst_cnt=256；ACK前126个旧请求地址仍旧context，之后完整新请求正确。模拟wrusedw=0、帧间空白缩短，不含实际FIFO、SDRAM数据返回或仲裁带宽/饥饿；50MHz mem/25MHz pixel/相移25MHz mailbox。两轮完成，后一轮加严ACK条件；不是长稳或实板测试。详见wipe_backend_review.md。
- 静态集成审查：../audit/integration_review.md，绑定源码指纹，不代替模型或板测。

正式TD/时序/位流来源绑定以build/manual与交付info为准。模型不证明加密SDRAM内部、物理BRAM/HDMI PHY、真实TF/显示器或实板通过，也不能证明动态波形双线已修复。
