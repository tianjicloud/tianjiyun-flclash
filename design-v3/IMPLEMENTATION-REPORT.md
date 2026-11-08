# V3 首页实施报告（第二轮纠偏后）

执行基线：`tianjiyun-dev @ 782e6572` 之上的未提交工作区。
实施：OpenCode Go / DeepSeek Flash。方案与验收：Codex。
本轮未提交、未推送、未打 tag；未改 Go、子模块、凭据、报告契约、路由逻辑或版本。
上一轮未提交修复（控制栏换行、手机品牌行、手机统计、剩余流量单位/下限、生成文件格式）全部保留。

## 本轮改动

### 1. 真实外壳截图

- 截图 harness 改用真实 `HomePage` + `AppSidebarContainer` + 真实导航项，不再只渲染 `BusinessDashboardView`。
- 桌面截图含真实侧栏（`NavigationSidebar`），手机截图含真实底部浮动导航（`NavigationDock`）。
- 未手绘假 sidebar，未改 `plugins/prism_ui` 子模块。
- harness 只在验证时复制到 `test/`，执行后已删除；副本在
  `/home/nianyi778/.cache/tianji-residential-ui/v3_shell_preview_scratch_test.dart`。
- 截图全部来自真实 Flutter widget 渲染，载入 Noto Sans CJK 与 Twemoji 字体，使用明确虚构测试数据。

### 2. 手机首屏与层级

- `lib/views/dashboard/business.dart`
  - 手机端不再显示重复的页面标题“仪表盘”，改为 `titleWidget` 中的真实品牌“天机云”；桌面仍显示“仪表盘”。
  - 删除正文中的独立品牌行，品牌与状态不再占三行。
  - “剩余 N 天”移入状态行，与运行状态同一行。
  - 手机内容底部改为 `context.bottomInset`，滚动内容可完整避开浮动导航。
  - 手机顺序改为：主卡 → 场景 → 常用线路 → 剩余流量/有效期 → 默认/家宽线路 → 流量统计 → 订阅信息 → 接管区。
- `lib/views/dashboard/widgets/current_outbound.dart`
  - 手机主卡收紧：轨道按钮 208→152，间距 14→10，卡片上下内边距 18→14。
  - 手机 IP 使用 `DashboardFitText`，不再换行断成两行。
  - 手机不再渲染重复的状态标题行。
  - 手机卡内 `_BusinessMetrics` 增加真实“运行时长”，与下载/上传同排显示；
    停止/暂停时沿用原 `_Cells` 的 `active` 语义显示占位符。
  - 组织信息不再放在卡内，改由点击 IP 打开质量详情查看：已核实
    `lib/features/ip_quality/ip_quality_sheet.dart` 存在 `ipOrganization` 行；
    未新增假组织数据。
- `lib/views/dashboard/widgets/scene_bar.dart`
  - 手机场景条只保留场景切换；规则/全局/直连移到下方接管区，避免首屏重复入口。
- `lib/views/dashboard/business.dart`
  - 手机接管区新增“出站模式”卡片，保留真实 `OutboundModeInline` 入口，随后是真实接管开关。
- `lib/views/dashboard/widgets/outbound_mode.dart`
  - 手机端三个模式按钮均分宽度，窄屏/大字号不再溢出；桌面仍按内容宽度排布并由控制栏的 `IntrinsicWidth` 约束。
- 结果：390×844 正常字号首屏可见完整四条常用线路。

### 3. 常用线路响应式

- `lib/views/dashboard/widgets/quick_lines.dart`
  - 去掉固定 `childAspectRatio` 的 `GridView`，改为自然高度布局：
    - 桌面四列；
    - 手机正常宽度两列；
    - 窄屏 320 或大字号 1.6 单列。
  - 名称允许两行并在省略时通过 `Tooltip` 提供完整名称；不再只做单行截断。
  - 使用 `EmojiText` 渲染国家旗帜，旗帜不再变成占位字形。
  - 线路来源优先当前场景的 Selector 组，其次场景枢纽/根组，最后第一个 Selector 组。
    这是 UI 候选线路的优先级变化；实际切线仍走原有 `proxiesAction.changeProxy`，
    核心选择/路由策略未改。
  - 卡片内边距在 compact 密度下收紧。
  - 不再出现标题与卡片之间约 80 dp 的空白（原 GridView 继承 padding 的问题已消除）。

