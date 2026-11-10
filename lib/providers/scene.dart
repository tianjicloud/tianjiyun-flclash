import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/models/common.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/residential.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SceneUnconfirmedState {
  const SceneUnconfirmedState({this.profileId, this.value = false});

  final int? profileId;
  final bool value;
}

class SceneUnconfirmed extends Notifier<SceneUnconfirmedState> {
  @override
  SceneUnconfirmedState build() => const SceneUnconfirmedState();

  void set({required int? profileId, required bool unconfirmed}) {
    state = SceneUnconfirmedState(profileId: profileId, value: unconfirmed);
  }
}

final sceneUnconfirmedProvider =
    NotifierProvider<SceneUnconfirmed, SceneUnconfirmedState>(
      SceneUnconfirmed.new,
    );

/// What the scene switch can honestly show for the current profile: whether
/// the subscription carries the scene pivot at all, and which scene the
/// saved pick names. Apply state lives in the scene action's own state.
class ScenePolicy {
  const ScenePolicy({
    required this.available,
    required this.current,
    required this.suspended,
    this.unconfirmed = false,
  });

  final bool available;
  final SceneKind? current;

  /// A residential exit owns the profile: scene picks stay stored but the
  /// assembly skips the scene transform until the exit is released.
  final bool suspended;
  final bool unconfirmed;
}

/// Scene availability mirrors the residential policy's catalog discipline:
/// groups only count once the loaded catalog is known to belong to the
/// current profile, so a stale group list never lights the switch up.
final scenePolicyProvider = Provider<ScenePolicy>((ref) {
  final profile = ref.watch(currentProfileProvider);
  final source = ref.watch(groupsSourceProfileProvider);
  final ready = source.matches(profile?.id, profile?.url);
  final groups = ready ? ref.watch(groupsProvider) : const <Group>[];
  final pivot = groups.where((group) => group.name == sceneGroupName);
  var available = false;
  SceneKind? current;
  if (pivot.isNotEmpty) {
    final selected = ref.watch(selectedProxyNameProvider(sceneGroupName));
    current = sceneKindOfSelection(selected);
    available =
        current != null ||
        pivot.first.all.any(
          (proxy) => sceneKindOfSelection(proxy.name) != null,
        );
  }
  final stored = profile?.overrides.scene;
  final application = ref.watch(sceneUnconfirmedProvider);
  return ScenePolicy(
    available: available,
    current: current ?? sceneKindOfSelection(stored),
    suspended: isResidentialPolicyActive(profile),
    unconfirmed: application.profileId == profile?.id && application.value,
  );
});
