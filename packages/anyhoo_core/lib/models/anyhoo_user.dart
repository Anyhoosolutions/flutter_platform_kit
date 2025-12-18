/// Base interface for authenticated users.
///
/// Apps should extend this interface to create their own user models
/// with app-specific fields and settings.
abstract class AnyhooUser {
  /// Unique identifier for the user.
  String getId();

  /// User's email address.
  String getEmail();

  /// Convert user to JSON for storage/serialization.
  Map<String, dynamic> toJson();

  AnyhooUser get copyWith;
}
