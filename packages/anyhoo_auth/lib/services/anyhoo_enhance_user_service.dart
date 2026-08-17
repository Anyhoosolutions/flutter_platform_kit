import 'package:anyhoo_models/anyhoo_models.dart';

abstract class AnyhooEnhanceUserService<T extends AnyhooUser> {
  AnyhooEnhanceUserService();

  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user);

  Future<T> saveUser(T user);
}
