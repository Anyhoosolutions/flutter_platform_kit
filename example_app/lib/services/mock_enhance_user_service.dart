import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';

/// Creates a mock EnhanceUserService for demonstration purposes.
///
/// In a real app, this would make actual API calls.
///
class MockEnhanceUserService<T extends AnyhooUser> extends AnyhooEnhanceUserService<T> {
  String phoneNumber = '212-555-1234';

  MockEnhanceUserService();

  @override
  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user) async {
    return {...user, 'phoneNumber': phoneNumber};
  }

  @override
  Future<T> saveUser(T user) async {
    return user;
  }
}
