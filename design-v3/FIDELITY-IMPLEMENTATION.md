# V3 fidelity implementation record

基于 `FIDELITY.md` 实现桌面侧栏、手机悬浮导航和业务仪表盘布局。替换范围限于应用层导航与 dashboard 视图，保留现有路由、启动/暂停操作、线路选择、流量来源、订阅管理和家宽安全提示。

## 截图证据

截图由完整 `HomePage` 的 Flutter widget 测试生成，使用明确的合成订阅、线路、IP、速率测试延迟和流量统计；这些数值不代表真实用户数据。

缓存目录：`/home/nianyi778/.cache/tianji-residential-ui/`

- `v3-fidelity-desktop-planet-residential-1568x1024.png`
- `v3-fidelity-desktop-planet-disconnected-1568x1024.png`
- `v3-fidelity-desktop-planet-ordinary-1280x800.png`
- `v3-fidelity-desktop-solid-light-ordinary-1280x800.png`
- `v3-fidelity-mobile-planet-residential-390x844.png`
- `v3-fidelity-mobile-planet-disconnected-390x844.png`
- `v3-fidelity-mobile-planet-ordinary-390x844.png`
- `v3-fidelity-mobile-solid-light-ordinary-390x844.png`
- `v3-fidelity-mobile-planet-residential-390x844-1.6.png`

1280×800 预览断言实际 `NetworkTakeoverBlock` 底边不超出 800px。标准手机截图中两张首屏指标卡完整可见，导航 dock 与卡片间留有间距。截图用于视觉检查，不等于原生平台截图，也不宣称逐像素一致。

## 数据、交互和保留项

- 主卡沿用真实 provider 状态。手机连接态将速率、时长放入可展开详情；IP 仍服从隐藏 IP 偏好，点击 IP 可打开质量详情。探测失败与重探入口保留。
- 快捷线路展示真实选项及可用的探测延迟。当前线路从完整选择数据独立解析；找不到真实选中项时不猜默认线路。家宽展示用户实际选择的出口名称，不把锁定组别名当作出口。
- 侧栏和 dock 使用现有真实页面路由，支持键盘焦点与导航；没有为原型中的“订单/我的”新增不存在的产品入口。
- 订阅卡的续费按钮复用现有用户面板链接，管理入口仍保留。新增的“续费”文案已覆盖七种 ARB 语言。
- 未更改 prism 子模块、CoreStatusButton、内核/provider 业务、凭据、统计口径或上报流程。

## 验证记录

| 验证 | 结果 | 记录 |
| --- | --- | --- |
| `flutter pub get` | 通过 | `/home/nianyi778/.cache/tianji-residential-ui/v3-fidelity-pubget-final.log` |
| `flutter analyze --no-fatal-infos` | 无问题 | `/home/nianyi778/.cache/tianji-residential-ui/v3-fidelity-analyze-final2.log` |
| dashboard、home、business navigation、lint 相关测试 | 299 passed，0 failed | `/home/nianyi778/.cache/tianji-residential-ui/v3-fidelity-related-tests-final2.log` |
| 完整 HomePage 预览截图 | 9 passed，0 failed | `/home/nianyi778/.cache/tianji-residential-ui/v3-fidelity-preview-final.log` |
| 侧栏键盘焦点定向测试 | 1 passed | `/home/nianyi778/.cache/tianji-residential-ui/business-navigation-focus-recheck.log` |
| 格式与空白检查 | Codex最终检查通过：1108 files，0 changed | `v3-fidelity-codex-format-final.log`、`git diff --check` |

父级独立复核已完成：1299项扩展回归通过，最终静态分析无问题；详见 FIDELITY-ACCEPTANCE.md。尚未做 Windows、Android 原生实机截图或帧时间测量。未提交、推送或打标签。验证期间未启动监听端口，`devport mine` 为空。
