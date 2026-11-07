# 天机云客户端 v2 改造规格书（给 Codex 的执行提示词）

Codex 你好。本文件是天机云定制客户端（FlClash 分叉，仓库 `tianjicloud/tianjiyun-flclash`，工作分支 `tianjiyun-dev`，基线 HEAD `624385f8` / v0.9.9）的 v2 改造规格，共三个互相独立、可分批交付的工作包：WP1 换脸、WP2 铁律 1（普通节点分组「切了立即生效」）、WP3 铁律 2（大流量绕行家宽）。设计依据是同目录的 `design.md`（设计 v2「深空轨道」，含第三节·五「用户亲定的三条功能铁律」）与三张效果图；design.md 是设计意图来源，**不是现状来源**——现状只认代码（见总则第 1 条）。

---

## 总则（四条强制约束，违反任何一条即视为交付不合格）

### 1. 锚点必须实测

- 本规格每个改动点引用的文件、类、方法，都必须能在当前 HEAD（`tianjiyun-dev` @ `624385f8`）打开并找到。
- 规格正文中标「未核实，Codex 动手前先核查」的锚点，是规格作者没有亲自打开确认的推断。Codex 动手前必须先核查：核查通过的，在交付说明里注明实际位置；核查不通过的，按总则第 2 条停工报告。
- 不许凭 design.md、TIANJIYUN.md 或本规格的行文描述推断代码现状；描述与代码冲突时以代码为准。

### 2. 冲突停工规则（写给 Codex）

> **规格与代码现状冲突时，停下，按代码现状为准，在该工作包的交付说明里报告冲突点，不许自行发挥，不许顺手重构。**
>
> 触发停工的情形包括但不限于：规格引用的锚点不存在或签名不符；规格假设的行为与代码实际行为不一致；实现规格必须改动禁区清单内的区域；实现规格必须推翻 `.agents/tianjiyun/` 既有文档口径。停工只停冲突涉及的部分，工作包内其余无冲突的部分可以继续；交付说明必须逐条列出冲突点（规格原文 vs 代码现状）。

### 3. 动手前只读核查步（每个工作包的第 0 步，验收前置条件）

每个工作包开工前固定先做只读核查，不许跳过：

1. 打开该工作包列出的全部锚点文件，逐个确认类、方法、字段与规格描述一致；
2. 跑一遍该工作包列出的现有相关测试，确认基线全绿，并把基线结果（命令 + 通过数）记入交付说明；
3. 核查结果与规格不符 → 先报告（按总则第 2 条），等指令再动手，不得带着疑点开工。

**第 0 步未完成、或基线非绿且未报告的，该工作包不验收。**

### 4. 禁区清单（本轮任何工作包都不许碰）

| # | 禁区 | 说明 |
|---|---|---|
| B1 | Go 内核与 Mihomo 子模块 | `core/` 下 Go 代码、`core/Clash.Meta` 子模块（含其 `tianji-traffic` 补丁分支）一律不动；不许为了实现本规格去改内核行为。 |
| B2 | 订阅解析与凭据处理 | 订阅 URL 下载、解析、token 提取与会话交换（`lib/core/traffic/auth.dart` 等）、profile 凭据的存储与日志路径不动；订阅链接不进日志的既有红线不许削弱。 |
| B3 | `.agents/tianjiyun/` 既有三份文档的口径 | `onboarding.md`、`traffic-statistics.md`、`follow-ups.md` 的口径是既有事实，不许在实现中推翻；流量统计三分类（mainland-direct / proxy / other-direct）与「节省 = mainland-direct」的口径不许改。 |
| B4 | 生成文件 | `*.freezed.dart`、`*.g.dart`、`lib/l10n/intl/messages_*.dart` 等生成文件不许手改；改 models / providers / database 后按仓库规矩跑代码生成（见「仓库硬规矩」）。 |
| B5 | 流量上报契约 | 上报端点、主机白名单、ACK 协议、scope 规则（`.agents/tianjiyun/traffic-statistics.md` 已定）不动。 |
| B6 | 家宽变换核心语义 | `lib/core/residential.dart` 的锁定组 + 非直属目标 REJECT 语义是铁律 1 的既成实现，WP2 只许对齐引用，不许改写其语义；如确需改动该文件，按总则第 2 条停工报告。 |
| B7 | 发布与签名 | 发布工作流、签名密钥、包名/应用 ID、版本号不动；本轮不发版、不打 tag。 |

每个工作包交付时，必须对该工作包的全部提交做一次 diff 自查，在交付说明里写明「已自查 diff，未触碰禁区 B1–B7」或列出例外并说明（例外未经事先批准即视为不合格）。

---

## 必读文件（开工前先读，顺序如下）

1. 仓库根 `AGENTS.md` —— 仓库入口规矩；
2. `.agents/project.md`、`.agents/commands.md`、`.agents/rules.md` —— 版本与构建依赖、命令、lint/测试/生成代码规矩；
3. `.agents/surfaces.md` —— 凡涉及表面着色（WP1 必读）：fill levels、选中与状态色、描边口径；
4. `.agents/setting-changes.md` —— 凡涉及设置项生效方式（WP2 若触及接管状态判断时读）；
5. `.agents/tianjiyun/onboarding.md`、`.agents/tianjiyun/traffic-statistics.md`、`.agents/tianjiyun/follow-ups.md` —— 天机云专属既有口径，不许与之冲突；
6. 仓库根 `TIANJIYUN.md` —— 产品红线（与本规格禁区清单互补）；
7. 设计文件在仓库根目录：`DESIGN-V2.md`（设计 v2 说明）与 `design-v2-assets/` 下的效果图 `desktop-dashboard.png` / `mobile-home.png` / `residential-lines.png`（同名 `.html` 是原型源码，精确色值与尺寸以它为准）；本规格在仓库根目录为 `CODEX-SPEC-V2.md`。文中其他地方提到的 design.md 即 `DESIGN-V2.md`。

## 仓库硬规矩（最硬的几条，其余以 AGENTS.md 与 .agents/ 为准）

