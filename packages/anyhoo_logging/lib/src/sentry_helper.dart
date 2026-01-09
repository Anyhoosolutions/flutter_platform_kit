import 'package:anyhoo_logging/src/sentry_service.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Global Sentry service instance.
/// This is set when Sentry is initialized in the app.
SentryService? _sentryService;

/// Sets the global Sentry service instance.
/// This should be called by the app when initializing Sentry.
void setSentryService(SentryService? service) {
  _sentryService = service;
}

/// Gets the current Sentry service instance, if available.
SentryService? getSentryService() {
  return _sentryService;
}

/// Checks if Sentry is available and configured.
bool get isSentryAvailable => _sentryService != null;

/// Helper class for packages to easily report errors and logs to Sentry.
class SentryHelper {
  /// Reports an error to Sentry if available.
  ///
  /// This is a no-op if Sentry is not configured.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   // some code
  /// } catch (e, stackTrace) {
  ///   SentryHelper.captureException(e, stackTrace: stackTrace);
  /// }
  /// ```
  static Future<void> captureException(Object error, {StackTrace? stackTrace, Hint? hint, bool fatal = false}) async {
    if (_sentryService != null) {
      await _sentryService!.captureException(error, stackTrace: stackTrace, hint: hint, fatal: fatal);
    }
  }

  /// Reports a message to Sentry if available.
  ///
  /// This is a no-op if Sentry is not configured.
  static Future<void> captureMessage(String message, {String level = 'error', Hint? hint}) async {
    if (_sentryService != null) {
      await _sentryService!.captureMessage(message, level: level, hint: hint);
    }
  }

  /// Adds a breadcrumb to Sentry if available.
  ///
  /// This is a no-op if Sentry is not configured.
  static void addBreadcrumb({required String message, String? category, String level = 'info'}) {
    _sentryService?.addBreadcrumb(message: message, category: category, level: level);
  }

  /// Sets user context in Sentry if available.
  ///
  /// This is a no-op if Sentry is not configured.
  static void setUser({String? id, String? email, String? username, Map<String, dynamic>? data}) {
    _sentryService?.setUser(id: id, email: email, username: username, data: data);
  }

  /// Clears user context in Sentry if available.
  ///
  /// This is a no-op if Sentry is not configured.
  static void clearUser() {
    _sentryService?.clearUser();
  }

  /// Sets a tag in Sentry if available.
  ///
  /// This is a no-op if Sentry is not configured.
  static void setTag(String key, String value) {
    _sentryService?.setTag(key, value);
  }

  /// Sets context data in Sentry if available.
  ///
  /// This is a no-op if Sentry is not configured.
  static void setContexts(String key, dynamic value) {
    _sentryService?.setContexts(key, value);
  }

  /// Converts a LogRecord level to a Sentry level string.
  static String _logLevelToSentryLevel(Level level) {
    if (level >= Level.SEVERE) {
      return 'error';
    } else if (level >= Level.WARNING) {
      return 'warning';
    } else if (level >= Level.INFO) {
      return 'info';
    } else {
      return 'debug';
    }
  }

  /// Reports a LogRecord to Sentry if available.
  ///
  /// This is used internally by LoggingConfiguration to forward logs to Sentry.
  static Future<void> captureLogRecord(LogRecord record) async {
    if (_sentryService == null) return;

    final level = _logLevelToSentryLevel(record.level);

    // For severe errors, capture as exception
    if (record.level >= Level.SEVERE && record.error != null) {
      final hint = Hint()
        ..set('message', record.message)
        ..set('logger', record.loggerName)
        ..set('time', record.time.toIso8601String());
      await _sentryService!.captureException(record.error!, stackTrace: record.stackTrace, hint: hint, fatal: false);
    } else {
      // For other levels, capture as message or breadcrumb
      if (record.level >= Level.WARNING) {
        final hint = Hint()
          ..set('logger', record.loggerName)
          ..set('time', record.time.toIso8601String());
        if (record.error != null) {
          hint.set('error', record.error.toString());
        }
        await _sentryService!.captureMessage(record.message, level: level, hint: hint);
      } else {
        // For info/debug, add as breadcrumb
        _sentryService!.addBreadcrumb(message: record.message, category: record.loggerName, level: level);
      }
    }
  }
}
