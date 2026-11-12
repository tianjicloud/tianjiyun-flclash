import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/common/tianji_api.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/providers/residential.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'core.dart';
import 'route_state.dart';
import 'state.dart';
import 'routed_probe.dart';
import 'tianji_nodes.dart';

part 'generated/outbound_ip.g.dart';

/// Keyed by the outbound a lookup pins: a node name, `DIRECT`, or
/// [routedOutbound] for whatever the rules pick right now.
@Riverpod(keepAlive: true)
class OutboundIpProbe extends _$OutboundIpProbe
    with RoutedProbe<String, IpInfo> {
  DateTime? _tianjiCooldownUntil;
  @override
  RoutedProbeState<String, IpInfo> build() => buildProbe();

  @override
  bool get allowBackgroundProbe =>
      ref.read(appSettingProvider).backgroundResidentialCheck &&
      ref.read(residentialPolicyProvider).active &&
      ref.read(coreStatusProvider) == CoreStatus.connected &&
      !ref.read(suspendProvider);

  @override
  bool canProbeInBackground(String target) =>
      target == routedOutbound && allowBackgroundProbe;

  @override
  Future<Map<String, ProbeAnswer<IpInfo>>> probe(
    String target,
    RouteState route,
  ) async {
    final proxyName = target == routedOutbound && !route.proxied
        ? directOutbound
        : target;
    final core = ref.read(coreHandlerProvider);
    final business = ref.read(tianjiApiEnabledProvider);
    OutboundIpResult? result;
    IpInfo? value;
    if (business &&
        (_tianjiCooldownUntil == null ||
            DateTime.now().isAfter(_tianjiCooldownUntil!))) {
      result = await lookupOutboundIp(core, proxyName, urls: [tianjiEgressUrl]);
      value = parseTianjiEgress(result.body);
      if (value == null || result.error != null) {
        _tianjiCooldownUntil = DateTime.now().add(const Duration(seconds: 60));
        result = null;
      } else {
        _tianjiCooldownUntil = null;
      }
    }
    result ??= await lookupOutboundIp(core, proxyName);
    value ??= parseOutboundIp(result);
    final exit = result.chains.firstOrNull;
    return {
      target: ProbeAnswer(
        value: value,
        coreEpoch: result.coreEpoch,
        routeVersion: result.routeVersion,
        hits: result.hits,
        chains: result.chains,
      ),
      // A node leaves through the same address whatever it is asked for.
      if (value != null && exit != null && exit != target)
        exit: ProbeAnswer(
          value: value,
          coreEpoch: result.coreEpoch,
          routeVersion: result.routeVersion,
          hits: result.nodeHits,
        ),
    };
  }
}
