# WP2 交付说明

状态：实现已本地提交，待复核与 Windows 实机网络验收；未开始 WP3，未推送、打 tag 或发版。

## 第 0 步与冲突裁定

原始核查基线为 `e3f2f7e5`，逐项锚点与冲突见 [WP2-AUDIT.md](WP2-AUDIT.md)。374 项相关基线测试全绿。用户随后批准新增手动选择事实、限定首页校验范围、补齐必要探针信息；规格修订 `556108fa` 已通过 `165d759d` 合并。本包实现基于该合并提交。

| 核查项 | 实际位置与结论 |
|---|---|
| 手动切换、失败回滚 | `lib/providers/actions/proxies.dart:220`，保留失败 banner 和当前选择显示的回滚；增加请求归属判断，旧请求不回滚新选择。 |
| 首页默认线路入口 | 同文件 `changeDefaultLine`（315 行），保留先成员组再根组的顺序与部分失败呈现，同时记录手动意图并应用本地配置。 |
| 家宽拦截 | 同文件 `_rejectResidentialGroupChange`（402 行），函数行为原样保留；调用者只消费拒绝结果用于呈现。 |
| 配置组装 | `lib/providers/actions/setup.dart:526` 的 `getProfile`，584 行调用 `makeRealProfileTask`；`lib/common/task.dart:386` 接入普通组覆写。`updateConfig` 热更新职责不变。 |
| 家宽变换 | `lib/core/residential.dart:249` 保持零 diff；家宽生效时跳过普通组覆写。 |
| 探针与新鲜度 | `outbound_ip.dart` 保留已有结果的 chains 到 `RouteStamp`；`route_state.dart:96` 与 `routed_probe.dart:206` 保持 epoch、version、hostEpoch、proxied 校验和现有 watch/settle/throttle 调度。 |
| 确认与归因 | `lib/providers/selection_verification.dart:17` 为纯判定函数；`selection_check.dart:60` 负责路径范围、待完成动作与一次未知原因重探。 |
| 接管状态、家宽策略、启动宽限 | 原 `network_takeover.dart` 两个设置读数、`residentialPolicyProvider`、`probe_start_hold.dart` 五秒启动保持均复用；这些文件没有修改。 |
| 服务端替代出口标注 | 现有客户端模型没有可用于归因的明确目标范围字段；未使用客户订阅或凭据调查服务端。因此本包不输出 serverAlternateExit 归因，不把既有说明文案当成事实证据。 |

冲突报告：原 C1（组装入口）、C2（选择事实及默认路径范围）、C3（UI 缺少链数据）均按用户明确裁定处理，无另行突破禁区的例外。原规格中自动组覆写的实现选择，采用原生 select + 固定选择，细节如下。

## 实现与判断

1. `ProfileOverrides.manualSelections` 存每组的节点、递增序号、原组是否自动选择。复用既有本地 overrides JSON，不改数据库 schema、订阅文件或凭据路径。旧配置的 selectedMap 不推断为手动历史。自动组变化、常规状态同步不写此记录。连续点击每次记录，原防抖只合并实际 apply。
2. 记录表示明确的用户意图，不等于已生效。失败时保留意图并报错、回滚已选显示；失败探针不显示成功。多组待完成动作分别记录，订阅切换、较新的选择、组件释放都有对应清理或过期检查。家宽拒绝的动作只记录提示事件，不篡改家宽选择。
3. `applyManualSelections` 只覆写有非空手动记录的组：改 select、设置 default-selected，保留可选成员，首位增加 REJECT，并设置 empty-fallback。对 provider 的筛选及插入位置作等价保护，确保缺失所选节点时首位仍是 REJECT。其余组和规则保持原值。隐式 GLOBAL 仅在它有手动记录时按内核现有成员构成显式定义，并加同一保护。
4. 此方案不依赖 URL-Test/fallback 的健康检查优先项：这些原生组会在所选节点失效后取消固定选择；转换为 select 后不再自动漂移，直至用户明确恢复自动。保留原有自动组“再点已选节点恢复自动”的操作；首页选择自动线路也清除对应自动组的固定意图。恢复时从订阅原定义重新组装。
5. 手动覆写存在时走完整配置组装，避开 base/overlay 不包含完整组定义的问题；没有手动覆写时保留原优化。组装与下发仍归既有 SetupAction 所有，构建 key 包含手动记录，异步过程中出现新选择会按既有机制重建最新配置。
6. 首页优先使用当前、新鲜探针的实际链确定参与校验的组；尚无新鲜结果时只用已识别的默认根路径作待确认判断。无手动历史不判不一致；不在采样路径上的组不与首页出口比较。期望为所选节点经组解析后的出口，不是猜测一个预期 IP。默认根查询复用轻量函数，不在每次探针变化时构造整份线路选项。
7. 仅消费原查询已返回的链信息，无新增采集接口。选择后重探复用现有 watch 与失效/settle 调度，以 supersede 取代旧探针并按既有规则绕过旧结果的冷却期，不新开轮询；无法归因先提示正在确认原因并重探一次，仍未知则如实说明。旧 epoch/version、失败或在途答案不作为成功证据。系统代理/TUN 的设置读数不等于操作系统接管成功的实测证明。
8. 出口卡增加确认、未接管、家宽拒绝、自动组覆盖、未知原因提示与重新检测，七个语言 ARB 同步。业务仪表盘自然展开；上游固定高度出口卡在原指标区提供可滚动提示，保留 IP 与连接按钮。IP 质量源、分类、缓存及流量口径不变，未虚构 DNS 数据。

