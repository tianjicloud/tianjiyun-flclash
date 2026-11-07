import 'package:fl_clash/core/traffic/auth.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/core/residential_bulk.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/common.dart';
import 'package:fl_clash/models/profile.dart';

TianjiTrafficProfile? resolveTianjiProfile(Profile? profile) {
  if (profile == null || profile.type != ProfileType.url) {
    return null;
  }
  return TianjiTrafficProfile.resolve(
    profileId: profile.id.toString(),
    url: profile.url,
  );
}

bool isTianjiSubscriptionProfile(Profile? profile) {
  return resolveTianjiProfile(profile) != null;
}

bool isResidentialPolicyActive(Profile? profile) {
  final resolved = resolveTianjiProfile(profile);
  final entry = profile?.overrides.residentialExit;
  return resolved != null &&
      entry != null &&
      entry.isNotEmpty &&
      profile?.overrides.residentialSubscriptionFingerprint ==
          resolved.fingerprint;
}

ResidentialPolicy buildResidentialPolicy({
  required Profile? profile,
  required List<Group> groups,
  required bool catalogReady,
}) {
  final resolved = resolveTianjiProfile(profile);
  final configured = profile?.overrides.residentialExit;
  final active = isResidentialPolicyActive(profile);
  final graph = residentialGraphOfGroups(groups);
  final rootAvailable = graph.hasRoot;
  final choices = graph.choices;
  return ResidentialPolicy(
    profileId: profile?.id,
    fingerprint: resolved?.fingerprint,
    configuredExit: configured,
    selectedExit: active ? configured : null,
    active: active,
    rootAvailable: rootAvailable,
    choices: choices,
    catalogReady: catalogReady,
    bulkBypass: groups.getGroup(residentialBulkGroup) != null,
    rejected:
        groups
            .getGroup(tianjiResidentialLockedGroupName)
            ?.all
            .any((proxy) => proxy.name == 'REJECT') ??
        false,
  );
}

ResidentialGraph residentialGraphOfGroups(List<Group> groups) {
  final groupNames = {for (final group in groups) group.name};
  return ResidentialGraph(
    groups: {
      for (final group in groups)
        group.name: [for (final member in group.all) member.name],
    },
    proxies: {
      for (final group in groups)
        for (final member in group.all)
          if (!groupNames.contains(member.name)) member.name: member.type,
    },
  );
}

class ResidentialPolicy {
  const ResidentialPolicy({
    required this.profileId,
    required this.fingerprint,
    required this.configuredExit,
    required this.selectedExit,
    required this.active,
    required this.rootAvailable,
    required this.choices,
    required this.catalogReady,
    this.rejected = false,
    this.bulkBypass = false,
  });

  final int? profileId;
  final String? fingerprint;
  final String? configuredExit;
  final String? selectedExit;
  final bool active;
  final bool rootAvailable;
  final List<String> choices;
  final bool catalogReady;
  final bool rejected;
  final bool bulkBypass;

  bool get hasPlan => rootAvailable && choices.isNotEmpty;

  bool get missingExit =>
      active && (rejected || !choices.contains(configuredExit));

  bool get usingSubscriptionPolicy => !active;
}
