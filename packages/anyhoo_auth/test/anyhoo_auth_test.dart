import 'package:flutter_test/flutter_test.dart';

import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:anyhoo_core/anyhoo_core.dart';

void main() {
  group('AuthService', () {
    test('can be instantiated with a converter', () {
      final service = AnyhooAuthService(
        emailLoginFunction: (email, password) async => {'id': '1', 'email': email},
      );

      expect(service, isNotNull);
      expect(service.isAuthenticated, isFalse);
    });
  });
}

// Test implementations
class TestUser extends AnyhooUser {
  @override
  final String id;
  @override
  final String email;

  TestUser({required this.id, required this.email});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
