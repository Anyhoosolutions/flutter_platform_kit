/// Abstract interface for Sentry error reporting service.
///
/// This allows packages to report errors to Sentry without directly depending
/// on the Sentry package. Apps can optionally implement this interface and
/// register it with LoggingConfiguration.
abstract class SentryService {
  /// Reports an error to Sentry.
  ///
  /// [error] - The error object to report
  /// [stackTrace] - Optional stack trace
  /// [hint] - Optional hint/context about the error
  /// [fatal] - Whether this is a fatal error (defaults to false)
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? extraInfo,
    bool fatal = false,
  });

  /// Reports a message to Sentry.
  ///
  /// [message] - The message to report
  /// [level] - The severity level (defaults to 'error')
  /// [hint] - Optional hint/context
  Future<void> captureMessage(String message, {String level = 'error', Map<String, dynamic>? extraInfo});

  /// Adds breadcrumb to Sentry.
  ///
  /// [message] - The breadcrumb message
  /// [category] - Optional category
  /// [level] - Optional severity level
  void addBreadcrumb({required String message, String? category, String level = 'info'});

  /// Sets a user context for Sentry.
  ///
  /// [id] - User ID
  /// [email] - Optional email
  /// [username] - Optional username
  /// [data] - Optional additional user data
  void setUser({String? id, String? email, String? username, Map<String, dynamic>? data});

  /// Clears the user context.
  void clearUser();

  /// Sets a tag for Sentry.
  ///
  /// [key] - Tag key
  /// [value] - Tag value
  void setTag(String key, String value);

  /// Sets context data for Sentry.
  ///
  /// [key] - Context key
  /// [value] - Context value (can be a Map, String, or other dynamic value)
  void setContexts(String key, dynamic value);
}
