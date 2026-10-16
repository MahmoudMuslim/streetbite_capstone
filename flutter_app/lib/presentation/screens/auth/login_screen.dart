import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../data/services/biometric_service.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_page_body.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/semantic_id.dart';
import '../../widgets/auth_card.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/biometric_gate.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/theme_toggle_button.dart';

/// Sign-in screen backed by **Firebase Authentication**.
///
/// State handling rules that make this screen robust:
/// * `BlocBuilder` renders the form and the inline error banner.
/// * `BlocListener` performs the *side effects* (navigate, dismiss the
///   keyboard) exactly once per state change, never during build.
/// * Every Firebase rejection arrives as an ARB key and is rendered through
///   `context.trKey(...)`, so the message is localized and never raw.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  key: const ValueKey('login_error_snackbar'),
                  content: Text(context.trKey(state.messageKey)),
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          if (state is AuthFailureState && _emailController.text.isEmpty) {
            // Nothing has been typed yet: show the full-screen error instead of
            // an almost-empty form.
            return AppErrorView(
              messageKey: state.messageKey,
              icon: Icons.lock_outline_rounded,
              onRetry: () => context.read<AuthCubit>().clearError(),
            );
          }

          return AppPageBody(
            children: [
              const AuthHeader(
                titleKey: 'loginTitle',
                subtitleKey: 'loginSubtitle',
              ),
              AuthCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _emailController,
                        labelKey: 'email',
                        hintKey: 'emailHint',
                        fieldKeyName: 'login_email_field',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.none,
                        autofillHints: const [AutofillHints.email],
                        enabled: !isLoading,
                        validator: Validators.email,
                        onChanged: (_) =>
                            context.read<AuthCubit>().clearError(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        labelKey: 'password',
                        hintKey: 'passwordHint',
                        fieldKeyName: 'login_password_field',
                        icon: Icons.lock_outline_rounded,
                        obscure: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        enabled: !isLoading,
                        validator: Validators.password,
                        onChanged: (_) =>
                            context.read<AuthCubit>().clearError(),
                        // The field has no onSubmitted hook, so the password
                        // field submits the form from its trailing action.
                      ),
                      const SizedBox(height: 24),
                      SemanticId(
                        key: const ValueKey('login_button'),
                        id: 'login_button',
                        label: context.l10n.login,
                        button: true,
                        child: FilledButton(
                          onPressed: isLoading ? null : _submit,
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(context.l10n.login),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.noAccountYet,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SemanticId(
                    key: const ValueKey('go_to_sign_up_button'),
                    id: 'go_to_sign_up_button',
                    label: context.l10n.signUp,
                    button: true,
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () =>
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.signUp),
                      child: Text(context.l10n.signUp),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const _BiometricSignIn(),
            ],
          );
        },
      ),
    );
  }
}

/// Optional "sign in with fingerprint" shortcut under the form.
///
/// The [BiometricService] is resolved from GetIt rather than constructed inline
/// so that (a) the plugin is not instantiated twice and (b) a widget test can
/// swap in a stub instead of hitting a platform channel. Hidden automatically
/// when the device has no biometric hardware, so the screen never offers an
/// action that cannot work.
class _BiometricSignIn extends StatelessWidget {
  const _BiometricSignIn();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: GetIt.I<BiometricService>().isAvailable(),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return Center(
          child: TextButton.icon(
            key: const ValueKey('biometric_login_button'),
            onPressed: () => _prompt(context),
            icon: const Icon(Icons.fingerprint_rounded),
            label: Text(context.l10n.biometricPromptTitle),
          ),
        );
      },
    );
  }

  Future<void> _prompt(BuildContext context) async {
    final result = await GetIt.I<BiometricService>().authenticate(
      reason: BiometricGateReason.profile,
    );
    if (!context.mounted) return;

    if (result.isSuccess) {
      Navigator.of(context).pushNamed(AppRoutes.home);
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.trKey(result.messageKey!))),
      );
  }
}