- **提交禁止 `Co-authored-by` 署名**（给任何编码代理的都不行），`commit-msg` hook 会直接拒绝；
- **圆角一律超椭圆**：用 `AppShape` / `AppRadius` token（`prism_ui/lib/shape.dart`），禁止 `StadiumBorder`、`RoundedRectangleBorder`、`ClipRRect`、`drawRRect` 以及在 `BoxDecoration` / `InkWell` 上直接写 `borderRadius`；`test/lint/superellipse_corners_test.dart` 强制；
- **测试用 `flutter test`，不用 `dart test`**（models 依赖 Flutter 类型）；
- 改 models / providers / database schema 后**必须跑代码生成**，生成文件不许手改（见 B4）；
- 文案走 ARB/l10n 既有流程，不许在 UI 里散写硬编码字符串（仓库有动态消息键 lint）；
- **交付前**：`flutter pub get` + `flutter analyze --no-fatal-infos` 无问题 + 相关 `flutter test` 全过；构建 hook 需要的工具链（Go、Linux/Windows 上的 cargo）缺失时，写明跳过了哪项检查，不许默默跳过；
- 注释密度守仓库规矩（健康 ≤3.6%，单文件新增独立注释 >5% 会被 comment-density gate 拒）；不留注释掉的死代码；
- **UI 帧预算**（`.agents/rules.md` UI Frame Budget 一节）：动效与重排不得引入掉帧；只重建/重绘变化的部分，数据到达与延迟工作不得进入动效路径。

## 分支与提交纪律

- 只在 `tianjiyun-dev` 上工作，基于 `624385f8` 起步；**不推送、不打 tag、不动其他分支**；
- 小步提交：一个提交只做一件可独立说明的事；提交信息风格照仓库现有历史（`feat(dashboard): …`、`feat(residential): …`、`chore(release): …` 这类 conventional 前缀 + 英文摘要，仓库近史可查）；
- 现有测试不许删改来「凑绿」；行为确需变化时，先在交付说明里报告再改测试预期；
- 改动尽量集中在天机云定制层（`lib/views/dashboard/` 的业务仪表盘、`lib/core/residential.dart` 周边、`lib/providers/` 的天机云 provider），少动上游共用代码，便于日后跟上游同步；确需动上游共用文件时在交付说明里单列并说明理由；
- 本仓库是 GPL-3.0 分叉：保留上游版权与许可证头，不删除上游历史；新增文件如需版权头，照邻近文件的现有做法。

## 全局红线（承自 TIANJIYUN.md，三个工作包共同适用）

- 不为检测网站伪造 IP/DNS 结果；检测失败就如实显示失败，不许把失败记作通过/无泄漏；
- 不绕过套餐权限：套餐没有的线路看得见、点不了、写明原因（口径见 design.md 第三节 3）；
- 不新增遥测/使用统计；不把订阅令牌、密码、客户原始 IP 写进日志、诊断或仓库文件；
- 不接入管理员令牌；
- 不承诺「IP 数据库评分」「永久抗封」类文案。

---

## WP1 换脸（深空轨道视觉 + 仪表盘三层重排）

### 目标

把业务仪表盘（桌面 + 移动）从现状 Material 默认色板 + 亮蓝 `#0A55F5` 平涂，换成 design.md 第二节的深空蓝紫视觉体系，并按效果图把信息重排为三层：第一层状态与出口、第二层场景/模式与家宽、第三层流量/订阅/开关等管理信息。复用现有 widgets 与数据口径，只换呈现，不改业务逻辑。

### 现状锚点（均已在 HEAD `624385f8` 实测）

