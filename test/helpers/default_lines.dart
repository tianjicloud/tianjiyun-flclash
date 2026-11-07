import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';

const defaultLineTestGroups = [
  Group(
    name: appName,
    type: GroupType.Selector,
    now: '⚡ 自动选择',
    all: [
      Proxy(name: '⚡ 自动选择', type: 'URLTest'),
      Proxy(name: '📍 指定节点', type: 'Selector'),
    ],
  ),
  Group(
    name: '⚡ 自动选择',
    type: GroupType.URLTest,
    now: 'HK transport',
    all: [Proxy(name: 'HK transport', type: 'ss')],
  ),
  Group(
    name: '📍 指定节点',
    type: GroupType.Selector,
    now: 'Tokyo',
    all: [
      Proxy(name: 'Tokyo', type: 'URLTest'),
      Proxy(name: 'Hong Kong', type: 'ss'),
    ],
  ),
  Group(
    name: 'Tokyo',
    type: GroupType.URLTest,
    now: 'Tokyo transport',
    all: [Proxy(name: 'Tokyo transport', type: 'ss')],
  ),
  Group(
    name: 'AI',
    type: GroupType.Selector,
    now: 'AI auto',
    all: [Proxy(name: 'AI auto', type: 'URLTest')],
  ),
];
