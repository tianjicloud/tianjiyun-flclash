import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:flutter/widgets.dart';

extension BusinessDashboardCardView on BusinessDashboardCard {
  Glyph get glyph => switch (this) {
    BusinessDashboardCard.residentialLines => AppGlyphs.shuffle,
    BusinessDashboardCard.monthlyTraffic => AppGlyphs.dataUsage,
    BusinessDashboardCard.subscription => AppGlyphs.profiles,
    BusinessDashboardCard.networkTakeover => AppGlyphs.vpn,
    BusinessDashboardCard.aiAvailability => AppGlyphs.verified,
    BusinessDashboardCard.networkSpeed => AppGlyphs.speed,
    BusinessDashboardCard.trafficSavings => AppGlyphs.dataUsage,
    BusinessDashboardCard.proxyGroups => AppGlyphs.layers,
    BusinessDashboardCard.connectionStats => AppGlyphs.connections,
    BusinessDashboardCard.intranetIp => AppGlyphs.devices,
  };

  String label(BuildContext context) {
    final strings = context.appLocalizations;
    return switch (this) {
      BusinessDashboardCard.residentialLines => strings.businessLineTitle,
      BusinessDashboardCard.monthlyTraffic => strings.businessMonthUsed,
      BusinessDashboardCard.subscription => strings.businessSubscriptions,
      BusinessDashboardCard.networkTakeover => strings.networkTakeover,
      BusinessDashboardCard.aiAvailability => strings.businessAiServiceLabel,
      BusinessDashboardCard.networkSpeed => strings.networkSpeed,
      BusinessDashboardCard.trafficSavings => strings.trafficStats,
      BusinessDashboardCard.proxyGroups => strings.proxyGroup,
      BusinessDashboardCard.connectionStats => strings.connectionStats,
      BusinessDashboardCard.intranetIp => strings.intranetIP,
    };
  }

  String? description(BuildContext context) {
    final strings = context.appLocalizations;
    return switch (this) {
      BusinessDashboardCard.monthlyTraffic ||
      BusinessDashboardCard.trafficSavings => strings.trafficStatsDesc,
      BusinessDashboardCard.proxyGroups => strings.proxyGroupsAfterStart,
      BusinessDashboardCard.connectionStats => strings.connectionStatsDesc,
      _ => null,
    };
  }
}