| 锚点 | 实测内容 |
|---|---|
| `lib/common/constant.dart:183` | `const defaultPrimaryColor = 0xFF0A55F5;`，注释 `// The tianjiyun.org brand blue.`；同文件 202 行起 `defaultPrimaryColors` 以它为首元素 |
| `lib/models/config.dart:89` | `defaultThemeProps = ThemeProps(primaryColor: defaultPrimaryColor)`，默认主题由此灌入 |
| `lib/common/migration.dart:198-199` | 旧配置迁移时写入 `defaultPrimaryColor` / `defaultPrimaryColors` |
| `lib/views/dashboard/style.dart` `DashboardColors` | 仪表盘颜色全部从 `context.colorScheme` 与 `SurfaceLevel` 派生（page/card/tone/tone2/track/ok/warn 等），本身不写死品牌色 |
| 同文件 `DashboardCorner` | 现值：desktopCard 32 / mobileCard 34 / block 20 / mobileBlock 22 / tab 16 / badge 14（注意：与 design.md 的 20–22px 卡片圆角不一致，见改动点 4） |
| 同文件 `DashboardText` | 数字已经走 `.toTabular`（等宽数字），design.md 的 tabular 要求现状已满足，不用重做 |
| `lib/views/dashboard/dashboard.dart:54` | 天机订阅 profile 走 `BusinessDashboardView`，非天机订阅走上游可编辑仪表盘——本 WP 只动前者路径 |
| `lib/views/dashboard/business.dart` `BusinessDashboardView` / `_BusinessBody` | 业务仪表盘主体：`CurrentOutboundCard`（固定高 176/208）→ 接管警告 → `BusinessLineCard` → 桌面双列 `TrafficSavingsCard` + `ProfilesCard` …（该文件后段未逐行读完，Codex 第 0 步补齐） |
| `business.dart:176` `BusinessLineCard`（d8c69383 后形态） | 按 `residentialPolicyProvider` 分发：家宽策略生效/有家宽套餐 → `ResidentialExitCard`（同文件 242 行）；否则渲染普通线路卡（根组取 `groupsProvider` 里名为 `appName` 的组，当前选择读 `selectedProxyNameProvider(root.name)`，「选择线路」按钮开 `showProxiesSheet`） |
| `lib/views/dashboard/widgets/current_outbound.dart:36` `CurrentOutboundCard` | 出口主卡：51 行起持有 `outboundIpProbeProvider.notifier` 并 `watch(routedOutbound)`，78 行 `entryOf(routedOutbound)` 读探针条目，85 行 `ipQualityProvider(ipInfo.ip)` 读 IP 质量 |
| `lib/views/dashboard/widgets/traffic_savings.dart:12` `TrafficSavingsCard` | 「本月节省」卡（流量节省统计呈现，口径见 B3） |
| `lib/views/dashboard/widgets/profiles.dart:67` `ProfilesCard` | 订阅信息卡 |
| `lib/views/dashboard/widgets/outbound_mode.dart` `OutboundModeCard` / `OutboundModeBar` | 现有「出站模式」控件：`Mode.rule/global/direct` 三段，经 `setupActionProvider.notifier.changeMode` 切换——注意这是 mihomo 出站模式，**不是** design.md 说的标准/进阶双轨（见「不许动的东西」） |
| `lib/views/dashboard/widgets/network_takeover.dart` | 系统代理/TUN 接管卡：48 行 `enum TakeoverSwitch { systemProxy, tun }`，开关分别写 `networkSettingProvider.systemProxy` 与 `patchClashConfigProvider.tun.enable` |
| `lib/views/onboarding/` + `lib/providers/onboarding.dart` + `lib/common/onboarding.dart` | 首次导入指引**已实现**（提交 `76d799eb`，2026-11-06，规格 `.agents/tianjiyun/onboarding.md`）：无订阅时首页整页引导（粘贴/扫码 → 掩码确认 → 无弹窗导入 → 节点数/流量/到期展示 → 探针验证通过才显示已连接）。**本 WP 不排它的任何功能开发**，最多随主题换色自然换皮 |
| `assets_source/images/icon/tianjiyun-mark.png` | 现有品牌标原图：1254×1254 RGBA 位图，亮蓝 `#0A55F5` 系云朵 + 轨道球造型，带渐变与辉光 |
| `tool/generate_brand_icons.py:17` | `SOURCE = ROOT / 'assets_source/images/icon/tianjiyun-mark.png'`，全平台全尺寸图标由它从原图生成 |
| `test/views/dashboard/` | 现有仪表盘测试集：`business_test.dart`、`business_layout_test.dart`、`current_outbound_test.dart`、`traffic_savings_test.dart`、`outbound_mode_test.dart`、`network_takeover_test.dart`、`profiles_card_test.dart` 等，是本 WP 的基线测试 |

### 具体改动点

1. **种子色切换**：`defaultPrimaryColor` 由 `0xFF0A55F5` 改为新种子 `0xFF3D5AFE`，同步 `defaultPrimaryColors` 列表与迁移默认值；注释改述为新品牌色。注意存量用户已保存的主题色不被静默覆盖——迁移/默认值只影响新装与未改过主题色的用户；若代码里区分不了「用户改过没」，按总则第 2 条报告，不要自行决定覆盖策略。**迁移策略已裁定（2026-11-07）**：配置确无「用户手动选色」标记（Codex 核查确认），故存量安装已保存的颜色一律保留、不强制迁移；新安装使用新种子色 `#3D5AFE`。深空深色底与仪表盘布局重排不受此限、照常生效。
2. **色板落地（以原型 HTML 为准）**：深色基底 `#0A0F2B`（原型另有 `#0C1130` 作更深层）、面板白 4% 半透明 + 1px 白 7.5% 描边（玻璃拟态）、主文字 `#EDF0FF`、次 `#98A2C8`、弱 `#7E88B3`，选中/强调渐变 `#3D5AFE → #6A5CFF`（侧栏选中态、场景分段选中态），家宽紫系 `#7C4DFF` / `#8C78FF`（35% 描边）/ `#B79CFF`，已连接绿以 `#34E0B0` 为准、原型高亮处用 `#4CE8BC`，提醒 `#FFC24D`，错误 `#FF5C7A`（规范预留）。落地方式优先走主题 `ColorScheme` + `SurfaceLevel` 派生（`DashboardColors` 已经全派生，不要在 widget 里散写 `Color(0xFF…)` 字面量）；与 `.agents/surfaces.md` 的 fill level / 状态色口径冲突时，按总则第 2 条报告。
3. **背景星云**：深空底色 + 右上紫、左下蓝两团低强度光晕 + 星点纹理，只做仪表盘页背景层；必须遵守 UI 帧预算（静态绘制/缓存，不许逐帧重算大面积模糊；做不到不掉帧就降级为纯色 + 静态渐变，并报告）。
4. **圆角对齐（与现状有出入，先报告再改）**：design.md 规范为卡片 20–22px、按钮 11–14px、徽章全圆角；仓库现状 `DashboardCorner` 是桌面卡 32 / 移动卡 34，且全仓强制超椭圆 token。Codex 第 0 步先核对 `.agents/surfaces.md` 与 `AppRadius` 刻度，提出「以哪套刻度为准」的结论写入交付说明后再动手——两套刻度不许混用。无论哪套，形状必须用 `AppShape`/`AppRadius` 的 `RoundedSuperellipseBorder` 等超椭圆 API。
5. **轨道连接按钮**：仪表盘第一视觉主角——渐变球体 + 虚线轨道环 + 光晕，状态色说话（靛蓝 = 已连接、灰蓝 = 未连接、琥珀 = 连接中/异常——注意原型文案是「靛蓝 = 连接中」，此处「连接中」指 connected 稳态，与「正在连接」的过渡态在实现时必须区分，过渡态用琥珀）。**锚点已更正（2026-11-07 复核确认）**：启停入口在 `lib/views/dashboard/widgets/current_outbound.dart` 的 `_toggle()`（约 764 行），调用 `commonActionProvider.notifier.toggleRunning()`；`core_status_button.dart` 的 CoreStatusButton 是「确认后重启内核」按钮，与连接启停无关，**不许拿它充当连接按钮、不许替换它**。新轨道按钮挂到 current_outbound 的既有启停入口上，只换形态与布局位置，启停语义、长按/右键等既有交互一项不许丢；丢不下的在交付说明里列明。
6. **桌面仪表盘三层重排**（`BusinessDashboardView`）：顶栏状态丸（订阅更新时间弱态 + 连接状态绿丸）→ 出口主卡（左：大字 IP、国家/城市、住宅/质量/运营商徽章、时长/延迟/速率；右：轨道按钮）→ 家宽/线路卡（紫描边，第二屏位；两种形态 `ResidentialExitCard` 与普通线路卡都要适配新样式）→ 流量环形 + 订阅卡行 → 接管开关行。DNS 出口展示位在出口主卡里预留（数据来自 WP2 的校验结果；WP1 先按「取不到就不显示」占位，不许写示例值）。
7. **流量环形图**：`TrafficSavingsCard` 数据口径不变（B3），呈现改环形进度 + 明细行；环的分子分母用卡里现有数据，不许新造统计口径。
8. **订阅剩余天数**：`ProfilesCard` 突出剩余天数与到期日；≤7 天变琥珀 + 仪表盘横幅——提醒逻辑只读现有 profile 到期数据，不新增请求；续费入口仍走既有面板链接，不在客户端内做续费。
9. **移动端首页重排**：同一信息层级单列化（连接 > 场景/模式 > 家宽 > 流量/订阅双小卡 > 开关）；底部四标签与现有移动导航一致，不新增标签。
10. **场景条与双轨（仅占位，不实现功能）**：场景模式（日常/AI/观影）与标准/进阶双轨是结构级功能，**不在本轮三个工作包范围内**（见「不在本轮范围」）。WP1 只在第二层预留视觉位置：可以先放与现状能力等价的控件（出站模式条、线路选择入口），不许做一个点下去没真实效果的假场景开关。
11. **图标处理（分叉口径，重要）**：
    - **默认路径**：WP1 沿用现有品牌标 `assets_source/images/icon/tianjiyun-mark.png` 完成换脸，不改任何图标文件。（说明：该标是仓库既有资产，与本设计稿无关，不要误记为设计稿产物。）
    - **新标路径（待用户拍板，当前未定稿）**：另有一版「深空轨道」新标在议——保持云 + 轨道轮廓、换 `#3D5AFE → #7C4DFF` 深空渐变、去辉光以保证 16px 托盘/任务栏尺寸可辨。在用户明确拍板前，Codex 不许自行换标、不许自行绘制替代标。
    - 若新标后续定稿：**只替换 `assets_source/images/icon/tianjiyun-mark.png` 原图并重跑 `tool/generate_brand_icons.py`**，不许在各平台资源目录（Android mipmap、Windows .ico、macOS appiconset 等）手工改图标文件；生成后逐平台抽查一个最小尺寸（16px 托盘）与一个大尺寸渲染结果写入交付说明。
