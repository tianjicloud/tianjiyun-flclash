import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/models/common.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupsCatalogSource {
  const GroupsCatalogSource({
    this.profileId,
    this.url,
    this.loaded = false,
  });

  final int? profileId;
  final String? url;
  final bool loaded;

  bool matches(int? profileId, String? url) =>
      loaded && this.profileId == profileId && this.url == url;
}

class GroupsSourceProfile extends Notifier<GroupsCatalogSource> {
  @override
  GroupsCatalogSource build() => const GroupsCatalogSource();

  void set({required int profileId, required String url}) {
    state = GroupsCatalogSource(profileId: profileId, url: url, loaded: true);
  }

  void clear() {
    state = const GroupsCatalogSource();
  }
}

final groupsSourceProfileProvider =
    NotifierProvider<GroupsSourceProfile, GroupsCatalogSource>(
      GroupsSourceProfile.new,
    );

final residentialPolicyProvider = Provider<ResidentialPolicy>((ref) {
  final profile = ref.watch(currentProfileProvider);
  final source = ref.watch(groupsSourceProfileProvider);
  final ready = source.matches(profile?.id, profile?.url);
  final groups = ready ? ref.watch(groupsProvider) : const <Group>[];
  return buildResidentialPolicy(
    profile: profile,
    groups: groups,
    catalogReady: ready,
  );
});
