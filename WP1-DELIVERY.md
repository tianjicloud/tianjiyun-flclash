# WP1 深空轨道交付记录

状态：本地实现与自动检查完成，待用户复核及实机验收；未推送、未发布。WP2 / WP3 未开始。

## 第 0 步

起点：624385f8；用户批准保留的节点名称修复为 4c2f5aec，设计文件同步合并为 41c7666d。
`flutter test test/views/dashboard/`：198 通过、0 失败。
本机缺 Cargo，测试临时关闭 setup / rust_api 原生构建 hooks，运行后恢复；此结果不代表原生构建验收。

已逐项打开核对：

| 锚点 | 核查结论 |
| --- | --- |
| common/constant.dart、models/config.dart | 默认蓝为 0xFF0A55F5，默认列表和 ThemeProps 引用它 |
| common/migration.dart、views/theme.dart | 仅保存色值，没有用户手动选色标记；旧升级步骤会重置色值 |
| dashboard/style.dart | SurfaceLevel 派生色、32/34 卡片圆角、等宽数字均存在 |
| dashboard/dashboard.dart | 天机订阅分发至 BusinessDashboardView，其余走原仪表盘 |
| dashboard/business.dart 全文 | 出口、线路、统计/订阅、开关布局；家宽分发条件保持不变 |
| widgets/current_outbound.dart | routedOutbound 探针、IP 质量数据、启停 toggleRunning、刷新和质量详情交互存在 |
| widgets/core_status_button.dart | 确认后重启内核，保持原样 |
| widgets/traffic_savings.dart | monthMainlandDirect、monthProxy、monthSavings；没有套餐计费进度分母 |
| widgets/profiles.dart | 已有到期日、剩余天数、用量进度、刷新和详情入口 |
| widgets/outbound_mode.dart | rule/global/direct 调用 setup action，不是场景或双轨 |
| widgets/network_takeover.dart | 系统代理与 TUN 分别写既有设置，授权状态仍由既有逻辑负责 |
| views/onboarding、providers/onboarding、common/onboarding | 已有导入流程，原样保留 |
| assets_source/images/icon/tianjiyun-mark.png、tool/generate_brand_icons.py | 既有品牌资产与生成入口，本轮不改图标 |
| DESIGN-V2.md、三张 PNG、三个 HTML | 已读取并目检；示意数据不进入产品 |

## 冲突与裁定

- surfaces.md 禁止结构描边/选中填充，与设计稿冲突。用户已批准仅天机业务仪表盘使用玻璃描边与渐变选中态；不扩展到全局侧栏或其他页面。
- 旧规格误指 CoreStatusButton；已按更正规格使用 current_outbound 的启停入口，不改重启按钮。
- 主题配置无法区分主动选回默认蓝与未改色。仓库规格已裁定：存量保存色全部保留，新安装使用新种子色。
- BusinessLineCard 的旧锚点描述已被用户批准的 4c2f5aec 更新：保留默认线路目录、实际节点名称与自有选择 sheet。
- 圆角采用设计稿刻度，仅业务作用域卡片 22、按钮 14、徽章 full，使用 AppShape；上游卡片仍保留原刻度。
- 流量卡不照搬原型的套餐用量百分比：环只用现有本月大陆直连与代理字节，中心显示节省字节，不引入计费口径；other-direct 不计入节省。
- 没有 DNS 一致性结果时隐藏对应信息；运行状态不表述为“隧道安全”。套餐外线路缺乏目录数据，不虚构禁用线路。

## 验收记录

实施前报告的测试预期变化：`test/common/migration_test.dart` 的“重置主题色”和“迁移旧系统预设色”两项将改为保留保存色值/色板。原因是规格明确裁定存量安装保存颜色一律保留；其他升级行为和失败保存测试继续保留。不是为通过测试删除断言。

### 提交与文件

- `ee87b083 feat(theme): adopt the space seed while preserving saved colors`
  - `lib/common/constant.dart`：新装默认种子色及默认色板首色。
  - `lib/common/migration.dart`：执行历史升级时保留保存色值和色板；版本号不变。
  - `test/common/migration_test.dart`：两项历史重置预期按裁定更新；补充旧默认蓝、系统色与新装验证。
- `52ea7a2f feat(dashboard): introduce the scoped deep-space business interface`
  - `lib/views/dashboard/business_theme.dart`：局部主题、集中色值/圆角、静态星云和轨道绘制。
  - `lib/views/dashboard/business.dart`：状态/出口、真实出站模式、线路、统计/订阅、接管开关层级；两类选择 sheet 换皮。
  - `lib/views/dashboard/style.dart`、`widgets/card.dart`：仅业务作用域启用描边、选中渐变、状态色与大字号徽章高度。
  - `lib/views/dashboard/widgets/current_outbound.dart`：复用探针、IP 质量和启停动作，换成轨道形态；运行时长、真实速率与已有测速结果呈现；业务 IP/徽章不再受旧固定行高裁切。
  - `lib/views/dashboard/widgets/outbound_mode.dart`：作用域内圆角及字号适配，模式动作不变。
  - `lib/views/dashboard/widgets/profiles.dart`：突出到期日/剩余天数、临近到期横幅；保留刷新/详情，并使用既有用户面板地址管理订阅。
  - `lib/views/dashboard/widgets/traffic_savings.dart`：现有统计的环形呈现，节省值仍等于大陆直连。
  - `test/views/dashboard/business_appearance_test.dart`：主题隔离与 5/28 天横幅边界。
  - `test/views/dashboard/business_layout_test.dart`：保留原断言，扩展深浅色布局矩阵。
  - `test/views/dashboard/current_outbound_test.dart`：保留上游测试，新增业务轨道启停及大字号 IP 不裁切/不重叠检查。

