import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_tokens.dart';
import 'app_surface.dart';

/// The app's search input.
///
/// One call site, two renderings, mirroring [AppSurface]: under the Liquid
/// Glass theme the field sits chrome-less inside a real frosted [GlassCard]
/// pill (the panel supplies the fill and the hairline edge, so the input must
/// not draw its own box or the two outlines fight), and everywhere else it is
/// the theme-filled [TextField] the light/dark looks already use.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    required this.fieldKeyName,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  /// Stable identifier exposed to Appium via `ValueKey`.
  final String fieldKeyName;

  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final isGlass = AppGlassTokens.enabledOf(context);

    final field = TextField(
      key: ValueKey(fieldKeyName),
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        prefixIconColor: isGlass
            ? Theme.of(context).colorScheme.onSurface
            : AppColors.textSecondary,
        suffixIcon: suffixIcon,
        filled: !isGlass,
        border: isGlass ? InputBorder.none : null,
        enabledBorder: isGlass ? InputBorder.none : null,
        focusedBorder: isGlass ? InputBorder.none : null,
      ),
    );

    if (!isGlass) return field;

    return AppSurface(
      borderRadius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: field,
    );
  }
}