12. **引导流换皮**：首次导入指引（`lib/views/onboarding/`）不做任何流程/文案/状态改动，仅随主题色与表面体系自然换色；若换色导致引导页对比度或状态色异常，单独报告，不要顺手改引导逻辑。
13. **浅色模式**：同一色板降饱和、背景换 `#F2F4FF` 系派生，连接按钮与家宽描边保留渐变；不另起一套独立配色。

### 不许动的东西

- 业务逻辑与数据口径：探针、IP 质量、流量统计、订阅信息的数据来源与计算一律不动（B3、B5）；
- `OutboundModeCard` 的 rule/global/direct 语义不动，不许把它改名或包装成「标准/进阶双轨」；
- 家宽卡与普通线路卡的分发条件（`residentialPolicyProvider` 的判断）不动，只换样式；
- 引导流的流程、文案与失败归类（`.agents/tianjiyun/onboarding.md` 口径）不动；
- 禁区 B1–B7 全部适用。

### 验收标准

前置：第 0 步只读核查完成（锚点逐个打开确认 + `flutter test test/views/dashboard/` 基线全绿并记录）。

1. `flutter pub get`、`flutter analyze --no-fatal-infos` 无问题；`flutter test test/views/dashboard/ test/lint/` 全过（基线绿的用例不许变红；布局变化导致 golden/布局断言需更新时，在交付说明逐条说明改了哪条断言、为什么）；
2. `test/lint/superellipse_corners_test.dart` 通过——新增/修改的形状代码零违规；
3. 手工验收（桌面，Linux 开发机即可）：新装（清数据）启动 → 默认主题即深空色板、种子色为 `#3D5AFE`；导入任一天机订阅 → 仪表盘三层顺序与效果图一致（状态丸 → 出口主卡 → 线路卡 → 流量/订阅 → 开关）；连接/断开各一次，轨道按钮状态色与文案正确；切深/浅色各看一遍，无白底黑字错位、无溢出；
4. 手工验收（移动布局，窄窗口模拟即可）：单列顺序为连接 > 模式/线路 > 家宽 > 双小卡，底部四标签不变，大字号（系统字体放大）下不溢出；
5. 存量配置验收：用一份已改过主题色的旧配置启动，主题色保持用户所选不被覆盖（若实现上做不到，交付说明必须显式写明这一限制，不许默默覆盖）；
6. diff 自查：未触碰 B1–B7；图标文件零改动（除非用户已拍板新标且走了生成脚本路径，交付说明附生成脚本运行记录）。

### 已知风险与开放问题

- 种子色改动牵动 `defaultPrimaryColors` 与迁移逻辑，存量用户主题色处理是最大不确定项（见改动点 1）；
- 深空深色优先与仓库 `SurfaceLevel` / `.agents/surfaces.md` 的表面体系可能有口径冲突，需要第 0 步先对齐；
- 星云背景 + 玻璃面板在低端 Android 上的帧率风险（帧预算是硬规矩，做不到就降级）；
- 圆角刻度 design.md（20–22）与仓库现状（32/34）不一致，未定版（见改动点 4）；
- 浅色模式只给了派生原则，没有单独效果图，对比度需 Codex 按 surfaces.md 自检并在交付说明里说明。

---

