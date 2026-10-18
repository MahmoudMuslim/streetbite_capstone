import 'package:equatable/equatable.dart';

import '../../../domain/entities/meal_entity.dart';

/// States emitted by [MealsCubit] for the Home feed.
sealed class MealsState extends Equatable {
  const MealsState();

  @override
  List<Object?> get props => const [];
}

/// First load — the grid shows a `CircularProgressIndicator`.
class MealsInitial extends MealsState {
  const MealsInitial();
}

/// A refresh is running while stale content stays on screen.
class MealsLoading extends MealsState {
  const MealsLoading();
}

/// Successful load.
class MealsLoaded extends MealsState {
  const MealsLoaded({required this.meals, required this.hotOffers});

  final List<MealEntity> meals;
  final List<MealEntity> hotOffers;

  @override
  List<Object?> get props => [meals, hotOffers];
}

/// The feed could not be loaded; [messageKey] is resolved through the ARB files.
class MealsError extends MealsState {
  const MealsError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
