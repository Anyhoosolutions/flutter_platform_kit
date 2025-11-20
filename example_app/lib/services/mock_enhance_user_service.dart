import 'package:anyhoo_auth/anyhoo_auth.dart';

/// Creates a mock EnhanceUserService for demonstration purposes.
///
/// In a real app, this would make actual API calls.
EnhanceUserService createMockEnhanceUserService() {
  return EnhanceUserService(
    enhanceUserFunction: (user) async {
      return {...user, 'extra': 'here is more', 'avatarUrl': 'enhanced avatar url'};
    },
  );
}
