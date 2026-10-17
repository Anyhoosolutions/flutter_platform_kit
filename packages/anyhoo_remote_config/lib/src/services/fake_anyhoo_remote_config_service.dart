import 'dart:async';

import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';

class FakeAnyhooRemoteConfigService implements AnyhooRemoteConfigService {
  FakeAnyhooRemoteConfigService({Map<String, String>? values})
    : _values = {...?values};

  final Map<String, String> _values;
  final _configUpdateController = StreamController<void>.broadcast();

  /// Replace the current values and notify listeners.
  void update(Map<String, String> values) {
    _values
      ..clear()
      ..addAll(values);
    if (!_configUpdateController.isClosed) {
      _configUpdateController.add(null);
    }
  }

  @override
  Future<void> setupRemoteConfig() async {}

  @override
  Future<Map<String, String>> getAll() async =>
      Map<String, String>.from(_values);

  @override
  Stream<void> getConfigUpdatesStream() => _configUpdateController.stream;

  @override
  Future<void> dispose() async {
    await _configUpdateController.close();
  }
}

class FakeAnyhooRemoteConfigValues
    implements AnyhooRemoteConfigValues<FakeAnyhooRemoteConfigValues> {
  FakeAnyhooRemoteConfigValues([Map<String, String>? values])
    : values = {...?values};

  final Map<String, String> values;

  @override
  FakeAnyhooRemoteConfigValues withMap(Map<String, dynamic> map) {
    return FakeAnyhooRemoteConfigValues(
      map.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  @override
  Map<String, dynamic> toMap() => values;
}
