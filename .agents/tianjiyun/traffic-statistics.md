# 流量统计技术说明

本文件记录客户端流量统计的统计口径、核心采集点、本地持久化与上报契约。实现分布在
`core/traffic_accounting.go`、`lib/core/traffic/`（`service.dart`、`report.dart`、
`auth.dart`）和 `lib/views/dashboard/widgets/traffic_savings.dart`。

## 统计口径

只统计三类累计字节：

- `mainland-direct`：DIRECT 连接，且有明确的中国大陆目的地证据；
- `proxy`：出站链不是 DIRECT 的连接；
- `other-direct`：其余 DIRECT 连接。

“节省的代理流量”只等于 `mainland-direct`。`other-direct` 永不计入节省，未知 DIRECT
不会被当成大陆流量。

同时排除以下连接，双向都不计数：

- 私网、回环、链路本地、组播、未指定地址，包括 IPv4-mapped 私网；
- CGNAT `100.64.0.0/10`、保留段、基准测试段、文档段（如 `192.0.2.0/24`、
  `198.51.100.0/24`、`203.0.113.0/24`、`2001:db8::/32`）；
- `metadata.Type == INNER` 的内部探测；
- `localhost`、`.localhost`、`.local`、`.lan` 主机名。

## 保守的 CN 分类

只有以下证据之一才把 DIRECT 连接记为 `mainland-direct`：

1. `metadata.DstGeoIP` 含 `CN`（mihomo 已加载的 GeoIP 数据在规则匹配时写入的实际目的地证据）；
2. 命中规则恰好是 `GEOIP` 且 payload 为 `CN`；
3. 命中规则恰好是 `GEOSITE` 且分类为 `cn`、`china` 或 `geolocation-cn`（允许 `cn@ads`
   这类属性；以 `!` 开头的反向列表不算）。

不信任 RULE-SET 名称，不按域名后缀、关键词或 IP 段猜测大陆归属，也不做每连接的网络
地理查询。显式域名规则命中但没有上述证据的 DIRECT 连接会留在 `other-direct`，这是有意
的保守少计。

## TCP 与 UDP 采集

统计接在 mihomo tracker 的字节路径上，而不是轮询连接列表：

- TCP：`Read`、`ReadBuffer`、`UnwrapReader` 计数函数、`Write`、`WriteBuffer`、
  `UnwrapWriter` 计数函数；
- UDP：`ReadFrom`、`WaitReadFrom`、`WriteTo`；
- tracker 创建时传入的初始 upload/download 只计一次；
- 回调在 metadata 和 rule 确定之后、`manager.Join` 之前绑定，关闭后的晚到字节仍会进入
  回调；
- 所有路径都以 `pushToManager` 为闸门，与原生日志/统计行为一致。

分类在 tracker 创建时做一次，闭包只持有分类和累计器引用，不保留 tracker 表，也不依赖
事件监听器、请求列表、请求过滤或 `onlyStatisticsProxy`。

## 只统计接管流量

统计的是经过本应用 Core 的连接，不是整台设备的全部流量。未进入 Core 的系统流量、被其他
代理接管的流量、以及 Core 未转发的内容都不在统计内。卡片的“本设备”指本安装实例捕获到的
流量。

## 应用字节不是计费字节

计数是 mihomo 的应用层字节：缓冲写路径按 buffer 长度上报，即使底层写随后失败也按该长度
计入；初始 tracker 字节只计一次。它不是链路层或运营商计费字节，不能作为账单依据。

## 切换歧义窗口

当前 profile id 与订阅指纹构成本地作用域（local scope），不是服务器账号。profile 或凭证切换时：

- 读取一份新的 Core 快照，并把新作用域的 baseline/epoch 设为该快照，切换后的新流量立即
  开始累计；
- 上一次采样到切换之间的区间无法确定属于哪个作用域，直接丢弃，不记到旧作用域，也不记到
  新作用域；
- 如果切换读取失败，切换保持 pending，上传暂停，后续采样重试；
- 如果采样读取挂起期间 desired scope 已改变，该次快照被丢弃，由串行的 scope switch 建立
  新 baseline，避免旧快照记到旧作用域。

