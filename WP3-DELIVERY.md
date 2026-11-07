# WP3 交付说明

状态：已实现并本地提交，当前测试订阅的配置与内核规则匹配验证通过；**尚未完成 Windows 实机联网验收**。
未推送、未打 tag、未打包或发布。起点为 `c0befb08`；第 0 步证据与首次失败的处理见
[WP3-AUDIT.md](WP3-AUDIT.md)。WP2 的 Windows 验收缺口没有被本报告消除。

## 实现行为

- 仅在有效家宽选择生效的配置组装路径运行；普通订阅路由不变。
- 用户已确认「⚡ 自动选择」为视频／大下载出口。每次组装验证它仍是静态可达的 url-test 组，
  全部成员是安全代理且与家宽可达集合不相交；不是凭“自动”字样猜测带宽等级。
- 命中草案名单的代理目标通过隐藏单成员组「🎬 天机大流量」到达普通自动线路；
  不改家宽根组、锁定组或选择失败的 REJECT。失效家宽选择不启用绕行。
- 在原代理规则的位置插入原条件与名单的交集，未命中则继续原家宽规则。
  已完全落在名单内的 DOMAIN / DOMAIN-SUFFIX 直接使用普通目标；不相交的域名规则不加 guard。
  不将视频规则整体前置，也不包装 DIRECT，保留直连顺序和原规则类型供流量分类使用。
- 明确匹配名单、指向获批普通组的订阅 DOMAIN / DOMAIN-SUFFIX 规则优先保留，存在时不注入
  客户端兜底；这条识别范围外的规则集支持仍有缺口，见下文。
- 家宽卡与选择 sheet 从已加载配置中的绕行组读取状态，确认启用才显示绕行说明；
  未确认时如实提醒视频／下载可能占家宽流量，不把失败当成功。
- `residentialExplanation` 去掉“都会使用”的绝对表述，保留大陆直连与服务端替代出口说明。
- 产品优先级保持用户裁定：名单内大流量绕行高于普通分组的手动指向家宽；默认路径探针
  不在名单内，WP2 的校验对象未改为视频请求。

## 测试与生成记录

### 基线

`flutter test test/core/ test/views/dashboard/ --reporter expanded`：首次 502 通过、1 处原生库初始化失败；
补建现有 rust_api 并指定动态库目录后，**505 通过、0 失败**，发生在实现前。

构建使用现有 `~/.cargo/bin/cargo` / `rustc`，目标产物位于仓库外缓存；Rust/Go 源码没有修改。
测试仍由临时 verify.py 关闭自动原生构建 hook，结束恢复 pubspec 原字节；Rust IPC 测试使用
实际编译的动态库。未运行完整桌面应用构建，不以此宣称原生发布构建通过。

### 最终验证

- `flutter pub get` 成功（generate 流程与最终分析均完成依赖解析）。
- `dart run build_runner build` 与 `dart run intl_utils:generate` 成功；生成文件仅通过工具输出。
- `flutter analyze --no-fatal-infos`：**No issues found，3.7 秒**。
- `dart format --output=none --set-exit-if-changed lib test tool plugins setup.dart`：**1092 文件，0 改动**。
- 完整回归 **894 通过、0 失败**；包含 core、dashboard、lint、l10n 及 WP2 的相关 provider/model/common 套件。
- 真实测试订阅另跑 **5 项通过**：现状行为、绕行变换、94 条 DIRECT 保留、遍历全部 35 个家宽
  选择的单成员锁定、失效选择 REJECT。该配置含凭据，因此样本与临时用例未入仓。
- 本地 Go 程序调用当前 Mihomo `ParseRule` / `Match`：1968 条生成规则解析成功；11 个视频、
  AI、直连、普通网页场景通过。使用受控 metadata，不连接节点、不请求 AI、不测服务吞吐。
- 扩充 AI 核查：12 个域名 × 2 种目的地国家输入 × 2 种选择状态，共 **48 个匹配检查通过**。
  有效选择均指向家宽锁定组，无效选择仍指向 REJECT 所在的锁定组。国家输入是测试数据，
  不代表这些服务实际 IP 所在地。
- `git diff --check` 通过。既有测试断言未改；新增 business 测试覆盖已启用／未确认／未选家宽呈现。
  中途英文文案导致既有断言失败，恢复既有“service-side alternative exit”措辞后回归全绿，未放宽断言。

最终回归命令（通过 verify.py 调用，并设置原生库目录）：

```sh
flutter test test/core/ test/views/dashboard/ \
  test/providers/proxies_action_test.dart test/providers/setup_action_test.dart \
  test/providers/setup_state_test.dart test/providers/default_line_action_test.dart \
  test/providers/residential_setup_test.dart test/providers/outbound_ip_test.dart \
  test/providers/routed_probe_test.dart test/providers/selection_verification_test.dart \
  test/providers/selection_check_test.dart test/providers/manual_selection_action_test.dart \
  test/lint/ test/l10n/ test/models/config_test.dart test/models/profile_test.dart \
  test/models/profile_save_test.dart test/providers/profiles_action_test.dart \
  test/common/default_line_test.dart test/common/task_test.dart \
  test/common/residential_test.dart --reporter expanded
```

本地日志在 `~/.cache/tianji-residential-ui/`：`wp3-baseline-native.log`、`wp3-final-tests.log`、
`wp3-final-analyze.log`、`wp3-ai-test.log`。日志不含用户订阅令牌或客户原始 IP。

### AI 覆盖范围

