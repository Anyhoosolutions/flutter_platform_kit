import 'package:logging/logging.dart';

class LoggingConfiguration {
  static void setupLogging({
    Level logLevel = Level.WARNING,
    required List<String> loggersAtInfo,
    required List<String> loggersAtWarning,
    required List<String> loggersAtSevere,
  }) {
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
