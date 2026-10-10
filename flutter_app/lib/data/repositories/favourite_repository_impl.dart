import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/favourite_repository.dart';
import '../../core/error/either.dart';
import '../datasources/firestore_service.dart';
import '../models/favourite_model.dart';
import '../models/meal_model.dart';

/// Favourites storage, scoped to `users/{uid}/favourites`.
///
/// A toggle is implemented as *read-then-write*: the repository checks whether
/// the document already exists and either deletes it or merges it. Firestore
/// has no "toggle" primitive, and doing the check server-side would cost an
/// extra read anyway — so the single read here is both the cheapest option and
/// the one that tells us which SnackBar message to show.
class FavouriteRepositoryImpl implements FavouriteRepository {
  const FavouriteRepositoryImpl(this._firestore);

  final FirestoreService _firestore;

  @override
  Future<Either<Failure, bool>> toggleFavourite({
    required String uid,
    required MealEntity meal,
  }) async {
    if (!_firestore.isAvailable) {
      // Offline: nothing is persisted, but the caller still gets a coherent
      // "saved" answer so the UI does not flicker.
      return const Right<Failure, bool>(true);
    }
    try {
      final existing = await _firestore.readDocument(
        '${AppConstants.usersCollection}/$uid/'
        '${AppConstants.userFavouritesSubCollection}',
        meal.id,
      );

      if (existing != null) {
        await _firestore.deleteFromSubCollection(
          AppConstants.usersCollection,
          uid,
          AppConstants.userFavouritesSubCollection,
          meal.id,
        );
        return const Right<Failure, bool>(false);
      }

      await _firestore.writeToSubCollection(
        AppConstants.usersCollection,
        uid,
        AppConstants.userFavouritesSubCollection,
        meal.id,
        FavouriteModel(
          meal: MealModel.fromEntity(meal),
          savedAt: DateTime.now(),
        ).toJson(),
      );
      return const Right<Failure, bool>(true);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(details: error.message));
    }
  }

  @override
  Future<Either<Failure, List<MealEntity>>> getFavourites(String uid) async {
    if (!_firestore.isAvailable) return const Right(<MealEntity>[]);
    try {
      final docs = await _firestore.readSubCollection(
        AppConstants.usersCollection,
        uid,
        AppConstants.userFavouritesSubCollection,
      );
      final favourites =
          docs.map((doc) => FavouriteModel.fromJson(doc)).toList()
            // Most recently hearted first.
            ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return Right<Failure, List<MealEntity>>(
        favourites.map((f) => f.meal).toList(),
      );
    } on FirebaseException catch (error) {
      return Left(ServerFailure(details: error.message));
    }
  }
}
