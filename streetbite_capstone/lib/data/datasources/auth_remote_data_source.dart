import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failures.dart';
import '../models/user_model.dart';

/// Remote data source backed by **Firebase Authentication**.
///
/// It translates `FirebaseAuthException` codes into StreetBite failure keys
/// here, once, so that no screen ever has to import `firebase_auth` and no
/// Firebase error code is duplicated across widgets.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._auth);

  final FirebaseAuth _auth;

  /// The currently persisted session, or `null` when signed out.
  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebase(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  Stream<UserModel?> authStateChanges() => _auth.authStateChanges().map((user) {
    if (user == null) return null;
    return UserModel.fromFirebase(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  });

  /// Forces a brand-new ID token for the persisted session.
  ///
  /// Needed after a cold start. `currentUser` is restored from disk together
  /// with a cached ID token that may already be expired, and Firestore attaches
  /// that stale token to its first request — which the server rejects with
  /// `PERMISSION_DENIED`, indistinguishable from wrong security rules.
  /// Refreshing here means every later Firestore read carries a valid token.
  Future<void> refreshIdToken() async {
    await _auth.currentUser?.getIdToken(true);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthFailure('authErrorUnknown');
      return UserModel.fromFirebase(
        uid: user.uid,
        email: user.email ?? email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(mapAuthError(error.code), details: error.message);
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // displayName is *not* part of the sign-up payload, so it is written in
      // a second call. If it fails the account still exists, hence the guard.
      await credential.user?.updateDisplayName(displayName);
      return UserModel.fromFirebase(
        uid: credential.user?.uid ?? '',
        email: email,
        displayName: displayName,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(mapAuthError(error.code), details: error.message);
    }
  }

  Future<void> logout() => _auth.signOut();

  /// Maps a Firebase error code to the ARB key describing it for the user.
  ///
  /// This is the single translation table for the whole app — add a Firebase
  /// code here once and every screen benefits.
  static String mapAuthError(String code) => switch (code) {
    'invalid-email' => 'authErrorInvalidEmail',
    'email-already-in-use' => 'authErrorEmailInUse',
    'weak-password' => 'authErrorWeakPassword',
    'user-not-found' => 'authErrorUserNotFound',
    'wrong-password' => 'authErrorWrongPassword',
    'invalid-credential' => 'authErrorWrongPassword',
    'too-many-requests' => 'authErrorTooManyRequests',
    'network-request-failed' => 'authErrorNetwork',
    _ => 'authErrorUnknown',
  };
}
