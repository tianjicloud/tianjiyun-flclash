import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/traffic.dart';
import 'package:flutter_test/flutter_test.dart';

Profile _urlProfile(String url, {int id = 42}) {
  return Profile(
    id: id,
    type: ProfileType.url,
    url: url,
    autoUpdateDuration: const Duration(hours: 12),
  );
}

void main() {
  test('a supported Tianji subscription enables reporting', () {
    final profile = resolveTianjiTrafficProfile(
      _urlProfile('https://sub1.tianjiyun.org/s/abcdefgh12345678'),
    );
    expect(profile, isNotNull);
    expect(profile!.profileId, '42');
  });

  test('an unsupported or local profile never enables reporting', () {
    expect(
      resolveTianjiTrafficProfile(
        _urlProfile('https://example.com/s/abcdefgh12345678'),
      ),
      isNull,
    );
    expect(resolveTianjiTrafficProfile(_urlProfile('')), isNull);
    expect(resolveTianjiTrafficProfile(null), isNull);
    expect(
      resolveTianjiTrafficProfile(
        const Profile(
          id: 1,
          type: ProfileType.file,
          url: 'https://sub1.tianjiyun.org/s/abcdefgh12345678',
          autoUpdateDuration: Duration(hours: 12),
        ),
      ),
      isNull,
    );
  });
}
