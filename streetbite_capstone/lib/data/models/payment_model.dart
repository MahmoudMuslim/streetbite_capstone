import '../../domain/entities/payment.dart';

/// Serialisable snapshot of a [PaymentMethod] strategy.
///
/// The model stores only the *discriminator* and the masked card suffix, never
/// the payment object itself — the strategy is re-created on read by
/// [toEntity], which keeps the SOLID contract intact across the wire.
class PaymentModel {
  const PaymentModel({required this.type, this.last4});

  static const String typeKey = 'type';
  static const String last4Key = 'last4';

  final PaymentType type;
  final String? last4;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    type: PaymentType.fromKey(json[typeKey]?.toString()),
    last4: json[last4Key]?.toString(),
  );

  factory PaymentModel.fromEntity(PaymentMethod method) => PaymentModel(
    type: method.type,
    last4: method is CardPayment ? method.last4 : null,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    typeKey: type.key,
    if (last4 != null) last4Key: last4,
  };

  /// Rehydrates the SOLID strategy through [PaymentFactory] so the
  /// switch logic lives in the domain layer, not here.
  PaymentMethod toEntity() => PaymentFactory.create(type, last4: last4);
}
