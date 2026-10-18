import 'package:streetbite_capstone/domain/entities/cart_item_entity.dart';
import 'package:streetbite_capstone/domain/entities/meal_entity.dart';
import 'package:streetbite_capstone/domain/entities/order_entity.dart';
import 'package:streetbite_capstone/domain/entities/payment.dart';
import 'package:streetbite_capstone/domain/entities/user_entity.dart';
import 'package:streetbite_capstone/domain/usecases/calculate_order_totals.dart';

/// Canned entities shared by the test suite.
///
/// Centralising the fixtures means a change to an entity's shape breaks one
/// file instead of twenty tests, and it keeps the tests themselves focused on
/// behaviour rather than on object construction.
class TestFixtures {
  const TestFixtures._();

  static MealEntity meal({
    String id = 'meal-1',
    String name = 'Koshari',
    double price = 12.5,
    String category = 'Egyptian',
  }) => MealEntity(
    id: id,
    name: name,
    category: category,
    area: 'Egypt',
    instructions: 'Mix lentils, rice and pasta.',
    thumbnailUrl: 'https://example.com/$id.jpg',
    price: price,
  );

  static List<MealEntity> meals(int count) => List.generate(
    count,
    (index) => meal(id: 'meal-$index', name: 'Meal $index'),
  );

  static UserEntity user({
    String uid = 'u1',
    String email = 'yasmine@streetbite.app',
    String displayName = 'Yasmine Adel',
  }) => UserEntity(uid: uid, email: email, displayName: displayName);

  /// A two-line order whose money comes from `CalculateOrderTotals` — the same
  /// use case the cart and checkout use, so a receipt test can never assert
  /// against totals the production code would not have produced.
  static OrderEntity order({
    String id = 'sb-1001',
    OrderStatus status = OrderStatus.past,
    PaymentMethod payment = const CardPayment(),
    DateTime? placedAt,
    List<CartItemEntity>? items,
  }) {
    final lines =
        items ??
        [
          CartItemEntity(
            meal: meal(id: 'koshari', name: 'Koshari', price: 12.5),
            quantity: 2,
          ),
          CartItemEntity(
            meal: meal(id: 'foul', name: 'Foul Medames', price: 6),
            quantity: 1,
          ),
        ];
    final totals = const CalculateOrderTotals()(
      CalculateOrderTotalsParams(items: lines),
    );

    return OrderEntity(
      id: id,
      userId: 'u1',
      items: lines,
      subtotal: totals.subtotal,
      deliveryFee: totals.deliveryFee,
      serviceFee: totals.serviceFee,
      payment: payment,
      placedAt: placedAt ?? DateTime(2026, 3, 12, 18, 45),
      status: status,
    );
  }
}
