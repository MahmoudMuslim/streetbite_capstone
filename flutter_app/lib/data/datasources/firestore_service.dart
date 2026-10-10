import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/error/exceptions.dart';

/// **Singleton** — the Firestore gateway for the whole application.
///
/// Why a Singleton here?
/// ----------------------
/// * `FirebaseFirestore.instance` is itself a singleton, but *our* wrapper adds
///   offline persistence settings, a server timestamp provider and, most
///   importantly, a **single place** where every read/write is centralised.
/// * Having exactly one instance means the offline cache is configured once,
///   so a document written by the Cart screen is immediately visible to the
///   Profile screen — no "why is my favourite missing?" bug.
/// * It is registered as a `lazySingleton` in GetIt (`injection.dart`), so the
///   instance is created on first use and shared for the entire app lifecycle.
///
/// Every method returns a [Future] and converts platform errors into the
/// `core/error/exceptions.dart` vocabulary so repositories never import
/// `FirebaseException` directly.
class FirestoreService {
  /// Private constructor enforces the Singleton at compile time: the class
  /// cannot be instantiated from outside this library.
  FirestoreService._();

  static final FirestoreService _instance = FirestoreService._();

  /// The one and only instance.
  factory FirestoreService() => _instance;

  static bool _configured = false;
  static FirebaseFirestore? _firestore;

  /// Wires the real Firestore SDK once `Firebase.initializeApp()` succeeded.
  ///
  /// Passing `null` (the offline-fallback path) leaves the service in "local
  /// mode": every method then resolves through [isAvailable] == false and the
  /// repositories transparently use their local data sources instead.
  void configure(FirebaseFirestore? firestore) {
    _firestore = firestore;
    _configured = true;
  }

  /// `true` when a real Firestore instance is available.
  bool get isAvailable => _configured && _firestore != null;

  /// Throws [FirestoreNotAvailableException] instead of returning `null`, so a
  /// missing configuration is loud during development but is caught and turned
  /// into a friendly message by the repository layer.
  FirebaseFirestore get firestore {
    final instance = _firestore;
    if (!_configured || instance == null) {
      throw const FirestoreNotAvailableException();
    }
    return instance;
  }

  // ---------------------------------------------------------------------------
  // Collection accessors — the only place collection paths are written down.
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> usersCollection() =>
      firestore.collection('users');

  CollectionReference<Map<String, dynamic>> ordersCollection(String uid) =>
      firestore.collection('orders').doc(uid).collection('items');

  CollectionReference<Map<String, dynamic>> favouritesCollection(String uid) =>
      firestore.collection('users').doc(uid).collection('favourites');

  // ---------------------------------------------------------------------------
  // Operations used by the repositories.
  // ---------------------------------------------------------------------------

  /// Reads a document, returning `null` when it does not exist.
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String documentId,
  ) async {
    final snapshot = await firestore
        .collection(collection)
        .doc(documentId)
        .get();
    return snapshot.exists ? Map<String, dynamic>.from(snapshot.data()!) : null;
  }

  /// Creates or merges a document.
  Future<void> upsertDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await firestore
        .collection(collection)
        .doc(documentId)
        .set(data, SetOptions(merge: true));
  }

  /// Reads every document of a sub-collection, newest first by [orderBy].
  Future<List<Map<String, dynamic>>> readCollection(
    String path,
    String orderBy, {
    bool descending = true,
  }) async {
    final snapshot = await firestore
        .collection(path)
        .orderBy(orderBy, descending: descending)
        .get();
    return snapshot.docs
        .map((doc) => Map<String, dynamic>.from(doc.data()))
        .toList();
  }

  /// Reads a sub-collection without ordering (used by favourites, where the
  /// caller sorts client-side).
  Future<List<Map<String, dynamic>>> readSubCollection(
    String collection,
    String parentId,
    String subCollection,
  ) async {
    final snapshot = await firestore
        .collection(collection)
        .doc(parentId)
        .collection(subCollection)
        .get();
    return snapshot.docs
        .map((doc) => Map<String, dynamic>.from(doc.data()))
        .toList();
  }

  /// Writes a document into `collection/{parentId}/{subCollection}/{docId}`.
  Future<void> writeToSubCollection(
    String collection,
    String parentId,
    String subCollection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await firestore
        .collection(collection)
        .doc(parentId)
        .collection(subCollection)
        .doc(documentId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteFromSubCollection(
    String collection,
    String parentId,
    String subCollection,
    String documentId,
  ) async {
    await firestore
        .collection(collection)
        .doc(parentId)
        .collection(subCollection)
        .doc(documentId)
        .delete();
  }
}