## WP2 铁律 1：普通节点分组「切了立即生效」

### 目标

普通订阅/普通节点分组补齐家宽侧已有的保证：用户手动选了哪个节点，出口立刻就是哪个；自动机制不许静默盖掉手动选择；切换后自动做出口校验；仪表盘显示的出口与所选不一致时，用白话红字（错误色 `#FF5C7A` 或既有错误呈现）说明原因。归因不了的不许猜，显示「正在确认 / 无法确认」。

### 现状锚点（均已在 HEAD `624385f8` 实测）

| 锚点 | 实测内容 |
|---|---|
| `lib/providers/actions/proxies.dart:201` `ProxiesAction.changeProxy({groupName, proxyName})` | 切换主路径：先 `_rejectResidentialGroupChange` 拦截家宽组 → `profilesAction.updateCurrentSelectedMap` 乐观更新已选映射 → `_core.changeProxy(ChangeProxyParams)` 下发内核 → 失败回滚已选名 + error banner（`changeProxyFailedTip`）→ `result.changed` 为真时按 `appSettingProvider.closeConnections` 走 `closeConnections()` 或 `resetConnections()` |
| 同文件 `_rejectResidentialGroupChange`（changeProxy 紧下方） | 家宽策略生效时，对根组与锁定组的改选直接 warning banner（`residentialExitLocked`）并拒绝——这是 UI 层「被家宽锁定」归因的现成信号来源 |
| `lib/core/residential.dart:249` `applyResidentialEgress({config, selectedExit})` | 铁律 1 的范本实现：把全部代理目标规则改写到只含所选出口的锁定组；非根组直属成员的目标，锁定组保持 `REJECT`（宁断勿错）；`selectedExit` 不在可选列表时同样落 `REJECT`，结果带 `ResidentialExitState.applied / missingExit`（同文件 25 行枚举） |
| `lib/providers/outbound_ip.dart` `OutboundIpProbe.probe(target, route)` → `lookupOutboundIp(coreHandler, proxyName)` | 探针返回里除 IP 信息外还有 `chains`（`result.chains.firstOrNull` 即该探针实际经过的出站链首跳）、`coreEpoch`、`routeVersion`、`hits`——这是「按节点校验实际出口」的现成原料，但**节点名 → 期望出口 IP 的映射不存在**（见判定口径） |
| `lib/providers/routed_probe.dart` `RoutedProbe` | 探针调度基类：`watch/unwatch`、settle/throttle 时长；`CurrentOutboundCard` 已用它 watch `routedOutbound`（仪表盘当前实际路径出口） |
| `lib/views/dashboard/probe_start_hold.dart` | 启动初期探针失败有 5 秒宽限保持 probing 态的做法（`ProbePhase`）——WP2 的「正在确认」态应对齐这一既有口径，不另造计时 |
| `lib/providers/actions/setup.dart:343` `SetupAction.updateConfig()`（328 行有 debounce 版） | 配置重组装下发内核的路径：363/449/512 行附近已按 `isResidentialPolicyActive(profile)` 分支处理家宽——WP2 若需在配置层注入「手动优先」覆写，这是预期接入点，未核实其内部分支细节，Codex 动手前先核查 |
| `lib/views/dashboard/widgets/network_takeover.dart` | 接管状态读数：`networkSettingProvider.systemProxy`、`patchClashConfigProvider.tun.enable`——「未接管」归因的状态来源 |
| `lib/providers/residential.dart:36` `residentialPolicyProvider` | 家宽策略状态（active / catalogReady / hasPlan）的 UI 侧来源，`BusinessLineCard` 与 actions 共用 |
| 文案（l10n 实测） | `residentialExplanation` 已向用户声明「部分目标可能由服务端使用替代出口」；`residentialMissingDesc` 为「选择其他出口前，代理流量会被阻断；大陆直连不受影响」——WP2 的白话文案风格与事实口径对齐这两条 |

### 「不一致」的判定口径（先定口径再写码）

校验对象是**默认代理路径**（仪表盘 `routedOutbound` 探针所代表的实际路径），不是某个网站的个别结果：

1. **选择事实**：用户最后一次手动选择的（组, 节点），以 `selectedProxyNameProvider` / 已选映射的现值为准；用户从未手动选过（纯自动状态）时不做「不一致」判定，只显示当前出口。
2. **期望链**：所选节点经其所在组解析后，默认路径探针的首跳（`chains.firstOrNull`）应等于所选节点名（或其所属锁定组语义下的等价值）。探针结果的 `coreEpoch` / `routeVersion` 必须与切换后的当前值一致，旧 epoch 的结果一律作废，不参与判定。
3. **一致**：首跳 == 所选节点 → 仪表盘出口卡正常呈现，不加任何标记。
4. **不一致（可归因）**：首跳 != 所选节点，且能命中下表原因枚举之一 → 红字白话显示对应原因。
5. **不一致（不可归因）**：首跳 != 所选节点但命中不了任何已知原因 → 只显示「出口与所选不一致，原因正在确认」并触发一次重新探针；重探仍不可归因 → 显示「暂时无法确认原因」，**不许从下表里挑一个最像的糊弄用户**。
6. **未定**：探针在途、失败、或结果 epoch 已过期 → 显示「正在确认出口…」，不显示一致也不显示不一致（对齐 `probe_start_hold` 的宽限口径；探针失败按既有失败呈现，不许显示成「无泄漏/已生效」）。

### 原因枚举（穷尽已知，新增原因必须先改规格再实现）

