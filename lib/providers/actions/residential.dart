part of '../action.dart';

class ResidentialApplyState {
  const ResidentialApplyState({
    this.profileId,
    this.fingerprint,
    this.applying = false,
    this.failed = false,
    this.error,
    this.attempted = false,
    this.attemptedExit,
    this.resetFailed = false,
  });

  final int? profileId;
  final String? fingerprint;
  final bool applying;
  final bool failed;
  final Object? error;
  final bool attempted;
  final String? attemptedExit;
  final bool resetFailed;

  bool matches(int? profileId, String? fingerprint) =>
      this.profileId == profileId && this.fingerprint == fingerprint;
}

@Riverpod(keepAlive: true)
class ResidentialAction extends _$ResidentialAction {
  var _revision = 0;

  @override
  ResidentialApplyState build() => const ResidentialApplyState();

  Future<bool> select(String exit) => _commit(exit);

  Future<bool> clear() => _commit(null);

  Future<bool> retry() {
    final policy = ref.read(residentialPolicyProvider);
    final attempted =
        state.attempted && state.matches(policy.profileId, policy.fingerprint);
    if (attempted) {
      return _commit(state.attemptedExit);
    }
    final exit = policy.configuredExit;
    if (exit == null || exit.isEmpty) {
      return Future.value(false);
    }
    return _commit(exit);
  }

  Future<bool> _commit(String? exit) async {
    final profile = ref.read(currentProfileProvider);
    final resolved = resolveTianjiProfile(profile);
    if (profile == null || resolved == null) {
      return false;
    }
    final revision = ++_revision;
    final profileId = profile.id;
    final fingerprint = resolved.fingerprint;
    final next = profile.overrides.copyWith(
      residentialExit: exit,
      residentialSubscriptionFingerprint: exit == null ? null : fingerprint,
    );
    state = ResidentialApplyState(
      profileId: profileId,
      fingerprint: fingerprint,
      applying: true,
      attempted: true,
      attemptedExit: exit,
    );
    ref.read(profilesProvider.notifier).put(profile.copyWith(overrides: next));
    var applied = false;
    Object? error;
    try {
      applied = await ref
          .read(setupActionProvider.notifier)
          .applyProfile(silence: true, force: true);
    } catch (e) {
      error = e;
    }
    if (revision != _revision) {
      return false;
    }
    if (!_stillCurrent(profileId, fingerprint, exit)) {
      state = ResidentialApplyState(
        profileId: profileId,
        fingerprint: fingerprint,
        attempted: true,
        attemptedExit: exit,
      );
      return false;
    }
    var resetFailed = false;
    if (applied) {
      resetFailed = !await _resetConnections(
        () =>
            revision == _revision &&
            _stillCurrent(profileId, fingerprint, exit),
      );
    }
    if (revision != _revision) {
      return false;
    }
    final current = _stillCurrent(profileId, fingerprint, exit);
    state = ResidentialApplyState(
      profileId: profileId,
      fingerprint: fingerprint,
      failed: current && !applied,
      error: error,
      attempted: true,
      attemptedExit: exit,
      resetFailed: current && resetFailed,
    );
    return current && applied && !resetFailed;
  }

  bool _stillCurrent(int profileId, String fingerprint, String? exit) {
    if (ref.read(currentProfileIdProvider) != profileId) {
      return false;
    }
    final profile = ref.read(profilesProvider).getProfile(profileId);
    return resolveTianjiProfile(profile)?.fingerprint == fingerprint &&
        profile?.overrides.residentialExit == exit &&
        profile?.overrides.residentialSubscriptionFingerprint ==
            (exit == null ? null : fingerprint);
  }

  Future<bool> _resetConnections(bool Function() isCurrent) async {
    try {
      final core = ref.read(coreHandlerProvider);
      await core.closeConnections();
      if (!isCurrent()) return false;
      await core.resetConnections();
      return isCurrent();
    } catch (error) {
      commonPrint.log(
        'residential connection reset failed: ${compactError(error)}',
        logLevel: coreFailureLogLevel(error),
      );
      return false;
    }
  }
}
