import 'package:flutter/material.dart';

import '../../core/theme/app_glass_tokens.dart';
import '../extensions/l10n_extension.dart';
import 'app_surface.dart';
import 'semantic_id.dart';

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
    final isGlass = AppGlassTokens.enabledOf(context);
    final label = context.trKey(widget.labelKey);

    final field = TextFormField(
      key: ValueKey(widget.fieldKeyName),
      controller: widget.controller,
      obscureText: _obscured,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autofillHints: widget.autofillHints,
      // `Validators` deliberately returns an **ARB key**, never a literal, so
      // the rules stay locale-agnostic. The key is resolved to a sentence
      // here, at the last possible moment, which is what allows the same
      // validator to render in English and in Arabic.
      validator: (value) {
        final key = widget.validator?.call(value);
        return key == null ? null : context.trKey(key);
      },
      onChanged: widget.onChanged,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
      decoration: InputDecoration(
        // Under glass the frosted panel supplies the fill and the hairline
        // edge, so the input draws no box of its own and shows its name as a
        // hint inside the pill instead of a floating label above it.
        labelText: isGlass ? null : label,
        hintText: isGlass
            ? label
            : (widget.hintKey == null ? null : context.trKey(widget.hintKey!)),
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
        filled: !isGlass,
        border: isGlass ? InputBorder.none : null,
        enabledBorder: isGlass ? InputBorder.none : null,
        focusedBorder: isGlass ? InputBorder.none : null,
        errorBorder: isGlass ? InputBorder.none : null,
        focusedErrorBorder: isGlass ? InputBorder.none : null,
      ),
    );

    // Wrapped in [SemanticId] so the Appium suite can address this input by
    // `resource-id` instead of by its label, which changes with the language.
    return SemanticId(
      id: widget.fieldKeyName,
      label: label,
      child: isGlass
          ? AppSurface(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: field,
            )
          : field,
    );
  }
}
