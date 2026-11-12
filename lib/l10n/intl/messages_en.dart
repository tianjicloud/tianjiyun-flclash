// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, other: '${count} selected')}";

  static String m1(name) => "Added ${name} to local proxies";

  static String m2(name) => "${name} is already in local proxies";

  static String m3(count, skipped) =>
      "${count} to add, ${skipped} skipped as existing";

  static String m4(time) => "Checked at ${time}";

  static String m5(line) => "Traffic will exit through “${line}”";

  static String m6(name, status) => "Current: ${name} · ${status}";

  static String m7(actual, expected) =>
      "Exit is in ${actual}, while the selected line is in ${expected}";

  static String m8(name, ip) => "Selected “${name}” matches exit ${ip}";

  static String m9(date) => "Expires ${date}";

  static String m10(month, day) => "${month}/${day}";

  static String m11(date) =>
      "Plan expires ${date}; renew to keep your lines active";

  static String m12(value) => "Rate ${value}×";

  static String m13(days) => "Expired ${days} days ago";

  static String m14(date) =>
      "This plan expired on ${date}. Renew it, then validate the same link again.";

  static String m15(step, total) =>
      "Step ${step} of ${total} · Validate subscription";

  static String m16(count) => "Checked · ${count}";

  static String m17(count) => "${count} apps selected";

  static String m18(name) =>
      "The home broadband group is locked to “${name}”. Change it in the home broadband lines.";

  static String m19(time) => "Subscription updated ${time}";

  static String m20(categories) => "Direct datacenter exit for: ${categories}";

  static String m21(count) => "${count} apps";

  static String m22(count) => "${count} passed";

  static String m23(count) => "${count} requests";

  static String m24(version) => "Update available: ${version}";

  static String m25(percent) => "${percent}% used";

  static String m26(count) => "Wi-Fi rules ${count} items";

  static String m27(detail) => "Couldn\'t clear the data: ${detail}";

  static String m28(count, download, upload) =>
      "Total ${count} connections · Download ${download} · Upload ${upload} · Select a row to view the full chain and matched rule";

  static String m29(code) =>
      "Windows refused to run TianjiCloudCore.exe (error ${code}). An app control policy such as Smart App Control or AppLocker blocks unsigned programs; allow 天机云 in that policy or turn it off, then try again.";

  static String m30(name) =>
      "The app failed to finish launching twice in a row. To break the loop, the profile ${name} has been deselected and automatic setup was skipped. You can select it again at any time.";

  static String m31(url) => "Do you want to create a profile from ${url}?";

  static String m32(members, count) => "${members} and ${count} more";

  static String m33(count) => "Used by ${count} rules";

  static String m34(count, label) =>
      "${Intl.plural(count, one: '1 SUB-RULE rule was dropped, since custom profiles do not support sub-rules', other: '${label} SUB-RULE rules were dropped, since custom profiles do not support sub-rules')}";

  static String m35(message) => "The core cannot parse this proxy: ${message}";

  static String m36(proxy, target) =>
      "${proxy} dials through ${target}, which leads back to ${proxy}, so the dial loops";

  static String m37(name) =>
      "The name ${name} is already used by another proxy or proxy group";

  static String m38(path) =>
      "Proxy groups reference each other in a loop: ${path}";

  static String m39(name) =>
      "The empty fallback must be a proxy, but ${name} does not exist or is a proxy group";

  static String m40(name, message) =>
      "${name} is not a valid regex: ${message}";

  static String m41(name) => "The dialer proxy ${name} does not exist";

  static String m42(names) => "These proxy providers do not exist: ${names}";

  static String m43(names) =>
      "These proxies or policies do not exist: ${names}";

  static String m44(name) =>
      "${name} is a built-in policy name and cannot be used here";

  static String m45(count) =>
      "${count} items have problems, and applying this profile may fail";

  static String m46(count) => "Used by ${count} groups";

  static String m47(count) =>
      "${Intl.plural(count, one: '1 day ago', other: '${count} days ago')}";

  static String m48(count) => "${Intl.plural(count, other: '${count}d ago')}";

  static String m49(label) =>
      "Are you sure you want to delete the selected ${label}?";

  static String m50(label) => "Are you sure you want to delete this ${label}?";

  static String m51(hours) =>
      "Resources check for updates every ${hours} hours; if a download fails, the previous version remains in use.";

  static String m52(label) => "${label} details";

  static String m53(name) =>
      "Dialing through ${name} leads back to the proxy that uses it, so the connection was stopped";

  static String m54(label) => "${label} cannot be empty";

  static String m55(label) => "${label} already exists";

  static String m56(count) => "${count} items failed. Tap to view";

  static String m57(label, message) => "${label}: ${message}";

  static String m58(name) => "${name} is already up to date";

  static String m59(name) => "${name} updated";

  static String m60(count) =>
      "${Intl.plural(count, one: '1 group', other: '${count} groups')}";

  static String m61(count) => "${count} timed out";

  static String m62(action) =>
      "Already used by “${action}”. Saving moves it here.";

  static String m63(modifiers) => "Include at least one of ${modifiers}";

  static String m64(count) =>
      "${Intl.plural(count, one: '1 hour ago', other: '${count} hours ago')}";

  static String m65(count) => "${Intl.plural(count, other: '${count}h ago')}";

  static String m66(encoding) =>
      "Could not decode ${encoding}, so this is the data as it was sent.";

  static String m67(memory, body) =>
      "The oldest records go first once this many are kept or they fill ${memory} of memory. Each body keeps its first ${body}.";

  static String m68(invalid, total) => "${invalid} of ${total} invalid";

  static String m69(target) => "${target} is an invalid policy";

  static String m70(proxyName) => "${proxyName} is an invalid proxy";

  static String m71(providerName) =>
      "${providerName} is an invalid proxy provider";

  static String m72(ruleSet) => "${ruleSet} is an invalid rule set";

  static String m73(subRule) => "${subRule} is an invalid SUB_RULE";

  static String m74(count) =>
      "${Intl.plural(count, one: '1 item', other: '${count} items')}";

  static String m75(line, message) => "Line ${line}: ${message}";

  static String m76(appName) =>
      "1. Open System Settings > Privacy & Security\n2. Choose Location Services\n3. Find and check ${appName} in the list\n\nWhen you are done, return to the app to continue. Thank you for your cooperation.";

  static String m77(label, max) => "${label} must be at most ${max} characters";

  static String m78(size) => "Released ${size}";

  static String m79(count) =>
      "${Intl.plural(count, one: '1 minute ago', other: '${count} minutes ago')}";

  static String m80(count) => "${Intl.plural(count, other: '${count}m ago')}";

  static String m81(fileName) =>
      "Saved ${fileName} to Downloads. Install it in Settings under Security › Encryption & credentials › Install a certificate › CA certificate.";

  static String m82(command) =>
      "Chrome and Firefox keep their own certificate stores, which need certutil: ${command}";

  static String m83(host) =>
      "Add ${host} to the hostname list? 天机云 can then read what is sent to it, cookies and passwords included.";

  static String m84(host) =>
      "Add -${host} to the top of the hostname list? The host is then never decrypted.";

  static String m85(size) => "The file is larger than ${size} MB";

  static String m86(stores) => "Not yet in: ${stores}";

  static String m87(name) => "${name} changed its scripts and was turned off";

  static String m88(system) =>
      "Written for ${system}; some lines may not match apps on this device.";

  static String m89(name) =>
      "The old certificate, ${name}, could not be removed. Remove it from the trusted roots yourself.";

  static String m90(name) =>
      "The old certificate, ${name}, is still among the system\'s trusted CAs. Allow 天机云 root access in your root manager and regenerate, or remove the TianjiCloud MITM CA module there and restart.";

  static String m91(name) =>
      "Remove the old certificate, ${name}, in Settings under Security › Encryption & credentials › Trusted credentials › User, then install the new one.";

  static String m92(section) => "The [${section}] section is not supported";

  static String m93(count) =>
      "${Intl.plural(count, one: '1 month ago', other: '${count} months ago')}";

  static String m94(count) => "${Intl.plural(count, other: '${count}mo ago')}";

  static String m95(code) =>
      "The server denied access (HTTP ${code}). The link may have expired, or the credentials are wrong";

  static String m96(code) => "The server rejected the request (HTTP ${code})";

  static String m97(code) =>
      "Nothing was found at this address (HTTP ${code}). Check that the URL is correct";

  static String m98(detail) => "Network request failed: ${detail}";

  static String m99(code) =>
      "The server ran into a problem (HTTP ${code}). Try again later";

  static String m100(label) => "No ${label} yet";

  static String m101(label, min, max) =>
      "${label} must be between ${min} and ${max}";

  static String m102(label) => "${label} must be a number";

  static String m103(count) => "Imported · ${count} nodes";

  static String m104(label) => "${label} must be between 1024 and 49151";

  static String m105(port) => "Port ${port}";

  static String m106(days) =>
      "${Intl.plural(days, one: '1 day left', other: '${days} days left')}";

  static String m107(date, days) =>
      "Expires ${date}, ${Intl.plural(days, one: '1 day', other: '${days} days')} left";

  static String m108(time) => "Updated ${time}";

  static String m109(count) => "${count} items";

  static String m110(label, profiles) =>
      "${label} is still used by ${profiles}, which will not work properly once it is deleted. Are you sure you want to delete it?";

  static String m111(count, label) =>
      "${Intl.plural(count, one: '1 proxy', other: '${label} proxies')}";

  static String m112(name, count) => "${name} and others (${count} proxies)";

  static String m113(removed) =>
      "These proxies will be deleted: ${removed}. A line whose name changed counts as a new proxy, and custom profiles naming the deleted ones will flag them as missing. Apply anyway?";

  static String m114(removed, added) =>
      "These proxies will be deleted: ${removed}. These will be added: ${added}. A line whose name changed counts as a new proxy, and custom profiles naming the deleted ones will flag them as missing. Apply anyway?";

  static String m115(label) =>
      "${label} is still named by rules, proxy groups, dialer proxies, DNS or NTP in this profile, which stop working once it is deleted. Are you sure you want to delete it?";

  static String m116(count, label) =>
      "${Intl.plural(count, one: '1 proxy group', other: '${label} proxy groups')}";

  static String m117(line) =>
      "“${line}” failed 3 consecutive checks. Check the line or try again.";

  static String m118(name) => "Use ${name}";

  static String m119(count, label) =>
      "${Intl.plural(count, one: '1 rule', other: '${label} rules')}";

  static String m120(appName) => "${appName} (Safe mode)";

  static String m121(count) =>
      "${Intl.plural(count, one: '1 second', other: '${count} seconds')}";

  static String m122(count) => "${count} in effect";

  static String m123(count) =>
      "${Intl.plural(count, one: '1 issue', other: '${count} issues')}";

  static String m124(count) =>
      "${Intl.plural(count, one: '1 setting', other: '${count} settings')}";

  static String m125(link) => "No proxy could be read from ${link}";

  static String m126(label) => "${label} must be a single item";

  static String m127(name, date) => "${name} · ${date}";

  static String m128(days) => "Your plan expires in ${days} days";

  static String m129(value) => "Peak ${value}";

  static String m130(value) => "Total ${value}";

  static String m131(transport) => "${transport} Headers";

  static String m132(label) => "${label} must be a URL";

  static String m133(date) => "Valid until ${date}";

  static String m134(count) =>
      "${Intl.plural(count, one: '1 year ago', other: '${count} years ago')}";

  static String m135(count) => "${Intl.plural(count, other: '${count}y ago')}";

  static String m136(hours) => "every ${hours} hours auto update";

  static String m137(count, unit) => "Auto update every ${count} ${unit}";

  static String m138(date) => "Expires ${date}";

  static String m139(count) =>
      "Based on current subscription · ${count} override rules";

  static String m140(count) => "Subscription link · expired ${count} days ago";

  static String m141(scheme) =>
      "You can also paste a link from clipboard, choose a local YAML file, or open ${scheme} in a browser to import a link.";

  static String m142(date) => "Local file · imported ${date}";

  static String m143(quota) => "Total ${quota}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Access control"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Only selected apps go through the VPN",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "App access control is disabled",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Selected apps are excluded from the VPN",
    ),
    "accessControlSelectedCount": m0,
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "action": MessageLookupByLibrary.simpleMessage("Action"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage("Test all delays"),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("Direct mode"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("Global mode"),
    "actionMode": MessageLookupByLibrary.simpleMessage("Switch mode"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("Rule mode"),
    "actionStart": MessageLookupByLibrary.simpleMessage("Start/Stop"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage(
      "Update profiles",
    ),
    "actionView": MessageLookupByLibrary.simpleMessage("Show/Hide"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("Add proxy"),
    "addFilters": MessageLookupByLibrary.simpleMessage("Add filters"),
    "addNodes": MessageLookupByLibrary.simpleMessage("Add nodes"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage(
      "Add override entry",
    ),
    "addProfile": MessageLookupByLibrary.simpleMessage("Add profile"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("Add proxy group"),
    "addRule": MessageLookupByLibrary.simpleMessage("Add rule"),
    "addSettingEntry": MessageLookupByLibrary.simpleMessage("Add setting"),
    "addSsid": MessageLookupByLibrary.simpleMessage("Add SSID"),
    "addToLocalProxies": MessageLookupByLibrary.simpleMessage(
      "Add to local proxies",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Added rules"),
    "addedToLocalProxies": m1,
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Additional parameters",
    ),
    "additionalPrefix": MessageLookupByLibrary.simpleMessage("Name prefix"),
    "additionalSuffix": MessageLookupByLibrary.simpleMessage("Name suffix"),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid WebDAV address",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Advanced configuration",
    ),
    "ageEncryptedProfile": MessageLookupByLibrary.simpleMessage(
      "Encrypted profile",
    ),
    "ageSecretKey": MessageLookupByLibrary.simpleMessage("Age secret key"),
    "ageSecretKeyRequiredTip": MessageLookupByLibrary.simpleMessage(
      "This profile is encrypted with age and needs an age secret key to decrypt",
    ),
    "agree": MessageLookupByLibrary.simpleMessage("Agree"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "allReferencedProxies": MessageLookupByLibrary.simpleMessage(
      "All referenced proxies",
    ),
    "allReferencedProxyProviders": MessageLookupByLibrary.simpleMessage(
      "All referenced proxy providers",
    ),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Allow apps to bypass VPN",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Allow LAN"),
    "allowedIps": MessageLookupByLibrary.simpleMessage("Allowed IPs"),
    "alreadyInLocalProxies": m2,
    "answers": MessageLookupByLibrary.simpleMessage("Answers"),
    "app": MessageLookupByLibrary.simpleMessage("App"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "App access control",
    ),
    "appBackground": MessageLookupByLibrary.simpleMessage("Background"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage("App icon design"),
    "appProxiesEmpty": MessageLookupByLibrary.simpleMessage("No local proxies"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Append system DNS",
    ),
    "applied": MessageLookupByLibrary.simpleMessage("Applied"),
    "applyNow": MessageLookupByLibrary.simpleMessage("Apply now"),
    "arguments": MessageLookupByLibrary.simpleMessage("Arguments"),
    "authentication": MessageLookupByLibrary.simpleMessage("Authentication"),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "The system proxy is not applied while authentication is on.",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("Authorize"),
    "authorized": MessageLookupByLibrary.simpleMessage("Authorized"),
    "auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Auto check for updates",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Auto close connections",
    ),
    "autoInclude": MessageLookupByLibrary.simpleMessage("Auto-include"),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Auto launch"),
    "autoRun": MessageLookupByLibrary.simpleMessage("Auto run"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Auto run starts the proxy when the app opens.",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Auto-set system DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Auto update"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Auto-update interval",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backgroundAurora": MessageLookupByLibrary.simpleMessage("Aurora"),
    "backgroundBlur": MessageLookupByLibrary.simpleMessage("Background blur"),
    "backgroundGlobe": MessageLookupByLibrary.simpleMessage("Globe"),
    "backgroundMountains": MessageLookupByLibrary.simpleMessage("Mountains"),
    "backgroundNebula": MessageLookupByLibrary.simpleMessage("Nebula"),
    "backgroundOrbit": MessageLookupByLibrary.simpleMessage("Orbit"),
    "backgroundPlanet": MessageLookupByLibrary.simpleMessage("Planet"),
    "backgroundSolid": MessageLookupByLibrary.simpleMessage("Solid color"),
    "backup": MessageLookupByLibrary.simpleMessage("Backup"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Backup and restore",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "This backup comes from a newer version of the app. Update the app before restoring it",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("Backup successful"),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Basic info"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("Basic strategies"),
    "batchImport": MessageLookupByLibrary.simpleMessage("Batch import"),
    "batchLineInputTip": MessageLookupByLibrary.simpleMessage(
      "One item per line",
    ),
    "batchLinkInputTip": MessageLookupByLibrary.simpleMessage(
      "One link per line",
    ),
    "batchPreviewTip": m3,
    "batchUrlInputTip": MessageLookupByLibrary.simpleMessage(
      "One URL per line",
    ),
    "binaryData": MessageLookupByLibrary.simpleMessage("Binary data"),
    "bind": MessageLookupByLibrary.simpleMessage("Bind"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("Blacklist mode"),
    "blockQuic": MessageLookupByLibrary.simpleMessage("Block QUIC"),
    "bodyRewrite": MessageLookupByLibrary.simpleMessage("Body rewrite"),
    "brandName": MessageLookupByLibrary.simpleMessage("Tianji Cloud"),
    "brightness": MessageLookupByLibrary.simpleMessage("Brightness"),
    "businessAboutBackupTitle": MessageLookupByLibrary.simpleMessage(
      "About and backup",
    ),
    "businessAboutPanel": MessageLookupByLibrary.simpleMessage(
      "User panel and renewal",
    ),
    "businessAccentColor": MessageLookupByLibrary.simpleMessage("Accent color"),
    "businessAdvancedNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "Advanced Network Settings",
    ),
    "businessAiServiceLabel": MessageLookupByLibrary.simpleMessage(
      "AI services",
    ),
    "businessAiServices": MessageLookupByLibrary.simpleMessage(
      "ChatGPT · Claude",
    ),
    "businessAllLines": MessageLookupByLibrary.simpleMessage("All lines"),
    "businessAllowBypassDescription": MessageLookupByLibrary.simpleMessage(
      "Allow selected apps to connect outside the VPN.",
    ),
    "businessAppProxyTitle": MessageLookupByLibrary.simpleMessage(
      "Per-app proxy",
    ),
    "businessAuthorizeTun": MessageLookupByLibrary.simpleMessage(
      "Authorize virtual adapter",
    ),
    "businessAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Run in the background after signing in to Windows",
    ),
    "businessAutoLaunchTitle": MessageLookupByLibrary.simpleMessage(
      "Launch at startup",
    ),
    "businessAutoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Use the previous line and mode",
    ),
    "businessAutoRunTitle": MessageLookupByLibrary.simpleMessage(
      "Connect on launch",
    ),
    "businessAutoTest": MessageLookupByLibrary.simpleMessage("Automatic test"),
    "businessBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Save your profiles and app settings to a backup file.",
    ),
    "businessBackupNow": MessageLookupByLibrary.simpleMessage("Back up now"),
    "businessCards": MessageLookupByLibrary.simpleMessage("Cards"),
    "businessChangeLine": MessageLookupByLibrary.simpleMessage("Change line"),
    "businessCheckedAt": m4,
    "businessChooseLine": MessageLookupByLibrary.simpleMessage("Change line"),
    "businessClientVersion": MessageLookupByLibrary.simpleMessage(
      "Client version",
    ),
    "businessClientVersionDesc": MessageLookupByLibrary.simpleMessage(
      "Currently installed client version",
    ),
    "businessCloseAllConnections": MessageLookupByLibrary.simpleMessage(
      "Close all",
    ),
    "businessCloseWindow": MessageLookupByLibrary.simpleMessage(
      "When closing the window",
    ),
    "businessConnectVia": m5,
    "businessConnectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Connected · Issue detected",
    ),
    "businessConnectedDisconnect": MessageLookupByLibrary.simpleMessage(
      "Connected · Click to disconnect",
    ),
    "businessConnectedProbeFailed": MessageLookupByLibrary.simpleMessage(
      "Connected · Exit check failed",
    ),
    "businessConnectedUnverified": MessageLookupByLibrary.simpleMessage(
      "Connected · Exit not verified",
    ),
    "businessCopyErrorInfo": MessageLookupByLibrary.simpleMessage(
      "Copy error info",
    ),
    "businessCurrent": MessageLookupByLibrary.simpleMessage("Current"),
    "businessCurrentExitIp": MessageLookupByLibrary.simpleMessage(
      "Current exit IP",
    ),
    "businessCurrentLine": MessageLookupByLibrary.simpleMessage("Current line"),
    "businessCurrentLineState": m6,
    "businessCurrentNode": MessageLookupByLibrary.simpleMessage("Current node"),
    "businessDatacenter": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "businessDelayTestShort": MessageLookupByLibrary.simpleMessage(
      "Test speed",
    ),
    "businessDelayTimeout": MessageLookupByLibrary.simpleMessage("Timeout"),
    "businessDeveloperDescription": MessageLookupByLibrary.simpleMessage(
      "Open diagnostics and advanced developer tools.",
    ),
    "businessDeveloperOptionsDescription": MessageLookupByLibrary.simpleMessage(
      "These options help diagnose problems. Most people do not need to change them.",
    ),
    "businessDeveloperOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "Developer options",
    ),
    "businessDisclaimerAgree": MessageLookupByLibrary.simpleMessage(
      "Agree and continue",
    ),
    "businessDisclaimerSubtitle": MessageLookupByLibrary.simpleMessage(
      "Shown once on first launch",
    ),
    "businessDisclaimerTitle": MessageLookupByLibrary.simpleMessage(
      "Please read before use",
    ),
    "businessDisconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
    "businessDnsAndSniffing": MessageLookupByLibrary.simpleMessage(
      "DNS and Sniffing",
    ),
    "businessDnsFailed": MessageLookupByLibrary.simpleMessage("Failed"),
    "businessDnsModeDescription": MessageLookupByLibrary.simpleMessage(
      "Choose how DNS answers are generated.",
    ),
    "businessDnsNoUpstream": MessageLookupByLibrary.simpleMessage(
      "No DNS upstream overrides are configured.",
    ),
    "businessDnsProxyResolved": MessageLookupByLibrary.simpleMessage(
      "Proxy resolved",
    ),
    "businessDnsResourcePreview": MessageLookupByLibrary.simpleMessage(
      "Routing resource preview",
    ),
    "businessDnsServers": MessageLookupByLibrary.simpleMessage("DNS servers"),
    "businessDnsSucceeded": MessageLookupByLibrary.simpleMessage("Success"),
    "businessDomainSniffingDescription": MessageLookupByLibrary.simpleMessage(
      "Read hostnames from supported network traffic.",
    ),
    "businessEnableRules": MessageLookupByLibrary.simpleMessage(
      "Enable smart routing",
    ),
    "businessErrorSolutions": MessageLookupByLibrary.simpleMessage(
      "Try these steps",
    ),
    "businessErrorStepChangePort": MessageLookupByLibrary.simpleMessage(
      "Change the port in Settings → Inbound and ports",
    ),
    "businessErrorStepClosePort": MessageLookupByLibrary.simpleMessage(
      "Close the program using port 7890, then reopen TianjiCloud",
    ),
    "businessExitAnomaly": MessageLookupByLibrary.simpleMessage(
      "Line anomaly. Contact support.",
    ),
    "businessExitCheckPassed": MessageLookupByLibrary.simpleMessage(
      "Exit check passed",
    ),
    "businessExitCountryMismatch": m7,
    "businessExitKindMismatch": MessageLookupByLibrary.simpleMessage(
      "The exit type does not match the selected line",
    ),
    "businessExitMismatch": MessageLookupByLibrary.simpleMessage(
      "Your selected line does not match the actual exit",
    ),
    "businessExitProbeDescription": MessageLookupByLibrary.simpleMessage(
      "The exit check returned no result. The proxy may still be working. Retry or run diagnostics to see why.",
    ),
    "businessExitProbeUnavailable": MessageLookupByLibrary.simpleMessage(
      "Unable to confirm exit for now",
    ),
    "businessExitTunDescription": MessageLookupByLibrary.simpleMessage(
      "The virtual adapter has not been authorized. Terminals and some apps are not using the proxy, so they see your local IP. Authorize it once to fix this.",
    ),
    "businessExitVerified": MessageLookupByLibrary.simpleMessage(
      "Connected · Exit verified",
    ),
    "businessExitVerifiedDetail": m8,
    "businessExitVerifiedShort": MessageLookupByLibrary.simpleMessage(
      "Exit verified",
    ),
    "businessExpiryDate": m9,
    "businessExpiryDateShort": m10,
    "businessExpiryNotice": m11,
    "businessFollowSystem": MessageLookupByLibrary.simpleMessage(
      "Follow system",
    ),
    "businessGroupHeader": MessageLookupByLibrary.simpleMessage("Groups"),
    "businessGroupLocked": MessageLookupByLibrary.simpleMessage("Locked"),
    "businessHelp": MessageLookupByLibrary.simpleMessage("Help"),
    "businessHome": MessageLookupByLibrary.simpleMessage("Home"),
    "businessHotkeyHint": MessageLookupByLibrary.simpleMessage(
      "Select a row to set or change its shortcut",
    ),
    "businessImportAgain": MessageLookupByLibrary.simpleMessage("Import again"),
    "businessImportRenew": MessageLookupByLibrary.simpleMessage("Renew"),
    "businessIntercept": MessageLookupByLibrary.simpleMessage("Intercept"),
    "businessKernelRestart": MessageLookupByLibrary.simpleMessage(
      "Restart core",
    ),
    "businessKernelStartFailed": MessageLookupByLibrary.simpleMessage(
      "The network core couldn\'t start",
    ),
    "businessKernelUptime": MessageLookupByLibrary.simpleMessage(
      "Running time",
    ),
    "businessLegal": MessageLookupByLibrary.simpleMessage("Legal"),
    "businessLineCount": MessageLookupByLibrary.simpleMessage("lines"),
    "businessLineFailed": MessageLookupByLibrary.simpleMessage(
      "Could not finish switching lines. Retry.",
    ),
    "businessLineSelectionHint": MessageLookupByLibrary.simpleMessage(
      "Manual selection takes priority: the selected line is the exit. After switching, the exit IP is checked and any mismatch includes its reason.",
    ),
    "businessLineSelectionHintShort": MessageLookupByLibrary.simpleMessage(
      "The selected line is the exit; its exit IP is checked after switching.",
    ),
    "businessLineTitle": MessageLookupByLibrary.simpleMessage("Default line"),
    "businessLines": MessageLookupByLibrary.simpleMessage("Lines"),
    "businessLinesEmpty": MessageLookupByLibrary.simpleMessage(
      "No lines loaded yet. Check your subscription.",
    ),
    "businessLinesLoading": MessageLookupByLibrary.simpleMessage(
      "Loading available lines…",
    ),
    "businessLocalExport": MessageLookupByLibrary.simpleMessage(
      "Export to local file",
    ),
    "businessLocalPorts": MessageLookupByLibrary.simpleMessage("Local ports"),
    "businessLocked": MessageLookupByLibrary.simpleMessage("Locked"),
    "businessLockedExit": MessageLookupByLibrary.simpleMessage("Exit locked"),
    "businessMainlandDirect": MessageLookupByLibrary.simpleMessage(
      "Mainland direct",
    ),
    "businessManage": MessageLookupByLibrary.simpleMessage("Manage"),
    "businessManualSelect": MessageLookupByLibrary.simpleMessage(
      "Manual selection",
    ),
    "businessMinimizeDesc": MessageLookupByLibrary.simpleMessage(
      "The tray icon always shows connection status",
    ),
    "businessMinimizeToTray": MessageLookupByLibrary.simpleMessage(
      "Minimize to tray",
    ),
    "businessMitmDescription": MessageLookupByLibrary.simpleMessage(
      "Inspect HTTPS traffic with the local certificate.",
    ),
    "businessMitmWarning": MessageLookupByLibrary.simpleMessage(
      "MITM decrypts HTTPS traffic for matching domains. Enable it only for modules you trust.",
    ),
    "businessMonthTraffic": MessageLookupByLibrary.simpleMessage("This month"),
    "businessMonthUsed": MessageLookupByLibrary.simpleMessage(
      "Used this month",
    ),
    "businessMoreVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Open remaining VPN interface options.",
    ),
    "businessMoreVpnSettings": MessageLookupByLibrary.simpleMessage(
      "More VPN settings",
    ),
    "businessMultiplier": m12,
    "businessNetworkStack": MessageLookupByLibrary.simpleMessage(
      "Network stack",
    ),
    "businessNoExitInfo": MessageLookupByLibrary.simpleMessage("No exit data"),
    "businessNotConnected": MessageLookupByLibrary.simpleMessage(
      "Not connected",
    ),
    "businessOnDemandConnection": MessageLookupByLibrary.simpleMessage(
      "On-demand connection",
    ),
    "businessOnDemandEmpty": MessageLookupByLibrary.simpleMessage(
      "Add a Wi-Fi network to pause the app when you connect to it.",
    ),
    "businessOnboardingFactDashboard": MessageLookupByLibrary.simpleMessage(
      "View connection statistics on the dashboard",
    ),
    "businessOnboardingFactImport": MessageLookupByLibrary.simpleMessage(
      "Import your subscription configuration",
    ),
    "businessOnboardingFactStatus": MessageLookupByLibrary.simpleMessage(
      "Check line connection status",
    ),
    "businessOnboardingFailedChangeLink": MessageLookupByLibrary.simpleMessage(
      "Use a different subscription link",
    ),
    "businessOnboardingFailedDays": m13,
    "businessOnboardingFailedExpiredDescription": m14,
    "businessOnboardingFailedExpiredTitle":
        MessageLookupByLibrary.simpleMessage("This subscription has expired"),
    "businessOnboardingFailedPackage": MessageLookupByLibrary.simpleMessage(
      "Plan",
    ),
    "businessOnboardingFailedPastedUrl": MessageLookupByLibrary.simpleMessage(
      "The link you pasted",
    ),
    "businessOnboardingFailedRenew": MessageLookupByLibrary.simpleMessage(
      "Renew now",
    ),
    "businessOnboardingFailedRetainedConfig": MessageLookupByLibrary.simpleMessage(
      "Your previous configuration is saved, and the client can continue to work.",
    ),
    "businessOnboardingFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Revalidate",
    ),
    "businessOnboardingFailedStatus": MessageLookupByLibrary.simpleMessage(
      "Status",
    ),
    "businessOnboardingFailedStep": m15,
    "businessOnboardingHeroTitle": MessageLookupByLibrary.simpleMessage(
      "Connect to Tianji Cloud in three steps",
    ),
    "businessOnboardingImportConnect": MessageLookupByLibrary.simpleMessage(
      "Import and connect",
    ),
    "businessOnboardingScanFile": MessageLookupByLibrary.simpleMessage(
      "Scan QR code / choose file",
    ),
    "businessOnboardingUrlHint": MessageLookupByLibrary.simpleMessage(
      "Paste a Tianji Cloud subscription link",
    ),
    "businessOnboardingUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Subscription link",
    ),
    "businessOpenSource": MessageLookupByLibrary.simpleMessage(
      "Open-source licenses",
    ),
    "businessOpenSourceDescription": MessageLookupByLibrary.simpleMessage(
      "Based on FlClash · GPL-3.0",
    ),
    "businessOrdinaryWebExit": MessageLookupByLibrary.simpleMessage(
      "Ordinary web exit",
    ),
    "businessOutboundLabel": MessageLookupByLibrary.simpleMessage("Outbound"),
    "businessOverrideSettings": MessageLookupByLibrary.simpleMessage(
      "Subscription overrides",
    ),
    "businessPortConflictTip": MessageLookupByLibrary.simpleMessage(
      "Port 7890 is occupied by another program, so TianjiCloud can\'t listen on it. Your network settings haven\'t been changed; you can continue browsing normally.",
    ),
    "businessPrivacyTerms": MessageLookupByLibrary.simpleMessage(
      "Privacy policy · Terms of service",
    ),
    "businessProfileAddAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Auto-update",
    ),
    "businessProfileAddClipboardRecognized":
        MessageLookupByLibrary.simpleMessage(
          "Tianji Cloud subscription link detected in the clipboard.",
        ),
    "businessProfileAddCustomDescription": MessageLookupByLibrary.simpleMessage(
      "Add rules to an existing subscription",
    ),
    "businessProfileAddCustomTitle": MessageLookupByLibrary.simpleMessage(
      "Custom configuration",
    ),
    "businessProfileAddFileDescription": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "businessProfileAddFileTitle": MessageLookupByLibrary.simpleMessage(
      "Local file",
    ),
    "businessProfileAddLinkDescription": MessageLookupByLibrary.simpleMessage(
      "Copy from the user panel",
    ),
    "businessProfileAddLinkTitle": MessageLookupByLibrary.simpleMessage(
      "Subscription link",
    ),
    "businessProfileAddMoreOptions": MessageLookupByLibrary.simpleMessage(
      "More options",
    ),
    "businessProfileAddNameHint": MessageLookupByLibrary.simpleMessage(
      "Leave blank to use the plan name in the subscription",
    ),
    "businessProfileAddNameLabel": MessageLookupByLibrary.simpleMessage(
      "Name (optional)",
    ),
    "businessProfileAddSubmit": MessageLookupByLibrary.simpleMessage(
      "Import and verify",
    ),
    "businessProfileAddTitle": MessageLookupByLibrary.simpleMessage(
      "Add subscription",
    ),
    "businessProfileAddUrlHint": MessageLookupByLibrary.simpleMessage(
      "Paste subscription link",
    ),
    "businessProfileAddUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Subscription link",
    ),
    "businessProfileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "The import is validated first. A parsing failure will not replace the active profile.",
    ),
    "businessProfileEditDelete": MessageLookupByLibrary.simpleMessage(
      "Delete this subscription",
    ),
    "businessProfileEditDeleteDescription": MessageLookupByLibrary.simpleMessage(
      "Only removes this local configuration. Your Tianji Cloud account and plan are unaffected.",
    ),
    "businessProfileEditDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Delete subscription",
    ),
    "businessProfileEditExpire": MessageLookupByLibrary.simpleMessage(
      "Expires",
    ),
    "businessProfileEditExtendDescription":
        MessageLookupByLibrary.simpleMessage("Overrides enabled: "),
    "businessProfileEditExtendSuffix": MessageLookupByLibrary.simpleMessage(
      " items",
    ),
    "businessProfileEditExtensionTitle": MessageLookupByLibrary.simpleMessage(
      "Overrides & scripts",
    ),
    "businessProfileEditGroupCountSuffix": MessageLookupByLibrary.simpleMessage(
      " groups",
    ),
    "businessProfileEditHide": MessageLookupByLibrary.simpleMessage("Hide"),
    "businessProfileEditLineCountSeparator":
        MessageLookupByLibrary.simpleMessage(" · "),
    "businessProfileEditLineLabel": MessageLookupByLibrary.simpleMessage(
      "Lines",
    ),
    "businessProfileEditManage": MessageLookupByLibrary.simpleMessage("Manage"),
    "businessProfileEditOpen": MessageLookupByLibrary.simpleMessage("Open"),
    "businessProfileEditPlan": MessageLookupByLibrary.simpleMessage("Plan"),
    "businessProfileEditPreviewDescription":
        MessageLookupByLibrary.simpleMessage(
          "Read-only preview. Use custom configuration to make changes.",
        ),
    "businessProfileEditPrivacy": MessageLookupByLibrary.simpleMessage(
      "This link contains a personal token. Do not share it.",
    ),
    "businessProfileEditRawTitle": MessageLookupByLibrary.simpleMessage(
      "View raw configuration",
    ),
    "businessProfileEditRenew": MessageLookupByLibrary.simpleMessage(
      "Renew / upgrade",
    ),
    "businessProfileEditShow": MessageLookupByLibrary.simpleMessage("Show"),
    "businessProfileEditSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "Plan details",
    ),
    "businessProfileEditTitle": MessageLookupByLibrary.simpleMessage(
      "Edit subscription",
    ),
    "businessProfilesSortDescription": MessageLookupByLibrary.simpleMessage(
      "Drag to change order. Earlier subscriptions appear first in the dashboard and tray.",
    ),
    "businessProfilesSortTitle": MessageLookupByLibrary.simpleMessage(
      "Reorder subscriptions",
    ),
    "businessProvidersTitle": MessageLookupByLibrary.simpleMessage(
      "Proxy sets and rule sets",
    ),
    "businessProxyCardDensity": MessageLookupByLibrary.simpleMessage(
      "Proxy card density",
    ),
    "businessProxyCheckedGroup": m16,
    "businessProxyDnsRemote": MessageLookupByLibrary.simpleMessage(
      "Proxy traffic domains are resolved by the route",
    ),
    "businessProxyIcons": MessageLookupByLibrary.simpleMessage("Proxy icons"),
    "businessProxyNextConnection": MessageLookupByLibrary.simpleMessage(
      "Changes take effect on the next connection",
    ),
    "businessProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Proxy sets",
    ),
    "businessProxyReconnect": MessageLookupByLibrary.simpleMessage(
      "Reconnect now",
    ),
    "businessProxySearchHint": MessageLookupByLibrary.simpleMessage(
      "Search apps",
    ),
    "businessProxySelectedBypass": MessageLookupByLibrary.simpleMessage(
      "Bypass proxy for checked apps",
    ),
    "businessProxySelectedCount": m17,
    "businessProxySelectedOnly": MessageLookupByLibrary.simpleMessage(
      "Only proxy checked apps",
    ),
    "businessProxyTraffic": MessageLookupByLibrary.simpleMessage("Proxy"),
    "businessProxyUncheckedGroup": MessageLookupByLibrary.simpleMessage(
      "Not checked",
    ),
    "businessRecheck": MessageLookupByLibrary.simpleMessage("Verify again"),
    "businessRegionAT": MessageLookupByLibrary.simpleMessage("Austria"),
    "businessRegionAU": MessageLookupByLibrary.simpleMessage("Australia"),
    "businessRegionBE": MessageLookupByLibrary.simpleMessage("Belgium"),
    "businessRegionBR": MessageLookupByLibrary.simpleMessage("Brazil"),
    "businessRegionCA": MessageLookupByLibrary.simpleMessage("Canada"),
    "businessRegionCO": MessageLookupByLibrary.simpleMessage("Colombia"),
    "businessRegionCZ": MessageLookupByLibrary.simpleMessage("Czechia"),
    "businessRegionDE": MessageLookupByLibrary.simpleMessage("Germany"),
    "businessRegionFR": MessageLookupByLibrary.simpleMessage("France"),
    "businessRegionGB": MessageLookupByLibrary.simpleMessage("United Kingdom"),
    "businessRegionHK": MessageLookupByLibrary.simpleMessage("Hong Kong"),
    "businessRegionIT": MessageLookupByLibrary.simpleMessage("Italy"),
    "businessRegionJP": MessageLookupByLibrary.simpleMessage("Japan"),
    "businessRegionKR": MessageLookupByLibrary.simpleMessage("South Korea"),
    "businessRegionLocalDns": MessageLookupByLibrary.simpleMessage(
      "Mainland domains are resolved locally",
    ),
    "businessRegionRO": MessageLookupByLibrary.simpleMessage("Romania"),
    "businessRegionSE": MessageLookupByLibrary.simpleMessage("Sweden"),
    "businessRegionSG": MessageLookupByLibrary.simpleMessage("Singapore"),
    "businessRegionTW": MessageLookupByLibrary.simpleMessage("Taiwan"),
    "businessRegionUS": MessageLookupByLibrary.simpleMessage("United States"),
    "businessReplace": MessageLookupByLibrary.simpleMessage("Replace"),
    "businessResidential": MessageLookupByLibrary.simpleMessage("Residential"),
    "businessResidentialBroadband": MessageLookupByLibrary.simpleMessage(
      "Residential broadband",
    ),
    "businessResidentialLockedHint": m18,
    "businessResidentialShort": MessageLookupByLibrary.simpleMessage(
      "Residential",
    ),
    "businessRestoreAction": MessageLookupByLibrary.simpleMessage("Restore…"),
    "businessRestoreFromFileWebDav": MessageLookupByLibrary.simpleMessage(
      "Restore from file or WebDAV",
    ),
    "businessRoutingDesc": MessageLookupByLibrary.simpleMessage(
      "This changes only the default line. AI and streaming keep their own routing rules; direct and blocking rules stay unchanged.",
    ),
    "businessRuleModeRequired": MessageLookupByLibrary.simpleMessage(
      "Smart routing is not active. This default line is not currently in effect.",
    ),
    "businessRuleOverrideDescription": MessageLookupByLibrary.simpleMessage(
      "Manage routing rules and provider overrides.",
    ),
    "businessRuleProviders": MessageLookupByLibrary.simpleMessage("Rule sets"),
    "businessScanPrompt": MessageLookupByLibrary.simpleMessage(
      "Place the subscription QR code inside the frame",
    ),
    "businessSearchHint": MessageLookupByLibrary.simpleMessage(
      "Search line name or region",
    ),
    "businessSelected": MessageLookupByLibrary.simpleMessage("Selected"),
    "businessSelectionStale": MessageLookupByLibrary.simpleMessage(
      "The subscription or mode changed. Reopen line selection.",
    ),
    "businessServiceNoLogin": MessageLookupByLibrary.simpleMessage(
      "No login required",
    ),
    "businessSettingsAbout": MessageLookupByLibrary.simpleMessage(
      "About Tianji Cloud",
    ),
    "businessSettingsAppearance": MessageLookupByLibrary.simpleMessage(
      "Appearance",
    ),
    "businessSettingsCommon": MessageLookupByLibrary.simpleMessage("Common"),
    "businessSettingsDnsResources": MessageLookupByLibrary.simpleMessage(
      "DNS and resources",
    ),
    "businessSettingsHotkeys": MessageLookupByLibrary.simpleMessage(
      "Shortcuts",
    ),
    "businessSettingsIconsUa": MessageLookupByLibrary.simpleMessage(
      "Icons and UA",
    ),
    "businessSettingsInboundPorts": MessageLookupByLibrary.simpleMessage(
      "Inbound and ports",
    ),
    "businessSettingsNetworkAdvanced": MessageLookupByLibrary.simpleMessage(
      "Network (advanced)",
    ),
    "businessSettingsOther": MessageLookupByLibrary.simpleMessage("Other"),
    "businessSettingsRules": MessageLookupByLibrary.simpleMessage(
      "Rules and overrides",
    ),
    "businessSettingsStartupWindow": MessageLookupByLibrary.simpleMessage(
      "Startup and window",
    ),
    "businessSettingsTun": MessageLookupByLibrary.simpleMessage(
      "Virtual adapter TUN",
    ),
    "businessSmartRouting": MessageLookupByLibrary.simpleMessage(
      "Smart routing",
    ),
    "businessSortByDelay": MessageLookupByLibrary.simpleMessage(
      "Sort by delay",
    ),
    "businessStackModeDescription": MessageLookupByLibrary.simpleMessage(
      "Choose the network stack used by the VPN.",
    ),
    "businessSubscriptionAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Subscription auto-update",
    ),
    "businessSubscriptionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Refreshes automatically when lines change",
    ),
    "businessSubscriptionDetails": MessageLookupByLibrary.simpleMessage(
      "Subscription details",
    ),
    "businessSubscriptionOverridesDescription":
        MessageLookupByLibrary.simpleMessage(
          "DNS settings supplied by this subscription.",
        ),
    "businessSubscriptionUpdatedAt": m19,
    "businessSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Subscriptions",
    ),
    "businessSubstitutedCategories": m20,
    "businessSwitchMode": MessageLookupByLibrary.simpleMessage("Switch mode"),
    "businessSystemProxyDescription": MessageLookupByLibrary.simpleMessage(
      "Route HTTP traffic through the system proxy.",
    ),
    "businessSystemProxyHttp": MessageLookupByLibrary.simpleMessage(
      "System proxy (HTTP)",
    ),
    "businessTapToConnect": MessageLookupByLibrary.simpleMessage(
      "Tap to connect",
    ),
    "businessTestAll": MessageLookupByLibrary.simpleMessage("Test all"),
    "businessToolsAppearance": MessageLookupByLibrary.simpleMessage(
      "Appearance",
    ),
    "businessToolsAppearanceLanguage": MessageLookupByLibrary.simpleMessage(
      "Appearance and language",
    ),
    "businessToolsApplicationCount": m21,
    "businessToolsBrowse": MessageLookupByLibrary.simpleMessage("Browse"),
    "businessToolsConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "Connections and requests",
    ),
    "businessToolsGeneral": MessageLookupByLibrary.simpleMessage("General"),
    "businessToolsLocalDirect": MessageLookupByLibrary.simpleMessage(
      "Connect local network devices directly",
    ),
    "businessToolsPassedCount": m22,
    "businessToolsPerAppProxy": MessageLookupByLibrary.simpleMessage(
      "Per-app proxy",
    ),
    "businessToolsRequestCount": m23,
    "businessToolsRoutingResources": MessageLookupByLibrary.simpleMessage(
      "Routing resources",
    ),
    "businessToolsRuntimeLogs": MessageLookupByLibrary.simpleMessage(
      "Runtime logs",
    ),
    "businessToolsSimplifiedChinese": MessageLookupByLibrary.simpleMessage(
      "Simplified Chinese",
    ),
    "businessTrafficNotOnTianji": MessageLookupByLibrary.simpleMessage(
      "Traffic is not using a Tianji route",
    ),
    "businessTrafficScope": MessageLookupByLibrary.simpleMessage(
      "Traffic this month on this device only",
    ),
    "businessTunBypassPrivateDescription": MessageLookupByLibrary.simpleMessage(
      "Access printers, NAS devices, and other LAN devices directly",
    ),
    "businessTunCaption": MessageLookupByLibrary.simpleMessage(
      "Route all app traffic",
    ),
    "businessTunDevice": MessageLookupByLibrary.simpleMessage("Adapter name"),
    "businessTunExcludedRoutes": MessageLookupByLibrary.simpleMessage(
      "Excluded routes",
    ),
    "businessTunMtu": MessageLookupByLibrary.simpleMessage("MTU"),
    "businessTunRouteCount": MessageLookupByLibrary.simpleMessage("routes"),
    "businessTunStackGvisorDescription": MessageLookupByLibrary.simpleMessage(
      "TCP and UDP use the gVisor userspace network stack",
    ),
    "businessTunStackMipsDescription": MessageLookupByLibrary.simpleMessage(
      "TCP and UDP use the mipstack user-space network stack",
    ),
    "businessTunStackMixed": MessageLookupByLibrary.simpleMessage("Mixed"),
    "businessTunStackMixedDescription": MessageLookupByLibrary.simpleMessage(
      "TCP uses the system stack; UDP uses gVisor for broad compatibility",
    ),
    "businessTunStackSystemDescription": MessageLookupByLibrary.simpleMessage(
      "TCP and UDP use the operating system network stack",
    ),
    "businessTunTakeoverDescription": MessageLookupByLibrary.simpleMessage(
      "The virtual adapter takes over all apps, including terminals, games, and apps that ignore the system proxy. The system service must run as administrator.",
    ),
    "businessTunTakeoverMode": MessageLookupByLibrary.simpleMessage(
      "Traffic takeover",
    ),
    "businessTunTitle": MessageLookupByLibrary.simpleMessage(
      "Virtual network interface (TUN)",
    ),
    "businessTypographyLayout": MessageLookupByLibrary.simpleMessage(
      "Text and layout",
    ),
    "businessUpdateAvailable": m24,
    "businessUpdateDaily": MessageLookupByLibrary.simpleMessage("Daily"),
    "businessUpdateHour1": MessageLookupByLibrary.simpleMessage("Every hour"),
    "businessUpdateHour12": MessageLookupByLibrary.simpleMessage(
      "Every 12 hours",
    ),
    "businessUpdateHour6": MessageLookupByLibrary.simpleMessage(
      "Every 6 hours",
    ),
    "businessUsagePercent": m25,
    "businessVersion": MessageLookupByLibrary.simpleMessage("Version"),
    "businessViewDiagnostics": MessageLookupByLibrary.simpleMessage(
      "View diagnostics",
    ),
    "businessVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "businessVpnPermission": MessageLookupByLibrary.simpleMessage(
      "Allow VPN permission on first connection",
    ),
    "businessWebDavBackup": MessageLookupByLibrary.simpleMessage(
      "WebDAV backup",
    ),
    "businessWifiRulesCount": m26,
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Bypass domains"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Bypass domains apply only while the system proxy is on.",
    ),
    "bypassPrivateRoute": MessageLookupByLibrary.simpleMessage(
      "Bypass private addresses",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Cache"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("Cache algorithm"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "The cache is corrupted. Clear it?",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("Cache size"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Allow camera access in system settings to scan QR codes, or choose a QR code image from the album.",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Camera permission required",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage(
      "Camera unavailable",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("Deselect all"),
    "cannotSave": MessageLookupByLibrary.simpleMessage("Can\'t save"),
    "certificate": MessageLookupByLibrary.simpleMessage("Certificate"),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "Failed to switch proxy; the previous selection has been restored",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage(
      "Breaking changes",
    ),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("New features"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("Bug fixes"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage("Performance"),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("Reverts"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage(
      "Verify TLS certificates",
    ),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "With TLS verification off, subscriptions and backups are open to man-in-the-middle attacks.",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Check for updates"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "The app is already up to date",
    ),
    "checkingExit": MessageLookupByLibrary.simpleMessage("Checking exit…"),
    "chooseFile": MessageLookupByLibrary.simpleMessage("Choose file"),
    "cipher": MessageLookupByLibrary.simpleMessage("Cipher"),
    "clearData": MessageLookupByLibrary.simpleMessage("Clear data"),
    "clearDataAndExitTip": MessageLookupByLibrary.simpleMessage(
      "This deletes all profiles, settings, and local data, then closes the app. Open it again to start fresh.",
    ),
    "clearDataFailed": m27,
    "clearDnsCache": MessageLookupByLibrary.simpleMessage("Clear DNS cache"),
    "clearDnsCacheFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to clear DNS cache",
    ),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Clear search"),
    "clientFingerprint": MessageLookupByLibrary.simpleMessage(
      "Client fingerprint",
    ),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Export to clipboard",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Import from clipboard",
    ),
    "clipboardNoPackageNames": MessageLookupByLibrary.simpleMessage(
      "No package names found in the clipboard",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t copy to the clipboard. The selection may be too large",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "closeAllConnections": MessageLookupByLibrary.simpleMessage(
      "Close all connections",
    ),
    "closeConnection": MessageLookupByLibrary.simpleMessage("Close connection"),
    "closeConnections": MessageLookupByLibrary.simpleMessage(
      "Close connections",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Color"),
    "colorStyle": MessageLookupByLibrary.simpleMessage("Color style"),
    "columns": MessageLookupByLibrary.simpleMessage("Columns"),
    "compact": MessageLookupByLibrary.simpleMessage("Compact"),
    "compatible": MessageLookupByLibrary.simpleMessage("Compatibility mode"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to clear all data?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this proxy group?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to exit the current window?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force crash the core?",
    ),
    "congestionControl": MessageLookupByLibrary.simpleMessage(
      "Congestion control",
    ),
    "congestionController": MessageLookupByLibrary.simpleMessage(
      "TCP congestion control",
    ),
    "congestionControllerDesc": MessageLookupByLibrary.simpleMessage(
      "TCP congestion control works only with the mips stack.",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting…"),
    "connection": MessageLookupByLibrary.simpleMessage("Connection"),
    "connectionAddDomainRule": MessageLookupByLibrary.simpleMessage(
      "Add a rule for this domain",
    ),
    "connectionBlockedLabel": MessageLookupByLibrary.simpleMessage("Blocked"),
    "connectionCloseThis": MessageLookupByLibrary.simpleMessage(
      "Close this connection",
    ),
    "connectionGroup": MessageLookupByLibrary.simpleMessage("Group"),
    "connectionLocalDevice": MessageLookupByLibrary.simpleMessage(
      "This device",
    ),
    "connectionMatchedRule": MessageLookupByLibrary.simpleMessage(
      "Matched rule",
    ),
    "connectionProcessPath": MessageLookupByLibrary.simpleMessage(
      "Process path",
    ),
    "connectionSearchHint": MessageLookupByLibrary.simpleMessage(
      "Search domain, app, or rule",
    ),
    "connectionSniffedDomain": MessageLookupByLibrary.simpleMessage(
      "Sniffed domain",
    ),
    "connectionSourceAddress": MessageLookupByLibrary.simpleMessage(
      "Source address",
    ),
    "connectionStartTime": MessageLookupByLibrary.simpleMessage("Start time"),
    "connectionStats": MessageLookupByLibrary.simpleMessage("Connection stats"),
    "connectionStatsDesc": MessageLookupByLibrary.simpleMessage(
      "Live connections, recent requests and DNS queries",
    ),
    "connectionSummary": m28,
    "connectionSustained": MessageLookupByLibrary.simpleMessage("Elapsed"),
    "connectionTargetIp": MessageLookupByLibrary.simpleMessage("Target IP"),
    "connectionTrafficPath": MessageLookupByLibrary.simpleMessage(
      "Traffic path",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("Connections"),
    "connectionsAndRequests": MessageLookupByLibrary.simpleMessage(
      "Connections & Requests",
    ),
    "connectionsLiveShort": MessageLookupByLibrary.simpleMessage("Live"),
    "connectivity": MessageLookupByLibrary.simpleMessage("Connectivity: "),
    "content": MessageLookupByLibrary.simpleMessage("Content"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Content cannot be empty",
    ),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Control global added rules",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "copyAsBase64": MessageLookupByLibrary.simpleMessage("Copy as Base64"),
    "copyAsCurl": MessageLookupByLibrary.simpleMessage("Copy as cURL"),
    "copyDestination": MessageLookupByLibrary.simpleMessage("Copy destination"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Copy environment variables",
    ),
    "copyHost": MessageLookupByLibrary.simpleMessage("Copy host"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
    "copyRequest": MessageLookupByLibrary.simpleMessage("Copy request"),
    "copyResponse": MessageLookupByLibrary.simpleMessage("Copy response"),
    "copyResponseBody": MessageLookupByLibrary.simpleMessage(
      "Copy response body",
    ),
    "copySubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Copy subscription link",
    ),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Copied successfully"),
    "core": MessageLookupByLibrary.simpleMessage("Core"),
    "coreBlockedByPolicyTip": m29,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Windows Smart App Control blocked TianjiCloudCore.exe because it is not signed. Open Windows Security → App & browser control → Smart App Control settings, choose Off, then start 天机云 again. Smart App Control cannot be turned back on without reinstalling Windows.",
    ),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Core status"),
    "country": MessageLookupByLibrary.simpleMessage("Region"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("Crash detected"),
    "crashDetectedTip": m30,
    "crashTest": MessageLookupByLibrary.simpleMessage("Crash test"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createProfileFromUrlTip": m31,
    "creationTime": MessageLookupByLibrary.simpleMessage("Creation time"),
    "currentExpiry": MessageLookupByLibrary.simpleMessage("Expires"),
    "currentOutboundDesc": MessageLookupByLibrary.simpleMessage(
      "Holds the start button and can\'t be removed",
    ),
    "currentUsage": MessageLookupByLibrary.simpleMessage("Current usage"),
    "custom": MessageLookupByLibrary.simpleMessage("Custom"),
    "customAddProxy": MessageLookupByLibrary.simpleMessage("Add proxy"),
    "customColor": MessageLookupByLibrary.simpleMessage("Custom color"),
    "customGroupMemberSummary": m32,
    "customGroupRuleUsage": m33,
    "customGroupsLabel": MessageLookupByLibrary.simpleMessage("Groups"),
    "customImportDroppedSubRules": m34,
    "customImportFromLink": MessageLookupByLibrary.simpleMessage(
      "Import from link",
    ),
    "customIssueCoreRejected": m35,
    "customIssueDialerLoop": m36,
    "customIssueDuplicateName": m37,
    "customIssueEmptyName": MessageLookupByLibrary.simpleMessage(
      "The name is empty",
    ),
    "customIssueGroupLoop": m38,
    "customIssueInvalidEmptyFallback": m39,
    "customIssueInvalidFilter": m40,
    "customIssueMissingDialer": m41,
    "customIssueMissingProviders": m42,
    "customIssueMissingProxies": m43,
    "customIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "No proxies or proxy providers are selected, so the core rejects this group",
    ),
    "customIssueReservedName": m44,
    "customIssuesSummary": m45,
    "customPreviewMerged": MessageLookupByLibrary.simpleMessage(
      "Preview merged result",
    ),
    "customProfile": MessageLookupByLibrary.simpleMessage("Custom"),
    "customProvidersAndDialers": MessageLookupByLibrary.simpleMessage(
      "Providers and dialing",
    ),
    "customProxyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Custom proxies",
    ),
    "customProxyGroupUsage": m46,
    "customProxySubscriptionNote": MessageLookupByLibrary.simpleMessage(
      "Proxies from the subscription appear alongside these proxies.",
    ),
    "customProxyUnreferenced": MessageLookupByLibrary.simpleMessage(
      "Not referenced",
    ),
    "customResources": MessageLookupByLibrary.simpleMessage("Custom"),
    "customRuleCardTitle": MessageLookupByLibrary.simpleMessage("My rules"),
    "customRulePresets": MessageLookupByLibrary.simpleMessage(
      "Add from presets",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("Cut"),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "dashboardAddableSection": MessageLookupByLibrary.simpleMessage(
      "Available to add",
    ),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "Failed to save the change; it has been rolled back",
    ),
    "daysAgo": m47,
    "daysAgoShort": m48,
    "daysUnit": MessageLookupByLibrary.simpleMessage("days"),
    "decryptUntrusted": MessageLookupByLibrary.simpleMessage(
      "Decrypt without local trust",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Resolves the hostnames of the other DNS servers. Use IP addresses only.",
    ),
    "defaultSelected": MessageLookupByLibrary.simpleMessage(
      "Default selection",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("Default"),
    "definitionNotMap": MessageLookupByLibrary.simpleMessage(
      "The configuration must be a YAML mapping with a name and a type",
    ),
    "delay": MessageLookupByLibrary.simpleMessage("Delay"),
    "delayFailed": MessageLookupByLibrary.simpleMessage("Failed"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Delay test"),
    "delayTestTimeout": MessageLookupByLibrary.simpleMessage(
      "Delay test timeout",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteMultipTip": m49,
    "deleteTip": m50,
    "desc": MessageLookupByLibrary.simpleMessage(
      "A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.",
    ),
    "desktopAsnDescription": MessageLookupByLibrary.simpleMessage(
      "Autonomous system database",
    ),
    "desktopFakeIpExplanation": MessageLookupByLibrary.simpleMessage(
      "198.18.0.0/16 is the fake-IP mapping range; real DNS resolution happens at the exit, outside your local ISP.",
    ),
    "desktopGeoIpDescription": MessageLookupByLibrary.simpleMessage(
      "IP location database",
    ),
    "desktopGeoSiteDescription": MessageLookupByLibrary.simpleMessage(
      "Domain category database",
    ),
    "desktopResourceLatest": MessageLookupByLibrary.simpleMessage("Up to date"),
    "desktopResourceUpdateNote": m51,
    "desktopRuleSetDescription": MessageLookupByLibrary.simpleMessage(
      "Delivered by subscription",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destination"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "Destination GeoIP",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "Destination IP ASN",
    ),
    "details": m52,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Relies on a third-party API; for reference only",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Developer mode"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Developer mode is enabled.",
    ),
    "diagnosticsFailed": MessageLookupByLibrary.simpleMessage("Not passed"),
    "diagnosticsPassed": MessageLookupByLibrary.simpleMessage("Passed"),
    "diagnosticsRunAgain": MessageLookupByLibrary.simpleMessage("Run again"),
    "diagnosticsSelection": MessageLookupByLibrary.simpleMessage(
      "Default route exit verification",
    ),
    "diagnosticsStart": MessageLookupByLibrary.simpleMessage("Start"),
    "diagnosticsTitle": MessageLookupByLibrary.simpleMessage(
      "One-click diagnostics",
    ),
    "diagnosticsUnavailableNotice": MessageLookupByLibrary.simpleMessage(
      "DNS exit, browser WebRTC and NTP checks are not available.",
    ),
    "diagnosticsUnverified": MessageLookupByLibrary.simpleMessage(
      "Could not check",
    ),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("Dialer proxy"),
    "dialerProxyLoopStopped": m53,
    "dialog": MessageLookupByLibrary.simpleMessage("Dialog"),
    "direct": MessageLookupByLibrary.simpleMessage("Direct"),
    "directNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Resolves domains for connections that go direct.",
    ),
    "disableIcmpForwarding": MessageLookupByLibrary.simpleMessage(
      "Disable ICMP forwarding",
    ),
    "disableIcmpForwardingDesc": MessageLookupByLibrary.simpleMessage(
      "With ICMP forwarding disabled, TUN answers ping itself, so ping no longer shows the real latency.",
    ),
    "disableKeepAlive": MessageLookupByLibrary.simpleMessage(
      "Disable TCP keep-alive",
    ),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Disable UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("Disabled"),
    "discardChanges": MessageLookupByLibrary.simpleMessage(
      "Discard the changes?",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage("Disclaimer"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "This statement explains the nature, risks, and responsibilities of using the Software. It is not an additional term beyond GPL-3.0 and does not limit any right that license grants you, including to run, copy, modify, and distribute the Software. Where the two differ, GPL-3.0 prevails.",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage(
      "Relation to the open-source license",
    ),
    "disclaimerAcknowledgeLabel": MessageLookupByLibrary.simpleMessage(
      "I have read and understand this statement",
    ),
    "disclaimerAcknowledgeTip": MessageLookupByLibrary.simpleMessage(
      "To confirm you understand, read the following statement and check the box below:",
    ),
    "disclaimerAcknowledgeTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm the statement",
    ),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "This statement may be revised in later releases; each release carries the version that applies to it.",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Changes to this statement",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Before using 天机云 (\"the Software\"), please read this statement carefully and make sure you understand it. Tapping \"Agree\" means you have read and understood what follows. If you do not want to continue, tap \"Exit\".",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "To the maximum extent permitted by applicable law, neither the developers nor any contributor shall be liable for any direct, indirect, incidental, special, punitive, or consequential damages arising from the use of or inability to use the Software, including but not limited to data loss, device damage, network failures, business interruption, lost profits, or any resulting legal dispute, even if advised of the possibility of such damages.",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage(
      "Limitation of liability",
    ),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "The Software is open source under the GPL-3.0 license. Under that license you may run, study, modify, and distribute it; when you distribute the Software or a modified version, you must provide its source code under GPL-3.0 as well and keep the original copyright notices.\n\nThird-party components in the Software, including the Clash.Meta core, follow their own licenses. The original authors are not responsible for any problem arising from versions modified or distributed by others.",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "Open-source license",
    ),
    "disclaimerNoServiceStatement": MessageLookupByLibrary.simpleMessage(
      "The Software itself does not provide any proxy server, node, subscription, or network access service, and has no partnership, agency, or guarantee relationship with any provider of such services.",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "The Software does not collect or upload your subscription URLs, node details, configuration content, visited websites, connection records, traffic content, or logs. This data stays on your device and the developers have no access to it.\n\nThe Software only reaches the network when you use a feature that needs it, such as fetching the subscription URL you provided when updating a profile, or contacting GitHub when checking for updates.\n\nThe Software includes no analytics or crash reporting service on any platform.",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Data collection and privacy",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "You are responsible for making sure that using the Software is lawful where you live, and you alone bear the legal responsibility for everything you do with it and its consequences.\n\nThe subscriptions, nodes, and configurations you import are your own choice. Whether their source is lawful, their content is safe, and their service is reliable is a matter between you and their providers.",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "Your responsibility",
    ),
    "disclaimerRestateHint": MessageLookupByLibrary.simpleMessage(
      "Enter the statement above",
    ),
    "disclaimerRestateMismatch": MessageLookupByLibrary.simpleMessage(
      "Does not match the statement",
    ),
    "disclaimerRestateTip": MessageLookupByLibrary.simpleMessage(
      "To confirm you understand, enter the following statement in full in the field below:",
    ),
    "disclaimerRestateTitle": MessageLookupByLibrary.simpleMessage(
      "Restate the statement",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "The Software is an open-source network proxy client built on the Clash.Meta (mihomo) core. It only provides local tooling such as configuration management, rule-based routing, and traffic forwarding.",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "Nature of the software",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Subscription links, configuration files, rule sets, scripts, external resources, and external links are all provided by third parties. The developers cannot and do not review or guarantee their legality, accuracy, security, or availability.\n\nAny data leak, financial loss, account ban, or other loss caused by third-party content is to be settled between you and the third party; the developers bear no responsibility for it.",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Third-party content",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "Any commercial activity anyone carries out with the Software, including paid distribution, bundled sales, or use as part of a commercial service, is unrelated to the Software\'s developers, who do not endorse, support, or guarantee it.\n\nYou are responsible for complying with the laws where you live, and you bear the consequences of any unlawful use of the Software.",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage("About use"),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "The Software is provided \"as is\" and \"as available\", without warranty of any kind, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, non-infringement, uninterrupted availability, freedom from errors, or freedom from security vulnerabilities.\n\nThe developers do not guarantee that the Software will meet your needs or that it will run without interruption or error.",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage(
      "No warranty",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "New version found",
    ),
    "dnsBlocked": MessageLookupByLibrary.simpleMessage("Blocked"),
    "dnsCacheCleared": MessageLookupByLibrary.simpleMessage(
      "DNS cache cleared",
    ),
    "dnsExit": MessageLookupByLibrary.simpleMessage("DNS exit"),
    "dnsExitUnavailable": MessageLookupByLibrary.simpleMessage(
      "No result available",
    ),
    "dnsHandling": MessageLookupByLibrary.simpleMessage("Handling"),
    "dnsHijackDesc": MessageLookupByLibrary.simpleMessage(
      "Without this entry, TUN hijacks every DNS query to port 53 (any:53).",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS hijacking"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS mode"),
    "dnsOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Entries added here replace the DNS of every URL and file profile; anything not added keeps the profile\'s own setting. Custom profiles set their DNS in their content.",
    ),
    "dnsProxyRoute": MessageLookupByLibrary.simpleMessage("Proxy"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNS queries"),
    "dnsResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "DNS & Resources",
    ),
    "dnsUpstream": MessageLookupByLibrary.simpleMessage("Upstream"),
    "docked": MessageLookupByLibrary.simpleMessage("Docked"),
    "domain": MessageLookupByLibrary.simpleMessage("Domain"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "downloadBandwidth": MessageLookupByLibrary.simpleMessage(
      "Download bandwidth",
    ),
    "downloadingUpdate": MessageLookupByLibrary.simpleMessage(
      "Downloading update",
    ),
    "duration": MessageLookupByLibrary.simpleMessage("Duration"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editDashboard": MessageLookupByLibrary.simpleMessage("Edit dashboard"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Edit global rules",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Edit proxy"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("Edit proxy group"),
    "editRule": MessageLookupByLibrary.simpleMessage("Edit rule"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Edit SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage(
      "Editor unavailable",
    ),
    "elapsed": MessageLookupByLibrary.simpleMessage("Took"),
    "emptyFallback": MessageLookupByLibrary.simpleMessage("Empty fallback"),
    "emptyTip": m54,
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "enabled": MessageLookupByLibrary.simpleMessage("Enabled"),
    "entries": MessageLookupByLibrary.simpleMessage(" entries"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorDetails": MessageLookupByLibrary.simpleMessage("Error details"),
    "es": MessageLookupByLibrary.simpleMessage("Spanish"),
    "eventAlerts": MessageLookupByLibrary.simpleMessage("Event alerts"),
    "exclude": MessageLookupByLibrary.simpleMessage("Hide from recent tasks"),
    "excludeDstPort": MessageLookupByLibrary.simpleMessage(
      "Excluded destination ports",
    ),
    "excludeFilter": MessageLookupByLibrary.simpleMessage("Exclude filter"),
    "excludeInterface": MessageLookupByLibrary.simpleMessage(
      "Excluded interfaces",
    ),
    "excludeSrcPort": MessageLookupByLibrary.simpleMessage(
      "Excluded source ports",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("Exclude SSIDs"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "When connected to Wi-Fi with an excluded SSID, the app\'s running state switches automatically.",
    ),
    "excludeUid": MessageLookupByLibrary.simpleMessage("Excluded user IDs"),
    "existsTip": m55,
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage("Exit full screen"),
    "exitNodes": MessageLookupByLibrary.simpleMessage("Exit nodes"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Expected status"),
    "expireTime": MessageLookupByLibrary.simpleMessage("Expiration time"),
    "expiredStatus": MessageLookupByLibrary.simpleMessage("Expired"),
    "exportCertificate": MessageLookupByLibrary.simpleMessage(
      "Export certificate",
    ),
    "exportFile": MessageLookupByLibrary.simpleMessage("Export file"),
    "exportHar": MessageLookupByLibrary.simpleMessage("Export HAR"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Export logs"),
    "exportShort": MessageLookupByLibrary.simpleMessage("Export"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Export successful"),
    "extend": MessageLookupByLibrary.simpleMessage("Extend"),
    "extendMode": MessageLookupByLibrary.simpleMessage("Extend mode"),
    "extendOverridesScripts": MessageLookupByLibrary.simpleMessage(
      "Extension overrides and scripts",
    ),
    "extendScript": MessageLookupByLibrary.simpleMessage("Extend script"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "External controller",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "The external controller lets you control the core on port 9090.",
    ),
    "externalControllerSecret": MessageLookupByLibrary.simpleMessage(
      "External controller secret",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("External link"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("Extra large"),
    "fade": MessageLookupByLibrary.simpleMessage("Fade"),
    "failedCount": m56,
    "failedItem": m57,
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fake-IP filter"),
    "fakeipFilterDesc": MessageLookupByLibrary.simpleMessage(
      "These domains get real IPs instead of Fake-IPs. In whitelist mode, only they get Fake-IPs.",
    ),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage(
      "Fake-IP filter mode",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fake-IP range"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage(
      "Fake-IP range (IPv6)",
    ),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("Fake-IP TTL"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Used instead of Nameserver when the fallback filter treats its answer as polluted.",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback filter"),
    "fallbackFilterDomainDesc": MessageLookupByLibrary.simpleMessage(
      "These domains are resolved by Fallback directly.",
    ),
    "fallbackFilterGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Domains in these GeoSite categories are resolved by Fallback directly.",
    ),
    "fallbackFilterIpcidrDesc": MessageLookupByLibrary.simpleMessage(
      "When Nameserver returns an IP in these ranges, the Fallback answer is used.",
    ),
    "file": MessageLookupByLibrary.simpleMessage("File"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "The file has been modified. Save the changes?",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "filters": MessageLookupByLibrary.simpleMessage("Filters"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Find process"),
    "floating": MessageLookupByLibrary.simpleMessage("Floating"),
    "followProfile": MessageLookupByLibrary.simpleMessage("Follow profile"),
    "followSystem": MessageLookupByLibrary.simpleMessage("Follow system"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Font family"),
    "fontSize": MessageLookupByLibrary.simpleMessage("Size"),
    "forceDnsMapping": MessageLookupByLibrary.simpleMessage(
      "Force DNS mapping",
    ),
    "forceDnsMappingDesc": MessageLookupByLibrary.simpleMessage(
      "Force DNS mapping also sniffs connections whose domain came from a DNS mapping.",
    ),
    "forceDomain": MessageLookupByLibrary.simpleMessage("Force domains"),
    "forceDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Force domains are sniffed too; other connections that already have a domain are left alone.",
    ),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force restart the core?",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("French"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "generalOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Entries added here replace the setting of every profile; anything not added keeps the profile\'s own setting, or the core default when the profile has none.",
    ),
    "generateCertificate": MessageLookupByLibrary.simpleMessage(
      "Generate certificate",
    ),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo"),
    "geoSkipped": m58,
    "geoUpdated": m59,
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Geo low-memory mode",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Global"),
    "go": MessageLookupByLibrary.simpleMessage("Go"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Download"),
    "goToConfigureAddedRules": MessageLookupByLibrary.simpleMessage(
      "Go to added rules configuration",
    ),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Go to script configuration",
    ),
    "grid": MessageLookupByLibrary.simpleMessage("Grid"),
    "groupBy": MessageLookupByLibrary.simpleMessage("Group by"),
    "groupCount": m60,
    "groupCountUnit": MessageLookupByLibrary.simpleMessage("groups"),
    "groupTimeoutCount": m61,
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Cache the changes?",
    ),
    "hashByInUser": MessageLookupByLibrary.simpleMessage(
      "Hash by inbound user",
    ),
    "headerRewrite": MessageLookupByLibrary.simpleMessage("Header rewrite"),
    "healthCheck": MessageLookupByLibrary.simpleMessage("Health check"),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Helper service unavailable; TUN mode cannot be enabled. Reinstall 天机云 to restore it.",
    ),
    "hex": MessageLookupByLibrary.simpleMessage("Hex"),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Hide from list"),
    "hideIp": MessageLookupByLibrary.simpleMessage("Hide IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Hide password"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "Hide timed-out proxies",
    ),
    "hopInterval": MessageLookupByLibrary.simpleMessage("Hop interval"),
    "host": MessageLookupByLibrary.simpleMessage("Host"),
    "hostname": MessageLookupByLibrary.simpleMessage("Hostname"),
    "hotkeyConflictWith": m62,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "Global hotkeys work even while the window is hidden. Tap an action to record its key combination.",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Hotkey management",
    ),
    "hotkeyNeedsModifier": m63,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("Not set"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Not registered, it may be taken by another app",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("hours"),
    "hoursAgo": m64,
    "hoursAgoShort": m65,
    "http2": MessageLookupByLibrary.simpleMessage("HTTP/2"),
    "httpBodyNotKept": MessageLookupByLibrary.simpleMessage(
      "Not recorded while memory was short.",
    ),
    "httpBodyProtobufGuess": MessageLookupByLibrary.simpleMessage(
      "Read as Protobuf without its schema: field numbers only, and the types are guesses.",
    ),
    "httpBodyTruncated": MessageLookupByLibrary.simpleMessage(
      "Only the start of this body was recorded.",
    ),
    "httpBodyUndecoded": m66,
    "httpCapture": MessageLookupByLibrary.simpleMessage("HTTP capture"),
    "httpCaptureDesc": MessageLookupByLibrary.simpleMessage(
      "Records requests to the hosts listed under Hostname, to view in connection details. Records stay in memory only.",
    ),
    "httpCaptureLimit": MessageLookupByLibrary.simpleMessage("Maximum records"),
    "httpCaptureLimitDesc": m67,
    "httpCaptureNoHosts": MessageLookupByLibrary.simpleMessage(
      "No host is listed, so nothing is recorded. Add hosts under Hostname on the MITM page, or from the details of a connection.",
    ),
    "httpCaptureOff": MessageLookupByLibrary.simpleMessage("Capture is off"),
    "httpExportPrivate": MessageLookupByLibrary.simpleMessage(
      "A request can carry cookies, tokens, passwords and form contents. Check what you share, and with whom.",
    ),
    "httpExportPrivateTitle": MessageLookupByLibrary.simpleMessage(
      "Contains private data",
    ),
    "httpRequestCleared": MessageLookupByLibrary.simpleMessage(
      "This request is no longer kept",
    ),
    "httpRequests": MessageLookupByLibrary.simpleMessage("HTTP requests"),
    "httpRequestsMissing": MessageLookupByLibrary.simpleMessage(
      "Requests made before capture was on, or since cleared, are not listed.",
    ),
    "httpsDecryption": MessageLookupByLibrary.simpleMessage("HTTPS decryption"),
    "hue": MessageLookupByLibrary.simpleMessage("Hue"),
    "icon": MessageLookupByLibrary.simpleMessage("Icon"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("Icon records"),
    "iconSets": MessageLookupByLibrary.simpleMessage("Icon sets"),
    "iconSetsEmptyTip": MessageLookupByLibrary.simpleMessage(
      "No icon sets yet. Add them in Custom profile resources → Icon sets",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Icon style"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("Filled"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("Hidden"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("Plain"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("Icon URL"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Ignore battery optimization",
    ),
    "immediateUpdate": MessageLookupByLibrary.simpleMessage("Update now"),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "importConfigInvalid": MessageLookupByLibrary.simpleMessage(
      "This file is not a config that can be imported",
    ),
    "importConfigReplaceTip": MessageLookupByLibrary.simpleMessage(
      "Importing replaces the proxy groups, rules and settings this profile has now",
    ),
    "importFile": MessageLookupByLibrary.simpleMessage("Import from file"),
    "importFromLink": MessageLookupByLibrary.simpleMessage("Import from link"),
    "importSubscription": MessageLookupByLibrary.simpleMessage(
      "Import subscription",
    ),
    "importUrl": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "inProgress": MessageLookupByLibrary.simpleMessage("In progress"),
    "inUse": MessageLookupByLibrary.simpleMessage("In use"),
    "inbound": MessageLookupByLibrary.simpleMessage("Inbound"),
    "includeInterface": MessageLookupByLibrary.simpleMessage(
      "Included interfaces",
    ),
    "includeInterfaceDesc": MessageLookupByLibrary.simpleMessage(
      "Only traffic arriving on included interfaces goes through TUN, and excluded interfaces no longer apply.",
    ),
    "includeUid": MessageLookupByLibrary.simpleMessage("Included user IDs"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Never expires"),
    "init": MessageLookupByLibrary.simpleMessage("Init"),
    "initFailed": MessageLookupByLibrary.simpleMessage("Startup failed"),
    "initFailedTip": MessageLookupByLibrary.simpleMessage(
      "天机云 ran into an error while starting and can\'t continue. Copy the details to report the problem. If it keeps happening, clearing the data usually lets the app start again.",
    ),
    "initiator": MessageLookupByLibrary.simpleMessage("Initiator"),
    "initiatorShort": MessageLookupByLibrary.simpleMessage("From"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Enter the proxy group name",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Enter the rule content",
    ),
    "installCertificate": MessageLookupByLibrary.simpleMessage(
      "Install to system",
    ),
    "installCertificateSuccess": MessageLookupByLibrary.simpleMessage(
      "Certificate installed",
    ),
    "installedAppsPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "The app list permission was denied, so installed apps cannot be listed. Please grant it manually in system settings.",
    ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "This system hides the installed app list until the permission is granted. Authorize it to configure the per-app proxy.",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "App list permission required",
    ),
    "installedFonts": MessageLookupByLibrary.simpleMessage("Installed fonts"),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Smart selection",
    ),
    "intercept": MessageLookupByLibrary.simpleMessage("Intercept"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("Interface name"),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "Outbound interface",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("Clear"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("Custom"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage(
      "Follow config",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Interval"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Intranet IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Invalid backup file",
    ),
    "invalidCidrContent": MessageLookupByLibrary.simpleMessage(
      "Enter an IP range in CIDR form such as 192.168.0.0/16",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "A DSCP mark cannot exceed 63",
    ),
    "invalidHostContent": MessageLookupByLibrary.simpleMessage(
      "Enter a domain or an IP address",
    ),
    "invalidIconSet": MessageLookupByLibrary.simpleMessage(
      "Not a valid icon set",
    ),
    "invalidLinkTip": MessageLookupByLibrary.simpleMessage(
      "Not a subscription link or a proxy share link",
    ),
    "invalidListenContent": MessageLookupByLibrary.simpleMessage(
      "Enter an address and port such as 0.0.0.0:1053",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "Only tcp or udp is supported",
    ),
    "invalidOfCount": m68,
    "invalidPolicy": m69,
    "invalidPortRangeContent": MessageLookupByLibrary.simpleMessage(
      "Enter a port or a range such as 443 or 8000-9000",
    ),
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "This QR code doesn\'t contain a profile link",
    ),
    "invalidProxy": m70,
    "invalidProxyProvider": m71,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "Enter numbers or ranges such as 80 or 8000-9000, separated by /",
    ),
    "invalidRuleSet": m72,
    "invalidSubRule": m73,
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP address"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("Abuse history"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("Proxy"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("Flags"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("Organization"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t determine the IP type",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("Good"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("Level"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("Normal"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("Check again"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("Risky"),
    "ipQualityShort": MessageLookupByLibrary.simpleMessage("Quality"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("Answered by"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("Sources"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "Different outbound IP",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("No type"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage("Rate limited"),
    "ipType": MessageLookupByLibrary.simpleMessage("Type"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("Business"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("Data center"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("Mobile network"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Residential"),
    "ipTypeUnknown": MessageLookupByLibrary.simpleMessage("Unknown type"),
    "ipVersion": MessageLookupByLibrary.simpleMessage("IP version"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "IPv6 traffic is received only while IPv6 is on.",
    ),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("IPv6 timeout (ms)"),
    "itemsCount": m74,
    "ja": MessageLookupByLibrary.simpleMessage("Japanese"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "keepAliveIdle": MessageLookupByLibrary.simpleMessage(
      "TCP keep-alive idle",
    ),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "TCP keep-alive interval",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Key"),
    "ko": MessageLookupByLibrary.simpleMessage("Korean"),
    "label": MessageLookupByLibrary.simpleMessage("Label"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "large": MessageLookupByLibrary.simpleMessage("Large"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Last updated"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage(
      "Launch did not finish",
    ),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "The app exited unexpectedly while it was starting up last time. Automatic setup was skipped for this launch; you can start it manually to retry.",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("Layout"),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "lineIssueTip": m75,
    "lineRate": MessageLookupByLibrary.simpleMessage("Rate"),
    "lineWrap": MessageLookupByLibrary.simpleMessage("Word wrap"),
    "link": MessageLookupByLibrary.simpleMessage("Link"),
    "liquidGlass": MessageLookupByLibrary.simpleMessage("Liquid Glass"),
    "list": MessageLookupByLibrary.simpleMessage("List"),
    "listen": MessageLookupByLibrary.simpleMessage("Listen"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage(
      "Listen routing mark",
    ),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage(
      "Listen routing mark works only on Linux.",
    ),
    "liveConnections": MessageLookupByLibrary.simpleMessage("Live connections"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading…"),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localFile": MessageLookupByLibrary.simpleMessage("Local file"),
    "localImage": MessageLookupByLibrary.simpleMessage("Local image"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "Local network permission denied: using the gvisor stack, LAN is unreachable.",
    ),
    "localProxies": MessageLookupByLibrary.simpleMessage("Local proxies"),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Location permission",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Location permission was denied, so the current Wi-Fi name cannot be read. Please enable location permission manually in system settings.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "The system requires location permission to read the Wi-Fi name. On Android choose \"Allow all the time\", otherwise the Wi-Fi name cannot be read while the app is in the background.",
    ),
    "locationPermissionGuide": m76,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Location permission required",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Log"),
    "logFilterError": MessageLookupByLibrary.simpleMessage("Error"),
    "logFilterInfo": MessageLookupByLibrary.simpleMessage("Info"),
    "logFilterWarning": MessageLookupByLibrary.simpleMessage("Warning"),
    "logLevel": MessageLookupByLibrary.simpleMessage("Log level"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Turning off Logcat hides the logs entry.",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Logs"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Logs and diagnostics",
    ),
    "logsRunning": MessageLookupByLibrary.simpleMessage("Runtime logs"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Logs test"),
    "loopback": MessageLookupByLibrary.simpleMessage("UWP loopback exemption"),
    "loose": MessageLookupByLibrary.simpleMessage("Loose"),
    "mainlandDirect": MessageLookupByLibrary.simpleMessage("Mainland direct"),
    "mapLocal": MessageLookupByLibrary.simpleMessage("Map local"),
    "matchCase": MessageLookupByLibrary.simpleMessage("Match case"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("Match source IP"),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "matchedRules": MessageLookupByLibrary.simpleMessage("Matched rules"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("Max failures"),
    "maxLengthTip": m77,
    "maximize": MessageLookupByLibrary.simpleMessage("Maximize"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage(
      "Resident memory",
    ),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("App & shared"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("Heap idle"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("Heap in use"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "Core is not running",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage(
      "Runtime overhead",
    ),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("Goroutine stacks"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "Estimated from process resident memory; it may differ from what the system reports.",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "The Core runs inside the app process. Its share is estimated from runtime stats, and the rest counts as app and shared memory.",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Memory info"),
    "memoryInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Memory the app and the core use",
    ),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("Memory released"),
    "memoryReleasedSize": m78,
    "messageTest": MessageLookupByLibrary.simpleMessage("Message test"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "This is a message.",
    ),
    "method": MessageLookupByLibrary.simpleMessage("Method"),
    "minimize": MessageLookupByLibrary.simpleMessage("Minimize"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("Minimize on exit"),
    "minutes": MessageLookupByLibrary.simpleMessage("minutes"),
    "minutesAgo": m79,
    "minutesAgoShort": m80,
    "mitm": MessageLookupByLibrary.simpleMessage("MITM"),
    "mitmAddLocalFile": MessageLookupByLibrary.simpleMessage(
      "Add a local file",
    ),
    "mitmAddMapLocalRule": MessageLookupByLibrary.simpleMessage(
      "Add a map local rule",
    ),
    "mitmAddRejectRule": MessageLookupByLibrary.simpleMessage(
      "Add a reject rule",
    ),
    "mitmAttachments": MessageLookupByLibrary.simpleMessage("Attachments"),
    "mitmAttachmentsDesc": MessageLookupByLibrary.simpleMessage(
      "Lines refer to attachments by file name, as in script-path=a.js.",
    ),
    "mitmCertificateAndroidReadyTip": MessageLookupByLibrary.simpleMessage(
      "Only apps that trust user certificates, mostly browsers, are decrypted.",
    ),
    "mitmCertificateExportTip": MessageLookupByLibrary.simpleMessage(
      "Export it and trust it on the devices you want to decrypt.",
    ),
    "mitmCertificateLinuxTip": MessageLookupByLibrary.simpleMessage(
      "Flatpak browsers need the exported certificate imported by hand.",
    ),
    "mitmCertificateSavedTip": m81,
    "mitmCertutilMissing": m82,
    "mitmClientRefusedCertificate": MessageLookupByLibrary.simpleMessage(
      "The client refused the certificate. Install the CA, or exclude this host if the app pins its certificate.",
    ),
    "mitmDecryptHost": MessageLookupByLibrary.simpleMessage(
      "Decrypt this host",
    ),
    "mitmDecryptHostTip": m83,
    "mitmEnableTip": MessageLookupByLibrary.simpleMessage(
      "天机云 will be able to read everything sent to the decrypted hosts, cookies and passwords included. Turn this on only for hosts you mean to rewrite.",
    ),
    "mitmExcludeHost": MessageLookupByLibrary.simpleMessage(
      "Exclude from decryption",
    ),
    "mitmExcludeHostTip": m84,
    "mitmFileTooLarge": m85,
    "mitmHostnameDesc": MessageLookupByLibrary.simpleMessage(
      "A leading - excludes a host, and the first match decides.",
    ),
    "mitmIgnoredLines": MessageLookupByLibrary.simpleMessage("Ignored lines"),
    "mitmInstallSystemCaTip": MessageLookupByLibrary.simpleMessage(
      "Root was found, so the certificate goes into the system\'s trusted certificates as a TianjiCloud MITM CA module for Magisk, KernelSU or APatch. Every app on this device will then trust it, and anyone holding its private key could decrypt this device\'s HTTPS traffic. To undo it, regenerate the certificate or remove the module in the root manager and restart. If root is denied, it is installed as a user certificate instead.",
    ),
    "mitmInstallUserCaTip": MessageLookupByLibrary.simpleMessage(
      "No root was found, so the certificate can only be installed as a user certificate. Only apps that trust user certificates, mostly browsers, are decrypted; other apps fail on the hosts you list, so leave those hosts out. On Android 11 and later you finish the install yourself in system settings.",
    ),
    "mitmMissingStores": m86,
    "mitmModule": MessageLookupByLibrary.simpleMessage("Module"),
    "mitmModuleInvalid": MessageLookupByLibrary.simpleMessage(
      "This is not a Surge module, a Loon plugin, a Quantumult X snippet or a Stash override",
    ),
    "mitmModuleRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Routing rules go in front of the profile’s own.",
    ),
    "mitmModuleScriptsChanged": m87,
    "mitmModuleSystemTip": m88,
    "mitmModules": MessageLookupByLibrary.simpleMessage("Modules"),
    "mitmNewModule": MessageLookupByLibrary.simpleMessage("New module"),
    "mitmOldCertificateLeftTip": m89,
    "mitmOldSystemCertificateLeftTip": m90,
    "mitmRemoveOldCertificateTip": m91,
    "mitmRootPendingReboot": MessageLookupByLibrary.simpleMessage(
      "The certificate takes effect after the device restarts.",
    ),
    "mitmRootUntilReboot": MessageLookupByLibrary.simpleMessage(
      "No Magisk, KernelSU or APatch was found to keep the certificate. Install it again after the device restarts.",
    ),
    "mitmRoutingRules": MessageLookupByLibrary.simpleMessage("Routing rules"),
    "mitmRuleCopiedForStash": MessageLookupByLibrary.simpleMessage(
      "This module is a Stash override, so the rule was copied for you to add by hand.",
    ),
    "mitmRunScript": MessageLookupByLibrary.simpleMessage("Run now"),
    "mitmScriptNoOutput": MessageLookupByLibrary.simpleMessage(
      "The script finished without output",
    ),
    "mitmScriptRisk": MessageLookupByLibrary.simpleMessage(
      "Its scripts read and change the traffic of the hosts they match, cookies and tokens included, and can send requests of their own. Turn it on only if you trust where it comes from.",
    ),
    "mitmScriptRiskTitle": MessageLookupByLibrary.simpleMessage(
      "Run this module\'s scripts?",
    ),
    "mitmSkipConditional": MessageLookupByLibrary.simpleMessage(
      "Conditional rewrites are not supported",
    ),
    "mitmSkipDisabled": MessageLookupByLibrary.simpleMessage(
      "Turned off by an argument",
    ),
    "mitmSkipEvent": MessageLookupByLibrary.simpleMessage(
      "This event is not supported",
    ),
    "mitmSkipJq": MessageLookupByLibrary.simpleMessage(
      "jq rewrites are not supported",
    ),
    "mitmSkipJsonBody": MessageLookupByLibrary.simpleMessage(
      "JSON body rewrites are not supported",
    ),
    "mitmSkipNotDownloaded": MessageLookupByLibrary.simpleMessage(
      "Its file has not been downloaded",
    ),
    "mitmSkipPolicy": MessageLookupByLibrary.simpleMessage(
      "Only the DIRECT and REJECT policies are supported",
    ),
    "mitmSkipRawHeader": MessageLookupByLibrary.simpleMessage(
      "Rewriting all headers as one text is not supported",
    ),
    "mitmSkipRelativeData": MessageLookupByLibrary.simpleMessage(
      "The file this line names is not attached; use a URL or attach it",
    ),
    "mitmSkipRule": MessageLookupByLibrary.simpleMessage(
      "This rule type is not supported",
    ),
    "mitmSkipScriptType": MessageLookupByLibrary.simpleMessage(
      "This script type is not supported",
    ),
    "mitmSkipSection": m92,
    "mitmSkipSetting": MessageLookupByLibrary.simpleMessage(
      "This setting is not supported",
    ),
    "mitmSkipUnreadable": MessageLookupByLibrary.simpleMessage(
      "This line cannot be read",
    ),
    "mitmSystemStoreFailed": MessageLookupByLibrary.simpleMessage(
      "Adding the certificate to the system\'s trusted roots failed",
    ),
    "mitmTrustChecking": MessageLookupByLibrary.simpleMessage("Checking…"),
    "mitmTrustNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Not installed",
    ),
    "mitmTrustReady": MessageLookupByLibrary.simpleMessage("Trusted"),
    "mitmTrustUntrusted": MessageLookupByLibrary.simpleMessage(
      "Not fully trusted",
    ),
    "mixedPort": MessageLookupByLibrary.simpleMessage("Mixed port"),
    "mobilePlanValidity": MessageLookupByLibrary.simpleMessage("Plan validity"),
    "mobileRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Traffic left",
    ),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "monochromeIcon": MessageLookupByLibrary.simpleMessage("Monochrome icon"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Monochrome"),
    "monthsAgo": m93,
    "monthsAgoShort": m94,
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "The default DNS servers, such as 223.5.5.5, tls://1.1.1.1 or https://dns.google/dns-query.",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Matching domains use the DNS server given here instead of Nameserver and Fallback.",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("Bottom bar"),
    "network": MessageLookupByLibrary.simpleMessage("Network"),
    "networkAccessDeniedError": m95,
    "networkBadResponseError": m96,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "The request was cancelled",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t connect to the server. Check your network connection or proxy settings",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t resolve the server address. Check that the URL is correct and DNS is working",
    ),
    "networkName": MessageLookupByLibrary.simpleMessage("Network name"),
    "networkNotFoundError": m97,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "Too many requests (HTTP 429). Wait a moment and try again",
    ),
    "networkRequestFailed": m98,
    "networkSecret": MessageLookupByLibrary.simpleMessage("Network secret"),
    "networkServerError": m99,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Network speed"),
    "networkTakeover": MessageLookupByLibrary.simpleMessage("Traffic takeover"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "The request timed out. Check your network or proxy, then try again",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "Secure connection failed. The server\'s certificate may be invalid, or the connection is being intercepted",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("Network type"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("Next match"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noInfo": MessageLookupByLibrary.simpleMessage("No info"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Don\'t remind me again",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("No network"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("No-network apps"),
    "noResolve": MessageLookupByLibrary.simpleMessage("Don\'t resolve IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "Don\'t resolve hostname",
    ),
    "noSearchResults": MessageLookupByLibrary.simpleMessage(
      "No matching results",
    ),
    "nodes": MessageLookupByLibrary.simpleMessage("Nodes"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "This external resource is not a text file",
    ),
    "none": MessageLookupByLibrary.simpleMessage("None"),
    "notRunning": MessageLookupByLibrary.simpleMessage("Not running"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "The current proxy group cannot be selected",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage(
      "Sync interval (minutes)",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Add a profile to get started",
    ),
    "nullTip": m100,
    "numberRangeTip": m101,
    "numberTip": m102,
    "obfs": MessageLookupByLibrary.simpleMessage("Obfuscation"),
    "obfsHost": MessageLookupByLibrary.simpleMessage("Obfuscation host"),
    "obfsMode": MessageLookupByLibrary.simpleMessage("Obfuscation mode"),
    "obfsParam": MessageLookupByLibrary.simpleMessage("Obfuscation parameter"),
    "obfsPassword": MessageLookupByLibrary.simpleMessage(
      "Obfuscation password",
    ),
    "onDemand": MessageLookupByLibrary.simpleMessage("On demand"),
    "onboardingCheckingInternet": MessageLookupByLibrary.simpleMessage(
      "Checking internet access…",
    ),
    "onboardingClipboardEmpty": MessageLookupByLibrary.simpleMessage(
      "There is nothing in the clipboard",
    ),
    "onboardingConfirmNote": MessageLookupByLibrary.simpleMessage(
      "Check the full subscription link above before importing.",
    ),
    "onboardingConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Tianji Cloud subscription",
    ),
    "onboardingConnect": MessageLookupByLibrary.simpleMessage("Connect"),
    "onboardingConnectFailed": MessageLookupByLibrary.simpleMessage(
      "Couldn’t connect. Try again later.",
    ),
    "onboardingConnected": MessageLookupByLibrary.simpleMessage("Connected"),
    "onboardingConnectedNoInternet": MessageLookupByLibrary.simpleMessage(
      "Connected, but the internet is unreachable",
    ),
    "onboardingConnecting": MessageLookupByLibrary.simpleMessage("Connecting…"),
    "onboardingConnectingDescription": MessageLookupByLibrary.simpleMessage(
      "Once connected, the app will make one real request to the internet to confirm.",
    ),
    "onboardingContinue": MessageLookupByLibrary.simpleMessage("Continue"),
    "onboardingDescription": MessageLookupByLibrary.simpleMessage(
      "Paste or scan your subscription link from the panel, then connect in a few steps.",
    ),
    "onboardingExit": MessageLookupByLibrary.simpleMessage("Exit"),
    "onboardingExpireDate": MessageLookupByLibrary.simpleMessage("Expires"),
    "onboardingFailureEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "The plan may have expired, or this month’s traffic is used up. Renew or reset your traffic, then tap “Retry”.",
    ),
    "onboardingFailureEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No usable nodes in this subscription",
    ),
    "onboardingFailureExpiredDescription": MessageLookupByLibrary.simpleMessage(
      "The subscription may have been reset in the panel. Copy the subscription address again from your user panel, then paste it here.",
    ),
    "onboardingFailureExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Subscription link expired",
    ),
    "onboardingFailureNotSubscriptionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Tap “Copy subscription address” in your user panel, then paste it here.",
        ),
    "onboardingFailureNotSubscriptionTitle":
        MessageLookupByLibrary.simpleMessage("This is not a subscription link"),
    "onboardingFailureUnknownDescription": MessageLookupByLibrary.simpleMessage(
      "Check your network and try again.",
    ),
    "onboardingFailureUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "Import failed",
    ),
    "onboardingFailureUnreachableDescription": MessageLookupByLibrary.simpleMessage(
      "Your current network may be blocking this domain. The status page has backup addresses, or try again later.",
    ),
    "onboardingFailureUnreachableTitle": MessageLookupByLibrary.simpleMessage(
      "Can’t reach the subscription address",
    ),
    "onboardingImported": m103,
    "onboardingImporting": MessageLookupByLibrary.simpleMessage(
      "Fetching subscription…",
    ),
    "onboardingImportingDescription": MessageLookupByLibrary.simpleMessage(
      "Reading the node list and plan details",
    ),
    "onboardingInternetVerified": MessageLookupByLibrary.simpleMessage(
      "Internet access · verified",
    ),
    "onboardingNoSubscription": MessageLookupByLibrary.simpleMessage(
      "No subscription address yet? Open your user panel to copy it ›",
    ),
    "onboardingNodeUnavailable": MessageLookupByLibrary.simpleMessage(
      "The current node may be temporarily unavailable. Switching nodes usually fixes this.",
    ),
    "onboardingNotNow": MessageLookupByLibrary.simpleMessage("Not now"),
    "onboardingOpenPanel": MessageLookupByLibrary.simpleMessage(
      "Open user panel",
    ),
    "onboardingPasteAgain": MessageLookupByLibrary.simpleMessage("Paste again"),
    "onboardingPasteFromClipboard": MessageLookupByLibrary.simpleMessage(
      "Paste subscription link from clipboard",
    ),
    "onboardingPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "The clipboard is read only when you tap the button. Your subscription link stays on this device.",
    ),
    "onboardingRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Remaining traffic",
    ),
    "onboardingScanQr": MessageLookupByLibrary.simpleMessage(
      "Scan the QR code on your panel",
    ),
    "onboardingSwitchNode": MessageLookupByLibrary.simpleMessage("Switch node"),
    "onboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Import a subscription to get started",
    ),
    "onboardingViewStatus": MessageLookupByLibrary.simpleMessage(
      "View backup address",
    ),
    "onboardingVpnDescription": MessageLookupByLibrary.simpleMessage(
      "The system will ask whether to allow Tianji Cloud to create a VPN connection. Tap “OK”. You only need to allow it once.",
    ),
    "onboardingVpnTitle": MessageLookupByLibrary.simpleMessage(
      "One system permission needed",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Only count proxy traffic",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage("Open settings"),
    "optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "options": MessageLookupByLibrary.simpleMessage("Options"),
    "originalUrl": MessageLookupByLibrary.simpleMessage("Original URL"),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Other contributors",
    ),
    "otherProfilesTitle": MessageLookupByLibrary.simpleMessage(
      "Other profiles",
    ),
    "outbound": MessageLookupByLibrary.simpleMessage("Outbound"),
    "outboundExit": MessageLookupByLibrary.simpleMessage("Exit"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("Outbound IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Outbound mode"),
    "outboundModeDescription": MessageLookupByLibrary.simpleMessage(
      "Usually keep “Rule”. Global also proxies mainland traffic; Direct disables all proxy lines.",
    ),
    "outboundModeDirectWarning": MessageLookupByLibrary.simpleMessage(
      "Direct mode is active",
    ),
    "outboundModeGlobalWarning": MessageLookupByLibrary.simpleMessage(
      "Global mode is active",
    ),
    "outboundModeRestoreRule": MessageLookupByLibrary.simpleMessage(
      "Restore Rule",
    ),
    "overrideDestination": MessageLookupByLibrary.simpleMessage(
      "Override destination",
    ),
    "overrideEntries": MessageLookupByLibrary.simpleMessage("Override entries"),
    "overridesLabel": MessageLookupByLibrary.simpleMessage("Overrides"),
    "overview": MessageLookupByLibrary.simpleMessage("Overview"),
    "parsePureIp": MessageLookupByLibrary.simpleMessage("Parse pure IP"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "paste": MessageLookupByLibrary.simpleMessage("Paste"),
    "pasteFromClipboardImport": MessageLookupByLibrary.simpleMessage(
      "Import from clipboard",
    ),
    "peers": MessageLookupByLibrary.simpleMessage("Peers"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("Choose from album"),
    "pinWindow": MessageLookupByLibrary.simpleMessage("Pin window"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Please bind WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Please enter a script name",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Please upload a valid QR code",
    ),
    "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
    "pluginCipher": MessageLookupByLibrary.simpleMessage("Plugin cipher"),
    "pluginHost": MessageLookupByLibrary.simpleMessage("Plugin host"),
    "pluginMode": MessageLookupByLibrary.simpleMessage("Plugin mode"),
    "pluginPassword": MessageLookupByLibrary.simpleMessage("Plugin password"),
    "pluginPath": MessageLookupByLibrary.simpleMessage("Plugin path"),
    "pluginUsername": MessageLookupByLibrary.simpleMessage("Plugin username"),
    "port": MessageLookupByLibrary.simpleMessage("Port"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a different port",
    ),
    "portHopping": MessageLookupByLibrary.simpleMessage("Port hopping"),
    "portTip": m104,
    "portValue": m105,
    "ports": MessageLookupByLibrary.simpleMessage("Ports"),
    "preSharedKey": MessageLookupByLibrary.simpleMessage("Pre-shared key"),
    "preferred": MessageLookupByLibrary.simpleMessage("Preferred"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("Prerequisites"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Press a key combination",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "previewReadOnly": MessageLookupByLibrary.simpleMessage("Read-only"),
    "previousMatch": MessageLookupByLibrary.simpleMessage("Previous match"),
    "privateKey": MessageLookupByLibrary.simpleMessage("Private key"),
    "privateKeyPassphrase": MessageLookupByLibrary.simpleMessage(
      "Private key passphrase",
    ),
    "process": MessageLookupByLibrary.simpleMessage("Process"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileAddCustomSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Create local proxies, groups and rules",
    ),
    "profileAddFileSourceDesc": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "profileAddLinkSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Copy from your user panel",
    ),
    "profileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "Imports are validated first. A parsing failure does not replace the active profile.",
    ),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("Please enter a valid interval"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please enter the auto-update interval",
        ),
    "profileDaysLeft": m106,
    "profileExpiresIn": m107,
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "The profile has been modified. Turn off auto update?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please enter the profile name",
    ),
    "profilePreviewTitle": MessageLookupByLibrary.simpleMessage(
      "Configuration preview",
    ),
    "profileSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "Applies to this profile only; anything not added uses its default.",
    ),
    "profileSwitchNote": MessageLookupByLibrary.simpleMessage(
      "Changes apply immediately; if parsing fails, the current configuration is kept.",
    ),
    "profileTunSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "Applies to this profile only and takes precedence over the TUN override entries in the network settings.",
    ),
    "profileUpdatedAt": m108,
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid profile URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please enter the profile URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Profiles"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Sort profiles"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocol"),
    "protocolParam": MessageLookupByLibrary.simpleMessage("Protocol parameter"),
    "protocolVersion": MessageLookupByLibrary.simpleMessage("Protocol version"),
    "providerCount": m109,
    "providerInUse": m110,
    "providerUrlTip": MessageLookupByLibrary.simpleMessage(
      "Only remote providers are supported",
    ),
    "providers": MessageLookupByLibrary.simpleMessage("External resources"),
    "proxies": MessageLookupByLibrary.simpleMessage("Proxies"),
    "proxiesCount": m111,
    "proxiesProfileLabel": m112,
    "proxiesRemovedTip": m113,
    "proxiesReplacedTip": m114,
    "proxyChains": MessageLookupByLibrary.simpleMessage("Proxy chain"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Proxy group"),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy group is empty",
    ),
    "proxyGroupInUse": m115,
    "proxyGroupsAfterStart": MessageLookupByLibrary.simpleMessage(
      "Groups show up here once the core starts",
    ),
    "proxyGroupsCount": m116,
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Proxy providers"),
    "proxyServerNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Resolves proxy server hostnames only.",
    ),
    "proxyServerNameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Matching proxy server hostnames use the DNS server given here instead of Proxy Server Nameserver.",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Proxy type"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Prune cache"),
    "publicKey": MessageLookupByLibrary.simpleMessage("Public key"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("Pure black"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Pure black mode"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR code"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Scan a QR code to obtain a profile",
    ),
    "qrcodeTooLongTip": MessageLookupByLibrary.simpleMessage(
      "This link is too long for a QR code. Use Copy link instead.",
    ),
    "quickActions": MessageLookupByLibrary.simpleMessage("Quick actions"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("Quick edit"),
    "quickLines": MessageLookupByLibrary.simpleMessage("Quick lines"),
    "recentDnsQueries": MessageLookupByLibrary.simpleMessage(
      "Recent DNS queries",
    ),
    "recentRequests": MessageLookupByLibrary.simpleMessage("Recent requests"),
    "recommendedIcons": MessageLookupByLibrary.simpleMessage("Suggested"),
    "recordType": MessageLookupByLibrary.simpleMessage("Record type"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir port"),
    "redo": MessageLookupByLibrary.simpleMessage("Redo"),
    "regenerateCertificate": MessageLookupByLibrary.simpleMessage(
      "Regenerate certificate",
    ),
    "regenerateCertificateTip": MessageLookupByLibrary.simpleMessage(
      "The new certificate replaces the current one, which 天机云 takes out of this device\'s trusted roots where it can. Every other device that trusts the current one has to install the new one.",
    ),
    "regex": MessageLookupByLibrary.simpleMessage("Regex"),
    "releaseMemory": MessageLookupByLibrary.simpleMessage("Release memory"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to release memory",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("Remote"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Remote destination",
    ),
    "remoteDnsResolve": MessageLookupByLibrary.simpleMessage(
      "Remote DNS resolution",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "renew": MessageLookupByLibrary.simpleMessage("Renew"),
    "renewUpgrade": MessageLookupByLibrary.simpleMessage(
      "Renew / upgrade plan",
    ),
    "replace": MessageLookupByLibrary.simpleMessage("Replace"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("Replace all"),
    "request": MessageLookupByLibrary.simpleMessage("Request"),
    "requestBody": MessageLookupByLibrary.simpleMessage("Request body"),
    "requestHeaders": MessageLookupByLibrary.simpleMessage("Request headers"),
    "requests": MessageLookupByLibrary.simpleMessage("Requests"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Requests and updates",
    ),
    "required": MessageLookupByLibrary.simpleMessage("Required"),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "This page has changes. Are you sure you want to reset?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to reset?",
    ),
    "residentialActiveDesc": MessageLookupByLibrary.simpleMessage(
      "Once connected, traffic that needs a proxy follows this line.",
    ),
    "residentialApplyFailed": MessageLookupByLibrary.simpleMessage(
      "This line could not be applied. Retry or choose another line.",
    ),
    "residentialApplying": MessageLookupByLibrary.simpleMessage("Applying…"),
    "residentialBulkBypass": MessageLookupByLibrary.simpleMessage(
      "Video and large downloads use ordinary routes, saving residential traffic.",
    ),
    "residentialBulkUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "Bulk bypass not confirmed; video and downloads may use residential traffic.",
    ),
    "residentialCaptureOff": MessageLookupByLibrary.simpleMessage(
      "Computer traffic is not being captured. Enable System proxy or TUN below.",
    ),
    "residentialChange": MessageLookupByLibrary.simpleMessage("Change exit"),
    "residentialChoose": MessageLookupByLibrary.simpleMessage("Choose exit"),
    "residentialExitLocked": MessageLookupByLibrary.simpleMessage(
      "Choose the residential exit from the dashboard. Other groups cannot change it while residential routing is active.",
    ),
    "residentialExitSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "AI and groups that require a proxy follow the selected route.",
    ),
    "residentialExitSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Choose residential exit",
    ),
    "residentialExplanation": MessageLookupByLibrary.simpleMessage(
      "Default proxy traffic uses the selected residential exit; mainland and direct traffic follow the subscription. Bulk bypass status is shown below when active. Some destinations may use a service-side alternative exit.",
    ),
    "residentialLoadingCatalog": MessageLookupByLibrary.simpleMessage(
      "Loading residential lines…",
    ),
    "residentialLoadingCatalogDesc": MessageLookupByLibrary.simpleMessage(
      "Reading the available lines in your subscription.",
    ),
    "residentialManageSubscription": MessageLookupByLibrary.simpleMessage(
      "Manage subscription",
    ),
    "residentialMissing": MessageLookupByLibrary.simpleMessage(
      "The selected residential exit is no longer in this subscription.",
    ),
    "residentialMissingDesc": MessageLookupByLibrary.simpleMessage(
      "Proxy traffic is blocked until you choose another exit. Mainland direct traffic is unchanged.",
    ),
    "residentialNoPlan": MessageLookupByLibrary.simpleMessage(
      "No residential lines available",
    ),
    "residentialNoPlanDesc": MessageLookupByLibrary.simpleMessage(
      "This subscription has no usable residential exit right now. Keep using the subscription policy, or check the subscription panel.",
    ),
    "residentialNoticeBody": m117,
    "residentialNoticeChange": MessageLookupByLibrary.simpleMessage(
      "Choose another",
    ),
    "residentialNoticeRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "residentialNoticeTitle": MessageLookupByLibrary.simpleMessage(
      "Residential line temporarily unavailable",
    ),
    "residentialOutbound": MessageLookupByLibrary.simpleMessage(
      "Residential exit",
    ),
    "residentialPending": MessageLookupByLibrary.simpleMessage(
      "Switching lines. Please wait.",
    ),
    "residentialResetFailed": MessageLookupByLibrary.simpleMessage(
      "The new exit is active, but existing connections could not be closed. They may keep the previous exit until they reconnect.",
    ),
    "residentialRouteNote": MessageLookupByLibrary.simpleMessage(
      "The IP card shows the exit for its current check destination, not one universal exit.",
    ),
    "residentialSelected": MessageLookupByLibrary.simpleMessage("Selected"),
    "residentialSubscriptionPolicy": MessageLookupByLibrary.simpleMessage(
      "Subscription policy",
    ),
    "residentialTitle": MessageLookupByLibrary.simpleMessage(
      "Residential exit",
    ),
    "residentialUnavailable": MessageLookupByLibrary.simpleMessage(
      "Unavailable",
    ),
    "residentialUseExit": m118,
    "residentialUseSubscription": MessageLookupByLibrary.simpleMessage(
      "Use subscription policy",
    ),
    "residentialUsingSubscription": MessageLookupByLibrary.simpleMessage(
      "No residential exit is selected. Proxied traffic follows this subscription’s own policy.",
    ),
    "resourceUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Auto-update interval",
    ),
    "resourceUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "The auto-update interval must be greater than 0",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Resources"),
    "respectRules": MessageLookupByLibrary.simpleMessage("Respect rules"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Respect rules routes DNS connections by the rules and needs a Proxy Server Nameserver.",
    ),
    "response": MessageLookupByLibrary.simpleMessage("Response"),
    "responseBody": MessageLookupByLibrary.simpleMessage("Response body"),
    "responseCode": MessageLookupByLibrary.simpleMessage("Response code"),
    "responseHeaders": MessageLookupByLibrary.simpleMessage("Response headers"),
    "restart": MessageLookupByLibrary.simpleMessage("Restart"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to restart the core?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Restore"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("Restore all data"),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Restore profiles only",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("Restore strategy"),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage("Override"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Restore successful",
    ),
    "result": MessageLookupByLibrary.simpleMessage("Result"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "root": MessageLookupByLibrary.simpleMessage("Root"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Route addresses"),
    "routeExcludeAddress": MessageLookupByLibrary.simpleMessage(
      "Route exclude addresses",
    ),
    "routingMark": MessageLookupByLibrary.simpleMessage("Routing mark"),
    "routingResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "Routing resources",
    ),
    "routingResourcesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Decides which traffic uses the proxy or goes direct",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("Russian"),
    "rule": MessageLookupByLibrary.simpleMessage("Rule"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Logical rule AND",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Match the full domain",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Match a domain keyword",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match a domain regex",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match a domain suffix",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Wildcard match; only * and ? are supported",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Match the DSCP mark (tproxy UDP inbound only)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match the destination port range",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Match the IP\'s country code",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Match domains in Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound name",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound port",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound type",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Match the inbound username; separate multiple usernames with /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Match the IP\'s ASN",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Match an IP address range; IP-CIDR6 is just an alias",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Match an IP address range",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match an IP suffix range",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Match all requests, no conditions needed",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Match TCP or UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Logical rule NOT",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("Logical rule OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process name; matches the package name on Android",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process name regex; matches the package name on Android",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process name wildcard; only * and ? are supported",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Match by the full process path",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process path regex",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Match by process path wildcard; only * and ? are supported",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match the rematch name; separate multiple names with /",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Reference a rule set; requires rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Match the source IP\'s country code",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Match the source IP\'s ASN",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Match a source IP address range",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match a source IP suffix range",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match the source port range",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Match into a sub-rule; mind the parentheses",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Match the Linux user ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("Rule is empty"),
    "ruleListInvalid": MessageLookupByLibrary.simpleMessage(
      "The rules must be a YAML list with one rule per item, such as - DOMAIN,example.com,DIRECT",
    ),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent direct",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "Block DNS over TLS",
    ),
    "rulePresetBlockLoopback": MessageLookupByLibrary.simpleMessage(
      "Block proxy loopback",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage("Block QUIC"),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage("Block STUN"),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage("LAN direct"),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple and Microsoft direct",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Rule providers"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Rule set"),
    "ruleSetEmptyTip": MessageLookupByLibrary.simpleMessage(
      "The rule set has no usable entries",
    ),
    "ruleSetInvalidTip": MessageLookupByLibrary.simpleMessage(
      "This mrs file cannot be read",
    ),
    "ruleSetMixedTip": MessageLookupByLibrary.simpleMessage(
      "The rule set mixes domains and IP ranges, so its type cannot be told",
    ),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Rule target"),
    "ruleTextInvalid": MessageLookupByLibrary.simpleMessage(
      "The rule must start with a supported type, such as DOMAIN,example.com,DIRECT",
    ),
    "rules": MessageLookupByLibrary.simpleMessage("Rules"),
    "rulesCount": m119,
    "runTime": MessageLookupByLibrary.simpleMessage("Run time"),
    "running": MessageLookupByLibrary.simpleMessage("Running"),
    "runtimeConfig": MessageLookupByLibrary.simpleMessage("Runtime config"),
    "safeMode": MessageLookupByLibrary.simpleMessage("Safe mode"),
    "safeModeAppTitle": m120,
    "saturation": MessageLookupByLibrary.simpleMessage("Saturation"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save the changes?"),
    "scene": MessageLookupByLibrary.simpleMessage("Scene"),
    "sceneAi": MessageLookupByLibrary.simpleMessage("AI"),
    "sceneAiNote": MessageLookupByLibrary.simpleMessage(
      "AI services use AI mode routes; mainland traffic stays direct",
    ),
    "sceneDaily": MessageLookupByLibrary.simpleMessage("Daily"),
    "sceneDailyBypass": MessageLookupByLibrary.simpleMessage(
      "Large traffic bypasses residential automatically; mainland traffic stays direct",
    ),
    "sceneDailyNote": MessageLookupByLibrary.simpleMessage(
      "Mainland traffic stays direct",
    ),
    "sceneSuspended": MessageLookupByLibrary.simpleMessage(
      "Scenes paused in residential mode",
    ),
    "sceneUnavailable": MessageLookupByLibrary.simpleMessage(
      "Scenes unavailable",
    ),
    "sceneUnavailableDesc": MessageLookupByLibrary.simpleMessage(
      "This subscription has no scene groups yet. Ask support to enable scenes, or route from the Proxies page.",
    ),
    "sceneUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "Some rules could not be switched",
    ),
    "sceneWatch": MessageLookupByLibrary.simpleMessage("Streaming"),
    "sceneWatchNote": MessageLookupByLibrary.simpleMessage(
      "Streaming uses Watch routes; mainland traffic stays direct",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Script"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Script mode: rewrites the whole profile with an extension script",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage(
      "Scroll to selected",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "seconds": MessageLookupByLibrary.simpleMessage("seconds"),
    "secondsCount": m121,
    "secretKey": MessageLookupByLibrary.simpleMessage("Key"),
    "sectionsInEffect": m122,
    "select": MessageLookupByLibrary.simpleMessage("Select"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Please select a rule set",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Please select a split strategy",
    ),
    "selectionConfirming": MessageLookupByLibrary.simpleMessage(
      "Confirming the exit…",
    ),
    "selectionGroupOverridden": MessageLookupByLibrary.simpleMessage(
      "This automatic group chose a different node. Select a node manually to keep a fixed choice.",
    ),
    "selectionNotCaptured": MessageLookupByLibrary.simpleMessage(
      "Traffic is not captured yet. Enable system proxy or TUN below to use your selected node.",
    ),
    "selectionRecheck": MessageLookupByLibrary.simpleMessage("Check again"),
    "selectionResidentialLocked": MessageLookupByLibrary.simpleMessage(
      "Your residential line controls proxy traffic. Change it in the residential card or return to subscription routing.",
    ),
    "selectionUnknown": MessageLookupByLibrary.simpleMessage(
      "The exit differs from your selection. The reason could not be confirmed. Try checking again.",
    ),
    "selectionUnknownPending": MessageLookupByLibrary.simpleMessage(
      "The exit differs from your selection. Checking the reason…",
    ),
    "send": MessageLookupByLibrary.simpleMessage("Send"),
    "sendFromPhone": MessageLookupByLibrary.simpleMessage("Send from phone"),
    "sendFromPhoneConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Import the link from your phone?",
    ),
    "sendFromPhoneNoNetwork": MessageLookupByLibrary.simpleMessage(
      "This device is not connected to a local network",
    ),
    "sendFromPhonePageHint": MessageLookupByLibrary.simpleMessage(
      "Subscription link or proxy share link",
    ),
    "sendFromPhonePageSent": MessageLookupByLibrary.simpleMessage(
      "Sent. Confirm the import on the other device.",
    ),
    "sendFromPhonePageTitle": MessageLookupByLibrary.simpleMessage(
      "Send a link to 天机云",
    ),
    "sendFromPhonePermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Receiving a link from your phone needs the Nearby devices permission, which lets 天机云 reach the local network. Turn it on in the app\'s settings.",
    ),
    "sendFromPhoneTip": MessageLookupByLibrary.simpleMessage(
      "Scan the code with your phone\'s camera and paste the link on the page that opens. Both devices need to be on the same network.",
    ),
    "server": MessageLookupByLibrary.simpleMessage("Server"),
    "serviceAbnormalCount": m123,
    "serviceAllAvailable": MessageLookupByLibrary.simpleMessage(
      "All available",
    ),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("Available"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("Blocked"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("Check all"),
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("Coming soon"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "Disallowed ISP",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("Check failed"),
    "serviceManage": MessageLookupByLibrary.simpleMessage("Manage services"),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage(
      "Originals only",
    ),
    "servicePending": MessageLookupByLibrary.simpleMessage("Not checked"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage(
      "Access restricted",
    ),
    "serviceShownOnDashboard": MessageLookupByLibrary.simpleMessage(
      "Shown on the dashboard",
    ),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("Service status"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage(
      "Region not supported",
    ),
    "settingEntries": MessageLookupByLibrary.simpleMessage("settings"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsCount": m124,
    "shareLinkUnreadable": m125,
    "shareLinksInvalid": MessageLookupByLibrary.simpleMessage(
      "No proxy could be read from the links",
    ),
    "shareQrcodeTip": MessageLookupByLibrary.simpleMessage(
      "Scan with 天机云 on another device to import this profile.",
    ),
    "show": MessageLookupByLibrary.simpleMessage("Show"),
    "showLess": MessageLookupByLibrary.simpleMessage("Collapse"),
    "showMore": MessageLookupByLibrary.simpleMessage("Expand"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "Stop button in notification",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("Show password"),
    "sidebar": MessageLookupByLibrary.simpleMessage("Sidebar"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Silent launch"),
    "singleImport": MessageLookupByLibrary.simpleMessage("Single import"),
    "singleShareLinkOnly": MessageLookupByLibrary.simpleMessage(
      "Enter one link here; edit several from the quick edit of the list",
    ),
    "singleValueTip": m126,
    "size": MessageLookupByLibrary.simpleMessage("Size"),
    "skipCertVerify": MessageLookupByLibrary.simpleMessage(
      "Skip certificate verification",
    ),
    "skipDomain": MessageLookupByLibrary.simpleMessage("Skip domains"),
    "skipDstAddress": MessageLookupByLibrary.simpleMessage(
      "Skip destination addresses",
    ),
    "skipServerCertVerify": MessageLookupByLibrary.simpleMessage(
      "Skip server certificate verification",
    ),
    "skipSrcAddress": MessageLookupByLibrary.simpleMessage(
      "Skip source addresses",
    ),
    "slide": MessageLookupByLibrary.simpleMessage("Slide"),
    "sliders": MessageLookupByLibrary.simpleMessage("Sliders"),
    "sniffProtocols": MessageLookupByLibrary.simpleMessage("Protocols"),
    "sniffer": MessageLookupByLibrary.simpleMessage("Sniffer"),
    "socksPort": MessageLookupByLibrary.simpleMessage("SOCKS port"),
    "softStyle": MessageLookupByLibrary.simpleMessage("Soft"),
    "sort": MessageLookupByLibrary.simpleMessage("Sort"),
    "source": MessageLookupByLibrary.simpleMessage("Source"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Source IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Special proxy"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Special rules"),
    "spectrum": MessageLookupByLibrary.simpleMessage("Spectrum"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("Speed statistics"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("Split strategy"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Split strategy cannot be empty",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDs are empty"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Stack mode"),
    "stackTrace": MessageLookupByLibrary.simpleMessage("Stack trace"),
    "standard": MessageLookupByLibrary.simpleMessage("Standard"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Standard mode: adds rules on top of the profile",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage(
      "Start from scratch",
    ),
    "startVpn": MessageLookupByLibrary.simpleMessage("Starting VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage(
      "Startup and background",
    ),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "With DNS off, the system DNS is used.",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Stop"),
    "stopUpdateDownloadTip": MessageLookupByLibrary.simpleMessage(
      "Stop downloading the update?",
    ),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Stopping VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("Strategy"),
    "strictRoute": MessageLookupByLibrary.simpleMessage("Strict route"),
    "strictRouteDesc": MessageLookupByLibrary.simpleMessage(
      "Strict route keeps traffic such as DNS from bypassing TUN, and with IPv6 off it blocks this device\'s IPv6 connections.",
    ),
    "style": MessageLookupByLibrary.simpleMessage("Style"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "subscriptionDetails": MessageLookupByLibrary.simpleMessage("Details"),
    "subscriptionExpiryNoticeBody": m127,
    "subscriptionExpiryNoticeTitle": m128,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Subscription info",
    ),
    "subscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Subscription link",
    ),
    "sudoPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Enter your password for sudo",
    ),
    "suspended": MessageLookupByLibrary.simpleMessage("Suspended…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("Switch profile"),
    "switchProfileShort": MessageLookupByLibrary.simpleMessage("Switch"),
    "sync": MessageLookupByLibrary.simpleMessage("Sync"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "systemApp": MessageLookupByLibrary.simpleMessage("System apps"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "systemService": MessageLookupByLibrary.simpleMessage("System Service"),
    "systemServiceAbnormal": MessageLookupByLibrary.simpleMessage("Abnormal"),
    "systemServiceDescription": MessageLookupByLibrary.simpleMessage(
      "Runs with administrator privileges to configure and restore the virtual adapter, routes, and system proxy.",
    ),
    "systemServiceInstall": MessageLookupByLibrary.simpleMessage("Install"),
    "systemServiceNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Not installed",
    ),
    "systemServiceRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "systemServiceRepair": MessageLookupByLibrary.simpleMessage("Repair"),
    "systemServiceRunning": MessageLookupByLibrary.simpleMessage(
      "Installed and running",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Tab"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Tab animation"),
    "tapIconToRetry": MessageLookupByLibrary.simpleMessage(
      "Tap the icon to retry",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("Tap to authorize"),
    "target": MessageLookupByLibrary.simpleMessage("Target"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP concurrent"),
    "testInterval": MessageLookupByLibrary.simpleMessage("Test interval"),
    "testUrl": MessageLookupByLibrary.simpleMessage("Test URL"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("Test when used"),
    "textScale": MessageLookupByLibrary.simpleMessage("Text scaling"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "Text in the app will look like this",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Theme color"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "tight": MessageLookupByLibrary.simpleMessage("Tight"),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "timeToFirstByte": MessageLookupByLibrary.simpleMessage(
      "Time to first byte",
    ),
    "timeout": MessageLookupByLibrary.simpleMessage("Timeout"),
    "tintedStyle": MessageLookupByLibrary.simpleMessage("Tinted"),
    "tip": MessageLookupByLibrary.simpleMessage("Tip"),
    "toggle": MessageLookupByLibrary.simpleMessage("Toggle"),
    "tolerance": MessageLookupByLibrary.simpleMessage("Tolerance"),
    "tools": MessageLookupByLibrary.simpleMessage("Tools"),
    "torch": MessageLookupByLibrary.simpleMessage("Flashlight"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalDownload": MessageLookupByLibrary.simpleMessage("Downloaded"),
    "totalTraffic": MessageLookupByLibrary.simpleMessage("Total traffic"),
    "totalUpload": MessageLookupByLibrary.simpleMessage("Uploaded"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("TProxy port"),
    "traffic": MessageLookupByLibrary.simpleMessage("Traffic"),
    "trafficMainlandThisMonth": MessageLookupByLibrary.simpleMessage(
      "Mainland direct this month",
    ),
    "trafficOtherDirect": MessageLookupByLibrary.simpleMessage(
      "Direct (region unconfirmed)",
    ),
    "trafficPeak": m129,
    "trafficSavedThisMonth": MessageLookupByLibrary.simpleMessage(
      "Saved this month",
    ),
    "trafficStats": MessageLookupByLibrary.simpleMessage("Traffic statistics"),
    "trafficStatsDesc": MessageLookupByLibrary.simpleMessage(
      "This device\'s mainland direct, VPN and saved proxy traffic this month.",
    ),
    "trafficStatsScope": MessageLookupByLibrary.simpleMessage(
      "This device only, this month. Counts traffic captured by the app.",
    ),
    "trafficTotal": m130,
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Traffic usage"),
    "transport": MessageLookupByLibrary.simpleMessage("Transport"),
    "transportHeaders": m131,
    "trayCopyProxyCommand": MessageLookupByLibrary.simpleMessage(
      "Copy terminal proxy command",
    ),
    "trayDisconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
    "trayNotConnected": MessageLookupByLibrary.simpleMessage("Not connected"),
    "trayOpenApp": MessageLookupByLibrary.simpleMessage("Open Tianji Cloud…"),
    "trayPreferences": MessageLookupByLibrary.simpleMessage("Preferences"),
    "trayShowMainWindow": MessageLookupByLibrary.simpleMessage(
      "Show main window",
    ),
    "trayTun": MessageLookupByLibrary.simpleMessage(
      "Virtual network adapter (TUN)",
    ),
    "trustCertificate": MessageLookupByLibrary.simpleMessage(
      "Trust certificate",
    ),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunAuthorizationFailed": MessageLookupByLibrary.simpleMessage(
      "TUN could not be authorized, so it was turned off.",
    ),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "TUN works only in administrator mode.",
    ),
    "tunOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Entries added here replace the TUN settings of every profile; anything not added keeps the profile\'s own setting. Entries a custom profile adds itself take precedence.",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Turn off"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Turn on"),
    "udpRelayMode": MessageLookupByLibrary.simpleMessage("UDP relay mode"),
    "udpTimeout": MessageLookupByLibrary.simpleMessage("UDP timeout"),
    "udpTimeoutDesc": MessageLookupByLibrary.simpleMessage(
      "The UDP timeout is in seconds and works only with the gvisor, system and mixed stacks.",
    ),
    "ultra": MessageLookupByLibrary.simpleMessage("Ultra"),
    "undo": MessageLookupByLibrary.simpleMessage("Undo"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Unified delay"),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Unknown network error",
    ),
    "unmaximize": MessageLookupByLibrary.simpleMessage("Restore down"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Unnamed"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("Unpin window"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateAll": MessageLookupByLibrary.simpleMessage("Update all"),
    "updateDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "The update could not be downloaded.",
    ),
    "updateDownloadStarted": MessageLookupByLibrary.simpleMessage(
      "Downloading the update. Follow its progress on the dashboard.",
    ),
    "updateDownloadTest": MessageLookupByLibrary.simpleMessage(
      "Update download test",
    ),
    "updateFailed": MessageLookupByLibrary.simpleMessage("Update failed"),
    "updateInstallFailed": MessageLookupByLibrary.simpleMessage(
      "The update could not be installed. You can download it from the release page instead.",
    ),
    "updateNotVerified": MessageLookupByLibrary.simpleMessage(
      "The downloaded update could not be verified.",
    ),
    "updateReady": MessageLookupByLibrary.simpleMessage("Update ready"),
    "updateReadyTip": MessageLookupByLibrary.simpleMessage(
      "The update has downloaded. Tap to install it.",
    ),
    "updateRestartTip": MessageLookupByLibrary.simpleMessage(
      "天机云 closes to install the update and opens again when it is done.",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "uploadBandwidth": MessageLookupByLibrary.simpleMessage("Upload bandwidth"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlRewrite": MessageLookupByLibrary.simpleMessage("URL rewrite"),
    "urlTip": m132,
    "useHosts": MessageLookupByLibrary.simpleMessage("Use hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("Use system hosts"),
    "usedShort": MessageLookupByLibrary.simpleMessage("used"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("Used traffic"),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "validUntil": m133,
    "value": MessageLookupByLibrary.simpleMessage("Value"),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View all"),
    "virtualIpv4": MessageLookupByLibrary.simpleMessage("Virtual IPv4"),
    "vividStyle": MessageLookupByLibrary.simpleMessage("Vivid"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "VPN settings changed. Tap to restart",
    ),
    "vpnTraffic": MessageLookupByLibrary.simpleMessage("VPN"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "WebDAV configuration",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("Whitelist mode"),
    "writeToSystem": MessageLookupByLibrary.simpleMessage("Write to system"),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "Write to system also sets the system clock; Android ignores it.",
    ),
    "yearsAgo": m134,
    "yearsAgoShort": m135,
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "zhCN": MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
    "zzAutoUpdateHours": m136,
    "zzAutoUpdateIntervalLabel": m137,
    "zzExpiryDate": m138,
    "zzProfileBasedOnOverrides": m139,
    "zzProfileExpiredDays": m140,
    "zzProfileImportHint": m141,
    "zzProfileImportedOn": m142,
    "zzQuickClipboard": MessageLookupByLibrary.simpleMessage("Clipboard"),
    "zzQuickLocalFile": MessageLookupByLibrary.simpleMessage("Local file"),
    "zzQuickScan": MessageLookupByLibrary.simpleMessage("Scan"),
    "zzRemaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "zzRemainingDayUnit": MessageLookupByLibrary.simpleMessage("days"),
    "zzRenewUpgradeShort": MessageLookupByLibrary.simpleMessage(
      "Renew / upgrade",
    ),
    "zzTotalQuota": m143,
  };
}
