import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_tokens.dart';

/// Three-or-fewer-way pill selector used for Theme and Language in Settings.
///
/// Renders as a real [GlassSegmentedControl] under Liquid Glass (with the
/// jelly indicator that ships with it) and as an animated gradient pill
/// otherwise, so the control always matches the active look while every caller
/// keeps a single API.
class AppSegmentedPicker extends StatelessWidget {
  const AppSegmentedPicker({
    super.key,
    required this.keyPrefix,
    required this.labels,
    required this.icons,
    required this.selectedIndex,
    required this.onSelected,
  });

  /// Prepended to each option's `ValueKey`, e.g. `theme_option_0`.
  final String keyPrefix;

  final List<String> labels;
  final List<IconData> icons;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (AppGlassTokens.enabledOf(context)) {
      return GlassSegmentedControl(
        segments: [
          for (var i = 0; i < labels.length; i++)
            GlassSegment(icon: Icon(icons[i], size: 18), label: labels[i]),
        ],
        selectedIndex: selectedIndex,
        onSegmentSelected: onSelected,
        selectedTextStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedTextStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : AppColors.divider),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(child: _option(context, i, isDark)),
        ],
      ),
    );
  }

  Widget _option(BuildContext context, int index, bool isDark) {
    final selected = index == selectedIndex;
    final theme = Theme.of(context);

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        key: ValueKey('${keyPrefix}_$index'),
        onTap: () => onSelected(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: selected
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  )
                : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icons[index],
                size: 16,
                color: selected
                    ? Colors.white
                    : isDark
                    ? AppColors.glassTextSecondary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 13,
                    color: selected
                        ? Colors.white
                        : isDark
                        ? Colors.white70
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
