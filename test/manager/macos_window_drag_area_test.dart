import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/common/window_drag_area.dart';
import 'package:fl_clash/models/models.dart' show WindowProps;
import 'package:fl_clash/ui/scaffold/scaffold.dart' show Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart' show ThemeData, ViewScope;

import '../helpers/test_app.dart';

class _RecordingWindowPort implements WindowPort {
  int drags = 0;

  @override
  Future<WindowProps?> captureNormalGeometry(WindowProps current) async =>
      current;

  @override
  Future<double?> setBlur({
    required bool enabled,
    required Brightness brightness,
    required Color tint,
  }) async => null;

  @override
  Future<void> show() async {}

  @override
  Future<void> hide() async {}

  @override
  Future<void> toggle() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> startDragging() async => drags++;

  @override
  void forceExit() {}
}

void main() {
  testWidgets('dragging the macOS page title starts a window drag', (
    tester,
  ) async {
    final port = _RecordingWindowPort();
    final previousPort = windowPort;
    windowPort = port;
    addTearDown(() => windowPort = previousPort);
    final previousDrag = startWindowDragging;
    final previousToggle = toggleWindowMaximizedAction;
    startWindowDragging = port.startDragging;
    toggleWindowMaximizedAction = () async {};
    addTearDown(() {
      startWindowDragging = previousDrag;
      toggleWindowMaximizedAction = previousToggle;
    });
    await tester.pumpWidget(
      HostApp(
        theme: ThemeData(platform: TargetPlatform.macOS),
        builder: (context, child) => ViewScope(
          size: const Size(1000, 720),
          isMobile: false,
          child: wrapAppScopes(context, child!),
        ),
        home: const Scaffold(title: 'Dashboard', body: SizedBox.expand()),
      ),
    );

    final dragArea = find.byType(MacOSWindowDragArea);
    expect(dragArea, findsOneWidget);
    await tester.drag(dragArea, const Offset(20, 30));
    await tester.pump(const Duration(milliseconds: 300));
    expect(port.drags, 1);
  });
}
