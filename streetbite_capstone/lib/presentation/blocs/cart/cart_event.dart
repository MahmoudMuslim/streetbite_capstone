import 'package:equatable/equatable.dart';

import '../../../domain/entities/meal_entity.dart';
import '../../../domain/entities/payment.dart';
import '../../../domain/entities/user_entity.dart';

/// Events accepted by [CartBloc].
///
/// A full Bloc (not a Cubit) is used here because the cart has genuine
/// *event-driven* behaviour: `AddToCartRequested` carries a payload, and
/// `BlocListener` reacts to the resulting state transitions (SnackBars, badge
/// updates). Naming the events makes those transitions explicit and testable
/// instead of hiding them inside imperative method calls.
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => const [];
}

/// Adds a meal, or increments it when it is already in the cart.
class CartItemAdded extends CartEvent {
  const CartItemAdded(this.meal);

  final MealEntity meal;

  @override
  List<Object?> get props => [meal];
}

/// Removes one serving; drops the line at zero.
class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.mealId);

  final String mealId;

  @override
  List<Object?> get props => [mealId];
}

/// Empties the cart — dispatched after a successful checkout.
class CartCleared extends CartEvent {
  const CartCleared();
}

/// Increments/decrements a line by an explicit delta from the Cart screen.
class CartItemQuantityChanged extends CartEvent {
  const CartItemQuantityChanged(this.mealId, this.delta);

  final String mealId;
  final int delta;

  @override
  List<Object?> get props => [mealId, delta];
}

/// Checks out the cart.
///
/// Modelled as an event rather than a method for two reasons: the Bloc may
/// emit from the handler (which the framework only permits inside an event
/// handler), and keeping *all* state transitions event-driven means the whole
/// cart — including checkout — is replayable in a test.
class CartCheckoutRequested extends CartEvent {
  const CartCheckoutRequested({required this.user, required this.payment});

  final UserEntity user;
  final PaymentMethod payment;

  @override
  List<Object?> get props => [user.uid, payment.type];
}
