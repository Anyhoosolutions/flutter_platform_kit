import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

class SimpleBlocObserver extends BlocObserver {
  final _log = Logger('SimpleBlocObserver');

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _log.info('${bloc.runtimeType} $change');
  }
}
