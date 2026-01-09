import 'package:anyhoo_logging/src/logging_cubit.dart';
import 'package:anyhoo_logging/src/sentry_helper.dart';
import 'package:anyhoo_logging/src/sentry_service.dart';
import 'package:logging/logging.dart';

class LoggingConfiguration {
  final Level logLevel;
  final Map<String, Level> loggers = {};
  final LoggingCubit? loggingCubit;
  final SentryService? sentryService;
  final Level? sentryLogLevelFilter;

  LoggingConfiguration({
    required this.logLevel,
    required List<String> loggersAtInfo,
    required List<String> loggersAtWarning,
    required List<String> loggersAtSevere,
    this.loggingCubit,
    this.sentryService,
    this.sentryLogLevelFilter,
  }) {
    for (final logger in loggersAtInfo) {
      loggers[logger] = Level.INFO;
    }
    for (final logger in loggersAtWarning) {
      loggers[logger] = Level.WARNING;
    }
    for (final logger in loggersAtSevere) {
      loggers[logger] = Level.SEVERE;
    }

    // Set the global Sentry service if provided
    if (sentryService != null) {
      setSentryService(sentryService);
    }

    _setupLogging();
  }

  void _setupLogging() {
    hierarchicalLoggingEnabled = true;

    Logger.root.level = logLevel;

    Logger.root.onRecord.listen((record) {
      final str = '${record.loggerName}: ${record.level.name}: ${record.time}: ${record.message}';
      // ignore: avoid_print
      print('LOG: $str');

      // if (profile?.trackLogs ?? false) {
      if (loggingCubit != null) {
        loggingCubit!.log(record);
      }

      // Forward to Sentry if available and meets level filter
      if (sentryService != null) {
        // If filter is set, only forward logs at or above the filter level
        if (sentryLogLevelFilter == null || record.level >= sentryLogLevelFilter!) {
          SentryHelper.captureLogRecord(record);
        }
      }
    });

    _updateLoggers();
  }

  void _updateLoggers() {
    for (final logger in loggers.keys) {
      Logger(logger).level = loggers[logger] ?? Level.OFF;
    }
  }

  void addInfoLogger(String loggerName) {
    addLogger(loggerName, Level.INFO);
  }

  void addWarningLogger(String loggerName) {
    addLogger(loggerName, Level.WARNING);
  }

  void addSevereLogger(String loggerName) {
    addLogger(loggerName, Level.SEVERE);
  }

  void addLogger(String loggerName, Level level) {
    loggers[loggerName] = level;
    _updateLoggers();
  }

  void removeLogger(String loggerName) {
    loggers.remove(loggerName);
    _updateLoggers();
  }

  void removeInfoLogger(String loggerName) {
    removeLogger(loggerName);
  }

  void removeWarningLogger(String loggerName) {
    removeLogger(loggerName);
  }

  void removeSevereLogger(String loggerName) {
    removeLogger(loggerName);
  }
}
