/// Auth failure with a stable [code] apps can map to their own copy.
class AnyhooAuthException implements Exception {
  const AnyhooAuthException(this.code, {this.message});

  /// The credential being linked already belongs to another user. The app can
  /// offer to sign in to that account instead, which leaves the current
  /// (guest) user's data behind.
  static const credentialAlreadyInUse = 'credential-already-in-use';

  /// The email being linked already has an account.
  static const emailAlreadyInUse = 'email-already-in-use';

  final String code;
  final String? message;

  @override
  String toString() => message == null
      ? 'AnyhooAuthException($code)'
      : 'AnyhooAuthException($code): $message';
}
