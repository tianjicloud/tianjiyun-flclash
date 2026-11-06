import 'package:fl_clash/common/onboarding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/onboarding.g.dart';

sealed class OnboardingState {
  const OnboardingState();

  bool get isInProgress => switch (this) {
    OnboardingWelcome() || OnboardingDone() => false,
    _ => true,
  };
}

final class OnboardingWelcome extends OnboardingState {
  const OnboardingWelcome();
}

final class OnboardingConfirm extends OnboardingState {
  const OnboardingConfirm(this.url);

  final String url;
}

final class OnboardingImporting extends OnboardingState {
  const OnboardingImporting();
}

final class OnboardingImported extends OnboardingState {
  const OnboardingImported({required this.profileId, required this.proxyCount});

  final int profileId;
  final int proxyCount;
}

final class OnboardingFailed extends OnboardingState {
  const OnboardingFailed(this.failure, {this.url});

  final ImportFailure failure;
  final String? url;
}

final class OnboardingConnecting extends OnboardingState {
  const OnboardingConnecting({
    required this.profileId,
    required this.proxyCount,
  });

  final int profileId;
  final int proxyCount;
}

final class OnboardingConnected extends OnboardingState {
  const OnboardingConnected({
    required this.profileId,
    required this.proxyCount,
  });

  final int profileId;
  final int proxyCount;
}

final class OnboardingDone extends OnboardingState {
  const OnboardingDone();
}

@Riverpod(keepAlive: true)
class Onboarding extends _$Onboarding {
  @override
  OnboardingState build() {
    return const OnboardingWelcome();
  }

  void welcome() {
    state = const OnboardingWelcome();
  }

  void confirm(String url) {
    state = OnboardingConfirm(url);
  }

  void importing() {
    state = const OnboardingImporting();
  }

  void imported({required int profileId, required int proxyCount}) {
    state = OnboardingImported(profileId: profileId, proxyCount: proxyCount);
  }

  void failed(ImportFailure failure, {String? url}) {
    state = OnboardingFailed(failure, url: url);
  }

  void connecting() {
    final current = state;
    if (current is OnboardingImported) {
      state = OnboardingConnecting(
        profileId: current.profileId,
        proxyCount: current.proxyCount,
      );
    }
  }

  void connected() {
    state = switch (state) {
      OnboardingConnecting(:final profileId, :final proxyCount) =>
        OnboardingConnected(profileId: profileId, proxyCount: proxyCount),
      OnboardingConnected() => state,
      _ => state,
    };
  }

  void connectFailed() {
    if (state case OnboardingConnecting(:final profileId, :final proxyCount)) {
      state = OnboardingImported(profileId: profileId, proxyCount: proxyCount);
    }
  }

  void finish() {
    state = const OnboardingDone();
  }
}
