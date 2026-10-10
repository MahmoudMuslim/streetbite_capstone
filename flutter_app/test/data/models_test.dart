import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:streetbite_capstone/data/models/meal_model.dart';
import 'package:streetbite_capstone/data/models/payment_model.dart';
import 'package:streetbite_capstone/data/models/user_model.dart';
import 'package:streetbite_capstone/domain/entities/payment.dart';

void main() {
  group('MealModel', () {
    /// Minimal but realistic TheMealDB payload.
    final apiJson = <String, dynamic>{
      'idMeal': '52771',
      'strMeal': 'Spicy Arrabiata Penne',
      'strCategory': 'Pasta',
      'strArea': 'Italian',
      'strInstructions': 'Cook the pasta...',
      'strMealThumb': 'https://example.com/arrabiata.jpg',
      'strTags': 'Pasta,Curry',
      'strYoutube': 'https://youtu.be/abc',
    };

    test('parses a TheMealDB payload', () {
      final meal = MealModel.fromApiJson(apiJson);

      expect(meal.id, '52771');
      expect(meal.name, 'Spicy Arrabiata Penne');
      expect(meal.category, 'Pasta');
      expect(meal.area, 'Italian');
      expect(meal.tags, ['Pasta', 'Curry']);
      expect(meal.youtubeUrl, 'https://youtu.be/abc');
    });

    test('survives a round trip through toJson/fromJson', () {
      final original = MealModel.fromApiJson(apiJson);

      final restored = MealModel.fromJson(
        jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
      );

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.price, original.price);
      expect(restored.tags, original.tags);
    });

    test('derives a stable price from the meal id', () {
      final first = MealModel.fromApiJson(apiJson).price;
      final second = MealModel.fromApiJson(apiJson).price;

      expect(first, second, reason: 'price must not change between loads');
      expect(first, inInclusiveRange(6.99, 24.99));
    });

    test('substitutes fallbacks for missing fields', () {
      final meal = MealModel.fromApiJson({
        'idMeal': '1',
        'strMeal': 'Mystery',
      });

      expect(meal.category, isNotEmpty);
      expect(meal.area, isNotEmpty);
      expect(meal.instructions, isEmpty);
      expect(meal.tags, isEmpty);
    });

    test('returns a null youtube url rather than an empty string', () {
      final meal = MealModel.fromApiJson({...apiJson, 'strYoutube': ''});

      expect(meal.youtubeUrl, isNull);
    });
  });

  group('UserModel (Builder pattern)', () {
    test('builds a user from only the fields the caller knows', () {
      // This is the whole point of the builder: a Firebase restore knows the
      // uid and the e-mail but nothing else.
      final user = UserModel.builder().uid('u1').email('a@b.com').build();

      expect(user.uid, 'u1');
      expect(user.email, 'a@b.com');
      expect(user.displayName, '');
      expect(user.photoUrl, isNull);
      expect(user.createdAt, isNull);
    });

    test('supports the full sign-up payload', () {
      final user = UserModel.builder()
          .uid('u1')
          .email('a@b.com')
          .displayName('Yasmine Adel')
          .photoUrl('https://example.com/me.png')
          .createdAt(DateTime(2026, 1, 1))
          .build();

      expect(user.displayName, 'Yasmine Adel');
      expect(user.photoUrl, 'https://example.com/me.png');
      expect(user.createdAt, DateTime(2026, 1, 1));
    });

    test('treats an empty photo url as "no photo"', () {
      final user = UserModel.builder().uid('u1').photoUrl('').build();

      expect(user.photoUrl, isNull);
    });

    test('survives a round trip through JSON', () {
      final original = UserModel.fromFirebase(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Yasmine Adel',
      );

      final restored = UserModel.fromJson(
        jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
      );

      expect(restored.uid, original.uid);
      expect(restored.email, original.email);
      expect(restored.displayName, original.displayName);
      expect(restored.createdAt, original.createdAt);
    });

    test('copyWith replaces only the requested field', () {
      final original = UserModel.fromFirebase(
        uid: 'u1',
        email: 'a@b.com',
        displayName: 'Yasmine Adel',
      );

      final updated = original.copyWith(photoUrl: 'https://example.com/x.png');

      expect(updated.photoUrl, 'https://example.com/x.png');
      expect(updated.displayName, 'Yasmine Adel');
      expect(updated.email, 'a@b.com');
    });
  });

  group('PaymentModel (SOLID strategies)', () {
    test('rehydrates the cash strategy', () {
      final strategy = PaymentModel(type: PaymentType.cash).toEntity();

      expect(strategy, isA<CashPayment>());
    });

    test('rehydrates the card strategy with its masked suffix', () {
      final strategy =
          PaymentModel(type: PaymentType.card, last4: '4242').toEntity();

      expect(strategy, isA<CardPayment>());
      expect((strategy as CardPayment).last4, '4242');
    });

    test('falls back to a default suffix for a card without one', () {
      final strategy = PaymentModel(type: PaymentType.card).toEntity();

      expect((strategy as CardPayment).last4, '4242');
    });

    test('never serialises anything but the discriminator and suffix', () {
      final json = PaymentModel(type: PaymentType.cash).toJson();

      expect(json.keys, ['type']);
    });

    test('unknown persisted keys degrade to cash instead of throwing', () {
      expect(PaymentType.fromKey('bitcoin'), PaymentType.cash);
    });
  });
}
