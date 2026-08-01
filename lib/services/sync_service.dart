import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Best-effort sync layer on top of Firestore. Hive remains the single
/// source of truth for the UI; this service pushes local changes up and
/// streams remote changes down so multiple devices stay in sync when
/// online. Every method fails silently (logs in debug only) if Firebase
/// isn't configured or the device is offline — the app must keep
/// working with zero internet connection.
class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  static const String employeesCollection = 'employees';
  static const String scheduleEntriesCollection = 'schedule_entries';

  bool get _isAvailable => Firebase.apps.isNotEmpty;

  FirebaseFirestore? get _db => _isAvailable ? FirebaseFirestore.instance : null;

  Future<void> pushDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final db = _db;
    if (db == null) return;
    try {
      await db.collection(collection).doc(id).set(data);
    } catch (e) {
      _logFailure('push to $collection/$id', e);
    }
  }

  Future<void> deleteDocument(String collection, String id) async {
    final db = _db;
    if (db == null) return;
    try {
      await db.collection(collection).doc(id).delete();
    } catch (e) {
      _logFailure('delete $collection/$id', e);
    }
  }

  /// Streams every change (add/modify/remove) for a collection. Returns
  /// an empty stream if Firebase isn't configured.
  Stream<List<DocumentChange<Map<String, dynamic>>>> watchCollection(
    String collection,
  ) {
    final db = _db;
    if (db == null) return const Stream.empty();
    return db.collection(collection).snapshots().map((s) => s.docChanges);
  }

  void _logFailure(String action, Object error) {
    if (kDebugMode) {
      debugPrint('Sync skipped ($action): $error');
    }
  }
}
