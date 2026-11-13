import 'package:fl_clash/common/dns_response.dart';
import 'package:fl_clash/common/proxy_group_display.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/dashboard_lines.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('strips only a multiplier suffix from the displayed line name', () {
    expect(stripBusinessMultiplierSuffix('Tokyo 1.5x'), 'Tokyo');
    expect(stripBusinessMultiplierSuffix('Tokyo ×2'), 'Tokyo');
    expect(stripBusinessMultiplierSuffix('1.5x Tokyo'), '1.5x Tokyo');
    expect(stripBusinessMultiplierSuffix('Tokyo'), 'Tokyo');
  });

  test('maps Clash group names to group types', () {
    expect(proxyGroupTypeOf('URLTEST'), GroupType.URLTest);
    expect(proxyGroupTypeOf('Selector'), GroupType.Selector);
    expect(proxyGroupTypeOf('Fallback'), GroupType.Fallback);
    expect(proxyGroupTypeOf('LoadBalance'), GroupType.LoadBalance);
    expect(proxyGroupTypeOf('unknown'), isNull);
  });

  test('identifies Tianji internal groups from known names and structure', () {
    expect(
      isInternalLineGroup(
        const Group(name: sceneGroupName, type: GroupType.Selector),
      ),
      isTrue,
    );
    expect(
      isInternalLineGroup(
        const Group(
          name: 'Tokyo 1.5x',
          type: GroupType.URLTest,
          all: [Proxy(name: 'Tokyo 1.5x', type: 'ss')],
        ),
      ),
      isTrue,
    );
    expect(
      isInternalLineGroup(
        const Group(
          name: 'Tokyo automatic',
          type: GroupType.URLTest,
          all: [Proxy(name: '🇯🇵 Tokyo', type: 'ss')],
        ),
      ),
      isTrue,
    );
    expect(
      isInternalLineGroup(
        const Group(
          name: 'Tokyo',
          type: GroupType.URLTest,
          all: [
            Proxy(name: 'Tokyo', type: 'ss'),
            Proxy(name: 'Osaka', type: 'ss'),
          ],
        ),
      ),
      isFalse,
    );
  });

  test('maps common DNS response codes to plain meanings', () {
    expect(dnsResponseMeaning('NOERROR'), DnsResponseMeaning.success);
    expect(dnsResponseMeaning('NXDOMAIN'), DnsResponseMeaning.domainMissing);
    expect(dnsResponseMeaning('REFUSED'), DnsResponseMeaning.refused);
    expect(dnsResponseMeaning('SERVFAIL'), DnsResponseMeaning.serverError);
    expect(dnsResponseMeaning('OTHER'), DnsResponseMeaning.other);
  });
}
