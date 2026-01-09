# anyhoo_logging

A package for handling logging. It depends on the `logging` package but has some helper methods.
It has a `LoggingConfiguration` class to set what loggers should log at what level.
It will also support reading log levels from Remote config and/or from Firebase.

## Sentry Integration

This package supports optional Sentry error reporting integration. See [SENTRY_SETUP.md](SENTRY_SETUP.md) for detailed setup instructions.

Key features:
- **Optional**: Apps can choose whether to use Sentry or not
- **No forced dependencies**: Packages don't need Sentry as a dependency
- **Automatic log forwarding**: Logs are automatically forwarded to Sentry based on their level
- **Easy to use**: Simple `SentryHelper` class for packages to report errors

Packages can use `SentryHelper` to report errors/logs, and it will automatically be a no-op if Sentry is not configured.
