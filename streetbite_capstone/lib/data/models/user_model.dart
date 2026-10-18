import '../../domain/entities/user_entity.dart';

/// Data-layer representation of a StreetBite account.
///
/// **Builder pattern — why it is used here**
/// ------------------------------------------
/// A `UserEntity` can be produced from four very different places:
///
/// 1. Firebase Auth during sign-up  → knows uid, email and display name.
/// 2. A Firestore profile document  → knows the same fields *plus* photoUrl.
/// 3. The local fallback store      → knows email + password hash + name.
/// 4. A silent sign-in restore      → knows only uid and email.
///
/// A constructor with eight required parameters would force every one of those
/// call sites to invent values for fields it does not have. The builder lets a
/// call site set **only what it actually knows** and leaves the rest at their
/// defaults — which is exactly what the requirement asks for ("only sign-up
/// fields are set on construction").
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.createdAt,
  });

  static const String uidKey = 'uid';
  static const String emailKey = 'email';
  static const String displayNameKey = 'displayName';
  static const String photoUrlKey = 'photoUrl';
  static const String createdAtKey = 'createdAt';
  static const String passwordHashKey = 'passwordHash';

  /// Entry point of the Builder pattern.
  static UserBuilder builder() => UserBuilder();

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel.builder()
      .uid((json[uidKey] ?? '').toString())
      .email((json[emailKey] ?? '').toString())
      .displayName((json[displayNameKey] ?? '').toString())
      .photoUrl(_nullableString(json[photoUrlKey]))
      .createdAt(_nullableDate(json[createdAtKey]))
      .build();

  /// Creates a user from a successful Firebase registration.
  factory UserModel.fromFirebase({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) => UserModel.builder()
      .uid(uid)
      .email(email)
      .displayName(displayName)
      .photoUrl(photoUrl)
      .createdAt(DateTime.now())
      .build();

  /// Widens a domain entity into its serialisable model.
  ///
  /// Repositories use this at the very edge of the data layer, which is the
  /// only place where a domain object is allowed to become a payload.
  factory UserModel.fromEntity(UserEntity entity) => UserModel.builder()
      .uid(entity.uid)
      .email(entity.email)
      .displayName(entity.displayName)
      .photoUrl(entity.photoUrl)
      .createdAt(entity.createdAt)
      .build();

  Map<String, dynamic> toJson() => <String, dynamic>{
    uidKey: uid,
    emailKey: email,
    displayNameKey: displayName,
    photoUrlKey: photoUrl,
    createdAtKey: createdAt?.toIso8601String(),
  };

  @override
  UserModel copyWith({String? displayName, String? photoUrl}) =>
      UserModel.builder()
          .uid(uid)
          .email(email)
          .displayName(displayName ?? this.displayName)
          .photoUrl(photoUrl ?? this.photoUrl)
          .createdAt(createdAt)
          .build();

  static String? _nullableString(Object? value) {
    final text = value?.toString() ?? '';
    return text.isEmpty ? null : text;
  }

  static DateTime? _nullableDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

/// Fluent builder that assembles a [UserModel] step by step.
///
/// Every setter returns `this` so calls chain, and [build] is the only place
/// that constructs the immutable model. Unset fields fall back to their
/// defaults, which is what allows partial knowledge at the call site.
///
/// A common *optimisation* of the pattern would be to cache the created part,
/// but StreetBite builds at most one user per session, so a plain mutable
/// builder is the right trade-off here.
class UserBuilder {
  UserBuilder();

  String _uid = '';
  String _email = '';
  String _displayName = '';
  String? _photoUrl;
  DateTime? _createdAt;

  UserBuilder uid(String value) {
    _uid = value;
    return this;
  }

  UserBuilder email(String value) {
    _email = value;
    return this;
  }

  UserBuilder displayName(String? value) {
    _displayName = value ?? '';
    return this;
  }

  UserBuilder photoUrl(String? value) {
    _photoUrl = (value == null || value.isEmpty) ? null : value;
    return this;
  }

  UserBuilder createdAt(DateTime? value) {
    _createdAt = value;
    return this;
  }

  UserModel build() => UserModel(
    uid: _uid,
    email: _email,
    displayName: _displayName,
    photoUrl: _photoUrl,
    createdAt: _createdAt,
  );
}
