import 'dart:convert';

import 'tray_menu.dart';
import 'tray_spec.dart';

final class EncodedTray {
  const EncodedTray({
    required this.icon,
    required this.toolTip,
    required this.menu,
    required this.itemsById,
    required this.callbacksById,
    required this.signature,
  });

  final Map<String, Object?> icon;
  final String toolTip;
  final List<Object?> menu;
  final Map<int, TrayMenuItem> itemsById;
  final Map<int, TrayMenuItemSelectedCallback?> callbacksById;
  final String signature;
}

abstract final class TrayCodec {
  static const int firstItemId = 1024;

  static EncodedTray encode(TraySpec spec, {bool customMenuItems = true}) {
    final itemsById = <int, TrayMenuItem>{};
    final callbacksById = <int, TrayMenuItemSelectedCallback?>{};
    final menu = _encodeItems(
      spec.menu,
      itemsById,
      callbacksById,
      _IdAllocator(),
      customMenuItems,
    );
    final icon = <String, Object?>{
      'asset': spec.icon.asset,
      'isTemplate': spec.icon.isTemplate,
      'size': spec.icon.size,
      'position': spec.icon.position.name,
    };
    return EncodedTray(
      icon: icon,
      toolTip: spec.toolTip,
      menu: menu,
      itemsById: itemsById,
      callbacksById: callbacksById,
      signature: jsonEncode(<String, Object?>{
        'icon': icon,
        'toolTip': spec.toolTip,
        'menu': menu,
      }),
    );
  }

  static List<Object?> _encodeItems(
    List<TrayMenuItem> items,
    Map<int, TrayMenuItem> sink,
    Map<int, TrayMenuItemSelectedCallback?> callbacks,
    _IdAllocator allocator,
    bool customMenuItems,
  ) {
    final expanded = customMenuItems
        ? items
        : items.expand(
            (item) => switch (item) {
              TrayMenuMetrics(:final metrics) => [
                TrayMenuAction(
                  label: metrics
                      .map((metric) => '${metric.label} ${metric.value}')
                      .join(' · '),
                  enabled: false,
                ),
              ],
              TrayMenuSegmented(:final label, :final options) => [
                TrayMenuAction(label: label, enabled: false),
                for (final option in options)
                  TrayMenuCheckbox(
                    label: option.label,
                    checked: option.selected,
                    enabled: option.enabled,
                    onSelected: option.onSelected,
                  ),
              ],
              _ => [item],
            },
          );
    return expanded.map((item) {
      final id = allocator.next();
      sink[id] = item;
      if (item is TrayMenuAction) callbacks[id] = item.onSelected;
      if (item is TrayMenuCheckbox) callbacks[id] = item.onSelected;
      return switch (item) {
        TrayMenuSeparator() => <String, Object?>{'id': id, 'type': 'separator'},
        TrayMenuMetrics(:final metrics) => <String, Object?>{
          'id': id,
          'type': 'metrics',
          'metrics': [
            for (final metric in metrics)
              {'label': metric.label, 'value': metric.value},
          ],
        },
        TrayMenuSegmented(:final label, :final options) => <String, Object?>{
          'id': id,
          'type': 'segmented',
          'label': label,
          'options': [
            for (final option in options)
              (() {
                final optionId = allocator.next();
                sink[optionId] = item;
                callbacks[optionId] = option.onSelected;
                return {
                  'id': optionId,
                  'optionId': option.id,
                  'label': option.label,
                  'selected': option.selected,
                  'enabled': option.enabled,
                };
              })(),
          ],
        },
        TrayMenuAction(:final label, :final detail, :final enabled) =>
          <String, Object?>{
            'id': id,
            'type': 'action',
            'label': label,
            if (detail != null && detail.isNotEmpty) 'detail': detail,
            'enabled': enabled,
          },
        TrayMenuCheckbox(
          :final label,
          :final detail,
          :final enabled,
          :final checked,
        ) =>
          <String, Object?>{
            'id': id,
            'type': 'checkbox',
            'label': label,
            if (detail != null && detail.isNotEmpty) 'detail': detail,
            'enabled': enabled,
            'checked': checked,
          },
        TrayMenuSubmenu(
          :final label,
          :final detail,
          :final enabled,
          :final items,
        ) =>
          <String, Object?>{
            'id': id,
            'type': 'submenu',
            'label': label,
            if (detail != null && detail.isNotEmpty) 'detail': detail,
            'enabled': enabled,
            'items': _encodeItems(
              items,
              sink,
              callbacks,
              allocator,
              customMenuItems,
            ),
          },
      };
    }).toList();
  }
}

final class _IdAllocator {
  int _next = TrayCodec.firstItemId;

  int next() {
    final id = _next;
    _next = _next + 1;
    return id;
  }
}
