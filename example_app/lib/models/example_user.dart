import 'package:anyhoo_core/anyhoo_core.dart';

/// Example user model for the demo app.
///
/// This demonstrates how apps can extend AuthUser with their own fields.
class ExampleUser extends AnyhooUser {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final int? phoneNumber;
  ExampleUser({required this.id, required this.email, required this.name, this.photoUrl, this.phoneNumber});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'photoUrl': photoUrl, 'phoneNumber': phoneNumber};
  }

  factory ExampleUser.fromJson(Map<String, dynamic> json) {
    return ExampleUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as int?,
    );
  }

  @override
  ExampleUser copyWith({String? id, String? email, String? name, String? photoUrl, int? phoneNumber}) {
    return ExampleUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() =>
      'ExampleUser(id: $id, email: $email, name: $name, photoUrl: $photoUrl, phoneNumber: $phoneNumber)';

  @override
  String getEmail() => email;

  @override
  String getId() => id;
}
