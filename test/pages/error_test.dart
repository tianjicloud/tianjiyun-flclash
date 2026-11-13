import 'dart:io';

import 'package:fl_clash/pages/error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';
import '../helpers/test_app.dart';

final _stack = StackTrace.fromString('#0 boot (package:fl_clash/main.dart:1)');

Widget _screen({
  ThemeData? theme,
  AsyncCallback? onClearData,
  AsyncCallback? onExit,
}) {
  return HostApp(
    theme: theme,
    home: InitErrorScreen(
      error: StateError('boot failed'),
      stack: _stack,
      onClearData: onClearData ?? () async {},
      onExit: onExit ?? () async {},
    ),
  );
}

void main() {
  testWidgets('shows the error and its stack trace', (tester) async {
    await tester.pumpWidget(_screen());
    await tester.pump();

    expect(find.text("The network core couldn't start"), findsOneWidget);
    await tester.tap(find.text('Error details'));
    await tester.pump();
    expect(find.text('Error details'), findsOneWidget);
    expect(find.byKey(const ValueKey('error-details-chevron')), findsOneWidget);
    expect(find.text('Stack trace'), findsOneWidget);
    expect(
      find.text(StateError('boot failed').toString()),
      findsOneWidget,
      reason: 'the raw error must stay readable when nothing else works',
    );
    expect(find.text(_stack.toString()), findsOneWidget);
  });

  testWidgets('renders in both brightness modes', (tester) async {
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        _screen(theme: ThemeData(brightness: brightness)),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(InitErrorScreen), findsOneWidget);
    }
  });

  testWidgets('explains the occupied core port', (tester) async {
    await tester.pumpWidget(
      HostApp(
        locale: const Locale('zh', 'CN'),
        home: InitErrorScreen(
          error: StateError(
            'listen tcp 127.0.0.1:7890: bind: address already in use',
          ),
          stack: _stack,
          onClearData: () async {},
          onExit: () async {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('网络内核没能启动'), findsOneWidget);
    expect(
      find.text('端口 7890 已被其他程序占用，天机云无法监听。你的网络没有被改动，可以正常上网。'),
      findsOneWidget,
    );
    expect(find.text('可以这样解决'), findsOneWidget);
    expect(find.text('关闭占用 7890 端口的程序后重新打开天机云'), findsOneWidget);
    expect(find.text('在 设置 → 入站与端口 更换端口'), findsOneWidget);
    expect(find.byKey(const ValueKey('error-details-chevron')), findsOneWidget);
  });

  testWidgets('the shared startup error body exposes port and report actions', (
    tester,
  ) async {
    final actions = <String>[];
    await tester.pumpWidget(
      HostApp(
        locale: const Locale('en'),
        home: ErrorPageBody(
          error: StateError(
            'listen tcp 127.0.0.1:7890: bind: address already in use',
          ),
          onAutoChangePort: () async => actions.add('port'),
          onExportReport: () async => actions.add('report'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Choose an available port'), findsOneWidget);
    expect(find.text('Export support report'), findsOneWidget);
    expect(find.text('Clear data'), findsNothing);
    expect(find.text('Exit'), findsNothing);
    await tester.tap(find.text('Choose an available port'));
    await tester.tap(find.text('Export support report'));
    expect(actions, ['port', 'report']);
  });

  testWidgets('the app shell follows the system locale', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('zh', 'CN')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      InitErrorApp(
        error: StateError('boot failed'),
        stack: _stack,
        onClearData: () async {},
        onExit: () async {},
      ),
    );
    await tester.pump();

    expect(find.text('网络内核没能启动'), findsOneWidget);
  });

  testWidgets('copies the error and stack trace to the clipboard', (
    tester,
  ) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(_screen());
    await tester.pump();
    await tester.tap(find.text('Copy error info'));
    await tester.pump();

    expect(copied, hasLength(1));
    expect(copied.single, contains('boot failed'));
    expect(copied.single, contains(_stack.toString()));
    expect(find.text('Copied successfully'), findsOneWidget);
  });

  testWidgets('exit leaves through the exit callback', (tester) async {
    var exits = 0;
    await tester.pumpWidget(_screen(onExit: () async => exits++));
    await tester.pump();

    await tester.tap(find.text('Exit'));
    await tester.pump();

    expect(exits, 1);
  });

  testWidgets('clear data asks first, then clears and exits', (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(
      _screen(
        onClearData: () async => calls.add('clear'),
        onExit: () async => calls.add('exit'),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Clear data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(calls, isEmpty);

    await tester.tap(find.text('Clear data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(calls, [
      'clear',
      'exit',
    ], reason: 'the cleared data is only reread on the next launch');
  });

  testWidgets('a failed clear stays on the screen and says why', (
    tester,
  ) async {
    var exits = 0;
    await tester.pumpWidget(
      _screen(
        onClearData: () async => throw const FileSystemException('locked'),
        onExit: () async => exits++,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Clear data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(exits, 0);
    expect(find.textContaining("Couldn't clear the data"), findsOneWidget);
    final exitButton = tester.widget<FilledButton>(
      find.ancestor(of: find.text('Exit'), matching: find.byType(FilledButton)),
    );
    expect(exitButton.onPressed, isNotNull);
  });
}
