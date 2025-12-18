import 'package:anyhoo_core/models/anyhoo_user.dart';

abstract class AnyhooEnhanceUserService<T extends AnyhooUser> {
  AnyhooEnhanceUserService();

  Future<T> enhanceUser(T user);

  Future<T> saveUser(T user);
}
