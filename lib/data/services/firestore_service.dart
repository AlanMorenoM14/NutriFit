import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic Firestore service for CRUD operations.
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get a document by path.
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collection,
    String docId,
  ) {
    return _firestore.collection(collection).doc(docId).get();
  }

  /// Add a document with an auto-generated ID.
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collection).add(data);
  }

  /// Set a document (create or overwrite).
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) {
    return _firestore
        .collection(collection)
        .doc(docId)
        .set(data, SetOptions(merge: merge));
  }

  /// Update specific fields in a document.
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collection).doc(docId).update(data);
  }

  /// Stream a single document.
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(
    String collection,
    String docId,
  ) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }

  /// Query a collection with optional filters.
  Future<QuerySnapshot<Map<String, dynamic>>> queryCollection(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    if (filters != null) {
      for (final filter in filters) {
        switch (filter.operator) {
          case QueryOperator.isEqualTo:
            query = query.where(filter.field, isEqualTo: filter.value);
          case QueryOperator.arrayContains:
            query = query.where(filter.field, arrayContains: filter.value);
          case QueryOperator.isGreaterThan:
            query = query.where(filter.field, isGreaterThan: filter.value);
          case QueryOperator.isLessThan:
            query = query.where(filter.field, isLessThan: filter.value);
        }
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  /// Stream a query.
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    if (filters != null) {
      for (final filter in filters) {
        switch (filter.operator) {
          case QueryOperator.isEqualTo:
            query = query.where(filter.field, isEqualTo: filter.value);
          case QueryOperator.arrayContains:
            query = query.where(filter.field, arrayContains: filter.value);
          case QueryOperator.isGreaterThan:
            query = query.where(filter.field, isGreaterThan: filter.value);
          case QueryOperator.isLessThan:
            query = query.where(filter.field, isLessThan: filter.value);
        }
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    return query.snapshots();
  }
}

/// Filter helper for Firestore queries.
class QueryFilter {
  final String field;
  final QueryOperator operator;
  final dynamic value;

  const QueryFilter({
    required this.field,
    required this.operator,
    required this.value,
  });
}

enum QueryOperator {
  isEqualTo,
  arrayContains,
  isGreaterThan,
  isLessThan,
}
