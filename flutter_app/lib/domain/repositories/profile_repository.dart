import '../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../../core/error/either.dart';

/// Contract for the user profile document stored in Cloud Firestore at
/// `users/{uid}`.
abstract interface class ProfileRepository {
  /// Reads the profile; returns `null` when the document does not exist yet.
  Future<Either<Failure, UserEntity?>> getProfile(String uid);

  /// Creates or merges the profile document (used right after sign up).
  Future<Either<Failure, void>> saveProfile(UserEntity user);

  /// Stores the uploaded picture URL on the profile and returns the new URL.
  Future<Either<Failure, String>> updatePhotoUrl({
    required String uid,
    required String photoUrl,
  });
}
