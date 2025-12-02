import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';

class FakeAnyhooRemoteConfigService implements AnyhooRemoteConfigService {
  FakeAnyhooRemoteConfigService();

  @override
  Future<void> setupRemoteConfig() async {}

  @override
  Future<void> getAll() async {}

  @override
  Stream<void> getConfigUpdatesStream() {
    return Stream.value(null);
  }
}

class FakeAnyhooRemoteConfigValues implements AnyhooRemoteConfigValues {
  FakeAnyhooRemoteConfigValues();
  final Map<String, String> values = {};

  @override
  void fromMap(Map<String, dynamic> map) {
    values.clear();
    values.addAll(map.cast<String, String>());
  }

  @override
  Map<String, dynamic> toMap() {
    return values.cast<String, dynamic>();
  }
}
