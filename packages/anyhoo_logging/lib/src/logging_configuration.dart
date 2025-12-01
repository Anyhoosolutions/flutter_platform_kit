import 'package:logging/logging.dart';
import 'package:logging/logging.dart' as logging;

class LoggingConfiguration {
  static void setupLogging({
    required String logLevel,
    required List<String> loggersAtInfo,
    required List<String> loggersAtWarning,
    required List<String> loggersAtSevere,
  }) {
    logging.hierarchicalLoggingEnabled = true;

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
