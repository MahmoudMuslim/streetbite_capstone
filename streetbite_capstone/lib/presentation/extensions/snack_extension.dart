import 'package:flutter/material.dart';

/// Single entry point for the app's transient messages.
///
/// Every confirmation and every rejection used to re-type the same
/// `ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(...)`
/// chain, so a change to how a snack looks or behaves had to be repeated across
/// a dozen screens. The `ValueKey`s stay at the call sites because the widget
/// and Appium suites find specific confirmations by identity.
extension SnackX on BuildContext {
  /// Replaces whatever message is on screen with [message].
  void showSnack(String message, {Key? key}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(key: key, content: Text(message)));
  }
}
