import 'dart:convert';

import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/ui/app_background.dart';
import 'package:fl_clash/ui/scaffold/scaffold.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../helpers/test_app.dart';

var _mounts = 0;

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void initState() {
    super.initState();
    _mounts++;
  }

  @override
  Widget build(BuildContext context) => const Text('Page content');
}

void main() {
  setUp(() => _mounts = 0);
  test('background round trips without changing the chosen primary color', () {
    for (final preset in ['solid', 'orbit', 'mountains']) {
      final props = ThemeProps(background: preset, primaryColor: 0xFF123456);
      final restored = ThemeProps.fromJson(
        jsonDecode(jsonEncode(props.toJson())),
      );
      expect(restored.background, preset);
      expect(restored.primaryColor, props.primaryColor);
    }
    expect(ThemeProps.fromJson({}).background, 'orbit');
  });

  for (final brightness in Brightness.values) {
    testWidgets('all page scaffolds support images and solid $brightness', (
      tester,
    ) async {
      for (final preset in [
        'solid',
        'orbit',
        'mountains',
        'planet',
        'aurora',
        'nebula',
        'globe',
        'unknown',
        'solid',
      ]) {
        await tester.pumpWidget(
          TestApp(
            wrapInProviderScope: true,
            theme: ThemeData(
              colorScheme: seededColorScheme(
                seedColor: const Color(0xFF3D5AFE),
                brightness: brightness,
              ),
            ),
            child: AppBackgroundScope(
              preset: preset,
              child: const Scaffold(title: 'Preview', body: _Content()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.byType(SvgPicture),
          ['orbit', 'mountains'].contains(preset)
              ? findsOneWidget
              : findsNothing,
        );
        expect(
          find.byType(Image),
          ['planet', 'aurora', 'nebula', 'globe'].contains(preset)
              ? findsOneWidget
              : findsNothing,
        );
        expect(find.text('Page content'), findsOneWidget);
        expect(_mounts, 1);
        expect(tester.takeException(), isNull);
        expect(tester.binding.transientCallbackCount, 0);
      }
    });
  }
}
