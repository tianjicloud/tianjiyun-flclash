import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/common/l10n_labels.dart';
import 'package:fl_clash/manager/macos_menu.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/app_glyphs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _MenuDelegate extends PlatformMenuDelegate {
  List<PlatformMenuItem> menus = [];

  @override
  void setMenus(List<PlatformMenuItem> topLevelMenus) => menus = topLevelMenus;

  @override
  void clearMenus() => menus = [];

  @override
  bool debugLockDelegate(BuildContext context) => true;

  @override
  bool debugUnlockDelegate(BuildContext context) => true;
}

class _RecordingSystemAction extends SystemAction {
  static final calls = <String>[];

  @override
  Future<void> handleClose([bool exit = true]) async => calls.add('close');

  @override
  Future<void> handleExit([bool needSave = true]) async => calls.add('exit');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('macOS menus reflect state and navigate from shortcuts', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final binding = tester.binding;
    final previousDelegate = binding.platformMenuDelegate;
    final delegate = _MenuDelegate();
    binding.platformMenuDelegate = delegate;
    addTearDown(() => binding.platformMenuDelegate = previousDelegate);
    _RecordingSystemAction.calls.clear();
    final controller = TextEditingController(text: 'abcde');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    final container = ProviderContainer(
      overrides: [
        navigationStateProvider.overrideWithValue(
          NavigationState(
            pageLabel: PageLabel.dashboard,
            navigationItems: [
              NavigationItem(
                glyph: AppGlyphs.dashboard,
                label: PageLabel.dashboard,
                builder: (_) => const SizedBox(),
              ),
              NavigationItem(
                glyph: AppGlyphs.proxies,
                label: PageLabel.proxies,
                builder: (_) => const SizedBox(),
              ),
            ],
            viewMode: ViewMode.desktop,
            locale: null,
            currentIndex: 0,
          ),
        ),
        patchClashConfigProvider.overrideWithBuild(
          (_, _) => const PatchClashConfig(mode: Mode.rule),
        ),
        isStartProvider.overrideWithValue(true),
        appSettingProvider.overrideWithBuild(
          (_, _) => defaultAppSettingProps.copyWith(minimizeOnExit: true),
        ),
        systemActionProvider.overrideWith(_RecordingSystemAction.new),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: WidgetsApp(
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.delegate.supportedLocales,
          color: const Color(0xff000000),
          builder: (context, child) => MacOSMenuBar(
            child: EditableText(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: Color(0xffffffff)),
              cursorColor: const Color(0xff000000),
              backgroundCursorColor: const Color(0xffffffff),
            ),
          ),
        ),
      ),
    );

    PlatformMenu menu(String label) => delegate.menus
        .whereType<PlatformMenu>()
        .singleWhere((item) => item.label == label);

    final connectionItems = menu('连接').menus;
    expect(connectionItems.first.label, '断开连接');
    expect(
      connectionItems.map((item) => item.label),
      containsAll(['规则', '全局', '直连']),
    );
    expect(connectionItems[2].onSelected, isNull);
    container
        .read(patchClashConfigProvider.notifier)
        .update((config) => config.copyWith(mode: Mode.global));
    await tester.pump();
    expect(menu('连接').menus.first.label, '断开连接');
    expect(menu('连接').menus[3].onSelected, isNull);
    final proxies = menu('查看').menus[1];
    expect(proxies.label, PageLabel.proxies.label);
    proxies.onSelected!.call();
    await tester.pump();
    expect(container.read(currentPageLabelProvider), PageLabel.proxies);
    expect(
      proxies.shortcut,
      isA<SingleActivator>().having(
        (shortcut) => shortcut.trigger,
        'trigger',
        LogicalKeyboardKey.digit2,
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    menu('编辑').menus.singleWhere((item) => item.label == '全选').onSelected!();
    await tester.pump();
    expect(
      controller.selection,
      const TextSelection(baseOffset: 0, extentOffset: 5),
    );

    menu('天机云').menus.singleWhere((item) => item.label == '退出').onSelected!();
    await tester.pump();
    expect(_RecordingSystemAction.calls, ['exit']);
    await tester.pumpWidget(const SizedBox());
    binding.platformMenuDelegate = previousDelegate;
    debugDefaultTargetPlatformOverride = null;
  });
}
