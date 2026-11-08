# V3 原稿还原复核

本轮基线：809d1fa2（v0.9.12）。用户明确允许放弃现有视觉风格，按 design-v3 原稿重做。此前 ACCEPTANCE.md 的视觉通过结论不适用于本轮。

实施：OpenCode Go / DeepSeek Flash 起稿，额度限制中断；经用户指定改由 Codex Luna 完成。Codex 主代理负责规格、审图与独立检查。

## 视觉复核记录

- 第一批实际 Flutter 完整 HomePage 截图：不通过。手机轨道偏左、场景文字被挤掉、已连接态指标被底栏遮挡；桌面模式/接管控件未靠右、重复运行时长。
- 第二轮至第四轮：修复居中、手机专用字号、主卡体量、导航外壳、卡片最小高度、桌面三卡底部对齐和右侧控件。1568×1024 桌面与390×844手机标准样本的主要层级、尺寸、位置与原稿对应。
- 1280×800整窗首屏已独立看图确认：普通线路样本的完整控制条在首屏内，底部约768；预览夹具另断言 NetworkTakeoverBlock 底边不超过800。长内容、放大字号或异常提示允许滚动。

## 保留的真实差异

- 截图使用明确的虚构测试数据；真实客户端始终读现有 provider。原稿的示意 IP、延迟、流量、健康勾、重置日期不写入产品。
- 沿用现有品牌图标资产，未替换平台图标。
- 手机导航保留已有真实目的地与用户配置，没有新增不存在的订单/个人中心业务；浮动导航外观按稿重做。
- 连接后显示真实 IP，状态详情可展开；断开与暂停按真实状态呈现，错误/未接管/出口校验提示保留。大字号、长线路名、异常提示允许增高和滚动。
- 有效期缺少套餐起始周期，保留天数/日期，不绘制假有效期比例。续费入口打开既有用户面板。
- 截图含测试框架角标；属于真实 Flutter widget 渲染验证，不代表 Windows/Android 实机运行和120Hz性能验收。

## 检查

Codex 独立检查完成：

- `flutter pub get` 成功，日志 `~/.cache/tianji-residential-ui/v3-fidelity-codex-pubget.log`。
- `flutter analyze --no-fatal-infos`：No issues found，日志 `v3-fidelity-codex-analyze.log`。
- `dart run tool/test.dart test/views/dashboard test/widgets test/lint test/pages/home_test.dart test/pages/business_navigation_test.dart test/l10n`：**1299 passed，0 failed**，日志 `v3-fidelity-codex-regression.log`。含真实选择、IP遮罩、详情可达、启停、导航键盘/点击、响应式与共享控件回归。
- 全仓 `dart format --output=none --set-exit-if-changed lib test tool plugins setup.dart`：1108 files，0 changed。独立检查曾发现5个生成本地化文件未格式化，已用 Dart formatter 统一，未手工修改生成内容。最终日志 `v3-fidelity-codex-format-final.log`。
- 完整 HomePage 渲染9场景通过（实施记录），独立审阅1568桌面、1280深/浅色、390连接/断开截图；320宽和大字号由相关布局测试覆盖。
- `git diff --check` 无输出。已自查diff，内核/子模块、凭据、provider业务、上报、版本/签名/发布配置、图标文件均无改动。ARB输出通过既有生成流程与formatter产生。
- 本地验证按仓库命令临时关闭原生构建hook，使用已有匹配Rust测试库，验证后pubspec两个build_assets均恢复true。未执行原生打包、Windows/Android实机或帧时间测量。
- 起过的端口已全部关闭，`devport mine`为空。OpenCode Go任务额度中断后已停止其登记进程；Luna阶段没有启动监听服务。

本地代码/布局回归通过，供用户做最终视觉与Windows实机验收。保留上述真实差异，不声明逐像素完全一致。实现验收时尚未提交或发布；用户随后批准继续，发布进度以 Git 标签和 GitHub Actions 为准。

## 测试断言调整说明

- 业务手机主卡将时长/速率收进展开区，因此时长测试先打开状态详情；断开后详情消失。新增IP隐藏偏好及点击IP打开质量详情覆盖。
- 质量徽章移动到详情后，原手机IP与住宅徽章垂直顺序断言改为紧凑呈现断言；未删除质量详情可达能力。
- 桌面接管控件改用NetworkTakeoverBlock，原布局测试查找类型同步更新，边界可见性断言继续保留。
- 新增业务导航测试（点击/键盘/底部避让/普通订阅回归）和选择事实测试（第5条/不存在/真实家宽出口与锁定别名共存）。

## 截图

缓存目录 `~/.cache/tianji-residential-ui/`，`v3-fidelity-` 前缀；文件清单见 FIDELITY-IMPLEMENTATION.md。数据为合成测试数据，不代表用户真实订阅。


## 最终变更文件

- `arb/intl_en.arb`
- `arb/intl_es.arb`
- `arb/intl_fr.arb`
- `arb/intl_ja.arb`
- `arb/intl_ko.arb`
- `arb/intl_ru.arb`
- `arb/intl_zh_CN.arb`
- `design-v3/FIDELITY-ACCEPTANCE.md`
- `design-v3/FIDELITY-IMPLEMENTATION.md`
- `design-v3/FIDELITY.md`
- `lib/l10n/intl/messages_en.dart`
- `lib/l10n/intl/messages_es.dart`
- `lib/l10n/intl/messages_fr.dart`
- `lib/l10n/intl/messages_ja.dart`
- `lib/l10n/intl/messages_ko.dart`
- `lib/l10n/intl/messages_ru.dart`
- `lib/l10n/intl/messages_zh_CN.dart`
- `lib/l10n/l10n.dart`
- `lib/manager/app_manager.dart`
- `lib/pages/home.dart`
- `lib/ui/business_style.dart`
- `lib/views/dashboard/business.dart`
- `lib/views/dashboard/business_theme.dart`
- `lib/views/dashboard/line_data.dart`
- `lib/views/dashboard/widgets/card.dart`
- `lib/views/dashboard/widgets/current_outbound.dart`
- `lib/views/dashboard/widgets/network_takeover.dart`
- `lib/views/dashboard/widgets/outbound_mode.dart`
- `lib/views/dashboard/widgets/profiles.dart`
- `lib/views/dashboard/widgets/quick_lines.dart`
- `lib/views/dashboard/widgets/scene_bar.dart`
- `lib/views/dashboard/widgets/segmented.dart`
- `lib/views/dashboard/widgets/traffic_savings.dart`
- `lib/widgets/business_navigation.dart`
- `test/pages/business_navigation_test.dart`
- `test/views/dashboard/business_layout_test.dart`
- `test/views/dashboard/current_outbound_test.dart`
- `test/views/dashboard/line_data_test.dart`

## 提交前整合

远端 276a2c4a 将代理卡片圆角由 AppCorner.xl（24）改为 lg（20），已快进保留。整合回归发现 test/widgets/proxies_list_test.dart 两处仍断言 xl；将其同步为 lg，保留展开、收起、吸顶与边界行为断言。这是已确定视觉变更的预期同步，不改变产品行为。

整合后完整回归：原1299项套件加 test/views/proxies_list_test.dart、test/views/proxies_group_offsets_test.dart，1304 passed，0 failed。日志：`~/.cache/tianji-residential-ui/v3-fidelity-release-regression-final.log`。提交前结构审查覆盖导航状态与路由边界、线路展示数据、仪表盘布局及共享样式，未发现阻断提交的结构问题。