## UTC 日归属

按采样时刻的设备 UTC 日期归入当天记录。跨午夜时最多一个采样间隔会落到相邻日期，不做
拆分或回填。设备时钟回拨时按设备报告的日期写入。

## 采样、落盘与上报节奏

- 每 10 秒采样一次 Core 累计快照；
- 每 60 秒原子写一次本地 JSON 状态；
- 每 5 分钟尝试上报一次，带超时、失败后指数退避（10 分钟起，最长 1 小时）；
- 定时器和异步操作串行化，dispose 取消全部定时器；
- 启动、切 scope、采样、落盘、ACK 都经过同一串行队列；所有公开操作等待同一个 start future。

## 离线保留

本地状态保留最近 90 个 UTC 日，最多 512 条记录。加载时会丢弃：

- 超过保留窗口的记录；
- 未来日期记录；
- 负数或不完整记录。

被丢弃的待上报记录不会悄悄保留，属于有界存储下的明确丢失。状态 schema 损坏或版本未知时
fail closed：保留原值、不上报、不生成新的 installation id，避免制造重复的 fleet 总量。

## 上报协议与授权绑定

上报对支持的天机云订阅默认开启，不需要构建参数。客户端只从当前 profile 的订阅 URL 推导
端点，不再读取 `TRAFFIC_REPORT_URL`。仅以下精确主机被接受：

- 主站：`bslvn.divinations.top`、`vn3kq.divinations.top`、`sub1.tianjiyun.org`；
- 旧版 infra/sub-worker：`sub.nianyi.de5.net`、`sub.242.cc.cd`、`sub.262.cc.cd`。

只接受 HTTPS、无 userinfo、无 fragment、默认 443 端口的 URL。订阅凭证来自：

- `/s/<token>`，token 为 8..128 位 `[A-Za-z0-9_-]`，允许格式 query 参数，但不得附带另一个 token；纯数字 ID 不作为凭证；
- `/api/v1/client/subscribe?token=<token>`，要求恰好一个 token 参数。

本地 profile、非上述主机的订阅、文件/自定义 profile 一律不上报，也不会把 token 发往天机。
`scopeKey = sha256(installationId + '|scope|' + identityKey)` 的前 24 位，与本地统计的 scope
一致；identityKey 包含 profile id 和订阅凭证指纹。即使同一 profile 替换客户订阅，
也会切换本地作用域。旧作用域的待上报记录不会使用新凭证发送，保留到本地过期；
不推测重置前后的订阅凭证属于同一客户。原始 token 和 URL 不写入统计存储。

### 会话交换

同一 origin 下：

- `POST /s/tianji-traffic/session`，`Authorization: Subscription <token>`，请求体
  `{version:1, installation-id, scope-key}`；
- `POST /s/tianji-traffic/report`，`Authorization: Bearer <session>`。

会话 token 只按 `origin + installationId + scopeKey + 订阅 URL 指纹` 缓存在内存中，不落盘；
到达 900 秒有效期前 60 秒刷新。收到 401 时清除对应缓存，下一次上传重新交换。订阅 URL
或 token 轮换会改变指纹和缓存键；同一 profile id 的旧凭据不会被复用。profile 在认证
过程中改变时本次上传中止，不会把旧身份的记录挂到新身份下。重定向被禁用，HTTPS 严格；
会话响应校验版本、token 和 `expires-at`。

### 上报体与 ACK

请求体只含：

- 版本、installation id、发送时间；
- 每个 stream 的 `stream-id`、`day`、`scope-key`、单调 `revision`；
- 三类累计字节。

不包含域名、IP、URL、token、连接记录或历史。每批最多 64 个 stream、64 KiB。客户端只在
收到完整、版本为 1 且逐条匹配本批 `stream-id` 与发送 revision（允许服务端返回更高
的已存 revision）的 ACK 后才确认落盘；缺项、重复、格式错误或只有 2xx 状态而没有有效 ACK 都视为失败并重试。
ACK 只确认已发送的 revision；发送期间新采集的字节会推进 revision，不会被 ACK 丢弃。
发送失败、离线或超时保留待上报记录，按 10 分钟起、最长 1 小时退避重试。

