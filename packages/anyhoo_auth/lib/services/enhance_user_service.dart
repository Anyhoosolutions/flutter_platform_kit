class EnhanceUserService {
  final Future Function(Map<String, dynamic> user) enhanceUserFunction;

  EnhanceUserService({required this.enhanceUserFunction});

  /// Log in with email and password.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user) async {
    try {
      return await enhanceUserFunction(user);
    } catch (e) {
      rethrow;
    }
  }
}
