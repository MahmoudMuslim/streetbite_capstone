/// Pure, reusable helpers shared across layers.
///
/// They live in `core/utils` because they contain no Flutter and no domain
/// knowledge — which is exactly what makes them safe to unit test and reuse
/// from a data source, a use case, or a widget.
library;

/// Capitalises the first character of every whitespace-separated word and
/// leaves the rest untouched.
///
/// Required by the Sign Up specification: "Full Name (capital first letter)".
///
/// Example: `"yasmine adel"` -> `"Yasmine Adel"`.
String capitalizeEachWord(String input) {
  if (input.trim().isEmpty) return input;
  return input
      .trim()
      .split(RegExp(r'\s+'))
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1);
      })
      .join(' ');
}

/// Formats a raw double as a currency string with two decimals.
///
/// Kept as a helper so no screen formats money differently.
String formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

/// Returns the plural-safe item counter used by the cart badge and the
/// order summaries ("1 item" / "3 items").
String itemCountLabel(int count, String singular, String plural) =>
    count == 1 ? singular : plural;
