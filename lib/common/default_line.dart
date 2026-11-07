import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';

const _manualGroupName = '📍 指定节点';
const _automaticGroupName = '⚡ 自动选择';
const _nonProxyTypes = {'direct', 'reject', 'rejectdrop', 'pass', 'dns'};

typedef DefaultLineChoice = ({
  String name,
  String rootTarget,
  String? selector,
});

Group? defaultLineRootOf(List<Group> groups) =>
    groups
        .where(
          (group) => group.name == appName && group.type == GroupType.Selector,
        )
        .firstOrNull ??
    groups
        .where(
          (group) =>
              group.type == GroupType.Selector &&
              group.name != 'GLOBAL' &&
              group.all.any(
                (member) =>
                    member.name == _manualGroupName ||
                    member.name == _automaticGroupName,
              ),
        )
        .firstOrNull;

class DefaultLineCatalog {
  DefaultLineCatalog(List<Group> groups)
    : _groups = {for (final group in groups) group.name: group} {
    root = defaultLineRootOf(groups);
    final choices = <DefaultLineChoice>[];
    for (final member in root?.all ?? const <Proxy>[]) {
      if (_nonProxyTypes.contains(member.type.toLowerCase())) continue;
      final nested = _groups[member.name];
      if (member.name == _manualGroupName &&
          nested?.type == GroupType.Selector) {
        for (final proxy in nested!.all) {
          if (_nonProxyTypes.contains(proxy.type.toLowerCase())) continue;
          choices.add((
            name: proxy.name,
            rootTarget: member.name,
            selector: nested.name,
          ));
        }
      } else {
        choices.add((
          name: member.name,
          rootTarget: member.name,
          selector: null,
        ));
      }
    }
    this.choices = List.unmodifiable(choices);
  }

  final Map<String, Group> _groups;
  late final Group? root;
  late final List<DefaultLineChoice> choices;

  bool isAutomaticChoice(DefaultLineChoice choice) =>
      choice.rootTarget == _automaticGroupName;

  DefaultLineChoice? selected(Map<String, String> selections) {
    final root = this.root;
    if (root == null) return null;
    final target = root.getCurrentSelectedName(selections[root.name] ?? '');
    return choices
        .where(
          (choice) =>
              choice.rootTarget == target &&
              (choice.selector == null ||
                  _groups[choice.selector]?.getCurrentSelectedName(
                        selections[choice.selector] ?? '',
                      ) ==
                      choice.name),
        )
        .firstOrNull;
  }

  String? currentNode(Map<String, String> selections) {
    var name = root?.name ?? '';
    final visited = <String>{};
    while (name.isNotEmpty && visited.add(name)) {
      final group = _groups[name];
      if (group == null) return name;
      name = group.getCurrentSelectedName(selections[name] ?? '');
    }
    return null;
  }
}
