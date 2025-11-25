import 'package:anyhoo_core/anyhoo_core.dart';

/// Example user model for the demo app.
///
/// This demonstrates how apps can extend AuthUser with their own fields.
class ExampleUser extends AnyhooUser {
  @override
  final String id;
  @override
  final String email;
  final String name;
  final String? avatarUrl;

  ExampleUser({required this.id, required this.email, required this.name, this.avatarUrl});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'avatarUrl': avatarUrl};
  }

  factory ExampleUser.fromJson(Map<String, dynamic> json) {
    return ExampleUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  @override
  String toString() => 'ExampleUser(id: $id, email: $email, name: $name)';
}