### 4. 普通套餐预览夹具

- 预览 harness 的 `ordinary` 变体已移除 `🏠 家宽` 与 `🇯🇵 东京家宽` 组，并清空住所出口覆盖。
- 该夹具下 `BusinessLineCard` 走真实普通分支，显示“默认线路 / 台湾·家宽 / 更换线路”，没有伪造家宽或 AI 权限。
- 家宽变体仍使用真实住所组与覆盖，二者截图分开。

### 5. 轨道按钮立体感

- `lib/views/dashboard/business_theme.dart` 的 `OrbitPainter`：
  - 增加贴近外沿的光晕描边；
  - 增强球体左上高光并加入柔和高光斑；
  - 增加轨道顶部卫星光点。
- 只改绘制；`_StartToggle` 的启停、暂停、长按/右键、禁用、失败和 reduced motion 语义均未改动；没有新增全屏动效。

### 6. 桌面一屏与紧凑密度

- `lib/views/dashboard/business.dart`
  - 桌面内容最大宽度 1120→1280，接近设计稿内容宽度。
  - compact 密度下卡片间距 16→12。
  - 控制栏模式组用 `IntrinsicWidth`，规则/全局/直连与系统代理/TUN 在同一行，1280×800 与 1568×1024 均可见完整控制栏。
- `lib/views/dashboard/widgets/card.dart`
  - 玻璃卡在深色 planet 背景上桌面 0.62、手机 0.66 alpha，匹配设计。
  - compact 密度下业务卡内边距收紧。
- `lib/views/dashboard/widgets/current_outbound.dart`
  - compact 桌面主卡使用更紧的 IP 字号与按钮尺寸。
- `lib/views/dashboard/widgets/scene_bar.dart`
  - compact 密度场景条上下内边距收紧。
- `lib/ui/app_background.dart`
  - planet 深色背景按设计做深蓝底与方向性遮罩：宽窗从内容侧向右渐亮，窄窗自上而下压暗；其他预设、浅色和已保存偏好保持原行为。
  - 背景仍只绘制一次，未引入逐帧模糊或全屏动画。

### 7. 数据口径

- `lib/views/dashboard/widgets/profiles.dart`
  - 套餐有效期卡移除 `days / 365` 的伪装进度条，只保留天数与到期日期。
  - 上一轮的剩余流量单位与 `0` 下限修复保留。
  - 手机状态行显示剩余天数。
- 未引入任何假延迟、默认倍率、假 AI/家宽权限或假健康状态。

## 测试与命令

均通过给定 wrapper 执行（临时关闭 `build_assets` 后恢复），未并发调用。
涉及 Rust 编辑器库的测试额外设置：
`FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR=/home/nianyi778/.cache/tianji-residential-ui/wp3-rust-target/debug`。

| 命令 | 结果 |
| --- | --- |
| `flutter pub get` | 成功（wrapper 内） |
| `dart format --output=none --set-exit-if-changed lib test tool plugins setup.dart` | 1102 files，0 changed |
| `flutter analyze --no-fatal-infos` | No issues found |
| `flutter test test/views/dashboard`（运行时长补正前） | 238 passed |
| `flutter test test/views/dashboard/current_outbound_test.dart test/views/dashboard/business_layout_test.dart test/views/dashboard/quick_lines_test.dart`（补正后） | 51 passed |
| `flutter test test/views test/lint`（含 Rust 库环境） | 642 passed |
| `flutter test test/pages test/manager`（含 Rust 库环境） | 234 passed |
| `dart run tool/test.dart`（全仓，含 Rust 库环境；运行时长补正前） | 5122 passed，6 skipped |

最后一处“手机运行时长”补正后，按要求只重跑了当前出口 / business_layout / quick_lines
三个相关文件（51 passed）与 analyze/format，没有重复全仓 5122 测试。
Codex 独立验收的 1287 相关测试与全量 5122/skip6 日志保持不变、未被覆盖。

