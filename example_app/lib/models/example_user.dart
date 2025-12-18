import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_user.freezed.dart';
part 'example_user.g.dart';

/// Example user model for the demo app.
///
/// This demonstrates how apps can extend AuthUser with their own fields.
@freezed
abstract class ExampleUser with _$ExampleUser implements AnyhooUser {
  const factory ExampleUser({
    required String id,
    required String email,
    required String name,
    String? photoUrl,
    int? phoneNumber,
  }) = _ExampleUser;

  factory ExampleUser.fromJson(Map<String, dynamic> json) => _$ExampleUserFromJson(json);

  const ExampleUser._();
}