上报只选择当前本地 scope 的待上报记录。授权器按捕获的 `scopeKey` 取 token，scope 在认证
过程中改变时本次发送中止，避免把 A profile 的记录挂在 B profile 的凭据下。

## 当前接入状态

客户端默认鉴权及上报、Xboard `TianjiClientTraffic` 插件、两个订阅 Worker 的精确 POST
入口和运营后台 `/client-traffic` 已在本地实现。服务端代码位于相邻 `tianjiv3` 仓库：
`deploy/xboard-plugins/TianjiClientTraffic/`；运营后台支持日期/用户筛选和按日 CSV。
统计来自客户端估算，不参与用户扣费或余额计算，接口故障与零上报分开显示。

**尚未部署生产或发布客户端安装包。** 上线须显式建统计表和订阅 token 索引、登记插件、
重载 Octane，再发布边缘入口及后台，最后发布包含 Core 补丁的客户端。
生产变更遵循相邻仓库 `AGENTS.md` 的逐项授权要求；安装与回滚见插件 README。
服务端部署前，上报失败会退避，本地统计和 UI 不受影响。

## 子模块特性补丁

精确的最终字节统计需要在 mihomo tracker 字节路径上增加一个可选回调，因此
`core/Clash.Meta` 使用自有 fork 的 `tianji-traffic` 分支，补丁提交 `a55c2656`：

- `tunnel/statistic/patch.go`：`TrafficAccount` 类型与 `NewTrafficAccount` 工厂；
- `tunnel/statistic/tracker.go`：构造时绑定回调，在 TCP/UDP 各字节路径调用，保留原生
  totals 不变。

补丁已推送到 `tianjicloud/Clash.Meta`，主仓库 gitlink 固定该提交，CI 可完整检出。

## 验证

已执行的针对性命令：

```bash
flutter pub get
dart run intl_utils:generate
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed lib test tool plugins setup.dart
flutter analyze --no-fatal-infos
flutter test test/core/traffic test/views/dashboard/traffic_savings_test.dart \
  test/models/config_test.dart test/l10n test/lint/dynamic_message_key_test.dart \
  test/core/protocol_contract_test.dart
flutter test test/views/dashboard test/lint test/core/service_test.dart
cd core && CGO_ENABLED=0 go test .
cd core && CGO_ENABLED=0 go vet . ./cmd/...
cd core && GOOS=android GOARCH=arm64 CGO_ENABLED=0 go vet -tags=with_gvisor . ./mobile ./tun ./platform
```

缺口：

- 本机未运行 Cargo 检查（本轮未改 Rust）；Windows Helper 的 `windows-service` 特性仍需要
  真实 Windows 环境验证；
- Flutter 测试期间临时把 `setup.build_assets` 和 `rust_api.build_assets` 置为 false，
  结束后已恢复原值；
- 最终计量测试使用内存 TCP/UDP 替身，无需启动监听端口或测试服务器；
- Android 真机上的后台/断连恢复、真实服务端 ACK 与授权交换尚未验证。

## 2026-11-07 独立复核结果

- 客户端整组检查覆盖 403 项；初次 402 项通过、1 项过期会话测试样例的时间写错。
  修正后相关 62 项全部通过，包括同一 profile 的 A→B→A 凭证切换、第三方订阅停报、
  ACK 完整性、会话缓存与续期、离线重试；其余已通过测试未受样例修正影响。
- Flutter 依赖解析、代码生成和相关格式检查已执行。测试临时关闭 native hooks，结束后恢复为 true。
- 服务端真实 Laravel HTTP Kernel + 隔离 SQLite 鉴权/幂等/整批回滚/多进程并发测试通过。
- 两个边缘入口分别 9 项和 7 项测试通过，含分块超限立即取消读取与订阅 GET 回归。
- 运营后台 110 项测试、类型检查和 Next.js 生产构建通过；Core 流量累计 race 检查通过。
- 本机缺 Cargo，未完成原生安装包构建和 Windows 实机验收；真实上线鉴权链路待部署后验收。
- 本轮未部署生产、未提交或推送；两个 OpenCode 实施进程已停止，没有保留监听端口。
