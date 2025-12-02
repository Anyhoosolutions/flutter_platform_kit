import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class LoggingCubit extends Cubit<List<LogRecord>> {
  final int maxLogs;

  LoggingCubit({this.maxLogs = 100}) : super([]);

  void log(LogRecord record) {
    if (state.length >= maxLogs) {
      state.removeAt(0);
    }
    emit([...state, record]);
  }

  void clear() {
    emit([]);
  }
}
