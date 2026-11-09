part of '../action.dart';

class SceneApplyState {
  const SceneApplyState({
    this.profileId,
    this.applying = false,
    this.failed = false,
    this.attempted = false,
    this.attemptedScene,
  });

  final int? profileId;
  final bool applying;
  final bool failed;
  final bool attempted;
  final SceneKind? attemptedScene;

  bool matches(int? profileId) => this.profileId == profileId;
}

/// Persists a scene pick and re-applies the profile, following the
/// residential action's discipline: the pick lands first, the apply is
/// forced and silent, and a superseded attempt never reports over a newer
/// one. The pivot group's live selection is moved through the ordinary
/// proxy action afterwards, so what the UI shows and what the core runs
/// stay the same selection.
@Riverpod(keepAlive: true)
class SceneAction extends _$SceneAction {
  var _revision = 0;

  @override
  SceneApplyState build() => const SceneApplyState();

  Future<bool> select(SceneKind scene) async {
    final profile = ref.read(currentProfileProvider);
    if (profile == null || isResidentialPolicyActive(profile)) {
      return false;
    }
    final revision = ++_revision;
    final profileId = profile.id;
    final profileUrl = profile.url;
    final next = profile.overrides.copyWith(scene: scene.storageValue);
    state = SceneApplyState(
      profileId: profileId,
      applying: true,
      attempted: true,
      attemptedScene: scene,
    );
    ref.read(profilesProvider.notifier).put(profile.copyWith(overrides: next));
    var applied = false;
    try {
      applied = await ref
          .read(setupActionProvider.notifier)
          .applyProfile(silence: true, force: true);
    } catch (_) {
      applied = false;
    }
    if (!_isCurrentAttempt(revision, profileId, profileUrl, scene)) {
      return _finishStaleAttempt(revision, profileId, scene);
    }
    if (applied) {
      try {
        applied = await ref
            .read(proxiesActionProvider.notifier)
            .changeProxy(groupName: sceneGroupName, proxyName: scene.groupName);
      } catch (_) {
        applied = false;
      }
      if (!_isCurrentAttempt(revision, profileId, profileUrl, scene)) {
        return _finishStaleAttempt(revision, profileId, scene);
      }
      final root = ref
          .read(groupsProvider)
          .where((group) => group.name == sceneRootGroupName);
      if (applied &&
          root.isNotEmpty &&
          root.first.all.any((proxy) => proxy.name == sceneGroupName)) {
        try {
          applied = await ref
              .read(proxiesActionProvider.notifier)
              .changeProxy(
                groupName: sceneRootGroupName,
                proxyName: sceneGroupName,
              );
        } catch (_) {
          applied = false;
        }
        if (!_isCurrentAttempt(revision, profileId, profileUrl, scene)) {
          return _finishStaleAttempt(revision, profileId, scene);
        }
      }
    }
    final current = _isCurrentAttempt(revision, profileId, profileUrl, scene);
    if (!current) return _finishStaleAttempt(revision, profileId, scene);
    state = SceneApplyState(
      profileId: profileId,
      failed: current && !applied,
      attempted: true,
      attemptedScene: scene,
    );
    return current && applied;
  }

  bool _isCurrentAttempt(
    int revision,
    int profileId,
    String? profileUrl,
    SceneKind scene,
  ) {
    return revision == _revision && _stillCurrent(profileId, profileUrl, scene);
  }

  bool _stillCurrent(int profileId, String? profileUrl, SceneKind scene) {
    if (!ref.mounted || ref.read(currentProfileIdProvider) != profileId) {
      return false;
    }
    final profile = ref.read(profilesProvider).getProfile(profileId);
    return profile?.url == profileUrl &&
        !isResidentialPolicyActive(profile) &&
        profile?.overrides.scene == scene.storageValue;
  }

  bool _finishStaleAttempt(int revision, int profileId, SceneKind scene) {
    if (ref.mounted && revision == _revision) {
      state = SceneApplyState(
        profileId: profileId,
        attempted: true,
        attemptedScene: scene,
      );
    }
    return false;
  }
}
