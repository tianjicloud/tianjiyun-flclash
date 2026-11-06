# 首次导入与连接引导（规格）

目标：没有任何订阅的新用户，打开 App 后三步连上：导入订阅 → 连接 → 确认能上外网。
不做账号登录。界面参照已确认的原型（欢迎页、确认导入、导入中、已导入、VPN 授权说明、连接中、已连接、失败页）。

## 范围

- 新增：欢迎/引导流程（`lib/views/onboarding/`）、引导状态（`lib/providers/onboarding.dart`）、
  失败归类与展示用纯函数（`lib/common/onboarding.dart`）、文案（7 个 ARB）、测试。
- 改动：`HomePage` 在需要时显示引导；`ProfilesAction` 增加一个不弹窗、不跳页的导入方法；
  `application.dart` 的一键导入链接在「没有订阅」时走引导流程。
- 不改：老用户的「配置」页、首页仪表盘、现有的导入方式（链接/文件/二维码/从手机发送）及其行为。

## 什么时候显示引导

- 订阅列表为空时，`HomePage` 不显示导航和仪表盘，整页显示引导流程。
- 导入成功后订阅列表就不空了，但引导要继续走完（已导入 → 连接 → 已连接），
  所以显示条件是「订阅列表为空 **或** 引导流程正在进行」。
- 用户在「已连接」页点「完成」，或在「已导入」页点「暂不连接」后，引导结束，回到正常首页。
- 引导状态只存在内存里（不持久化）：中途退出 App，下次打开若已有订阅，就直接是正常首页。

## 引导状态

`lib/providers/onboarding.dart`，`@Riverpod(keepAlive: true)`，状态是一个 sealed class 或 enum + 数据：

| 阶段 | 页面 | 进入方式 |
|---|---|---|
| `welcome` | 欢迎页 | 默认 |
| `confirm(url)` | 确认导入 | 粘贴/扫码拿到候选链接 |
| `importing` | 导入中 | 点「导入」或一键导入链接 |
| `imported(profileId)` | 已导入 | 导入成功且节点数 > 0 |
| `failed(ImportFailure)` | 失败页 | 导入失败，见下文 |
| `connecting` | 连接中 | 点「连接」（安卓先过授权说明） |
| `connected` | 已连接 | 连接成功；连通验证结果见下文 |
| `done` | —（回到首页） | 点「完成」或「暂不连接」 |

## 各页面

文案以原型为准（中文），其它语言给出对应翻译。颜色用主题色（品牌主色已是 `#0A55F5`），不要写死颜色值；
图标用项目已有的 `GlyphIcon` / `AppGlyphs`，没有的才用简单矢量绘制。

1. **欢迎页**：logo（`assets/images/icon.png`）、标题「导入订阅，马上开始」、说明一行；
   主按钮「从剪贴板粘贴订阅链接」，次按钮「扫描面板上的二维码」（仅在支持扫码的平台显示，与现有 `addProfileFormQrCode` 的平台判断一致）；
   一行隐私说明「只在你点按钮时读取剪贴板。订阅链接只保存在这台设备上。」；
   底部「还没有订阅地址？打开用户面板复制 ›」，打开 `https://panel.tianjiyun.org`（新增常量 `userPanelUrl`）。
   - 点粘贴：`Clipboard.getData('text/plain')`。**只在点击时读取，绝不在启动或回到前台时自动读。**
     取出的文本去空白；不是 `http`/`https` 链接，也不是 `clash://`/`clashmeta://`/`tianji://` 的 `install-config` 链接，
     直接进 `failed(notSubscription)`；`install-config` 链接先解出 `url` 参数（复用 `link.dart` 的解析逻辑，必要时把它提成公开函数）。
   - 剪贴板为空：用现有的提示方式（toast/snackbar）说「剪贴板里没有内容」，留在欢迎页。
2. **确认导入**：显示「天机云订阅」和打码后的链接：只显示 scheme 和路径的第一段，其余用 `••••••` 代替
   （例：`https://••••••/s/••••••••`）；说明「链接里含有你的订阅凭证，这里只显示一部分。」；按钮「导入」「取消」。
3. **导入中**：转圈 +「正在获取订阅…」「读取节点列表和套餐信息」。
4. **已导入**：「已导入 · N 个节点」；套餐卡片：剩余流量（`total - upload - download`，带进度条）、到期时间（`expire`，秒级时间戳，显示 `yyyy-MM-dd`）。
   **`total == 0` 就不显示流量行，`expire == 0` 就不显示到期行，两个都没有就不显示整张卡片**（取不到就不显示，不许编）。
   大按钮「连接」，下方文字按钮「暂不连接」。
