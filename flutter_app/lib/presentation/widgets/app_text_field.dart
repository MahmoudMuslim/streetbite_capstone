import 'package:flutter/material.dart';

import '../extensions/l10n_extension.dart';

/// Reusable labelled text field used by both the Login and Sign Up screens.
///
/// Extracting it guarantees the two forms look and behave identically — the
/// same label placement, the same error rendering, and the same
/// `obscureText` toggle. It also gives every field a stable `Key`, which is how
/// the Appium suite addresses inputs without relying on screen coordinates.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.labelKey,
    required this.fieldKeyName,
    this.hintKey,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.autofillHints,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;

  /// ARB key of the floating label.
  final String labelKey;

  /// Stable identifier exposed to Appium via `ValueKey`.
  final String fieldKeyName;

  /// ARB key of the placeholder text.
  final String? hintKey;

  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Returns an ARB key (never a literal) — see `core/utils/validators.dart`.
  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final TextCapitalization textCapitalization;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(widget.fieldKeyName),
      controller: widget.controller,
      obscureText: _obscured,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
      decoration: InputDecoration(
        labelText: context.trKey(widget.labelKey),
        hintText: widget.hintKey == null
            ? null
            : context.trKey(widget.hintKey!),
        prefixIcon: widget.icon == null ? null : Icon(widget.icon),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _obscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
      ),
    );
  }
}
