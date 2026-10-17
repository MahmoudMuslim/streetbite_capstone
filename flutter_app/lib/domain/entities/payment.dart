/// Payment strategies for the checkout screen.
///
/// SOLID in action
/// ---------------
/// * **S**ingle responsibility — each concrete class knows exactly one way of
///   paying: `CashPayment` collects money on delivery, `CardPayment` charges a
///   saved card. Adding a wallet means adding a class, never editing these.
/// * **O**pen/closed — the checkout screen depends on the [PaymentMethod]
///   *abstraction*. New payment types are added without touching existing
///   code, so the system stays open for extension but closed for modification.
/// * **L**iskov substitution — every implementation can be swapped for any
///   other behind a `PaymentMethod` reference.
/// * **I**nterface segregation — the interface has three narrow members and
///   nothing more, so no client is forced to depend on methods it ignores.
/// * **D**ependency inversion — the screen depends on this domain interface,
///   never on a concrete payment class or on any data-layer detail.
///
/// The entity layer also needs to persist the chosen type, so the enum
/// [PaymentType] is what actually travels to Firestore as a string.
library;

/// Persisted discriminator for the payment strategy.
enum PaymentType {
  cash('cash'),
  card('card');

  const PaymentType(this.key);

  /// Stable key written to / read from Firestore.
  final String key;

  static PaymentType fromKey(String? key) => PaymentType.values.firstWhere(
    (type) => type.key == key,
    orElse: () => PaymentType.cash,
  );
}

/// Common contract implemented by every payment strategy.
abstract interface class PaymentMethod {
  /// Discriminator used for serialisation.
  PaymentType get type;

  /// Short label key resolved through the ARB files at render time.
  String get labelKey;

  /// Secondary helper text key shown under the payment option.
  String get descriptionKey;

  /// Human readable receipt line for the order detail screen.
  String receiptLine(String localizedType);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PaymentMethod && other.type == type;

  @override
  int get hashCode => type.hashCode;
}

/// Strategy #1 — the customer pays the vendor in cash on delivery.
class CashPayment implements PaymentMethod {
  const CashPayment();

  @override
  PaymentType get type => PaymentType.cash;

  @override
  String get labelKey => 'payCash';

  @override
  String get descriptionKey => 'cashOnDeliveryHint';

  @override
  String receiptLine(String localizedType) => localizedType;

  @override
  bool operator ==(Object other) => other is CashPayment;

  @override
  int get hashCode => type.hashCode;
}

/// Strategy #2 — the customer pays with a stored card.
class CardPayment implements PaymentMethod {
  const CardPayment({this.last4 = '4242'});

  /// Only the last four digits are ever persisted (PCI-safe by design).
  final String last4;

  @override
  PaymentType get type => PaymentType.card;

  @override
  String get labelKey => 'payCard';

  @override
  String get descriptionKey => 'cardPaymentHint';

  @override
  String receiptLine(String localizedType) => '$localizedType ····$last4';

  @override
  bool operator ==(Object other) =>
      other is CardPayment && other.last4 == last4;

  @override
  int get hashCode => Object.hash(type, last4);
}
