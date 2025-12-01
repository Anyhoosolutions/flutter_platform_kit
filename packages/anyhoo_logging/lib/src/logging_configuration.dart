import 'package:logging/logging.dart';

class LoggingConfiguration {
  final String logLevel;
  final List<String> loggersAtInfo;
  final List<String> loggersAtWarning;
  final List<String> loggersAtSevere;

  LoggingConfiguration({
    required this.logLevel,
    required this.loggersAtInfo,
    required this.loggersAtWarning,
    required this.loggersAtSevere,
  }) {
    _setupLogging();
  }

  void _setupLogging() {
    final level = switch (logLevel) {
      'ALL' => Level.ALL,
      'FINEST' => Level.FINEST,
      'FINER' => Level.FINER,
      'FINE' => Level.FINE,
      'CONFIG' => Level.CONFIG,
      'INFO' => Level.INFO,
      'WARNING' => Level.WARNING,
      'SEVERE' => Level.SEVERE,
      'SHOUT' => Level.SHOUT,
      'OFF' => Level.OFF,
      _ => throw Exception('Invalid log level: $logLevel'),
    };

    Logger.root.level = level;

    for (final logger in loggersAtSevere) {
      Logger(logger).level = Level.SEVERE;
    }

    for (final logger in loggersAtWarning) {
      Logger(logger).level = Level.WARNING;
    }

    for (final logger in loggersAtInfo) {
      Logger(logger).level = Level.INFO;
    }
  }
}
