import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('LoggingCubit', () {
    late LoggingCubit cubit;

    setUp(() {
      cubit = LoggingCubit(maxLogs: 3);
    });

    test('initial state is 0', () {
      expect(cubit.state, equals([]));
    });

    blocTest(
      'emits [hello] when log is called with message "hello"',
      build: () => cubit,
      act: (bloc) {
        final record = LogRecord(Level.INFO, 'hello', 'test');
        bloc.log(record);
      },
      verify: (bloc) {
        expect(bloc.state.length, equals(1));
        final record = bloc.state[0];
        expect(record.level, equals(Level.INFO));
        expect(record.loggerName, equals('test'));
        expect(record.message, equals('hello'));
      },
    );

    blocTest(
      'emits [hello] when log is called with message "hello"',
      build: () => cubit,
      act: (bloc) {
        bloc.log(LogRecord(Level.INFO, 'one', 'test'));
        bloc.log(LogRecord(Level.INFO, 'two', 'test'));
        bloc.log(LogRecord(Level.INFO, 'three', 'test'));
        bloc.log(LogRecord(Level.INFO, 'four', 'test'));
      },
      verify: (bloc) {
        expect(bloc.state.length, equals(3));
        var record = bloc.state[0];
        expect(record.message, equals('two'));

        record = bloc.state[1];
        expect(record.message, equals('three'));

        record = bloc.state[2];
        expect(record.message, equals('four'));
      },
    );
  });
}
