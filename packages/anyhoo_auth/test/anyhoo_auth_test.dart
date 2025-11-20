import 'package:flutter_test/flutter_test.dart';

import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:anyhoo_core/anyhoo_core.dart';

void main() {
  group('AuthService', () {
    test('can be instantiated with a converter', () {
      final converter = _TestUserConverter();
      final service = AuthService<TestUser>(
        converter: converter,
        emailLoginFunction: (email, password) async => {'id': '1', 'email': email},
      );

      expect(service, isNotNull);
      expect(service.isAuthenticated, isFalse);
    });
  });
}

// Test implementations
class TestUser extends AuthUser {
  @override
  final String id;
  @override
  final String email;

  TestUser({required this.id, required this.email});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}

class _TestUserConverter implements UserConverter<TestUser> {
  @override
  TestUser fromJson(Map<String, dynamic> json) {
    return TestUser(id: json['id'] as String, email: json['email'] as String);
  }

  @override
  Map<String, dynamic> toJson(TestUser user) => user.toJson();
}