## 测试与生成

环境：Flutter 3.47.6 / Dart 3.13.5。通过本机 `verify.py` 临时关闭两个 native build_assets hook，结束后原样恢复 pubspec。缺少 cargo，未运行 Rust 构建、原生桌面打包或 Windows 实机测试；不能将这些 Dart 测试当成完整原生构建通过。

基线命令（374 通过、0 失败）：

```sh
flutter test test/views/dashboard/ test/providers/proxies_action_test.dart test/providers/setup_action_test.dart test/providers/setup_state_test.dart test/providers/default_line_action_test.dart test/providers/residential_setup_test.dart test/providers/outbound_ip_test.dart test/providers/routed_probe_test.dart --reporter expanded
```

最终回归命令：`00:31 +607: All tests passed!`，607 通过、0 失败，包含原 374 项基线。

```sh
flutter test test/views/dashboard/ test/providers/proxies_action_test.dart test/providers/setup_action_test.dart test/providers/setup_state_test.dart test/providers/default_line_action_test.dart test/providers/residential_setup_test.dart test/providers/outbound_ip_test.dart test/providers/routed_probe_test.dart test/core/manual_selection_test.dart test/providers/selection_verification_test.dart test/providers/selection_check_test.dart test/providers/manual_selection_action_test.dart test/lint/ test/l10n/ test/models/config_test.dart test/models/profile_test.dart test/models/profile_save_test.dart test/providers/profiles_action_test.dart test/common/default_line_test.dart test/core/residential_test.dart test/common/task_test.dart --reporter expanded
```

- `flutter pub get`、`dart run build_runner build`、`dart run intl_utils:generate` 均成功；生成文件只由生成器与 dart format 产生。
- `flutter analyze --no-fatal-infos`：No issues found，最终耗时 2.6 秒。
- 全仓 `dart format --output=none --set-exit-if-changed lib test tool plugins setup.dart`：1090 文件、0 改动；`git diff --check` 与 comment-density gate 通过。
- 默认根路径提取的最终定向测试：8 通过；出口卡与提示定向测试：29 通过，包括新增桌面/移动卡布局检查及 1.6 倍字体提示。以上与完整回归重复覆盖，不相加计数。
- 额外原生语义验证：从 `core/` 执行 `go run -mod=readonly /home/nianyi778/.cache/tianji-residential-ui/wp2-native-check.go` 成功。直接使用当前 Mihomo 的内存 provider 与 selector，验证所选节点、缺失后 REJECT、再次改选；包含筛选与 use-position。未启动 Core 服务、监听端口或测试流量；未修改 Go 或子模块。
- 日志目录：`/home/nianyi778/.cache/tianji-residential-ui/`，分别为 `wp2-baseline.log`、`wp2-final-tests.log`、`wp2-final-analyze.log`、`wp2-generate.log`、`wp2-native-check.log`、`wp2-root-check.log`、`wp2-card-tests.log`。

原有测试预期没有删除或放宽。`default_line_action_test.dart` 增加假 SetupAction，以适配新增的配置 apply，原有节点切换顺序与失败断言全部保留；另增 apply 失败、恢复自动测试。`residential_setup_test.dart` 增加普通组完整组装及家宽隔离测试。`current_outbound_test.dart` 增加提示布局用例，不修改原断言。

