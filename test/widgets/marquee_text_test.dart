import 'package:fl_clash/widgets/marquee_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('fits without creating a ticker', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(width: 200, child: MarqueeText('short')),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(AnimatedBuilder), findsNothing);
    expect(find.byType(ShaderMask), findsNothing);
  });

  testWidgets(
    'long text keeps its slot size and stops when animations are disabled',
    (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 60,
              child: MarqueeText('A very long connection name', key: key),
            ),
          ),
        ),
      );
      final rect = tester.getRect(find.byKey(key));
      await tester.pump(const Duration(seconds: 2));
      expect(tester.getRect(find.byKey(key)), rect);
      expect(find.byType(AnimatedBuilder), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('scrolling text moves inside its fixed slot', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: false),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TickerMode(
            enabled: true,
            child: SizedBox(
              width: 80,
              child: MarqueeText(
                'A long name that must move inside its slot',
                key: key,
                scrollWhen: true,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    final element = tester.element(find.byKey(key));
    expect(tester.widget<MarqueeText>(find.byKey(key)).scrollWhen, isTrue);
    expect(tester.widget<MarqueeText>(find.byKey(key)).hoverToScroll, isFalse);
    expect(MediaQuery.disableAnimationsOf(element), isFalse);
    expect(TickerMode.valuesOf(element).enabled, isTrue);
    final slot = tester.getRect(find.byKey(key));
    final text = find.text('A long name that must move inside its slot');
    final start = tester.getRect(text).left;
    expect(find.byType(AnimatedBuilder), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(seconds: 2));
    expect(tester.getRect(find.byKey(key)), slot);
    expect(tester.getRect(text).left, lessThan(start));
    expect(find.byType(AnimatedBuilder), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hover starts scrolling and leaving stops it', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: false),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TickerMode(
            enabled: true,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 80,
                child: MarqueeText(
                  'A long name that must move inside its slot',
                  key: key,
                  scrollWhen: true,
                  hoverToScroll: true,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final text = find.text('A long name that must move inside its slot');
    final start = tester.getRect(text).left;
    expect(find.byType(AnimatedBuilder), findsNothing);
    final rect = tester.getRect(find.byKey(key));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: rect.center);
    await mouse.moveTo(rect.center);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(seconds: 2));
    expect(tester.getRect(text).left, lessThan(start));
    await mouse.moveTo(const Offset(500, 500));
    await tester.pump();
    await tester.pump();
    expect(find.byType(AnimatedBuilder), findsNothing);
    expect(tester.takeException(), isNull);

    await mouse.moveTo(rect.center);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(seconds: 2));
    expect(tester.getRect(text).left, lessThan(start));
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
    await tester.pump();
  });

  testWidgets('TickerMode disabled prevents marquee motion', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: false),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TickerMode(
            enabled: false,
            child: SizedBox(
              width: 80,
              child: MarqueeText(
                'A long name that must stay still',
                scrollWhen: true,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
    final text = find.text('A long name that must stay still');
    final initial = tester.getRect(text);
    await tester.pump(const Duration(seconds: 3));
    expect(tester.getRect(text), initial);
    expect(tester.takeException(), isNull);
  });
}