| 服务 | 已测域名 |
| --- | --- |
| ChatGPT | chatgpt.com、api.openai.com、auth.openai.com |
| Claude / Claude Code | claude.ai、api.anthropic.com、console.anthropic.com |
| Gemini / Code Assist | gemini.google.com、generativelanguage.googleapis.com、cloudcode-pa.googleapis.com |
| Grok | grok.com、api.x.ai、x.ai |

API 与 Code Assist 域名核对来源：[Claude API](https://platform.claude.com/docs/en/api/overview)、
[Claude Code 网络配置](https://docs.anthropic.com/en/docs/claude-code/corporate-proxy)、
[Gemini API](https://ai.google.dev/api)、
[Code Assist 配置](https://docs.cloud.google.com/gemini/docs/codeassist/set-up-gemini)、
[xAI API](https://docs.x.ai/developers/rest-api-reference/inference)。
这不覆盖客户自定义 API 中转地址、第三方云端模型入口，也不证明账号可用性或真实出口 IP。

## 手工验收清单

- [x] 测试订阅获取、结构核查，普通组角色用户确认。
- [x] 实际规则列表在 Mihomo 匹配器里验证视频、AI、大陆直连及普通海外目标。
- [x] 自动化 widget 测试覆盖绕行说明出现与隐藏；现有 dashboard 布局测试通过。
- [ ] Windows 上播放 YouTube 视频并观察请求页实际出站链。
- [ ] Windows 上实际调用上述 AI，确认走所选家宽的真实出口。
- [ ] Windows 上真实大陆网页直连与视频同时运行，核对连接列表和统计。
- [ ] Windows 家宽选择失效、订阅刷新、切回按订阅分流的联网验收。

## 冲突、限制与待复核

- 已解决：最初缺少测试订阅、普通组认定与原生测试环境，处理见核查报告。
- **部分停工：含外部 RULE-SET 或既有 SUB-RULE 的模板未核验**，不能证明是否已有等价分流，
  本轮不注入、不宣称支持；仍按原家宽变换运行，界面显示未确认。需要相应测试配置与规则集
  识别依据后继续。未知、混合家宽、动态 provider 或无法证明安全的普通组同样不注入。
- 订阅优先判定目前只覆盖名单内 DOMAIN / DOMAIN-SUFFIX 到获批普通组的显式规则，
  不把不同规则表达式或其他组名猜作等价。此范围外不能宣称达到 WP3 全模板支持。
- 名单是规格授权的**草案**，没有扩写未经核实的 HBO / Apple / Steam CDN；未加入待确认的
  Prime Video、Apple TV+、Spotify，也未加入 AI、运营站点或泛 CDN。
- 非家宽路径零注入；家宽缺失选择仍 REJECT。大流量绕行不改变大陆直连统计三分类。
- 运行时规则匹配验证不等于真实网络路径或出口测量；测试没有登录或付费调用任何 AI。
- WP3 未满足全部实机验收，不能按本报告宣布已发布或用户端已升级。

## 草案域名全表

youtube.com、googlevideo.com、ytimg.com、youtube-nocookie.com、netflix.com、nflxvideo.net、nflximg.net、nflxso.net、tiktok.com、tiktokcdn.com、byteoversea.com、ibytedtos.com、disneyplus.com、dssott.com、bamgrid.com、max.com、hbo.com、hbomax.com、twitch.tv、ttvnw.net、vimeo.com、dailymotion.com、steamcontent.com、steamstatic.com、download.microsoft.com、windowsupdate.com、mesu.apple.com。


## 提交与文件

### a258c725 feat(residential): bypass bulk traffic through verified ordinary routes

- `WP3-AUDIT.md`
- `lib/common/task.dart`
- `lib/core/residential_bulk.dart`
- `test/core/residential_bulk_test.dart`

### 33466515 feat(dashboard): show confirmed residential bulk bypass status

- `arb/intl_en.arb`
- `arb/intl_es.arb`
- `arb/intl_fr.arb`
- `arb/intl_ja.arb`
- `arb/intl_ko.arb`
- `arb/intl_ru.arb`
- `arb/intl_zh_CN.arb`
- `lib/common/residential.dart`
- `lib/l10n/intl/messages_en.dart`
- `lib/l10n/intl/messages_es.dart`
- `lib/l10n/intl/messages_fr.dart`
- `lib/l10n/intl/messages_ja.dart`
- `lib/l10n/intl/messages_ko.dart`
- `lib/l10n/intl/messages_ru.dart`
- `lib/l10n/intl/messages_zh_CN.dart`
- `lib/l10n/l10n.dart`
- `lib/views/dashboard/business.dart`
- `test/views/dashboard/business_test.dart`

## 结构与禁区自查

审查范围：最终绕行纯函数、配置组装接入、家宽策略呈现状态与界面消费。没有新增采集、
轮询、持久化选择或生命周期所有者；变换继续在既有配置 isolate 中运行。
无需要暂停提交的结构问题；保留独立规则解析小段，避免为共用它去改 B6 禁区核心。

上游共用文件仅 `lib/common/task.dart` 增加家宽分支后的变换调用；理由是该处持有完整最终配置，
与已核验的 getProfile → makeRealProfileTask 链路一致。其余变更集中在天机云业务层与本地化输出。

已自查全部提交 diff，未触碰禁区 B1–B7。`lib/core/residential.dart` 零改动；Go 与子模块零改动；
订阅解析、凭据处理、上报契约、既有三份天机云文档、版本、签名、图标、发布工作流均未改动。
l10n 输出由生成器产生并自动格式化，无手工修改生成文件。

未启动监听服务；`devport mine` 为空，起过的端口已全部关闭。
