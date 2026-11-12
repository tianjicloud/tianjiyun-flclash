// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(count) => "${count} 件選択済み";

  static String m1(name) => "${name} をローカルプロキシに追加しました";

  static String m2(name) => "${name} はすでにローカルプロキシにあります";

  static String m3(count, skipped) => "${count}件を追加、${skipped}件は既存のためスキップ";

  static String m4(time) => "${time} に確認";

  static String m5(line) => "「${line}」経由で接続します";

  static String m6(name, status) => "現在：${name} · ${status}";

  static String m7(actual, expected) => "出口は${actual}にあり、選択した回線は${expected}です";

  static String m8(name, ip) => "選択した「${name}」と出口 ${ip} が一致";

  static String m9(date) => "${date} に期限切れ";

  static String m10(month, day) => "${month}月${day}日";

  static String m11(date) => "プランは ${date} に終了します。更新すると回線を継続できます";

  static String m12(value) => "倍率 ${value}×";

  static String m13(days) => "期限切れから ${days} 日";

  static String m14(date) => "このプランは ${date} に期限切れになりました。更新後、同じリンクを再確認してください。";

  static String m15(step, total) => "ステップ ${step}/${total} · サブスクリプションを確認";

  static String m16(count) => "選択済み · ${count}";

  static String m17(count) => "${count} 個のアプリを選択中";

  static String m18(name) => "ホーム回線グループは「${name}」に固定されています。ホーム回線で変更してください。";

  static String m19(time) => "サブスクリプション更新 ${time}";

  static String m20(categories) => "次のカテゴリはデータセンターから直接接続：${categories}";

  static String m21(count) => "${count} 個のアプリ";

  static String m22(count) => "${count} 項目合格";

  static String m23(count) => "${count} 件";

  static String m24(version) => "新しいバージョン ${version} が見つかりました";

  static String m25(percent) => "${percent}% 使用済み";

  static String m26(count) => "Wi-Fi ルール ${count} 件";

  static String m27(detail) => "データを消去できませんでした：${detail}";

  static String m28(count, download, upload) =>
      "合計 ${count} 件の接続 · ダウンロード ${download} · アップロード ${upload} · 行を選択すると全経路と一致したルールを表示";

  static String m29(code) =>
      "Windows が TianjiCloudCore.exe の実行を拒否しました（エラー ${code}）。スマート アプリ コントロールや AppLocker などのアプリ制御ポリシーは未署名のプログラムをブロックします。ポリシーで天机云を許可するか、ポリシーを無効にしてから再試行してください。";

  static String m30(name) =>
      "アプリの起動が2回連続で完了しませんでした。クラッシュループを断ち切るため、プロファイル ${name} の選択を解除し、今回の自動セットアップをスキップしました。いつでも選択し直せます。";

  static String m31(url) => "${url} からプロファイルを作成しますか？";

  static String m32(members, count) => "${members}、ほか ${count} 件";

  static String m33(count) => "${count} 件のルールで使用";

  static String m34(count, label) =>
      "${Intl.plural(count, other: 'カスタム設定はサブルールに対応していないため、SUB-RULE ルール ${label} 件を破棄しました')}";

  static String m35(message) => "コアがこのプロキシを解析できません：${message}";

  static String m36(proxy, target) =>
      "${proxy} は ${target} 経由で接続しますが、${target} から再び ${proxy} に戻るため、ループになります";

  static String m37(name) => "名前 ${name} は他のプロキシまたはプロキシグループで使用されています";

  static String m38(path) => "プロキシグループが循環参照しています：${path}";

  static String m39(name) =>
      "空グループのフォールバックはプロキシである必要がありますが、${name} は存在しないかプロキシグループです";

  static String m40(name, message) => "${name}は有効な正規表現ではありません：${message}";

  static String m41(name) => "ダイヤラープロキシ ${name} が存在しません";

  static String m42(names) => "次のプロキシプロバイダーは存在しません：${names}";

  static String m43(names) => "次のプロキシまたはポリシーは存在しません：${names}";

  static String m44(name) => "${name} は組み込みポリシー名のため使用できません";

  static String m45(count) => "${count} 件に問題があり、プロファイルの適用に失敗する可能性があります";

  static String m46(count) => "${count} 個のグループで使用";

  static String m47(count) => "${count} 日前";

  static String m48(count) => "${count} 日前";

  static String m49(label) => "選択した${label}を削除してもよろしいですか？";

  static String m50(label) => "この${label}を削除してもよろしいですか？";

  static String m51(hours) =>
      "リソースは ${hours} 時間ごとに更新を確認します。ダウンロードに失敗した場合は以前のバージョンを使用します。";

  static String m52(label) => "${label}の詳細";

  static String m53(name) => "${name} 経由の接続が使用元のプロキシに戻るため、接続を中止しました";

  static String m54(label) => "${label}は空にできません";

  static String m55(label) => "${label}はすでに存在します";

  static String m56(count) => "${count} 件が失敗しました。タップして表示";

  static String m57(label, message) => "${label}：${message}";

  static String m58(name) => "${name} はすでに最新です";

  static String m59(name) => "${name} を更新しました";

  static String m60(count) => "${count} 個";

  static String m61(count) => "${count} 件タイムアウト";

  static String m62(action) => "「${action}」で使用中です。保存するとこちらに移動します。";

  static String m63(modifiers) => "${modifiers} のいずれかを含めてください";

  static String m64(count) => "${count} 時間前";

  static String m65(count) => "${count} 時間前";

  static String m66(encoding) => "${encoding} をデコードできないため、送信時のままのデータを表示しています。";

  static String m67(memory, body) =>
      "この件数に達するか、メモリを ${memory} 使い切ると、古い記録から削除されます。本文は先頭の ${body} のみ保持されます。";

  static String m68(invalid, total) => "${total} 件中 ${invalid} 件が無効";

  static String m69(target) => "${target} は無効なポリシーです";

  static String m70(proxyName) => "${proxyName} は無効なプロキシです";

  static String m71(providerName) => "${providerName} は無効なプロキシプロバイダーです";

  static String m72(ruleSet) => "${ruleSet} は無効なルールセットです";

  static String m73(subRule) => "${subRule} は無効な SUB_RULE です";

  static String m74(count) => "${count} 件";

  static String m75(line, message) => "${line}行目：${message}";

  static String m76(appName) =>
      "1. システム設定 > プライバシーとセキュリティ を開く\n2. 位置情報サービス を選択\n3. リストで ${appName} を見つけてチェックを入れる\n\n設定が完了したらアプリに戻ると、通常どおり使用できます。ご協力ありがとうございます。";

  static String m77(label, max) => "${label}は最大${max}文字です";

  static String m78(size) => "${size} を解放しました";

  static String m79(count) => "${count} 分前";

  static String m80(count) => "${count} 分前";

  static String m81(fileName) =>
      "${fileName} を「ダウンロード」に保存しました。設定の「セキュリティ › 暗号化と認証情報 › 証明書のインストール › CA 証明書」からインストールしてください。";

  static String m82(command) =>
      "Chrome と Firefox は独自の証明書ストアを使うため、certutil が必要です：${command}";

  static String m83(host) =>
      "${host} をホスト名リストに追加しますか？天机云は Cookie やパスワードを含め、このホストに送られる内容を読み取れるようになります。";

  static String m84(host) => "ホスト名リストの先頭に -${host} を追加しますか？以後このホストは復号されません。";

  static String m85(size) => "ファイルが ${size} MB を超えています";

  static String m86(stores) => "未追加：${stores}";

  static String m87(name) => "${name} のスクリプトが変更されたためオフにしました";

  static String m88(system) =>
      "${system} 向けに書かれています。一部の行はこのデバイスのアプリに一致しない場合があります。";

  static String m89(name) => "古い証明書 ${name} を削除できませんでした。信頼されたルートから手動で削除してください。";

  static String m90(name) =>
      "古い証明書 ${name} はシステムの信頼された証明書に残っています。root マネージャーで天机云に root を許可してから再生成するか、そこで「TianjiCloud MITM CA」モジュールを削除して再起動してください。";

  static String m91(name) =>
      "設定の「セキュリティ › 暗号化と認証情報 › 信頼できる認証情報 › ユーザー」で古い証明書 ${name} を削除してから、新しい証明書をインストールしてください。";

  static String m92(section) => "[${section}] セクションには対応していません";

  static String m93(count) => "${count} か月前";

  static String m94(count) => "${count} か月前";

  static String m95(code) =>
      "サーバーがアクセスを拒否しました（HTTP ${code}）。リンクの期限切れか、認証情報が誤っている可能性があります";

  static String m96(code) => "サーバーがリクエストを拒否しました（HTTP ${code}）";

  static String m97(code) =>
      "このアドレスには何も見つかりませんでした（HTTP ${code}）。URL が正しいか確認してください";

  static String m98(detail) => "ネットワークリクエストに失敗しました：${detail}";

  static String m99(code) => "サーバーで問題が発生しました（HTTP ${code}）。しばらくしてから再試行してください";

  static String m100(label) => "${label}はまだありません";

  static String m101(label, min, max) => "${label}は${min}から${max}の範囲で指定してください";

  static String m102(label) => "${label}は数値である必要があります";

  static String m103(count) => "インポート済み · ${count} 個のノード";

  static String m104(label) => "${label} は 1024〜49151 の範囲で指定してください";

  static String m105(port) => "ポート ${port}";

  static String m106(days) => "残り ${days} 日";

  static String m107(date, days) => "${date} に期限切れ、残り ${days} 日";

  static String m108(time) => "${time}に更新";

  static String m109(count) => "${count} 件";

  static String m110(label, profiles) =>
      "${label} は ${profiles} でまだ使用されており、削除するとそれらが正常に動作しなくなります。削除してもよろしいですか？";

  static String m111(count, label) =>
      "${Intl.plural(count, other: 'プロキシ ${label} 件')}";

  static String m112(name, count) => "${name} など${count}件のプロキシ";

  static String m113(removed) =>
      "次のプロキシが削除されます：${removed}。名前を変えた行は新しいプロキシとして扱われ、削除されたプロキシを参照するカスタムプロファイルでは見つからないと表示されます。適用しますか？";

  static String m114(removed, added) =>
      "次のプロキシが削除されます：${removed}。次のプロキシが追加されます：${added}。名前を変えた行は新しいプロキシとして扱われ、削除されたプロキシを参照するカスタムプロファイルでは見つからないと表示されます。適用しますか？";

  static String m115(label) =>
      "${label} はこのプロファイルのルール、プロキシグループ、ダイヤラープロキシ、DNS または NTP からまだ参照されており、削除するとそれらの参照は無効になります。削除してもよろしいですか？";

  static String m116(count, label) =>
      "${Intl.plural(count, other: 'プロキシグループ ${label} 件')}";

  static String m117(line) => "「${line}」の確認に 3 回連続で失敗しました。回線を確認するか再試行してください。";

  static String m118(name) => "${name}を使用";

  static String m119(count, label) =>
      "${Intl.plural(count, other: 'ルール ${label} 件')}";

  static String m120(appName) => "${appName}（セーフモード）";

  static String m121(count) => "${count} 秒";

  static String m122(count) => "${count} 件が有効";

  static String m123(count) => "${count} 件に問題";

  static String m124(count) => "設定 ${count} 件";

  static String m125(link) => "${link} からプロキシを読み取れませんでした";

  static String m126(label) => "${label}は1項目のみ指定できます";

  static String m127(name, date) => "${name} · ${date}";

  static String m128(days) => "プランの有効期限まであと ${days} 日";

  static String m129(value) => "ピーク ${value}";

  static String m130(value) => "累計 ${value}";

  static String m131(transport) => "${transport} リクエストヘッダー";

  static String m132(label) => "${label}はURLである必要があります";

  static String m133(date) => "有効期限 ${date}";

  static String m134(count) => "${count} 年前";

  static String m135(count) => "${count} 年前";

  static String m136(hours) => "${hours} 時間ごとに自動更新";

  static String m137(count, unit) => "${count}${unit}ごとに自動更新";

  static String m138(date) => "${date} に期限切れ";

  static String m139(count) => "現在のサブスクリプションを基に · 上書きルール${count}件";

  static String m140(count) => "サブスクリプションリンク · ${count}日前に期限切れ";

  static String m141(scheme) =>
      "クリップボードからリンクを貼り付けるか、ローカル YAML ファイルを選択するか、ブラウザーで ${scheme} を開いてリンクをインポートできます。";

  static String m142(date) => "ローカルファイル · ${date}にインポート";

  static String m143(quota) => "合計 ${quota}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("アプリについて"),
    "accessControl": MessageLookupByLibrary.simpleMessage("アクセス制御"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "選択したアプリのみVPNを経由します",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "アプリアクセス制御は無効です",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "選択したアプリはVPNから除外されます",
    ),
    "accessControlSelectedCount": m0,
    "account": MessageLookupByLibrary.simpleMessage("アカウント"),
    "action": MessageLookupByLibrary.simpleMessage("アクション"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage("すべての遅延をテスト"),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("ダイレクトモード"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("グローバルモード"),
    "actionMode": MessageLookupByLibrary.simpleMessage("モード切替"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("システムプロキシ"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("ルールモード"),
    "actionStart": MessageLookupByLibrary.simpleMessage("開始/停止"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage("プロファイルを更新"),
    "actionView": MessageLookupByLibrary.simpleMessage("表示/非表示"),
    "add": MessageLookupByLibrary.simpleMessage("追加"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("プロキシを追加"),
    "addFilters": MessageLookupByLibrary.simpleMessage("フィルターを追加"),
    "addNodes": MessageLookupByLibrary.simpleMessage("ノードを追加"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage("上書き項目を追加"),
    "addProfile": MessageLookupByLibrary.simpleMessage("プロファイルを追加"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("プロキシグループを追加"),
    "addRule": MessageLookupByLibrary.simpleMessage("ルールを追加"),
    "addSettingEntry": MessageLookupByLibrary.simpleMessage("設定項目を追加"),
    "addSsid": MessageLookupByLibrary.simpleMessage("SSIDを追加"),
    "addToLocalProxies": MessageLookupByLibrary.simpleMessage("ローカルプロキシに追加"),
    "addedRules": MessageLookupByLibrary.simpleMessage("追加ルール"),
    "addedToLocalProxies": m1,
    "additionalParameters": MessageLookupByLibrary.simpleMessage("追加パラメータ"),
    "additionalPrefix": MessageLookupByLibrary.simpleMessage("名前のプレフィックス"),
    "additionalSuffix": MessageLookupByLibrary.simpleMessage("名前のサフィックス"),
    "address": MessageLookupByLibrary.simpleMessage("アドレス"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "有効なWebDAVアドレスを入力してください",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage("詳細設定"),
    "ageEncryptedProfile": MessageLookupByLibrary.simpleMessage("暗号化されたプロファイル"),
    "ageSecretKey": MessageLookupByLibrary.simpleMessage("age 秘密鍵"),
    "ageSecretKeyRequiredTip": MessageLookupByLibrary.simpleMessage(
      "このプロファイルは age で暗号化されており、復号には age 秘密鍵が必要です",
    ),
    "agree": MessageLookupByLibrary.simpleMessage("同意する"),
    "all": MessageLookupByLibrary.simpleMessage("すべて"),
    "allReferencedProxies": MessageLookupByLibrary.simpleMessage(
      "参照されているすべてのプロキシ",
    ),
    "allReferencedProxyProviders": MessageLookupByLibrary.simpleMessage(
      "参照されているすべてのプロキシプロバイダー",
    ),
    "allowBypass": MessageLookupByLibrary.simpleMessage("アプリによるVPNバイパスを許可"),
    "allowLan": MessageLookupByLibrary.simpleMessage("LANプロキシ"),
    "allowedIps": MessageLookupByLibrary.simpleMessage("許可する IP"),
    "alreadyInLocalProxies": m2,
    "answers": MessageLookupByLibrary.simpleMessage("応答"),
    "app": MessageLookupByLibrary.simpleMessage("アプリ"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage("アプリアクセス制御"),
    "appBackground": MessageLookupByLibrary.simpleMessage("背景"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage("アプリアイコンのデザイン"),
    "appProxiesEmpty": MessageLookupByLibrary.simpleMessage("ローカルプロキシがありません"),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage("システムDNSを追加"),
    "applied": MessageLookupByLibrary.simpleMessage("適用しました"),
    "applyNow": MessageLookupByLibrary.simpleMessage("今すぐ適用"),
    "arguments": MessageLookupByLibrary.simpleMessage("引数"),
    "authentication": MessageLookupByLibrary.simpleMessage("認証"),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "認証が有効な間、システムプロキシは適用されません。",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("許可"),
    "authorized": MessageLookupByLibrary.simpleMessage("許可済み"),
    "auto": MessageLookupByLibrary.simpleMessage("自動"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage("更新の自動チェック"),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage("接続を自動的に閉じる"),
    "autoInclude": MessageLookupByLibrary.simpleMessage("自動で含める"),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("自動起動"),
    "autoRun": MessageLookupByLibrary.simpleMessage("自動実行"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "自動実行はアプリを開いたときにプロキシを開始します。",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage("システムDNSを自動設定"),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("自動更新"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage("自動更新間隔"),
    "back": MessageLookupByLibrary.simpleMessage("戻る"),
    "backgroundAurora": MessageLookupByLibrary.simpleMessage("オーロラ"),
    "backgroundBlur": MessageLookupByLibrary.simpleMessage("背景のぼかし"),
    "backgroundGlobe": MessageLookupByLibrary.simpleMessage("グローブ"),
    "backgroundMountains": MessageLookupByLibrary.simpleMessage("山々"),
    "backgroundNebula": MessageLookupByLibrary.simpleMessage("星雲"),
    "backgroundOrbit": MessageLookupByLibrary.simpleMessage("軌道"),
    "backgroundPlanet": MessageLookupByLibrary.simpleMessage("惑星"),
    "backgroundSolid": MessageLookupByLibrary.simpleMessage("単色"),
    "backup": MessageLookupByLibrary.simpleMessage("バックアップ"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage("バックアップと復元"),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "このバックアップは新しいバージョンのアプリで作成されています。アプリを更新してから復元してください",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("バックアップが完了しました"),
    "basicInfo": MessageLookupByLibrary.simpleMessage("基本情報"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("基本ポリシー"),
    "batchImport": MessageLookupByLibrary.simpleMessage("一括インポート"),
    "batchLineInputTip": MessageLookupByLibrary.simpleMessage("1 行に 1 項目"),
    "batchLinkInputTip": MessageLookupByLibrary.simpleMessage(
      "1行に1つのリンクを入力してください",
    ),
    "batchPreviewTip": m3,
    "batchUrlInputTip": MessageLookupByLibrary.simpleMessage(
      "1行に1つのURLを入力してください",
    ),
    "binaryData": MessageLookupByLibrary.simpleMessage("バイナリデータ"),
    "bind": MessageLookupByLibrary.simpleMessage("連携"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("ブラックリストモード"),
    "blockQuic": MessageLookupByLibrary.simpleMessage("QUIC をブロック"),
    "bodyRewrite": MessageLookupByLibrary.simpleMessage("ボディ書き換え"),
    "brandName": MessageLookupByLibrary.simpleMessage("天機クラウド"),
    "brightness": MessageLookupByLibrary.simpleMessage("明度"),
    "businessAboutBackupTitle": MessageLookupByLibrary.simpleMessage(
      "アプリ情報とバックアップ",
    ),
    "businessAboutPanel": MessageLookupByLibrary.simpleMessage("ユーザーパネルと更新"),
    "businessAccentColor": MessageLookupByLibrary.simpleMessage("アクセントカラー"),
    "businessAdvancedNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "ネットワーク詳細設定",
    ),
    "businessAiServiceLabel": MessageLookupByLibrary.simpleMessage("AI サービス"),
    "businessAiServices": MessageLookupByLibrary.simpleMessage(
      "ChatGPT · Claude",
    ),
    "businessAllLines": MessageLookupByLibrary.simpleMessage("すべての回線"),
    "businessAllowBypassDescription": MessageLookupByLibrary.simpleMessage(
      "選択したアプリを VPN の対象外にします。",
    ),
    "businessAppProxyTitle": MessageLookupByLibrary.simpleMessage("アプリ別プロキシ"),
    "businessAuthorizeTun": MessageLookupByLibrary.simpleMessage("仮想アダプターを承認"),
    "businessAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Windows へのサインイン後、バックグラウンドで実行",
    ),
    "businessAutoLaunchTitle": MessageLookupByLibrary.simpleMessage("起動時に自動起動"),
    "businessAutoRunDesc": MessageLookupByLibrary.simpleMessage("前回の回線とモードを使用"),
    "businessAutoRunTitle": MessageLookupByLibrary.simpleMessage("起動後に自動接続"),
    "businessAutoTest": MessageLookupByLibrary.simpleMessage("自動テスト"),
    "businessBackupDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルとアプリ設定をバックアップファイルに保存します。",
    ),
    "businessBackupNow": MessageLookupByLibrary.simpleMessage("今すぐバックアップ"),
    "businessCards": MessageLookupByLibrary.simpleMessage("カード"),
    "businessChangeLine": MessageLookupByLibrary.simpleMessage("回線を変更"),
    "businessCheckedAt": m4,
    "businessChooseLine": MessageLookupByLibrary.simpleMessage("回線を変更"),
    "businessClientVersion": MessageLookupByLibrary.simpleMessage(
      "クライアントバージョン",
    ),
    "businessClientVersionDesc": MessageLookupByLibrary.simpleMessage(
      "現在インストールされているクライアントバージョン",
    ),
    "businessCloseAllConnections": MessageLookupByLibrary.simpleMessage(
      "すべて閉じる",
    ),
    "businessCloseWindow": MessageLookupByLibrary.simpleMessage("ウィンドウを閉じるとき"),
    "businessConnectVia": m5,
    "businessConnectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "接続済み · 異常があります",
    ),
    "businessConnectedDisconnect": MessageLookupByLibrary.simpleMessage(
      "接続中 · クリックして切断",
    ),
    "businessConnectedProbeFailed": MessageLookupByLibrary.simpleMessage(
      "接続済み · 出口の確認に失敗",
    ),
    "businessConnectedUnverified": MessageLookupByLibrary.simpleMessage(
      "接続済み · 出口未検証",
    ),
    "businessCopyErrorInfo": MessageLookupByLibrary.simpleMessage("エラー情報をコピー"),
    "businessCurrent": MessageLookupByLibrary.simpleMessage("現在"),
    "businessCurrentExitIp": MessageLookupByLibrary.simpleMessage("現在の出口 IP"),
    "businessCurrentLine": MessageLookupByLibrary.simpleMessage("現在の回線"),
    "businessCurrentLineState": m6,
    "businessCurrentNode": MessageLookupByLibrary.simpleMessage("現在のノード"),
    "businessDatacenter": MessageLookupByLibrary.simpleMessage("データセンター"),
    "businessDelayTestShort": MessageLookupByLibrary.simpleMessage("速度測定"),
    "businessDelayTimeout": MessageLookupByLibrary.simpleMessage("タイムアウト"),
    "businessDeveloperDescription": MessageLookupByLibrary.simpleMessage(
      "診断と開発者向けツールを開きます。",
    ),
    "businessDeveloperOptionsDescription": MessageLookupByLibrary.simpleMessage(
      "これらのオプションは問題の診断に使います。通常は変更する必要はありません。",
    ),
    "businessDeveloperOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "開発者向けオプション",
    ),
    "businessDisclaimerAgree": MessageLookupByLibrary.simpleMessage("同意して続行"),
    "businessDisclaimerSubtitle": MessageLookupByLibrary.simpleMessage(
      "初回起動時に表示されます",
    ),
    "businessDisclaimerTitle": MessageLookupByLibrary.simpleMessage(
      "使用前にお読みください",
    ),
    "businessDisconnect": MessageLookupByLibrary.simpleMessage("切断"),
    "businessDnsAndSniffing": MessageLookupByLibrary.simpleMessage(
      "DNS とスニッフィング",
    ),
    "businessDnsFailed": MessageLookupByLibrary.simpleMessage("失敗"),
    "businessDnsModeDescription": MessageLookupByLibrary.simpleMessage(
      "DNS 応答の生成方法を選択します。",
    ),
    "businessDnsNoUpstream": MessageLookupByLibrary.simpleMessage(
      "DNS上書きサーバーは設定されていません。",
    ),
    "businessDnsProxyResolved": MessageLookupByLibrary.simpleMessage("プロキシで解決"),
    "businessDnsResourcePreview": MessageLookupByLibrary.simpleMessage(
      "ルーティングリソースのプレビュー",
    ),
    "businessDnsServers": MessageLookupByLibrary.simpleMessage("DNSサーバー"),
    "businessDnsSucceeded": MessageLookupByLibrary.simpleMessage("成功"),
    "businessDomainSniffingDescription": MessageLookupByLibrary.simpleMessage(
      "対応する通信からホスト名を読み取ります。",
    ),
    "businessEnableRules": MessageLookupByLibrary.simpleMessage(
      "スマートルーティングを有効化",
    ),
    "businessErrorSolutions": MessageLookupByLibrary.simpleMessage(
      "次の方法をお試しください",
    ),
    "businessErrorStepChangePort": MessageLookupByLibrary.simpleMessage(
      "設定 → インバウンドとポートでポートを変更する",
    ),
    "businessErrorStepClosePort": MessageLookupByLibrary.simpleMessage(
      "ポート 7890 を使用中のプログラムを終了して天機雲を再起動する",
    ),
    "businessExitAnomaly": MessageLookupByLibrary.simpleMessage(
      "回線に異常があります。サポートにお問い合わせください",
    ),
    "businessExitCheckPassed": MessageLookupByLibrary.simpleMessage(
      "出口確認に成功しました",
    ),
    "businessExitCountryMismatch": m7,
    "businessExitKindMismatch": MessageLookupByLibrary.simpleMessage(
      "出口の種類が選択した回線と一致しません",
    ),
    "businessExitMismatch": MessageLookupByLibrary.simpleMessage(
      "実際の出口が選択した回線と一致しません",
    ),
    "businessExitProbeDescription": MessageLookupByLibrary.simpleMessage(
      "出口チェックの結果がありません。プロキシは動作中の可能性があります。再確認するか、診断を実行してください。",
    ),
    "businessExitProbeUnavailable": MessageLookupByLibrary.simpleMessage(
      "出口を確認できません",
    ),
    "businessExitTunDescription": MessageLookupByLibrary.simpleMessage(
      "仮想アダプターが未承認です。ターミナルや一部のアプリはプロキシを経由せず、ローカル IP が表示されます。一度承認すると解決します。",
    ),
    "businessExitVerified": MessageLookupByLibrary.simpleMessage(
      "接続済み · 出口検証済み",
    ),
    "businessExitVerifiedDetail": m8,
    "businessExitVerifiedShort": MessageLookupByLibrary.simpleMessage(
      "出口を確認済み",
    ),
    "businessExpiryDate": m9,
    "businessExpiryDateShort": m10,
    "businessExpiryNotice": m11,
    "businessFollowSystem": MessageLookupByLibrary.simpleMessage("システムに従う"),
    "businessGroupHeader": MessageLookupByLibrary.simpleMessage("グループ"),
    "businessGroupLocked": MessageLookupByLibrary.simpleMessage("ロック中"),
    "businessHelp": MessageLookupByLibrary.simpleMessage("ヘルプ"),
    "businessHome": MessageLookupByLibrary.simpleMessage("ホーム"),
    "businessHotkeyHint": MessageLookupByLibrary.simpleMessage(
      "行を選択してショートカットを設定または変更",
    ),
    "businessImportAgain": MessageLookupByLibrary.simpleMessage("再インポート"),
    "businessImportRenew": MessageLookupByLibrary.simpleMessage("更新"),
    "businessIntercept": MessageLookupByLibrary.simpleMessage("ブロック"),
    "businessKernelRestart": MessageLookupByLibrary.simpleMessage("コアを再起動"),
    "businessKernelStartFailed": MessageLookupByLibrary.simpleMessage(
      "ネットワークコアを起動できませんでした",
    ),
    "businessKernelUptime": MessageLookupByLibrary.simpleMessage("稼働時間"),
    "businessLegal": MessageLookupByLibrary.simpleMessage("法律情報"),
    "businessLineCount": MessageLookupByLibrary.simpleMessage("件"),
    "businessLineFailed": MessageLookupByLibrary.simpleMessage(
      "回線の切り替えを完了できませんでした。再試行してください。",
    ),
    "businessLineSelectionHint": MessageLookupByLibrary.simpleMessage(
      "手動選択が優先されます。選択した回線が出口になり、切替後に出口 IP を確認します。不一致の場合は理由を表示します。",
    ),
    "businessLineSelectionHintShort": MessageLookupByLibrary.simpleMessage(
      "選択した回線が出口になり、切替後に出口 IP を確認します。",
    ),
    "businessLineTitle": MessageLookupByLibrary.simpleMessage("既定の回線"),
    "businessLines": MessageLookupByLibrary.simpleMessage("回線"),
    "businessLinesEmpty": MessageLookupByLibrary.simpleMessage(
      "回線が読み込まれていません。サブスクリプションを確認してください。",
    ),
    "businessLinesLoading": MessageLookupByLibrary.simpleMessage(
      "利用可能な回線を読み込み中…",
    ),
    "businessLocalExport": MessageLookupByLibrary.simpleMessage(
      "ローカルファイルにエクスポート",
    ),
    "businessLocalPorts": MessageLookupByLibrary.simpleMessage("ローカルポート"),
    "businessLocked": MessageLookupByLibrary.simpleMessage("固定"),
    "businessLockedExit": MessageLookupByLibrary.simpleMessage("出口を固定"),
    "businessMainlandDirect": MessageLookupByLibrary.simpleMessage("中国本土直通"),
    "businessManage": MessageLookupByLibrary.simpleMessage("管理"),
    "businessManualSelect": MessageLookupByLibrary.simpleMessage("手動選択"),
    "businessMinimizeDesc": MessageLookupByLibrary.simpleMessage(
      "トレイアイコンに接続状態を常に表示",
    ),
    "businessMinimizeToTray": MessageLookupByLibrary.simpleMessage("トレイに最小化"),
    "businessMitmDescription": MessageLookupByLibrary.simpleMessage(
      "ローカル証明書で HTTPS 通信を検査します。",
    ),
    "businessMitmWarning": MessageLookupByLibrary.simpleMessage(
      "MITM は一致するドメインの HTTPS トラフィックを復号します。信頼できるモジュールでのみ有効にしてください。",
    ),
    "businessMonthTraffic": MessageLookupByLibrary.simpleMessage("今月の通信量"),
    "businessMonthUsed": MessageLookupByLibrary.simpleMessage("今月の使用量"),
    "businessMoreVpnDescription": MessageLookupByLibrary.simpleMessage(
      "その他の VPN インターフェイス設定を開きます。",
    ),
    "businessMoreVpnSettings": MessageLookupByLibrary.simpleMessage(
      "その他の VPN 設定",
    ),
    "businessMultiplier": m12,
    "businessNetworkStack": MessageLookupByLibrary.simpleMessage("ネットワークスタック"),
    "businessNoExitInfo": MessageLookupByLibrary.simpleMessage("出口情報なし"),
    "businessNotConnected": MessageLookupByLibrary.simpleMessage("未接続"),
    "businessOnDemandConnection": MessageLookupByLibrary.simpleMessage(
      "オンデマンド接続",
    ),
    "businessOnDemandEmpty": MessageLookupByLibrary.simpleMessage(
      "Wi-Fiネットワークを追加すると、接続時にアプリを一時停止できます。",
    ),
    "businessOnboardingFactDashboard": MessageLookupByLibrary.simpleMessage(
      "ダッシュボードで接続統計を確認",
    ),
    "businessOnboardingFactImport": MessageLookupByLibrary.simpleMessage(
      "サブスクリプション設定をインポート",
    ),
    "businessOnboardingFactStatus": MessageLookupByLibrary.simpleMessage(
      "回線の接続状態を確認",
    ),
    "businessOnboardingFailedChangeLink": MessageLookupByLibrary.simpleMessage(
      "別のサブスクリプションリンクを使う",
    ),
    "businessOnboardingFailedDays": m13,
    "businessOnboardingFailedExpiredDescription": m14,
    "businessOnboardingFailedExpiredTitle":
        MessageLookupByLibrary.simpleMessage("このサブスクリプションは有効期限切れです"),
    "businessOnboardingFailedPackage": MessageLookupByLibrary.simpleMessage(
      "プラン",
    ),
    "businessOnboardingFailedPastedUrl": MessageLookupByLibrary.simpleMessage(
      "貼り付けたリンク",
    ),
    "businessOnboardingFailedRenew": MessageLookupByLibrary.simpleMessage(
      "更新する",
    ),
    "businessOnboardingFailedRetainedConfig":
        MessageLookupByLibrary.simpleMessage(
          "以前の設定は保持されており、クライアントは引き続き利用できます。",
        ),
    "businessOnboardingFailedRetry": MessageLookupByLibrary.simpleMessage(
      "再確認",
    ),
    "businessOnboardingFailedStatus": MessageLookupByLibrary.simpleMessage(
      "状態",
    ),
    "businessOnboardingFailedStep": m15,
    "businessOnboardingHeroTitle": MessageLookupByLibrary.simpleMessage(
      "3ステップで天機雲に接続",
    ),
    "businessOnboardingImportConnect": MessageLookupByLibrary.simpleMessage(
      "インポートして接続",
    ),
    "businessOnboardingScanFile": MessageLookupByLibrary.simpleMessage(
      "QRコードをスキャン / ファイルを選択",
    ),
    "businessOnboardingUrlHint": MessageLookupByLibrary.simpleMessage(
      "天機雲のリンクを貼り付け",
    ),
    "businessOnboardingUrlLabel": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンク",
    ),
    "businessOpenSource": MessageLookupByLibrary.simpleMessage("オープンソースライセンス"),
    "businessOpenSourceDescription": MessageLookupByLibrary.simpleMessage(
      "FlClash ベース · GPL-3.0",
    ),
    "businessOrdinaryWebExit": MessageLookupByLibrary.simpleMessage(
      "一般ウェブサイトの出口",
    ),
    "businessOutboundLabel": MessageLookupByLibrary.simpleMessage("出力"),
    "businessOverrideSettings": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションの上書き",
    ),
    "businessPortConflictTip": MessageLookupByLibrary.simpleMessage(
      "ポート 7890 は他のプログラムが使用中のため、天機雲は待ち受けできません。ネットワーク設定は変更されていないため、通常どおり閲覧できます。",
    ),
    "businessPrivacyTerms": MessageLookupByLibrary.simpleMessage(
      "プライバシーポリシー · 利用規約",
    ),
    "businessProfileAddAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "自動更新",
    ),
    "businessProfileAddClipboardRecognized":
        MessageLookupByLibrary.simpleMessage(
          "クリップボードから Tianji Cloud のリンクを検出しました",
        ),
    "businessProfileAddCustomDescription": MessageLookupByLibrary.simpleMessage(
      "既存のサブスクリプションにルールを追加",
    ),
    "businessProfileAddCustomTitle": MessageLookupByLibrary.simpleMessage(
      "カスタム設定",
    ),
    "businessProfileAddFileDescription": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "businessProfileAddFileTitle": MessageLookupByLibrary.simpleMessage(
      "ローカルファイル",
    ),
    "businessProfileAddLinkDescription": MessageLookupByLibrary.simpleMessage(
      "ユーザーパネルからコピー",
    ),
    "businessProfileAddLinkTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンク",
    ),
    "businessProfileAddMoreOptions": MessageLookupByLibrary.simpleMessage(
      "その他のオプション",
    ),
    "businessProfileAddNameHint": MessageLookupByLibrary.simpleMessage(
      "空欄の場合はサブスクリプション内のプラン名を使用",
    ),
    "businessProfileAddNameLabel": MessageLookupByLibrary.simpleMessage(
      "名前（任意）",
    ),
    "businessProfileAddSubmit": MessageLookupByLibrary.simpleMessage(
      "インポートして検証",
    ),
    "businessProfileAddTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションを追加",
    ),
    "businessProfileAddUrlHint": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクを貼り付け",
    ),
    "businessProfileAddUrlLabel": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンク",
    ),
    "businessProfileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "インポート時に検証します。解析に失敗しても現在の設定は上書きされません。",
    ),
    "businessProfileEditDelete": MessageLookupByLibrary.simpleMessage(
      "このサブスクリプションを削除",
    ),
    "businessProfileEditDeleteDescription":
        MessageLookupByLibrary.simpleMessage(
          "この端末の設定のみ削除します。Tianji Cloud アカウントとプランには影響しません。",
        ),
    "businessProfileEditDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションを削除",
    ),
    "businessProfileEditExpire": MessageLookupByLibrary.simpleMessage("有効期限"),
    "businessProfileEditExtendDescription":
        MessageLookupByLibrary.simpleMessage("有効なオーバーライド："),
    "businessProfileEditExtendSuffix": MessageLookupByLibrary.simpleMessage(
      " 件",
    ),
    "businessProfileEditExtensionTitle": MessageLookupByLibrary.simpleMessage(
      "拡張オーバーライドとスクリプト",
    ),
    "businessProfileEditGroupCountSuffix": MessageLookupByLibrary.simpleMessage(
      " グループ",
    ),
    "businessProfileEditHide": MessageLookupByLibrary.simpleMessage("非表示"),
    "businessProfileEditLineCountSeparator":
        MessageLookupByLibrary.simpleMessage(" 件 · "),
    "businessProfileEditLineLabel": MessageLookupByLibrary.simpleMessage("回線"),
    "businessProfileEditManage": MessageLookupByLibrary.simpleMessage("管理"),
    "businessProfileEditOpen": MessageLookupByLibrary.simpleMessage("開く"),
    "businessProfileEditPlan": MessageLookupByLibrary.simpleMessage("プラン"),
    "businessProfileEditPreviewDescription":
        MessageLookupByLibrary.simpleMessage(
          "読み取り専用プレビューです。変更にはカスタム設定を使用してください。",
        ),
    "businessProfileEditPrivacy": MessageLookupByLibrary.simpleMessage(
      "このリンクには個人トークンが含まれています。共有しないでください。",
    ),
    "businessProfileEditRawTitle": MessageLookupByLibrary.simpleMessage(
      "元の設定を表示",
    ),
    "businessProfileEditRenew": MessageLookupByLibrary.simpleMessage(
      "更新 / アップグレード",
    ),
    "businessProfileEditShow": MessageLookupByLibrary.simpleMessage("表示"),
    "businessProfileEditSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "プラン情報",
    ),
    "businessProfileEditTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションを編集",
    ),
    "businessProfilesSortDescription": MessageLookupByLibrary.simpleMessage(
      "ドラッグして順序を変更します。先にあるサブスクリプションがダッシュボードとトレイに優先表示されます。",
    ),
    "businessProfilesSortTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションの順序を変更",
    ),
    "businessProvidersTitle": MessageLookupByLibrary.simpleMessage(
      "プロキシセットとルールセット",
    ),
    "businessProxyCardDensity": MessageLookupByLibrary.simpleMessage(
      "プロキシカードの密度",
    ),
    "businessProxyCheckedGroup": m16,
    "businessProxyDnsRemote": MessageLookupByLibrary.simpleMessage(
      "プロキシ通信のドメインは回線側で解決されます",
    ),
    "businessProxyIcons": MessageLookupByLibrary.simpleMessage("プロキシアイコン"),
    "businessProxyNextConnection": MessageLookupByLibrary.simpleMessage(
      "変更は次回の接続時に反映されます",
    ),
    "businessProxyProviders": MessageLookupByLibrary.simpleMessage("プロキシセット"),
    "businessProxyReconnect": MessageLookupByLibrary.simpleMessage("今すぐ再接続"),
    "businessProxySearchHint": MessageLookupByLibrary.simpleMessage("アプリを検索"),
    "businessProxySelectedBypass": MessageLookupByLibrary.simpleMessage(
      "チェックしたアプリはプロキシを迂回",
    ),
    "businessProxySelectedCount": m17,
    "businessProxySelectedOnly": MessageLookupByLibrary.simpleMessage(
      "チェックしたアプリのみプロキシ",
    ),
    "businessProxyTraffic": MessageLookupByLibrary.simpleMessage("プロキシ"),
    "businessProxyUncheckedGroup": MessageLookupByLibrary.simpleMessage("未選択"),
    "businessRecheck": MessageLookupByLibrary.simpleMessage("再確認"),
    "businessRegionAT": MessageLookupByLibrary.simpleMessage("オーストリア"),
    "businessRegionAU": MessageLookupByLibrary.simpleMessage("オーストラリア"),
    "businessRegionBE": MessageLookupByLibrary.simpleMessage("ベルギー"),
    "businessRegionBR": MessageLookupByLibrary.simpleMessage("ブラジル"),
    "businessRegionCA": MessageLookupByLibrary.simpleMessage("カナダ"),
    "businessRegionCO": MessageLookupByLibrary.simpleMessage("コロンビア"),
    "businessRegionCZ": MessageLookupByLibrary.simpleMessage("チェコ"),
    "businessRegionDE": MessageLookupByLibrary.simpleMessage("ドイツ"),
    "businessRegionFR": MessageLookupByLibrary.simpleMessage("フランス"),
    "businessRegionGB": MessageLookupByLibrary.simpleMessage("イギリス"),
    "businessRegionHK": MessageLookupByLibrary.simpleMessage("香港"),
    "businessRegionIT": MessageLookupByLibrary.simpleMessage("イタリア"),
    "businessRegionJP": MessageLookupByLibrary.simpleMessage("日本"),
    "businessRegionKR": MessageLookupByLibrary.simpleMessage("韓国"),
    "businessRegionLocalDns": MessageLookupByLibrary.simpleMessage(
      "中国本土のドメインはローカル DNS で解決されます",
    ),
    "businessRegionRO": MessageLookupByLibrary.simpleMessage("ルーマニア"),
    "businessRegionSE": MessageLookupByLibrary.simpleMessage("スウェーデン"),
    "businessRegionSG": MessageLookupByLibrary.simpleMessage("シンガポール"),
    "businessRegionTW": MessageLookupByLibrary.simpleMessage("台湾"),
    "businessRegionUS": MessageLookupByLibrary.simpleMessage("アメリカ"),
    "businessReplace": MessageLookupByLibrary.simpleMessage("変更"),
    "businessResidential": MessageLookupByLibrary.simpleMessage("住宅"),
    "businessResidentialBroadband": MessageLookupByLibrary.simpleMessage(
      "住宅用ブロードバンド",
    ),
    "businessResidentialLockedHint": m18,
    "businessResidentialShort": MessageLookupByLibrary.simpleMessage("住宅"),
    "businessRestoreAction": MessageLookupByLibrary.simpleMessage("復元…"),
    "businessRestoreFromFileWebDav": MessageLookupByLibrary.simpleMessage(
      "ファイルまたは WebDAV から復元",
    ),
    "businessRoutingDesc": MessageLookupByLibrary.simpleMessage(
      "既定の回線のみ変更します。AI・動画などの個別ルール、直接接続、ブロックのルールは維持します。",
    ),
    "businessRuleModeRequired": MessageLookupByLibrary.simpleMessage(
      "スマートルーティングが無効のため、この既定の回線は現在適用されていません。",
    ),
    "businessRuleOverrideDescription": MessageLookupByLibrary.simpleMessage(
      "ルールとプロバイダーを管理します。",
    ),
    "businessRuleProviders": MessageLookupByLibrary.simpleMessage("ルールセット"),
    "businessScanPrompt": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションの QR コードを枠内に入れてください",
    ),
    "businessSearchHint": MessageLookupByLibrary.simpleMessage("回線名または地域を検索"),
    "businessSelected": MessageLookupByLibrary.simpleMessage("選択中"),
    "businessSelectionStale": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションまたはモードが変わりました。回線選択を開き直してください。",
    ),
    "businessServiceNoLogin": MessageLookupByLibrary.simpleMessage("ログイン不要"),
    "businessSettingsAbout": MessageLookupByLibrary.simpleMessage("天机云について"),
    "businessSettingsAppearance": MessageLookupByLibrary.simpleMessage("外観"),
    "businessSettingsCommon": MessageLookupByLibrary.simpleMessage("よく使う項目"),
    "businessSettingsDnsResources": MessageLookupByLibrary.simpleMessage(
      "DNS とリソース",
    ),
    "businessSettingsHotkeys": MessageLookupByLibrary.simpleMessage("ショートカット"),
    "businessSettingsIconsUa": MessageLookupByLibrary.simpleMessage("アイコンと UA"),
    "businessSettingsInboundPorts": MessageLookupByLibrary.simpleMessage(
      "受信とポート",
    ),
    "businessSettingsNetworkAdvanced": MessageLookupByLibrary.simpleMessage(
      "ネットワーク（詳細）",
    ),
    "businessSettingsOther": MessageLookupByLibrary.simpleMessage("その他"),
    "businessSettingsRules": MessageLookupByLibrary.simpleMessage("ルールと上書き"),
    "businessSettingsStartupWindow": MessageLookupByLibrary.simpleMessage(
      "起動とウィンドウ",
    ),
    "businessSettingsTun": MessageLookupByLibrary.simpleMessage("仮想アダプター TUN"),
    "businessSmartRouting": MessageLookupByLibrary.simpleMessage("スマートルーティング"),
    "businessSortByDelay": MessageLookupByLibrary.simpleMessage("遅延順に並べ替え"),
    "businessStackModeDescription": MessageLookupByLibrary.simpleMessage(
      "VPN が使用するネットワークスタックを選択します。",
    ),
    "businessSubscriptionAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションの自動更新",
    ),
    "businessSubscriptionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "回線の変更後に自動で更新",
    ),
    "businessSubscriptionDetails": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションの詳細",
    ),
    "businessSubscriptionOverridesDescription":
        MessageLookupByLibrary.simpleMessage("このサブスクリプションが提供する DNS 設定。"),
    "businessSubscriptionUpdatedAt": m19,
    "businessSubscriptions": MessageLookupByLibrary.simpleMessage("サブスクリプション"),
    "businessSubstitutedCategories": m20,
    "businessSwitchMode": MessageLookupByLibrary.simpleMessage("モードを切り替え"),
    "businessSystemProxyDescription": MessageLookupByLibrary.simpleMessage(
      "HTTP 通信をシステムプロキシ経由にします。",
    ),
    "businessSystemProxyHttp": MessageLookupByLibrary.simpleMessage(
      "システムプロキシ（HTTP）",
    ),
    "businessTapToConnect": MessageLookupByLibrary.simpleMessage("タップして接続"),
    "businessTestAll": MessageLookupByLibrary.simpleMessage("すべて測定"),
    "businessToolsAppearance": MessageLookupByLibrary.simpleMessage("外観"),
    "businessToolsAppearanceLanguage": MessageLookupByLibrary.simpleMessage(
      "外観と言語",
    ),
    "businessToolsApplicationCount": m21,
    "businessToolsBrowse": MessageLookupByLibrary.simpleMessage("閲覧"),
    "businessToolsConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "接続とリクエスト",
    ),
    "businessToolsGeneral": MessageLookupByLibrary.simpleMessage("一般"),
    "businessToolsLocalDirect": MessageLookupByLibrary.simpleMessage(
      "ローカルネットワーク機器を直接接続",
    ),
    "businessToolsPassedCount": m22,
    "businessToolsPerAppProxy": MessageLookupByLibrary.simpleMessage(
      "アプリごとのプロキシ",
    ),
    "businessToolsRequestCount": m23,
    "businessToolsRoutingResources": MessageLookupByLibrary.simpleMessage(
      "ルーティングリソース",
    ),
    "businessToolsRuntimeLogs": MessageLookupByLibrary.simpleMessage("実行ログ"),
    "businessToolsSimplifiedChinese": MessageLookupByLibrary.simpleMessage(
      "簡体字中国語",
    ),
    "businessTrafficNotOnTianji": MessageLookupByLibrary.simpleMessage(
      "通信が天机回線を経由していません",
    ),
    "businessTrafficScope": MessageLookupByLibrary.simpleMessage(
      "今月の通信量（このデバイスのみ）",
    ),
    "businessTunBypassPrivateDescription": MessageLookupByLibrary.simpleMessage(
      "プリンターや NAS などの LAN 機器へ直接アクセス",
    ),
    "businessTunCaption": MessageLookupByLibrary.simpleMessage("すべてのアプリ通信を処理"),
    "businessTunDevice": MessageLookupByLibrary.simpleMessage("アダプター名"),
    "businessTunExcludedRoutes": MessageLookupByLibrary.simpleMessage("除外ルート"),
    "businessTunMtu": MessageLookupByLibrary.simpleMessage("MTU"),
    "businessTunRouteCount": MessageLookupByLibrary.simpleMessage("件"),
    "businessTunStackGvisorDescription": MessageLookupByLibrary.simpleMessage(
      "TCP と UDP に gVisor のユーザー空間スタックを使用",
    ),
    "businessTunStackMipsDescription": MessageLookupByLibrary.simpleMessage(
      "TCP と UDP にユーザー空間スタック mipstack を使用",
    ),
    "businessTunStackMixed": MessageLookupByLibrary.simpleMessage("混合"),
    "businessTunStackMixedDescription": MessageLookupByLibrary.simpleMessage(
      "TCP はシステムスタック、UDP は gVisor を使用し、互換性に優れます",
    ),
    "businessTunStackSystemDescription": MessageLookupByLibrary.simpleMessage(
      "TCP と UDP に OS のネットワークスタックを使用",
    ),
    "businessTunTakeoverDescription": MessageLookupByLibrary.simpleMessage(
      "仮想アダプターがターミナル、ゲーム、システムプロキシを使わないアプリを含むすべてのアプリの通信を処理します。システムサービスを管理者権限で実行してください。",
    ),
    "businessTunTakeoverMode": MessageLookupByLibrary.simpleMessage(
      "通信の引き継ぎ方法",
    ),
    "businessTunTitle": MessageLookupByLibrary.simpleMessage(
      "仮想ネットワークインターフェイス（TUN）",
    ),
    "businessTypographyLayout": MessageLookupByLibrary.simpleMessage(
      "文字とレイアウト",
    ),
    "businessUpdateAvailable": m24,
    "businessUpdateDaily": MessageLookupByLibrary.simpleMessage("毎日"),
    "businessUpdateHour1": MessageLookupByLibrary.simpleMessage("1 時間ごと"),
    "businessUpdateHour12": MessageLookupByLibrary.simpleMessage("12 時間ごと"),
    "businessUpdateHour6": MessageLookupByLibrary.simpleMessage("6 時間ごと"),
    "businessUsagePercent": m25,
    "businessVersion": MessageLookupByLibrary.simpleMessage("バージョン"),
    "businessViewDiagnostics": MessageLookupByLibrary.simpleMessage("診断を見る"),
    "businessVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "businessVpnPermission": MessageLookupByLibrary.simpleMessage(
      "初回接続時に VPN の許可が必要です",
    ),
    "businessWebDavBackup": MessageLookupByLibrary.simpleMessage(
      "WebDAV バックアップ",
    ),
    "businessWifiRulesCount": m26,
    "bypassDomain": MessageLookupByLibrary.simpleMessage("除外ドメイン"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "除外ドメインはシステムプロキシが有効な場合のみ適用されます。",
    ),
    "bypassPrivateRoute": MessageLookupByLibrary.simpleMessage(
      "プライベートアドレスをバイパス",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("キャッシュ"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("キャッシュアルゴリズム"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "キャッシュが破損しています。クリアしますか？",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("キャッシュサイズ"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "QRコードをスキャンするには、システム設定でカメラへのアクセスを許可するか、アルバムからQRコード画像を選択してください。",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "カメラの権限が必要です",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage("カメラを使用できません"),
    "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("すべて選択解除"),
    "cannotSave": MessageLookupByLibrary.simpleMessage("保存できません"),
    "certificate": MessageLookupByLibrary.simpleMessage("証明書"),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "プロキシの切り替えに失敗したため、前回の選択に戻しました",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage("破壊的変更"),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("新機能"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("不具合修正"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage("パフォーマンス"),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("取り消し"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage("TLS証明書を検証"),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "TLS 証明書の検証を無効にすると、サブスクリプションとバックアップが中間者攻撃にさらされます。",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("更新を確認"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage("すでに最新バージョンです"),
    "checkingExit": MessageLookupByLibrary.simpleMessage("出口を確認中…"),
    "chooseFile": MessageLookupByLibrary.simpleMessage("ファイルを選択"),
    "cipher": MessageLookupByLibrary.simpleMessage("暗号方式"),
    "clearData": MessageLookupByLibrary.simpleMessage("データを消去"),
    "clearDataAndExitTip": MessageLookupByLibrary.simpleMessage(
      "すべてのプロファイル、設定、ローカルデータを削除してアプリを終了します。もう一度開くと最初から始められます。",
    ),
    "clearDataFailed": m27,
    "clearDnsCache": MessageLookupByLibrary.simpleMessage("DNSキャッシュをクリア"),
    "clearDnsCacheFailed": MessageLookupByLibrary.simpleMessage(
      "DNSキャッシュのクリアに失敗しました",
    ),
    "clearSearch": MessageLookupByLibrary.simpleMessage("検索をクリア"),
    "clientFingerprint": MessageLookupByLibrary.simpleMessage(
      "クライアントフィンガープリント",
    ),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("クリップボードへエクスポート"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("クリップボードからインポート"),
    "clipboardNoPackageNames": MessageLookupByLibrary.simpleMessage(
      "クリップボードに有効なパッケージ名がありません",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "クリップボードにコピーできませんでした。選択範囲が大きすぎる可能性があります",
    ),
    "close": MessageLookupByLibrary.simpleMessage("閉じる"),
    "closeAllConnections": MessageLookupByLibrary.simpleMessage("すべての接続を閉じる"),
    "closeConnection": MessageLookupByLibrary.simpleMessage("接続を閉じる"),
    "closeConnections": MessageLookupByLibrary.simpleMessage("接続を閉じる"),
    "color": MessageLookupByLibrary.simpleMessage("カラー"),
    "colorStyle": MessageLookupByLibrary.simpleMessage("配色スタイル"),
    "columns": MessageLookupByLibrary.simpleMessage("列数"),
    "compact": MessageLookupByLibrary.simpleMessage("コンパクト"),
    "compatible": MessageLookupByLibrary.simpleMessage("互換モード"),
    "confirm": MessageLookupByLibrary.simpleMessage("OK"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "すべてのデータを消去してもよろしいですか？",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "このプロキシグループを削除してもよろしいですか？",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "現在のウィンドウを閉じてもよろしいですか？",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "コアを強制クラッシュさせてもよろしいですか？",
    ),
    "congestionControl": MessageLookupByLibrary.simpleMessage("輻輳制御"),
    "congestionController": MessageLookupByLibrary.simpleMessage("TCP 輻輳制御"),
    "congestionControllerDesc": MessageLookupByLibrary.simpleMessage(
      "TCP 輻輳制御は mips スタックでのみ有効です。",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("接続済み"),
    "connecting": MessageLookupByLibrary.simpleMessage("接続中…"),
    "connection": MessageLookupByLibrary.simpleMessage("接続"),
    "connectionAddDomainRule": MessageLookupByLibrary.simpleMessage(
      "このドメインのルールを追加",
    ),
    "connectionBlockedLabel": MessageLookupByLibrary.simpleMessage("ブロック済み"),
    "connectionCloseThis": MessageLookupByLibrary.simpleMessage("この接続を閉じる"),
    "connectionGroup": MessageLookupByLibrary.simpleMessage("グループ"),
    "connectionLocalDevice": MessageLookupByLibrary.simpleMessage("このデバイス"),
    "connectionMatchedRule": MessageLookupByLibrary.simpleMessage("適用ルール"),
    "connectionProcessPath": MessageLookupByLibrary.simpleMessage("プロセスパス"),
    "connectionSearchHint": MessageLookupByLibrary.simpleMessage(
      "ドメイン、アプリ、ルールを検索",
    ),
    "connectionSniffedDomain": MessageLookupByLibrary.simpleMessage(
      "検出されたドメイン",
    ),
    "connectionSourceAddress": MessageLookupByLibrary.simpleMessage("送信元アドレス"),
    "connectionStartTime": MessageLookupByLibrary.simpleMessage("開始時刻"),
    "connectionStats": MessageLookupByLibrary.simpleMessage("接続統計"),
    "connectionStatsDesc": MessageLookupByLibrary.simpleMessage(
      "ライブ接続、最近のリクエスト、DNS クエリ",
    ),
    "connectionSummary": m28,
    "connectionSustained": MessageLookupByLibrary.simpleMessage("経過"),
    "connectionTargetIp": MessageLookupByLibrary.simpleMessage("宛先 IP"),
    "connectionTrafficPath": MessageLookupByLibrary.simpleMessage("通信経路"),
    "connections": MessageLookupByLibrary.simpleMessage("接続"),
    "connectionsAndRequests": MessageLookupByLibrary.simpleMessage("接続とリクエスト"),
    "connectionsLiveShort": MessageLookupByLibrary.simpleMessage("ライブ"),
    "connectivity": MessageLookupByLibrary.simpleMessage("接続状態："),
    "content": MessageLookupByLibrary.simpleMessage("内容"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage("内容は空にできません"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "グローバル追加ルールを管理",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("コピー"),
    "copyAsBase64": MessageLookupByLibrary.simpleMessage("Base64 としてコピー"),
    "copyAsCurl": MessageLookupByLibrary.simpleMessage("cURL としてコピー"),
    "copyDestination": MessageLookupByLibrary.simpleMessage("宛先をコピー"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage("環境変数をコピー"),
    "copyHost": MessageLookupByLibrary.simpleMessage("ホストをコピー"),
    "copyLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
    "copyRequest": MessageLookupByLibrary.simpleMessage("リクエストをコピー"),
    "copyResponse": MessageLookupByLibrary.simpleMessage("レスポンスをコピー"),
    "copyResponseBody": MessageLookupByLibrary.simpleMessage("レスポンス本文をコピー"),
    "copySubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクをコピー",
    ),
    "copySuccess": MessageLookupByLibrary.simpleMessage("コピーしました"),
    "core": MessageLookupByLibrary.simpleMessage("コア"),
    "coreBlockedByPolicyTip": m29,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Windows のスマート アプリ コントロールが、署名されていない TianjiCloudCore.exe をブロックしました。Windows セキュリティ → アプリとブラウザーの制御 → スマート アプリ コントロールの設定で「オフ」を選び、天机云を再起動してください。一度オフにすると、Windows を再インストールしない限り再度オンにはできません。",
    ),
    "coreStatus": MessageLookupByLibrary.simpleMessage("コアの状態"),
    "country": MessageLookupByLibrary.simpleMessage("地域"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("クラッシュを検出しました"),
    "crashDetectedTip": m30,
    "crashTest": MessageLookupByLibrary.simpleMessage("クラッシュテスト"),
    "create": MessageLookupByLibrary.simpleMessage("作成"),
    "createProfileFromUrlTip": m31,
    "creationTime": MessageLookupByLibrary.simpleMessage("作成日時"),
    "currentExpiry": MessageLookupByLibrary.simpleMessage("有効期限"),
    "currentOutboundDesc": MessageLookupByLibrary.simpleMessage(
      "起動ボタンがあるため削除できません",
    ),
    "currentUsage": MessageLookupByLibrary.simpleMessage("今月の使用量"),
    "custom": MessageLookupByLibrary.simpleMessage("カスタム"),
    "customAddProxy": MessageLookupByLibrary.simpleMessage("プロキシを追加"),
    "customColor": MessageLookupByLibrary.simpleMessage("カスタムカラー"),
    "customGroupMemberSummary": m32,
    "customGroupRuleUsage": m33,
    "customGroupsLabel": MessageLookupByLibrary.simpleMessage("グループ"),
    "customImportDroppedSubRules": m34,
    "customImportFromLink": MessageLookupByLibrary.simpleMessage("リンクから読み込む"),
    "customIssueCoreRejected": m35,
    "customIssueDialerLoop": m36,
    "customIssueDuplicateName": m37,
    "customIssueEmptyName": MessageLookupByLibrary.simpleMessage("名前が空です"),
    "customIssueGroupLoop": m38,
    "customIssueInvalidEmptyFallback": m39,
    "customIssueInvalidFilter": m40,
    "customIssueMissingDialer": m41,
    "customIssueMissingProviders": m42,
    "customIssueMissingProxies": m43,
    "customIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "プロキシもプロキシプロバイダーも選択されていないため、コアはこのグループを拒否します",
    ),
    "customIssueReservedName": m44,
    "customIssuesSummary": m45,
    "customPreviewMerged": MessageLookupByLibrary.simpleMessage("統合結果をプレビュー"),
    "customProfile": MessageLookupByLibrary.simpleMessage("カスタム"),
    "customProvidersAndDialers": MessageLookupByLibrary.simpleMessage(
      "プロバイダーとダイヤル",
    ),
    "customProxyCardTitle": MessageLookupByLibrary.simpleMessage("カスタムプロキシ"),
    "customProxyGroupUsage": m46,
    "customProxySubscriptionNote": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションのプロキシは、ここにあるプロキシと一緒に表示されます。",
    ),
    "customProxyUnreferenced": MessageLookupByLibrary.simpleMessage("未参照"),
    "customResources": MessageLookupByLibrary.simpleMessage("カスタム"),
    "customRuleCardTitle": MessageLookupByLibrary.simpleMessage("マイルール"),
    "customRulePresets": MessageLookupByLibrary.simpleMessage("プリセットから追加"),
    "cut": MessageLookupByLibrary.simpleMessage("切り取り"),
    "dark": MessageLookupByLibrary.simpleMessage("ダーク"),
    "dashboard": MessageLookupByLibrary.simpleMessage("ダッシュボード"),
    "dashboardAddableSection": MessageLookupByLibrary.simpleMessage("追加できるカード"),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "変更の保存に失敗したため、元に戻しました",
    ),
    "daysAgo": m47,
    "daysAgoShort": m48,
    "daysUnit": MessageLookupByLibrary.simpleMessage("日"),
    "decryptUntrusted": MessageLookupByLibrary.simpleMessage(
      "ローカルで信頼されていなくても復号",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "ほかの DNS サーバーのドメイン名を解決します。IP アドレスのみ指定できます。",
    ),
    "defaultSelected": MessageLookupByLibrary.simpleMessage("デフォルトの選択"),
    "defaultText": MessageLookupByLibrary.simpleMessage("デフォルト"),
    "definitionNotMap": MessageLookupByLibrary.simpleMessage(
      "設定は name と type を含む YAML マッピングである必要があります",
    ),
    "delay": MessageLookupByLibrary.simpleMessage("遅延"),
    "delayFailed": MessageLookupByLibrary.simpleMessage("失敗"),
    "delayTest": MessageLookupByLibrary.simpleMessage("遅延テスト"),
    "delayTestTimeout": MessageLookupByLibrary.simpleMessage("遅延テストのタイムアウト"),
    "delete": MessageLookupByLibrary.simpleMessage("削除"),
    "deleteMultipTip": m49,
    "deleteTip": m50,
    "desc": MessageLookupByLibrary.simpleMessage(
      "ClashMetaベースのマルチプラットフォーム対応プロキシクライアント。シンプルで使いやすく、オープンソースで広告もありません。",
    ),
    "desktopAsnDescription": MessageLookupByLibrary.simpleMessage(
      "自律システムデータベース",
    ),
    "desktopFakeIpExplanation": MessageLookupByLibrary.simpleMessage(
      "198.18.0.0/16 は fake-IP の割り当て範囲です。実際の DNS 解決は出口側で行われ、ローカル ISP を経由しません。",
    ),
    "desktopGeoIpDescription": MessageLookupByLibrary.simpleMessage(
      "IP ロケーションデータベース",
    ),
    "desktopGeoSiteDescription": MessageLookupByLibrary.simpleMessage(
      "ドメイン分類データベース",
    ),
    "desktopResourceLatest": MessageLookupByLibrary.simpleMessage("最新です"),
    "desktopResourceUpdateNote": m51,
    "desktopRuleSetDescription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションから配信",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("宛先"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage("宛先GeoIP"),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("宛先IP ASN"),
    "details": m52,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "サードパーティAPIに依存しているため、参考値です",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("開発者モード"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "開発者モードが有効になりました。",
    ),
    "diagnosticsFailed": MessageLookupByLibrary.simpleMessage("未合格"),
    "diagnosticsPassed": MessageLookupByLibrary.simpleMessage("成功"),
    "diagnosticsRunAgain": MessageLookupByLibrary.simpleMessage("再診断"),
    "diagnosticsSelection": MessageLookupByLibrary.simpleMessage("既定経路の出口検証"),
    "diagnosticsStart": MessageLookupByLibrary.simpleMessage("診断開始"),
    "diagnosticsTitle": MessageLookupByLibrary.simpleMessage("ワンクリック診断"),
    "diagnosticsUnavailableNotice": MessageLookupByLibrary.simpleMessage(
      "DNS 出口、ブラウザーの WebRTC、NTP の検査は利用できません。",
    ),
    "diagnosticsUnverified": MessageLookupByLibrary.simpleMessage("検出できず"),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("ダイヤラープロキシ"),
    "dialerProxyLoopStopped": m53,
    "dialog": MessageLookupByLibrary.simpleMessage("ダイアログ"),
    "direct": MessageLookupByLibrary.simpleMessage("ダイレクト"),
    "directNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "直接接続する通信のドメイン名を解決します。",
    ),
    "disableIcmpForwarding": MessageLookupByLibrary.simpleMessage(
      "ICMP 転送を無効化",
    ),
    "disableIcmpForwardingDesc": MessageLookupByLibrary.simpleMessage(
      "ICMP 転送を無効にすると TUN が ping に直接応答するため、ping に実際の遅延が表示されなくなります。",
    ),
    "disableKeepAlive": MessageLookupByLibrary.simpleMessage("TCP キープアライブを無効化"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("UDPを無効化"),
    "disabled": MessageLookupByLibrary.simpleMessage("無効"),
    "discardChanges": MessageLookupByLibrary.simpleMessage("変更を破棄しますか？"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("免責事項"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "本声明は本ソフトウェアの性質、リスク、責任を説明するものであり、GPL-3.0 に加わる追加条項ではなく、同ライセンスがあなたに与える実行、複製、改変、配布などのいかなる権利も制限しません。両者が異なる場合は GPL-3.0 が優先します。",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage(
      "オープンソースライセンスとの関係",
    ),
    "disclaimerAcknowledgeLabel": MessageLookupByLibrary.simpleMessage(
      "この声明を読み、理解しました",
    ),
    "disclaimerAcknowledgeTip": MessageLookupByLibrary.simpleMessage(
      "内容を理解したことを確認するため、以下の声明を読み、下のチェックボックスをオンにしてください：",
    ),
    "disclaimerAcknowledgeTitle": MessageLookupByLibrary.simpleMessage("声明の確認"),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "本声明は今後のバージョンで改訂されることがあり、各バージョンに付属する内容が適用されます。",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage("本声明の変更"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "天机云（以下「本ソフトウェア」）を使用する前に、本声明をよくお読みのうえ十分に理解してください。「同意する」をタップすると、以下の内容を読み理解したことになります。続行しない場合は「終了」をタップしてください。",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "適用法で認められる最大限の範囲において、開発者およびすべての貢献者は、本ソフトウェアの使用または使用不能に起因する直接的、間接的、偶発的、特別、懲罰的または結果的な損害（データの消失、機器の損傷、ネットワーク障害、業務の中断、逸失利益、およびそれに起因する法的紛争を含むがこれらに限らない）について、その可能性を知らされていた場合であっても、一切責任を負いません。",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage("責任の制限"),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは GPL-3.0 ライセンスのもとで公開されたオープンソースソフトウェアです。同ライセンスに従って実行、研究、改変、配布することができます。本ソフトウェアまたはその改変版を配布する場合は、同じく GPL-3.0 のもとでソースコードを提供し、元の著作権表示を保持する必要があります。\n\n本ソフトウェアに含まれるサードパーティコンポーネント（Clash.Meta コアを含む）は、それぞれのライセンスに従います。他者が改変または配布したバージョンにより生じた問題について、原作者は責任を負いません。",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "オープンソースライセンス",
    ),
    "disclaimerNoServiceStatement": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェア自体は、プロキシサーバー、ノード、サブスクリプション、ネットワーク接続サービスを一切提供しておらず、それらのサービス提供者と提携、代理、保証の関係はありません。",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは、サブスクリプション URL、ノード情報、設定内容、閲覧したウェブサイト、接続記録、通信内容、ログを収集またはアップロードしません。これらのデータは端末内にのみ保存され、開発者がアクセスすることはできません。\n\n本ソフトウェアが外部ネットワークにアクセスするのは、プロファイル更新時に指定されたサブスクリプション URL へアクセスする場合や、アップデート確認時に GitHub へアクセスする場合など、該当する機能を使用したときのみです。\n\n本ソフトウェアには、どのプラットフォームでも統計やクラッシュレポートのサービスは一切組み込まれていません。",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "データ収集とプライバシー",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "お住まいの国または地域で本ソフトウェアの使用が合法であることはご自身で確認する必要があり、本ソフトウェアを使用したすべての行為とその結果について、ご自身が単独で法的責任を負います。\n\nインポートするサブスクリプション、ノード、設定はご自身の判断で選択したものです。その出所の適法性、内容の安全性、サービスの安定性については、利用者と各提供者の間で解決してください。",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "利用者の責任",
    ),
    "disclaimerRestateHint": MessageLookupByLibrary.simpleMessage("上記の声明を入力"),
    "disclaimerRestateMismatch": MessageLookupByLibrary.simpleMessage(
      "声明の内容と一致しません",
    ),
    "disclaimerRestateTip": MessageLookupByLibrary.simpleMessage(
      "内容を理解したことを確認するため、以下の声明を下の入力欄に正確に入力してください：",
    ),
    "disclaimerRestateTitle": MessageLookupByLibrary.simpleMessage("声明の復唱"),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは Clash.Meta（mihomo）コアをベースとしたオープンソースのネットワークプロキシクライアントであり、設定管理、ルールによる振り分け、トラフィック転送などのローカルツール機能のみを提供します。",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "ソフトウェアの性質",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンク、設定ファイル、ルールセット、スクリプト、外部リソース、外部リンクはすべて第三者が提供するものであり、開発者はその適法性、正確性、安全性、可用性を審査または保証することはできず、また行いません。\n\nサードパーティのコンテンツの使用に起因する情報漏えい、財産上の損失、アカウント停止その他の損失は、利用者と第三者の間で解決するものとし、開発者は一切責任を負いません。",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "サードパーティのコンテンツ",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "有料配布、抱き合わせ販売、商用サービスの一部としての利用など、本ソフトウェアを用いて誰かが行う商業活動は本ソフトウェアの開発者とは無関係であり、開発者はそれを推奨、支援、保証しません。\n\nお住まいの国または地域の法令はご自身で遵守してください。本ソフトウェアの違法な使用により生じた結果はご自身の責任となります。",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage("使用について"),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "本ソフトウェアは「現状のまま」かつ「提供可能な範囲で」提供され、商品性、特定目的への適合性、非侵害、継続的な可用性、エラーやセキュリティ上の脆弱性がないことの保証を含め、明示または黙示を問わずいかなる保証も伴いません。\n\n開発者は、本ソフトウェアが利用者の要件を満たすこと、また中断やエラーなく動作することを保証しません。",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage("無保証"),
    "disconnected": MessageLookupByLibrary.simpleMessage("切断済み"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "新しいバージョンが見つかりました",
    ),
    "dnsBlocked": MessageLookupByLibrary.simpleMessage("ブロック済み"),
    "dnsCacheCleared": MessageLookupByLibrary.simpleMessage("DNSキャッシュをクリアしました"),
    "dnsExit": MessageLookupByLibrary.simpleMessage("DNS 出口"),
    "dnsExitUnavailable": MessageLookupByLibrary.simpleMessage("検査結果なし"),
    "dnsHandling": MessageLookupByLibrary.simpleMessage("処理"),
    "dnsHijackDesc": MessageLookupByLibrary.simpleMessage(
      "追加しない場合、ポート 53 宛てのすべての DNS 問い合わせをハイジャックします（any:53）。",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNSハイジャック"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNSモード"),
    "dnsOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "ここで追加した項目は、すべての URL・ファイルプロファイルの DNS を上書きします。追加していない項目はプロファイル自身の設定のままです。カスタムプロファイルの DNS はその内容で設定します。",
    ),
    "dnsProxyRoute": MessageLookupByLibrary.simpleMessage("プロキシ経由"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNS クエリ"),
    "dnsResourcesDesktop": MessageLookupByLibrary.simpleMessage("DNS とリソース"),
    "dnsUpstream": MessageLookupByLibrary.simpleMessage("上流 DNS"),
    "docked": MessageLookupByLibrary.simpleMessage("固定"),
    "domain": MessageLookupByLibrary.simpleMessage("ドメイン"),
    "done": MessageLookupByLibrary.simpleMessage("完了"),
    "download": MessageLookupByLibrary.simpleMessage("ダウンロード"),
    "downloadBandwidth": MessageLookupByLibrary.simpleMessage("ダウンロード帯域幅"),
    "downloadingUpdate": MessageLookupByLibrary.simpleMessage("更新をダウンロード中"),
    "duration": MessageLookupByLibrary.simpleMessage("経過時間"),
    "edit": MessageLookupByLibrary.simpleMessage("編集"),
    "editDashboard": MessageLookupByLibrary.simpleMessage("ダッシュボードを編集"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage("グローバルルールを編集"),
    "editProxy": MessageLookupByLibrary.simpleMessage("プロキシを編集"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("プロキシグループを編集"),
    "editRule": MessageLookupByLibrary.simpleMessage("ルールを編集"),
    "editSsid": MessageLookupByLibrary.simpleMessage("SSIDを編集"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage("エディターを利用できません"),
    "elapsed": MessageLookupByLibrary.simpleMessage("所要時間"),
    "emptyFallback": MessageLookupByLibrary.simpleMessage("空グループのフォールバック"),
    "emptyTip": m54,
    "en": MessageLookupByLibrary.simpleMessage("英語"),
    "enabled": MessageLookupByLibrary.simpleMessage("有効"),
    "entries": MessageLookupByLibrary.simpleMessage(" 件"),
    "error": MessageLookupByLibrary.simpleMessage("エラー"),
    "errorDetails": MessageLookupByLibrary.simpleMessage("エラーの詳細"),
    "es": MessageLookupByLibrary.simpleMessage("スペイン語"),
    "eventAlerts": MessageLookupByLibrary.simpleMessage("イベント通知"),
    "exclude": MessageLookupByLibrary.simpleMessage("最近のタスクから隠す"),
    "excludeDstPort": MessageLookupByLibrary.simpleMessage("除外宛先ポート"),
    "excludeFilter": MessageLookupByLibrary.simpleMessage("除外フィルター"),
    "excludeInterface": MessageLookupByLibrary.simpleMessage("除外インターフェース"),
    "excludeSrcPort": MessageLookupByLibrary.simpleMessage("除外送信元ポート"),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("除外SSID"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "除外した SSID の Wi-Fi に接続すると、アプリの実行状態が自動的に切り替わります。",
    ),
    "excludeUid": MessageLookupByLibrary.simpleMessage("除外ユーザー ID"),
    "existsTip": m55,
    "exit": MessageLookupByLibrary.simpleMessage("終了"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage("全画面表示を終了"),
    "exitNodes": MessageLookupByLibrary.simpleMessage("出口ノード"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("期待するステータス"),
    "expireTime": MessageLookupByLibrary.simpleMessage("有効期限"),
    "expiredStatus": MessageLookupByLibrary.simpleMessage("期限切れ"),
    "exportCertificate": MessageLookupByLibrary.simpleMessage("証明書をエクスポート"),
    "exportFile": MessageLookupByLibrary.simpleMessage("ファイルをエクスポート"),
    "exportHar": MessageLookupByLibrary.simpleMessage("HAR をエクスポート"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("ログをエクスポート"),
    "exportShort": MessageLookupByLibrary.simpleMessage("エクスポート"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("エクスポートが完了しました"),
    "extend": MessageLookupByLibrary.simpleMessage("拡張"),
    "extendMode": MessageLookupByLibrary.simpleMessage("拡張モード"),
    "extendOverridesScripts": MessageLookupByLibrary.simpleMessage(
      "拡張の上書きとスクリプト",
    ),
    "extendScript": MessageLookupByLibrary.simpleMessage("拡張スクリプト"),
    "externalController": MessageLookupByLibrary.simpleMessage("外部コントローラー"),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "外部コントローラーを有効にすると、ポート 9090 でコアを制御できます。",
    ),
    "externalControllerSecret": MessageLookupByLibrary.simpleMessage(
      "外部コントローラーのシークレット",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("外部リンク"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("特大"),
    "fade": MessageLookupByLibrary.simpleMessage("フェード"),
    "failedCount": m56,
    "failedItem": m57,
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fake-IPフィルター"),
    "fakeipFilterDesc": MessageLookupByLibrary.simpleMessage(
      "これらのドメインには Fake-IP ではなく実際の IP を返します。whitelist モードでは、これらだけが Fake-IP を使います。",
    ),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage("Fake-IPフィルターモード"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fake-IP範囲"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage("Fake-IP範囲（IPv6）"),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("Fake-IP TTL"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "フォールバックフィルターが Nameserver の結果を汚染とみなしたときは、こちらの結果を使います。",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("フォールバックフィルター"),
    "fallbackFilterDomainDesc": MessageLookupByLibrary.simpleMessage(
      "これらのドメインは、直接 Fallback で解決します。",
    ),
    "fallbackFilterGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "これらの GeoSite カテゴリのドメインは、直接 Fallback で解決します。",
    ),
    "fallbackFilterIpcidrDesc": MessageLookupByLibrary.simpleMessage(
      "Nameserver がこれらの範囲の IP を返したときは、Fallback の結果を使います。",
    ),
    "file": MessageLookupByLibrary.simpleMessage("ファイル"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "ファイルが変更されています。変更を保存しますか？",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("フィルター"),
    "filters": MessageLookupByLibrary.simpleMessage("フィルター"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("プロセス検出"),
    "floating": MessageLookupByLibrary.simpleMessage("フローティング"),
    "followProfile": MessageLookupByLibrary.simpleMessage("プロファイルに従う"),
    "followSystem": MessageLookupByLibrary.simpleMessage("システムに従う"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("フォント"),
    "fontSize": MessageLookupByLibrary.simpleMessage("サイズ"),
    "forceDnsMapping": MessageLookupByLibrary.simpleMessage("DNSマッピングを強制"),
    "forceDnsMappingDesc": MessageLookupByLibrary.simpleMessage(
      "DNS マッピングを強制すると、DNS マッピングでドメインを得た接続もスニッフィングします。",
    ),
    "forceDomain": MessageLookupByLibrary.simpleMessage("強制するドメイン"),
    "forceDomainDesc": MessageLookupByLibrary.simpleMessage(
      "強制するドメインもスニッフィングします。ドメインを持つその他の接続は対象外です。",
    ),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "コアを強制再起動してもよろしいですか？",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("フランス語"),
    "general": MessageLookupByLibrary.simpleMessage("一般"),
    "generalOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "ここで追加した項目は、すべてのプロファイルの該当設定を上書きします。追加していない項目はプロファイル自身の設定のままで、プロファイルにない場合はコアの既定値を使います。",
    ),
    "generateCertificate": MessageLookupByLibrary.simpleMessage("証明書を生成"),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo"),
    "geoSkipped": m58,
    "geoUpdated": m59,
    "geodataLoader": MessageLookupByLibrary.simpleMessage("Geo低メモリモード"),
    "global": MessageLookupByLibrary.simpleMessage("グローバル"),
    "go": MessageLookupByLibrary.simpleMessage("開く"),
    "goDownload": MessageLookupByLibrary.simpleMessage("ダウンロードへ"),
    "goToConfigureAddedRules": MessageLookupByLibrary.simpleMessage(
      "追加ルール設定へ移動",
    ),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage("スクリプト設定へ移動"),
    "grid": MessageLookupByLibrary.simpleMessage("グリッド"),
    "groupBy": MessageLookupByLibrary.simpleMessage("グループ"),
    "groupCount": m60,
    "groupCountUnit": MessageLookupByLibrary.simpleMessage("個"),
    "groupTimeoutCount": m61,
    "hasCacheChange": MessageLookupByLibrary.simpleMessage("変更をキャッシュしますか？"),
    "hashByInUser": MessageLookupByLibrary.simpleMessage("インバウンドユーザーでハッシュ"),
    "headerRewrite": MessageLookupByLibrary.simpleMessage("ヘッダー書き換え"),
    "healthCheck": MessageLookupByLibrary.simpleMessage("ヘルスチェック"),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Helper サービスが利用できないため、TUN モードを有効にできません。天机云を再インストールしてください。",
    ),
    "hex": MessageLookupByLibrary.simpleMessage("16進数"),
    "hideFromList": MessageLookupByLibrary.simpleMessage("リストから隠す"),
    "hideIp": MessageLookupByLibrary.simpleMessage("IP を隠す"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("パスワードを隠す"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "タイムアウトしたプロキシを隠す",
    ),
    "hopInterval": MessageLookupByLibrary.simpleMessage("ホップ間隔"),
    "host": MessageLookupByLibrary.simpleMessage("ホスト"),
    "hostname": MessageLookupByLibrary.simpleMessage("ホスト名"),
    "hotkeyConflictWith": m62,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "グローバルホットキーはウィンドウが非表示でも有効です。アクションをタップしてキーの組み合わせを記録します。",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("ホットキー管理"),
    "hotkeyNeedsModifier": m63,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("未設定"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "登録できませんでした。他のアプリが使用している可能性があります",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("時間"),
    "hoursAgo": m64,
    "hoursAgoShort": m65,
    "http2": MessageLookupByLibrary.simpleMessage("HTTP/2"),
    "httpBodyNotKept": MessageLookupByLibrary.simpleMessage(
      "メモリ不足のため記録されていません。",
    ),
    "httpBodyProtobufGuess": MessageLookupByLibrary.simpleMessage(
      "スキーマなしで Protobuf として解析しました。フィールド番号のみで、型は推測です。",
    ),
    "httpBodyTruncated": MessageLookupByLibrary.simpleMessage(
      "このボディは先頭部分のみ記録されています。",
    ),
    "httpBodyUndecoded": m66,
    "httpCapture": MessageLookupByLibrary.simpleMessage("HTTP キャプチャ"),
    "httpCaptureDesc": MessageLookupByLibrary.simpleMessage(
      "ホスト名に記載したホストへのリクエストを記録し、接続の詳細で確認できます。記録はメモリ上にのみ保持されます。",
    ),
    "httpCaptureLimit": MessageLookupByLibrary.simpleMessage("最大記録数"),
    "httpCaptureLimitDesc": m67,
    "httpCaptureNoHosts": MessageLookupByLibrary.simpleMessage(
      "ホストが記載されていないため、何も記録されません。MITM ページの「ホスト名」または接続の詳細から追加してください。",
    ),
    "httpCaptureOff": MessageLookupByLibrary.simpleMessage("キャプチャはオフです"),
    "httpExportPrivate": MessageLookupByLibrary.simpleMessage(
      "リクエストには Cookie、トークン、パスワード、フォームの内容が含まれることがあります。共有する内容と相手を確認してください。",
    ),
    "httpExportPrivateTitle": MessageLookupByLibrary.simpleMessage(
      "プライベートな情報を含みます",
    ),
    "httpRequestCleared": MessageLookupByLibrary.simpleMessage(
      "このリクエストの記録は消去されました",
    ),
    "httpRequests": MessageLookupByLibrary.simpleMessage("HTTP リクエスト"),
    "httpRequestsMissing": MessageLookupByLibrary.simpleMessage(
      "キャプチャをオンにする前のリクエストや、消去済みのリクエストは表示されません。",
    ),
    "httpsDecryption": MessageLookupByLibrary.simpleMessage("HTTPS 復号"),
    "hue": MessageLookupByLibrary.simpleMessage("色相"),
    "icon": MessageLookupByLibrary.simpleMessage("アイコン"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("アイコン履歴"),
    "iconSets": MessageLookupByLibrary.simpleMessage("アイコンセット"),
    "iconSetsEmptyTip": MessageLookupByLibrary.simpleMessage(
      "アイコンセットはまだありません。「カスタムプロファイルのリソース → アイコンセット」で追加できます",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("アイコンスタイル"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("背景あり"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("非表示"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("背景なし"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("アイコンURL"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "電池の最適化を無視",
    ),
    "immediateUpdate": MessageLookupByLibrary.simpleMessage("今すぐ更新"),
    "import": MessageLookupByLibrary.simpleMessage("インポート"),
    "importConfigInvalid": MessageLookupByLibrary.simpleMessage(
      "このファイルはインポートできる設定ではありません",
    ),
    "importConfigReplaceTip": MessageLookupByLibrary.simpleMessage(
      "インポートすると、このプロファイルの現在のプロキシグループ、ルール、設定が置き換えられます",
    ),
    "importFile": MessageLookupByLibrary.simpleMessage("ファイルからインポート"),
    "importFromLink": MessageLookupByLibrary.simpleMessage("リンクからインポート"),
    "importSubscription": MessageLookupByLibrary.simpleMessage("サブスクリプションを追加"),
    "importUrl": MessageLookupByLibrary.simpleMessage("URLからインポート"),
    "inProgress": MessageLookupByLibrary.simpleMessage("進行中"),
    "inUse": MessageLookupByLibrary.simpleMessage("使用中"),
    "inbound": MessageLookupByLibrary.simpleMessage("インバウンド"),
    "includeInterface": MessageLookupByLibrary.simpleMessage("対象インターフェース"),
    "includeInterfaceDesc": MessageLookupByLibrary.simpleMessage(
      "対象インターフェースから入る通信だけが TUN を通り、除外インターフェースは無効になります。",
    ),
    "includeUid": MessageLookupByLibrary.simpleMessage("対象ユーザー ID"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("無期限"),
    "init": MessageLookupByLibrary.simpleMessage("初期化"),
    "initFailed": MessageLookupByLibrary.simpleMessage("起動に失敗しました"),
    "initFailedTip": MessageLookupByLibrary.simpleMessage(
      "天机云の起動中にエラーが発生したため、続行できません。詳細をコピーして問題を報告できます。繰り返し発生する場合は、データを消去すると起動できるようになることがあります。",
    ),
    "initiator": MessageLookupByLibrary.simpleMessage("発信元"),
    "initiatorShort": MessageLookupByLibrary.simpleMessage("発信元"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "プロキシグループ名を入力してください",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage("ルールの内容を入力してください"),
    "installCertificate": MessageLookupByLibrary.simpleMessage("システムにインストール"),
    "installCertificateSuccess": MessageLookupByLibrary.simpleMessage(
      "証明書をインストールしました",
    ),
    "installedAppsPermissionDeniedMessage":
        MessageLookupByLibrary.simpleMessage(
          "アプリ一覧の権限が拒否されたため、インストール済みアプリを取得できません。システム設定から手動で許可してください。",
        ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "このシステムでは、許可するまでインストール済みアプリの一覧が提供されません。許可すると、アプリごとのプロキシを設定できます。",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "アプリ一覧の権限が必要です",
    ),
    "installedFonts": MessageLookupByLibrary.simpleMessage("インストール済みのフォント"),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("スマート選択"),
    "intercept": MessageLookupByLibrary.simpleMessage("ブロック"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("インターフェース名"),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "アウトバウンドインターフェース",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("クリア"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("カスタム"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage("設定に従う"),
    "internet": MessageLookupByLibrary.simpleMessage("インターネット"),
    "interval": MessageLookupByLibrary.simpleMessage("間隔"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("イントラネットIP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage("無効なバックアップファイル"),
    "invalidCidrContent": MessageLookupByLibrary.simpleMessage(
      "192.168.0.0/16 のような CIDR 形式の IP 範囲を入力してください",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "DSCP マークは 63 を超えられません",
    ),
    "invalidHostContent": MessageLookupByLibrary.simpleMessage(
      "ドメインまたは IP アドレスを入力してください",
    ),
    "invalidIconSet": MessageLookupByLibrary.simpleMessage("有効なアイコンセットではありません"),
    "invalidLinkTip": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクまたはプロキシの共有リンクではありません",
    ),
    "invalidListenContent": MessageLookupByLibrary.simpleMessage(
      "0.0.0.0:1053 のようなアドレスとポートを入力してください",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "tcp または udp のみ対応しています",
    ),
    "invalidOfCount": m68,
    "invalidPolicy": m69,
    "invalidPortRangeContent": MessageLookupByLibrary.simpleMessage(
      "443 や 8000-9000 のようなポートまたは範囲を入力してください",
    ),
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "このQRコードにはプロファイルのリンクが含まれていません",
    ),
    "invalidProxy": m70,
    "invalidProxyProvider": m71,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "80 や 8000-9000 のような数値または範囲を / 区切りで入力してください",
    ),
    "invalidRuleSet": m72,
    "invalidSubRule": m73,
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP アドレス"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("不正利用の履歴"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("プロキシ"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("検出"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("組織"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "IP タイプを判定できませんでした",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("良好"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("レベル"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("普通"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("再確認"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("リスクあり"),
    "ipQualityShort": MessageLookupByLibrary.simpleMessage("品質"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("採用したソース"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("各ソース"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "アウトバウンド IP が不一致",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("判定不可"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage("レート制限"),
    "ipType": MessageLookupByLibrary.simpleMessage("タイプ"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("ビジネス"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("データセンター"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("モバイル回線"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("住宅"),
    "ipTypeUnknown": MessageLookupByLibrary.simpleMessage("タイプ不明"),
    "ipVersion": MessageLookupByLibrary.simpleMessage("IP バージョン"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "IPv6 トラフィックは IPv6 が有効なときだけ受信します。",
    ),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("IPv6タイムアウト（ms）"),
    "itemsCount": m74,
    "ja": MessageLookupByLibrary.simpleMessage("日本語"),
    "justNow": MessageLookupByLibrary.simpleMessage("たった今"),
    "keepAliveIdle": MessageLookupByLibrary.simpleMessage("TCP キープアライブ待機時間"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "TCPキープアライブ間隔",
    ),
    "key": MessageLookupByLibrary.simpleMessage("キー"),
    "ko": MessageLookupByLibrary.simpleMessage("韓国語"),
    "label": MessageLookupByLibrary.simpleMessage("ラベル"),
    "language": MessageLookupByLibrary.simpleMessage("言語"),
    "large": MessageLookupByLibrary.simpleMessage("大"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("最終更新"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage("起動が完了しませんでした"),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "前回、アプリは起動中に予期せず終了しました。今回の自動セットアップはスキップしました。手動で起動して再試行できます。",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("レイアウト"),
    "light": MessageLookupByLibrary.simpleMessage("ライト"),
    "lineIssueTip": m75,
    "lineRate": MessageLookupByLibrary.simpleMessage("倍率"),
    "lineWrap": MessageLookupByLibrary.simpleMessage("折り返し"),
    "link": MessageLookupByLibrary.simpleMessage("リンク"),
    "liquidGlass": MessageLookupByLibrary.simpleMessage("リキッドグラス"),
    "list": MessageLookupByLibrary.simpleMessage("リスト"),
    "listen": MessageLookupByLibrary.simpleMessage("リッスン"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage("リッスンのルーティングマーク"),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage(
      "リッスンのルーティングマークは Linux でのみ有効です。",
    ),
    "liveConnections": MessageLookupByLibrary.simpleMessage("ライブ接続"),
    "loading": MessageLookupByLibrary.simpleMessage("読み込み中…"),
    "local": MessageLookupByLibrary.simpleMessage("ローカル"),
    "localFile": MessageLookupByLibrary.simpleMessage("ローカルファイル"),
    "localImage": MessageLookupByLibrary.simpleMessage("ローカル画像"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "ローカルネットワークの権限が拒否されたため gvisor スタックを使用します。LAN にはアクセスできません。",
    ),
    "localProxies": MessageLookupByLibrary.simpleMessage("ローカルプロキシ"),
    "locationPermission": MessageLookupByLibrary.simpleMessage("位置情報の権限"),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "位置情報の権限が拒否されたため、現在の Wi-Fi 名を取得できません。システム設定で位置情報の権限を手動で有効にしてください。",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "システムの要件により、Wi-Fi 名の取得には位置情報の権限が必要です。Android では「常に許可」を選択してください。そうしないと、アプリがバックグラウンドにあるときに Wi-Fi 名を取得できません。",
    ),
    "locationPermissionGuide": m76,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "位置情報の権限が必要です",
    ),
    "log": MessageLookupByLibrary.simpleMessage("ログ"),
    "logFilterError": MessageLookupByLibrary.simpleMessage("エラー"),
    "logFilterInfo": MessageLookupByLibrary.simpleMessage("情報"),
    "logFilterWarning": MessageLookupByLibrary.simpleMessage("警告"),
    "logLevel": MessageLookupByLibrary.simpleMessage("ログレベル"),
    "logcat": MessageLookupByLibrary.simpleMessage("ログキャプチャ"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "ログキャプチャを無効にすると、ログの入り口が非表示になります。",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("ログ"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage("ログと診断"),
    "logsRunning": MessageLookupByLibrary.simpleMessage("実行ログ"),
    "logsTest": MessageLookupByLibrary.simpleMessage("ログテスト"),
    "loopback": MessageLookupByLibrary.simpleMessage("UWP ループバック解除"),
    "loose": MessageLookupByLibrary.simpleMessage("ゆったり"),
    "mainlandDirect": MessageLookupByLibrary.simpleMessage("中国本土直結"),
    "mapLocal": MessageLookupByLibrary.simpleMessage("ローカルマップ"),
    "matchCase": MessageLookupByLibrary.simpleMessage("大文字と小文字を区別"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("送信元IPにマッチ"),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "matchedRules": MessageLookupByLibrary.simpleMessage("一致したルール"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("最大失敗回数"),
    "maxLengthTip": m77,
    "maximize": MessageLookupByLibrary.simpleMessage("最大化"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage("常駐メモリ"),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("アプリと共有"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("未使用のヒープ"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("使用中のヒープ"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "コアは実行されていません",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage("ランタイムのオーバーヘッド"),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("ゴルーチンスタック"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスの常駐メモリからの推定値で、システムの表示とは異なる場合があります。",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "コアはアプリと同じプロセスで動作します。コア分はランタイム統計から推定し、残りはアプリと共有メモリとして計上します。",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("メモリ情報"),
    "memoryInfoDesc": MessageLookupByLibrary.simpleMessage("アプリとコアが使用するメモリ"),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("メモリを解放しました"),
    "memoryReleasedSize": m78,
    "messageTest": MessageLookupByLibrary.simpleMessage("メッセージテスト"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("これはメッセージです。"),
    "method": MessageLookupByLibrary.simpleMessage("メソッド"),
    "minimize": MessageLookupByLibrary.simpleMessage("最小化"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("終了時に最小化"),
    "minutes": MessageLookupByLibrary.simpleMessage("分"),
    "minutesAgo": m79,
    "minutesAgoShort": m80,
    "mitm": MessageLookupByLibrary.simpleMessage("MITM"),
    "mitmAddLocalFile": MessageLookupByLibrary.simpleMessage("ローカルファイルを追加"),
    "mitmAddMapLocalRule": MessageLookupByLibrary.simpleMessage(
      "ローカルマップのルールを追加",
    ),
    "mitmAddRejectRule": MessageLookupByLibrary.simpleMessage("拒否ルールを追加"),
    "mitmAttachments": MessageLookupByLibrary.simpleMessage("添付ファイル"),
    "mitmAttachmentsDesc": MessageLookupByLibrary.simpleMessage(
      "行は script-path=a.js のようにファイル名で添付ファイルを参照します。",
    ),
    "mitmCertificateAndroidReadyTip": MessageLookupByLibrary.simpleMessage(
      "復号されるのはユーザー証明書を信頼するアプリ（主にブラウザ）だけです。",
    ),
    "mitmCertificateExportTip": MessageLookupByLibrary.simpleMessage(
      "エクスポートして、復号したいデバイスで信頼してください。",
    ),
    "mitmCertificateLinuxTip": MessageLookupByLibrary.simpleMessage(
      "Flatpak 版ブラウザには、エクスポートした証明書を手動でインポートする必要があります。",
    ),
    "mitmCertificateSavedTip": m81,
    "mitmCertutilMissing": m82,
    "mitmClientRefusedCertificate": MessageLookupByLibrary.simpleMessage(
      "クライアントが証明書を拒否しました。証明書をインストールするか、アプリが証明書を固定している場合はこのホストを除外してください。",
    ),
    "mitmDecryptHost": MessageLookupByLibrary.simpleMessage("このホストを復号"),
    "mitmDecryptHostTip": m83,
    "mitmEnableTip": MessageLookupByLibrary.simpleMessage(
      "オンにすると、天机云は復号するホストに送られるすべての内容（Cookie やパスワードを含む）を読み取れます。書き換えが必要なホストに限ってオンにしてください。",
    ),
    "mitmExcludeHost": MessageLookupByLibrary.simpleMessage("復号から除外"),
    "mitmExcludeHostTip": m84,
    "mitmFileTooLarge": m85,
    "mitmHostnameDesc": MessageLookupByLibrary.simpleMessage(
      "先頭の - は除外を表し、最初に一致した項目が優先されます。",
    ),
    "mitmIgnoredLines": MessageLookupByLibrary.simpleMessage("無視された行"),
    "mitmInstallSystemCaTip": MessageLookupByLibrary.simpleMessage(
      "root が見つかったため、証明書は Magisk、KernelSU または APatch のモジュール「TianjiCloud MITM CA」としてシステムの信頼できる証明書に追加されます。以後この端末のすべてのアプリが信頼し、秘密鍵を持つ人はこの端末の HTTPS 通信を復号できます。元に戻すには証明書を再生成するか、root マネージャーでモジュールを削除して再起動してください。root が拒否された場合はユーザー証明書としてインストールします。",
    ),
    "mitmInstallUserCaTip": MessageLookupByLibrary.simpleMessage(
      "root が見つからないため、ユーザー証明書としてのみインストールできます。復号されるのはユーザー証明書を信頼するアプリ（主にブラウザ）だけで、他のアプリは記載したホストへの接続に失敗するため、それらのホストは記載しないでください。Android 11 以降はシステム設定で手動でインストールを完了します。",
    ),
    "mitmMissingStores": m86,
    "mitmModule": MessageLookupByLibrary.simpleMessage("モジュール"),
    "mitmModuleInvalid": MessageLookupByLibrary.simpleMessage(
      "Surge モジュール、Loon プラグイン、Quantumult X スニペット、Stash オーバーライドのいずれでもありません",
    ),
    "mitmModuleRulesDesc": MessageLookupByLibrary.simpleMessage(
      "ルーティングルールはプロファイル自身のルールより前に入ります。",
    ),
    "mitmModuleScriptsChanged": m87,
    "mitmModuleSystemTip": m88,
    "mitmModules": MessageLookupByLibrary.simpleMessage("モジュール"),
    "mitmNewModule": MessageLookupByLibrary.simpleMessage("モジュールを新規作成"),
    "mitmOldCertificateLeftTip": m89,
    "mitmOldSystemCertificateLeftTip": m90,
    "mitmRemoveOldCertificateTip": m91,
    "mitmRootPendingReboot": MessageLookupByLibrary.simpleMessage(
      "証明書は端末の再起動後に有効になります。",
    ),
    "mitmRootUntilReboot": MessageLookupByLibrary.simpleMessage(
      "証明書を保持する Magisk、KernelSU、APatch が見つかりません。端末の再起動後にもう一度インストールしてください。",
    ),
    "mitmRoutingRules": MessageLookupByLibrary.simpleMessage("ルーティングルール"),
    "mitmRuleCopiedForStash": MessageLookupByLibrary.simpleMessage(
      "このモジュールは Stash のオーバーライドのため、ルールをコピーしました。手動で追加してください。",
    ),
    "mitmRunScript": MessageLookupByLibrary.simpleMessage("今すぐ実行"),
    "mitmScriptNoOutput": MessageLookupByLibrary.simpleMessage(
      "スクリプトは出力なしで終了しました",
    ),
    "mitmScriptRisk": MessageLookupByLibrary.simpleMessage(
      "スクリプトは一致したホストの通信を読み取り、変更できます。Cookie やトークンも含まれ、独自にリクエストを送ることもできます。提供元を信頼できる場合にのみオンにしてください。",
    ),
    "mitmScriptRiskTitle": MessageLookupByLibrary.simpleMessage(
      "このモジュールのスクリプトを実行しますか？",
    ),
    "mitmSkipConditional": MessageLookupByLibrary.simpleMessage(
      "条件付きの書き換えには対応していません",
    ),
    "mitmSkipDisabled": MessageLookupByLibrary.simpleMessage("引数でオフになっています"),
    "mitmSkipEvent": MessageLookupByLibrary.simpleMessage("このイベントには対応していません"),
    "mitmSkipJq": MessageLookupByLibrary.simpleMessage("jq による書き換えには対応していません"),
    "mitmSkipJsonBody": MessageLookupByLibrary.simpleMessage(
      "JSON 本文の書き換えには対応していません",
    ),
    "mitmSkipNotDownloaded": MessageLookupByLibrary.simpleMessage(
      "ファイルがまだダウンロードされていません",
    ),
    "mitmSkipPolicy": MessageLookupByLibrary.simpleMessage(
      "DIRECT と REJECT のポリシーのみに対応しています",
    ),
    "mitmSkipRawHeader": MessageLookupByLibrary.simpleMessage(
      "ヘッダー全体を 1 つのテキストとして書き換えることには対応していません",
    ),
    "mitmSkipRelativeData": MessageLookupByLibrary.simpleMessage(
      "この行が指すファイルは添付されていません。URL を使うか、添付してください",
    ),
    "mitmSkipRule": MessageLookupByLibrary.simpleMessage("この種類のルールには対応していません"),
    "mitmSkipScriptType": MessageLookupByLibrary.simpleMessage(
      "この種類のスクリプトには対応していません",
    ),
    "mitmSkipSection": m92,
    "mitmSkipSetting": MessageLookupByLibrary.simpleMessage("この設定には対応していません"),
    "mitmSkipUnreadable": MessageLookupByLibrary.simpleMessage("この行を読み取れません"),
    "mitmSystemStoreFailed": MessageLookupByLibrary.simpleMessage(
      "証明書をシステムの信頼されたルートに追加できませんでした",
    ),
    "mitmTrustChecking": MessageLookupByLibrary.simpleMessage("確認中…"),
    "mitmTrustNotInstalled": MessageLookupByLibrary.simpleMessage("未インストール"),
    "mitmTrustReady": MessageLookupByLibrary.simpleMessage("信頼済み"),
    "mitmTrustUntrusted": MessageLookupByLibrary.simpleMessage("完全には信頼されていません"),
    "mixedPort": MessageLookupByLibrary.simpleMessage("Mixedポート"),
    "mobilePlanValidity": MessageLookupByLibrary.simpleMessage("プラン有効期限"),
    "mobileRemainingTraffic": MessageLookupByLibrary.simpleMessage("今月の残り通信量"),
    "mode": MessageLookupByLibrary.simpleMessage("モード"),
    "monochromeIcon": MessageLookupByLibrary.simpleMessage("モノクロームアイコン"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("モノクローム"),
    "monthsAgo": m93,
    "monthsAgoShort": m94,
    "more": MessageLookupByLibrary.simpleMessage("その他"),
    "name": MessageLookupByLibrary.simpleMessage("名前"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "既定で使う DNS サーバーです。例：223.5.5.5、tls://1.1.1.1、https://dns.google/dns-query",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "一致したドメインは、Nameserver と Fallback より優先してここで指定した DNS サーバーを使います。",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("ボトムバー"),
    "network": MessageLookupByLibrary.simpleMessage("ネットワーク"),
    "networkAccessDeniedError": m95,
    "networkBadResponseError": m96,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "リクエストはキャンセルされました",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "サーバーに接続できませんでした。ネットワーク接続またはプロキシ設定を確認してください",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "サーバーのアドレスを解決できませんでした。URL が正しいこと、DNS が使えることを確認してください",
    ),
    "networkName": MessageLookupByLibrary.simpleMessage("ネットワーク名"),
    "networkNotFoundError": m97,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "リクエストが多すぎます（HTTP 429）。しばらく待ってから再試行してください",
    ),
    "networkRequestFailed": m98,
    "networkSecret": MessageLookupByLibrary.simpleMessage("ネットワークシークレット"),
    "networkServerError": m99,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("ネットワーク速度"),
    "networkTakeover": MessageLookupByLibrary.simpleMessage("トラフィックの引き継ぎ"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "リクエストがタイムアウトしました。ネットワークまたはプロキシを確認してから再試行してください",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "安全な接続に失敗しました。サーバー証明書が無効か、接続が傍受されている可能性があります",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("ネットワーク種別"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("次の一致"),
    "no": MessageLookupByLibrary.simpleMessage("いいえ"),
    "noData": MessageLookupByLibrary.simpleMessage("データがありません"),
    "noInfo": MessageLookupByLibrary.simpleMessage("情報がありません"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage("今後表示しない"),
    "noNetwork": MessageLookupByLibrary.simpleMessage("ネットワークがありません"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("ネットワーク不使用アプリ"),
    "noResolve": MessageLookupByLibrary.simpleMessage("IPを解決しない"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage("ホスト名を解決しない"),
    "noSearchResults": MessageLookupByLibrary.simpleMessage("一致する結果はありません"),
    "nodes": MessageLookupByLibrary.simpleMessage("ノード"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "この外部リソースはテキストファイルではありません",
    ),
    "none": MessageLookupByLibrary.simpleMessage("なし"),
    "notRunning": MessageLookupByLibrary.simpleMessage("停止中"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "現在のプロキシグループは選択できません",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage("同期間隔（分）"),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルを追加して始めましょう",
    ),
    "nullTip": m100,
    "numberRangeTip": m101,
    "numberTip": m102,
    "obfs": MessageLookupByLibrary.simpleMessage("難読化"),
    "obfsHost": MessageLookupByLibrary.simpleMessage("難読化ホスト"),
    "obfsMode": MessageLookupByLibrary.simpleMessage("難読化モード"),
    "obfsParam": MessageLookupByLibrary.simpleMessage("難読化パラメータ"),
    "obfsPassword": MessageLookupByLibrary.simpleMessage("難読化パスワード"),
    "onDemand": MessageLookupByLibrary.simpleMessage("オンデマンド"),
    "onboardingCheckingInternet": MessageLookupByLibrary.simpleMessage(
      "インターネットアクセスを確認しています…",
    ),
    "onboardingClipboardEmpty": MessageLookupByLibrary.simpleMessage(
      "クリップボードに内容がありません",
    ),
    "onboardingConfirmNote": MessageLookupByLibrary.simpleMessage(
      "上のサブスクリプションリンク全体を確認してからインポートしてください。",
    ),
    "onboardingConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Tianji Cloud のサブスクリプション",
    ),
    "onboardingConnect": MessageLookupByLibrary.simpleMessage("接続"),
    "onboardingConnectFailed": MessageLookupByLibrary.simpleMessage(
      "接続できませんでした。後でもう一度お試しください。",
    ),
    "onboardingConnected": MessageLookupByLibrary.simpleMessage("接続済み"),
    "onboardingConnectedNoInternet": MessageLookupByLibrary.simpleMessage(
      "接続済みですが、インターネットにアクセスできません",
    ),
    "onboardingConnecting": MessageLookupByLibrary.simpleMessage("接続しています…"),
    "onboardingConnectingDescription": MessageLookupByLibrary.simpleMessage(
      "接続後、実際に一度インターネットへアクセスして確認します。",
    ),
    "onboardingContinue": MessageLookupByLibrary.simpleMessage("続ける"),
    "onboardingDescription": MessageLookupByLibrary.simpleMessage(
      "パネルのサブスクリプションリンクを貼り付けるかスキャンして、数ステップで接続できます。",
    ),
    "onboardingExit": MessageLookupByLibrary.simpleMessage("出口"),
    "onboardingExpireDate": MessageLookupByLibrary.simpleMessage("有効期限"),
    "onboardingFailureEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "プランの期限が切れているか、今月の通信量を使い切った可能性があります。更新または通信量のリセット後、「再試行」を押してください。",
    ),
    "onboardingFailureEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "このサブスクリプションに利用可能なノードがありません",
    ),
    "onboardingFailureExpiredDescription": MessageLookupByLibrary.simpleMessage(
      "パネルでサブスクリプションをリセットした可能性があります。ユーザーパネルからサブスクリプションアドレスをコピーし直して、ここに貼り付けてください。",
    ),
    "onboardingFailureExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクの有効期限が切れています",
    ),
    "onboardingFailureNotSubscriptionDescription":
        MessageLookupByLibrary.simpleMessage(
          "ユーザーパネルで「サブスクリプションアドレスをコピー」を押し、ここに貼り付けてください。",
        ),
    "onboardingFailureNotSubscriptionTitle":
        MessageLookupByLibrary.simpleMessage("これはサブスクリプションリンクではありません"),
    "onboardingFailureUnknownDescription": MessageLookupByLibrary.simpleMessage(
      "ネットワークを確認して再試行してください。",
    ),
    "onboardingFailureUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "インポートに失敗しました",
    ),
    "onboardingFailureUnreachableDescription":
        MessageLookupByLibrary.simpleMessage(
          "現在のネットワークがこのドメインを制限している可能性があります。ステータスページに予備アドレスがあります。後でもう一度お試しください。",
        ),
    "onboardingFailureUnreachableTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションアドレスに接続できません",
    ),
    "onboardingImported": m103,
    "onboardingImporting": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションを取得しています…",
    ),
    "onboardingImportingDescription": MessageLookupByLibrary.simpleMessage(
      "ノード一覧とプラン情報を読み込んでいます",
    ),
    "onboardingInternetVerified": MessageLookupByLibrary.simpleMessage(
      "インターネットアクセス · 確認済み",
    ),
    "onboardingNoSubscription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションのアドレスがまだありませんか？ユーザーパネルを開いてコピー ›",
    ),
    "onboardingNodeUnavailable": MessageLookupByLibrary.simpleMessage(
      "現在のノードが一時的に利用できない可能性があります。ノードを切り替えると解決することがほとんどです。",
    ),
    "onboardingNotNow": MessageLookupByLibrary.simpleMessage("今はしない"),
    "onboardingOpenPanel": MessageLookupByLibrary.simpleMessage("ユーザーパネルを開く"),
    "onboardingPasteAgain": MessageLookupByLibrary.simpleMessage("もう一度貼り付ける"),
    "onboardingPasteFromClipboard": MessageLookupByLibrary.simpleMessage(
      "クリップボードからサブスクリプションリンクを貼り付け",
    ),
    "onboardingPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "クリップボードを読み取るのはボタンを押したときだけです。サブスクリプションリンクはこの端末にのみ保存されます。",
    ),
    "onboardingRemainingTraffic": MessageLookupByLibrary.simpleMessage("残り通信量"),
    "onboardingScanQr": MessageLookupByLibrary.simpleMessage(
      "パネルの QR コードをスキャン",
    ),
    "onboardingSwitchNode": MessageLookupByLibrary.simpleMessage("ノードを切り替える"),
    "onboardingTitle": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションをインポートして開始",
    ),
    "onboardingViewStatus": MessageLookupByLibrary.simpleMessage("予備アドレスを見る"),
    "onboardingVpnDescription": MessageLookupByLibrary.simpleMessage(
      "次に、Tianji Cloud が VPN 接続を作成してよいかシステムが確認します。「OK」を押してください。許可が必要なのは今回だけです。",
    ),
    "onboardingVpnTitle": MessageLookupByLibrary.simpleMessage("システムの許可が必要です"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "プロキシトラフィックのみ集計",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage("設定を開く"),
    "optional": MessageLookupByLibrary.simpleMessage("任意"),
    "options": MessageLookupByLibrary.simpleMessage("オプション"),
    "originalUrl": MessageLookupByLibrary.simpleMessage("元の URL"),
    "other": MessageLookupByLibrary.simpleMessage("その他"),
    "otherContributors": MessageLookupByLibrary.simpleMessage("その他の貢献者"),
    "otherProfilesTitle": MessageLookupByLibrary.simpleMessage("その他の設定"),
    "outbound": MessageLookupByLibrary.simpleMessage("アウトバウンド"),
    "outboundExit": MessageLookupByLibrary.simpleMessage("出口"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("アウトバウンド IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("アウトバウンドモード"),
    "outboundModeDescription": MessageLookupByLibrary.simpleMessage(
      "通常は「ルール」のままにしてください。グローバルでは中国本土の通信もプロキシ経由になり、直接接続ではすべての回線が使えなくなります。",
    ),
    "outboundModeDirectWarning": MessageLookupByLibrary.simpleMessage(
      "直接接続モードが有効です",
    ),
    "outboundModeGlobalWarning": MessageLookupByLibrary.simpleMessage(
      "グローバルモードが有効です",
    ),
    "outboundModeRestoreRule": MessageLookupByLibrary.simpleMessage("ルールに戻す"),
    "overrideDestination": MessageLookupByLibrary.simpleMessage("宛先を上書き"),
    "overrideEntries": MessageLookupByLibrary.simpleMessage("上書き項目"),
    "overridesLabel": MessageLookupByLibrary.simpleMessage("オーバーライド"),
    "overview": MessageLookupByLibrary.simpleMessage("概要"),
    "parsePureIp": MessageLookupByLibrary.simpleMessage("純粋なIPを解析"),
    "password": MessageLookupByLibrary.simpleMessage("パスワード"),
    "paste": MessageLookupByLibrary.simpleMessage("貼り付け"),
    "pasteFromClipboardImport": MessageLookupByLibrary.simpleMessage(
      "クリップボードから追加",
    ),
    "peers": MessageLookupByLibrary.simpleMessage("ピア"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("アルバムから選択"),
    "pinWindow": MessageLookupByLibrary.simpleMessage("最前面に固定"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage("WebDAVを連携してください"),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "スクリプト名を入力してください",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "有効なQRコードをアップロードしてください",
    ),
    "plugin": MessageLookupByLibrary.simpleMessage("プラグイン"),
    "pluginCipher": MessageLookupByLibrary.simpleMessage("プラグイン暗号方式"),
    "pluginHost": MessageLookupByLibrary.simpleMessage("プラグインホスト"),
    "pluginMode": MessageLookupByLibrary.simpleMessage("プラグインモード"),
    "pluginPassword": MessageLookupByLibrary.simpleMessage("プラグインパスワード"),
    "pluginPath": MessageLookupByLibrary.simpleMessage("プラグインパス"),
    "pluginUsername": MessageLookupByLibrary.simpleMessage("プラグインユーザー名"),
    "port": MessageLookupByLibrary.simpleMessage("ポート"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage("別のポートを入力してください"),
    "portHopping": MessageLookupByLibrary.simpleMessage("ポートホッピング"),
    "portTip": m104,
    "portValue": m105,
    "ports": MessageLookupByLibrary.simpleMessage("ポート"),
    "preSharedKey": MessageLookupByLibrary.simpleMessage("事前共有鍵"),
    "preferred": MessageLookupByLibrary.simpleMessage("優先"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("前提条件"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage("キーの組み合わせを押してください"),
    "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
    "previewReadOnly": MessageLookupByLibrary.simpleMessage("読み取り専用"),
    "previousMatch": MessageLookupByLibrary.simpleMessage("前の一致"),
    "privateKey": MessageLookupByLibrary.simpleMessage("秘密鍵"),
    "privateKeyPassphrase": MessageLookupByLibrary.simpleMessage("秘密鍵のパスフレーズ"),
    "process": MessageLookupByLibrary.simpleMessage("プロセス"),
    "profile": MessageLookupByLibrary.simpleMessage("プロファイル"),
    "profileAddCustomSourceDesc": MessageLookupByLibrary.simpleMessage(
      "ローカルのプロキシ・グループ・ルールを作成",
    ),
    "profileAddFileSourceDesc": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "profileAddLinkSourceDesc": MessageLookupByLibrary.simpleMessage(
      "ユーザーパネルからリンクをコピー",
    ),
    "profileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "インポート前に検証します。解析に失敗しても現在のプロファイルは置き換えません。",
    ),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("有効な間隔を入力してください"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("自動更新間隔を入力してください"),
    "profileDaysLeft": m106,
    "profileExpiresIn": m107,
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "プロファイルが変更されています。自動更新を無効にしますか？",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイル名を入力してください",
    ),
    "profilePreviewTitle": MessageLookupByLibrary.simpleMessage("設定プレビュー"),
    "profileSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "このプロファイルにのみ適用されます。追加していない項目はデフォルト値を使用します。",
    ),
    "profileSwitchNote": MessageLookupByLibrary.simpleMessage(
      "切り替えはすぐに反映されます。解析に失敗した場合は現在の設定を維持します。",
    ),
    "profileTunSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "このプロファイルにのみ適用され、ネットワーク設定の TUN 上書き項目より優先されます。",
    ),
    "profileUpdatedAt": m108,
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "有効なプロファイルURLを入力してください",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "プロファイルのURLを入力してください",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("プロファイル"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("プロファイルの並べ替え"),
    "project": MessageLookupByLibrary.simpleMessage("プロジェクト"),
    "protocol": MessageLookupByLibrary.simpleMessage("プロトコル"),
    "protocolParam": MessageLookupByLibrary.simpleMessage("プロトコルパラメータ"),
    "protocolVersion": MessageLookupByLibrary.simpleMessage("プロトコルバージョン"),
    "providerCount": m109,
    "providerInUse": m110,
    "providerUrlTip": MessageLookupByLibrary.simpleMessage("リモートリソースのみ対応しています"),
    "providers": MessageLookupByLibrary.simpleMessage("外部リソース"),
    "proxies": MessageLookupByLibrary.simpleMessage("プロキシ"),
    "proxiesCount": m111,
    "proxiesProfileLabel": m112,
    "proxiesRemovedTip": m113,
    "proxiesReplacedTip": m114,
    "proxyChains": MessageLookupByLibrary.simpleMessage("プロキシチェーン"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("プロキシグループ"),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage("プロキシグループが空です"),
    "proxyGroupInUse": m115,
    "proxyGroupsAfterStart": MessageLookupByLibrary.simpleMessage(
      "起動するとここにグループが表示されます",
    ),
    "proxyGroupsCount": m116,
    "proxyProviders": MessageLookupByLibrary.simpleMessage("プロキシプロバイダー"),
    "proxyServerNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "プロキシサーバーのドメイン名の解決にのみ使います。",
    ),
    "proxyServerNameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "一致したプロキシサーバーのドメイン名は、Proxy Server Nameserver より優先してここで指定した DNS サーバーを使います。",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("プロキシタイプ"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("キャッシュを整理"),
    "publicKey": MessageLookupByLibrary.simpleMessage("公開鍵"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("ピュアブラック"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("ピュアブラックモード"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QRコード"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "QRコードをスキャンしてプロファイルを取得します",
    ),
    "qrcodeTooLongTip": MessageLookupByLibrary.simpleMessage(
      "このリンクは長すぎて QR コードにできません。「リンクをコピー」を使ってください。",
    ),
    "quickActions": MessageLookupByLibrary.simpleMessage("クイック操作"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("クイック編集"),
    "quickLines": MessageLookupByLibrary.simpleMessage("よく使う回線"),
    "recentDnsQueries": MessageLookupByLibrary.simpleMessage("最近の DNS クエリ"),
    "recentRequests": MessageLookupByLibrary.simpleMessage("最近のリクエスト"),
    "recommendedIcons": MessageLookupByLibrary.simpleMessage("おすすめ"),
    "recordType": MessageLookupByLibrary.simpleMessage("レコードタイプ"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redirポート"),
    "redo": MessageLookupByLibrary.simpleMessage("やり直す"),
    "regenerateCertificate": MessageLookupByLibrary.simpleMessage("証明書を再生成"),
    "regenerateCertificateTip": MessageLookupByLibrary.simpleMessage(
      "新しい証明書が現在の証明書を置き換えます。天机云は可能な場合、現在の証明書をこのデバイスの信頼されたルートから削除します。現在の証明書を信頼している他のデバイスには、新しい証明書をインストールする必要があります。",
    ),
    "regex": MessageLookupByLibrary.simpleMessage("正規表現"),
    "releaseMemory": MessageLookupByLibrary.simpleMessage("メモリを解放"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "メモリの解放に失敗しました",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("リモート"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage("リモート宛先"),
    "remoteDnsResolve": MessageLookupByLibrary.simpleMessage("リモート DNS 解決"),
    "remove": MessageLookupByLibrary.simpleMessage("削除"),
    "rename": MessageLookupByLibrary.simpleMessage("名前を変更"),
    "renew": MessageLookupByLibrary.simpleMessage("更新する"),
    "renewUpgrade": MessageLookupByLibrary.simpleMessage("更新 / プランをアップグレード"),
    "replace": MessageLookupByLibrary.simpleMessage("置換"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("すべて置換"),
    "request": MessageLookupByLibrary.simpleMessage("リクエスト"),
    "requestBody": MessageLookupByLibrary.simpleMessage("リクエストボディ"),
    "requestHeaders": MessageLookupByLibrary.simpleMessage("リクエストヘッダー"),
    "requests": MessageLookupByLibrary.simpleMessage("リクエスト"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage("リクエストと更新"),
    "required": MessageLookupByLibrary.simpleMessage("必須"),
    "reset": MessageLookupByLibrary.simpleMessage("リセット"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "このページには変更があります。リセットしてもよろしいですか？",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("リセットしてもよろしいですか？"),
    "residentialActiveDesc": MessageLookupByLibrary.simpleMessage(
      "接続後、プロキシが必要な通信はこの回線を使用します。",
    ),
    "residentialApplyFailed": MessageLookupByLibrary.simpleMessage(
      "この回線を適用できませんでした。再試行するか、別の回線を選んでください。",
    ),
    "residentialApplying": MessageLookupByLibrary.simpleMessage("適用中…"),
    "residentialBulkBypass": MessageLookupByLibrary.simpleMessage(
      "動画と大容量ダウンロードは通常回線を使用し、住宅回線の通信量を消費しません。",
    ),
    "residentialBulkUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "大容量通信の迂回が未確認です。動画やダウンロードが住宅回線を使う場合があります。",
    ),
    "residentialCaptureOff": MessageLookupByLibrary.simpleMessage(
      "パソコンの通信はまだ取り込まれていません。下のシステムプロキシまたは TUN を有効にしてください。",
    ),
    "residentialChange": MessageLookupByLibrary.simpleMessage("出口を変更"),
    "residentialChoose": MessageLookupByLibrary.simpleMessage("出口を選択"),
    "residentialExitLocked": MessageLookupByLibrary.simpleMessage(
      "住宅出口はダッシュボードで選択してください。住宅ルーティング有効中は他のグループから変更できません。",
    ),
    "residentialExitSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "AI とプロキシが必要なグループは選択した回線を使用します。",
    ),
    "residentialExitSheetTitle": MessageLookupByLibrary.simpleMessage(
      "住宅回線の出口を選択",
    ),
    "residentialExplanation": MessageLookupByLibrary.simpleMessage(
      "既定のプロキシ通信は選択した住宅回線を使用し、中国本土と直接通信はサブスクリプションに従います。大容量通信の迂回が有効な場合は下に表示します。一部の宛先ではサーバーが別の出口を使用する場合があります。",
    ),
    "residentialLoadingCatalog": MessageLookupByLibrary.simpleMessage(
      "住宅回線を読み込み中…",
    ),
    "residentialLoadingCatalogDesc": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションの利用可能な回線を読み込んでいます。",
    ),
    "residentialManageSubscription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションを管理",
    ),
    "residentialMissing": MessageLookupByLibrary.simpleMessage(
      "選択した住宅出口はこのサブスクリプションに存在しません。",
    ),
    "residentialMissingDesc": MessageLookupByLibrary.simpleMessage(
      "別の出口を選ぶまでプロキシ通信はブロックされます。中国本土への直結通信は変わりません。",
    ),
    "residentialNoPlan": MessageLookupByLibrary.simpleMessage(
      "利用可能な住宅回線がありません",
    ),
    "residentialNoPlanDesc": MessageLookupByLibrary.simpleMessage(
      "このサブスクリプションには現在利用できる住宅出口がありません。サブスクリプションのポリシーを使うか、サブスクリプションパネルを確認してください。",
    ),
    "residentialNoticeBody": m117,
    "residentialNoticeChange": MessageLookupByLibrary.simpleMessage("別の住宅回線"),
    "residentialNoticeRetry": MessageLookupByLibrary.simpleMessage("再試行"),
    "residentialNoticeTitle": MessageLookupByLibrary.simpleMessage(
      "住宅回線を一時的に利用できません",
    ),
    "residentialOutbound": MessageLookupByLibrary.simpleMessage("住宅回線"),
    "residentialPending": MessageLookupByLibrary.simpleMessage(
      "回線を切り替えています。しばらくお待ちください。",
    ),
    "residentialResetFailed": MessageLookupByLibrary.simpleMessage(
      "新しい出口は有効ですが、既存の接続を閉じられませんでした。再接続するまで以前の出口を使う場合があります。",
    ),
    "residentialRouteNote": MessageLookupByLibrary.simpleMessage(
      "IP カードは現在の確認先に対する出口を表示するだけで、すべてのサイトが同じ出口とは限りません。",
    ),
    "residentialSelected": MessageLookupByLibrary.simpleMessage("選択中"),
    "residentialSubscriptionPolicy": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションのポリシー",
    ),
    "residentialTitle": MessageLookupByLibrary.simpleMessage("住宅回線"),
    "residentialUnavailable": MessageLookupByLibrary.simpleMessage("利用不可"),
    "residentialUseExit": m118,
    "residentialUseSubscription": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションのポリシーを使用",
    ),
    "residentialUsingSubscription": MessageLookupByLibrary.simpleMessage(
      "住宅出口は未選択です。プロキシが必要な通信はサブスクリプションのポリシーに従います。",
    ),
    "resourceUpdateInterval": MessageLookupByLibrary.simpleMessage("自動更新間隔"),
    "resourceUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "自動更新間隔は0より大きくしてください",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("リソース"),
    "respectRules": MessageLookupByLibrary.simpleMessage("ルールに従う"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "ルールに従うを有効にすると DNS 接続がルールに従います。Proxy Server Nameserver の設定が必要です。",
    ),
    "response": MessageLookupByLibrary.simpleMessage("レスポンス"),
    "responseBody": MessageLookupByLibrary.simpleMessage("レスポンスボディ"),
    "responseCode": MessageLookupByLibrary.simpleMessage("応答コード"),
    "responseHeaders": MessageLookupByLibrary.simpleMessage("レスポンスヘッダー"),
    "restart": MessageLookupByLibrary.simpleMessage("再起動"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage("コアを再起動してもよろしいですか？"),
    "restore": MessageLookupByLibrary.simpleMessage("復元"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("すべてのデータを復元"),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage("プロファイルのみ復元"),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("復元方式"),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage("互換"),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage("上書き"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("復元が完了しました"),
    "result": MessageLookupByLibrary.simpleMessage("結果"),
    "retry": MessageLookupByLibrary.simpleMessage("再試行"),
    "root": MessageLookupByLibrary.simpleMessage("Root"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("ルートアドレス"),
    "routeExcludeAddress": MessageLookupByLibrary.simpleMessage("ルート除外アドレス"),
    "routingMark": MessageLookupByLibrary.simpleMessage("ルーティングマーク"),
    "routingResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "ルーティングリソース",
    ),
    "routingResourcesSubtitle": MessageLookupByLibrary.simpleMessage(
      "プロキシ経由と直接接続する通信を決定します",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("ロシア語"),
    "rule": MessageLookupByLibrary.simpleMessage("ルール"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage("論理ルール AND"),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage("完全なドメインにマッチ"),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "ドメインキーワードにマッチ",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "ドメインの正規表現でマッチ",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "ドメインサフィックスにマッチ",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "ワイルドカードでマッチ（* と ? のみ対応）",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "DSCPマークにマッチ（tproxy udpインバウンドのみ）",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "宛先ポート範囲にマッチ",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage("IPの国コードにマッチ"),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Geosite 内のドメインにマッチ",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage("インバウンド名にマッチ"),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "インバウンドポートにマッチ",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "インバウンドタイプにマッチ",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "インバウンドユーザー名にマッチ（/ で複数指定可）",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "IPが属するASNにマッチ",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "IPアドレス範囲にマッチ（IP-CIDR6 は別名です）",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "IPアドレス範囲にマッチ",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "IPサフィックス範囲にマッチ",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "すべてのリクエストにマッチ（条件不要）",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "TCPまたはUDPにマッチ",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage("論理ルール NOT"),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("論理ルール OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "プロセス名でマッチ（Androidではパッケージ名にマッチ）",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "プロセス名の正規表現でマッチ（Androidではパッケージ名にマッチ）",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "プロセス名のワイルドカードでマッチ（* と ? のみ対応）",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスのフルパスでマッチ",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスパスの正規表現でマッチ",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "プロセスパスのワイルドカードでマッチ（* と ? のみ対応）",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "再マッチ名にマッチ（複数は / で区切る）",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "ルールセットを参照します。rule-providersの設定が必要です",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPの国コードにマッチ",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPが属するASNにマッチ",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPアドレス範囲にマッチ",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "送信元IPサフィックス範囲にマッチ",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "送信元ポート範囲にマッチ",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "サブルールへマッチします。括弧の使い方に注意してください",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "LinuxのユーザーIDにマッチ",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("ルールが空です"),
    "ruleListInvalid": MessageLookupByLibrary.simpleMessage(
      "ルールは 1 項目に 1 つのルールを書いた YAML リストにしてください。例：- DOMAIN,example.com,DIRECT",
    ),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent を直接接続",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "DNS over TLS をブロック",
    ),
    "rulePresetBlockLoopback": MessageLookupByLibrary.simpleMessage(
      "プロキシのループバックを防止",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage("QUIC をブロック"),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage("STUN をブロック"),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage("LAN 直接接続"),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple と Microsoft に直接接続",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("ルールプロバイダー"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("ルールセット"),
    "ruleSetEmptyTip": MessageLookupByLibrary.simpleMessage(
      "ルールセットに使用できるエントリがありません",
    ),
    "ruleSetInvalidTip": MessageLookupByLibrary.simpleMessage(
      "この mrs ファイルを読み込めません",
    ),
    "ruleSetMixedTip": MessageLookupByLibrary.simpleMessage(
      "ルールセットにドメインと IP 範囲が混在しているため、種類を判別できません",
    ),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("ルールターゲット"),
    "ruleTextInvalid": MessageLookupByLibrary.simpleMessage(
      "ルールは対応する種類で始めてください。例：DOMAIN,example.com,DIRECT",
    ),
    "rules": MessageLookupByLibrary.simpleMessage("ルール"),
    "rulesCount": m119,
    "runTime": MessageLookupByLibrary.simpleMessage("稼働時間"),
    "running": MessageLookupByLibrary.simpleMessage("実行中"),
    "runtimeConfig": MessageLookupByLibrary.simpleMessage("ランタイム設定"),
    "safeMode": MessageLookupByLibrary.simpleMessage("セーフモード"),
    "safeModeAppTitle": m120,
    "saturation": MessageLookupByLibrary.simpleMessage("彩度"),
    "save": MessageLookupByLibrary.simpleMessage("保存"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("変更を保存しますか？"),
    "scene": MessageLookupByLibrary.simpleMessage("シーン"),
    "sceneAi": MessageLookupByLibrary.simpleMessage("AI"),
    "sceneAiNote": MessageLookupByLibrary.simpleMessage(
      "AI サービスは AI モードの経路を使用し、中国本土向け通信は直接接続",
    ),
    "sceneDaily": MessageLookupByLibrary.simpleMessage("日常"),
    "sceneDailyBypass": MessageLookupByLibrary.simpleMessage(
      "大容量通信は住宅回線を自動的に迂回し、中国本土向け通信は直接接続",
    ),
    "sceneDailyNote": MessageLookupByLibrary.simpleMessage("中国本土向け通信は直接接続"),
    "sceneSuspended": MessageLookupByLibrary.simpleMessage("住宅回線モードではシーン切替を停止"),
    "sceneUnavailable": MessageLookupByLibrary.simpleMessage("シーンは利用できません"),
    "sceneUnavailableDesc": MessageLookupByLibrary.simpleMessage(
      "このサブスクリプションにはシーングループがまだありません。サポートへお問い合わせいただくか、プロキシページで切り替えてください。",
    ),
    "sceneUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "一部のルールを切り替えられませんでした",
    ),
    "sceneWatch": MessageLookupByLibrary.simpleMessage("視聴"),
    "sceneWatchNote": MessageLookupByLibrary.simpleMessage(
      "ストリーミングは視聴モードの経路を使用し、中国本土向け通信は直接接続",
    ),
    "script": MessageLookupByLibrary.simpleMessage("スクリプト"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "スクリプトモード：拡張スクリプトでプロファイル全体を書き換えます",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage("選択項目へスクロール"),
    "search": MessageLookupByLibrary.simpleMessage("検索"),
    "seconds": MessageLookupByLibrary.simpleMessage("秒"),
    "secondsCount": m121,
    "secretKey": MessageLookupByLibrary.simpleMessage("キー"),
    "sectionsInEffect": m122,
    "select": MessageLookupByLibrary.simpleMessage("選択"),
    "selectAll": MessageLookupByLibrary.simpleMessage("すべて選択"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage("ルールセットを選択してください"),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "振り分け戦略を選択してください",
    ),
    "selectionConfirming": MessageLookupByLibrary.simpleMessage("出口を確認しています…"),
    "selectionGroupOverridden": MessageLookupByLibrary.simpleMessage(
      "自動グループが別のノードを選びました。固定するにはノードを手動で選択してください。",
    ),
    "selectionNotCaptured": MessageLookupByLibrary.simpleMessage(
      "端末の通信はまだ取り込まれていません。下のシステムプロキシまたは TUN を有効にしてください。",
    ),
    "selectionRecheck": MessageLookupByLibrary.simpleMessage("再確認"),
    "selectionResidentialLocked": MessageLookupByLibrary.simpleMessage(
      "住宅回線がプロキシ通信を制御しています。住宅回線カードで回線を変更するか、サブスクリプションのルーティングに戻してください。",
    ),
    "selectionUnknown": MessageLookupByLibrary.simpleMessage(
      "出口が選択と異なります。原因を確認できませんでした。もう一度確認してください。",
    ),
    "selectionUnknownPending": MessageLookupByLibrary.simpleMessage(
      "出口が選択と異なります。原因を確認しています…",
    ),
    "send": MessageLookupByLibrary.simpleMessage("送信"),
    "sendFromPhone": MessageLookupByLibrary.simpleMessage("スマートフォンから送信"),
    "sendFromPhoneConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "スマートフォンから届いたリンクをインポートしますか？",
    ),
    "sendFromPhoneNoNetwork": MessageLookupByLibrary.simpleMessage(
      "このデバイスはローカルネットワークに接続されていません",
    ),
    "sendFromPhonePageHint": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションリンクまたはプロキシ共有リンク",
    ),
    "sendFromPhonePageSent": MessageLookupByLibrary.simpleMessage(
      "送信しました。もう一方のデバイスでインポートを確認してください。",
    ),
    "sendFromPhonePageTitle": MessageLookupByLibrary.simpleMessage(
      "天机云にリンクを送信",
    ),
    "sendFromPhonePermissionDenied": MessageLookupByLibrary.simpleMessage(
      "スマートフォンからリンクを受け取るには、天机云がローカルネットワークにアクセスするための「付近のデバイス」権限が必要です。アプリの設定でオンにしてください。",
    ),
    "sendFromPhoneTip": MessageLookupByLibrary.simpleMessage(
      "スマートフォンのカメラでコードをスキャンし、開いたページにリンクを貼り付けてください。両方のデバイスを同じネットワークに接続する必要があります。",
    ),
    "server": MessageLookupByLibrary.simpleMessage("サーバー"),
    "serviceAbnormalCount": m123,
    "serviceAllAvailable": MessageLookupByLibrary.simpleMessage("すべて利用可能"),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("利用可能"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("ブロック済み"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("すべて検査"),
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("近日提供予定"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "許可されていない ISP",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("検出に失敗しました"),
    "serviceManage": MessageLookupByLibrary.simpleMessage("サービスを管理"),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage("オリジナル作品のみ"),
    "servicePending": MessageLookupByLibrary.simpleMessage("未検査"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage("アクセス制限"),
    "serviceShownOnDashboard": MessageLookupByLibrary.simpleMessage(
      "ダッシュボードに表示",
    ),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("サービスの状態"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("利用不可"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage("対象外の地域"),
    "settingEntries": MessageLookupByLibrary.simpleMessage("設定項目"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "settingsCount": m124,
    "shareLinkUnreadable": m125,
    "shareLinksInvalid": MessageLookupByLibrary.simpleMessage(
      "リンクからプロキシを読み取れませんでした",
    ),
    "shareQrcodeTip": MessageLookupByLibrary.simpleMessage(
      "別のデバイスの天机云でスキャンすると、このプロファイルをインポートできます。",
    ),
    "show": MessageLookupByLibrary.simpleMessage("表示"),
    "showLess": MessageLookupByLibrary.simpleMessage("折りたたむ"),
    "showMore": MessageLookupByLibrary.simpleMessage("展開"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "通知に停止ボタンを表示",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("パスワードを表示"),
    "sidebar": MessageLookupByLibrary.simpleMessage("サイドバー"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("サイレント起動"),
    "singleImport": MessageLookupByLibrary.simpleMessage("個別インポート"),
    "singleShareLinkOnly": MessageLookupByLibrary.simpleMessage(
      "ここにはリンクを 1 つだけ入力してください。複数の場合は一覧のクイック編集を使ってください",
    ),
    "singleValueTip": m126,
    "size": MessageLookupByLibrary.simpleMessage("サイズ"),
    "skipCertVerify": MessageLookupByLibrary.simpleMessage("証明書の検証をスキップ"),
    "skipDomain": MessageLookupByLibrary.simpleMessage("スキップするドメイン"),
    "skipDstAddress": MessageLookupByLibrary.simpleMessage("スキップする宛先アドレス"),
    "skipServerCertVerify": MessageLookupByLibrary.simpleMessage(
      "サーバー証明書の検証をスキップ",
    ),
    "skipSrcAddress": MessageLookupByLibrary.simpleMessage("スキップする送信元アドレス"),
    "slide": MessageLookupByLibrary.simpleMessage("スライド"),
    "sliders": MessageLookupByLibrary.simpleMessage("スライダ"),
    "sniffProtocols": MessageLookupByLibrary.simpleMessage("プロトコル"),
    "sniffer": MessageLookupByLibrary.simpleMessage("スニッファー"),
    "socksPort": MessageLookupByLibrary.simpleMessage("SOCKSポート"),
    "softStyle": MessageLookupByLibrary.simpleMessage("ソフト"),
    "sort": MessageLookupByLibrary.simpleMessage("並べ替え"),
    "source": MessageLookupByLibrary.simpleMessage("ソース"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("送信元IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("特殊プロキシ"),
    "specialRules": MessageLookupByLibrary.simpleMessage("特殊ルール"),
    "spectrum": MessageLookupByLibrary.simpleMessage("スペクトル"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("速度統計"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("振り分け戦略"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "振り分け戦略は空にできません",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDが空です"),
    "stackMode": MessageLookupByLibrary.simpleMessage("スタックモード"),
    "stackTrace": MessageLookupByLibrary.simpleMessage("スタックトレース"),
    "standard": MessageLookupByLibrary.simpleMessage("標準"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "標準モード：プロファイルにルールを追加します",
    ),
    "start": MessageLookupByLibrary.simpleMessage("開始"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage("最初から作成"),
    "startVpn": MessageLookupByLibrary.simpleMessage("VPNを起動しています…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage("起動とバックグラウンド"),
    "status": MessageLookupByLibrary.simpleMessage("状態"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "DNS を無効にすると、システム DNS を使用します。",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("停止"),
    "stopUpdateDownloadTip": MessageLookupByLibrary.simpleMessage(
      "アップデートのダウンロードを中止しますか？",
    ),
    "stopVpn": MessageLookupByLibrary.simpleMessage("VPNを停止しています…"),
    "strategy": MessageLookupByLibrary.simpleMessage("戦略"),
    "strictRoute": MessageLookupByLibrary.simpleMessage("厳格なルーティング"),
    "strictRouteDesc": MessageLookupByLibrary.simpleMessage(
      "厳格なルーティングは DNS などの通信が TUN を迂回するのを防ぎます。IPv6 がオフの場合、この端末の IPv6 通信は遮断されます。",
    ),
    "style": MessageLookupByLibrary.simpleMessage("スタイル"),
    "submit": MessageLookupByLibrary.simpleMessage("送信"),
    "subscriptionDetails": MessageLookupByLibrary.simpleMessage("詳細"),
    "subscriptionExpiryNoticeBody": m127,
    "subscriptionExpiryNoticeTitle": m128,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage("サブスクリプション情報"),
    "subscriptionLink": MessageLookupByLibrary.simpleMessage("サブスクリプションリンク"),
    "sudoPasswordTitle": MessageLookupByLibrary.simpleMessage("sudo のパスワードを入力"),
    "suspended": MessageLookupByLibrary.simpleMessage("一時停止中…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("プロファイルを切り替え"),
    "switchProfileShort": MessageLookupByLibrary.simpleMessage("切替"),
    "sync": MessageLookupByLibrary.simpleMessage("同期"),
    "system": MessageLookupByLibrary.simpleMessage("システム"),
    "systemApp": MessageLookupByLibrary.simpleMessage("システムアプリ"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("システムプロキシ"),
    "systemService": MessageLookupByLibrary.simpleMessage("システムサービス"),
    "systemServiceAbnormal": MessageLookupByLibrary.simpleMessage("異常"),
    "systemServiceDescription": MessageLookupByLibrary.simpleMessage(
      "管理者権限で実行し、仮想アダプター、ルート、システムプロキシの設定と復元を行います。",
    ),
    "systemServiceInstall": MessageLookupByLibrary.simpleMessage("インストール"),
    "systemServiceNotInstalled": MessageLookupByLibrary.simpleMessage(
      "未インストール",
    ),
    "systemServiceRefresh": MessageLookupByLibrary.simpleMessage("更新"),
    "systemServiceRepair": MessageLookupByLibrary.simpleMessage("修復"),
    "systemServiceRunning": MessageLookupByLibrary.simpleMessage(
      "インストール済み・実行中",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("タブ"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("タブアニメーション"),
    "tapIconToRetry": MessageLookupByLibrary.simpleMessage("アイコンをタップして再試行"),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("タップして許可"),
    "target": MessageLookupByLibrary.simpleMessage("宛先"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP同時接続"),
    "testInterval": MessageLookupByLibrary.simpleMessage("テスト間隔"),
    "testUrl": MessageLookupByLibrary.simpleMessage("テストURL"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("使用時にテスト"),
    "textScale": MessageLookupByLibrary.simpleMessage("テキストの拡大縮小"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "アプリ内の文字はこの大きさで表示されます",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("テーマ"),
    "themeColor": MessageLookupByLibrary.simpleMessage("テーマカラー"),
    "themeMode": MessageLookupByLibrary.simpleMessage("テーマモード"),
    "tight": MessageLookupByLibrary.simpleMessage("コンパクト"),
    "time": MessageLookupByLibrary.simpleMessage("時刻"),
    "timeToFirstByte": MessageLookupByLibrary.simpleMessage("最初のバイトまでの時間"),
    "timeout": MessageLookupByLibrary.simpleMessage("タイムアウト"),
    "tintedStyle": MessageLookupByLibrary.simpleMessage("ティント"),
    "tip": MessageLookupByLibrary.simpleMessage("ヒント"),
    "toggle": MessageLookupByLibrary.simpleMessage("切り替え"),
    "tolerance": MessageLookupByLibrary.simpleMessage("許容値"),
    "tools": MessageLookupByLibrary.simpleMessage("ツール"),
    "torch": MessageLookupByLibrary.simpleMessage("ライト"),
    "total": MessageLookupByLibrary.simpleMessage("合計"),
    "totalDownload": MessageLookupByLibrary.simpleMessage("ダウンロード量"),
    "totalTraffic": MessageLookupByLibrary.simpleMessage("合計トラフィック"),
    "totalUpload": MessageLookupByLibrary.simpleMessage("アップロード量"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("TProxyポート"),
    "traffic": MessageLookupByLibrary.simpleMessage("通信量"),
    "trafficMainlandThisMonth": MessageLookupByLibrary.simpleMessage(
      "今月の中国本土への直接通信",
    ),
    "trafficOtherDirect": MessageLookupByLibrary.simpleMessage("直接通信（地域未確認）"),
    "trafficPeak": m129,
    "trafficSavedThisMonth": MessageLookupByLibrary.simpleMessage("今月の節約"),
    "trafficStats": MessageLookupByLibrary.simpleMessage("通信統計"),
    "trafficStatsDesc": MessageLookupByLibrary.simpleMessage(
      "この端末の今月の中国本土直結通信、VPN 通信、節約したプロキシ通信です。",
    ),
    "trafficStatsScope": MessageLookupByLibrary.simpleMessage(
      "この端末の今月分のみを集計します。アプリが取得した通信が対象です。",
    ),
    "trafficTotal": m130,
    "trafficUsage": MessageLookupByLibrary.simpleMessage("トラフィック統計"),
    "transport": MessageLookupByLibrary.simpleMessage("トランスポート"),
    "transportHeaders": m131,
    "trayCopyProxyCommand": MessageLookupByLibrary.simpleMessage(
      "ターミナル用プロキシコマンドをコピー",
    ),
    "trayDisconnect": MessageLookupByLibrary.simpleMessage("切断"),
    "trayNotConnected": MessageLookupByLibrary.simpleMessage("未接続"),
    "trayOpenApp": MessageLookupByLibrary.simpleMessage("Tianji Cloud を開く…"),
    "trayPreferences": MessageLookupByLibrary.simpleMessage("環境設定"),
    "trayShowMainWindow": MessageLookupByLibrary.simpleMessage("メインウィンドウを表示"),
    "trayTun": MessageLookupByLibrary.simpleMessage("仮想ネットワークアダプター（TUN）"),
    "trustCertificate": MessageLookupByLibrary.simpleMessage("証明書を信頼"),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunAuthorizationFailed": MessageLookupByLibrary.simpleMessage(
      "TUN の権限を取得できなかったため、オフにしました。",
    ),
    "tunDesc": MessageLookupByLibrary.simpleMessage("TUN は管理者モードでのみ有効です。"),
    "tunOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "ここで追加した項目は、すべてのプロファイルの TUN 設定を上書きします。追加していない項目はプロファイル自身の設定のままです。カスタムプロファイル自身が追加した項目が優先されます。",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("オフにする"),
    "turnOn": MessageLookupByLibrary.simpleMessage("オンにする"),
    "udpRelayMode": MessageLookupByLibrary.simpleMessage("UDP リレーモード"),
    "udpTimeout": MessageLookupByLibrary.simpleMessage("UDP タイムアウト"),
    "udpTimeoutDesc": MessageLookupByLibrary.simpleMessage(
      "UDP タイムアウトは秒単位で、gvisor・system・mixed スタックでのみ有効です。",
    ),
    "ultra": MessageLookupByLibrary.simpleMessage("最高"),
    "undo": MessageLookupByLibrary.simpleMessage("元に戻す"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("統一遅延"),
    "unknown": MessageLookupByLibrary.simpleMessage("不明"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage("不明なネットワークエラー"),
    "unmaximize": MessageLookupByLibrary.simpleMessage("元に戻す"),
    "unnamed": MessageLookupByLibrary.simpleMessage("名称未設定"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("固定を解除"),
    "update": MessageLookupByLibrary.simpleMessage("更新"),
    "updateAll": MessageLookupByLibrary.simpleMessage("すべて更新"),
    "updateDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "更新をダウンロードできませんでした。",
    ),
    "updateDownloadStarted": MessageLookupByLibrary.simpleMessage(
      "アップデートのダウンロードを開始しました。進行状況はダッシュボードで確認できます。",
    ),
    "updateDownloadTest": MessageLookupByLibrary.simpleMessage(
      "アップデートのダウンロードテスト",
    ),
    "updateFailed": MessageLookupByLibrary.simpleMessage("更新に失敗しました"),
    "updateInstallFailed": MessageLookupByLibrary.simpleMessage(
      "更新をインストールできませんでした。リリースページからダウンロードできます。",
    ),
    "updateNotVerified": MessageLookupByLibrary.simpleMessage(
      "ダウンロードした更新を検証できませんでした。",
    ),
    "updateReady": MessageLookupByLibrary.simpleMessage("アップデートの準備完了"),
    "updateReadyTip": MessageLookupByLibrary.simpleMessage(
      "アップデートをダウンロードしました。タップしてインストールします。",
    ),
    "updateRestartTip": MessageLookupByLibrary.simpleMessage(
      "更新をインストールするため天机云を終了し、完了後に再び起動します。",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("アップロード"),
    "uploadBandwidth": MessageLookupByLibrary.simpleMessage("アップロード帯域幅"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlRewrite": MessageLookupByLibrary.simpleMessage("URL 書き換え"),
    "urlTip": m132,
    "useHosts": MessageLookupByLibrary.simpleMessage("Hostsを使用"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("システムのHostsを使用"),
    "usedShort": MessageLookupByLibrary.simpleMessage("使用済み"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("使用済みトラフィック"),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
    "validUntil": m133,
    "value": MessageLookupByLibrary.simpleMessage("値"),
    "view": MessageLookupByLibrary.simpleMessage("表示"),
    "viewAll": MessageLookupByLibrary.simpleMessage("すべて表示"),
    "virtualIpv4": MessageLookupByLibrary.simpleMessage("仮想 IPv4"),
    "vividStyle": MessageLookupByLibrary.simpleMessage("ビビッド"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "VPN関連の設定が変更されました。タップして再起動",
    ),
    "vpnTraffic": MessageLookupByLibrary.simpleMessage("VPN"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage("WebDAV設定"),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("ホワイトリストモード"),
    "writeToSystem": MessageLookupByLibrary.simpleMessage("システムに書き込む"),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "システムに書き込むを有効にするとシステムクロックも設定します。Android では無視されます。",
    ),
    "yearsAgo": m134,
    "yearsAgoShort": m135,
    "yes": MessageLookupByLibrary.simpleMessage("はい"),
    "zhCN": MessageLookupByLibrary.simpleMessage("簡体字中国語"),
    "zzAutoUpdateHours": m136,
    "zzAutoUpdateIntervalLabel": m137,
    "zzExpiryDate": m138,
    "zzProfileBasedOnOverrides": m139,
    "zzProfileExpiredDays": m140,
    "zzProfileImportHint": m141,
    "zzProfileImportedOn": m142,
    "zzQuickClipboard": MessageLookupByLibrary.simpleMessage("クリップボード"),
    "zzQuickLocalFile": MessageLookupByLibrary.simpleMessage("ローカルファイル"),
    "zzQuickScan": MessageLookupByLibrary.simpleMessage("スキャン"),
    "zzRemaining": MessageLookupByLibrary.simpleMessage("残り"),
    "zzRemainingDayUnit": MessageLookupByLibrary.simpleMessage("日"),
    "zzRenewUpgradeShort": MessageLookupByLibrary.simpleMessage("更新 / アップグレード"),
    "zzTotalQuota": m143,
  };
}
