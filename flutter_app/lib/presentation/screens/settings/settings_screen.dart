import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/usecase/usecase.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/services/biometric_service.dart';
import '../../../domain/usecases/get_biometric_sign_in.dart';
import '../../../domain/usecases/set_biometric_sign_in.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../blocs/locale/locale_state.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/theme/theme_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_segmented_picker.dart';
import '../../widgets/app_surface.dart';
import '../../widgets/settings_row.dart';
import '../../widgets/theme_options_sheet.dart';

/// Appearance + security preferences.
///
/// Split out of the Profile screen for two reasons: appearance is now two axes
/// (brightness and surface style), which no longer fits a single on/off switch,
/// and the brief asks for the language and theme changes to be reachable from
/// settings rather than buried next to the order history.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// `null` while the platform channel is still answering.
  bool? _biometricsAvailable;

  /// Whether this device should ask for a scan instead of the password.
  late bool _biometricSignIn;

  @override
  void initState() {
    super.initState();
    _biometricSignIn = GetIt.I<GetBiometricSignIn>()(const NoParams());
    _probeBiometrics();
  }

  /// Asking the sensor is a one-shot read, not a subscription: nothing on this
  /// screen can change enrolment, so a single probe keeps the row honest
  /// without holding a stream open for the life of the page.
  Future<void> _probeBiometrics() async {
    final available = await GetIt.I<BiometricService>().isAvailable();
    if (!mounted) return;
    setState(() => _biometricsAvailable = available);
  }

  /// Turns the opt-in on only after a scan has actually passed.
  ///
  /// The switch grants future access to the account *without* a password, so
  /// letting anybody flip it on from a screen that never proved who they are
  /// would defeat the feature. Turning it off needs no proof — that direction
  /// only ever makes sign-in harder.
  Future<void> _setBiometricSignIn(bool enable) async {
    if (!enable) {
      _persistBiometricSignIn(false);
      return;
    }

    // Resolved before the await; the OS prompt paints this string.
    final reason = context.l10n.biometricSignInReason;
    final result = await GetIt.I<BiometricService>().authenticate(
      reason: reason,
    );
    if (!mounted) return;

    if (!result.isSuccess) {
      final messageKey = result.messageKey;
      if (messageKey != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              key: const ValueKey('biometric_sign_in_error_snackbar'),
              content: Text(context.trKey(messageKey)),
            ),
          );
      }
      return;
    }

    _persistBiometricSignIn(true);
  }

  void _persistBiometricSignIn(bool enabled) {
    setState(() => _biometricSignIn = enabled);
    unawaited(
      GetIt.I<SetBiometricSignIn>()(SetBiometricSignInParams(enabled: enabled)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Responsive.constrainWidth(
            context,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  _SectionTitle(title: context.l10n.appearance),
                  const _AppearanceCard(),
                  const SizedBox(height: 8),
                  _SectionTitle(title: context.l10n.security),
                  _BiometricCard(
                    available: _biometricsAvailable,
                    signInEnabled: _biometricSignIn,
                    onSignInChanged: _setBiometricSignIn,
                  ),
                  const SizedBox(height: 8),
                  _SectionTitle(title: context.l10n.general),
                  AppSurface(
                    child: SettingsRow(
                      icon: Icons.map_outlined,
                      label: context.l10n.vendorMap,
                      subtitle: context.l10n.vendorMapHint,
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.vendorMap),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Uppercase-ish section caption sitting above each card.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 18, 6, 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6),
      ),
    );
  }
}

