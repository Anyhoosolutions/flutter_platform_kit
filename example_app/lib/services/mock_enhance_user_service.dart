import 'package:anyhoo_auth/anyhoo_auth.dart';

/// Creates a mock EnhanceUserService for demonstration purposes.
///
/// In a real app, this would make actual API calls.
///
class MockEnhanceUserService extends AnyhooEnhanceUserService {
  @override
  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user) async {
    return {...user, 'extra': 'here is more', 'avatarUrl': 'enhanced avatar url'};
  }
}
