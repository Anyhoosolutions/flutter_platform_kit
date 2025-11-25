import 'package:anyhoo_core/anyhoo_core.dart';

/// Interface for converting between JSON and user objects.
///
/// Apps must implement this to convert API responses to their custom user type.
abstract class AnyhooUserConverter<T extends AnyhooUser> {
  /// Convert JSON data to a user object.
  T fromJson(Map<String, dynamic> json);

  /// Convert a user object to JSON.
  Map<String, dynamic> toJson(T user);
}
