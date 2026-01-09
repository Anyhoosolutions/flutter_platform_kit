// Utility functions for JSON parsing and error handling.

/// Safely calls a fromJson function with enhanced error messages
/// when type cast errors occur due to null values or missing fields.
///
/// This function wraps any fromJson call and provides detailed error information
/// when a type cast error occurs, making it easier to identify which field
/// is causing the problem.
///
/// Example:
/// ```dart
/// final user = safeFromJson<User>(
///   (json) => User.fromJson(json),
///   userData,
/// );
/// ```
///
/// [fromJson] - A function that takes a Map and returns an instance of type T
/// [json] - The JSON data to parse
/// Returns an instance of type T
/// Throws [FormatException] with detailed error information if parsing fails
T safeFromJson<T>(T Function(Map<String, dynamic>) fromJson, Map<String, dynamic> json) {
  try {
    return fromJson(json);
  } catch (e) {
    // If it's a type cast error, provide more context about null/missing fields
    if (e.toString().contains("type 'Null' is not a subtype") || e.toString().contains("is not a subtype")) {
      final nullFields = <String>[];
      json.forEach((key, value) {
        if (value == null) {
          nullFields.add(key);
        }
      });

      final errorMessage =
          'Failed to parse ${T.toString()} from JSON. '
          'Type cast error likely due to null required fields or type mismatch. '
          'Null fields found: ${nullFields.isEmpty ? "none (check for missing keys)" : nullFields.join(", ")}. '
          'Available keys: ${json.keys.join(", ")}. '
          'Full JSON: $json. '
          'Original error: $e';

      throw FormatException(errorMessage, e);
    }
    rethrow;
  }
}
