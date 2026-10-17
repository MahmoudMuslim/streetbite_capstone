import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/biometric_service.dart';
import '../../../domain/entities/user_entity.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_page_body.dart';
import '../../widgets/auth_card.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/semantic_id.dart';
import '../../widgets/theme_toggle_button.dart';

/// The fingerprint / face prompt that replaces the password on a cold start.
///
/// Shown only when the session restored **and** this device opted in to
/// biometric sign-in, which is the `AuthBiometricGate` state. The credentials
/// are already valid at this point; the scan is a local check on whether *this
/// handset* may use them.
///
/// The scan fires by itself one frame after the screen appears, so the normal
/// path is: splash -> this greeting -> Home, with nothing to tap. Anything that
/// is not a passed scan — declined, timed out, no hardware — hands over to the
/// password form. That fallback deliberately stops at changing the screen:
/// `fallBackToPassword()` never signs out, so one mis-tap on the prompt costs a
/// few seconds rather than a full re-login.
class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  /// The account the splash found, captured once.
  ///
  /// Reading it from the bloc on every build would blank the greeting the
  /// moment [AuthCubit.fallBackToPassword] emits `AuthUnauthenticated`, which
  /// can happen while this screen is still on the way out.
  UserEntity? _user;

  bool _scanning = false;

  /// Set when the user chooses the password form while a scan is still in
  /// flight.
  ///
  /// Both outcomes write to the same cubit, so without this the prompt landing
  /// a moment later could pull the user back off the form they just asked for.
  bool _declinedToPassword = false;

  @override
  void initState() {
    super.initState();

    final state = context.read<AuthCubit>().state;
    if (state is AuthBiometricGate) _user = state.user;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // `null` here means the screen was reached without a gated session — a
      // deep link or a test harness. There is nothing to unlock, so the only
      // honest destination is the password form.
      if (_user == null) {
        _usePassword();
        return;
      }
      _scan();
    });
  }

  Future<void> _scan() async {
    final service = GetIt.I<BiometricService>();

    // Resolved before any await: the OS prompt paints this string, and reading
    // it from `context` after a platform round trip would risk a deactivated
    // element.
    final reason = context.l10n.biometricSignInReason;

    if (!await service.isAvailable()) {
      // No sensor, nothing enrolled, or the sensor is locked out. A scan that
      // cannot succeed must not be offered even once.
      if (mounted) _usePassword();
      return;
    }

    setState(() => _scanning = true);
    final result = await service.authenticate(reason: reason);
    if (!mounted || _declinedToPassword) return;
    setState(() => _scanning = false);

    if (result.isSuccess) {
      context.read<AuthCubit>().confirmBiometricSignIn();
      return;
    }
    _usePassword();
  }

  void _usePassword() {
    _declinedToPassword = true;
    context.read<AuthCubit>().fallBackToPassword();
  }

  String _greeting(UserEntity user) {
    final firstName = user.displayName.trim().split(' ').first;
    // An account with no display name would otherwise produce "Welcome back,"
    // with nothing after it. Email is the one field every session carries.
    return context.l10n.welcomeBack(firstName.isEmpty ? user.email : firstName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = _user;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(context.l10n.appName),
        actions: const [
          ThemeToggleButton(),
          LanguageToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          }
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return AppPageBody(
            children: [
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.12),
                      ),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: _scanning ? 1 : 0.45,
                        child: const Icon(
                          Icons.fingerprint_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      user == null
                          ? context.l10n.biometricSignIn
                          : _greeting(user),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _scanning
                          ? context.l10n.scanToSignIn
                          : context.l10n.biometricSignInHint,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AuthCard(
                child: SemanticId(
                  key: const ValueKey('use_password_button'),
                  id: 'use_password_button',
                  label: context.l10n.usePasswordInstead,
                  button: true,
                  child: TextButton(
                    onPressed: isLoading ? null : _usePassword,
                    child: Text(context.l10n.usePasswordInstead),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
