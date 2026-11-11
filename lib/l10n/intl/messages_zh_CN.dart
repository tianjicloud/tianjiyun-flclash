// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(count) => "已选 ${count}";

  static String m1(name) => "已将 ${name} 添加到本地代理";

  static String m2(name) => "本地代理中已有 ${name}";

  static String m3(count, skipped) => "将添加 ${count} 项，跳过 ${skipped} 项已存在";

  static String m4(time) => "${time} 检测";

  static String m5(line) => "将从「${line}」出去";

  static String m6(name, status) => "当前：${name} · ${status}";

  static String m7(name, ip) => "所选「${name}」与实际出口 ${ip} 一致";

  static String m8(date) => "${date} 到期";

  static String m9(month, day) => "${month} 月 ${day} 日";

  static String m10(date) => "套餐 ${date}到期，续费后线路不中断";

  static String m11(value) => "倍率 ${value}×";

  static String m12(days) => "已过期 ${days} 天";

  static String m13(date) => "这个套餐已于 ${date} 到期。续费后可以重新校验同一订阅链接。";

  static String m14(step, total) => "第 ${step} 步，共 ${total} 步 · 校验订阅";

  static String m15(count) => "已勾选 · ${count}";

  static String m16(count) => "已选 ${count} 个应用";

  static String m17(name) => "家宽分组已锁定到「${name}」，在家宽线路里更换。";

  static String m18(time) => "订阅更新于 ${time}";

  static String m19(count) => "${count} 个应用";

  static String m20(count) => "${count} 项通过";

  static String m21(count) => "${count} 条";

  static String m22(version) => "发现新版本 ${version}";

  static String m23(percent) => "已用 ${percent}%";

  static String m24(count) => "Wi-Fi 规则 ${count} 条";

  static String m25(detail) => "清除数据失败：${detail}";

  static String m26(count, download, upload) =>
      "共 ${count} 条连接 · 下载 ${download} · 上传 ${upload} · 选中一行可查看完整链路与命中规则";

  static String m27(code) =>
      "Windows 拒绝运行 TianjiCloudCore.exe（错误 ${code}）。智能应用控制、AppLocker 等应用控制策略会拦截未签名程序，请在该策略中放行天机云或关闭策略后重试。";

  static String m28(name) =>
      "应用连续两次未能完成启动。为打断崩溃循环，已取消选中配置 ${name}，并跳过本次自动配置，你可以随时重新选中它。";

  static String m29(url) => "是否要通过 ${url} 创建配置？";

  static String m30(members, count) => "${members} 等 ${count} 个";

  static String m31(count) => "被 ${count} 条规则引用";

  static String m32(count, label) =>
      "${Intl.plural(count, other: '自定义配置不支持子规则，已丢弃 ${label} 条 SUB-RULE 规则')}";

  static String m33(message) => "内核无法解析该代理：${message}";

  static String m34(proxy, target) =>
      "${proxy} 经 ${target} 拨号，而 ${target} 又会回到 ${proxy}，形成环路";

  static String m35(name) => "名称 ${name} 已被其他代理或策略组使用";

  static String m36(path) => "策略组之间存在循环引用：${path}";

  static String m37(name) => "空组兜底只能是代理，${name} 不存在或是策略组";

  static String m38(name, message) => "${name}不是有效的正则：${message}";

  static String m39(name) => "拨号代理 ${name} 不存在";

  static String m40(names) => "以下代理集不存在：${names}";

  static String m41(names) => "以下代理或策略不存在：${names}";

  static String m42(name) => "${name} 是内置策略名，不能在此使用";

  static String m43(count) => "${count} 项存在问题，应用配置可能失败";

  static String m44(count) => "被 ${count} 个分组使用";

  static String m45(count) => "${count} 天前";

  static String m46(count) => "${count} 天前";

  static String m47(label) => "确定删除选中的${label}吗？";

  static String m48(label) => "确定删除当前${label}吗？";

  static String m49(hours) => "资源每 ${hours} 小时自动检查更新；下载失败时继续使用旧版本";

  static String m50(label) => "${label}详情";

  static String m51(name) => "经 ${name} 拨号会绕回使用它的代理，连接已中止";

  static String m52(label) => "${label}不能为空";

  static String m53(label) => "${label}当前已存在";

  static String m54(count) => "${count} 项失败，点击查看";

  static String m55(label, message) => "${label}：${message}";

  static String m56(name) => "${name} 已是最新版本";

  static String m57(name) => "${name} 已更新";

  static String m58(count) => "${count} 个";

  static String m59(count) => "${count} 超时";

  static String m60(action) => "已被“${action}”使用，保存后将移到这里";

  static String m61(modifiers) => "至少包含 ${modifiers} 中的一个";

  static String m62(count) => "${count} 小时前";

  static String m63(count) => "${count} 小时前";

  static String m64(encoding) => "无法解码 ${encoding}，显示的是传输时的原始数据。";

  static String m65(memory, body) =>
      "达到此条数或占满 ${memory} 内存后，先丢弃最早的记录。每段内容只保留前 ${body}。";

  static String m66(invalid, total) => "${total} 条中 ${invalid} 条无效";

  static String m67(target) => "${target} 是一个无效的策略";

  static String m68(proxyName) => "${proxyName} 是一个无效的代理";

  static String m69(providerName) => "${providerName} 是一个无效的代理集";

  static String m70(ruleSet) => "${ruleSet} 不是有效的规则集";

  static String m71(subRule) => "${subRule} 是一个无效的SUB_RULE";

  static String m72(count) => "${count} 项";

  static String m73(line, message) => "第 ${line} 行：${message}";

  static String m74(appName) =>
      "1. 打开 系统设置 > 隐私与安全性\n2. 选择 定位服务\n3. 在右侧列表中找到并勾选 ${appName}\n\n完成设置后，返回应用即可正常使用。感谢您的配合。";

  static String m75(label, max) => "${label}最多${max}个字符";

  static String m76(size) => "已释放 ${size}";

  static String m77(count) => "${count} 分钟前";

  static String m78(count) => "${count} 分钟前";

  static String m79(fileName) =>
      "已将 ${fileName} 保存到“下载”。请在系统设置的“安全 › 加密与凭据 › 安装证书 › CA 证书”中安装。";

  static String m80(command) =>
      "Chrome 和 Firefox 使用自己的证书库，需要 certutil：${command}";

  static String m81(host) =>
      "要把 ${host} 加入主机名列表吗？之后天机云能读取发往它的内容，包括 Cookie 和密码。";

  static String m82(host) => "要把 -${host} 加到主机名列表顶部吗？之后不再解密该主机。";

  static String m83(size) => "文件大于 ${size} MB";

  static String m84(stores) => "尚未加入：${stores}";

  static String m85(name) => "${name} 的脚本有变化，已关闭";

  static String m86(system) => "为 ${system} 编写，部分行可能不适用于本设备。";

  static String m87(name) => "无法移除旧证书 ${name}，请自行从信任的根证书中移除。";

  static String m88(name) =>
      "旧证书 ${name} 仍在系统信任的证书中。请在 root 管理器中允许天机云使用 root 后重新生成，或在其中移除“TianjiCloud MITM CA”模块并重启。";

  static String m89(name) =>
      "请在系统设置的“安全 › 加密与凭据 › 信任的凭据 › 用户”中移除旧证书 ${name}，再安装新证书。";

  static String m90(section) => "不支持 [${section}] 段";

  static String m91(count) => "${count} 个月前";

  static String m92(count) => "${count} 个月前";

  static String m93(code) => "服务器拒绝访问（HTTP ${code}），链接可能已过期或凭据有误";

  static String m94(code) => "服务器拒绝了请求（HTTP ${code}）";

  static String m95(code) => "该地址下没有内容（HTTP ${code}），请确认链接是否正确";

  static String m96(detail) => "网络请求失败：${detail}";

  static String m97(code) => "服务器出现问题（HTTP ${code}），请稍后再试";

  static String m98(label) => "暂无${label}";

  static String m99(label, min, max) => "${label}必须在 ${min} 到 ${max} 之间";

  static String m100(label) => "${label}必须为数字";

  static String m101(count) => "已导入 · ${count} 个节点";

  static String m102(label) => "${label} 必须在 1024 到 49151 之间";

  static String m103(port) => "端口 ${port}";

  static String m104(days) => "剩余 ${days} 天";

  static String m105(date, days) => "${date} 到期，剩余 ${days} 天";

  static String m106(time) => "更新于 ${time}";

  static String m107(count) => "${count} 条";

  static String m108(label, profiles) =>
      "${label} 仍被 ${profiles} 使用，删除后这些配置会异常。确定删除吗？";

  static String m109(count, label) =>
      "${Intl.plural(count, other: '${label} 个代理')}";

  static String m110(name, count) => "${name} 等 ${count} 个代理";

  static String m111(removed) =>
      "以下代理将被删除：${removed}。改了名字的行按新代理处理，自定义配置中对被删除代理的引用会标为缺失。确定应用吗？";

  static String m112(removed, added) =>
      "以下代理将被删除：${removed}。以下代理将新增：${added}。改了名字的行按新代理处理，自定义配置中对被删除代理的引用会标为缺失。确定应用吗？";

  static String m113(label) =>
      "${label} 仍被当前配置的规则、策略组、拨号代理、DNS 或 NTP 引用，删除后这些引用会失效。确定删除吗？";

  static String m114(count, label) =>
      "${Intl.plural(count, other: '${label} 个策略组')}";

  static String m115(name) => "使用${name}";

  static String m116(count, label) =>
      "${Intl.plural(count, other: '${label} 条规则')}";

  static String m117(appName) => "${appName}（安全模式）";

  static String m118(count) => "${count} 秒";

  static String m119(count) => "${count} 项生效";

  static String m120(count) => "${count} 项异常";

  static String m121(count) => "${count} 项设置";

  static String m122(link) => "无法从 ${link} 中读取代理";

  static String m123(label) => "${label}只能是一项";

  static String m124(value) => "峰值 ${value}";

  static String m125(value) => "累计 ${value}";

  static String m126(transport) => "${transport} 请求头";

  static String m127(label) => "${label}必须为URL";

  static String m128(date) => "有效期至 ${date}";

  static String m129(count) => "${count} 年前";

  static String m130(count) => "${count} 年前";

  static String m131(hours) => "每 ${hours} 小时自动更新";

  static String m132(count, unit) => "每${count} ${unit}自动更新";

  static String m133(date) => "${date} 到期";

  static String m134(count) => "基于当前订阅 · ${count} 条覆写规则";

  static String m135(count) => "订阅链接 · 已过期 ${count} 天";

  static String m136(scheme) =>
      "还可以：从剪贴板粘贴链接、选择本地 YAML 文件，或在浏览器打开 ${scheme} 导入链接";

  static String m137(date) => "本地文件 · ${date} 导入";

  static String m138(quota) => "共 ${quota}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("关于"),
    "accessControl": MessageLookupByLibrary.simpleMessage("访问控制"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "只允许选中应用进入VPN",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "应用访问控制已关闭",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "选中应用将会被排除在VPN之外",
    ),
    "accessControlSelectedCount": m0,
    "account": MessageLookupByLibrary.simpleMessage("账号"),
    "action": MessageLookupByLibrary.simpleMessage("操作"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage("测试全部延迟"),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("直连模式"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("全局模式"),
    "actionMode": MessageLookupByLibrary.simpleMessage("切换模式"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("规则模式"),
    "actionStart": MessageLookupByLibrary.simpleMessage("启动/停止"),
    "actionTun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage("更新全部配置"),
    "actionView": MessageLookupByLibrary.simpleMessage("显示/隐藏"),
    "add": MessageLookupByLibrary.simpleMessage("添加"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("添加代理"),
    "addFilters": MessageLookupByLibrary.simpleMessage("添加筛选"),
    "addNodes": MessageLookupByLibrary.simpleMessage("添加节点"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage("添加覆写项"),
    "addProfile": MessageLookupByLibrary.simpleMessage("添加配置"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("添加策略组"),
    "addRule": MessageLookupByLibrary.simpleMessage("添加规则"),
    "addSettingEntry": MessageLookupByLibrary.simpleMessage("添加设置项"),
    "addSsid": MessageLookupByLibrary.simpleMessage("添加SSID"),
    "addToLocalProxies": MessageLookupByLibrary.simpleMessage("添加到本地代理"),
    "addedRules": MessageLookupByLibrary.simpleMessage("附加规则"),
    "addedToLocalProxies": m1,
    "additionalParameters": MessageLookupByLibrary.simpleMessage("附加参数"),
    "additionalPrefix": MessageLookupByLibrary.simpleMessage("名称前缀"),
    "additionalSuffix": MessageLookupByLibrary.simpleMessage("名称后缀"),
    "address": MessageLookupByLibrary.simpleMessage("地址"),
    "addressTip": MessageLookupByLibrary.simpleMessage("请输入有效的WebDAV地址"),
    "advancedConfig": MessageLookupByLibrary.simpleMessage("进阶配置"),
    "ageEncryptedProfile": MessageLookupByLibrary.simpleMessage("配置已加密"),
    "ageSecretKey": MessageLookupByLibrary.simpleMessage("age 私钥"),
    "ageSecretKeyRequiredTip": MessageLookupByLibrary.simpleMessage(
      "该配置已用 age 加密，需要 age 私钥才能解密",
    ),
    "agree": MessageLookupByLibrary.simpleMessage("同意"),
    "all": MessageLookupByLibrary.simpleMessage("全部"),
    "allReferencedProxies": MessageLookupByLibrary.simpleMessage("全部被引用的代理"),
    "allReferencedProxyProviders": MessageLookupByLibrary.simpleMessage(
      "全部被引用的代理集",
    ),
    "allowBypass": MessageLookupByLibrary.simpleMessage("允许应用绕过VPN"),
    "allowLan": MessageLookupByLibrary.simpleMessage("局域网代理"),
    "allowedIps": MessageLookupByLibrary.simpleMessage("允许的 IP"),
    "alreadyInLocalProxies": m2,
    "answers": MessageLookupByLibrary.simpleMessage("应答"),
    "app": MessageLookupByLibrary.simpleMessage("应用"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage("应用访问控制"),
    "appBackground": MessageLookupByLibrary.simpleMessage("背景"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage("应用图标设计"),
    "appProxiesEmpty": MessageLookupByLibrary.simpleMessage("暂无本地代理"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage("追加系统DNS"),
    "applied": MessageLookupByLibrary.simpleMessage("已应用"),
    "applyNow": MessageLookupByLibrary.simpleMessage("立即应用"),
    "arguments": MessageLookupByLibrary.simpleMessage("参数"),
    "authentication": MessageLookupByLibrary.simpleMessage("认证"),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "认证启用时，系统代理不生效。",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("授权"),
    "authorized": MessageLookupByLibrary.simpleMessage("已授权"),
    "auto": MessageLookupByLibrary.simpleMessage("自动"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage("自动检查更新"),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage("自动关闭连接"),
    "autoInclude": MessageLookupByLibrary.simpleMessage("自动包含"),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自启动"),
    "autoRun": MessageLookupByLibrary.simpleMessage("自动运行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage("自动运行会在打开应用时启动代理。"),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage("自动设置系统DNS"),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自动更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage("自动更新间隔"),
    "back": MessageLookupByLibrary.simpleMessage("返回"),
    "backgroundAurora": MessageLookupByLibrary.simpleMessage("极光"),
    "backgroundBlur": MessageLookupByLibrary.simpleMessage("背景模糊"),
    "backgroundGlobe": MessageLookupByLibrary.simpleMessage("星网"),
    "backgroundMountains": MessageLookupByLibrary.simpleMessage("远山"),
    "backgroundNebula": MessageLookupByLibrary.simpleMessage("星云"),
    "backgroundOrbit": MessageLookupByLibrary.simpleMessage("深空轨道"),
    "backgroundPlanet": MessageLookupByLibrary.simpleMessage("星球"),
    "backgroundSolid": MessageLookupByLibrary.simpleMessage("纯色"),
    "backup": MessageLookupByLibrary.simpleMessage("备份"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage("备份与恢复"),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "该备份来自更高版本的应用，请先更新应用再恢复",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("备份成功"),
    "basicInfo": MessageLookupByLibrary.simpleMessage("基础信息"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("基础策略"),
    "batchImport": MessageLookupByLibrary.simpleMessage("批量导入"),
    "batchLineInputTip": MessageLookupByLibrary.simpleMessage("每行一项"),
    "batchLinkInputTip": MessageLookupByLibrary.simpleMessage("每行一个链接"),
    "batchPreviewTip": m3,
    "batchUrlInputTip": MessageLookupByLibrary.simpleMessage("每行一个URL"),
    "binaryData": MessageLookupByLibrary.simpleMessage("二进制数据"),
    "bind": MessageLookupByLibrary.simpleMessage("绑定"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("黑名单模式"),
    "blockQuic": MessageLookupByLibrary.simpleMessage("阻止 QUIC"),
    "bodyRewrite": MessageLookupByLibrary.simpleMessage("Body 重写"),
    "brandName": MessageLookupByLibrary.simpleMessage("天机云"),
    "brightness": MessageLookupByLibrary.simpleMessage("亮度"),
    "businessAboutBackupTitle": MessageLookupByLibrary.simpleMessage("关于与备份"),
    "businessAboutPanel": MessageLookupByLibrary.simpleMessage("用户面板与续费"),
    "businessAccentColor": MessageLookupByLibrary.simpleMessage("强调色"),
    "businessAdvancedNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "进阶网络设置",
    ),
    "businessAiServiceLabel": MessageLookupByLibrary.simpleMessage("AI 服务"),
    "businessAiServices": MessageLookupByLibrary.simpleMessage(
      "ChatGPT · Claude",
    ),
    "businessAllLines": MessageLookupByLibrary.simpleMessage("全部线路"),
    "businessAllowBypassDescription": MessageLookupByLibrary.simpleMessage(
      "允许指定应用绕过 VPN。",
    ),
    "businessAppProxyTitle": MessageLookupByLibrary.simpleMessage("分应用代理"),
    "businessAuthorizeTun": MessageLookupByLibrary.simpleMessage("授权虚拟网卡"),
    "businessAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "登录 Windows 后在后台运行",
    ),
    "businessAutoLaunchTitle": MessageLookupByLibrary.simpleMessage("开机自动启动"),
    "businessAutoRunDesc": MessageLookupByLibrary.simpleMessage("使用上次的线路与模式"),
    "businessAutoRunTitle": MessageLookupByLibrary.simpleMessage("启动后自动连接"),
    "businessAutoTest": MessageLookupByLibrary.simpleMessage("自动测速"),
    "businessBackupDesc": MessageLookupByLibrary.simpleMessage(
      "将配置和应用设置保存为备份文件。",
    ),
    "businessBackupNow": MessageLookupByLibrary.simpleMessage("立即备份"),
    "businessCards": MessageLookupByLibrary.simpleMessage("卡片"),
    "businessCheckedAt": m4,
    "businessChooseLine": MessageLookupByLibrary.simpleMessage("更换线路"),
    "businessClientVersion": MessageLookupByLibrary.simpleMessage("客户端版本"),
    "businessClientVersionDesc": MessageLookupByLibrary.simpleMessage(
      "当前安装的客户端版本",
    ),
    "businessCloseAllConnections": MessageLookupByLibrary.simpleMessage("全部关闭"),
    "businessCloseWindow": MessageLookupByLibrary.simpleMessage("关闭窗口时"),
    "businessConnectVia": m5,
    "businessConnectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "已连接 · 有异常",
    ),
    "businessConnectedDisconnect": MessageLookupByLibrary.simpleMessage(
      "已连接 · 点击断开",
    ),
    "businessConnectedProbeFailed": MessageLookupByLibrary.simpleMessage(
      "已连接 · 出口检测失败",
    ),
    "businessConnectedUnverified": MessageLookupByLibrary.simpleMessage(
      "已连接 · 出口未通过校验",
    ),
    "businessCopyErrorInfo": MessageLookupByLibrary.simpleMessage("复制错误信息"),
    "businessCurrent": MessageLookupByLibrary.simpleMessage("当前"),
    "businessCurrentExitIp": MessageLookupByLibrary.simpleMessage("当前出口 IP"),
    "businessCurrentLine": MessageLookupByLibrary.simpleMessage("当前线路"),
    "businessCurrentLineState": m6,
    "businessCurrentNode": MessageLookupByLibrary.simpleMessage("当前节点"),
    "businessDelayTestShort": MessageLookupByLibrary.simpleMessage("测速"),
    "businessDelayTimeout": MessageLookupByLibrary.simpleMessage("超时"),
    "businessDeveloperDescription": MessageLookupByLibrary.simpleMessage(
      "打开诊断与开发者工具。",
    ),
    "businessDeveloperOptionsDescription": MessageLookupByLibrary.simpleMessage(
      "这些选项用于排查问题，一般不需要修改。",
    ),
    "businessDeveloperOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "开发者选项",
    ),
    "businessDisclaimerAgree": MessageLookupByLibrary.simpleMessage("同意并继续"),
    "businessDisclaimerSubtitle": MessageLookupByLibrary.simpleMessage(
      "首次启动时显示一次",
    ),
    "businessDisclaimerTitle": MessageLookupByLibrary.simpleMessage("使用前请阅读"),
    "businessDisconnect": MessageLookupByLibrary.simpleMessage("断开"),
    "businessDnsAndSniffing": MessageLookupByLibrary.simpleMessage("DNS 与嗅探"),
    "businessDnsFailed": MessageLookupByLibrary.simpleMessage("失败"),
    "businessDnsModeDescription": MessageLookupByLibrary.simpleMessage(
      "选择 DNS 解析与返回结果的方式。",
    ),
    "businessDnsNoUpstream": MessageLookupByLibrary.simpleMessage(
      "尚未配置 DNS 上游覆写。",
    ),
    "businessDnsProxyResolved": MessageLookupByLibrary.simpleMessage("代理解析"),
    "businessDnsResourcePreview": MessageLookupByLibrary.simpleMessage(
      "分流资源预览",
    ),
    "businessDnsServers": MessageLookupByLibrary.simpleMessage("DNS 服务器"),
    "businessDnsSucceeded": MessageLookupByLibrary.simpleMessage("成功"),
    "businessDomainSniffingDescription": MessageLookupByLibrary.simpleMessage(
      "从支持的网络流量中读取域名。",
    ),
    "businessEnableRules": MessageLookupByLibrary.simpleMessage("启用智能分流"),
    "businessErrorSolutions": MessageLookupByLibrary.simpleMessage("可以这样解决"),
    "businessErrorStepChangePort": MessageLookupByLibrary.simpleMessage(
      "在 设置 → 入站与端口 更换端口",
    ),
    "businessErrorStepClosePort": MessageLookupByLibrary.simpleMessage(
      "关闭占用 7890 端口的程序后重新打开天机云",
    ),
    "businessExitCheckPassed": MessageLookupByLibrary.simpleMessage("出口校验通过"),
    "businessExitMismatch": MessageLookupByLibrary.simpleMessage(
      "实际出口与所选线路不一致",
    ),
    "businessExitProbeDescription": MessageLookupByLibrary.simpleMessage(
      "出口检测没有返回结果，代理可能仍在工作。可以重新检测，或运行诊断查看原因。",
    ),
    "businessExitProbeUnavailable": MessageLookupByLibrary.simpleMessage(
      "暂时无法确认出口",
    ),
    "businessExitTunDescription": MessageLookupByLibrary.simpleMessage(
      "虚拟网卡还没有授权，终端和部分应用没有经过代理，它们看到的是你的本地 IP。授权一次即可修复。",
    ),
    "businessExitVerified": MessageLookupByLibrary.simpleMessage("已连接 · 出口已校验"),
    "businessExitVerifiedDetail": m7,
    "businessExitVerifiedShort": MessageLookupByLibrary.simpleMessage("出口已校验"),
    "businessExpiryDate": m8,
    "businessExpiryDateShort": m9,
    "businessExpiryNotice": m10,
    "businessFollowSystem": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "businessGroupHeader": MessageLookupByLibrary.simpleMessage("分组"),
    "businessGroupLocked": MessageLookupByLibrary.simpleMessage("已锁定"),
    "businessHelp": MessageLookupByLibrary.simpleMessage("帮助"),
    "businessHome": MessageLookupByLibrary.simpleMessage("首页"),
    "businessHotkeyHint": MessageLookupByLibrary.simpleMessage("点击一行设置或修改快捷键"),
    "businessImportAgain": MessageLookupByLibrary.simpleMessage("重新导入"),
    "businessImportRenew": MessageLookupByLibrary.simpleMessage("续费"),
    "businessIntercept": MessageLookupByLibrary.simpleMessage("拦截"),
    "businessKernelRestart": MessageLookupByLibrary.simpleMessage("重启内核"),
    "businessKernelStartFailed": MessageLookupByLibrary.simpleMessage(
      "网络内核没能启动",
    ),
    "businessKernelUptime": MessageLookupByLibrary.simpleMessage("已运行"),
    "businessLegal": MessageLookupByLibrary.simpleMessage("法律"),
    "businessLineCount": MessageLookupByLibrary.simpleMessage("条"),
    "businessLineFailed": MessageLookupByLibrary.simpleMessage("未能完成线路切换，请重试"),
    "businessLineSelectionHint": MessageLookupByLibrary.simpleMessage(
      "手动选择优先：选中哪条，出口就是哪条。切换后会自动校验出口 IP，不一致会直接写明原因。",
    ),
    "businessLineSelectionHintShort": MessageLookupByLibrary.simpleMessage(
      "选中哪条，出口就是哪条；切换后自动校验出口 IP。",
    ),
    "businessLineTitle": MessageLookupByLibrary.simpleMessage("默认线路"),
    "businessLines": MessageLookupByLibrary.simpleMessage("线路"),
    "businessLinesEmpty": MessageLookupByLibrary.simpleMessage(
      "暂未读取到可用线路，请检查订阅。",
    ),
    "businessLinesLoading": MessageLookupByLibrary.simpleMessage("正在读取可用线路…"),
    "businessLocalExport": MessageLookupByLibrary.simpleMessage("导出到本地文件"),
    "businessLocalPorts": MessageLookupByLibrary.simpleMessage("本地端口"),
    "businessLocked": MessageLookupByLibrary.simpleMessage("锁定"),
    "businessLockedExit": MessageLookupByLibrary.simpleMessage("已锁定出口"),
    "businessMainlandDirect": MessageLookupByLibrary.simpleMessage("大陆直连"),
    "businessManage": MessageLookupByLibrary.simpleMessage("管理"),
    "businessManualSelect": MessageLookupByLibrary.simpleMessage("手动选择"),
    "businessMinimizeDesc": MessageLookupByLibrary.simpleMessage(
      "托盘图标会一直显示连接状态",
    ),
    "businessMinimizeToTray": MessageLookupByLibrary.simpleMessage("最小化到托盘"),
    "businessMitmDescription": MessageLookupByLibrary.simpleMessage(
      "使用本地证书检查 HTTPS 流量。",
    ),
    "businessMitmWarning": MessageLookupByLibrary.simpleMessage(
      "MITM 会解密匹配域名的 HTTPS 流量。只在你信任的模块里启用。",
    ),
    "businessMonthTraffic": MessageLookupByLibrary.simpleMessage("本月流量"),
    "businessMonthUsed": MessageLookupByLibrary.simpleMessage("本月已用"),
    "businessMoreVpnDescription": MessageLookupByLibrary.simpleMessage(
      "打开其余虚拟网卡接口选项。",
    ),
    "businessMoreVpnSettings": MessageLookupByLibrary.simpleMessage(
      "更多 VPN 设置",
    ),
    "businessMultiplier": m11,
    "businessNetworkStack": MessageLookupByLibrary.simpleMessage("网络栈"),
    "businessNotConnected": MessageLookupByLibrary.simpleMessage("未连接"),
    "businessOnDemandConnection": MessageLookupByLibrary.simpleMessage("按需连接"),
    "businessOnDemandEmpty": MessageLookupByLibrary.simpleMessage(
      "添加 Wi-Fi 网络后，连接到该网络时会暂停应用运行。",
    ),
    "businessOnboardingFactDashboard": MessageLookupByLibrary.simpleMessage(
      "在仪表盘查看连接统计",
    ),
    "businessOnboardingFactImport": MessageLookupByLibrary.simpleMessage(
      "导入订阅配置",
    ),
    "businessOnboardingFactStatus": MessageLookupByLibrary.simpleMessage(
      "查看线路连接状态",
    ),
    "businessOnboardingFailedChangeLink": MessageLookupByLibrary.simpleMessage(
      "换一个订阅链接",
    ),
    "businessOnboardingFailedDays": m12,
    "businessOnboardingFailedExpiredDescription": m13,
    "businessOnboardingFailedExpiredTitle":
        MessageLookupByLibrary.simpleMessage("这个订阅已经过期"),
    "businessOnboardingFailedPackage": MessageLookupByLibrary.simpleMessage(
      "套餐",
    ),
    "businessOnboardingFailedPastedUrl": MessageLookupByLibrary.simpleMessage(
      "你粘贴的链接",
    ),
    "businessOnboardingFailedRenew": MessageLookupByLibrary.simpleMessage(
      "去续费",
    ),
    "businessOnboardingFailedRetainedConfig":
        MessageLookupByLibrary.simpleMessage("之前的配置已保留，客户端仍可正常使用。"),
    "businessOnboardingFailedRetry": MessageLookupByLibrary.simpleMessage(
      "重新校验",
    ),
    "businessOnboardingFailedStatus": MessageLookupByLibrary.simpleMessage(
      "状态",
    ),
    "businessOnboardingFailedStep": m14,
    "businessOnboardingHeroTitle": MessageLookupByLibrary.simpleMessage(
      "三步连接天机云",
    ),
    "businessOnboardingImportConnect": MessageLookupByLibrary.simpleMessage(
      "导入并连接",
    ),
    "businessOnboardingScanFile": MessageLookupByLibrary.simpleMessage(
      "扫码 / 选择文件",
    ),
    "businessOnboardingUrlHint": MessageLookupByLibrary.simpleMessage(
      "粘贴天机云订阅链接",
    ),
    "businessOnboardingUrlLabel": MessageLookupByLibrary.simpleMessage("订阅链接"),
    "businessOpenSource": MessageLookupByLibrary.simpleMessage("开源许可"),
    "businessOpenSourceDescription": MessageLookupByLibrary.simpleMessage(
      "基于 FlClash · GPL-3.0",
    ),
    "businessOutboundLabel": MessageLookupByLibrary.simpleMessage("出站"),
    "businessOverrideSettings": MessageLookupByLibrary.simpleMessage("订阅覆写"),
    "businessPortConflictTip": MessageLookupByLibrary.simpleMessage(
      "端口 7890 已被其他程序占用，天机云无法监听。你的网络没有被改动，可以正常上网。",
    ),
    "businessPrivacyTerms": MessageLookupByLibrary.simpleMessage("隐私政策 · 服务条款"),
    "businessProfileAddAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "自动更新",
    ),
    "businessProfileAddClipboardRecognized":
        MessageLookupByLibrary.simpleMessage("已从剪贴板识别到天机云订阅链接"),
    "businessProfileAddCustomDescription": MessageLookupByLibrary.simpleMessage(
      "在已有订阅上加规则",
    ),
    "businessProfileAddCustomTitle": MessageLookupByLibrary.simpleMessage(
      "自定义配置",
    ),
    "businessProfileAddFileDescription": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "businessProfileAddFileTitle": MessageLookupByLibrary.simpleMessage("本地文件"),
    "businessProfileAddLinkDescription": MessageLookupByLibrary.simpleMessage(
      "从用户面板复制",
    ),
    "businessProfileAddLinkTitle": MessageLookupByLibrary.simpleMessage("订阅链接"),
    "businessProfileAddMoreOptions": MessageLookupByLibrary.simpleMessage(
      "更多选项",
    ),
    "businessProfileAddNameHint": MessageLookupByLibrary.simpleMessage(
      "留空则使用订阅里的套餐名",
    ),
    "businessProfileAddNameLabel": MessageLookupByLibrary.simpleMessage(
      "名称（可选）",
    ),
    "businessProfileAddSubmit": MessageLookupByLibrary.simpleMessage("导入并校验"),
    "businessProfileAddTitle": MessageLookupByLibrary.simpleMessage("添加订阅"),
    "businessProfileAddUrlHint": MessageLookupByLibrary.simpleMessage("粘贴订阅链接"),
    "businessProfileAddUrlLabel": MessageLookupByLibrary.simpleMessage("订阅链接"),
    "businessProfileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "导入后会先校验；解析失败不会覆盖你正在用的配置。",
    ),
    "businessProfileEditDelete": MessageLookupByLibrary.simpleMessage("删除此订阅"),
    "businessProfileEditDeleteDescription":
        MessageLookupByLibrary.simpleMessage("只删除本机的配置，不影响你的天机云账号和套餐。"),
    "businessProfileEditDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "删除订阅",
    ),
    "businessProfileEditExpire": MessageLookupByLibrary.simpleMessage("到期"),
    "businessProfileEditExtendDescription":
        MessageLookupByLibrary.simpleMessage("已启用 "),
    "businessProfileEditExtendSuffix": MessageLookupByLibrary.simpleMessage(
      " 项覆写",
    ),
    "businessProfileEditExtensionTitle": MessageLookupByLibrary.simpleMessage(
      "扩展覆写与脚本",
    ),
    "businessProfileEditGroupCountSuffix": MessageLookupByLibrary.simpleMessage(
      " 个分组",
    ),
    "businessProfileEditHide": MessageLookupByLibrary.simpleMessage("隐藏"),
    "businessProfileEditLineCountSeparator":
        MessageLookupByLibrary.simpleMessage(" 条 · "),
    "businessProfileEditLineLabel": MessageLookupByLibrary.simpleMessage("线路"),
    "businessProfileEditManage": MessageLookupByLibrary.simpleMessage("管理"),
    "businessProfileEditOpen": MessageLookupByLibrary.simpleMessage("打开"),
    "businessProfileEditPlan": MessageLookupByLibrary.simpleMessage("套餐"),
    "businessProfileEditPreviewDescription":
        MessageLookupByLibrary.simpleMessage("只读预览，修改请用自定义配置"),
    "businessProfileEditPrivacy": MessageLookupByLibrary.simpleMessage(
      "链接含个人令牌，请勿分享",
    ),
    "businessProfileEditRawTitle": MessageLookupByLibrary.simpleMessage(
      "查看原始配置",
    ),
    "businessProfileEditRenew": MessageLookupByLibrary.simpleMessage("续费 / 升级"),
    "businessProfileEditShow": MessageLookupByLibrary.simpleMessage("显示"),
    "businessProfileEditSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "套餐信息",
    ),
    "businessProfileEditTitle": MessageLookupByLibrary.simpleMessage("编辑订阅"),
    "businessProfilesSortDescription": MessageLookupByLibrary.simpleMessage(
      "拖动调整顺序，排在前面的订阅优先显示在仪表盘和托盘中。",
    ),
    "businessProfilesSortTitle": MessageLookupByLibrary.simpleMessage("调整订阅顺序"),
    "businessProvidersTitle": MessageLookupByLibrary.simpleMessage("代理集与规则集"),
    "businessProxyCardDensity": MessageLookupByLibrary.simpleMessage("线路卡片密度"),
    "businessProxyCheckedGroup": m15,
    "businessProxyIcons": MessageLookupByLibrary.simpleMessage("线路图标"),
    "businessProxyNextConnection": MessageLookupByLibrary.simpleMessage(
      "改动会在下次连接时生效",
    ),
    "businessProxyProviders": MessageLookupByLibrary.simpleMessage("代理集"),
    "businessProxyReconnect": MessageLookupByLibrary.simpleMessage("立即重连"),
    "businessProxySearchHint": MessageLookupByLibrary.simpleMessage("搜索应用"),
    "businessProxySelectedBypass": MessageLookupByLibrary.simpleMessage(
      "勾选的应用不走代理",
    ),
    "businessProxySelectedCount": m16,
    "businessProxySelectedOnly": MessageLookupByLibrary.simpleMessage(
      "只代理勾选的应用",
    ),
    "businessProxyTraffic": MessageLookupByLibrary.simpleMessage("代理"),
    "businessProxyUncheckedGroup": MessageLookupByLibrary.simpleMessage("未勾选"),
    "businessRecheck": MessageLookupByLibrary.simpleMessage("重新校验"),
    "businessReplace": MessageLookupByLibrary.simpleMessage("更换"),
    "businessResidentialBroadband": MessageLookupByLibrary.simpleMessage(
      "住宅宽带",
    ),
    "businessResidentialLockedHint": m17,
    "businessResidentialShort": MessageLookupByLibrary.simpleMessage("住宅"),
    "businessRestoreAction": MessageLookupByLibrary.simpleMessage("恢复…"),
    "businessRestoreFromFileWebDav": MessageLookupByLibrary.simpleMessage(
      "从文件或 WebDAV 恢复",
    ),
    "businessRoutingDesc": MessageLookupByLibrary.simpleMessage(
      "此处只更改默认线路；AI、流媒体等仍按各自规则分流，直连和拦截规则保持不变。",
    ),
    "businessRuleModeRequired": MessageLookupByLibrary.simpleMessage(
      "当前未使用智能分流，这里的默认线路暂不生效。",
    ),
    "businessRuleOverrideDescription": MessageLookupByLibrary.simpleMessage(
      "管理规则与规则集提供者。",
    ),
    "businessRuleProviders": MessageLookupByLibrary.simpleMessage("规则集"),
    "businessScanPrompt": MessageLookupByLibrary.simpleMessage("把订阅二维码放进框里"),
    "businessSearchHint": MessageLookupByLibrary.simpleMessage("搜索线路名或地区"),
    "businessSelected": MessageLookupByLibrary.simpleMessage("已选"),
    "businessSelectionStale": MessageLookupByLibrary.simpleMessage(
      "订阅或模式已变化，请重新打开线路选择。",
    ),
    "businessServiceNoLogin": MessageLookupByLibrary.simpleMessage("无需登录"),
    "businessSettingsAbout": MessageLookupByLibrary.simpleMessage("关于天机云"),
    "businessSettingsAppearance": MessageLookupByLibrary.simpleMessage("外观"),
    "businessSettingsCommon": MessageLookupByLibrary.simpleMessage("常用"),
    "businessSettingsDnsResources": MessageLookupByLibrary.simpleMessage(
      "DNS 与资源",
    ),
    "businessSettingsHotkeys": MessageLookupByLibrary.simpleMessage("快捷键"),
    "businessSettingsIconsUa": MessageLookupByLibrary.simpleMessage("图标与 UA"),
    "businessSettingsInboundPorts": MessageLookupByLibrary.simpleMessage(
      "入站与端口",
    ),
    "businessSettingsNetworkAdvanced": MessageLookupByLibrary.simpleMessage(
      "网络（进阶）",
    ),
    "businessSettingsOther": MessageLookupByLibrary.simpleMessage("其他"),
    "businessSettingsRules": MessageLookupByLibrary.simpleMessage("规则与覆写"),
    "businessSettingsStartupWindow": MessageLookupByLibrary.simpleMessage(
      "启动与窗口",
    ),
    "businessSettingsTun": MessageLookupByLibrary.simpleMessage("虚拟网卡 TUN"),
    "businessSmartRouting": MessageLookupByLibrary.simpleMessage("智能分流"),
    "businessSortByDelay": MessageLookupByLibrary.simpleMessage("按延迟排序"),
    "businessStackModeDescription": MessageLookupByLibrary.simpleMessage(
      "选择 VPN 使用的网络栈模式。",
    ),
    "businessSubscriptionAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "订阅自动更新",
    ),
    "businessSubscriptionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "线路变动后无需手动刷新",
    ),
    "businessSubscriptionDetails": MessageLookupByLibrary.simpleMessage("订阅详情"),
    "businessSubscriptionOverridesDescription":
        MessageLookupByLibrary.simpleMessage("此订阅下发的 DNS 设置。"),
    "businessSubscriptionUpdatedAt": m18,
    "businessSubscriptions": MessageLookupByLibrary.simpleMessage("订阅"),
    "businessSystemProxyDescription": MessageLookupByLibrary.simpleMessage(
      "通过系统代理转发 HTTP 流量。",
    ),
    "businessSystemProxyHttp": MessageLookupByLibrary.simpleMessage(
      "系统代理（HTTP）",
    ),
    "businessTapToConnect": MessageLookupByLibrary.simpleMessage("轻点连接"),
    "businessTestAll": MessageLookupByLibrary.simpleMessage("全部测速"),
    "businessToolsAppearance": MessageLookupByLibrary.simpleMessage("外观"),
    "businessToolsAppearanceLanguage": MessageLookupByLibrary.simpleMessage(
      "外观与语言",
    ),
    "businessToolsApplicationCount": m19,
    "businessToolsBrowse": MessageLookupByLibrary.simpleMessage("查看"),
    "businessToolsConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "连接与请求",
    ),
    "businessToolsGeneral": MessageLookupByLibrary.simpleMessage("通用"),
    "businessToolsLocalDirect": MessageLookupByLibrary.simpleMessage("局域网设备直连"),
    "businessToolsPassedCount": m20,
    "businessToolsPerAppProxy": MessageLookupByLibrary.simpleMessage("分应用代理"),
    "businessToolsRequestCount": m21,
    "businessToolsRoutingResources": MessageLookupByLibrary.simpleMessage(
      "分流资源",
    ),
    "businessToolsRuntimeLogs": MessageLookupByLibrary.simpleMessage("运行日志"),
    "businessToolsSimplifiedChinese": MessageLookupByLibrary.simpleMessage(
      "简体中文",
    ),
    "businessTrafficScope": MessageLookupByLibrary.simpleMessage("仅本设备本月统计"),
    "businessTunBypassPrivateDescription": MessageLookupByLibrary.simpleMessage(
      "打印机、NAS 等局域网设备直接访问",
    ),
    "businessTunCaption": MessageLookupByLibrary.simpleMessage("接管所有应用流量"),
    "businessTunDevice": MessageLookupByLibrary.simpleMessage("网卡名称"),
    "businessTunExcludedRoutes": MessageLookupByLibrary.simpleMessage("排除的路由"),
    "businessTunMtu": MessageLookupByLibrary.simpleMessage("MTU"),
    "businessTunRouteCount": MessageLookupByLibrary.simpleMessage("条"),
    "businessTunStackGvisorDescription": MessageLookupByLibrary.simpleMessage(
      "由 gVisor 用户态网络栈处理 TCP 和 UDP",
    ),
    "businessTunStackMipsDescription": MessageLookupByLibrary.simpleMessage(
      "由 mipstack 用户态网络栈处理 TCP 和 UDP",
    ),
    "businessTunStackMixed": MessageLookupByLibrary.simpleMessage("混合"),
    "businessTunStackMixedDescription": MessageLookupByLibrary.simpleMessage(
      "TCP 用系统栈、UDP 用 gVisor，兼容性最好",
    ),
    "businessTunStackSystemDescription": MessageLookupByLibrary.simpleMessage(
      "由操作系统网络栈处理 TCP 和 UDP",
    ),
    "businessTunTakeoverDescription": MessageLookupByLibrary.simpleMessage(
      "虚拟网卡接管所有应用（包括终端、游戏、不认系统代理的软件）。需要「系统服务」以管理员权限运行。",
    ),
    "businessTunTakeoverMode": MessageLookupByLibrary.simpleMessage("接管方式"),
    "businessTunTitle": MessageLookupByLibrary.simpleMessage("虚拟网卡（TUN）"),
    "businessTypographyLayout": MessageLookupByLibrary.simpleMessage("文字与布局"),
    "businessUpdateAvailable": m22,
    "businessUpdateDaily": MessageLookupByLibrary.simpleMessage("每天"),
    "businessUpdateHour1": MessageLookupByLibrary.simpleMessage("每 1 小时"),
    "businessUpdateHour12": MessageLookupByLibrary.simpleMessage("每 12 小时"),
    "businessUpdateHour6": MessageLookupByLibrary.simpleMessage("每 6 小时"),
    "businessUsagePercent": m23,
    "businessVersion": MessageLookupByLibrary.simpleMessage("版本"),
    "businessViewDiagnostics": MessageLookupByLibrary.simpleMessage("查看诊断"),
    "businessVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "businessVpnPermission": MessageLookupByLibrary.simpleMessage(
      "首次连接需要允许 VPN 权限",
    ),
    "businessWebDavBackup": MessageLookupByLibrary.simpleMessage("WebDAV 备份"),
    "businessWifiRulesCount": m24,
    "bypassDomain": MessageLookupByLibrary.simpleMessage("排除域名"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "排除域名仅在系统代理启用时生效。",
    ),
    "bypassPrivateRoute": MessageLookupByLibrary.simpleMessage("绕过私有路由地址"),
    "cache": MessageLookupByLibrary.simpleMessage("缓存"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("缓存算法"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage("缓存已损坏，是否清空？"),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("缓存大小"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "请在系统设置中允许访问相机以扫描二维码，或从相册选择二维码图片。",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage("需要相机权限"),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage("相机不可用"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("取消全选"),
    "cannotSave": MessageLookupByLibrary.simpleMessage("无法保存"),
    "certificate": MessageLookupByLibrary.simpleMessage("证书"),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "切换代理失败，已恢复上一次的选择",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage("重大变更"),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("新功能"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("问题修复"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage("性能优化"),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("已回滚"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage("校验 TLS 证书"),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "关闭证书校验后，订阅和备份可能遭中间人攻击。",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage("当前应用已经是最新版了"),
    "checkingExit": MessageLookupByLibrary.simpleMessage("正在确认出口…"),
    "chooseFile": MessageLookupByLibrary.simpleMessage("选择文件"),
    "cipher": MessageLookupByLibrary.simpleMessage("加密方式"),
    "clearData": MessageLookupByLibrary.simpleMessage("清除数据"),
    "clearDataAndExitTip": MessageLookupByLibrary.simpleMessage(
      "将删除所有配置、设置和本地数据，随后关闭应用。重新打开即可从头开始。",
    ),
    "clearDataFailed": m25,
    "clearDnsCache": MessageLookupByLibrary.simpleMessage("清除DNS缓存"),
    "clearDnsCacheFailed": MessageLookupByLibrary.simpleMessage("清除DNS缓存失败"),
    "clearSearch": MessageLookupByLibrary.simpleMessage("清除搜索"),
    "clientFingerprint": MessageLookupByLibrary.simpleMessage("客户端指纹"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("导出剪贴板"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("剪贴板导入"),
    "clipboardNoPackageNames": MessageLookupByLibrary.simpleMessage(
      "剪贴板中没有有效的包名",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "无法复制到剪贴板，所选内容可能过大",
    ),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "closeAllConnections": MessageLookupByLibrary.simpleMessage("关闭全部连接"),
    "closeConnection": MessageLookupByLibrary.simpleMessage("关闭连接"),
    "closeConnections": MessageLookupByLibrary.simpleMessage("关闭连接"),
    "color": MessageLookupByLibrary.simpleMessage("颜色"),
    "colorStyle": MessageLookupByLibrary.simpleMessage("配色风格"),
    "columns": MessageLookupByLibrary.simpleMessage("列数"),
    "compact": MessageLookupByLibrary.simpleMessage("紧凑"),
    "compatible": MessageLookupByLibrary.simpleMessage("兼容模式"),
    "confirm": MessageLookupByLibrary.simpleMessage("确定"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage("确定要清除所有数据？"),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "确定要删除当前策略组吗？",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage("确定要退出当前窗口吗？"),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage("确定要强制崩溃核心？"),
    "congestionControl": MessageLookupByLibrary.simpleMessage("拥塞控制"),
    "congestionController": MessageLookupByLibrary.simpleMessage("TCP 拥塞控制"),
    "congestionControllerDesc": MessageLookupByLibrary.simpleMessage(
      "TCP 拥塞控制仅在 mips 栈生效。",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("已连接"),
    "connecting": MessageLookupByLibrary.simpleMessage("连接中…"),
    "connection": MessageLookupByLibrary.simpleMessage("连接"),
    "connectionAddDomainRule": MessageLookupByLibrary.simpleMessage("为该域名添加规则"),
    "connectionBlockedLabel": MessageLookupByLibrary.simpleMessage("已拦截"),
    "connectionCloseThis": MessageLookupByLibrary.simpleMessage("关闭此连接"),
    "connectionGroup": MessageLookupByLibrary.simpleMessage("分组"),
    "connectionLocalDevice": MessageLookupByLibrary.simpleMessage("本机"),
    "connectionMatchedRule": MessageLookupByLibrary.simpleMessage("命中规则"),
    "connectionProcessPath": MessageLookupByLibrary.simpleMessage("进程路径"),
    "connectionSearchHint": MessageLookupByLibrary.simpleMessage("搜索域名、应用或规则"),
    "connectionSniffedDomain": MessageLookupByLibrary.simpleMessage("嗅探到的域名"),
    "connectionSourceAddress": MessageLookupByLibrary.simpleMessage("源地址"),
    "connectionStartTime": MessageLookupByLibrary.simpleMessage("开始时间"),
    "connectionStats": MessageLookupByLibrary.simpleMessage("连接统计"),
    "connectionStatsDesc": MessageLookupByLibrary.simpleMessage(
      "实时连接、最近请求、DNS查询",
    ),
    "connectionSummary": m26,
    "connectionSustained": MessageLookupByLibrary.simpleMessage("持续"),
    "connectionTargetIp": MessageLookupByLibrary.simpleMessage("目标 IP"),
    "connectionTrafficPath": MessageLookupByLibrary.simpleMessage("流量路径"),
    "connections": MessageLookupByLibrary.simpleMessage("连接"),
    "connectionsAndRequests": MessageLookupByLibrary.simpleMessage("连接与请求"),
    "connectionsLiveShort": MessageLookupByLibrary.simpleMessage("实时"),
    "connectivity": MessageLookupByLibrary.simpleMessage("连通性："),
    "content": MessageLookupByLibrary.simpleMessage("内容"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage("内容不能为空"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage("控制全局附加规则"),
    "copy": MessageLookupByLibrary.simpleMessage("复制"),
    "copyAsBase64": MessageLookupByLibrary.simpleMessage("复制为 Base64"),
    "copyAsCurl": MessageLookupByLibrary.simpleMessage("复制为 cURL"),
    "copyDestination": MessageLookupByLibrary.simpleMessage("复制目标地址"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage("复制环境变量"),
    "copyHost": MessageLookupByLibrary.simpleMessage("复制主机"),
    "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
    "copyRequest": MessageLookupByLibrary.simpleMessage("复制请求"),
    "copyResponse": MessageLookupByLibrary.simpleMessage("复制响应"),
    "copyResponseBody": MessageLookupByLibrary.simpleMessage("复制响应体"),
    "copySubscriptionLink": MessageLookupByLibrary.simpleMessage("复制订阅链接"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("复制成功"),
    "core": MessageLookupByLibrary.simpleMessage("内核"),
    "coreBlockedByPolicyTip": m27,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Windows 智能应用控制拦截了未签名的 TianjiCloudCore.exe。请打开 Windows 安全中心 → 应用和浏览器控制 → 智能应用控制设置，选择「关闭」后重新启动天机云。智能应用控制关闭后无法再开启，除非重装 Windows。",
    ),
    "coreStatus": MessageLookupByLibrary.simpleMessage("核心状态"),
    "country": MessageLookupByLibrary.simpleMessage("区域"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("检测到崩溃"),
    "crashDetectedTip": m28,
    "crashTest": MessageLookupByLibrary.simpleMessage("崩溃测试"),
    "create": MessageLookupByLibrary.simpleMessage("创建"),
    "createProfileFromUrlTip": m29,
    "creationTime": MessageLookupByLibrary.simpleMessage("创建时间"),
    "currentExpiry": MessageLookupByLibrary.simpleMessage("到期"),
    "currentOutboundDesc": MessageLookupByLibrary.simpleMessage("含启动键，不可移除"),
    "currentUsage": MessageLookupByLibrary.simpleMessage("本期已用"),
    "custom": MessageLookupByLibrary.simpleMessage("自定义"),
    "customAddProxy": MessageLookupByLibrary.simpleMessage("添加代理"),
    "customColor": MessageLookupByLibrary.simpleMessage("自定义颜色"),
    "customGroupMemberSummary": m30,
    "customGroupRuleUsage": m31,
    "customGroupsLabel": MessageLookupByLibrary.simpleMessage("分组"),
    "customImportDroppedSubRules": m32,
    "customImportFromLink": MessageLookupByLibrary.simpleMessage("从链接导入"),
    "customIssueCoreRejected": m33,
    "customIssueDialerLoop": m34,
    "customIssueDuplicateName": m35,
    "customIssueEmptyName": MessageLookupByLibrary.simpleMessage("名称为空"),
    "customIssueGroupLoop": m36,
    "customIssueInvalidEmptyFallback": m37,
    "customIssueInvalidFilter": m38,
    "customIssueMissingDialer": m39,
    "customIssueMissingProviders": m40,
    "customIssueMissingProxies": m41,
    "customIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "未选择任何代理或代理集，内核会拒绝该策略组",
    ),
    "customIssueReservedName": m42,
    "customIssuesSummary": m43,
    "customPreviewMerged": MessageLookupByLibrary.simpleMessage("预览合并结果"),
    "customProfile": MessageLookupByLibrary.simpleMessage("自定义"),
    "customProvidersAndDialers": MessageLookupByLibrary.simpleMessage("提供者与拨号"),
    "customProxyCardTitle": MessageLookupByLibrary.simpleMessage("自定义代理"),
    "customProxyGroupUsage": m44,
    "customProxySubscriptionNote": MessageLookupByLibrary.simpleMessage(
      "订阅里的代理会与这里的代理一起显示。",
    ),
    "customProxyUnreferenced": MessageLookupByLibrary.simpleMessage("未被引用"),
    "customResources": MessageLookupByLibrary.simpleMessage("自定义"),
    "customRuleCardTitle": MessageLookupByLibrary.simpleMessage("我的规则"),
    "customRulePresets": MessageLookupByLibrary.simpleMessage("从预设添加"),
    "cut": MessageLookupByLibrary.simpleMessage("剪切"),
    "dark": MessageLookupByLibrary.simpleMessage("深色"),
    "dashboard": MessageLookupByLibrary.simpleMessage("仪表盘"),
    "dashboardAddableSection": MessageLookupByLibrary.simpleMessage("可添加"),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "保存更改失败，已回滚",
    ),
    "daysAgo": m45,
    "daysAgoShort": m46,
    "daysUnit": MessageLookupByLibrary.simpleMessage("天"),
    "decryptUntrusted": MessageLookupByLibrary.simpleMessage("本机未信任时也解密"),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "用于解析其他 DNS 服务器的域名，只能填写 IP 地址。",
    ),
    "defaultSelected": MessageLookupByLibrary.simpleMessage("默认选中"),
    "defaultText": MessageLookupByLibrary.simpleMessage("默认"),
    "definitionNotMap": MessageLookupByLibrary.simpleMessage(
      "配置必须是包含 name 和 type 的 YAML 映射",
    ),
    "delay": MessageLookupByLibrary.simpleMessage("延迟"),
    "delayFailed": MessageLookupByLibrary.simpleMessage("失败"),
    "delayTest": MessageLookupByLibrary.simpleMessage("延迟测试"),
    "delayTestTimeout": MessageLookupByLibrary.simpleMessage("延迟测试超时"),
    "delete": MessageLookupByLibrary.simpleMessage("删除"),
    "deleteMultipTip": m47,
    "deleteTip": m48,
    "desc": MessageLookupByLibrary.simpleMessage(
      "基于ClashMeta的多平台代理客户端，简单易用，开源无广告。",
    ),
    "desktopAsnDescription": MessageLookupByLibrary.simpleMessage("自治系统数据库"),
    "desktopFakeIpExplanation": MessageLookupByLibrary.simpleMessage(
      "198.18.0.0/16 为 fake-ip 映射地址，真实解析在出口端完成，不经本地运营商",
    ),
    "desktopGeoIpDescription": MessageLookupByLibrary.simpleMessage("IP 归属地库"),
    "desktopGeoSiteDescription": MessageLookupByLibrary.simpleMessage("域名分类库"),
    "desktopResourceLatest": MessageLookupByLibrary.simpleMessage("已是最新"),
    "desktopResourceUpdateNote": m49,
    "desktopRuleSetDescription": MessageLookupByLibrary.simpleMessage(
      "订阅下发规则集",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("目标地址"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage("目标地理定位"),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("目标IP ASN"),
    "details": m50,
    "detectionTip": MessageLookupByLibrary.simpleMessage("依赖第三方api，仅供参考"),
    "developerMode": MessageLookupByLibrary.simpleMessage("开发者模式"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage("开发者模式已启用。"),
    "diagnosticsFailed": MessageLookupByLibrary.simpleMessage("未通过"),
    "diagnosticsPassed": MessageLookupByLibrary.simpleMessage("通过"),
    "diagnosticsRunAgain": MessageLookupByLibrary.simpleMessage("重新诊断"),
    "diagnosticsSelection": MessageLookupByLibrary.simpleMessage("默认路径出口校验"),
    "diagnosticsStart": MessageLookupByLibrary.simpleMessage("开始诊断"),
    "diagnosticsTitle": MessageLookupByLibrary.simpleMessage("一键诊断"),
    "diagnosticsUnavailableNotice": MessageLookupByLibrary.simpleMessage(
      "暂不提供 DNS 出口、浏览器 WebRTC 和 NTP 检测。",
    ),
    "diagnosticsUnverified": MessageLookupByLibrary.simpleMessage("未能检测"),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("拨号代理"),
    "dialerProxyLoopStopped": m51,
    "dialog": MessageLookupByLibrary.simpleMessage("对话框"),
    "direct": MessageLookupByLibrary.simpleMessage("直连"),
    "directNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "用于解析直连连接的域名。",
    ),
    "disableIcmpForwarding": MessageLookupByLibrary.simpleMessage("禁用ICMP转发"),
    "disableIcmpForwardingDesc": MessageLookupByLibrary.simpleMessage(
      "禁用 ICMP 转发后由虚拟网卡直接应答 ping，ping 将不再显示真实延迟。",
    ),
    "disableKeepAlive": MessageLookupByLibrary.simpleMessage("禁用 TCP 保持活动"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("禁用UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("已关闭"),
    "discardChanges": MessageLookupByLibrary.simpleMessage("是否放弃更改？"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("免责声明"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "本声明是对软件性质、风险与责任的说明，不是 GPL-3.0 之外的附加条款，也不限制该协议授予你的运行、复制、修改和分发等任何权利；两者不一致时，以 GPL-3.0 为准。",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage("与开源协议的关系"),
    "disclaimerAcknowledgeLabel": MessageLookupByLibrary.simpleMessage(
      "我已阅读并理解此声明",
    ),
    "disclaimerAcknowledgeTip": MessageLookupByLibrary.simpleMessage(
      "为确认你已知悉，请阅读以下声明并勾选下方选项：",
    ),
    "disclaimerAcknowledgeTitle": MessageLookupByLibrary.simpleMessage("确认声明"),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "本声明可能随版本更新而修订，以每个版本附带的内容为准。",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage("声明变更"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "在使用天机云（以下简称“本软件”）前，请仔细阅读并充分理解本声明。点击“同意”表示你已阅读并理解以下内容；如不想继续，可点击“退出”。",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "在适用法律允许的最大范围内，开发者及所有贡献者均不对因使用或无法使用本软件而产生的任何直接、间接、偶然、特殊、惩罚性或后果性损害承担责任，包括但不限于数据丢失、设备损坏、网络异常、业务中断、利润损失或因此引起的任何法律纠纷，即使已被告知发生此类损害的可能性。",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage("责任限制"),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "本软件以 GPL-3.0 协议开源，你可以依该协议运行、研究、修改和分发本软件；分发本软件或其修改版本时，须同样以 GPL-3.0 协议提供源代码并保留原有的版权声明。\n\n本软件包含的第三方组件（包括 Clash.Meta 内核）分别遵循其各自的开源协议。基于本软件修改或分发的版本所产生的任何问题，与原作者无关。",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage("开源协议"),
    "disclaimerNoServiceStatement": MessageLookupByLibrary.simpleMessage(
      "本软件自身不提供任何代理服务器、节点、订阅、机场或网络接入服务，也不与任何此类服务的提供者存在合作、代理或担保关系。",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "本软件不会收集或上传你的订阅地址、节点信息、配置内容、访问的网站、连接记录、流量内容和日志，这些数据仅保存在你的设备本地，开发者无法获取。\n\n本软件只会在你使用相应功能时访问外部网络，例如更新订阅时访问你提供的订阅地址、检查更新时访问 GitHub。\n\n本软件在所有平台上均未集成任何数据统计或崩溃上报服务。",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage("数据收集与隐私"),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "你应自行确认使用本软件在你所在国家或地区是合法的，并对使用本软件的全部行为及其后果独立承担法律责任。\n\n你导入的订阅、节点与配置由你自行选择和判断，其来源是否合法、内容是否安全、服务是否稳定，均由你与相关提供者自行负责。",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "用户责任",
    ),
    "disclaimerRestateHint": MessageLookupByLibrary.simpleMessage("在此输入上述声明"),
    "disclaimerRestateMismatch": MessageLookupByLibrary.simpleMessage(
      "与声明内容不一致",
    ),
    "disclaimerRestateTip": MessageLookupByLibrary.simpleMessage(
      "为确认你已知悉，请在下方输入框中完整复述以下声明：",
    ),
    "disclaimerRestateTitle": MessageLookupByLibrary.simpleMessage("复述声明"),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "本软件是基于 Clash.Meta（mihomo）内核的开源网络代理客户端，仅提供配置管理、规则分流与流量转发等本地工具功能。",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage("软件性质"),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "订阅链接、配置文件、规则集、脚本、外部资源及外部链接均由第三方提供，开发者无法也不会对其合法性、准确性、安全性和可用性进行审查或担保。\n\n因使用第三方内容导致的数据泄露、财产损失、账号封禁或其他任何损失，由你与第三方自行解决，开发者不承担任何责任。",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage("第三方内容"),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "任何人基于本软件开展的商业活动，包括付费分发、捆绑销售或作为商业服务的组成部分，均与本软件的开发者无关，开发者不为其提供背书、支持或担保。\n\n你须自行遵守所在国家或地区的法律法规，因违法使用本软件产生的后果由你自行承担。",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage("使用说明"),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "本软件按“现状”和“可用”的原则提供，不附带任何明示或默示的担保，包括但不限于适销性、特定用途适用性、不侵权以及持续可用、无错误、无安全漏洞的担保。\n\n开发者不保证本软件能满足你的需求，也不保证本软件的运行不会中断或不会出现错误。",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage("无担保声明"),
    "disconnected": MessageLookupByLibrary.simpleMessage("已断开"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage("发现新版本"),
    "dnsBlocked": MessageLookupByLibrary.simpleMessage("已拦截"),
    "dnsCacheCleared": MessageLookupByLibrary.simpleMessage("DNS缓存已清除"),
    "dnsExit": MessageLookupByLibrary.simpleMessage("DNS 出口"),
    "dnsExitUnavailable": MessageLookupByLibrary.simpleMessage("暂无检测结果"),
    "dnsHandling": MessageLookupByLibrary.simpleMessage("处理"),
    "dnsHijackDesc": MessageLookupByLibrary.simpleMessage(
      "未添加时劫持所有发往 53 端口的 DNS 请求（any:53）。",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS劫持"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS模式"),
    "dnsOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "添加的项会覆写所有 URL 和文件配置的 DNS，未添加的项沿用配置自身的设置。自定义配置的 DNS 在其内容中设置。",
    ),
    "dnsProxyRoute": MessageLookupByLibrary.simpleMessage("走代理"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNS 查询"),
    "dnsResourcesDesktop": MessageLookupByLibrary.simpleMessage("DNS 与资源"),
    "dnsUpstream": MessageLookupByLibrary.simpleMessage("上游"),
    "docked": MessageLookupByLibrary.simpleMessage("固定"),
    "domain": MessageLookupByLibrary.simpleMessage("域名"),
    "done": MessageLookupByLibrary.simpleMessage("完成"),
    "download": MessageLookupByLibrary.simpleMessage("下载"),
    "downloadBandwidth": MessageLookupByLibrary.simpleMessage("下行带宽"),
    "downloadingUpdate": MessageLookupByLibrary.simpleMessage("正在下载更新"),
    "duration": MessageLookupByLibrary.simpleMessage("时长"),
    "edit": MessageLookupByLibrary.simpleMessage("编辑"),
    "editDashboard": MessageLookupByLibrary.simpleMessage("编辑仪表盘"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage("编辑全局规则"),
    "editProxy": MessageLookupByLibrary.simpleMessage("编辑代理"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("编辑策略组"),
    "editRule": MessageLookupByLibrary.simpleMessage("编辑规则"),
    "editSsid": MessageLookupByLibrary.simpleMessage("编辑SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage("编辑器不可用"),
    "elapsed": MessageLookupByLibrary.simpleMessage("耗时"),
    "emptyFallback": MessageLookupByLibrary.simpleMessage("空组兜底"),
    "emptyTip": m52,
    "en": MessageLookupByLibrary.simpleMessage("英语"),
    "enabled": MessageLookupByLibrary.simpleMessage("已开启"),
    "entries": MessageLookupByLibrary.simpleMessage("个条目"),
    "error": MessageLookupByLibrary.simpleMessage("错误"),
    "errorDetails": MessageLookupByLibrary.simpleMessage("错误详情"),
    "es": MessageLookupByLibrary.simpleMessage("西班牙语"),
    "exclude": MessageLookupByLibrary.simpleMessage("从最近任务中隐藏"),
    "excludeDstPort": MessageLookupByLibrary.simpleMessage("排除目标端口"),
    "excludeFilter": MessageLookupByLibrary.simpleMessage("排除筛选"),
    "excludeInterface": MessageLookupByLibrary.simpleMessage("排除网卡"),
    "excludeSrcPort": MessageLookupByLibrary.simpleMessage("排除源端口"),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("排除SSIDs"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "连接到被排除 SSID 的 Wi-Fi 时，将会自动切换应用运行状态。",
    ),
    "excludeUid": MessageLookupByLibrary.simpleMessage("排除用户 ID"),
    "existsTip": m53,
    "exit": MessageLookupByLibrary.simpleMessage("退出"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage("退出全屏"),
    "exitNodes": MessageLookupByLibrary.simpleMessage("出口节点"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("预期状态"),
    "expireTime": MessageLookupByLibrary.simpleMessage("到期时间"),
    "expiredStatus": MessageLookupByLibrary.simpleMessage("已过期"),
    "exportCertificate": MessageLookupByLibrary.simpleMessage("导出证书"),
    "exportFile": MessageLookupByLibrary.simpleMessage("导出文件"),
    "exportHar": MessageLookupByLibrary.simpleMessage("导出 HAR"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("导出日志"),
    "exportShort": MessageLookupByLibrary.simpleMessage("导出"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("导出成功"),
    "extend": MessageLookupByLibrary.simpleMessage("扩展"),
    "extendMode": MessageLookupByLibrary.simpleMessage("扩展模式"),
    "extendOverridesScripts": MessageLookupByLibrary.simpleMessage("扩展覆写与脚本"),
    "extendScript": MessageLookupByLibrary.simpleMessage("扩展脚本"),
    "externalController": MessageLookupByLibrary.simpleMessage("外部控制器"),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "外部控制器开启后，可通过 9090 端口控制内核。",
    ),
    "externalControllerSecret": MessageLookupByLibrary.simpleMessage("外部控制器密钥"),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部链接"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("超大"),
    "fade": MessageLookupByLibrary.simpleMessage("淡入"),
    "failedCount": m54,
    "failedItem": m55,
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fake-IP过滤"),
    "fakeipFilterDesc": MessageLookupByLibrary.simpleMessage(
      "这些域名不使用 Fake-IP，返回真实 IP；过滤模式为 whitelist 时则只有它们使用 Fake-IP。",
    ),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage("Fake-IP过滤模式"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fake-IP范围"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage("Fake-IP范围（IPv6）"),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("Fake-IP TTL"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Nameserver 的结果被 Fallback 过滤判定为污染时，改用这些服务器的结果。",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback过滤"),
    "fallbackFilterDomainDesc": MessageLookupByLibrary.simpleMessage(
      "这些域名直接使用 Fallback 解析。",
    ),
    "fallbackFilterGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "属于这些 GeoSite 分类的域名直接使用 Fallback 解析。",
    ),
    "fallbackFilterIpcidrDesc": MessageLookupByLibrary.simpleMessage(
      "Nameserver 返回这些网段内的 IP 时，改用 Fallback 的结果。",
    ),
    "file": MessageLookupByLibrary.simpleMessage("文件"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage("文件有修改，是否保存修改"),
    "filter": MessageLookupByLibrary.simpleMessage("筛选"),
    "filters": MessageLookupByLibrary.simpleMessage("筛选"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("查找进程"),
    "floating": MessageLookupByLibrary.simpleMessage("悬浮"),
    "followProfile": MessageLookupByLibrary.simpleMessage("跟随配置"),
    "followSystem": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("字体"),
    "fontSize": MessageLookupByLibrary.simpleMessage("大小"),
    "forceDnsMapping": MessageLookupByLibrary.simpleMessage("强制DNS映射"),
    "forceDnsMappingDesc": MessageLookupByLibrary.simpleMessage(
      "强制 DNS 映射对通过 DNS 映射得到域名的连接也进行嗅探。",
    ),
    "forceDomain": MessageLookupByLibrary.simpleMessage("强制嗅探域名"),
    "forceDomainDesc": MessageLookupByLibrary.simpleMessage(
      "强制嗅探域名中的域名同样会被嗅探，其余已有域名的连接不嗅探。",
    ),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要强制重启核心吗？"),
    "fr": MessageLookupByLibrary.simpleMessage("法语"),
    "general": MessageLookupByLibrary.simpleMessage("常规"),
    "generalOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "添加的项会覆写所有配置的对应设置，未添加的项沿用配置自身的设置，配置未设置时使用内核默认值。",
    ),
    "generateCertificate": MessageLookupByLibrary.simpleMessage("生成证书"),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo"),
    "geoSkipped": m56,
    "geoUpdated": m57,
    "geodataLoader": MessageLookupByLibrary.simpleMessage("Geo低内存模式"),
    "global": MessageLookupByLibrary.simpleMessage("全局"),
    "go": MessageLookupByLibrary.simpleMessage("前往"),
    "goDownload": MessageLookupByLibrary.simpleMessage("前往下载"),
    "goToConfigureAddedRules": MessageLookupByLibrary.simpleMessage("前往配置附加规则"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage("前往配置脚本"),
    "grid": MessageLookupByLibrary.simpleMessage("网格"),
    "groupBy": MessageLookupByLibrary.simpleMessage("按"),
    "groupCount": m58,
    "groupCountUnit": MessageLookupByLibrary.simpleMessage("个"),
    "groupTimeoutCount": m59,
    "hasCacheChange": MessageLookupByLibrary.simpleMessage("是否缓存修改"),
    "hashByInUser": MessageLookupByLibrary.simpleMessage("按入站用户哈希"),
    "headerRewrite": MessageLookupByLibrary.simpleMessage("Header 重写"),
    "healthCheck": MessageLookupByLibrary.simpleMessage("健康检查"),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Helper 服务不可用，无法启用 TUN 模式，请重新安装天机云。",
    ),
    "hex": MessageLookupByLibrary.simpleMessage("十六进制"),
    "hideFromList": MessageLookupByLibrary.simpleMessage("从列表中隐藏"),
    "hideIp": MessageLookupByLibrary.simpleMessage("隐藏 IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("隐藏密码"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage("隐藏超时代理"),
    "hopInterval": MessageLookupByLibrary.simpleMessage("跳跃间隔"),
    "host": MessageLookupByLibrary.simpleMessage("主机"),
    "hostname": MessageLookupByLibrary.simpleMessage("主机名"),
    "hotkeyConflictWith": m60,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "全局快捷键在窗口隐藏时依然生效，点击操作即可录制组合键。",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("快捷键管理"),
    "hotkeyNeedsModifier": m61,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("未设置"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "未能注册，可能已被其他应用占用",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("小时"),
    "hoursAgo": m62,
    "hoursAgoShort": m63,
    "http2": MessageLookupByLibrary.simpleMessage("HTTP/2"),
    "httpBodyNotKept": MessageLookupByLibrary.simpleMessage("内存紧张时未记录这段内容。"),
    "httpBodyProtobufGuess": MessageLookupByLibrary.simpleMessage(
      "按 Protobuf 解析，没有 .proto：只有字段编号，类型是推测的。",
    ),
    "httpBodyTruncated": MessageLookupByLibrary.simpleMessage("只记录了这段内容的开头部分。"),
    "httpBodyUndecoded": m64,
    "httpCapture": MessageLookupByLibrary.simpleMessage("抓包"),
    "httpCaptureDesc": MessageLookupByLibrary.simpleMessage(
      "记录“主机名”中列出的主机的请求，在连接详情中查看。记录只保存在内存中。",
    ),
    "httpCaptureLimit": MessageLookupByLibrary.simpleMessage("最多记录条数"),
    "httpCaptureLimitDesc": m65,
    "httpCaptureNoHosts": MessageLookupByLibrary.simpleMessage(
      "未列出任何主机，不会记录内容。请在 MITM 页的“主机名”中添加，或在连接详情中加入。",
    ),
    "httpCaptureOff": MessageLookupByLibrary.simpleMessage("抓包未开启"),
    "httpExportPrivate": MessageLookupByLibrary.simpleMessage(
      "请求里可能有 Cookie、令牌、密码和表单内容，分享前请确认内容和对象。",
    ),
    "httpExportPrivateTitle": MessageLookupByLibrary.simpleMessage("包含隐私信息"),
    "httpRequestCleared": MessageLookupByLibrary.simpleMessage("这条请求的记录已清除"),
    "httpRequests": MessageLookupByLibrary.simpleMessage("HTTP 请求"),
    "httpRequestsMissing": MessageLookupByLibrary.simpleMessage(
      "抓包开启前发出或已被清除的请求不在列表中。",
    ),
    "httpsDecryption": MessageLookupByLibrary.simpleMessage("HTTPS 解密"),
    "hue": MessageLookupByLibrary.simpleMessage("色相"),
    "icon": MessageLookupByLibrary.simpleMessage("图标"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("图标记录"),
    "iconSets": MessageLookupByLibrary.simpleMessage("图标集"),
    "iconSetsEmptyTip": MessageLookupByLibrary.simpleMessage(
      "暂无图标集，可在「自定义配置资源 → 图标集」中添加",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("图标样式"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("色块"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("隐藏"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("纯图标"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("图标链接"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage("忽略电池优化"),
    "immediateUpdate": MessageLookupByLibrary.simpleMessage("立即更新"),
    "import": MessageLookupByLibrary.simpleMessage("导入"),
    "importConfigInvalid": MessageLookupByLibrary.simpleMessage("此文件不是可导入的配置"),
    "importConfigReplaceTip": MessageLookupByLibrary.simpleMessage(
      "导入会替换此配置现有的策略组、规则和设置",
    ),
    "importFile": MessageLookupByLibrary.simpleMessage("通过文件导入"),
    "importFromLink": MessageLookupByLibrary.simpleMessage("从链接导入"),
    "importSubscription": MessageLookupByLibrary.simpleMessage("导入订阅"),
    "importUrl": MessageLookupByLibrary.simpleMessage("通过URL导入"),
    "inProgress": MessageLookupByLibrary.simpleMessage("进行中"),
    "inUse": MessageLookupByLibrary.simpleMessage("使用中"),
    "inbound": MessageLookupByLibrary.simpleMessage("入站"),
    "includeInterface": MessageLookupByLibrary.simpleMessage("包含网卡"),
    "includeInterfaceDesc": MessageLookupByLibrary.simpleMessage(
      "只有从包含网卡进入的流量经过虚拟网卡，设置后排除网卡不再生效。",
    ),
    "includeUid": MessageLookupByLibrary.simpleMessage("包含用户 ID"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("长期有效"),
    "init": MessageLookupByLibrary.simpleMessage("初始化"),
    "initFailed": MessageLookupByLibrary.simpleMessage("启动失败"),
    "initFailedTip": MessageLookupByLibrary.simpleMessage(
      "天机云启动时出错，无法继续运行。可以复制错误详情用于反馈；如果问题反复出现，清除数据后通常可以重新启动。",
    ),
    "initiator": MessageLookupByLibrary.simpleMessage("发起方"),
    "initiatorShort": MessageLookupByLibrary.simpleMessage("发起"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage("输入策略组名称"),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage("输入规则内容"),
    "installCertificate": MessageLookupByLibrary.simpleMessage("安装到系统"),
    "installCertificateSuccess": MessageLookupByLibrary.simpleMessage("证书已安装"),
    "installedAppsPermissionDeniedMessage":
        MessageLookupByLibrary.simpleMessage(
          "读取应用列表权限已被拒绝，无法获取已安装的应用。请前往系统设置手动开启。",
        ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "当前系统在授权前不会提供已安装的应用列表，授权后即可配置分应用代理。",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "需要读取应用列表权限",
    ),
    "installedFonts": MessageLookupByLibrary.simpleMessage("已安装字体"),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("智能选择"),
    "intercept": MessageLookupByLibrary.simpleMessage("拦截"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("网卡名称"),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage("出站网卡"),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("清空"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("自定义"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage("跟随配置"),
    "internet": MessageLookupByLibrary.simpleMessage("互联网"),
    "interval": MessageLookupByLibrary.simpleMessage("间隔"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("内网 IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage("无效备份文件"),
    "invalidCidrContent": MessageLookupByLibrary.simpleMessage(
      "请输入 CIDR 格式的 IP 段，如 192.168.0.0/16",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "DSCP 标记不能超过 63",
    ),
    "invalidHostContent": MessageLookupByLibrary.simpleMessage("请输入域名或 IP 地址"),
    "invalidIconSet": MessageLookupByLibrary.simpleMessage("不是有效的图标集"),
    "invalidLinkTip": MessageLookupByLibrary.simpleMessage("不是有效的订阅链接或代理分享链接"),
    "invalidListenContent": MessageLookupByLibrary.simpleMessage(
      "请输入地址和端口，如 0.0.0.0:1053",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "仅支持 tcp 或 udp",
    ),
    "invalidOfCount": m66,
    "invalidPolicy": m67,
    "invalidPortRangeContent": MessageLookupByLibrary.simpleMessage(
      "请输入端口或范围，如 443 或 8000-9000",
    ),
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "该二维码不包含配置文件链接",
    ),
    "invalidProxy": m68,
    "invalidProxyProvider": m69,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "请输入数字或范围，如 80 或 8000-9000，多个用 / 分隔",
    ),
    "invalidRuleSet": m70,
    "invalidSubRule": m71,
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP 地址"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("滥用记录"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("代理"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("命中标记"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("组织"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage("类型查询失败"),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("优"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("等级"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("普通"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("重新查询"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("风险"),
    "ipQualityShort": MessageLookupByLibrary.simpleMessage("质量"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("采用来源"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("各来源"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage("出站 IP 不一致"),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("无法判定类型"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage("限流"),
    "ipType": MessageLookupByLibrary.simpleMessage("类型"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("商业"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("机房"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("移动网络"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("住宅"),
    "ipTypeUnknown": MessageLookupByLibrary.simpleMessage("类型未知"),
    "ipVersion": MessageLookupByLibrary.simpleMessage("IP 版本"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage("开启 IPv6 后才会接收 IPv6 流量。"),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("IPv6超时（毫秒）"),
    "itemsCount": m72,
    "ja": MessageLookupByLibrary.simpleMessage("日语"),
    "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
    "keepAliveIdle": MessageLookupByLibrary.simpleMessage("TCP 保持活动空闲时间"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage("TCP保持活动间隔"),
    "key": MessageLookupByLibrary.simpleMessage("键"),
    "ko": MessageLookupByLibrary.simpleMessage("韩语"),
    "label": MessageLookupByLibrary.simpleMessage("标签"),
    "language": MessageLookupByLibrary.simpleMessage("语言"),
    "large": MessageLookupByLibrary.simpleMessage("大"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("上次更新"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage("启动未完成"),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "应用上次在启动过程中意外退出。已跳过本次自动配置，你可以手动启动重试。",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("布局"),
    "light": MessageLookupByLibrary.simpleMessage("浅色"),
    "lineIssueTip": m73,
    "lineRate": MessageLookupByLibrary.simpleMessage("倍率"),
    "lineWrap": MessageLookupByLibrary.simpleMessage("自动换行"),
    "link": MessageLookupByLibrary.simpleMessage("链接"),
    "liquidGlass": MessageLookupByLibrary.simpleMessage("液态玻璃"),
    "list": MessageLookupByLibrary.simpleMessage("列表"),
    "listen": MessageLookupByLibrary.simpleMessage("监听"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage("监听路由标记"),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage(
      "监听路由标记仅在 Linux 生效。",
    ),
    "liveConnections": MessageLookupByLibrary.simpleMessage("实时连接"),
    "loading": MessageLookupByLibrary.simpleMessage("加载中…"),
    "local": MessageLookupByLibrary.simpleMessage("本地"),
    "localFile": MessageLookupByLibrary.simpleMessage("本地文件"),
    "localImage": MessageLookupByLibrary.simpleMessage("本地图片"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "本地网络权限被拒绝：已改用 gvisor 栈，局域网无法访问。",
    ),
    "localProxies": MessageLookupByLibrary.simpleMessage("本地代理"),
    "locationPermission": MessageLookupByLibrary.simpleMessage("位置权限"),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "位置权限已被拒绝，无法获取当前 Wi-Fi 名称。请前往系统设置手动开启位置权限。",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "根据系统要求，获取Wi-Fi名称需要您授予位置权限。Android 上请选择“始终允许”，否则应用在后台时无法获取 Wi-Fi 名称。",
    ),
    "locationPermissionGuide": m74,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "需要位置权限",
    ),
    "log": MessageLookupByLibrary.simpleMessage("日志"),
    "logFilterError": MessageLookupByLibrary.simpleMessage("错误"),
    "logFilterInfo": MessageLookupByLibrary.simpleMessage("信息"),
    "logFilterWarning": MessageLookupByLibrary.simpleMessage("警告"),
    "logLevel": MessageLookupByLibrary.simpleMessage("日志等级"),
    "logcat": MessageLookupByLibrary.simpleMessage("日志捕获"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage("关闭日志捕获会隐藏日志入口。"),
    "logs": MessageLookupByLibrary.simpleMessage("日志"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage("日志与诊断"),
    "logsRunning": MessageLookupByLibrary.simpleMessage("运行日志"),
    "logsTest": MessageLookupByLibrary.simpleMessage("日志测试"),
    "loopback": MessageLookupByLibrary.simpleMessage("UWP 回环解锁"),
    "loose": MessageLookupByLibrary.simpleMessage("宽松"),
    "mainlandDirect": MessageLookupByLibrary.simpleMessage("内地直连"),
    "mapLocal": MessageLookupByLibrary.simpleMessage("本地映射"),
    "matchCase": MessageLookupByLibrary.simpleMessage("区分大小写"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("匹配来源IP"),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "matchedRules": MessageLookupByLibrary.simpleMessage("命中的规则"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("最大失败次数"),
    "maxLengthTip": m75,
    "maximize": MessageLookupByLibrary.simpleMessage("最大化"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage("常驻内存"),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("应用及共享"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("堆内存空闲"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("堆内存使用中"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage("内核未运行"),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage("运行时开销"),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("协程栈"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "基于进程常驻内存估算，可能与系统显示的数值不同。",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "内核与应用运行在同一进程，内核部分按运行时统计估算，其余计入应用及共享内存。",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("内存信息"),
    "memoryInfoDesc": MessageLookupByLibrary.simpleMessage("应用与内核占用的内存"),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("内存已释放"),
    "memoryReleasedSize": m76,
    "messageTest": MessageLookupByLibrary.simpleMessage("消息测试"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("这是一条消息。"),
    "method": MessageLookupByLibrary.simpleMessage("方法"),
    "minimize": MessageLookupByLibrary.simpleMessage("最小化"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("退出时最小化"),
    "minutes": MessageLookupByLibrary.simpleMessage("分钟"),
    "minutesAgo": m77,
    "minutesAgoShort": m78,
    "mitm": MessageLookupByLibrary.simpleMessage("MITM"),
    "mitmAddLocalFile": MessageLookupByLibrary.simpleMessage("添加本地文件"),
    "mitmAddMapLocalRule": MessageLookupByLibrary.simpleMessage("添加本地映射规则"),
    "mitmAddRejectRule": MessageLookupByLibrary.simpleMessage("添加拒绝规则"),
    "mitmAttachments": MessageLookupByLibrary.simpleMessage("附件"),
    "mitmAttachmentsDesc": MessageLookupByLibrary.simpleMessage(
      "行内按文件名引用附件，如 script-path=a.js。",
    ),
    "mitmCertificateAndroidReadyTip": MessageLookupByLibrary.simpleMessage(
      "只有信任用户证书的应用（多为浏览器）会被解密。",
    ),
    "mitmCertificateExportTip": MessageLookupByLibrary.simpleMessage(
      "导出后在要解密的设备上信任此证书。",
    ),
    "mitmCertificateLinuxTip": MessageLookupByLibrary.simpleMessage(
      "Flatpak 版浏览器需要手动导入导出的证书。",
    ),
    "mitmCertificateSavedTip": m79,
    "mitmCertutilMissing": m80,
    "mitmClientRefusedCertificate": MessageLookupByLibrary.simpleMessage(
      "客户端拒绝了证书。请安装证书；如果应用固定了证书，请排除此主机。",
    ),
    "mitmDecryptHost": MessageLookupByLibrary.simpleMessage("解密此主机"),
    "mitmDecryptHostTip": m81,
    "mitmEnableTip": MessageLookupByLibrary.simpleMessage(
      "开启后，天机云能读取发往被解密主机的全部内容，包括 Cookie 和密码。请只为需要改写的主机开启。",
    ),
    "mitmExcludeHost": MessageLookupByLibrary.simpleMessage("排除解密"),
    "mitmExcludeHostTip": m82,
    "mitmFileTooLarge": m83,
    "mitmHostnameDesc": MessageLookupByLibrary.simpleMessage(
      "以 - 开头表示排除，第一条匹配的生效。",
    ),
    "mitmIgnoredLines": MessageLookupByLibrary.simpleMessage("忽略的行"),
    "mitmInstallSystemCaTip": MessageLookupByLibrary.simpleMessage(
      "检测到 root，证书将以 Magisk、KernelSU 或 APatch 模块“TianjiCloud MITM CA”加入系统信任的根证书。之后本机所有应用都会信任它，持有其私钥的人可以解密本机的 HTTPS 流量。如需撤销，可重新生成证书，或在 root 管理器中移除该模块并重启。若拒绝 root 授权，将改为安装用户证书。",
    ),
    "mitmInstallUserCaTip": MessageLookupByLibrary.simpleMessage(
      "未检测到 root，证书只能安装为用户证书。只有信任用户证书的应用（多为浏览器）会被解密，其他应用访问列出的主机会失败，请不要列出它们的主机。Android 11 起需在系统设置中手动完成安装。",
    ),
    "mitmMissingStores": m84,
    "mitmModule": MessageLookupByLibrary.simpleMessage("模块"),
    "mitmModuleInvalid": MessageLookupByLibrary.simpleMessage(
      "这不是 Surge 模块、Loon 插件、Quantumult X 片段或 Stash 覆写",
    ),
    "mitmModuleRulesDesc": MessageLookupByLibrary.simpleMessage(
      "分流规则排在配置自身的规则之前。",
    ),
    "mitmModuleScriptsChanged": m85,
    "mitmModuleSystemTip": m86,
    "mitmModules": MessageLookupByLibrary.simpleMessage("模块"),
    "mitmNewModule": MessageLookupByLibrary.simpleMessage("新建模块"),
    "mitmOldCertificateLeftTip": m87,
    "mitmOldSystemCertificateLeftTip": m88,
    "mitmRemoveOldCertificateTip": m89,
    "mitmRootPendingReboot": MessageLookupByLibrary.simpleMessage(
      "证书将在重启手机后生效。",
    ),
    "mitmRootUntilReboot": MessageLookupByLibrary.simpleMessage(
      "未找到可保留证书的 Magisk、KernelSU 或 APatch，重启手机后需要重新安装。",
    ),
    "mitmRoutingRules": MessageLookupByLibrary.simpleMessage("分流规则"),
    "mitmRuleCopiedForStash": MessageLookupByLibrary.simpleMessage(
      "这个模块是 Stash 覆写，规则已复制，请手动添加。",
    ),
    "mitmRunScript": MessageLookupByLibrary.simpleMessage("立即运行"),
    "mitmScriptNoOutput": MessageLookupByLibrary.simpleMessage("脚本已运行完毕，没有输出"),
    "mitmScriptRisk": MessageLookupByLibrary.simpleMessage(
      "它的脚本能读取并修改所匹配主机的流量，包括 Cookie 和令牌，还能自行发送请求。只在信任其来源时开启。",
    ),
    "mitmScriptRiskTitle": MessageLookupByLibrary.simpleMessage("运行此模块的脚本？"),
    "mitmSkipConditional": MessageLookupByLibrary.simpleMessage("不支持条件重写"),
    "mitmSkipDisabled": MessageLookupByLibrary.simpleMessage("已被参数关闭"),
    "mitmSkipEvent": MessageLookupByLibrary.simpleMessage("不支持此事件"),
    "mitmSkipJq": MessageLookupByLibrary.simpleMessage("不支持 jq 重写"),
    "mitmSkipJsonBody": MessageLookupByLibrary.simpleMessage("不支持 JSON 正文重写"),
    "mitmSkipNotDownloaded": MessageLookupByLibrary.simpleMessage("其文件尚未下载"),
    "mitmSkipPolicy": MessageLookupByLibrary.simpleMessage(
      "只支持 DIRECT 和 REJECT 策略",
    ),
    "mitmSkipRawHeader": MessageLookupByLibrary.simpleMessage(
      "不支持把全部标头作为一段文本改写",
    ),
    "mitmSkipRelativeData": MessageLookupByLibrary.simpleMessage(
      "此行引用的文件不是附件，请改用 URL 或添加为附件",
    ),
    "mitmSkipRule": MessageLookupByLibrary.simpleMessage("不支持此规则类型"),
    "mitmSkipScriptType": MessageLookupByLibrary.simpleMessage("不支持此类脚本"),
    "mitmSkipSection": m90,
    "mitmSkipSetting": MessageLookupByLibrary.simpleMessage("不支持此设置"),
    "mitmSkipUnreadable": MessageLookupByLibrary.simpleMessage("无法识别此行"),
    "mitmSystemStoreFailed": MessageLookupByLibrary.simpleMessage(
      "无法把证书加入系统信任的根证书",
    ),
    "mitmTrustChecking": MessageLookupByLibrary.simpleMessage("正在检查…"),
    "mitmTrustNotInstalled": MessageLookupByLibrary.simpleMessage("未安装"),
    "mitmTrustReady": MessageLookupByLibrary.simpleMessage("已信任"),
    "mitmTrustUntrusted": MessageLookupByLibrary.simpleMessage("未完全信任"),
    "mixedPort": MessageLookupByLibrary.simpleMessage("混合端口"),
    "mobilePlanValidity": MessageLookupByLibrary.simpleMessage("套餐有效期"),
    "mobileRemainingTraffic": MessageLookupByLibrary.simpleMessage("本月剩余流量"),
    "mode": MessageLookupByLibrary.simpleMessage("模式"),
    "monochromeIcon": MessageLookupByLibrary.simpleMessage("单色图标"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("单色"),
    "monthsAgo": m91,
    "monthsAgoShort": m92,
    "more": MessageLookupByLibrary.simpleMessage("更多"),
    "name": MessageLookupByLibrary.simpleMessage("名称"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "默认使用的 DNS 服务器，如 223.5.5.5、tls://1.1.1.1、https://dns.google/dns-query。",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "匹配的域名改用此处指定的 DNS 服务器，优先于 Nameserver 和 Fallback。",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("底栏"),
    "network": MessageLookupByLibrary.simpleMessage("网络"),
    "networkAccessDeniedError": m93,
    "networkBadResponseError": m94,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage("请求已取消"),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "无法连接到服务器，请检查网络连接或代理设置",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "无法解析服务器地址，请确认链接正确且 DNS 可用",
    ),
    "networkName": MessageLookupByLibrary.simpleMessage("网络名称"),
    "networkNotFoundError": m95,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "请求过于频繁（HTTP 429），请稍后再试",
    ),
    "networkRequestFailed": m96,
    "networkSecret": MessageLookupByLibrary.simpleMessage("网络密码"),
    "networkServerError": m97,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("网络速度"),
    "networkTakeover": MessageLookupByLibrary.simpleMessage("网络接管"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "请求超时，请检查网络或代理后重试",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "安全连接失败，服务器证书可能无效，或连接被拦截",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("网络类型"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("下一个匹配"),
    "no": MessageLookupByLibrary.simpleMessage("否"),
    "noData": MessageLookupByLibrary.simpleMessage("暂无数据"),
    "noInfo": MessageLookupByLibrary.simpleMessage("暂无信息"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage("不再提示"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("无网络"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("无网络应用"),
    "noResolve": MessageLookupByLibrary.simpleMessage("不解析IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage("不解析主机名"),
    "noSearchResults": MessageLookupByLibrary.simpleMessage("没有匹配的结果"),
    "nodes": MessageLookupByLibrary.simpleMessage("节点"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage("该外部资源不是文本文件"),
    "none": MessageLookupByLibrary.simpleMessage("无"),
    "notRunning": MessageLookupByLibrary.simpleMessage("未运行"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage("当前代理组无法选中"),
    "ntpInterval": MessageLookupByLibrary.simpleMessage("同步间隔（分钟）"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage("添加一个配置文件后即可开始使用"),
    "nullTip": m98,
    "numberRangeTip": m99,
    "numberTip": m100,
    "obfs": MessageLookupByLibrary.simpleMessage("混淆"),
    "obfsHost": MessageLookupByLibrary.simpleMessage("混淆主机"),
    "obfsMode": MessageLookupByLibrary.simpleMessage("混淆模式"),
    "obfsParam": MessageLookupByLibrary.simpleMessage("混淆参数"),
    "obfsPassword": MessageLookupByLibrary.simpleMessage("混淆密码"),
    "onDemand": MessageLookupByLibrary.simpleMessage("按需运行"),
    "onboardingCheckingInternet": MessageLookupByLibrary.simpleMessage(
      "正在确认外网…",
    ),
    "onboardingClipboardEmpty": MessageLookupByLibrary.simpleMessage(
      "剪贴板里没有内容",
    ),
    "onboardingConfirmNote": MessageLookupByLibrary.simpleMessage(
      "请核对上方完整订阅链接，确认无误后导入。",
    ),
    "onboardingConfirmTitle": MessageLookupByLibrary.simpleMessage("天机云订阅"),
    "onboardingConnect": MessageLookupByLibrary.simpleMessage("连接"),
    "onboardingConnectFailed": MessageLookupByLibrary.simpleMessage(
      "连接没有成功，请稍后再试。",
    ),
    "onboardingConnected": MessageLookupByLibrary.simpleMessage("已连接"),
    "onboardingConnectedNoInternet": MessageLookupByLibrary.simpleMessage(
      "已连接，但上不了外网",
    ),
    "onboardingConnecting": MessageLookupByLibrary.simpleMessage("正在连接…"),
    "onboardingConnectingDescription": MessageLookupByLibrary.simpleMessage(
      "连上后会实际访问一次外网来确认",
    ),
    "onboardingContinue": MessageLookupByLibrary.simpleMessage("继续"),
    "onboardingDescription": MessageLookupByLibrary.simpleMessage(
      "粘贴或扫描面板上的订阅链接，几步就能连上。",
    ),
    "onboardingExit": MessageLookupByLibrary.simpleMessage("出口"),
    "onboardingExpireDate": MessageLookupByLibrary.simpleMessage("到期时间"),
    "onboardingFailureEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "套餐可能已到期，或本月流量已用完。续费或重置流量后，回来点「重试」。",
    ),
    "onboardingFailureEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "订阅里没有可用节点",
    ),
    "onboardingFailureExpiredDescription": MessageLookupByLibrary.simpleMessage(
      "可能是在面板里重置过订阅。请到用户面板重新复制订阅地址，再回来粘贴。",
    ),
    "onboardingFailureExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "订阅链接已失效",
    ),
    "onboardingFailureNotSubscriptionDescription":
        MessageLookupByLibrary.simpleMessage("请在用户面板点「复制订阅地址」，再回来粘贴。"),
    "onboardingFailureNotSubscriptionTitle":
        MessageLookupByLibrary.simpleMessage("这不是订阅链接"),
    "onboardingFailureUnknownDescription": MessageLookupByLibrary.simpleMessage(
      "请检查网络后重试。",
    ),
    "onboardingFailureUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "导入没有成功",
    ),
    "onboardingFailureUnreachableDescription":
        MessageLookupByLibrary.simpleMessage(
          "可能是当前网络限制了这个域名。状态页上有备用地址，也可以稍后再试。",
        ),
    "onboardingFailureUnreachableTitle": MessageLookupByLibrary.simpleMessage(
      "暂时连不上订阅地址",
    ),
    "onboardingImported": m101,
    "onboardingImporting": MessageLookupByLibrary.simpleMessage("正在获取订阅…"),
    "onboardingImportingDescription": MessageLookupByLibrary.simpleMessage(
      "读取节点列表和套餐信息",
    ),
    "onboardingInternetVerified": MessageLookupByLibrary.simpleMessage(
      "外网访问 · 已验证可用",
    ),
    "onboardingNoSubscription": MessageLookupByLibrary.simpleMessage(
      "还没有订阅地址？打开用户面板复制 ›",
    ),
    "onboardingNodeUnavailable": MessageLookupByLibrary.simpleMessage(
      "当前节点可能暂时不可用。换一个节点通常就能解决。",
    ),
    "onboardingNotNow": MessageLookupByLibrary.simpleMessage("暂不连接"),
    "onboardingOpenPanel": MessageLookupByLibrary.simpleMessage("打开用户面板"),
    "onboardingPasteAgain": MessageLookupByLibrary.simpleMessage("重新粘贴"),
    "onboardingPasteFromClipboard": MessageLookupByLibrary.simpleMessage(
      "从剪贴板粘贴订阅链接",
    ),
    "onboardingPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "只在你点按钮时读取剪贴板。订阅链接只保存在这台设备上。",
    ),
    "onboardingRemainingTraffic": MessageLookupByLibrary.simpleMessage("剩余流量"),
    "onboardingScanQr": MessageLookupByLibrary.simpleMessage("扫描面板上的二维码"),
    "onboardingSwitchNode": MessageLookupByLibrary.simpleMessage("换一个节点"),
    "onboardingTitle": MessageLookupByLibrary.simpleMessage("导入订阅，马上开始"),
    "onboardingViewStatus": MessageLookupByLibrary.simpleMessage("查看备用地址"),
    "onboardingVpnDescription": MessageLookupByLibrary.simpleMessage(
      "接下来系统会询问是否允许天机云创建 VPN 连接，请点「确定」。只需要授权这一次。",
    ),
    "onboardingVpnTitle": MessageLookupByLibrary.simpleMessage("需要一次系统授权"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage("仅统计代理流量"),
    "openSettings": MessageLookupByLibrary.simpleMessage("打开设置"),
    "optional": MessageLookupByLibrary.simpleMessage("可选"),
    "options": MessageLookupByLibrary.simpleMessage("选项"),
    "originalUrl": MessageLookupByLibrary.simpleMessage("原 URL"),
    "other": MessageLookupByLibrary.simpleMessage("其他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("其他贡献者"),
    "otherProfilesTitle": MessageLookupByLibrary.simpleMessage("其他配置"),
    "outbound": MessageLookupByLibrary.simpleMessage("出站"),
    "outboundExit": MessageLookupByLibrary.simpleMessage("出口"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("出站 IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("出站模式"),
    "outboundModeDescription": MessageLookupByLibrary.simpleMessage(
      "一般保持「规则」。全局会让大陆流量也走代理，直连会让所有线路失效。",
    ),
    "outboundModeDirectWarning": MessageLookupByLibrary.simpleMessage(
      "当前为直连模式",
    ),
    "outboundModeGlobalWarning": MessageLookupByLibrary.simpleMessage(
      "当前为全局模式",
    ),
    "outboundModeRestoreRule": MessageLookupByLibrary.simpleMessage("恢复规则"),
    "overrideDestination": MessageLookupByLibrary.simpleMessage("覆盖目标地址"),
    "overrideEntries": MessageLookupByLibrary.simpleMessage("覆写项"),
    "overridesLabel": MessageLookupByLibrary.simpleMessage("覆写"),
    "overview": MessageLookupByLibrary.simpleMessage("概览"),
    "parsePureIp": MessageLookupByLibrary.simpleMessage("解析纯IP"),
    "password": MessageLookupByLibrary.simpleMessage("密码"),
    "paste": MessageLookupByLibrary.simpleMessage("粘贴"),
    "pasteFromClipboardImport": MessageLookupByLibrary.simpleMessage("从剪贴板导入"),
    "peers": MessageLookupByLibrary.simpleMessage("初始节点"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("从相册选择"),
    "pinWindow": MessageLookupByLibrary.simpleMessage("窗口置顶"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage("请绑定WebDAV"),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage("请输入脚本名称"),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "请上传有效的二维码",
    ),
    "plugin": MessageLookupByLibrary.simpleMessage("插件"),
    "pluginCipher": MessageLookupByLibrary.simpleMessage("插件加密方式"),
    "pluginHost": MessageLookupByLibrary.simpleMessage("插件主机"),
    "pluginMode": MessageLookupByLibrary.simpleMessage("插件模式"),
    "pluginPassword": MessageLookupByLibrary.simpleMessage("插件密码"),
    "pluginPath": MessageLookupByLibrary.simpleMessage("插件路径"),
    "pluginUsername": MessageLookupByLibrary.simpleMessage("插件用户名"),
    "port": MessageLookupByLibrary.simpleMessage("端口"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage("请输入不同的端口"),
    "portHopping": MessageLookupByLibrary.simpleMessage("端口跳跃"),
    "portTip": m102,
    "portValue": m103,
    "ports": MessageLookupByLibrary.simpleMessage("端口"),
    "preSharedKey": MessageLookupByLibrary.simpleMessage("预共享密钥"),
    "preferred": MessageLookupByLibrary.simpleMessage("首选"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("前置条件"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("请按下组合键"),
    "preview": MessageLookupByLibrary.simpleMessage("预览"),
    "previewReadOnly": MessageLookupByLibrary.simpleMessage("只读"),
    "previousMatch": MessageLookupByLibrary.simpleMessage("上一个匹配"),
    "privateKey": MessageLookupByLibrary.simpleMessage("私钥"),
    "privateKeyPassphrase": MessageLookupByLibrary.simpleMessage("私钥密码"),
    "process": MessageLookupByLibrary.simpleMessage("进程"),
    "profile": MessageLookupByLibrary.simpleMessage("配置"),
    "profileAddCustomSourceDesc": MessageLookupByLibrary.simpleMessage(
      "创建本地节点、分组和规则",
    ),
    "profileAddFileSourceDesc": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "profileAddLinkSourceDesc": MessageLookupByLibrary.simpleMessage(
      "从用户面板复制订阅链接",
    ),
    "profileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "导入前会先校验；解析失败不会替换当前配置。",
    ),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入有效间隔时间格式"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("请输入自动更新间隔时间"),
    "profileDaysLeft": m104,
    "profileExpiresIn": m105,
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "配置文件已经修改，是否关闭自动更新？",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置名称",
    ),
    "profilePreviewTitle": MessageLookupByLibrary.simpleMessage("配置预览"),
    "profileSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "仅作用于当前配置，未添加的项使用默认值。",
    ),
    "profileSwitchNote": MessageLookupByLibrary.simpleMessage(
      "切换后立即生效；解析失败时保留当前配置",
    ),
    "profileTunSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "仅作用于当前配置，并优先于网络设置中的虚拟网卡覆写项。",
    ),
    "profileUpdatedAt": m106,
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入有效配置URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "请输入配置URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("配置"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("配置排序"),
    "project": MessageLookupByLibrary.simpleMessage("项目"),
    "protocol": MessageLookupByLibrary.simpleMessage("协议"),
    "protocolParam": MessageLookupByLibrary.simpleMessage("协议参数"),
    "protocolVersion": MessageLookupByLibrary.simpleMessage("协议版本"),
    "providerCount": m107,
    "providerInUse": m108,
    "providerUrlTip": MessageLookupByLibrary.simpleMessage("仅支持远程资源"),
    "providers": MessageLookupByLibrary.simpleMessage("外部资源"),
    "proxies": MessageLookupByLibrary.simpleMessage("代理"),
    "proxiesCount": m109,
    "proxiesProfileLabel": m110,
    "proxiesRemovedTip": m111,
    "proxiesReplacedTip": m112,
    "proxyChains": MessageLookupByLibrary.simpleMessage("代理链"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("策略组"),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage("策略组为空"),
    "proxyGroupInUse": m113,
    "proxyGroupsAfterStart": MessageLookupByLibrary.simpleMessage(
      "启动后在这里显示策略组",
    ),
    "proxyGroupsCount": m114,
    "proxyProviders": MessageLookupByLibrary.simpleMessage("代理集"),
    "proxyServerNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "仅用于解析代理服务器的域名。",
    ),
    "proxyServerNameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "匹配的代理服务器域名改用此处指定的 DNS 服务器，优先于 Proxy Server Nameserver。",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("代理类型"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("修剪缓存"),
    "publicKey": MessageLookupByLibrary.simpleMessage("公钥"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("纯黑"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("纯黑模式"),
    "qrcode": MessageLookupByLibrary.simpleMessage("二维码"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage("扫描二维码获取配置文件"),
    "qrcodeTooLongTip": MessageLookupByLibrary.simpleMessage(
      "链接过长，无法生成二维码，请改用“复制链接”。",
    ),
    "quickActions": MessageLookupByLibrary.simpleMessage("快捷操作"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("快速编辑"),
    "quickLines": MessageLookupByLibrary.simpleMessage("常用线路"),
    "recentDnsQueries": MessageLookupByLibrary.simpleMessage("最近 DNS 查询"),
    "recentRequests": MessageLookupByLibrary.simpleMessage("最近请求"),
    "recommendedIcons": MessageLookupByLibrary.simpleMessage("推荐"),
    "recordType": MessageLookupByLibrary.simpleMessage("记录类型"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir端口"),
    "redo": MessageLookupByLibrary.simpleMessage("重做"),
    "regenerateCertificate": MessageLookupByLibrary.simpleMessage("重新生成证书"),
    "regenerateCertificateTip": MessageLookupByLibrary.simpleMessage(
      "新证书会替换当前证书，天机云会尽量把当前证书从本机信任的根证书中移除。信任当前证书的其他设备都需要安装新证书。",
    ),
    "regex": MessageLookupByLibrary.simpleMessage("正则"),
    "releaseMemory": MessageLookupByLibrary.simpleMessage("释放内存"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage("释放内存失败"),
    "remote": MessageLookupByLibrary.simpleMessage("远程"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage("远程目标"),
    "remoteDnsResolve": MessageLookupByLibrary.simpleMessage("远程 DNS 解析"),
    "remove": MessageLookupByLibrary.simpleMessage("移除"),
    "rename": MessageLookupByLibrary.simpleMessage("重命名"),
    "renew": MessageLookupByLibrary.simpleMessage("续费"),
    "renewUpgrade": MessageLookupByLibrary.simpleMessage("续费 / 升级套餐"),
    "replace": MessageLookupByLibrary.simpleMessage("替换"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("全部替换"),
    "request": MessageLookupByLibrary.simpleMessage("请求"),
    "requestBody": MessageLookupByLibrary.simpleMessage("请求体"),
    "requestHeaders": MessageLookupByLibrary.simpleMessage("请求头"),
    "requests": MessageLookupByLibrary.simpleMessage("请求"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage("请求与更新"),
    "required": MessageLookupByLibrary.simpleMessage("必填"),
    "reset": MessageLookupByLibrary.simpleMessage("重置"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "当前页面存在更改，确定重置吗？",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("确定要重置吗？"),
    "residentialActiveDesc": MessageLookupByLibrary.simpleMessage(
      "连接后，需要代理的分组都会自动跟随这条线路。",
    ),
    "residentialApplyFailed": MessageLookupByLibrary.simpleMessage(
      "线路未能生效，请重试或选择其他线路。",
    ),
    "residentialApplying": MessageLookupByLibrary.simpleMessage("正在应用…"),
    "residentialBulkBypass": MessageLookupByLibrary.simpleMessage(
      "视频和大文件下载走普通线路，不占家宽流量。",
    ),
    "residentialBulkUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "大流量绕行未确认；视频和下载可能占家宽流量。",
    ),
    "residentialCaptureOff": MessageLookupByLibrary.simpleMessage(
      "尚未接管电脑流量，请开启下方的系统代理或 TUN 模式。",
    ),
    "residentialChange": MessageLookupByLibrary.simpleMessage("更换线路"),
    "residentialChoose": MessageLookupByLibrary.simpleMessage("选择家宽"),
    "residentialExitLocked": MessageLookupByLibrary.simpleMessage(
      "请在仪表盘选择家宽出口。家宽分流生效期间，其他分组无法更改它。",
    ),
    "residentialExitSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "AI 与需要代理的分组会跟随所选线路",
    ),
    "residentialExitSheetTitle": MessageLookupByLibrary.simpleMessage("选择家宽出口"),
    "residentialExplanation": MessageLookupByLibrary.simpleMessage(
      "默认代理流量使用所选家宽线路；大陆与直连流量仍按订阅分流。大流量绕行状态见下方说明。部分目标可能由服务端使用替代出口。",
    ),
    "residentialLoadingCatalog": MessageLookupByLibrary.simpleMessage(
      "正在加载家宽线路…",
    ),
    "residentialLoadingCatalogDesc": MessageLookupByLibrary.simpleMessage(
      "正在读取订阅中的可用线路。",
    ),
    "residentialManageSubscription": MessageLookupByLibrary.simpleMessage(
      "管理订阅",
    ),
    "residentialMissing": MessageLookupByLibrary.simpleMessage(
      "所选家宽出口已不在当前订阅中。",
    ),
    "residentialMissingDesc": MessageLookupByLibrary.simpleMessage(
      "选择其他出口前，代理流量会被阻断；大陆直连不受影响。",
    ),
    "residentialNoPlan": MessageLookupByLibrary.simpleMessage("暂无可用家宽线路"),
    "residentialNoPlanDesc": MessageLookupByLibrary.simpleMessage(
      "当前订阅没有可用的家宽出口。可继续使用订阅策略，或前往订阅面板查看。",
    ),
    "residentialOutbound": MessageLookupByLibrary.simpleMessage("住宅出口"),
    "residentialPending": MessageLookupByLibrary.simpleMessage("正在切换线路，请稍候。"),
    "residentialResetFailed": MessageLookupByLibrary.simpleMessage(
      "新出口已生效，但旧连接未能关闭，重连前可能仍走旧出口。",
    ),
    "residentialRouteNote": MessageLookupByLibrary.simpleMessage(
      "IP 卡片只显示当前检测目标对应的出口，不代表所有网站都使用同一个出口。",
    ),
    "residentialSelected": MessageLookupByLibrary.simpleMessage("已选择"),
    "residentialSubscriptionPolicy": MessageLookupByLibrary.simpleMessage(
      "按订阅分流",
    ),
    "residentialTitle": MessageLookupByLibrary.simpleMessage("家宽线路"),
    "residentialUnavailable": MessageLookupByLibrary.simpleMessage("不可用"),
    "residentialUseExit": m115,
    "residentialUseSubscription": MessageLookupByLibrary.simpleMessage("按订阅分流"),
    "residentialUsingSubscription": MessageLookupByLibrary.simpleMessage(
      "尚未选择家宽出口，需要代理的流量按订阅自身策略分流。",
    ),
    "resourceUpdateInterval": MessageLookupByLibrary.simpleMessage("自动更新间隔"),
    "resourceUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "自动更新间隔必须大于0",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("资源"),
    "respectRules": MessageLookupByLibrary.simpleMessage("遵守规则"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "遵守规则使 DNS 连接遵守规则，需配置 Proxy Server Nameserver。",
    ),
    "response": MessageLookupByLibrary.simpleMessage("响应"),
    "responseBody": MessageLookupByLibrary.simpleMessage("响应体"),
    "responseCode": MessageLookupByLibrary.simpleMessage("响应码"),
    "responseHeaders": MessageLookupByLibrary.simpleMessage("响应头"),
    "restart": MessageLookupByLibrary.simpleMessage("重启"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage("您确定要重启核心吗？"),
    "restore": MessageLookupByLibrary.simpleMessage("恢复"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("恢复所有数据"),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage("仅恢复配置文件"),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("恢复策略"),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage("兼容"),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage("覆盖"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("恢复成功"),
    "result": MessageLookupByLibrary.simpleMessage("结果"),
    "retry": MessageLookupByLibrary.simpleMessage("重试"),
    "root": MessageLookupByLibrary.simpleMessage("Root"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("路由地址"),
    "routeExcludeAddress": MessageLookupByLibrary.simpleMessage("排除路由地址"),
    "routingMark": MessageLookupByLibrary.simpleMessage("路由标记"),
    "routingResourcesDesktop": MessageLookupByLibrary.simpleMessage("分流资源"),
    "routingResourcesSubtitle": MessageLookupByLibrary.simpleMessage(
      "决定哪些流量走代理、哪些直连",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("俄语"),
    "rule": MessageLookupByLibrary.simpleMessage("规则"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 AND"),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage("匹配完整域名"),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "匹配域名关键字",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用域名正则表达式匹配",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配域名后缀",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "通配符匹配，仅支持*和?通配符",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "匹配DSCP标记（仅限 tproxy udp 入站）",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage("匹配请求目标端口范围"),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 所属国家代码"),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 Geosite 内的域名",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage("匹配入站名称"),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage("匹配入站端口"),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage("匹配入站类型"),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "匹配入站用户名，支持使用 / 分隔多个用户名",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 所属 ASN"),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "匹配 IP 地址范围，IP-CIDR6 只是一个别名",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage("匹配 IP 地址范围"),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 IP 后缀范围",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage("匹配所有请求，无需条件"),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage("匹配TCP或者UDP"),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 NOT"),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("逻辑规则 OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程匹配，在Android平台可以匹配包名",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程名称正则表达式匹配，在Android平台可以匹配包名",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程名称通配符匹配，仅支持*和?通配符",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "使用完整进程路径匹配",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程路径正则表达式匹配",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "使用进程路径通配符匹配，仅支持*和?通配符",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "匹配重匹配名称，多个名称用/分隔",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "引用规则集合，需配置rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 所属国家代码",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 所属 ASN",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 地址范围",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "匹配来源 IP 后缀范围",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage("匹配请求来源端口范围"),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "匹配至子规则，需要注意括号的使用",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "匹配 Linux USER ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("规则为空"),
    "ruleListInvalid": MessageLookupByLibrary.simpleMessage(
      "规则必须是 YAML 列表，每项一条规则，例如 - DOMAIN,example.com,DIRECT",
    ),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BT 下载直连",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "屏蔽 DNS over TLS",
    ),
    "rulePresetBlockLoopback": MessageLookupByLibrary.simpleMessage("防止代理回环"),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage("屏蔽 QUIC"),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage("屏蔽 STUN"),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage("局域网直连"),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple 与 Microsoft 直连",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("规则集"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("规则集"),
    "ruleSetEmptyTip": MessageLookupByLibrary.simpleMessage("规则集中没有可用的条目"),
    "ruleSetInvalidTip": MessageLookupByLibrary.simpleMessage("无法读取该 mrs 文件"),
    "ruleSetMixedTip": MessageLookupByLibrary.simpleMessage(
      "规则集同时包含域名和 IP 段，无法判断类型",
    ),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("规则目标"),
    "ruleTextInvalid": MessageLookupByLibrary.simpleMessage(
      "规则必须以受支持的类型开头，例如 DOMAIN,example.com,DIRECT",
    ),
    "rules": MessageLookupByLibrary.simpleMessage("规则"),
    "rulesCount": m116,
    "runTime": MessageLookupByLibrary.simpleMessage("运行时长"),
    "running": MessageLookupByLibrary.simpleMessage("运行中"),
    "runtimeConfig": MessageLookupByLibrary.simpleMessage("运行时配置"),
    "safeMode": MessageLookupByLibrary.simpleMessage("安全模式"),
    "safeModeAppTitle": m117,
    "saturation": MessageLookupByLibrary.simpleMessage("饱和度"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("是否保存更改？"),
    "scene": MessageLookupByLibrary.simpleMessage("场景"),
    "sceneAi": MessageLookupByLibrary.simpleMessage("AI"),
    "sceneAiNote": MessageLookupByLibrary.simpleMessage(
      "AI 服务走 AI 模式线路 · 大陆流量本地直连",
    ),
    "sceneDaily": MessageLookupByLibrary.simpleMessage("日常"),
    "sceneDailyBypass": MessageLookupByLibrary.simpleMessage(
      "大流量自动绕开家宽 · 大陆流量本地直连",
    ),
    "sceneDailyNote": MessageLookupByLibrary.simpleMessage("大陆流量本地直连"),
    "sceneSuspended": MessageLookupByLibrary.simpleMessage("家宽模式下，场景切换已暂停"),
    "sceneUnavailable": MessageLookupByLibrary.simpleMessage("场景暂不可用"),
    "sceneUnavailableDesc": MessageLookupByLibrary.simpleMessage(
      "当前订阅还没有场景分组，联系客服开通，或在代理页手动分流。",
    ),
    "sceneUnconfirmed": MessageLookupByLibrary.simpleMessage("部分规则未能切换"),
    "sceneWatch": MessageLookupByLibrary.simpleMessage("观影"),
    "sceneWatchNote": MessageLookupByLibrary.simpleMessage(
      "流媒体走观影线路 · 大陆流量本地直连",
    ),
    "script": MessageLookupByLibrary.simpleMessage("脚本"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage("脚本模式，使用扩展脚本改写整个配置"),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage("滚动到已选"),
    "search": MessageLookupByLibrary.simpleMessage("搜索"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "secondsCount": m118,
    "secretKey": MessageLookupByLibrary.simpleMessage("密钥"),
    "sectionsInEffect": m119,
    "select": MessageLookupByLibrary.simpleMessage("选中"),
    "selectAll": MessageLookupByLibrary.simpleMessage("全选"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage("请选择规则集"),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage("请选择分流策略"),
    "selectionConfirming": MessageLookupByLibrary.simpleMessage("正在确认出口…"),
    "selectionGroupOverridden": MessageLookupByLibrary.simpleMessage(
      "这个分组正在自动选择节点，实际节点与所选不同。请手动选择节点来固定线路。",
    ),
    "selectionNotCaptured": MessageLookupByLibrary.simpleMessage(
      "还没接管这台设备的流量：请在下方开启系统代理或虚拟网卡，选好的节点才会生效。",
    ),
    "selectionRecheck": MessageLookupByLibrary.simpleMessage("重新检测"),
    "selectionResidentialLocked": MessageLookupByLibrary.simpleMessage(
      "家宽线路正在接管代理流量。请在家宽卡里更换线路，或切回按订阅分流。",
    ),
    "selectionUnknown": MessageLookupByLibrary.simpleMessage(
      "出口与所选不一致，暂时无法确认原因。可以重新检测一次。",
    ),
    "selectionUnknownPending": MessageLookupByLibrary.simpleMessage(
      "出口与所选不一致，原因正在确认…",
    ),
    "send": MessageLookupByLibrary.simpleMessage("发送"),
    "sendFromPhone": MessageLookupByLibrary.simpleMessage("从手机发送"),
    "sendFromPhoneConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "导入手机发来的链接？",
    ),
    "sendFromPhoneNoNetwork": MessageLookupByLibrary.simpleMessage(
      "这台设备没有连接局域网",
    ),
    "sendFromPhonePageHint": MessageLookupByLibrary.simpleMessage(
      "订阅链接或代理分享链接",
    ),
    "sendFromPhonePageSent": MessageLookupByLibrary.simpleMessage(
      "已发送，请在另一台设备上确认导入。",
    ),
    "sendFromPhonePageTitle": MessageLookupByLibrary.simpleMessage("把链接发送到天机云"),
    "sendFromPhonePermissionDenied": MessageLookupByLibrary.simpleMessage(
      "从手机接收链接需要「附近的设备」权限，天机云才能访问局域网。请在应用设置中开启。",
    ),
    "sendFromPhoneTip": MessageLookupByLibrary.simpleMessage(
      "用手机相机扫描二维码，在打开的页面里粘贴链接。两台设备需要连在同一个网络。",
    ),
    "server": MessageLookupByLibrary.simpleMessage("服务器"),
    "serviceAbnormalCount": m120,
    "serviceAllAvailable": MessageLookupByLibrary.simpleMessage("全部可用"),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("可用"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("已被封禁"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("全部检测"),
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("即将上线"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage("不允许的 ISP"),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("检测失败"),
    "serviceManage": MessageLookupByLibrary.simpleMessage("管理服务"),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage("仅限自制内容"),
    "servicePending": MessageLookupByLibrary.simpleMessage("待检测"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage("访问受限"),
    "serviceShownOnDashboard": MessageLookupByLibrary.simpleMessage("显示在仪表盘"),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("服务状态"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("不可用"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage("地区不支持"),
    "settingEntries": MessageLookupByLibrary.simpleMessage("设置项"),
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "settingsCount": m121,
    "shareLinkUnreadable": m122,
    "shareLinksInvalid": MessageLookupByLibrary.simpleMessage("无法从链接中读取代理"),
    "shareQrcodeTip": MessageLookupByLibrary.simpleMessage(
      "在另一台设备上用天机云扫码即可导入此配置。",
    ),
    "show": MessageLookupByLibrary.simpleMessage("显示"),
    "showLess": MessageLookupByLibrary.simpleMessage("收起"),
    "showMore": MessageLookupByLibrary.simpleMessage("展开"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "通知栏显示停止按钮",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("显示密码"),
    "sidebar": MessageLookupByLibrary.simpleMessage("侧边栏"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("静默启动"),
    "singleImport": MessageLookupByLibrary.simpleMessage("单条导入"),
    "singleShareLinkOnly": MessageLookupByLibrary.simpleMessage(
      "这里只能填写一条链接，多条请在列表的快速编辑中填写",
    ),
    "singleValueTip": m123,
    "size": MessageLookupByLibrary.simpleMessage("尺寸"),
    "skipCertVerify": MessageLookupByLibrary.simpleMessage("跳过证书验证"),
    "skipDomain": MessageLookupByLibrary.simpleMessage("跳过域名"),
    "skipDstAddress": MessageLookupByLibrary.simpleMessage("跳过目标地址"),
    "skipServerCertVerify": MessageLookupByLibrary.simpleMessage("跳过服务器证书验证"),
    "skipSrcAddress": MessageLookupByLibrary.simpleMessage("跳过来源地址"),
    "slide": MessageLookupByLibrary.simpleMessage("滑动"),
    "sliders": MessageLookupByLibrary.simpleMessage("滑块"),
    "sniffProtocols": MessageLookupByLibrary.simpleMessage("协议"),
    "sniffer": MessageLookupByLibrary.simpleMessage("域名嗅探"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks端口"),
    "softStyle": MessageLookupByLibrary.simpleMessage("柔和"),
    "sort": MessageLookupByLibrary.simpleMessage("排序"),
    "source": MessageLookupByLibrary.simpleMessage("来源"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("源IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("特殊代理"),
    "specialRules": MessageLookupByLibrary.simpleMessage("特殊规则"),
    "spectrum": MessageLookupByLibrary.simpleMessage("光谱"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("网速统计"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("分流策略"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage("分流策略不能为空"),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDs为空"),
    "stackMode": MessageLookupByLibrary.simpleMessage("栈模式"),
    "stackTrace": MessageLookupByLibrary.simpleMessage("堆栈信息"),
    "standard": MessageLookupByLibrary.simpleMessage("标准"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "标准模式，在配置的基础上附加规则",
    ),
    "start": MessageLookupByLibrary.simpleMessage("启动"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage("从零开始"),
    "startVpn": MessageLookupByLibrary.simpleMessage("正在启动VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage("启动与后台"),
    "status": MessageLookupByLibrary.simpleMessage("状态"),
    "statusDesc": MessageLookupByLibrary.simpleMessage("关闭 DNS 后将使用系统 DNS。"),
    "stop": MessageLookupByLibrary.simpleMessage("暂停"),
    "stopUpdateDownloadTip": MessageLookupByLibrary.simpleMessage("要停止下载更新吗？"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("正在停止VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("策略"),
    "strictRoute": MessageLookupByLibrary.simpleMessage("严格路由"),
    "strictRouteDesc": MessageLookupByLibrary.simpleMessage(
      "严格路由防止 DNS 等流量绕过虚拟网卡，关闭 IPv6 时会阻断本机的 IPv6 连接。",
    ),
    "style": MessageLookupByLibrary.simpleMessage("风格"),
    "submit": MessageLookupByLibrary.simpleMessage("提交"),
    "subscriptionDetails": MessageLookupByLibrary.simpleMessage("详情"),
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage("订阅信息"),
    "subscriptionLink": MessageLookupByLibrary.simpleMessage("订阅链接"),
    "sudoPasswordTitle": MessageLookupByLibrary.simpleMessage("输入 sudo 密码"),
    "suspended": MessageLookupByLibrary.simpleMessage("挂起中…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("切换配置"),
    "switchProfileShort": MessageLookupByLibrary.simpleMessage("切换"),
    "sync": MessageLookupByLibrary.simpleMessage("同步"),
    "system": MessageLookupByLibrary.simpleMessage("系统"),
    "systemApp": MessageLookupByLibrary.simpleMessage("系统应用"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("系统代理"),
    "systemService": MessageLookupByLibrary.simpleMessage("系统服务"),
    "systemServiceAbnormal": MessageLookupByLibrary.simpleMessage("异常"),
    "systemServiceDescription": MessageLookupByLibrary.simpleMessage(
      "以管理员权限运行，负责虚拟网卡、路由和系统代理的设置与恢复",
    ),
    "systemServiceInstall": MessageLookupByLibrary.simpleMessage("安装"),
    "systemServiceNotInstalled": MessageLookupByLibrary.simpleMessage("未安装"),
    "systemServiceRefresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "systemServiceRepair": MessageLookupByLibrary.simpleMessage("修复"),
    "systemServiceRunning": MessageLookupByLibrary.simpleMessage("已安装并运行"),
    "tab": MessageLookupByLibrary.simpleMessage("标签页"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("选项卡动画"),
    "tapIconToRetry": MessageLookupByLibrary.simpleMessage("点击图标重试"),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("点击授权"),
    "target": MessageLookupByLibrary.simpleMessage("目标"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP并发"),
    "testInterval": MessageLookupByLibrary.simpleMessage("测试间隔"),
    "testUrl": MessageLookupByLibrary.simpleMessage("测速链接"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("使用时测试"),
    "textScale": MessageLookupByLibrary.simpleMessage("文本缩放"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage("应用内的文字将以这个大小显示"),
    "theme": MessageLookupByLibrary.simpleMessage("主题"),
    "themeColor": MessageLookupByLibrary.simpleMessage("主题色彩"),
    "themeMode": MessageLookupByLibrary.simpleMessage("主题模式"),
    "tight": MessageLookupByLibrary.simpleMessage("紧凑"),
    "time": MessageLookupByLibrary.simpleMessage("时间"),
    "timeToFirstByte": MessageLookupByLibrary.simpleMessage("首字节耗时"),
    "timeout": MessageLookupByLibrary.simpleMessage("超时"),
    "tintedStyle": MessageLookupByLibrary.simpleMessage("氛围"),
    "tip": MessageLookupByLibrary.simpleMessage("提示"),
    "toggle": MessageLookupByLibrary.simpleMessage("切换"),
    "tolerance": MessageLookupByLibrary.simpleMessage("容差"),
    "tools": MessageLookupByLibrary.simpleMessage("工具"),
    "torch": MessageLookupByLibrary.simpleMessage("手电筒"),
    "total": MessageLookupByLibrary.simpleMessage("总计"),
    "totalDownload": MessageLookupByLibrary.simpleMessage("下载总量"),
    "totalTraffic": MessageLookupByLibrary.simpleMessage("总流量"),
    "totalUpload": MessageLookupByLibrary.simpleMessage("上传总量"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy端口"),
    "traffic": MessageLookupByLibrary.simpleMessage("流量"),
    "trafficMainlandThisMonth": MessageLookupByLibrary.simpleMessage("本月大陆直连"),
    "trafficOtherDirect": MessageLookupByLibrary.simpleMessage("直连（地区未确认）"),
    "trafficPeak": m124,
    "trafficSavedThisMonth": MessageLookupByLibrary.simpleMessage("本月节省"),
    "trafficStats": MessageLookupByLibrary.simpleMessage("流量统计"),
    "trafficStatsDesc": MessageLookupByLibrary.simpleMessage(
      "本设备本月的内地直连流量、VPN 流量和节省的代理流量。",
    ),
    "trafficStatsScope": MessageLookupByLibrary.simpleMessage(
      "仅本设备本月统计，包含应用捕获的流量。",
    ),
    "trafficTotal": m125,
    "trafficUsage": MessageLookupByLibrary.simpleMessage("流量统计"),
    "transport": MessageLookupByLibrary.simpleMessage("传输协议"),
    "transportHeaders": m126,
    "trustCertificate": MessageLookupByLibrary.simpleMessage("信任证书"),
    "tun": MessageLookupByLibrary.simpleMessage("虚拟网卡"),
    "tunAuthorizationFailed": MessageLookupByLibrary.simpleMessage(
      "虚拟网卡授权失败，已关闭。",
    ),
    "tunDesc": MessageLookupByLibrary.simpleMessage("虚拟网卡仅在管理员模式生效。"),
    "tunOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "添加的项会覆写所有配置的虚拟网卡设置，未添加的项沿用配置自身的设置。自定义配置自己添加的项优先。",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("关闭"),
    "turnOn": MessageLookupByLibrary.simpleMessage("开启"),
    "udpRelayMode": MessageLookupByLibrary.simpleMessage("UDP 中继模式"),
    "udpTimeout": MessageLookupByLibrary.simpleMessage("UDP 超时"),
    "udpTimeoutDesc": MessageLookupByLibrary.simpleMessage(
      "UDP 超时以秒为单位，仅在 gvisor、system 和 mixed 栈生效。",
    ),
    "ultra": MessageLookupByLibrary.simpleMessage("极致"),
    "undo": MessageLookupByLibrary.simpleMessage("撤销"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("统一延迟"),
    "unknown": MessageLookupByLibrary.simpleMessage("未知"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage("未知网络错误"),
    "unmaximize": MessageLookupByLibrary.simpleMessage("向下还原"),
    "unnamed": MessageLookupByLibrary.simpleMessage("未命名"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("取消置顶"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "updateAll": MessageLookupByLibrary.simpleMessage("更新全部"),
    "updateDownloadFailed": MessageLookupByLibrary.simpleMessage("无法下载更新。"),
    "updateDownloadStarted": MessageLookupByLibrary.simpleMessage(
      "已开始下载更新，可在首页查看进度",
    ),
    "updateDownloadTest": MessageLookupByLibrary.simpleMessage("更新下载测试"),
    "updateFailed": MessageLookupByLibrary.simpleMessage("更新失败"),
    "updateInstallFailed": MessageLookupByLibrary.simpleMessage(
      "无法安装更新，可以前往发布页手动下载。",
    ),
    "updateNotVerified": MessageLookupByLibrary.simpleMessage("下载的更新未通过校验。"),
    "updateReady": MessageLookupByLibrary.simpleMessage("更新已就绪"),
    "updateReadyTip": MessageLookupByLibrary.simpleMessage("更新已下载，点击安装"),
    "updateRestartTip": MessageLookupByLibrary.simpleMessage(
      "天机云将关闭以安装更新，完成后自动重新打开。",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("上传"),
    "uploadBandwidth": MessageLookupByLibrary.simpleMessage("上行带宽"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlRewrite": MessageLookupByLibrary.simpleMessage("URL 重写"),
    "urlTip": m127,
    "useHosts": MessageLookupByLibrary.simpleMessage("使用Hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("使用系统Hosts"),
    "usedShort": MessageLookupByLibrary.simpleMessage("已用"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("已用流量"),
    "userAgent": MessageLookupByLibrary.simpleMessage("用户代理"),
    "username": MessageLookupByLibrary.simpleMessage("用户名"),
    "validUntil": m128,
    "value": MessageLookupByLibrary.simpleMessage("值"),
    "view": MessageLookupByLibrary.simpleMessage("查看"),
    "viewAll": MessageLookupByLibrary.simpleMessage("查看全部"),
    "virtualIpv4": MessageLookupByLibrary.simpleMessage("虚拟 IPv4"),
    "vividStyle": MessageLookupByLibrary.simpleMessage("鲜明"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "VPN 相关配置已改动，点击重启",
    ),
    "vpnTraffic": MessageLookupByLibrary.simpleMessage("VPN"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage("WebDAV配置"),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("白名单模式"),
    "writeToSystem": MessageLookupByLibrary.simpleMessage("写入系统"),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "写入系统会同时设置系统时钟，Android 上不生效。",
    ),
    "yearsAgo": m129,
    "yearsAgoShort": m130,
    "yes": MessageLookupByLibrary.simpleMessage("是"),
    "zhCN": MessageLookupByLibrary.simpleMessage("中文简体"),
    "zzAutoUpdateHours": m131,
    "zzAutoUpdateIntervalLabel": m132,
    "zzExpiryDate": m133,
    "zzProfileBasedOnOverrides": m134,
    "zzProfileExpiredDays": m135,
    "zzProfileImportHint": m136,
    "zzProfileImportedOn": m137,
    "zzQuickClipboard": MessageLookupByLibrary.simpleMessage("剪贴板"),
    "zzQuickLocalFile": MessageLookupByLibrary.simpleMessage("本地文件"),
    "zzQuickScan": MessageLookupByLibrary.simpleMessage("扫码"),
    "zzRemaining": MessageLookupByLibrary.simpleMessage("剩余"),
    "zzRemainingDayUnit": MessageLookupByLibrary.simpleMessage("天"),
    "zzRenewUpgradeShort": MessageLookupByLibrary.simpleMessage("续费 / 升级"),
    "zzTotalQuota": m138,
  };
}
