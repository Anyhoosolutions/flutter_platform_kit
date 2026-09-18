import 'package:cloud_firestore/cloud_firestore.dart';

enum _FirestoreWhereOp {
  equalTo,
  notEqualTo,
  lessThan,
  lessThanOrEqualTo,
  greaterThan,
  greaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
  isNull,
}

/// A single Firestore filter for [FirestoreService.getCollection] /
/// [FirestoreService.watchCollection].
///
/// Keeps app code free of `cloud_firestore` query APIs.
class FirestoreWhere {
  const FirestoreWhere._(this.field, this._op, [this._value]);

  final String field;
  final _FirestoreWhereOp _op;
  final Object? _value;

  factory FirestoreWhere.equalTo(String field, Object? value) =>
      FirestoreWhere._(field, _FirestoreWhereOp.equalTo, value);

  factory FirestoreWhere.notEqualTo(String field, Object? value) =>
      FirestoreWhere._(field, _FirestoreWhereOp.notEqualTo, value);

  factory FirestoreWhere.lessThan(String field, Object? value) =>
      FirestoreWhere._(field, _FirestoreWhereOp.lessThan, value);

  factory FirestoreWhere.lessThanOrEqualTo(String field, Object? value) =>
      FirestoreWhere._(field, _FirestoreWhereOp.lessThanOrEqualTo, value);

  factory FirestoreWhere.greaterThan(String field, Object? value) =>
      FirestoreWhere._(field, _FirestoreWhereOp.greaterThan, value);

  factory FirestoreWhere.greaterThanOrEqualTo(String field, Object? value) =>
      FirestoreWhere._(field, _FirestoreWhereOp.greaterThanOrEqualTo, value);

  factory FirestoreWhere.arrayContains(String field, Object? value) =>
      FirestoreWhere._(field, _FirestoreWhereOp.arrayContains, value);

  factory FirestoreWhere.arrayContainsAny(String field, List<Object?> values) =>
      FirestoreWhere._(field, _FirestoreWhereOp.arrayContainsAny, values);

  factory FirestoreWhere.whereIn(String field, List<Object?> values) =>
      FirestoreWhere._(field, _FirestoreWhereOp.whereIn, values);

  factory FirestoreWhere.whereNotIn(String field, List<Object?> values) =>
      FirestoreWhere._(field, _FirestoreWhereOp.whereNotIn, values);

  factory FirestoreWhere.isNull(String field) =>
      FirestoreWhere._(field, _FirestoreWhereOp.isNull);

  Query<Map<String, dynamic>> apply(Query<Map<String, dynamic>> query) {
    return switch (_op) {
      _FirestoreWhereOp.equalTo => query.where(field, isEqualTo: _value),
      _FirestoreWhereOp.notEqualTo => query.where(field, isNotEqualTo: _value),
      _FirestoreWhereOp.lessThan => query.where(field, isLessThan: _value),
      _FirestoreWhereOp.lessThanOrEqualTo =>
        query.where(field, isLessThanOrEqualTo: _value),
      _FirestoreWhereOp.greaterThan => query.where(field, isGreaterThan: _value),
      _FirestoreWhereOp.greaterThanOrEqualTo =>
        query.where(field, isGreaterThanOrEqualTo: _value),
      _FirestoreWhereOp.arrayContains =>
        query.where(field, arrayContains: _value),
      _FirestoreWhereOp.arrayContainsAny =>
        query.where(field, arrayContainsAny: _value! as List<Object?>),
      _FirestoreWhereOp.whereIn =>
        query.where(field, whereIn: _value! as List<Object?>),
      _FirestoreWhereOp.whereNotIn =>
        query.where(field, whereNotIn: _value! as List<Object?>),
      _FirestoreWhereOp.isNull => query.where(field, isNull: true),
    };
  }
}
