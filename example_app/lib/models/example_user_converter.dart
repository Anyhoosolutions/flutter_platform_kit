import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'example_user.dart';

/// Converter for ExampleUser.
///
/// This demonstrates how apps implement UserConverter for their custom user type.
class ExampleUserConverter implements UserConverter<ExampleUser> {
  @override
  ExampleUser fromJson(Map<String, dynamic> json) {
    final values = {'name': json['name'] ?? 'No name at all', 'avatarUrl': json['photoURL'], ...json};

    return ExampleUser.fromJson(values);
  }

  @override
  Map<String, dynamic> toJson(ExampleUser user) {
    return user.toJson();
  }
}
