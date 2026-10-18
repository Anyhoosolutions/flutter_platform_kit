import 'dart:async';

import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger('RemoteConfigCubit');

class RemoteConfigState<T extends AnyhooRemoteConfigValues<T>> {
  final T values;
  final DateTime latestUpdate;

  RemoteConfigState({required this.values, required this.latestUpdate});

  @override
  bool operator ==(Object other) {
    if (other is! RemoteConfigState<T>) {
      return false;
    }
    final current = values.toMap();
    final next = other.values.toMap();
    if (current.length != next.length) {
      return false;
    }
    for (final entry in current.entries) {
      if (next[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(values.toMap().entries);
}

class RemoteConfigCubit<T extends AnyhooRemoteConfigValues<T>>
    extends Cubit<RemoteConfigState<T>> {
  final AnyhooRemoteConfigService service;
  StreamSubscription<void>? _configUpdateSubscription;
  Future<void> _pendingUpdate = Future<void>.value();
  var _closing = false;

  RemoteConfigCubit({required this.service, required T initialValues})
    : super(
        RemoteConfigState(values: initialValues, latestUpdate: DateTime.now()),
      ) {
    _initialize();
  }

  Future<void> _initialize() async {
    _configUpdateSubscription = service.getConfigUpdatesStream().listen((_) {
      _updateValues();
    });

    await service.setupRemoteConfig();
    await _updateValues();
  }

  Future<void> _updateValues() {
    _pendingUpdate = _pendingUpdate.then((_) => _readAndEmit());
    return _pendingUpdate;
  }

  Future<void> _readAndEmit() async {
    if (isClosed || _closing) {
      return;
    }
    final allValues = await service.getAll();
    if (isClosed || _closing) {
      return;
    }
    final nextValues = state.values.withMap(allValues);
    final nextState = RemoteConfigState(
      values: nextValues,
      latestUpdate: DateTime.now(),
    );
    if (nextState == state) {
      return;
    }
    _log.info('Emitting updated values: ${nextValues.toMap()}');
    emit(nextState);
  }

  @override
  Future<void> close() async {
    _closing = true;
    await _configUpdateSubscription?.cancel();
    _configUpdateSubscription = null;
    await service.dispose();
    return super.close();
  }
}
