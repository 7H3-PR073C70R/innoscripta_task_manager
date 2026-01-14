import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/core/themes/color/app_theme_colors.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';

/// Priority badge widget that displays task priority with color coding
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({
    required this.priority,
    this.size = PriorityBadgeSize.medium,
    super.key,
  });

  final int priority;
  final PriorityBadgeSize size;

  @override
  Widget build(BuildContext context) {
    // Usage of theme extension
    final colors = context.colors;
    final priorityData = _getPriorityData(context, priority, colors);
    final textTheme = context.textTheme;

    final fontSize = switch (size) {
      PriorityBadgeSize.small => 10,
      PriorityBadgeSize.medium => 12,
      PriorityBadgeSize.large => 14,
    };

    final padding = switch (size) {
      PriorityBadgeSize.small => const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      PriorityBadgeSize.medium => const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      PriorityBadgeSize.large => const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: padding,
      decoration: BoxDecoration(
        color: priorityData.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priorityData.label,
        style: textTheme.caption.copyWith(
          color: priorityData.textColor,
          fontSize: fontSize.toDouble(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _PriorityData _getPriorityData(
    BuildContext context,
    int priority,
    AppThemeColors colors,
  ) {
    final appString = context.l10n;
    // Priority 1 = High (p1), 2 = Medium (p2), 3 = Low (p3), 4 = None
    if (priority == 1) {
      return _PriorityData(
        label: appString.high,
        backgroundColor: colors.error[50]!,
        textColor: colors.error[700]!,
      );
    } else if (priority == 2) {
      return _PriorityData(
        label: appString.medium,
        backgroundColor: colors.warning[50]!,
        textColor: colors.warning[700]!,
      );
    } else {
      return _PriorityData(
        label: appString.low,
        backgroundColor: colors.gray[100]!,
        textColor: colors.gray[700]!,
      );
    }
  }
}

class _PriorityData {
  const _PriorityData({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
}

enum PriorityBadgeSize {
  small,
  medium,
  large,
}