/// Theme and language pickers, both applied live through the global cubits.
class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return AppSurface(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PickerLabel(
                    icon: Icons.palette_outlined,
                    text: l10n.themeMode,
                  ),
                  const SizedBox(height: 12),
                  AppSegmentedPicker(
                    keyPrefix: 'theme_option',
                    labels: [l10n.themeLight, l10n.themeDark],
                    icons: const [
                      Icons.light_mode_rounded,
                      Icons.dark_mode_rounded,
                    ],
                    selectedIndex: themeState.mode.isDark ? 1 : 0,
                    onSelected: (index) => context.read<ThemeCubit>().setMode(
                      themeState.mode.withDark(index == 1),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Glass is a surface style, not a brightness: it layers over
                  // whichever of light/dark is selected above, so it gets its
                  // own switch rather than a third segment.
                  Row(
                    children: [
                      Icon(
                        Icons.blur_on_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.themeLiquidGlass,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        key: const ValueKey('glass_style_switch'),
                        value: themeState.isLiquidGlass,
                        onChanged: (on) => context.read<ThemeCubit>().setMode(
                          themeState.mode.withGlass(on),
                        ),
                      ),
                    ],
                  ),
                  if (themeState.isLiquidGlass) ...[
                    const SizedBox(height: 8),
                    _Hint(text: l10n.themeLiquidGlassHint),
                  ],
                  const SizedBox(height: 18),
                  // The two-axis controls above are the quick path; this opens
                  // the sheet with all four looks drawn side by side.
                  OutlinedButton.icon(
                    key: const ValueKey('theme_options_button'),
                    onPressed: () => showThemeOptionsSheet(context),
                    icon: const Icon(Icons.palette_outlined, size: 18),
                    label: Text(l10n.viewAllThemes),
                  ),
                  const SizedBox(height: 22),
                  _PickerLabel(
                    icon: Icons.translate_rounded,
                    text: l10n.language,
                  ),
                  const SizedBox(height: 12),
                  AppSegmentedPicker(
                    keyPrefix: 'language_option',
                    labels: [l10n.english, l10n.arabic],
                    icons: const [
                      Icons.language_rounded,
                      Icons.translate_rounded,
                    ],
                    selectedIndex: localeState.isArabic ? 1 : 0,
                    onSelected: (index) => context
                        .read<LocaleCubit>()
                        .setLocale(Locale(index == 1 ? 'ar' : 'en')),
                  ),
                  const SizedBox(height: 18),
                  _Hint(text: l10n.appearanceHint),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PickerLabel extends StatelessWidget {
  const _PickerLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: theme.textTheme.titleMedium)),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
        height: 1.45,
      ),
    );
  }
}

/// Biometric security, in two halves.
///
/// The upper row reports the sensor state for the Profile gate, which is
/// read-only by design — the gate itself lives on that tab, and reporting the
/// sensor here is what tells the user why it did or did not appear. The lower
/// switch is the cold-start sign-in opt-in, which the device stores rather than
/// the account: the same user on a tablet with no enrolled finger must not
/// inherit an opt-in it can never satisfy.
class _BiometricCard extends StatelessWidget {
  const _BiometricCard({
    required this.available,
    required this.signInEnabled,
    required this.onSignInChanged,
  });

  final bool? available;
  final bool signInEnabled;
  final ValueChanged<bool> onSignInChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AppSurface(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppTheme.radius - 6),
                ),
                child: const Icon(
                  Icons.fingerprint_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.biometricUnlock,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          // The hint and the status each get a full-width line. Sharing one row
          // with the "Available on this device" chip left the text about 100dp
          // wide on a 360dp phone, which wrapped a one-line caption into a
          // five-line column and made this card tower over the page.
          const SizedBox(height: 10),
          _Hint(text: l10n.biometricUnlockHint),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _StatusChip(
                key: const ValueKey('biometric_status_chip'),
                available: available,
              ),
            ],
          ),
          // A switch that cannot work would be worse than no switch: it promises
          // a fingerprint every cold start and delivers a password form.
          if (available ?? false) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.biometricSignIn,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Switch(
                  key: const ValueKey('biometric_sign_in_switch'),
                  value: signInEnabled,
                  onChanged: onSignInChanged,
                ),
              ],
            ),
            const SizedBox(height: 2),
            _Hint(text: l10n.biometricSignInHint),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({super.key, required this.available});

  final bool? available;

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = switch (available) {
      null => (
        AppColors.textSecondary,
        context.l10n.loading,
        Icons.hourglass_empty_rounded,
      ),
      true => (
        AppColors.success,
        context.l10n.biometricStatusAvailable,
        Icons.check_circle_rounded,
      ),
      false => (
        AppColors.textSecondary,
        context.l10n.biometricStatusUnavailable,
        Icons.block_rounded,
      ),
    };

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
