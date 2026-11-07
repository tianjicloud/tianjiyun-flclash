# WP3 第 0 步核查（含用户补充后的复核）

核查基线：`tianjiyun-dev @ c0befb08`，包含 WP2 已交付的本地提交。
本文件仅记录只读核查，不代表 WP3 已实现。WP2 Windows 实机验收缺口仍见
`WP2-DELIVERY.md`。

## 已确认的源码锚点

| 锚点 | 实测结论 |
| --- | --- |
| `lib/core/residential.dart:50` `ResidentialGraph` | 从配置建立组成员与代理类型图；没有大带宽业务角色字段。 |
| 同文件 `safeGroup` / `isProxyTarget` | 分别判断安全代理成员与代理目标，不能证明一个组是大带宽普通组。 |
| 同文件 `applyResidentialEgress:249` | 合法家宽选择形成单成员锁定组；无效选择形成 REJECT。强制 rule 模式。 |
| 同文件 `_rewriteRules:306` / `_rewriteRule` | 所有代理目标改写至锁定组；DIRECT 等非代理目标保持原样；同时处理 sub-rules，SUB-RULE 跳转本身保留。没有现成大流量例外。 |
| `lib/providers/actions/setup.dart:526` `getProfile` | 最终配置组装入口；584 行调用 `makeRealProfileTask`。不能只在上层 updateConfig 插入未经核对的变换。 |
| `lib/common/task.dart:386–396` | 普通路径应用手动选择覆写；家宽路径随后调用家宽变换并编码最终配置。 |
| `lib/views/dashboard/business.dart:366` | `ResidentialExitCard` 消费真实家宽策略；384 行使用既有 residentialExplanation。 |
| 同文件 `_ResidentialExitSheet:595` | 复用 SelectionSheet，数据为 policy.choices；没有绕行明示。 |
| `arb/intl_zh_CN.arb:1146` | 既有说明仍为“需要代理的流量都会使用所选家宽线路”；功能未实现前不能改成已绕行承诺。 |

## 基线测试

运行命令：

```sh
python3 /home/nianyi778/.cache/tianji-residential-ui/verify.py \
  flutter test test/core/ test/views/dashboard/ --reporter expanded
```

结果：**502 项通过，1 处 setUpAll 失败，退出码 1**，不是全绿。
失败位置为 `test/core/desktop/ipc_native_test.dart` 的原生库初始化：

```text
Bad state: Editor native library not found;
tried build/native_assets/linux/librust_api.so, .dart_tool/lib/librust_api.so
```

本机 PATH 未找到 cargo / rustc。临时验证脚本关闭原生 build_assets hook，运行后恢复
pubspec.yaml 原字节；没有将该开关变更留在仓库。它能验证 Dart/Flutter 套件，不能代替原生
IPC 测试。没有删除测试、修改断言或将失败算作跳过通过。

完整日志留在本机：
`/home/nianyi778/.cache/tianji-residential-ui/wp3-baseline.log`。

## 首轮缺口与处理（历史记录，复核结果见下文）

1. **主力测试订阅未核验。** 仓库检索只找到合成测试配置，尚未取得当前主力测试订阅的
   完整配置。不能据此断言服务端没有视频分流规则。已请求专用测试订阅或脱敏完整配置的
   本地路径，不索取客户订阅链接或令牌。
2. **大带宽组认定依据缺失。** 图结构只能回答成员关系，不能推导带宽与套餐角色。
   现有合成配置还包含同时可达普通节点和家宽根组的混合组，因此“不是家宽根组”的组名
   不能充当大带宽证明。待服务端明确组名或角色标记，再核查该组及其可达成员。
3. **基线不满足全绿要求。** 原生 IPC 初始化失败如上。按规格总则第 0 步要求报告，
   本轮不进入实现；也不擅自削减基线套件。

以上是未完成的验收前置条件，并非已证实订阅缺少某字段。源码锚点可定位，没有把更新后的
行号差异视作业务冲突。WP3 明确允许的向后兼容跳过名单例外保留，不将它与一般 B6 禁区
重复解读为必须重新授权；但任何后续实现仍须证明锁定与 REJECT 语义不变。

