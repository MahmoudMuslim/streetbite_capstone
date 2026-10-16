import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_glass_tokens.dart';

/// Builds the light, dark and Liquid Glass [ThemeData] for StreetBite.
///
/// The Figma kit uses a single vivid green on a near-white canvas, large
/// bold headings, and generous 20px corner radii. All three themes are derived
/// from the same helper so they stay structurally identical and the ThemeCubit
/// switch can never desynchronise them.
class AppTheme {
  const AppTheme._();

  /// Corner radius used by cards, buttons, chips and bottom sheets.
  static const double radius = 20;

  /// Maximum content width used on tablets / wide windows.
  static const double maxContentWidth = 720;

  /// Shared card surface: white (dark: elevated grey) with a soft shadow in
  /// light mode, so every card across the app lifts off the canvas identically.
  ///
  /// Under Liquid Glass the same helper returns a translucent panel with a
  /// hairline edge: real refraction is painted by `GlassCard`, and this is the
  /// cheap fallback for surfaces that must stay `BoxDecoration`-shaped.
  static BoxDecoration cardDecoration(BuildContext context) {
    if (AppGlassTokens.enabledOf(context)) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return BoxDecoration(
        color: isDark ? AppColors.glassSurface : AppColors.glassSurfaceLight,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
        ),
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? AppColors.surfaceDark : AppColors.background,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isDark ? null : AppColors.cardShadow,
    );
  }

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  /// Dark-brightness theme with transparent scaffolds, so the aurora backdrop
  /// painted behind the `Navigator` shows through every route and the glass
  /// surfaces have something to refract.
  static ThemeData get liquidGlassDark => _build(Brightness.dark, glass: true);

  /// The same frosted treatment at light brightness: white-tinted panels over
  /// a pale aurora instead of dark-tinted panels over a deep one.
  static ThemeData get liquidGlassLight =>
      _build(Brightness.light, glass: true);

  static ThemeData _build(Brightness brightness, {bool glass = false}) {
    final isDark = brightness == Brightness.dark;

    // Glass keeps its own palette per brightness so the frosted panels and
    // hairlines stay legible on both canvases.
    final glassSurface = isDark
        ? AppColors.glassSurface
        : AppColors.glassSurfaceLight;
    final glassSurfaceStrong = isDark
        ? AppColors.glassSurfaceStrong
        : AppColors.glassSurfaceLightStrong;
    final glassBorder = isDark
        ? AppColors.glassBorder
        : AppColors.glassBorderLight;
    final glassText = isDark
        ? AppColors.glassTextPrimary
        : AppColors.glassTextPrimaryLight;
    final glassTextMuted = isDark
        ? AppColors.glassTextSecondary
        : AppColors.glassTextSecondaryLight;
    // Sheets and dialogs stay opaque in both glass variants: a modal has
    // nothing behind it to refract.
    final glassPanel = isDark
        ? const Color(0xFF0F1A2B)
        : const Color(0xFFF5FAFD);

    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: isDark && !glass ? AppColors.primaryDark : AppColors.primary,
          onPrimary: Colors.white,
          surface: glass
              ? (isDark
                    ? AppColors.glassCanvasBottom
                    : AppColors.glassCanvasBottomLight)
              : isDark
              ? AppColors.backgroundDark
              : AppColors.background,
          onSurface: glass
              ? glassText
              : isDark
              ? Colors.white
              : AppColors.textPrimary,
          outlineVariant: glass ? glassBorder : null,
          error: AppColors.error,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      // Grey canvas in light mode: white cards read as objects on it instead
      // of dissolving into a white page. Glass mode leaves scaffolds
      // transparent so the shared aurora backdrop stays visible.
      scaffoldBackgroundColor: glass
          ? Colors.transparent
          : isDark
          ? AppColors.backgroundDark
          : AppColors.surface,
      splashFactory: InkSparkle.splashFactory,
      extensions: [AppGlassTokens(enabled: glass)],
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: glass
            ? Colors.transparent
            : isDark
            ? AppColors.backgroundDark
            : AppColors.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: glass
            ? glassSurface
            : (isDark ? AppColors.surfaceDark : AppColors.background),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: glass ? BorderSide(color: glassBorder) : BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textSecondary,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
          side: BorderSide(
            color: glass
                ? glassBorder
                : isDark
                ? Colors.white24
                : AppColors.border,
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glass
            ? glassSurfaceStrong
            : isDark
            ? AppColors.surfaceDark
            : AppColors.background,
        hintStyle: TextStyle(
          color: glass ? glassTextMuted : AppColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: glass ? BorderSide(color: glassBorder) : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.6),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? Colors.white : AppColors.textPrimary,
        // Dark mode inverts the bar to white, so the copy has to invert with it
        // — white-on-white made every SnackBar unreadable.
        contentTextStyle: TextStyle(
          color: isDark ? AppColors.textPrimary : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        // Sheets stay opaque under glass: a modal has nothing behind it to
        // refract, and a translucent sheet over a dimmed route reads as a bug.
        backgroundColor: glass
            ? glassPanel
            : isDark
            ? AppColors.surfaceDark
            : AppColors.background,
        showDragHandle: true,
        dragHandleColor: glass
            ? glassBorder
            : isDark
            ? Colors.white24
            : AppColors.border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: glass
            ? Colors.transparent
            : isDark
            ? AppColors.surfaceDark
            : AppColors.background,
        indicatorColor: glass ? AppColors.primary : AppColors.primarySoft,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        elevation: 0,
        height: 76,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            letterSpacing: 0.1,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? glass
                      ? glassText
                      : scheme.primary
                : glass
                ? glassTextMuted
                : AppColors.textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 25,
            color: states.contains(WidgetState.selected)
                ? glass
                      ? glassText
                      : scheme.primary
                : glass
                ? glassTextMuted
                : AppColors.textSecondary,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: glass
            ? glassBorder
            : isDark
            ? Colors.white12
            : AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: glass
            ? glassPanel
            : isDark
            ? AppColors.surfaceDark
            : AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: TextStyle(
          color: glass
              ? glassText
              : isDark
              ? Colors.white
              : AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
    );
  }

  /// Typography scale matching the Figma kit: heavy display headings, medium
  /// body copy, and muted supporting labels.
  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        height: 1.15,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
      bodySmall: base.bodySmall?.copyWith(letterSpacing: 0.1),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
    );
  }
}
