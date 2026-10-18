import 'package:equatable/equatable.dart';

/// A StreetBite account.
///
/// The [bio] field only exists for users created through the Sign Up flow,
/// which is why the data layer builds this entity through a **Builder**
/// (see `UserModel.builder()`), letting each call site set only the fields it
/// actually knows about.
class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.photoUrl,
    this.createdAt,
  });

  /// Stable Firebase (or local) user identifier.
  final String uid;

  final String email;
  final String displayName;

  /// Remote URL of the Firestore-hosted profile picture.
  final String? photoUrl;

  final DateTime? createdAt;

  UserEntity copyWith({String? displayName, String? photoUrl}) => UserEntity(
    uid: uid,
    email: email,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl ?? this.photoUrl,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, createdAt];
}
