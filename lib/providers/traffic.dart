import 'dart:async';

import 'package:fl_clash/core/traffic/auth.dart';
import 'package:fl_clash/core/traffic/report.dart';
import 'package:fl_clash/core/traffic/service.dart';
import 'package:fl_clash/core/traffic/store.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/core.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trafficSessionCacheProvider = Provider<TrafficSessionCache>(
  (ref) => TrafficSessionCache(),
);

final trafficSessionTransportProvider = Provider<TrafficSessionTransport>(
  (ref) => const HttpTrafficSessionTransport(),
);

typedef TrafficAuthenticatorFactory =
    TrafficReportAuthenticator Function(TianjiTrafficProfile profile);

final trafficAuthenticatorFactoryProvider =
    Provider<TrafficAuthenticatorFactory>((ref) {
      final transport = ref.watch(trafficSessionTransportProvider);
      final cache = ref.watch(trafficSessionCacheProvider);
      return (profile) => TianjiTrafficAuthenticator(
        profile: profile,
        transport: transport,
        cache: cache,
      );
    });

final trafficReportTransportProvider = Provider<TrafficReportTransport>(
  (ref) => const HttpTrafficReportTransport(),
);

@visibleForTesting
TianjiTrafficProfile? resolveTianjiTrafficProfile(Profile? profile) {
  if (profile == null || profile.type != ProfileType.url) return null;
  return TianjiTrafficProfile.resolve(
    profileId: profile.id.toString(),
    url: profile.url,
  );
}

final trafficStatsProvider = Provider<TrafficAccountingService>((ref) {
  final service = TrafficAccountingService(
    store: const PreferencesTrafficStatsStore(),
    readSnapshot: () => ref.read(coreHandlerProvider).getTrafficStats(),
  );
  ref.onDispose(service.dispose);

  final authenticatorFactory = ref.read(trafficAuthenticatorFactoryProvider);
  final reportTransport = ref.read(trafficReportTransportProvider);
  String? reportingIdentity;

  void applyReporting(Profile? profile) {
    final tianji = resolveTianjiTrafficProfile(profile);
    unawaited(service.setScope(tianji?.identityKey ?? profile?.id.toString()));
    if (tianji == null) {
      reportingIdentity = null;
      service.stopReporting();
      return;
    }
    if (reportingIdentity == tianji.identityKey) return;
    reportingIdentity = tianji.identityKey;
    service.configureReporting(
      options: TrafficReportOptions(
        endpoint: tianji.reportEndpoint,
        identityKey: tianji.identityKey,
        authenticator: authenticatorFactory(tianji),
      ),
      transport: reportTransport,
    );
  }

  ref.listen(
    currentProfileProvider.select(
      (profile) => (profile?.id, profile?.type, profile?.url),
    ),
    (_, _) => applyReporting(ref.read(currentProfileProvider)),
    fireImmediately: true,
  );
  unawaited(service.start());
  return service;
});
