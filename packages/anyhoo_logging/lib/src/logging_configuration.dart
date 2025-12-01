import 'package:logging/logging.dart';

class LoggingConfiguration {
  final Level logLevel;
  final Map<String, Level> loggers = {};

  LoggingConfiguration({
    required this.logLevel,
    required List<String> loggersAtInfo,
    required List<String> loggersAtWarning,
    required List<String> loggersAtSevere,
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
      //   loggingBloc.add(LoggingEvent.addLog(str));
      // }
    });

    _updateLoggers();
  }

  void _updateLoggers() {
    for (final logger in loggers.keys) {
      Logger(logger).level = loggers[logger] ?? Level.OFF;
    }
  }

  void addInfoLogger(String loggerName) {
    loggers[loggerName] = Level.INFO;
    _updateLoggers();
  }

  void addWarningLogger(String loggerName) {
    loggers[loggerName] = Level.WARNING;
    _updateLoggers();
  }

  void addSevereLogger(String loggerName) {
    loggers[loggerName] = Level.SEVERE;
    _updateLoggers();
  }

  void removeInfoLogger(String loggerName) {
    loggers.remove(loggerName);
    _updateLoggers();
  }

  void removeWarningLogger(String loggerName) {
    loggers.remove(loggerName);
    _updateLoggers();
  }

  void removeSevereLogger(String loggerName) {
    loggers.remove(loggerName);
    _updateLoggers();
  }
}
