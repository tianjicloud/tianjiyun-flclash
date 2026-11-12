typedef TrayMenuItemSelectedCallback = void Function();

sealed class TrayMenuItem {
  const TrayMenuItem();
}

final class TrayMenuAction extends TrayMenuItem {
  const TrayMenuAction({
    required this.label,
    this.detail,
    this.enabled = true,
    this.onSelected,
  });

  final String label;
  final String? detail;
  final bool enabled;
  final TrayMenuItemSelectedCallback? onSelected;
}

final class TrayMenuCheckbox extends TrayMenuItem {
  const TrayMenuCheckbox({
    required this.label,
    required this.checked,
    this.detail,
    this.enabled = true,
    this.onSelected,
  });

  final String label;
  final bool checked;
  final String? detail;
  final bool enabled;
  final TrayMenuItemSelectedCallback? onSelected;
}

final class TrayMenuSubmenu extends TrayMenuItem {
  const TrayMenuSubmenu({
    required this.label,
    required this.items,
    this.detail,
    this.enabled = true,
  });

  final String label;
  final List<TrayMenuItem> items;
  final String? detail;
  final bool enabled;
}

final class TrayMenuSeparator extends TrayMenuItem {
  const TrayMenuSeparator();
}

final class TrayMenuMetric {
  const TrayMenuMetric({required this.label, required this.value});

  final String label;
  final String value;
}

final class TrayMenuMetrics extends TrayMenuItem {
  const TrayMenuMetrics({required this.metrics});

  final List<TrayMenuMetric> metrics;
}

final class TrayMenuSegmentOption {
  const TrayMenuSegmentOption({
    required this.id,
    required this.label,
    required this.selected,
    this.enabled = true,
    this.onSelected,
  });

  final String id;
  final String label;
  final bool selected;
  final bool enabled;
  final TrayMenuItemSelectedCallback? onSelected;
}

final class TrayMenuSegmented extends TrayMenuItem {
  const TrayMenuSegmented({required this.label, required this.options});

  final String label;
  final List<TrayMenuSegmentOption> options;
}
