# Example: Using Sentry in Packages

This document shows examples of how packages can use Sentry error reporting.

## Basic Error Reporting

```dart
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:logging/logging.dart';

final _log = Logger('MyPackage');

void performAction() {
  try {
    // Your code that might throw
    riskyOperation();
  } catch (e, stackTrace) {
    // Log to standard logger
    _log.severe('Error in performAction', e, stackTrace);
    
    // Also report to Sentry (no-op if Sentry not configured)
    SentryHelper.captureException(
      e,
      stackTrace: stackTrace,
      fatal: false,
    );
    
    // Re-throw or handle as needed
    rethrow;
  }
}
```

## Reporting Messages

```dart
void reportWarning(String message) {
  _log.warning(message);
  
  // Report to Sentry as warning
  SentryHelper.captureMessage(
    message,
    level: 'warning',
  );
}

void reportError(String message) {
  _log.severe(message);
  
  // Report to Sentry as error
  SentryHelper.captureMessage(
    message,
    level: 'error',
  );
}
```

## Adding Breadcrumbs

Breadcrumbs help track user actions leading up to an error:

```dart
void userPerformedAction(String action) {
  // Add breadcrumb to track user actions
  SentryHelper.addBreadcrumb(
    message: 'User performed: $action',
    category: 'user_action',
    level: 'info',
  );
  
  // Your code here
  processAction(action);
}
```

## Setting User Context

When a user logs in, you can set their context in Sentry:

```dart
void onUserLogin(String userId, String email) {
  SentryHelper.setUser(
    id: userId,
    email: email,
    username: email.split('@').first,
  );
}

void onUserLogout() {
  SentryHelper.clearUser();
}
```

## Conditional Sentry Usage

You can check if Sentry is available before using it:

```dart
void reportError(Object error, StackTrace stackTrace) {
  _log.severe('Error occurred', error, stackTrace);
  
  if (isSentryAvailable) {
    // Sentry is configured, report the error
    SentryHelper.captureException(error, stackTrace: stackTrace);
  } else {
    // Sentry not available, maybe use alternative error reporting
    // or just rely on logging
  }
}
```

## Real-World Example

Here's how you might integrate Sentry into an authentication service:

```dart
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:logging/logging.dart';

final _log = Logger('AuthService');

class AuthService {
  Future<User> loginWithEmail(String email, String password) async {
    try {
      SentryHelper.addBreadcrumb(
        message: 'Attempting email login',
        category: 'auth',
        level: 'info',
      );
      
      final user = await _performLogin(email, password);
      
      // Set user context in Sentry
      SentryHelper.setUser(
        id: user.id,
        email: user.email,
      );
      
      _log.info('Login successful for user: ${user.id}');
      return user;
    } catch (e, stackTrace) {
      _log.severe('Login failed', e, stackTrace);
      
      SentryHelper.captureException(
        e,
        stackTrace: stackTrace,
        hint: {
          'email': email,
          'method': 'email',
        },
        fatal: false,
      );
      
      rethrow;
    }
  }
  
  void logout() {
    SentryHelper.addBreadcrumb(
      message: 'User logged out',
      category: 'auth',
      level: 'info',
    );
    
    SentryHelper.clearUser();
    _log.info('User logged out');
  }
}
```

## Automatic Log Forwarding

When you use the standard `Logger` class, logs are automatically forwarded to Sentry based on their level:

- **SEVERE** logs with errors → Captured as exceptions
- **WARNING** logs → Captured as warning messages  
- **INFO/DEBUG** logs → Added as breadcrumbs

This happens automatically when `LoggingConfiguration` is initialized with a `sentryService`. No additional code needed!

**Note:** You can control which log levels are forwarded using the `sentryLogLevelFilter` parameter in `LoggingConfiguration`. For example, setting it to `Level.WARNING` will only forward WARNING and SEVERE logs, skipping INFO and DEBUG.

```dart
final _log = Logger('MyPackage');

// This will automatically be forwarded to Sentry if configured
// (and if it meets the sentryLogLevelFilter threshold)
_log.severe('Something went wrong', error, stackTrace);
_log.warning('This is a warning');
_log.info('User action performed'); // May be filtered out depending on sentryLogLevelFilter
```
