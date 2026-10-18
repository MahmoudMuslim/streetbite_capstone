import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/meal_entity.dart';
import '../../../domain/usecases/get_meals.dart';
import 'meals_state.dart';

/// Drives the Home screen: the featured banner, the meals grid and the Hot
/// Offers strip.
///
/// Both requests are launched together and awaited as one future so the grid
/// and the offers row appear in the same frame — a screen that pops in twice
/// looks broken even when it works.
class MealsCubit extends Cubit<MealsState> {
  MealsCubit({required this._getMeals, required this._getHotOffers})
    : super(const MealsInitial());

  final GetMeals _getMeals;
  final GetHotOffers _getHotOffers;

  Future<void> load({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(const MealsLoading());
    } else if (state is! MealsLoaded) {
      emit(const MealsLoading());
    }

    final mealsFuture = _getMeals(const NoParams());
    final offersFuture = _getHotOffers(const NoParams());

    final mealsResult = await mealsFuture;
    final offersResult = await offersFuture;

    mealsResult.fold(
      (failure) => emit(MealsError(failure.messageKey)),
      (meals) => emit(
        MealsLoaded(
          meals: meals,
          hotOffers: offersResult.valueOrNull ?? const <MealEntity>[],
        ),
      ),
    );
  }
}
