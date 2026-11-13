import 'package:flutter/widgets.dart';

Future<void> Function()? startWindowDragging;
Future<void> Function()? toggleWindowMaximizedAction;

class MacOSWindowDragArea extends StatelessWidget {
  const MacOSWindowDragArea({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => startWindowDragging?.call(),
      onDoubleTap: () => toggleWindowMaximizedAction?.call(),
      child: child,
    );
  }
}
