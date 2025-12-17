import 'dart:async';

import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger('RemoteConfigCubit');

class RemoteConfigState<T extends AnyhooRemoteConfigValues> {
  final T values;
  final DateTime latestUpdate;

  RemoteConfigState({required this.values, required this.latestUpdate});
}

class RemoteConfigCubit<T extends AnyhooRemoteConfigValues> extends Cubit<RemoteConfigState<T>> {
  final AnyhooRemoteConfigService _service;
  final T initialValues;
  StreamSubscription<void>? _configUpdateSubscription;

  RemoteConfigCubit({required AnyhooRemoteConfigService service, required this.initialValues})
    : _service = service,
      super(RemoteConfigState(values: initialValues, latestUpdate: DateTime.now())) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Set up listener for config updates
    _configUpdateSubscription = _service.getConfigUpdatesStream().listen((_) {
      _updateValues();
    });

    // Set up remote config
    await _service.setupRemoteConfig();

    // Load initial values
    await _updateValues();
  }

  Future<void> _updateValues() async {
    final allValues = await _service.getAll();
    state.values.fromMap(allValues);
    _log.info('Emitting updated values: ${state.values}');
    emit(RemoteConfigState(values: state.values, latestUpdate: DateTime.now()));
  }

  @override
  Future<void> close() {
    _configUpdateSubscription?.cancel();
    return super.close();
  }
}
