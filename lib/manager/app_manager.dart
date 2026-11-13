import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/system_dns.dart';
import 'package:fl_clash/common/subscription_expiry.dart';
import 'package:fl_clash/manager/notification_policy.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/mitm.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/common/window_drag_area.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/app_background.dart';
import 'package:fl_clash/ui/business_brand_mark.dart';
import 'package:fl_clash/views/dashboard/business.dart';
import 'package:fl_clash/views/config/advanced.dart';
import 'package:fl_clash/widgets/icon.dart';
import 'package:fl_clash/widgets/business_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStateManager extends ConsumerStatefulWidget {
  final Widget child;
  final App? appPlugin;
  final bool? isAndroid;
  final DateTime Function()? clock;

  const AppStateManager({
    super.key,
    required this.child,
    this.appPlugin,
    this.isAndroid,
    this.clock,
  });

  @override
  ConsumerState<AppStateManager> createState() => _AppStateManagerState();
}

class _AppStateManagerState extends ConsumerState<AppStateManager>
    with WidgetsBindingObserver {
  final _residentialFailures = ResidentialFailureTracker();
  Timer? _residentialTimer;
  bool _brandMarksPrecached = false;
  bool _residentialBackgroundWatching = false;
  String? _residentialExit;
  App? get _app => widget.appPlugin ?? app;
  DateTime get _now => widget.clock?.call() ?? DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_brandMarksPrecached) return;
    _brandMarksPrecached = true;
    precacheBusinessBrandMarks(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_app != null) {
      _app!.onRoute = _handleRoute;
      unawaited(
        _app!.takeInitialRoute().then((route) {
          if (route != null && mounted) _handleRoute(route);
        }),
      );
    }
    ref.listenManual(currentProfileProvider, (_, profile) {
      unawaited(_checkExpiry(profile));
    }, fireImmediately: true);
    _residentialExit = ref.read(residentialPolicyProvider).selectedExit;
    ref.listenManual(
      residentialPolicyProvider.select((state) => state.selectedExit),
      (_, next) {
        if (next != _residentialExit) {
          _residentialExit = next;
          _residentialFailures.observe(
            exit: next ?? '',
            failed: false,
            appVisible: true,
            now: _now,
          );
        }
      },
    );
    // Each finished routed probe is one check of the residential exit; the
    // apply action only runs when the user picks a line.
    ref.listenManual(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
      (previous, entry) {
        if (previous?.phase != ProbePhase.probing ||
            entry.phase == ProbePhase.probing) {
          return;
        }
        _observeResidentialCheck(failed: entry.phase == ProbePhase.failed);
      },
    );
    // A desktop build started to the tray mounts while hidden, and a paused
    // render never runs a post-frame callback.
    scheduleMicrotask(() {
      if (mounted) {
        _updateVisible(WidgetsBinding.instance.lifecycleState);
      }
    });
    ref.listenManual(configProvider, (prev, next) {
      if (prev != next) {
        ref.read(storeActionProvider.notifier).savePreferencesDebounce();
      }
    });
    void syncResidentialTimer() {
      if (!_residentialCheckEligible()) {
        _residentialTimer?.cancel();
        _residentialTimer = null;
        if (_residentialBackgroundWatching) {
          ref.read(outboundIpProbeProvider.notifier).unwatch(routedOutbound);
          _residentialBackgroundWatching = false;
        }
        return;
      }
      if (_residentialTimer != null) return;
      ref.read(outboundIpProbeProvider.notifier).watch(routedOutbound);
      _residentialBackgroundWatching = true;
      _residentialTimer = Timer.periodic(const Duration(minutes: 10), (_) {
        if (_residentialCheckEligible()) {
          ref.read(outboundIpProbeProvider.notifier).recheck(routedOutbound);
        } else {
          syncResidentialTimer();
        }
      });
    }

    ref.listenManual(
      appSettingProvider.select((state) => state.backgroundResidentialCheck),
      (_, _) => syncResidentialTimer(),
    );
    ref.listenManual(coreStatusProvider, (_, _) => syncResidentialTimer());
    ref.listenManual(
      residentialPolicyProvider.select((state) => state.active),
      (_, _) => syncResidentialTimer(),
    );
    ref.listenManual(appVisibleProvider, (_, _) => syncResidentialTimer());
    syncResidentialTimer();
    ref.listenManual(groupsProvider, (prev, next) {
      if (prev != next) {
        unawaited(precacheTargetIcons(next.map((group) => group.icon)));
      }
    }, fireImmediately: true);
    ref.listenManual(iconSetsProvider, (_, next) {
      if (next.value case final iconSets?) {
        unawaited(
          precacheTargetIcons(iconSets.map((iconSet) => iconSet.cover)),
        );
      }
    }, fireImmediately: true);
    ref.listenManual(needUpdateGroupsProvider, (prev, next) {
      if (prev != next) {
        ref.read(proxiesActionProvider.notifier).updateGroupsDebounce();
      }
    });
    ref.listenManual(suspendProvider, (prev, next) {
      if (prev != next) {
        ref.read(setupActionProvider.notifier).syncSuspend();
      }
    });
    final systemDns = systemDnsCoordinator;
    if (systemDns != null) {
      ref.listenManual(shouldPatchSystemDnsProvider, (prev, next) {
        unawaited(systemDns.sync(next));
      }, fireImmediately: true);
    }
  }

  bool _residentialCheckEligible() =>
      ref.read(appSettingProvider).backgroundResidentialCheck &&
      ref.read(coreStatusProvider) == CoreStatus.connected &&
      ref.read(residentialPolicyProvider).active &&
      !ref.read(appVisibleProvider);

  void _observeResidentialCheck({required bool failed}) {
    final profile = ref.read(currentProfileProvider);
    final policy = ref.read(residentialPolicyProvider);
    final exit = policy.selectedExit;
    if (!isTianjiSubscriptionProfile(profile) ||
        !policy.active ||
        exit == null ||
        ref.read(coreStatusProvider) != CoreStatus.connected) {
      if (_residentialExit != null) {
        _residentialFailures.observe(
          exit: _residentialExit!,
          failed: false,
          appVisible: true,
          now: _now,
        );
      }
      return;
    }
    final notify = _residentialFailures.observe(
      exit: exit,
      failed: failed,
      appVisible: ref.read(appVisibleProvider),
      now: _now,
    );
    if (notify) unawaited(_sendResidentialFailure(exit));
  }

  void _handleRoute(String value) {
    final page = businessNotificationRoutePage(
      value,
      business: isTianjiSubscriptionProfile(ref.read(currentProfileProvider)),
    );
    if (page == null) return;
    ref.read(currentPageLabelProvider.notifier).toPage(page);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (value == 'residential') showResidentialExitSheet(context);
      if (value == 'outboundMode') {
        showExtend(
          context,
          builder: (_) => const AdvancedConfigView(isAndroid: true),
        );
      }
      if (value == 'residentialRetry') {
        ref.read(outboundIpProbeProvider.notifier).recheck(routedOutbound);
      }
    });
  }

  Future<void> _sendResidentialFailure(String line) async {
    if (ref.read(appVisibleProvider)) return;
    final prefs = Preferences();
    final key = 'residential:${Uri.encodeComponent(line)}';
    final previous = await prefs.getEventDate(key);
    final now = _now;
    if (previous != null &&
        now.millisecondsSinceEpoch - previous <
            const Duration(minutes: 30).inMilliseconds) {
      return;
    }
    final sent = await _app?.sendEventNotification(
      kind: 'residentialFailure',
      title: currentAppLocalizations.residentialNoticeTitle,
      body: currentAppLocalizations.residentialNoticeBody(line),
      channelName: currentAppLocalizations.eventAlerts,
      route: 'residential',
      changeText: currentAppLocalizations.residentialNoticeChange,
      retryText: currentAppLocalizations.residentialNoticeRetry,
    );
    if (sent == true) await prefs.setEventDate(key, now.millisecondsSinceEpoch);
  }

  Future<void> _checkExpiry(Profile? profile) async {
    if (!(widget.isAndroid ?? system.isAndroid) ||
        profile?.subscriptionExpiryNotifications == false ||
        !isTianjiSubscriptionProfile(profile)) {
      return;
    }
    final expiry = profileExpiryOf(profile);
    if (expiry == null) return;
    final days = profileDaysLeft(expiry);
    if (days < 1 || days > 7) return;
    final now = _now;
    final day = now.year * 10000 + now.month * 100 + now.day;
    final prefs = Preferences();
    if (!shouldSendSubscriptionExpiry(
      daysLeft: days,
      lastSentDay: await prefs.getEventDate('subscriptionExpiry'),
      today: day,
    )) {
      return;
    }
    final sent = await _app?.sendEventNotification(
      kind: 'subscriptionExpiry',
      title: currentAppLocalizations.subscriptionExpiryNoticeTitle(days),
      body: currentAppLocalizations.subscriptionExpiryNoticeBody(
        profile!.realLabel,
        expiry.show,
      ),
      channelName: currentAppLocalizations.eventAlerts,
      route: 'subscription',
    );
    if (sent == true) await prefs.setEventDate('subscriptionExpiry', day);
  }

  @override
  void dispose() {
    _residentialTimer?.cancel();
    if (_residentialBackgroundWatching) {
      ref.read(outboundIpProbeProvider.notifier).unwatch(routedOutbound);
    }
    WidgetsBinding.instance.removeObserver(this);
    _app?.onRoute = null;
    super.dispose();
  }

  void _updateVisible(AppLifecycleState? state) {
    ref.read(appVisibleProvider.notifier).value = switch (state) {
      null || AppLifecycleState.resumed || AppLifecycleState.inactive => true,
      AppLifecycleState.hidden ||
      AppLifecycleState.paused ||
      AppLifecycleState.detached => false,
    };
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    _updateVisible(state);
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      if (_residentialFailures.shouldSendOnBackground &&
          _residentialExit != null) {
        unawaited(_sendResidentialFailure(_residentialExit!));
      }
    }
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(locationPermissionsProvider.notifier).refresh());
      // A certificate removed meanwhile stops decryption before the next start.
      if (mitmFeature && ref.read(patchClashConfigProvider).mitm.enable) {
        unawaited(ref.read(mitmTrustStateProvider.notifier).refresh());
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref.read(routeTrackerProvider.notifier).markResumed();
      });
    }
  }

  @override
  void didChangePlatformBrightness() {
    ref.read(themeActionProvider.notifier).updateBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class AppEnvManager extends ConsumerWidget {
  final Widget child;

  const AppEnvManager({super.key, required this.child});

  String? _bannerMessage({required bool safeMode}) {
    if (safeMode) {
      return 'SAFE MODE';
    }
    if (!globalState.isPre) {
      return null;
    }
    return kDebugMode ? 'DEBUG' : globalState.appEnv.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = _bannerMessage(safeMode: ref.watch(safeModeProvider));
    if (message == null) {
      return child;
    }
    return Banner(
      message: message,
      location: BannerLocation.topEnd,
      child: child,
    );
  }
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({
    required this.items,
    required this.currentIndex,
    required this.viewMode,
    required this.onSelected,
    required this.business,
  });

  final List<NavigationItem> items;
  final int currentIndex;
  final ViewMode viewMode;
  final void Function(int index) onSelected;
  final bool business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canExpand = canExpandSidebar(viewMode);
    final sidebarExpanded = ref.watch(
      appSettingProvider.select((state) => state.sidebarExpanded),
    );
    final version = ref.watch(versionProvider);
    final windowControls = windowControlsOverSidebar(
      isMacOS: system.isMacOS,
      version: version,
    );
    final Widget sidebar;
    if (business && viewMode != ViewMode.mobile) {
      sidebar = BusinessNavigationSidebar(
        items: items,
        currentIndex: currentIndex,
        expanded: canExpand && sidebarExpanded,
        onSelected: onSelected,
        windowControls: windowControls,
      );
    } else {
      sidebar = NavigationSidebar(
        destinations: [
          for (final item in items)
            SidebarDestination(glyph: item.glyph, label: item.label.label),
        ],
        selectedIndex: currentIndex,
        expanded: canExpand && sidebarExpanded,
        onSelected: onSelected,
        onToggle: canExpand
            ? () {
                ref
                    .read(appSettingProvider.notifier)
                    .update(
                      (state) => state.copyWith(
                        sidebarExpanded: !state.sidebarExpanded,
                      ),
                    );
              }
            : null,
        windowControls: windowControls,
      );
    }
    if (!system.isMacOS) return sidebar;
    return Stack(
      children: [
        sidebar,
        PositionedDirectional(
          start: 0,
          top: 0,
          end: 0,
          height: macOSTrafficLightsArea.height,
          child: const MacOSWindowDragArea(
            enabled: true,
            child: SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class AppSidebarContainer extends ConsumerWidget {
  final Widget child;

  const AppSidebarContainer({super.key, required this.child});

  void _updateSideBarWidth(WidgetRef ref, double contentWidth) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sideWidthProvider.notifier).value =
          ref.read(viewSizeProvider.select((state) => state.width)) -
          contentWidth;
    });
  }

  void _handleToPage(WidgetRef ref, PageLabel pageLabel) {
    final focusNode = FocusManager.instance.primaryFocus;
    final focusContext = focusNode?.context;
    final preserveNavigationFocus =
        focusContext?.findAncestorWidgetOfExactType<NavigationSidebar>() !=
            null ||
        focusContext
                ?.findAncestorWidgetOfExactType<BusinessNavigationSidebar>() !=
            null;
    ref.read(currentPageLabelProvider.notifier).toPage(pageLabel);
    if (!preserveNavigationFocus || focusNode == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNode.context != null && focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationStateProvider);
    final navigationItems = navigationState.navigationItems;
    final viewMode = navigationState.viewMode;
    final currentIndex = navigationState.currentIndex;
    final backdropOpacity = ref.watch(windowBlurProvider);
    final wallpaper = AppBackgroundScope.hasImage(context);
    final page = MacOSStyle.of(context)
        ? context.colorScheme.surface
        : SurfaceLevel.page.colorOf(context.colorScheme);
    final chrome = context.colorScheme.chromeSurface;
    final isBusiness = isTianjiSubscriptionProfile(
      ref.watch(currentProfileProvider),
    );
    final customBusinessSidebar = isBusiness && viewMode != ViewMode.mobile;
    void onSelected(int index) {
      _handleToPage(ref, navigationItems[index].label);
    }

    final hasSidebar = viewMode != ViewMode.mobile;
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    return AppBackground(
      child: Container(
        color: wallpaper || backdropOpacity != null ? Colors.transparent : page,
        child: Row(
          children: [
            AnimatedVisibility.sidebar(
              visible: hasSidebar,
              child: Surface(
                color: customBusinessSidebar || wallpaper
                    ? Colors.transparent
                    : backdropOpacity != null
                    ? chrome.withValues(alpha: backdropOpacity)
                    : chrome,
                shape: BorderDirectional(
                  end: Divider.createBorderSide(context),
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeLeft: !isLtr,
                  removeRight: isLtr,
                  child: _Sidebar(
                    items: navigationItems,
                    currentIndex: currentIndex,
                    viewMode: viewMode,
                    onSelected: onSelected,
                    business: isBusiness,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRect(
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    _updateSideBarWidth(ref, constraints.maxWidth);
                    return MediaQuery.removePadding(
                      context: context,
                      removeLeft: hasSidebar && isLtr,
                      removeRight: hasSidebar && !isLtr,
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
