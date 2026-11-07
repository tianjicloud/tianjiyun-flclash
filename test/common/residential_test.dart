import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

const _url = 'https://sub1.tianjiyun.org/s/test_subscription_001';

Profile _profile({String url = _url, ProfileOverrides? overrides}) {
  return Profile(
    id: 1,
    type: ProfileType.url,
    label: 'Tianji',
    url: url,
    autoUpdateDuration: Duration.zero,
    overrides: overrides ?? const ProfileOverrides(),
  );
}

List<Group> _groups() => [
  const Group(
    type: GroupType.Selector,
    name: tianjiResidentialRootName,
    all: [
      Proxy(name: 'Tokyo', type: 'url-test'),
      Proxy(name: 'DIRECT', type: 'direct'),
    ],
  ),
  const Group(
    type: GroupType.URLTest,
    name: 'Tokyo',
    all: [Proxy(name: 'home-a', type: 'ss')],
  ),
];

ProfileOverrides _chosen(String? fingerprint) => ProfileOverrides(
  residentialExit: 'Tokyo',
  residentialSubscriptionFingerprint: fingerprint,
);

void main() {
  test('only verified Tianji subscription URLs are business profiles', () {
    expect(isTianjiSubscriptionProfile(_profile()), isTrue);
    expect(
      isTianjiSubscriptionProfile(
        _profile(url: 'https://example.com/s/test_subscription_001'),
      ),
      isFalse,
    );
    expect(
      isTianjiSubscriptionProfile(
        _profile(url: 'https://sub1.tianjiyun.org/s/123456789'),
      ),
      isFalse,
    );
  });

  test('a choice belongs to the subscription identity, not the row id', () {
    final profile = _profile();
    final fingerprint = resolveTianjiProfile(profile)!.fingerprint;
    expect(
      isResidentialPolicyActive(_profile(overrides: _chosen(fingerprint))),
      isTrue,
    );
    expect(
      isResidentialPolicyActive(
        _profile(
          url: 'https://sub1.tianjiyun.org/s/test_subscription_002',
          overrides: _chosen(fingerprint),
        ),
      ),
      isFalse,
    );
  });

  test('policy exposes safe direct choices and catalog state', () {
    final profile = _profile();
    final fingerprint = resolveTianjiProfile(profile)!.fingerprint;
    final chosen = _profile(overrides: _chosen(fingerprint));
    final policy = buildResidentialPolicy(
      profile: chosen,
      groups: _groups(),
      catalogReady: true,
    );

    expect(policy.active, isTrue);
    expect(policy.selectedExit, 'Tokyo');
    expect(policy.choices, ['Tokyo']);
    expect(policy.missingExit, isFalse);

    final notReady = buildResidentialPolicy(
      profile: chosen,
      groups: const [],
      catalogReady: false,
    );
    expect(notReady.catalogReady, isFalse);
    expect(notReady.choices, isEmpty);
  });

  test('a removed child is reported as a missing exit', () {
    final profile = _profile();
    final fingerprint = resolveTianjiProfile(profile)!.fingerprint;
    final policy = buildResidentialPolicy(
      profile: _profile(overrides: _chosen(fingerprint)),
      groups: [
        const Group(type: GroupType.Selector, name: tianjiResidentialRootName),
      ],
      catalogReady: true,
    );

    expect(policy.active, isTrue);
    expect(policy.missingExit, isTrue);
    expect(policy.selectedExit, 'Tokyo');
  });

  test(
    'a reject-only applied route is unavailable even if the catalog lists it',
    () {
      final profile = _profile();
      final policy = buildResidentialPolicy(
        profile: _profile(
          overrides: _chosen(resolveTianjiProfile(profile)!.fingerprint),
        ),
        groups: [
          ..._groups(),
          const Group(
            name: tianjiResidentialLockedGroupName,
            type: GroupType.Selector,
            all: [Proxy(name: 'REJECT', type: 'reject')],
          ),
        ],
        catalogReady: true,
      );

      expect(policy.choices, contains('Tokyo'));
      expect(policy.missingExit, isTrue);
    },
  );
}