| 枚举 | 判定信号（全部来自既有状态，不许新造推测） | 白话文案（草案，进 ARB 时可润色，事实不变） |
|---|---|---|
| `notCaptured` 未接管 | 系统代理与 TUN 均未开启（`network_takeover.dart` 的两个读数均为关）且内核在运行 | 「还没接管这台设备的流量：请在下方开启系统代理或 TUN，选好的节点才会生效。」 |
| `residentialLocked` 被家宽锁定 | `residentialPolicyProvider.active` 为真，且当前路径走家宽锁定组；或切换动作被 `_rejectResidentialGroupChange` 拒绝过 | 「家宽线路正在接管代理流量，普通节点的选择暂时不生效。先在家宽卡里切回按订阅分流，或更换家宽线路。」 |
| `serverAlternateExit` 服务端替代出口 | 家宽说明文案已声明的服务端行为：仅当所选路径的服务端配置明确标注了替代出口的目标范围时才可归因（标注来源未核实，Codex 动手前先核查订阅下发数据里是否存在此标注；**不存在标注就永远不用这个枚举**，落到不可归因） | 「这个目标由服务端安排了备用出口，所以看到的 IP 和所选线路不同，这是服务端设置，不是你的操作问题。」 |
| `groupOverridden` 被自动组接管 | 所选组本身是 URL-Test/fallback 等自动组（组类型可从 `groupsProvider` 的组数据读到），组内实际节点由内核按测速/健康检查选出且 != 用户点的节点 | 「这个分组是自动选节点的：你点的是分组，实际用哪个节点由测速决定。想要固定一个节点，请选手动分组。」——注意：这属于「选节点的动作被组语义接管」，与下面「手动优先」的改造直接相关；改造后若能消除，枚举保留作存量订阅的解释 |
| `unknown` 无法确认 | 以上皆不命中 | 「出口与所选不一致，暂时无法确认原因。可以点出口卡重新检测一次。」 |

### 具体改动点

1. **手动优先（配置层）**：用户在普通分组手动选定节点后，该选择不被 URL-Test/自动机制静默覆盖。预期实现路径（未核实，Codex 动手前先核查 `setup.dart` 的 `updateConfig` 组装细节后定案）：在配置组装阶段，对「用户有手动选择的组」做与 `applyResidentialEgress` 同思路的覆写——把该组收敛为只含所选节点的 select 语义（或等价的内核原生机制，如组类型降级 + `now` 固定，二选一由 Codex 在第 0 步核查后提出、写入交付说明再实现）；用户改回自动时（若 UI 有此入口）恢复订阅原组定义。覆写只作用于有手动选择的组，其余组与规则一字不动。
2. **不许改内核**：上述覆写只在 Dart 侧配置组装层完成（B1）；找不到不改内核的实现路径时，按总则第 2 条停工报告，不许硬上。
3. **切换后校验触发**：`changeProxy` 成功（`result.changed`）后，触发对默认路径的一次重新探针（复用 `routed_probe` 的 watch/节流机制，不新开轮询）；校验状态机按判定口径六态走：未手动选 / 一致 / 不一致（四枚举） / 未定。
4. **呈现**：校验结果落在出口主卡（`CurrentOutboundCard`）：一致时无额外标记；未定时一行弱态「正在确认出口…」；不一致时红字白话（上表文案）+ 一个「重新检测」动作（复用出口卡既有的点徽章重探交互模式）。文案全部进 ARB。
5. **家宽侧只对齐不重写**：家宽路径已满足铁律 1（锁定 + REJECT + 文案），WP2 只把它的状态读数接进同一套校验呈现（家宽生效时默认路径的期望链 = 所选家宽出口），`lib/core/residential.dart` 与 `_rejectResidentialGroupChange` 的行为不许改（B6）。
6. **失败不装成功**：`changeProxy` 现有失败回滚 + banner 保持；校验探针失败时按未定态处理，不许因为探针失败就显示「已生效」。

### 不许动的东西

- `lib/core/residential.dart` 的变换语义（B6）、内核与子模块（B1）；
- `changeProxy` 对家宽组的拦截行为本身（只能消费它的结果做归因呈现）；
- 流量统计与上报（B3、B5）；IP 质量判断的查询源/分类/缓存（`.agents/tianjiyun/follow-ups.md` 已明确暂缓，本 WP 不碰 `lib/common/ip_quality.dart` 的判断逻辑，只消费探针链信息）；
- 订阅侧组定义原文：覆写只发生在本地组装结果里，不回写、不修改订阅文件。

### 验收标准

前置：第 0 步只读核查完成（锚点打开确认 + `flutter test test/views/dashboard/ test/providers/` 中与 proxies/setup 相关的现有用例基线全绿并记录；setup.dart 组装细节核查结论写入交付说明）。

1. `flutter analyze --no-fatal-infos` 无问题；`flutter test` 相关套件全过；新增单测覆盖：判定口径六态各至少一例（纯函数化校验判定，输入选择事实 + 探针答案 + 状态读数，输出态与原因枚举），含「旧 epoch 结果作废」与「不可归因落 unknown」两例；
2. 手工场景验收（用测试订阅逐条演）：
   - a. 自动组里点一个非测速最优节点 → 出口卡在校验完成后显示该节点为实际首跳（手动优先生效），或若实现路径做不到，交付说明里必须有停工报告而不是假装完成；
   - b. 关闭系统代理与 TUN 后切换节点 → 出现 `notCaptured` 白话红字；开启任一接管后红字消失；
   - c. 家宽策略生效时切普通节点 → 出现 `residentialLocked` 文案，家宽出口本身不受影响；
   - d. 选一个已失效节点并重组配置 → 行为与家宽侧口径一致（宁断勿错或明确失败呈现），不静默漂移到其他节点且不告知；
   - e. 校验在途时仪表盘只显示「正在确认出口…」，不闪烁一致/不一致结论；
3. diff 自查：未触碰 B1–B7；`lib/core/residential.dart` 若有任何 diff，必须逐行说明且语义不变，否则不合格。

### 已知风险与开放问题

- 「手动优先」在不改内核前提下能否对所有组类型成立，取决于 `updateConfig` 组装细节与 mihomo 组语义，是本 WP 最大不确定项（第 0 步定案）；
- `serverAlternateExit` 的标注来源未核实，可能根本不存在 → 该枚举大概率长期闲置，属预期，不要为了用上它而造标注；
- 探针是抽样而非全量路径证明：判定口径只对默认路径成立，个别网站的服务端行为不在本 WP 保证范围内（文案不许承诺超出此范围）；
- fallback 组在主节点恢复后自动切回是其设计语义，与「手动优先」冲突时以本 WP 的覆写规则为准，但要在交付说明里写明对 fallback 语义的影响。

