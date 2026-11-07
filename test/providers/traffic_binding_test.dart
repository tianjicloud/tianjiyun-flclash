import 'package:fl_clash/common/preferences.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/report.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/providers/core.dart';
import 'package:fl_clash/providers/database.dart';
import 'package:fl_clash/providers/traffic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _Auth implements TrafficReportAuthenticator {
  const _Auth(this.identity);

  final String identity;

  @override
  Future<String?> authorizationFor(
    Uri endpoint, {
    required String installationId,
    required String scopeKey,
  }) async => identity;

  @override
  void invalidate({
    required Uri endpoint,
    required String installationId,
    required String scopeKey,
  }) {}
}

class _Transport implements TrafficReportTransport {
  final batches = <TrafficReportBatch>[];
  final identities = <String>[];

  @override
  Future<TrafficReportAck> send(
    TrafficReportBatch batch, {
    required Uri endpoint,
    required String authorization,
    required Duration timeout,
  }) async {
    batches.add(batch);
    identities.add(authorization);
    return TrafficReportAck(
      version: 1,
      accepted: [
        for (final stream in batch.streams)
          TrafficReportAccepted(
            streamId: stream.streamId,
            revision: stream.revision,
          ),
      ],
      receivedAt: DateTime.now().toUtc(),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'same-profile credential replacement isolates pending customer data',
    () async {
      SharedPreferences.setMockInitialValues({});
      await preferences.rebind();
      addTearDown(() async {
        SharedPreferences.setMockInitialValues({});
        await preferences.rebind();
      });
      final original = Profile.normal(
        label: 'Customer A',
        url: 'https://sub1.tianjiyun.org/s/customerA12345678',
      );
      final replacement = original.copyWith(
        url: 'https://sub1.tianjiyun.org/s/customerB12345678',
      );
      var up = 0;
      final core = _Core();
      when(() => core.getTrafficStats()).thenAnswer(
        (_) async => TrafficSnapshot(
          version: 1,
          epoch: 1,
          mainlandDirect: TrafficBytes.zero,
          proxy: TrafficBytes(up: up),
          otherDirect: TrafficBytes.zero,
        ),
      );
      final transport = _Transport();
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([original])),
          currentProfileIdProvider.overrideWithBuild((_, _) => original.id),
          coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
          trafficAuthenticatorFactoryProvider.overrideWithValue(
            (profile) => _Auth(profile.identityKey),
          ),
          trafficReportTransportProvider.overrideWithValue(transport),
        ],
      );
      addTearDown(container.dispose);
      container.listen(trafficStatsProvider, (_, _) {});
      final service = container.read(trafficStatsProvider);
      await service.start();
      await service.sample();
      up = 100;
      await service.sample();

      container
          .read(profilesProvider.notifier)
          .updateProfile(original.id, (_) => replacement);
      await container.pump();
      expect(container.read(trafficStatsProvider), same(service));
      await service.sample();
      up = 130;
      await service.sample();
      await service.upload();
      expect(transport.batches, hasLength(1));
      expect(transport.batches.single.streams.single.allocation.proxy.up, 30);
      expect(
        transport.identities.single,
        resolveTianjiTrafficProfile(replacement)!.identityKey,
      );

      container
          .read(profilesProvider.notifier)
          .updateProfile(original.id, (_) => original);
      await container.pump();
      await service.sample();
      await service.upload();
      expect(transport.batches, hasLength(2));
      expect(transport.batches.last.streams.single.allocation.proxy.up, 100);
      expect(
        transport.identities.last,
        resolveTianjiTrafficProfile(original)!.identityKey,
      );

      container
          .read(profilesProvider.notifier)
          .updateProfile(
            original.id,
            (profile) =>
                profile.copyWith(url: 'https://example.com/s/other12345678'),
          );
      await container.pump();
      await service.sample();
      up = 160;
      await service.sample();
      await service.upload();
      expect(transport.batches, hasLength(2));
      await service.flush();
    },
  );
}
