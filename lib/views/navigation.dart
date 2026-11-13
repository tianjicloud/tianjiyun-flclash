import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/ui/icons/app_glyphs.dart';
import 'package:fl_clash/views/views.dart';

class Navigation implements NavigationPort {
  static Navigation? _instance;

  Navigation._internal({SupportPlatform? platform})
    : _platform = platform ?? SupportPlatform.currentPlatform;

  final SupportPlatform _platform;

  @override
  List<NavigationItem> getItems({
    bool openLogs = false,
    bool hasProxies = false,
  }) {
    return [
      NavigationItem(
        glyph: AppGlyphs.dashboard,
        label: PageLabel.dashboard,
        builder: (_) => const DashboardView(),
      ),
      NavigationItem(
        glyph: AppGlyphs.proxies,
        label: PageLabel.proxies,
        builder: (_) => const ProxiesView(),
        modes: hasProxies
            ? [NavigationItemMode.mobile, NavigationItemMode.desktop]
            : [],
      ),
      if (_platform == SupportPlatform.MacOS)
        NavigationItem(
          glyph: AppGlyphs.residential,
          label: PageLabel.residential,
          builder: (_) => const ResidentialView(),
        ),
      NavigationItem(
        glyph: AppGlyphs.profiles,
        label: PageLabel.profiles,
        builder: (_) => const ProfilesView(),
      ),
      NavigationItem(
        glyph: AppGlyphs.requests,
        label: PageLabel.requests,
        builder: (_) => const RequestsView(),
        modes: [NavigationItemMode.desktop, NavigationItemMode.moreFull],
      ),
      NavigationItem(
        glyph: AppGlyphs.dns,
        label: PageLabel.dns,
        builder: (_) => const DnsResourcesView(),
        modes: [NavigationItemMode.moreFull],
      ),
      NavigationItem(
        glyph: AppGlyphs.resources,
        label: PageLabel.resources,
        builder: (_) => const ResourcesView(),
        modes: [NavigationItemMode.more],
      ),
      NavigationItem(
        glyph: AppGlyphs.logs,
        label: PageLabel.logs,
        builder: (_) => const LogsView(),
        modes: openLogs
            ? [NavigationItemMode.desktop, NavigationItemMode.more]
            : [],
      ),
      NavigationItem(
        glyph: AppGlyphs.tools,
        label: PageLabel.tools,
        builder: (_) => const ToolsView(),
        modes: [NavigationItemMode.desktop, NavigationItemMode.mobile],
      ),
    ];
  }

  factory Navigation() {
    _instance ??= Navigation._internal();
    return _instance!;
  }

  Navigation.forPlatform(SupportPlatform platform)
    : this._internal(platform: platform);
}

final navigation = Navigation();
