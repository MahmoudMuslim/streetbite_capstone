import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/meal_entity.dart';
import '../../../domain/usecases/get_favourites.dart';
import '../../../domain/usecases/toggle_favourite.dart';
import 'favourites_state.dart';

/// Owns the saved-meals list shared by the Profile screen and the heart button
/// on every meal card.
///
/// Keeping one Cubit app-wide (rather than one per screen) is what makes the
/// heart on the Home grid and the list on the Profile screen stay in sync the
/// instant a meal is toggled — no manual refresh, no duplicated fetch.
class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit({
    required this._getFavourites,
    required this._toggleFavourite,
  }) : super(const FavouritesInitial());

  final GetFavourites _getFavourites;
  final ToggleFavourite _toggleFavourite;

  /// Loads favourites for [uid]; a signed-out user gets an empty list.
  Future<void> load(String uid) async {
    if (uid.isEmpty) {
      emit(const FavouritesLoaded([]));
      return;
    }
    emit(const FavouritesLoading());
    final result = await _getFavourites(uid);
    result.fold(
      (failure) => emit(FavouritesError(failure.messageKey)),
      (meals) => emit(FavouritesLoaded(meals)),
    );
  }

  /// Saves / removes [meal]; returns the resulting "is saved" flag.
  ///
  /// The list is updated optimistically *after* the write succeeds, so a
  /// failed write can never leave a heart that lies about the backend state.
  Future<bool?> toggle(String uid, MealEntity meal) async {
    final result = await _toggleFavourite(
      ToggleFavouriteParams(uid: uid, meal: meal),
    );

    return result.fold(
      (failure) {
        emit(FavouritesError(failure.messageKey));
        return null;
      },
      (isSaved) {
        final current = switch (state) {
          FavouritesLoaded(:final meals) => meals,
          _ => <MealEntity>[],
        };
        final updated = isSaved
            ? [meal, ...current.where((item) => item.id != meal.id)]
            : current.where((item) => item.id != meal.id).toList();
        emit(FavouritesLoaded(updated));
        return isSaved;
      },
    );
  }
}
