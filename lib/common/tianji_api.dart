import 'dart:convert';

import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/l10n/l10n.dart';

const tianjiApiRoot = 'https://wnq3g3p59e.qovari.net';
const tianjiEgressUrl = '$tianjiApiRoot/v1/egress';
const tianjiNodesUrl = '$tianjiApiRoot/v1/nodes';

IpInfo? parseTianjiEgress(String body) {
  try {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final ip = json['ip'];
    if (ip is! String || ip.isEmpty) return null;
    final code = json['country_code'];
    final exitData = json['exit'];
    final exit = exitData is Map<String, dynamic>
        ? EgressExit(
            kind: switch (exitData['kind']) {
              'residential' => 'residential',
              'datacenter' => 'datacenter',
              _ => 'unknown',
            },
            countryCode: exitData['country_code'] is String
                ? exitData['country_code'] as String
                : null,
            pool: exitData['pool'] is String
                ? exitData['pool'] as String
                : null,
          )
        : null;
    return IpInfo(
      ip: ip,
      countryCode: code is String ? code : null,
      asn: json['asn'] is int ? json['asn'] as int : null,
      isp: json['isp'] is String ? json['isp'] as String : null,
      region: json['region'] is String ? json['region'] as String : null,
      exit: exit,
      fromTianji: true,
    );
  } on Object {
    return null;
  }
}

TianjiNodes parseTianjiNodes(String body) {
  final nodes = TianjiNodes.fromJson(jsonDecode(body) as Map<String, Object?>);
  return nodes.copyWith(
    nodes: [
      for (final node in nodes.nodes)
        if (node.expectedExit case final exit?)
          node.copyWith(
            expectedExit: switch (exit.kind) {
              'residential' || 'datacenter' => exit,
              _ => exit.copyWith(kind: 'unknown'),
            },
          )
        else
          node,
    ],
  );
}

String localizedRegion(AppLocalizations strings, String? code) =>
    switch (code) {
      'JP' => strings.businessRegionJP,
      'HK' => strings.businessRegionHK,
      'US' => strings.businessRegionUS,
      'SG' => strings.businessRegionSG,
      'DE' => strings.businessRegionDE,
      'GB' => strings.businessRegionGB,
      'TW' => strings.businessRegionTW,
      'CA' => strings.businessRegionCA,
      'FR' => strings.businessRegionFR,
      'AT' => strings.businessRegionAT,
      'AU' => strings.businessRegionAU,
      'BR' => strings.businessRegionBR,
      'CO' => strings.businessRegionCO,
      'CZ' => strings.businessRegionCZ,
      'KR' => strings.businessRegionKR,
      'RO' => strings.businessRegionRO,
      'SE' => strings.businessRegionSE,
      'BE' => strings.businessRegionBE,
      'IT' => strings.businessRegionIT,
      _ => code ?? '',
    };