---

## WP3 铁律 2：大流量绕行家宽

### 目标

视频/流媒体/大下载类目标默认不走家宽出口，改走大带宽普通节点，日常/AI 场景下同样生效（不依赖用户切换到「观影」场景）。这是产品级默认分流，**不算** WP2 铁律 1 的「切了不生效」——但必须对用户明示哪些流量自动绕行。这是铁律 3（大陆流量走本地直连，已实现）的同类机制在「大流量」维度上的延伸。

### 现状锚点

| 锚点 | 实测内容 |
|---|---|
| `lib/core/residential.dart:249` `applyResidentialEgress` + `_rewriteRules` | 家宽生效时把全部代理目标规则改写到锁定组——这正是 WP3 要开的例外口：命中大流量域名集的规则须在改写时保留指向大带宽组（或在改写前先行分流），实现细节未核实到 `_rewriteRules` 逐行，Codex 动手前先核查 |
| 同文件 `ResidentialGraph`（50 行起） | 从最终配置的 `proxy-groups` / `proxies` 建图，含根组、锁定组与成员关系——「大带宽组」的认定应基于此图与订阅实际组名，不许写死组名猜测 |
| `lib/providers/actions/setup.dart:343` `updateConfig()` | 配置组装总入口，家宽变换在此链路上（363/449/512 行的家宽分支已实测存在）；WP3 的规则注入点预期在此链路与 `applyResidentialEgress` 的衔接处，具体位置未核实，Codex 动手前先核查 |
| `lib/l10n/intl/messages_zh_CN.dart:1412` `residentialExplanation` | 现文案：「需要代理的流量都会使用所选家宽线路；大陆与直连流量仍按订阅分流。部分目标可能由服务端使用替代出口。」——WP3 落地后这句「都会」不再成立，文案必须同步改（走 ARB 流程），新文案须含大流量绕行的明示 |
| design.md 铁律 2 设计补强③ + 本规格 WP2 原因枚举 | 呈现口径：家宽卡/线路页明示自动绕行的类别；WP2 的校验判定里，走大流量集的目标不参与「不一致」判定（它们本就不该走家宽） |

未核实（不许当现状写死）：订阅下发数据中是否已有可用的「大流量规则集」字段/规则集名；大带宽组在各订阅里的确切组名与识别方式。两者都是第 0 步核查项。

### 规则来源（优先级写死）

1. **订阅下发优先**：订阅配置中若已有指向大带宽组的视频/流媒体规则或规则集，客户端尊重订阅原样，不注入、不覆盖；本 WP 的客户端注入只在订阅没有等价规则时兜底。第 0 步先核查当前主力订阅的实际下发内容（用测试订阅，不用客户真实订阅），把结论写入交付说明。
2. **客户端内置兜底名单**：订阅无等价规则时，用下方草案域名集在本地组装阶段注入规则，目标组为经 `ResidentialGraph` 认定的大带宽普通组（认定规则第 0 步定案并写入交付说明；认定不了时不注入，报告之）。
3. **顺序红线**：注入规则的位置必须保证——大陆直连（铁律 3，既有规则）优先级不被破坏、大流量规则只影响原本会走家宽的那部分代理流量、不改变非家宽订阅的任何路由结果。非家宽订阅下注入规则应无效果或不注入，二选一并在交付说明写明。

### 内置兜底域名集草案（待用户确认，未确认前按草案实现但在交付说明标注「草案」）

以 `DOMAIN-SUFFIX` 为主，必要时辅以 `DOMAIN-KEYWORD`；以下是类别与代表域名，完整名单在实现时按此口径展开并在交付说明附全表：

- **YouTube / Google 视频**：`youtube.com`、`googlevideo.com`、`ytimg.com`、`youtube-nocookie.com`；
- **Netflix**：`netflix.com`、`nflxvideo.net`、`nflximg.net`、`nflxso.net`；
- **TikTok**：`tiktok.com`、`tiktokcdn.com`、`byteoversea.com`、`ibytedtos.com`；
- **Disney+**：`disneyplus.com`、`dssott.com`、`bamgrid.com`；
- **HBO / Max**：`max.com`、`hbo.com`、`hbomax.com`（CDN 域名未核实，Codex 动手前先核查并在交付说明标注来源）；
- **Twitch**：`twitch.tv`、`ttvnw.net`；
- **其他主流流媒体**：`vimeo.com`、`dailymotion.com`、`bilibili` 的海外 CDN 不在范围（大陆站点本就直连）；Prime Video（`primevideo.com`、`amazonvideo.com`）、Apple TV+（`tv.apple.com`，其 CDN 域名未核实，同上先核查）、Spotify 视频/音频（`spotify.com`、`scdn.co`）——是否纳入由用户确认草案时定；
- **大文件下载**：Steam 内容分发（`steamcontent.com`、`steamstatic.com`、Akamai/Limelight 上的 Steam CDN 主机名未核实，先核查）、Microsoft 更新与商店下载（`download.microsoft.com`、`windowsupdate.com`）、Apple 系统/应用下载（`mesu.apple.com`、更新 CDN 未核实，同上）；
- **明确不纳入**：AI 服务（ChatGPT/Claude 等，那是家宽的正当用途）、电商店铺与社媒运营站点（家宽核心场景）、一般网页与图片 CDN（范围不可控）。

### 与铁律 1 的关系（写死，不许含糊）

