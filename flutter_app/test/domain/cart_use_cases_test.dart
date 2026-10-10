import 'package:flutter_test/flutter_test.dart';
import 'package:streetbite_capstone/domain/entities/cart_item_entity.dart';
import 'package:streetbite_capstone/domain/entities/meal_entity.dart';
import 'package:streetbite_capstone/domain/usecases/add_to_cart.dart';
import 'package:streetbite_capstone/domain/usecases/calculate_order_totals.dart';
import 'package:streetbite_capstone/domain/usecases/remove_from_cart.dart';

import '../helpers/test_fixtures.dart';

void main() {
  group('AddToCart', () {
    const addToCart = AddToCart();
    final koshari = TestFixtures.meal(id: 'a', name: 'Koshari');
    final ful = TestFixtures.meal(id: 'b', name: 'Ful');

    test('creates a new line with quantity 1 for an empty cart', () {
      final result = addToCart(
        AddToCartParams(currentItems: const [], meal: koshari),
      );

      expect(result, hasLength(1));
      expect(result.single.meal.id, 'a');
      expect(result.single.quantity, 1);
    });

    test('increments the existing line instead of duplicating it', () {
      final first = addToCart(
        AddToCartParams(currentItems: const [], meal: koshari),
      );
      final second = addToCart(
        AddToCartParams(currentItems: first, meal: koshari),
      );

      expect(second, hasLength(1));
      expect(second.single.quantity, 2);
    });

    test('keeps other lines untouched', () {
      final withKoshari = addToCart(
        AddToCartParams(currentItems: const [], meal: koshari),
      );
      final withBoth = addToCart(
        AddToCartParams(currentItems: withKoshari, meal: ful),
      );

      expect(withBoth.map((item) => item.meal.id), ['a', 'b']);
    });

    test('does not mutate the list it was given', () {
      final original = <CartItemEntity>[];
      addToCart(AddToCartParams(currentItems: original, meal: koshari));

      expect(original, isEmpty);
    });
  });

  group('RemoveFromCart', () {
    const addToCart = AddToCart();
    const removeFromCart = RemoveFromCart();
    final koshari = TestFixtures.meal(id: 'a');

    List<CartItemEntity> cartWith(int quantity) => [
          CartItemEntity(meal: koshari, quantity: quantity),
        ];

    test('decrements the quantity by one', () {
      final two = addToCart(
        AddToCartParams(currentItems: cartWith(1), meal: koshari),
      );
      expect(two.single.quantity, 2, reason: 'setup sanity check');

      final result = removeFromCart(
        RemoveFromCartParams(currentItems: two, mealId: 'a'),
      );

      expect(result.single.quantity, 1);
    });

    test('drops the whole line when the quantity reaches zero', () {
      final one = cartWith(1);

      final result = removeFromCart(
        RemoveFromCartParams(currentItems: one, mealId: 'a'),
      );

      expect(result, isEmpty);
    });

    test('is a no-op for an unknown meal id', () {
      final one = cartWith(1);

      final result = removeFromCart(
        RemoveFromCartParams(currentItems: one, mealId: 'does-not-exist'),
      );

      expect(result, hasLength(1));
    });
  });

  group('CalculateOrderTotals', () {
    const calculate = CalculateOrderTotals();

    test('charges delivery and service fees on a small basket', () {
      final totals = calculate(
        const CalculateOrderTotalsParams(
          items: [CartItemEntity(meal: _meal10, quantity: 1)],
        ),
      );

      expect(totals.subtotal, 10);
      expect(totals.deliveryFee, CalculateOrderTotals.deliveryFee);
      expect(totals.serviceFee, CalculateOrderTotals.serviceFee);
      expect(
        totals.total,
        totals.subtotal + totals.deliveryFee + totals.serviceFee,
      );
      expect(totals.hasFreeDelivery, isFalse);
    });

    test('waives the delivery fee above the free-delivery threshold', () {
      final totals = calculate(
        const CalculateOrderTotalsParams(
          items: [CartItemEntity(meal: _meal40, quantity: 1)],
        ),
      );

      expect(totals.deliveryFee, 0);
      expect(totals.hasFreeDelivery, isTrue);
    });

    test('produces zeroes for an empty basket', () {
      final totals =
          calculate(const CalculateOrderTotalsParams(items: []));

      expect(totals.subtotal, 0);
      expect(totals.deliveryFee, 0);
      expect(totals.serviceFee, 0);
      expect(totals.total, 0);
    });

    test('multiplies the price by the quantity', () {
      final totals = calculate(
        const CalculateOrderTotalsParams(
          items: [CartItemEntity(meal: _meal10, quantity: 3)],
        ),
      );

      expect(totals.subtotal, 30);
    });
  });
}

const MealEntity _meal10 = MealEntity(
  id: 'm10',
  name: 'Shawarma',
  category: 'Levantine',
  area: 'Lebanon',
  instructions: 'Roll it.',
  thumbnailUrl: '',
  price: 10,
);

const MealEntity _meal40 = MealEntity(
  id: 'm40',
  name: 'Mixed Grill',
  category: 'Grill',
  area: 'Lebanon',
  instructions: 'Grill it.',
  thumbnailUrl: '',
  price: 40,
);
