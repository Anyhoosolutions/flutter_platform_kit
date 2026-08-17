/// Base interface for authenticated users.
///
/// Apps should extend this interface to create their own user models
/// with app-specific fields and settings.
abstract interface class AnyhooUser {
  /// Convert user to JSON for storage/serialization.
  Map<String, dynamic> toJson();
}
