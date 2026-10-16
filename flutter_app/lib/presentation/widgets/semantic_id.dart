import 'package:flutter/material.dart';

/// Tags a subtree with a **stable accessibility identifier**.
///
/// Why this exists
/// ---------------
/// A Dart `ValueKey` is invisible to the platform: UiAutomator2 and Appium
/// cannot see it, so an automation suite can only fall back to visible text or
/// raw coordinates — both of which break the moment the design changes.
/// Flutter's [Semantics.identifier], by contrast, is published to Android as
/// the node's {@code resource-id}, which is exactly what an Appium XPath can
/// address.
///
/// Using it here gives two wins at once:
/// * tests address `resource-id="login_email_field"` instead of
///   "the EditText above the Password field";
/// * screen-reader tooling gets a meaningful, non-localised handle.
///
/// The [label] argument adds a *human* name alongside the identifier, so
/// assistive technology still announces something useful.
///
/// Note that callers should normally pass `key: ValueKey(id)` as well: that
/// keeps the widget-test story (`find.byKey`) working alongside the device
/// story (`resource-id`), so both layers of the test suite address the same
/// widget.
class SemanticId extends StatelessWidget {
  const SemanticId({
    super.key,
    required this.id,
    required this.child,
    this.label,
    this.button = false,
    this.value,
    this.explicitChildNodes = true,
  });

  /// Stable, non-localised identifier (e.g. `login_email_field`).
  final String id;

  /// Optional human-readable label announced by assistive technology.
  final String? label;

  final bool button;
  final String? value;

  /// Keeps each descendant in its own node instead of folding their labels into
  /// this one.
  ///
  /// This defaults to `true` for a concrete reason. Flutter merges a subtree's
  /// labels into a single accessibility node whenever a node owns several
  /// children, which is why a meal card used to surface as one blob of text and
  /// its Add-to-Cart button vanished from the tree entirely — taking its
  /// `resource-id` with it. Declaring the children explicit is what lets
  /// Appium address a button nested inside a card.
  final bool explicitChildNodes;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: id,
      label: label,
      value: value,
      button: button,
      // `container: true` makes this a distinct node in the tree instead of
      // merging the tag into an ancestor.
      container: true,
      explicitChildNodes: explicitChildNodes,
      child: child,
    );
  }
}
