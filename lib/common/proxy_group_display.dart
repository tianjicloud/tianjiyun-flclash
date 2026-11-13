import 'package:fl_clash/enum/enum.dart';

GroupType? proxyGroupTypeOf(String value) => switch (value.toLowerCase()) {
  'url-test' || 'urltest' => GroupType.URLTest,
  'select' || 'selector' => GroupType.Selector,
  'fallback' => GroupType.Fallback,
  'load-balance' || 'loadbalance' => GroupType.LoadBalance,
  'relay' => GroupType.Relay,
  _ => null,
};
