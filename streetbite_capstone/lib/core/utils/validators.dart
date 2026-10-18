/// Declarative form validators.
///
/// Every validator returns an **ARB message key** instead of a literal string.
/// The widgets then resolve that key through `AppLocalizations.of(context)`,
/// which is what allows the very same validator to produce English *and*
/// Arabic messages at runtime with zero hard-coded text in the UI layer.
class Validators {
  const Validators._();

  /// Minimum password length enforced by the Sign Up / Login forms.
  static const int minPasswordLength = 6;

  static final RegExp _emailPattern = RegExp(
    r'^[\w.!#$%&*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$',
  );

  static final RegExp _capitalPattern = RegExp(r'[A-Z]');

  /// Field cannot be empty.
  static String? required(String? value, String emptyKey) {
    if (value == null || value.trim().isEmpty) return emptyKey;
    return null;
  }

  /// Must look like an e-mail address.
  static String? email(String? value) {
    final base = required(value, 'validationEmailRequired');
    if (base != null) return base;
    if (!_emailPattern.hasMatch(value!.trim())) return 'validationEmailInvalid';
    return null;
  }

  /// At least [minPasswordLength] characters.
  static String? password(String? value) {
    final base = required(value, 'validationPasswordRequired');
    if (base != null) return base;
    if (value!.length < minPasswordLength) return 'validationPasswordShort';
    return null;
  }

  /// Both passwords match.
  static String? confirmPassword(String? value, String password) {
    final base = required(value, 'validationConfirmRequired');
    if (base != null) return base;
    if (value != password) return 'validationPasswordMismatch';
    return null;
  }

  /// Full name must be at least two words and start with a capital letter —
  /// the exact rule described in the functional requirements.
  static String? fullName(String? value) {
    final base = required(value, 'validationNameRequired');
    if (base != null) return base;
    final trimmed = value!.trim();
    if (trimmed.split(RegExp(r'\s+')).length < 2) {
      return 'validationNameTwoWords';
    }
    if (!_capitalPattern.hasMatch(trimmed)) return 'validationNameCapital';
    return null;
  }
}
