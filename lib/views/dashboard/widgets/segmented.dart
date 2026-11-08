import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';

class BusinessSegment<T> {
  const BusinessSegment({required this.value, required this.label, this.glyph});

  final T value;
  final String label;
  final Glyph? glyph;
}

/// The design's segmented pill: one translucent track, each option a full pill
/// that takes the blue-violet gradient when selected.
class BusinessSegmented<T> extends StatelessWidget {
  const BusinessSegmented({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    this.height = 38,
    this.expand = false,
    this.mobile = false,
  });

  final List<BusinessSegment<T>> items;
  final T selected;
  final ValueChanged<T> onSelected;
  final double height;
  final bool expand;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardColors.of(context);
    final style = BusinessText.segment(context, mobile: mobile);
    final row = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      spacing: 4,
      children: [
        for (final item in items)
          if (expand)
            Expanded(child: _option(context, item, style))
          else
            _option(context, item, style),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(color: colors.tone, shape: AppShape.full),
      child: row,
    );
  }

  Widget _option(
    BuildContext context,
    BusinessSegment<T> item,
    TextStyle style,
  ) {
    final isSelected = item.value == selected;
    final foreground = isSelected
        ? const Color(0xFFFFFFFF)
        : context.colorScheme.onSurfaceVariant;
    return PressRegion(
      shape: AppShape.full,
      overlay: PressRegion.hoverOverlay,
      onTap: () => onSelected(item.value),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: mobile ? 7 : 15),
        decoration: ShapeDecoration(
          gradient: isSelected ? BusinessPalette.gradient : null,
          shape: AppShape.full,
          shadows: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x66465AFF),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ]
              : const [],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              if (item.glyph case final glyph?)
                GlyphIcon(glyph, size: mobile ? 14 : 16, color: foreground),
              if (expand)
                Flexible(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style.copyWith(color: foreground),
                  ),
                )
              else
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.copyWith(color: foreground),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
