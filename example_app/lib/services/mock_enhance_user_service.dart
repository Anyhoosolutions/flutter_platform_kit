import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';

/// Creates a mock EnhanceUserService for demonstration purposes.
///
/// In a real app, this would make actual API calls.
///
class MockEnhanceUserService<T extends AnyhooUser> extends AnyhooEnhanceUserService<T> {
  String phoneNumber = '212-555-1234';
  final AnyhooUserConverter<T> _converter;

  MockEnhanceUserService({required AnyhooUserConverter<T> converter}) : _converter = converter;

  @override
  Future<T> enhanceUser(T user) async {
    return _converter.fromJson({
      ...user.toJson(),
      'extra': 'here is more',
      'avatarUrl': 'enhanced avatar url',
      'phoneNumber': phoneNumber,
    });
  }

  @override
  Future<T> saveUser(T user) async {
    return user;
  }
}
