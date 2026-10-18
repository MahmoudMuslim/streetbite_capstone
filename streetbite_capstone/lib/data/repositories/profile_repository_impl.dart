import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/error/either.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/firestore_service.dart';
import '../models/user_model.dart';

/// Reads and writes `users/{uid}` through the [FirestoreService] singleton.
///
/// When Firestore is not available (offline fallback mode) the repository
/// resolves from the local session instead of failing, so the Profile screen
/// still shows the signed-in user's data.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._firestore);

  final FirestoreService _firestore;

  @override
  Future<Either<Failure, UserEntity?>> getProfile(String uid) async {
    if (!_firestore.isAvailable) {
      return const Right<Failure, UserEntity?>(null);
    }
    try {
      final data = await _firestore.readDocument(
        AppConstants.usersCollection,
        uid,
      );
      return Right<Failure, UserEntity?>(
        data == null ? null : UserModel.fromJson(data),
      );
    } on FirebaseException catch (error) {
      return Left(ServerFailure(details: error.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(UserEntity user) async {
    if (!_firestore.isAvailable) return const Right(null);
    try {
      await _firestore.upsertDocument(
        AppConstants.usersCollection,
        user.uid,
        // `UserModel` owns serialisation, so the domain entity is widened to
        // its model here - the one place where a domain object becomes a
        // Firestore payload.
        UserModel.fromEntity(user).toJson(),
      );
      return const Right(null);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(details: error.message));
    }
  }

  @override
  Future<Either<Failure, String>> updatePhotoUrl({
    required String uid,
    required String photoUrl,
  }) async {
    if (!_firestore.isAvailable) {
      // Offline: echo the local path back so the UI still updates instantly.
      return Right<Failure, String>(photoUrl);
    }
    try {
      await _firestore.upsertDocument(
        AppConstants.usersCollection,
        uid,
        <String, dynamic>{UserModel.photoUrlKey: photoUrl},
      );
      return Right<Failure, String>(photoUrl);
    } on FirebaseException catch (error) {
      return Left(ServerFailure(details: error.message));
    }
  }
}
