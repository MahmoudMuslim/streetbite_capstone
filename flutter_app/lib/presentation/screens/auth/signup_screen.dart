import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/utils/string_helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/user_entity.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../extensions/l10n_extension.dart';
import '../../widgets/app_page_body.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_card.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/language_toggle_button.dart';
import '../../widgets/theme_toggle_button.dart';

/// Account creation screen.
///
/// The success path follows the brief exactly:
/// validate -> `AuthSignUpSuccess` -> confirmation dialog -> **fade**
/// transition into the Home screen.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // "yasmine adel" -> "Yasmine Adel", exactly as the brief requires.
    context.read<AuthCubit>().signUp(
      displayName: capitalizeEachWord(_nameController.text),
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  /// Shows the success dialog, then fades into Home.
  Future<void> _confirmAndGoHome(UserEntity user) async {
    final cubit = context.read<AuthCubit>();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('sign_up_success_dialog'),
        icon: const Icon(Icons.check_circle_rounded, size: 44),
        title: Text(context.l10n.signUpSuccessTitle),
        content: Text(
          context.trArgs('signUpSuccessMessage', {'name': user.displayName}),
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            key: const ValueKey('sign_up_continue_button'),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.continueAction),
          ),
        ],
      ),
    );

    if (!mounted) return;

    // Dismiss the dialog with a fade, exactly as the brief requires, and hand
    // the freshly authenticated user back to the state machine.
    final navigator = Navigator.of(context);
    cubit.confirmSignUp(user);
    navigator.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(context.l10n.signUpTitle),
        actions: const [
          ThemeToggleButton(),
          LanguageToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            _confirmAndGoHome(state.user);
          }
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  key: const ValueKey('sign_up_error_snackbar'),
                  content: Text(context.trKey(state.messageKey)),
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return AppPageBody(
            children: [
              const AuthHeader(
                titleKey: 'signUpTitle',
                subtitleKey: 'signUpSubtitle',
              ),
              AuthCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _nameController,
                        labelKey: 'fullName',
                        hintKey: 'fullNameHint',
                        fieldKeyName: 'signup_name_field',
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        autofillHints: const [AutofillHints.name],
                        enabled: !isLoading,
                        validator: Validators.fullName,
                        onChanged: (_) =>
                            context.read<AuthCubit>().clearError(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _emailController,
                        labelKey: 'email',
                        hintKey: 'emailHint',
                        fieldKeyName: 'signup_email_field',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newUsername],
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
                        fieldKeyName: 'signup_password_field',
                        icon: Icons.lock_outline_rounded,
                        obscure: true,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        enabled: !isLoading,
                        validator: Validators.password,
                        onChanged: (_) =>
                            context.read<AuthCubit>().clearError(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _confirmController,
                        labelKey: 'confirmPassword',
                        fieldKeyName: 'signup_confirm_password_field',
                        icon: Icons.lock_reset_rounded,
                        obscure: true,
                        textInputAction: TextInputAction.done,
                        enabled: !isLoading,
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        onChanged: (_) =>
                            context.read<AuthCubit>().clearError(),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const ValueKey('sign_up_button'),
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
                            : Text(context.l10n.signUp),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.l10n.alreadyHaveAccount),
                  TextButton(
                    key: const ValueKey('go_to_login_button'),
                    onPressed: isLoading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(context.l10n.login),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