改到共用文件的原因：主题默认值/历史升级入口必须在 common 层处理；现有 dashboard widgets 同时服务上游和业务页，因此使用 BusinessTheme 作用域分支复用其数据和动作，不新建第二套业务状态。未改 prism_ui 子模块。

### 检查结果

使用 Flutter 3.47.6；每次运行结束均恢复两个 `build_assets: true`。日志位于本机 `~/.cache/tianji-residential-ui/`。

| 命令 | 实际结果 |
| --- | --- |
| `flutter pub get` | 成功；无依赖或锁文件变更 |
| `flutter analyze --no-fatal-infos` | No issues found |
| `dart format --output=none --set-exit-if-changed lib test tool plugins setup.dart` | 通过 |
| `flutter test test/views/dashboard/ test/lint/ test/common/migration_test.dart` | 最终 252 通过、0 失败，包含超椭圆 lint |
| `flutter test test/widgets/ test/views/dashboard/ test/lint/ test/common/migration_test.dart --name '^(?!.*a new script asks before a name alone is discarded)'` | 1,245 通过、0 失败；随后仅调整字号/徽章呈现，以上最终 252 项再通过 |
| 两个仓库外 widget 预览 harness | 12 通过、0 失败；普通/家宽 × 深/浅色 × 桌面/手机/大字号，无点击未命中警告 |
| `git diff --check`、comment-density hook | 通过 |

未运行：Cargo/Rust 原生构建与依赖 Rust editor 的 `a new script asks before a name alone is discarded` 用例；Go hook 同样在本地 widget 检查时关闭。没有把这些缺口表述为通过。

### 逐条验收

- [x] 第 0 步锚点核查与 198 项基线通过。
- [x] 自动测试验证新装种子 #3D5AFE；旧自选色、旧默认蓝和系统色保留。
- [x] 深浅色、桌面、窄屏、大字号布局和普通/家宽分发回归通过；超椭圆 lint 通过。
- [x] 测试替身验证轨道按钮仍通过原有 setup action 启停，未改 CoreStatusButton。
- [x] 测试数据截图目检主题、线路名称、轨道、属性和选择 sheet；长 IP 允许换行，大字号下无裁切。
- [x] 订阅 5 天出现横幅，28 天不出现；不增加订阅请求或通知机制。
- [x] 保留原导航，未增加场景、双轨、诊断或整页线路功能；无 DNS 结果时不显示结论。
- [ ] Linux/Windows 实际安装的新装/存量配置启动验证：未执行，本机未启动真实客户端。
- [ ] 真实测试订阅的连接/断开、出口和系统接管验证：未执行，不能以替身测试替代。
- [ ] 低端 Android、120 Hz 真机帧预算验收：未执行。背景和轨道采用静态 shader/有限绘制及 RepaintBoundary，无逐帧大面积模糊；这只是实现策略，不是性能实测结论。

### 预览（全部为测试数据）

本机缓存目录下：

- `wp1-dark-home-1200-1.0.png`：普通线路桌面深色。
- `wp1-residential-dark-home-1200-1.0.png`：家宽桌面深色。
- `wp1-light-home-390-1.0.png`：手机浅色。
- `wp1-residential-light-home-390-1.6.png`：家宽手机大字号。
- `wp1-dark-picker-1200-1.0.png`、`wp1-residential-dark-picker-1200-1.0.png`：两类选择 sheet。

截图由 Flutter widget 渲染，无生产账号；203.0.113.9 是文档示例地址。预览 harness、字体加载和图片均未入仓。

## 禁区自查与遗留

已自查 WP1 全部代码 diff，未触碰禁区 B1–B7；图标文件零改动，CoreStatusButton 零改动，版本号/工作流/子模块/订阅解析/上报契约/家宽变换零改动。本轮未编辑 models/providers/database，无需新增代码生成；没有手改任何生成文件。

唯一批准的规范例外是业务仪表盘及其线路选择呈现使用玻璃描边和渐变选中态，以用户会话裁定为准。全局侧栏不在这一作用域内，仍使用上游样式。

取舍与待复核：环的比例为大陆直连 /（大陆直连 + 代理），中心显示真实节省字节，不把其他直连算成节省；没有延迟测量则不显示延迟，DNS 结论同样不造值；到期/更新时间复用现有本地时间口径。手机通常显示统计/订阅双卡，窄屏或放大字号时改为纵向，优先保证可读性。

存量主题的颜色和色板保存值保持不变，历史升级的其他行为（例如玻璃模式升级）照旧。默认 ThemeMode 仍跟随系统，不强制用户进入深色。

起过的端口已全部关闭；本轮实际上未启动任何监听端口或真实客户端。WP1 尚待用户复核及上述实机验收，不据此进入 WP2/WP3。


## v0.9.10 发布前 CI 补充核查

CI 42369118275 中 `test/views/theme_test.dart` 的两个用例仍引用旧默认品牌色，单独重跑也失败。
在修改断言前记录本次预期变更：`starts on blue among the system colors` 的默认色断言由
`0xFF0A55F5` 改为已批准的新默认 `0xFF3D5AFE`；`merges a color edited into one already listed`
的色块选择、编辑输入与去重后的颜色断言同步指向新默认色。保留默认值检查、色板成员检查、
重复色合并后的数量减一与原色移除断言，不删测试、不放宽匹配。

这两项遗漏不在前次 dashboard/lint 相关套件里，现由发布前全量 CI 发现并补齐。
同轮 scroll_test 在共享 isolate 中报告定时器残留，CI 自动单独重跑通过，未改该用例或统计逻辑。
