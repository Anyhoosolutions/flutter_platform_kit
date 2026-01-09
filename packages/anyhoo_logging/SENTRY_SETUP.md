# Sentry Integration Setup

This guide explains how to set up optional Sentry error reporting in your Flutter app using the `anyhoo_logging` package.

## Overview

The `anyhoo_logging` package supports optional Sentry integration. This allows:
- Apps to optionally enable Sentry without forcing it as a dependency
- Packages to report errors/logs to Sentry if it's available
- Clean separation of concerns - Sentry setup stays in the app, not in packages

## Setup Steps

### 1. Add Sentry Dependencies

Add `sentry_flutter` to your app's `pubspec.yaml`:

```yaml
dependencies:
  sentry_flutter: ^8.0.0
```

### 2. Create a Sentry Service Implementation

Create a file in your app (e.g., `lib/services/sentry_service_impl.dart`):

```dart
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppSentryService implements SentryService {
  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    Hint? hint,
    bool fatal = false,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: hint,
      withScope: (scope) {
        scope.level = fatal ? SentryLevel.fatal : SentryLevel.error;
      },
    );
  }

  @override
  Future<void> captureMessage(
    String message, {
    String level = 'error',
    Hint? hint,
  }) async {
    await Sentry.captureMessage(
      message,
      level: _stringToSentryLevel(level),
      hint: hint,
    );
  }

  @override
  void addBreadcrumb({
    required String message,
    String? category,
    String level = 'info',
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: _stringToSentryLevel(level),
      ),
    );
  }

  @override
  void setUser({
    String? id,
    String? email,
    String? username,
    Map<String, dynamic>? data,
  }) {
    Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(
          id: id,
          email: email,
          username: username,
          data: data,
        ),
      );
    });
  }

  @override
  void clearUser() {
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  @override
  void setTag(String key, String value) {
    Sentry.configureScope((scope) {
      scope.setTag(key, value);
    });
  }

  @override
  void setExtra(String key, dynamic value) {
    Sentry.configureScope((scope) {
      scope.setExtra(key, value);
    });
  }

  SentryLevel _stringToSentryLevel(String level) {
    switch (level.toLowerCase()) {
      case 'fatal':
        return SentryLevel.fatal;
      case 'error':
        return SentryLevel.error;
      case 'warning':
        return SentryLevel.warning;
      case 'info':
        return SentryLevel.info;
      case 'debug':
        return SentryLevel.debug;
      default:
        return SentryLevel.info;
    }
  }
}
```

### 3. Initialize Sentry in Your App

Update your `main.dart` to initialize Sentry and pass it to `LoggingConfiguration`:

```dart
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:logging/logging.dart';
import 'services/sentry_service_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Sentry (optional - wrap in a flag if you want to disable it)
  final enableSentry = !kDebugMode; // Only enable in release mode, for example
  
  if (enableSentry) {
    await SentryFlutter.init(
      (options) {
        options.dsn = 'YOUR_SENTRY_DSN_HERE';
        // Configure other Sentry options as needed
        options.tracesSampleRate = 1.0;
        options.environment = kDebugMode ? 'development' : 'production';
      },
      appRunner: () => _runApp(),
    );
  } else {
    _runApp();
  }
}

void _runApp() {
  final loggingCubit = LoggingCubit(maxLogs: 10);
  
  // Create Sentry service if enabled
  final sentryService = enableSentry ? AppSentryService() : null;
  
  final loggingConfiguration = LoggingConfiguration(
    logLevel: kDebugMode ? Level.ALL : Level.WARNING,
    loggersAtInfo: [],
    loggersAtWarning: [],
    loggersAtSevere: [],
    loggingCubit: loggingCubit,
    sentryService: sentryService, // Pass Sentry service here
    sentryLogLevelFilter: Level.WARNING, // Optional: Only forward WARNING and above to Sentry
  );

  runApp(MyApp(loggingConfiguration: loggingConfiguration));
}
```

### 4. Using Sentry in Packages

Packages can now report errors to Sentry using the `SentryHelper` class:

```dart
import 'package:anyhoo_logging/anyhoo_logging.dart';

final _log = Logger('MyPackage');

void someFunction() {
  try {
    // Your code here
  } catch (e, stackTrace) {
    // Log to standard logger
    _log.severe('Error in someFunction', e, stackTrace);
    
    // Also report to Sentry if available (no-op if Sentry not configured)
    SentryHelper.captureException(
      e,
      stackTrace: stackTrace,
      fatal: false,
    );
  }
}

// Or report messages
void reportWarning(String message) {
  _log.warning(message);
  SentryHelper.captureMessage(message, level: 'warning');
}

// Or add breadcrumbs
void trackUserAction(String action) {
  SentryHelper.addBreadcrumb(
    message: 'User performed: $action',
    category: 'user_action',
    level: 'info',
  );
}
```

## Checking if Sentry is Available

Packages can check if Sentry is configured before using it:

```dart
import 'package:anyhoo_logging/anyhoo_logging.dart';

if (isSentryAvailable) {
  // Sentry is configured, safe to use
  SentryHelper.captureMessage('Something happened');
} else {
  // Sentry not configured, skip or use alternative
}
```

## Benefits

1. **Optional**: Apps can choose whether to use Sentry or not
2. **No Forced Dependencies**: Packages don't need Sentry as a dependency
3. **Centralized**: Sentry setup happens in one place (the app)
4. **Automatic Log Forwarding**: Logs are automatically forwarded to Sentry based on their level
5. **Easy to Use**: Simple helper class for packages to report errors

## Filtering Log Levels Sent to Sentry

You can control which log levels are forwarded to Sentry using the `sentryLogLevelFilter` parameter:

```dart
final loggingConfiguration = LoggingConfiguration(
  // ... other parameters
  sentryService: sentryService,
  sentryLogLevelFilter: Level.WARNING, // Only forward WARNING and above
);
```

- If `sentryLogLevelFilter` is `null` (default), all logs are forwarded to Sentry
- If set to `Level.WARNING`, only WARNING and SEVERE logs are forwarded
- If set to `Level.SEVERE`, only SEVERE logs are forwarded
- This only affects automatic log forwarding from `Logger` instances
- Direct calls to `SentryHelper.captureException()` and `SentryHelper.captureMessage()` are not filtered

**Example:**
```dart
// Only send errors and warnings to Sentry, skip info/debug logs
sentryLogLevelFilter: Level.WARNING,

// Only send severe errors to Sentry
sentryLogLevelFilter: Level.SEVERE,

// Send all logs to Sentry (default)
sentryLogLevelFilter: null,
```

## Notes

- If Sentry is not configured, all `SentryHelper` methods are no-ops (they do nothing)
- Logs at `SEVERE` level with errors are automatically captured as exceptions
- Logs at `WARNING` level and above are captured as messages
- Logs at `INFO` and `DEBUG` levels are added as breadcrumbs
- The `sentryLogLevelFilter` parameter controls which logs are automatically forwarded
- Direct calls to `SentryHelper` methods bypass the filter and always send to Sentry (if configured)
