import 'package:fl_clash/views/dashboard/widgets/current_outbound.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('formats the location chip for desktop and Android', () {
    expect(
      outboundLocationLabel(countryCode: 'JP', city: '东京', desktop: true),
      'JP · 东京',
    );
    expect(
      outboundLocationLabel(countryCode: 'JP', city: '东京', desktop: false),
      'JP 东京',
    );
    expect(
      outboundLocationLabel(countryCode: 'JP', city: null, desktop: true),
      'JP',
    );
  });

  test('residential business chip uses the desktop label on desktop', () async {
    final l10n = await AppLocalizations.load(const Locale('zh', 'CN'));

    expect(
      businessResidentialLabel(l10n, desktop: true),
      l10n.businessResidentialBroadband,
    );
    expect(
      businessResidentialLabel(l10n, desktop: false),
      l10n.businessResidentialShort,
    );
  });
}
