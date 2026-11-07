# WP2 第 0 步核查与冲突报告

核查基线：`tianjiyun-dev @ e3f2f7e5`（包含 WP1 与独立节点名修复）。
历史状态：基线测试通过后，发现规格与代码冲突，依总则第 2、3 条暂停相关实现。以下保留当时核查结论。

后续裁定：用户批准 C1–C3 的处理建议，远端规格提交 `556108fa` 已通过合并提交 `165d759d` 拉取。允许记录仅由手动动作写入的（组、节点、序号）、只校验默认路径上的组，并保留判定必需的探针链信息。WP2 已依此继续实施；本报告随第一笔 WP2 实现提交入库。最终交付与验证见 `WP2-DELIVERY.md`，不以本历史报告的暂停状态代替最终结果。

## 已核对的锚点

| 位置 | 实际结论 |
|---|---|
| `lib/providers/actions/proxies.dart:201` | `changeProxy` 存在，家宽拦截、乐观更新、失败回滚、成功后关闭或重置连接与规格一致。 |
| 同文件 `changeDefaultLine` | 上一轮节点名修复增加的独立切换路径，先改成员组再改根组；WP2 不能只覆盖 `changeProxy`。 |
| 同文件 `_rejectResidentialGroupChange` | 拒绝根组/锁定组改选并显示 banner；没有持久化“曾拒绝”状态。行为保持不变。 |
| `lib/core/residential.dart:249` | 锁定组、无效选择 REJECT、规则重写及 applied/missingExit 均存在。未修改。 |
| `lib/providers/outbound_ip.dart:21` | 原始结果有 chains；提供给 UI 的 ProbeAnswer 不保存 chains，仅保存值、epoch/version、hits，并用出口名建立别名结果。 |
| `lib/providers/routed_probe.dart` | watch/unwatch、settle/throttle、refresh 均存在。refresh 是用户主动刷新，明确跳过节流，不能声称直接调用它就是复用节流。 |
| `lib/providers/route_state.dart` | isFresh 同时检查 coreEpoch、routeVersion、hostEpoch、proxied 和 synced。不能只比较两个计数器。 |
| `lib/views/dashboard/probe_start_hold.dart` | 启动失败显示 probing 的五秒保持存在。 |
| `lib/providers/actions/setup.dart:343` | updateConfig 只发送 UpdateParams；与“配置重组装入口”的描述冲突，见下表。 |
| `lib/views/dashboard/widgets/network_takeover.dart:72` | 系统代理和 TUN 的设置读数与规格一致；设置值本身不是操作系统接管成功的证明。 |
| `lib/providers/residential.dart:36` | 根据当前 profile、目录归属和 groups 构造策略，存在 catalogReady 判断。 |
| `arb/intl_zh_CN.arb:1142`、`:1146` | 失效阻断与服务端替代出口说明存在；文案本身不能证明具体目标被服务端替代。 |
| `lib/views/dashboard/widgets/current_outbound.dart:36` | watch/unwatch 默认路径，读取探针条目，支持现有手动刷新。 |

## 需要裁定的冲突

### C1 配置组装入口

- 规格：`SetupAction.updateConfig()` 是配置重组装下发路径。
- 代码：该方法仅热更新参数；分组与规则在 `getProfile()`（508 行）→ `makeRealProfileTask()` → `_makeRealProfileTask()` 组装。普通订阅还存在 base + overlay 优化，不可假定 rawConfig 包含完整组定义。
- 建议：更正锚点，批准在实际 apply/getProfile/task 链路实现本地手动覆写，并审查 base/overlay 兼容路径。保留 updateConfig 的热更新职责。
- 处理：暂停手动覆写实现，未修改任何配置行为。

### C2 “最后一次手动选择”与默认路径不等价

- 规格：以已选映射现值取得最后一次手动选择的（组、节点），并比较默认路径出口。
- 代码：`Profile.selectedMap` 只有每组当前值；`ProfilesAction.updateCurrentSelectedMap()` 更新已有键不会记录选择时间或最后选择组。`selectedProxyNameProvider` 还可能回退到组的当前值。切换独立业务组也不改变根组指向。
- 影响：用户在不属于默认路径的业务组选择节点，不能据此判定首页默认出口错误。把该组强行变成默认路径又违反“其余组与规则一字不动”。
- 建议：手动优先作用于被选组；首页仅校验默认路径上的明确手动选择。新增独立的手动选择事实记录，不从 Map 顺序猜最后选择；旧配置不补造历史事实。非默认业务组不与首页探针比较。
- 处理：暂停依赖选择事实的校验状态机和错误文案接入，等待上述产品口径裁定。

### C3 原始链信息没有保留到 UI 状态

- 规格依赖 `chains.firstOrNull` 判定；原始查询确有该字段，但现有 ProbeAnswer/ProbeEntry 没有它。
- 建议：在 Dart 探针结果中显式保留所需出口信息，并与同一结果的 epoch/version 一起失效；不通过缓存别名倒推，也不修改内核协议。
- 处理：记录为实现前的数据接入差异，与 C2 一并确认后实施。现有 hits 也需核对其与原始首跳的等价性，不能直接假定。

服务端替代出口标注及完整自动组机制尚未完成核查；未使用客户订阅、未查询客户凭据。不能把此项写成“不存在标注”或“所有组可覆写”的结论。

## 基线测试

实际执行（Flutter 3.47.6，使用本地 verify.py 临时关闭 native build_assets hooks，执行后原样恢复 pubspec）：

```sh
flutter test test/views/dashboard/ test/providers/proxies_action_test.dart test/providers/setup_action_test.dart test/providers/setup_state_test.dart test/providers/default_line_action_test.dart test/providers/residential_setup_test.dart test/providers/outbound_ip_test.dart test/providers/routed_probe_test.dart --reporter expanded
```

结果：`00:29 +374: All tests passed!`，374 通过、0 失败。
日志：`/home/nianyi778/.cache/tianji-residential-ui/wp2-baseline.log`。
这些是 Dart/Flutter 基线测试，不包含 Go/Rust 编译或真实网络验收；本机缺少 cargo。

## 变更与验收状态

- 本轮仅新增本核查报告，暂无 WP2 实现提交；未更改现有测试预期。
- 第 0 步未宣告全部完成：冲突裁定、服务端标注与自动组核查待续。
- 未执行 WP2 最终 analyze、手工场景或新增状态机测试，因为尚未实施 WP2。
- 已自查 diff，未触碰禁区 B1–B7；未推送、未打 tag、未发版。
- 未启动监听服务；交付前检查 devport，端口收尾结果以本轮回复为准。