## 手工验收与遗留

以下不以单测替代实机打勾：

- [ ] a. Windows 测试订阅下，在自动组手动选择非最优节点，观察真实出口链。已有动作测试、配置组装测试与原生选择器语义验证。
- [ ] b. Windows 关闭系统代理和 TUN 后改选，检查红字并逐个开启消除。已有判定及文案测试，未操作用户当前网络。
- [ ] c. 家宽生效时改选普通根组，检查拒绝提示和家宽出口。既有家宽回归保持通过，未作真实订阅验收。
- [ ] d. 真实失效节点及订阅移除后重新 apply，确认宁断勿错。已有配置与原生缺失节点 REJECT 验证。
- [ ] e. 真实网络切换全过程无错误结论闪烁。已有 pending/旧答案/异步失败/订阅替换测试及头部 UI 测试。
- [ ] Android/低端设备帧率与真实平台接管验证。没有新增逐帧动画；未宣称达到实机帧预算。

没有使用实际主力测试订阅进行服务端范围调查；没有节点名到期望 IP 的映射。用户选择的是一个自动子组而非具体节点时，期望出口按其当前组解析结果判断，不承诺该自动子组永远保持同一个 IP。客户端记录与锁定不替代服务端出口范围说明。

## 禁区与结构自查

已自查本包全部 diff，未触碰禁区 B1–B7。B4 的生成文件改动均来自代码生成；`core/`、`lib/core/residential.dart`、流量认证/上报、既有天机文档、发布工作流、版本号、图标与锁文件均零改动。`_rejectResidentialGroupChange` 函数体保持不变。

涉及共用文件的理由：models/state 承载序列化与不可变组装快照；ProfilesAction/ProxiesAction/SetupAction 是现有选择与下发入口；task 是现有 isolate 组装入口；RouteStamp/RoutedProbe 负责已有结果的新鲜度与调度；代理卡须在组转换后保留恢复自动操作。没有新增生命周期控制者，没有绕过套餐权限。

提交前结构检查覆盖上述责任边界、纯函数、provider 与 UI，未发现需要另行裁定的结构问题。未启动监听服务，`devport mine` 为空；起过的端口已全部关闭（本轮无新增监听端口）。

## 提交与文件清单

下列为实现提交。交付说明自身另作 docs 提交，仅新增本文件，其 hash 见最终回复。

### d9383e91 — feat(proxies): preserve manual choices and verify default-route exits

```text
WP2-AUDIT.md
lib/common/default_line.dart
lib/common/task.dart
lib/core/manual_selection.dart
lib/models/clash_config.dart
lib/models/generated/clash_config.freezed.dart
lib/models/generated/clash_config.g.dart
lib/models/generated/state.freezed.dart
lib/models/state.dart
lib/providers/action.dart
lib/providers/actions/profiles.dart
lib/providers/actions/proxies.dart
lib/providers/actions/setup.dart
lib/providers/generated/action.g.dart
lib/providers/generated/outbound_ip.g.dart
lib/providers/generated/state.g.dart
lib/providers/outbound_ip.dart
lib/providers/route_state.dart
lib/providers/routed_probe.dart
lib/providers/selection_check.dart
lib/providers/selection_verification.dart
lib/providers/state/profile.dart
lib/views/proxies/card.dart
test/core/manual_selection_test.dart
test/providers/default_line_action_test.dart
test/providers/manual_selection_action_test.dart
test/providers/residential_setup_test.dart
test/providers/selection_check_test.dart
test/providers/selection_verification_test.dart
```

### b709c666 — feat(dashboard): explain manual exit verification states

```text
arb/intl_en.arb
arb/intl_es.arb
arb/intl_fr.arb
arb/intl_ja.arb
arb/intl_ko.arb
arb/intl_ru.arb
arb/intl_zh_CN.arb
lib/l10n/intl/messages_en.dart
lib/l10n/intl/messages_es.dart
lib/l10n/intl/messages_fr.dart
lib/l10n/intl/messages_ja.dart
lib/l10n/intl/messages_ko.dart
lib/l10n/intl/messages_ru.dart
lib/l10n/intl/messages_zh_CN.dart
lib/l10n/l10n.dart
lib/views/dashboard/widgets/current_outbound.dart
lib/views/dashboard/widgets/selection_notice.dart
test/views/dashboard/current_outbound_test.dart
test/views/dashboard/selection_notice_test.dart
```
