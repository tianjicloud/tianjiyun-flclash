import 'package:fl_clash/ui/business_brand_mark.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the brand asset at the requested size', (tester) async {
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(devicePixelRatio: 2),
          child: BusinessBrandMark(size: 24),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<ResizeImage>());
    final provider = image.image as ResizeImage;
    expect(
      (provider.imageProvider as AssetImage).assetName,
      'assets/images/icon.png',
    );
    expect(provider.width, 48);
    expect(provider.height, 48);
    expect(image.width, 24);
    expect(image.height, 24);
    expect(image.fit, BoxFit.contain);
    expect(image.filterQuality, FilterQuality.medium);
  });
}
