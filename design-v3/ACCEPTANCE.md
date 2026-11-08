# V3 首页验收记录（Codex）

日期：2026-11-08。基线：`tianjiyun-dev @ 782e6572`，含上一轮已验证但未提交的修复。
实施由用户指定的 `opencode-go/deepseek-v4.1-flash` 完成；Codex 编写方案、两轮视觉返工意见、最终补正要求并独立验收。
OpenCode 会话：`ses_e46b24e11ffeIbi1UJhzYWKS1E`。本记录以代码、实际日志和 Flutter 截图为准，不以实施方描述替代验收。

## 结论

本地 UI 实施及相关回归验收通过。尚未提交/推送/打 tag/发布安装包，不能把本次验收等同于 Windows 或 Android 实机发布验收。

## 审查及返工

1. 保留上一轮控制栏换行、手机布局、流量单位/下限与统计恢复修复，未通过回退修复来贴近原型。
2. 第一轮截图拒收：手机主卡和重复标题占用首屏、线路区异常留白、截图缺真实侧栏/导航、普通套餐夹具含家宽组。
3. 第二轮纠偏后：真实 HomePage 外壳、窄屏自然高度线路卡、真实普通套餐分支；390×844 正常字号四条线路可见，1568×1024完整桌面可见三卡及底部控制栏。
4. 最后补正将手机运行时长合并到速度指标 Wrap，停止/暂停仍显示占位符；组织信息通过既有 IP 质量详情访问，不用新增大卡。新增运行/停止状态测试。
5. 核对 QuickLines：改变的是 UI 候选组优先级（优先当前场景 Selector），实际选择仍调用原 ProxiesAction.changeProxy；未改配置组装、家宽锁定、自动组机制或路由规则。测试夹具为一组四节点，并非四个节点组。
6. 有效期缺少总周期时去掉 `days / 365` 进度；流量仍为 VPN/大陆直连/其他直连，节省口径未变。未测延迟不填示例数字。

## 实际验证

以下日志均在 `/home/nianyi778/.cache/tianji-residential-ui/`，非仓库内容：

| 执行方 / 时点 | 检查 | 结果 / 日志 |
| --- | --- | --- |
| DS Flash，第二轮主体完成 | `dart run tool/test.dart` 全仓 | 5122 passed，6 skipped；`v3-full-suite-round2.log` |
| Codex，第二轮主体完成 | `flutter pub get` | 成功；`v3-codex-pub.log` |
| Codex，第二轮主体完成 | `flutter analyze --no-fatal-infos` | No issues found；`v3-codex-analyze.log` |
| Codex，第二轮主体完成 | `dart run tool/test.dart test/views/dashboard test/widgets test/lint test/pages/home_test.dart` | 1287 passed；`v3-codex-tests.log` |
| Codex，第二轮主体完成 | 全仓 format 检查 | 1102 files，0 changed；`v3-codex-format.log` |
| 最后运行时长补正 | 当前出口 / business_layout / quick_lines 三文件 | DS Flash 51 passed；Codex独立复核51 passed，见 `v3-codex-final-tests.log` |
| 最后运行时长补正 | analyze / format | DS Flash实际输出无问题 / 0 changed；`v3-opencode-final.jsonl` |

5122/1287是最后小补正前的全量/相关套件结果，最后小补正只重跑受影响三文件，没有将先前全量结果冒充为最终提交全量重跑。
测试使用仓库允许的 UI 测试包装脚本：临时关闭 build_assets 后恢复，Rust 测试复用同源已编译缓存库；不计为重新构建 Go/Helper/Rust。主机 cargo 未在 PATH，本轮未进行原生打包。

## 视觉对照

Codex实际打开并审阅设计 PNG/HTML，以及下列真实 Flutter 渲染（测试数据，不是真实客户会话）：

- [完整桌面，家宽，1568×1024](/home/nianyi778/.cache/tianji-residential-ui/v3-after-desktop-planet-residential-1568x1024.png)
- [完整桌面，普通套餐，1280×800](/home/nianyi778/.cache/tianji-residential-ui/v3-after-desktop-planet-ordinary-1280x800.png)
- [手机，家宽，390×844](/home/nianyi778/.cache/tianji-residential-ui/v3-after-mobile-planet-residential-390x844.png)
- [手机，普通套餐，390×844](/home/nianyi778/.cache/tianji-residential-ui/v3-after-mobile-planet-ordinary-390x844.png)
- [手机，浅色纯色，390×844](/home/nianyi778/.cache/tianji-residential-ui/v3-after-mobile-solid-light-ordinary-390x844.png)
- [手机，大字体1.6](/home/nianyi778/.cache/tianji-residential-ui/v3-after-mobile-planet-residential-390x844-1.6.png)

已检查：背景贯穿真实侧栏、品牌/按钮层级、四条常用线路、普通套餐分支、深浅色可读性、单行自适应 IP、统计和订阅保留。窄320与大字体线路布局由专项测试验证；大字号不强求一屏，支持下滑。

与原型有意保持差异：
- 原生导航仍保留现有入口与组件，没有新增订单/我的空页面；侧栏未照搬示意账号卡。
- 数据和状态不照抄原型，不保证示例中的IP、延迟、流量、倍率或绿勾。
- 手机首屏以连接与四条常用线路优先；流量/订阅、线路详情、统计、接管控制可下滑。原型 overflow:hidden 不照搬。
- 保留用户背景和主题偏好；要查看星球效果选择 planet 预设，不强制覆盖已有选择。

## 范围与遗留

已自查 diff：未触碰 Go/Mihomo、子模块、路由核心、订阅凭据/鉴权、流量上报契约、版本、签名和发布工作流。生成文件的差异仅上一轮 formatter 产生的 l10n 格式修复。未删除现有测试凑绿；IP `maxLines` 断言变为1对应明确的单行自适应改动。

未验证：Windows安装包实机、Android设备/模拟器、TUN/代理真实接管、真实出口联网、120Hz帧预算及GPU玻璃成本。本轮没有为证明这些项目启动正常模式客户端或接入用户订阅。

OpenCode实施进程由Codex统一登记管理，交付前停止；本轮起过的端口与实施进程全部关闭，`devport mine`复核为空。