5. **VPN 授权说明（仅安卓）**：底部弹层，标题「需要一次系统授权」，正文「接下来系统会询问是否允许天机云创建 VPN 连接，请点『确定』。只需要授权这一次。」；
   按钮「继续」→ 进入连接；「暂不连接」→ 关闭弹层。已经授权过 VPN 的设备不必再显示这层（若现有代码能判断授权状态就用它，判断不了就每次都显示，不要为此新增原生代码）。
   桌面端点「连接」直接进入连接。
6. **连接中**：转圈 +「正在连接…」「连上后会实际访问一次外网来确认」。
   调 `ref.read(setupActionProvider.notifier).setRunning(true)`；返回 `false` 回到「已导入」并用现有提示方式报错。
7. **已连接**：用 `outboundIpProbeProvider`（用法照 `lib/views/dashboard/widgets/current_outbound.dart`）确认外网与出口：
   - 探测成功：大对勾 +「已连接」；「出口」显示国家/城市（取探测结果里已有的地理信息，取不到就不显示这一行）；「外网访问 · 已验证可用」。
   - 探测失败（`ProbePhase.failed`，并且超过 `probe_start_hold.dart` 的 5 秒宽限期）：警告图标 +「已连接，但上不了外网」+「当前节点可能暂时不可用。换一个节点通常就能解决。」，
     按钮「换一个节点」→ 跳到正常首页的「代理」页并结束引导；不要自己实现自动换节点。
   - 探测中：保持「正在确认外网…」，不要提前显示成功。
   按钮「完成」→ `done`。

## 导入与失败归类

在 `ProfilesAction` 新增 `Future<Profile> importForOnboarding(String url)`：
用 `Profile.normal(url: url)` + 现有 `_download` 下载校验，`putProfile` 保存，并设为当前订阅（照现有添加后选中的逻辑）；
**不调用 `_showProfiles()`、不弹 loading、不弹错误框**，异常原样抛出交给引导处理。导入成功后用 `CoreController.readConfig(profile.id)` 读出 `proxies` 数量。

失败归类放在 `lib/common/onboarding.dart` 的纯函数 `ImportFailure classifyImportError(Object error)`，可单元测试：

| 归类 | 判定 | 标题 / 说明 | 主按钮 | 次按钮 |
|---|---|---|---|---|
| `expired` | `DioException` 且状态码 401、403、404 | 订阅链接已失效 / 可能是在面板里重置过订阅。请到用户面板重新复制订阅地址，再回来粘贴。 | 打开用户面板 | 重新粘贴 |
| `unreachable` | `DioException` 的连接错误、各类超时，或状态码 ≥ 500 | 暂时连不上订阅地址 / 可能是当前网络限制了这个域名。状态页上有备用地址，也可以稍后再试。 | 查看备用地址（`https://status.tianjiyun.org`，新增常量 `statusPageUrl`） | 重试 |
| `empty` | 导入成功但节点数为 0 | 订阅里没有可用节点 / 套餐可能已到期，或本月流量已用完。续费或重置流量后，回来点「重试」。 | 打开用户面板 | 重试 |
| `notSubscription` | 不是链接；或校验失败抛出的 `MessageException`；或返回内容是 HTML | 这不是订阅链接 / 请在用户面板点「复制订阅地址」，再回来粘贴。 | 打开用户面板 | 重新粘贴 |
| `unknown` | 其它 | 导入没有成功 / 请检查网络后重试。 | 重试 | 重新粘贴 |

`empty` 时已保存的订阅要删除（用现有删除方法），以免用户看到一个空订阅。

## 一键导入链接

`application.dart` 的 `_initLink`：当前订阅列表为空时，不弹现有确认框，改为让引导进入 `confirm(url)`；有订阅时行为完全不变。

## 红线

- **订阅链接不进日志**：引导相关代码不得 `print`/`commonPrint` 链接或含链接的异常文本；界面上只显示打码后的链接。
- 取不到的数据不显示，不写示例值。
- 不新增网络请求（除了订阅下载本身和现有的出口探测）、不新增遥测、不新增原生代码。

## 验收

- `dart run intl_utils:generate` 后 `dart format lib test tool plugins setup.dart`，
  `dart format --output=none --set-exit-if-changed lib test tool plugins setup.dart` 通过。
- `flutter analyze --no-fatal-infos` 无问题；`flutter test` 全部通过。
- 新增测试：`classifyImportError` 每一行；链接打码；剩余流量/到期的显示与隐藏（0 值不显示）；
  `HomePage` 在订阅为空时显示欢迎页、引导结束后显示正常首页；欢迎页粘贴非链接文本进入 `notSubscription`。