## 规则顺序的核查结论

- 当前家宽变换会改写已有视频代理规则。即使服务端提供等价分流，也需要在家宽变换中
  明确保留；“不注入兜底规则”不等于当前代码已保留服务端出口。
- 简单把域名规则插到列表最前，可能抢在原有 DIRECT 规则前命中；放在 MATCH 后又不能
  生效。仅断言 DIRECT 规则文本不变不足以证明直连判定不变。
- 因此，注入位置、已有等价规则判定、大带宽组认定都尚未定案。需用测试订阅实际规则与
  sub-rules 验证后再实现，不在缺证据时先写猜测性的变换。
- 域名名单仍为规格草案；未核实 CDN 不补写，需用户确认的可选类别也未擅自纳入。

## 首轮只读核查自查（历史记录）

- 仅新增本核查报告，尚未提交；没有 WP3 实现提交。
- 已自查 diff，未触碰禁区 B1–B7；没有改变路由、文案、图标、版本、工作流或生成文件。
- 未运行 WP3 实现后的 analyze / 手工联网验收，因为尚未开始实现。
- 未启动监听服务；`devport mine` 登记为空，起过的端口已全部关闭。

继续实现前需取得测试配置及大带宽组依据，并解决或由用户明确裁定原生测试环境缺口。


## 用户补充后的复核与开工结论

用户提供专用测试订阅并授权测试；随后明确批准使用「⚡ 自动选择」作为视频／大下载出口。
这里只记录结构证据，不记录链接、令牌、原始 IP 或节点连接凭据。

- HTTP 200，YAML 解析成功：54 个组、122 个代理、1919 条规则，35 个可选家宽组。
- 家宽可达 69 个底层代理；「⚡ 自动选择」为 url-test，含 52 个静态代理，全部是已声明代理，
  与家宽可达集合零重叠；「📍 指定节点」则包含全部 69 个家宽代理，不能作为绕行出口。
- YouTube / Netflix / googlevideo 指向总入口；没有指向获批普通组的等价视频规则。
  下载相关 Windows / Microsoft / Apple 域名已有 DIRECT 规则；全配置含 94 条字面 DIRECT。
- 该配置无 rule-providers / sub-rules，规则类型为 DOMAIN、DOMAIN-SUFFIX、DOMAIN-KEYWORD、
  IP-CIDR、IP-CIDR6、GEOIP、MATCH。不能将这个结论外推到其他套餐。
- Rust 并非未安装：`~/.cargo/bin/cargo` 和 `rustc` 均可用，只是原 PATH 未包含。
  使用现有工具链在仓库外编译 rust_api，随后指定
  `FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR` 重跑原命令：**505 通过，0 失败**。
  原生 IPC 用例实际执行；没有减少套件。日志：`wp3-baseline-native.log`。
- 配置实测的 3 项既有行为检查通过：35 个家宽选择可用；视频 / AI 被锁定且 DIRECT 保留；
  无效选择仍为 REJECT。这些是本机配置测试，不是 Windows 出口实测。

开工依据：本测试订阅、普通出口组用户裁定、505 项全绿基线均已齐备。
带宽等级本身没有可读字段，组角色采用本次用户裁定，成员排除家宽则每次按图验证。

实现定案：在家宽变换结果上增加范围严格受限的规则，不改 `lib/core/residential.dart`。
只在原代理规则的位置插入“原条件且命中名单”的普通出口规则；DIRECT 保持顶层原顺序与类型，
确保流量分类仍能读取原规则证据。未命中名单回落原家宽规则；家宽无效选择时不注入。

保守停工范围：外部 RULE-SET 与已有 SUB-RULE 模板缺少本次实测样本及等价规则识别契约，
不猜测其内容，不注入兜底。未知组、动态成员、混合家宽成员同样不注入，界面不承诺已绕行。
这部分仍需另提供相应测试配置后复核；不影响本次已验证模板的实现。
