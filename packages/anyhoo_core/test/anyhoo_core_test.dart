import 'package:flutter_test/flutter_test.dart';

import 'package:anyhoo_core/anyhoo_core.dart';

void main() {
  group('AuthUser', () {
    test('can be extended by concrete implementations', () {
      final user = TestUser(id: '1', email: 'test@example.com');
      expect(user.id, '1');
      expect(user.email, 'test@example.com');
    });
  });
}

// Test implementation
class TestUser implements AnyhooUser {
  final String id;
  final String email;

  TestUser({required this.id, required this.email});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
