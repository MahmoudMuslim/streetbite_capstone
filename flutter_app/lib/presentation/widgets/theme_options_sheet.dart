import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme_mode.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/theme/theme_state.dart';
import '../extensions/app_theme_mode_l10n.dart';
import '../extensions/l10n_extension.dart';
import 'app_surface.dart';

/// Opens the appearance picker.
///
/// Used from every place that used to offer a blind light -> dark -> glass
/// cycle. With four looks, cycling guesses what the user wanted; a sheet that
/// draws each one lets them see it before committing.
Future<void> showThemeOptionsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    // Four preview tiles are taller than the default half-screen peek, and the
    // sheet must not clip the last one on a short device.
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const ThemeOptionsSheet(),
  );
}

/// The four [AppThemeMode] appearances as tappable cards.
///
/// Selection applies instantly and leaves the sheet open, so the looks can be
/// compared one after another. The sheet itself is rebuilt by the same
/// [ThemeCubit] it writes to, which means the tiles re-skin as the user picks
/// (a real preview of the surface style, not a static thumbnail alone).
class ThemeOptionsSheet extends StatelessWidget {
  const ThemeOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.themeSheetTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.appearanceHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) => Column(
                  children: [
                    for (final mode in AppThemeMode.values)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ThemeOptionTile(
                          mode: mode,
                          selected: mode == state.mode,
                          // `setMode` persists through the cubit, so closing
                          // the sheet — or the app — keeps the pick.
                          onTap: () => context.read<ThemeCubit>().setMode(mode),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One appearance row: swatch, name, description, selection marker.
class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final AppThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AppSurface(
      key: ValueKey('theme_sheet_option_${mode.name}'),
      onTap: onTap,
      borderRadius: 22,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          _AppearanceSwatch(mode: mode, selected: selected),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode.label(l10n),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: selected ? AppColors.primary : null,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  mode.hint(l10n),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              key: ValueKey(selected),
              size: 24,
              color: selected
                  ? AppColors.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.28),
            ),
          ),
        ],
      ),
    );
  }
}

/// A miniature of the appearance: its canvas gradient with a couple of "cards"
/// floating on it, so the surface style (solid vs frosted) is legible at a
/// glance rather than only described by words.
class _AppearanceSwatch extends StatelessWidget {
  const _AppearanceSwatch({required this.mode, required this.selected});

  final AppThemeMode mode;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final (canvasTop, canvasBottom) = switch (mode) {
      AppThemeMode.light => (AppColors.background, AppColors.surface),
      AppThemeMode.dark => (AppColors.backgroundDark, AppColors.surfaceDark),
      AppThemeMode.glassLight => (
        AppColors.glassCanvasTopLight,
        AppColors.glassCanvasBottomLight,
      ),
      AppThemeMode.glassDark => (
        AppColors.glassCanvasTop,
        AppColors.glassCanvasBottom,
      ),
    };
    // Solid looks paint an opaque content card; glass looks float a translucent
    // pane with a hairline edge on top of the aurora — that edge is the whole
    // difference between the two families, so the thumbnail has to show it.
    final paneFill = mode.isLiquidGlass
        ? (mode.isDark
              ? AppColors.glassSurfaceStrong
              : Colors.white.withValues(alpha: 0.62))
        : (mode.isDark ? AppColors.surface : Colors.white);
    final ink = mode.isDark ? Colors.white : AppColors.textPrimary;

    return Container(
      width: 54,
      height: 46,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [canvasTop, canvasBottom],
        ),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : (mode.isDark ? Colors.white24 : AppColors.divider),
          width: selected ? 2 : 1,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: paneFill,
          borderRadius: BorderRadius.circular(8),
          border: mode.isLiquidGlass
              ? Border.all(
                  color: mode.isDark
                      ? AppColors.glassBorder
                      : AppColors.glassBorderLight,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 6, 5, 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 4),
              _line(width: 28, color: ink.withValues(alpha: 0.30)),
              const SizedBox(height: 3),
              _line(width: 20, color: ink.withValues(alpha: 0.18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line({required double width, required Color color}) => Container(
    width: width,
    height: 3,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}
