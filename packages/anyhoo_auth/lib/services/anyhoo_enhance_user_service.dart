import 'package:anyhoo_core/models/anyhoo_user.dart';

abstract class AnyhooEnhanceUserService<T extends AnyhooUser> {
  AnyhooEnhanceUserService();

  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user);

  Future<T> saveUser(T user);
}