- 大流量集命中目标走大带宽组，是**产品级默认分流**，与用户手动选的家宽出口并存，不构成 WP2 的「不一致」：WP2 的校验判定对象是默认路径探针（非大流量目标），两边口径不许打架；
- 若用户在普通分组的手动选择与大流量集冲突（用户手动把某视频站所在组指到家宽），以大流量集为准还是以手动为准——**默认以大流量集为准**（铁律 2 是防烧家宽的产品红线），但必须在呈现层明示；此条属产品口径，交付说明里复述确认；
- 明示呈现：家宽卡（`ResidentialExitCard`）与线路选择页（`_ResidentialExitSheet`，business.dart:466）各加一行白话：「视频和大文件下载会自动走大带宽节点，不占家宽流量。」并同步修改 `residentialExplanation` 文案去掉「都会」的误导表述；家宽流量数字（若卡上有）口径不变，不许把绕行流量算进家宽。

### 具体改动点

1. 兜底域名集以纯数据 + 纯函数形式落地（建议放 `lib/core/` 天机云定制层，函数输入最终配置 + 认定出的大带宽组名，输出注入后规则列表），可单测、不依赖 UI；
2. 在家宽变换链路上开例外口：命中域名集的规则不被 `applyResidentialEgress` 改写到锁定组，改为指向大带宽组；`applyResidentialEgress` 的其余语义一字不变（B6——如实现必须改该文件内部实现细节，只许在 `_rewriteRules` 增加「跳过名单」参数这类向后兼容的改法，并在交付说明逐行交代；语义变化即停工）；
3. 订阅已有等价规则时整体不介入（判定方法第 0 步定案：如订阅规则中已存在指向非家宽组的上述域名集规则，即视为已有）；
4. 文案与呈现按上一节落地，全部走 ARB；
5. 规则集留热更新口：名单集中放一处常量/数据结构，订阅下发覆盖客户端名单的合并规则先写成「订阅有则全量用订阅的」这一条，不做复杂合并。

### 不许动的东西

- 铁律 3 的大陆直连规则与流量统计三分类（B3）：大流量注入不许改变任何 DIRECT 判定与节省口径；
- 非家宽订阅的路由结果（见顺序红线 3）；
- `applyResidentialEgress` 的锁定/REJECT 语义（B6）；
- 不许按流量大小做运行时动态判定（如「单连接超 X MB 才切换」）——本 WP 只做域名维度的静态分流，动态方案不在范围。

### 验收标准

前置：第 0 步只读核查完成（当前主力测试订阅的下发规则现状结论 + 大带宽组认定规则，写入交付说明；基线 `flutter test test/core/ test/views/dashboard/` 全绿并记录）。

1. 新增单测覆盖注入纯函数：家宽生效 + 命中域名 → 规则指向大带宽组；未命中 → 仍指锁定组；订阅已有等价规则 → 输出与输入一致（零注入）；非家宽配置 → 零注入或注入无效果（按定案口径断言）；大陆直连相关规则在注入前后逐条不变；
2. `flutter analyze --no-fatal-infos` 无问题；相关 `flutter test` 全过；
3. 手工场景验收（测试订阅 + 家宽生效状态）：打开 YouTube 播放一段高清视频 → 连接列表（请求页）里 googlevideo 连接的出站链是大带宽组而非家宽锁定组；打开任一 AI 服务 → 仍走家宽出口；打开任一大陆站点 → 仍直连；普通海外网页 → 仍走家宽；
4. 文案验收：家宽卡与线路页出现绕行明示；`residentialExplanation` 不再出现「都会使用所选家宽线路」的表述；WP2 校验在上述 YouTube 场景下不报「不一致」；
5. diff 自查：未触碰 B1–B7；`lib/core/residential.dart` 的 diff 逐行交代且语义不变。

### 已知风险与开放问题

- 域名集是猫鼠游戏：CDN 域名会变、区域差异大，草案名单必然不全；口径是「主流目标兜底」，不许在文案里承诺「所有视频都不走家宽」；
- 大带宽组认定依赖订阅组结构，不同订阅（试用/入门/家宽档）的组名可能不同，认定规则需在第 0 步用真实测试订阅验证；
- 订阅侧将来下发正式规则集后，客户端兜底应能整体让位——合并规则已在改动点 5 定为最简版，后续再议；
- HBO/Apple/Steam 等 CDN 域名未核实，实现前逐个核查并标注来源，不许凭印象写。

---

## 不在本轮范围（明确排除，防止顺手扩需求）

- 场景模式（日常/AI/观影）的功能实现与标准/进阶双轨的功能实现（结构级，另行立项；WP1 只预留视觉位置）；
- 一键诊断与脱敏报告导出（P1，另行立项）；
- 到期/流量提醒的通知机制（WP1 只做卡内呈现）；
- 线路故障自动恢复与切换策略（只做既有呈现的换皮，不改行为）；
- 首次导入指引的任何功能改动（已实现，见 WP1 锚点）；
- 家宽线路选择页的整页化（design.md 第三节 3 是目标形态，本轮只要求现有 sheet 随 WP1 换皮 + WP3 的绕行明示文案；整页化另行立项）。

## 交付方式（每个工作包分别交付，不许三个包攒一起交）

每个工作包交付时提交一份交付说明，必须包含：

1. **第 0 步核查结果**：锚点逐个确认结论（与规格不符的逐条列出）、基线测试命令与结果；
2. **冲突报告**：按总则第 2 条触发过的冲突点（规格原文 vs 代码现状 vs 处理方式），无冲突也要写「无」；
3. **变更文件清单**：每个提交的 hash + 一句话摘要 + 改动文件列表；
4. **测试结果**：`flutter analyze` 与相关 `flutter test` 的实际输出摘要（通过数/失败数），手工验收逐条对照本规格的验收标准打勾；
5. **禁区自查**：diff 已自查、未触碰 B1–B7 的声明，或例外清单；
6. **遗留与假设**：实现中做过的、规格没写死的判断（如圆角刻度定案、大带宽组认定规则、域名集全表），逐条列出等复核。

交付顺序建议 WP1 → WP2 → WP3（WP3 依赖 WP2 的校验口径，WP2/WP3 都可能碰 `business.dart` 与 setup 链路，串行交付避免互相踩踏）。每个工作包经复核通过后再开下一个；复核未过的工作包不许把问题带进下一个包。
