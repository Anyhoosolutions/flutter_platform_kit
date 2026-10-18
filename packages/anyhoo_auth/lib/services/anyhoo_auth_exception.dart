/// Auth failure with a stable [code] apps can map to their own copy.
class AnyhooAuthException implements Exception {
  const AnyhooAuthException(this.code, {this.message});

  final String code;
  final String? message;

  @override
  String toString() => message == null
      ? 'AnyhooAuthException($code)'
      : 'AnyhooAuthException($code): $message';
}