关键日志（仓库外缓存）：
- `v3-dashboard-round2.log`
- `v3-views-lint-final.log`
- `v3-pages-manager.log`
- `v3-full-suite-round2.log`
- `v3-round2-focused2.log`
- `v3-final-focused.log`

新增/调整测试说明：
- 新增 `test/views/dashboard/quick_lines_test.dart`：夹具的常用线路实际来自**一组四节点**
  （另有三个 `hidden: false` 备用分组覆盖状态过滤路径），使用真实长名称；覆盖 390 两列、
  320 单列、390×1.6 单列；断言四张卡与两行名称均存在且无 overflow。
- `business_layout_test.dart`：追加桌面/手机订阅态布局、模式入口唯一、手机“剩余/有效期”在默认线路卡之前的顺序断言。
- `scene_bar_test.dart`：夹具补 `hidden: false` 与真实 `now`，使场景与常用线路真实解析；追加常用线路标题与真实线路名断言。
- `profiles_card_test.dart`：追加“有效期不显示伪造比例/百分比”的断言；上一轮剩余流量单位与下限断言保留。
- `current_outbound_test.dart`：将业务主卡 IP 的 `maxLines` 断言从 `null` 改为 `1`，因为本轮明确改为单行自适应，避免 IP 换行断字。

## 真实截图（仓库外缓存）

路径前缀：`/home/nianyi778/.cache/tianji-residential-ui/`

- `v3-after-desktop-planet-residential-1568x1024.png`
  - 完整桌面外壳：真实侧栏 + 1568×1024 内容；含底部控制栏、场景、四条常用线路、家宽/统计/订阅三卡。
- `v3-after-desktop-planet-ordinary-1280x800.png`
  - 完整桌面外壳；普通套餐（无家宽组），默认线路卡可用；底部控制栏在首屏内。
- `v3-after-desktop-solid-light-ordinary-1280x800.png`
  - 浅色纯色背景普通套餐；底部控制栏在首屏内。
- `v3-after-mobile-planet-residential-390x844.png`
  - 完整手机外壳：真实底部导航；品牌在顶栏，状态一行；
    运行时长与下载/上传同排，四条常用线路首屏可见（补正后已重新渲染）。
- `v3-after-mobile-planet-ordinary-390x844.png`
  - 完整手机外壳；普通套餐无家宽组；四条常用线路首屏可见（补正后已重新渲染）。
- `v3-after-mobile-solid-light-ordinary-390x844.png`
  - 浅色纯色背景普通套餐。
- `v3-after-mobile-planet-residential-390x844-1.6.png`
  - 390×844、系统字号 1.6；常用线路单列自然高度，向下滚动可达，无裁切异常。

## 与设计的差异及未覆盖项

- 手机底部导航使用产品真实导航项（仪表盘/代理/配置/工具），不是设计稿的五个占位名称；未新增或替换路由。
- 手机顶栏仍保留真实更新入口/Core 状态动作。截图中右上角绿色 Core 状态按钮是测试宿主 `system.isAndroid == false`、`coreLib == null` 造成的宿主产物；真实 Android 构建中 `coreLib` 非空，不会出现该按钮。
- 截图使用虚构订阅数据（套餐、节点、延迟缺失等），不是真实账号数据；未提供延迟时截图不显示延迟。
- 未在真实 Windows/Android 设备或模拟器上运行，未做原生 Windows/Android profile、VPN/TUN、系统代理、托盘或服务生命周期验证。
- 未做真实 120 Hz 性能 profile；本报告只证明布局、重建与无 overflow，不宣称帧预算达标。
- 未启动任何监听端口，未启动 FlClash 正常进程。`devport mine` 中的
  `tianji-v3-ds-review` 是 Codex 已有的 CLI 服务，未触碰、未停止。
- 未提交、未推送、未打 tag。

## 禁区 diff 自查

- 未修改 `core/`、`plugins/prism_ui/`、`android/`、`ios/`、`windows/`、`macos/`、`linux/`。
- 未修改版本号、签名、发布流程、凭据、上报/报告契约。
- 未修改路由、选择策略、订阅权限或探针分类。
- 生成文件仅保留上一轮已有的 l10n 格式修复，本轮未手改生成文件。
