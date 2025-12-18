abstract class AnyhooEnhanceUserService {
  AnyhooEnhanceUserService();

  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user);

  Future<Map<String, dynamic>> saveUser(Map<String, dynamic> user);
}
