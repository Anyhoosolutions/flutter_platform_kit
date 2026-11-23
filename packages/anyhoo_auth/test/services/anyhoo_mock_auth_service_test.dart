import 'package:anyhoo_auth/services/anyhoo_auth_exception.dart';
import 'package:anyhoo_auth/services/anyhoo_mock_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnyhooMockAuthService linking', () {
    late AnyhooMockAuthService service;

    setUp(() {
      service = AnyhooMockAuthService(loginDelay: Duration.zero);
    });

    tearDown(() => service.dispose());

    test('linking upgrades a guest and keeps the uid', () async {
      await service.loginWithAnonymous();
      final guestId = service.currentUser!['id'];

      await service.linkWithGoogle();

      final user = service.currentUser!;
      expect(user['id'], guestId);
      expect(user['isAnonymous'], false);
      expect(user['providerIds'], ['google.com']);
    });

    test('linking an email sets it on the user', () async {
      await service.loginWithAnonymous();

      await service.linkWithEmailAndPassword('me@example.com', 'secret1');

      expect(service.currentUser!['email'], 'me@example.com');
      expect(service.currentUser!['providerIds'], ['password']);
    });

    test('a weak password is rejected and the user stays a guest', () async {
      await service.loginWithAnonymous();

      await expectLater(
        service.linkWithEmailAndPassword('me@example.com', '123'),
        throwsA(isA<AnyhooAuthException>().having((e) => e.code, 'code', 'weak-password')),
      );
      expect(service.currentUser!['isAnonymous'], true);
    });

    test('linking without a user throws no-user', () async {
      await expectLater(
        service.linkWithApple(),
        throwsA(isA<AnyhooAuthException>().having((e) => e.code, 'code', 'no-user')),
      );
    });
  });
}
