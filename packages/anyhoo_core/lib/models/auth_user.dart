/// Base interface for authenticated users.
///
/// Apps should extend this interface to create their own user models
/// with app-specific fields and settings.
abstract class AuthUser {
  /// Unique identifier for the user.
  String get id;

  /// User's email address.
  String get email;

  /// Convert user to JSON for storage/serialization.
  Map<String, dynamic> toJson();
}
