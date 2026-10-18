import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streetbite_capstone/l10n/generated/app_localizations.dart';
import 'package:streetbite_capstone/presentation/extensions/l10n_extension.dart';

/// Guards the *dynamic* half of the localisation bridge.
///
/// Widgets that resolve a message through a key coming from the domain (a
/// payment strategy, a failure, a checkout CTA) get no compile-time help: an
/// unwired key silently renders the generic error sentence. That is exactly how
/// the Place-order button once read "Something went wrong", so every key that
/// can arrive dynamically is asserted on here.
void main() {
  /// Pumps a throwaway widget and hands the test its [BuildContext], so the
  /// extension under test runs against the real `AppLocalizations`.
  Future<void> pumpIn(
    WidgetTester tester,
    Locale locale,
    void Function(BuildContext context) read,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            read(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the checkout CTA resolves instead of falling back', (
    tester,
  ) async {
    late String label;
    await pumpIn(tester, const Locale('en'), (context) {
      label = context.trArgs('placeOrderFor', {'amount': '\$23.14'});
    });

    expect(label, 'Place order · \$23.14');
    expect(label, isNot(contains('wrong')));
  });

  testWidgets('both payment strategies resolve to their wording', (
    tester,
  ) async {
    late List<String> lines;
    await pumpIn(tester, const Locale('en'), (context) {
      lines = [
        context.trKey('payCash'),
        context.trKey('payCard'),
        context.trKey('cashOnDeliveryHint'),
        context.trKey('cardPaymentHint'),
      ];
    });

    expect(lines, [
      'Cash',
      'Card',
      'Pay the vendor in cash when your order arrives.',
      'Visa / Mastercard ending in 4242.',
    ]);
  });

  testWidgets('failure and empty-state keys stay wired', (tester) async {
    late List<String> lines;
    await pumpIn(tester, const Locale('en'), (context) {
      lines = [
        context.trKey('failureNetwork'),
        context.trKey('orderHistoryEmpty'),
        context.trKey('browseMenu'),
      ];
    });

    expect(lines.first, contains('StreetBite'));
    expect(lines[1], 'No orders yet');
    expect(lines[2], 'Browse menu');
  });

  testWidgets('order dates follow the active locale', (tester) async {
    final placed = DateTime(2026, 3, 12, 18, 45);
    late String english;
    late String arabic;

    await pumpIn(tester, const Locale('en'), (context) {
      english = context.formatOrderDate(placed);
    });
    await pumpIn(tester, const Locale('ar'), (context) {
      arabic = context.formatOrderDate(placed);
    });

    expect(english, allOf(contains('Mar'), contains('2026'), contains('6:45')));
    // An uninitialised intl locale would throw inside `formatOrderDate`; the
    // Arabic string also has to differ, or the receipt leaks English copy.
    expect(arabic, isNotEmpty);
    expect(arabic, isNot(english));
  });
}
