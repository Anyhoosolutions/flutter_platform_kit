abstract class AnyhooEnhanceUserService {
  AnyhooEnhanceUserService();

  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user);

  Future<void> saveUser(Map<String, dynamic> user);
}
