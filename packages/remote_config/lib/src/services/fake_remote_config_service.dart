import 'package:remote_config/src/interface/remote_config_values.dart';
import 'package:remote_config/src/services/remote_config_service.dart';

class FakeRemoteConfigService implements RemoteConfigService {
  FakeRemoteConfigService();

  @override
  Future<void> setupRemoteConfig() async {}

  @override
  Future<void> getAll() async {}

  @override
  Stream<void> getConfigUpdatesStream() {
    return Stream.value(null);
  }
}

class FakeRemoteConfigValues implements RemoteConfigValues {
  FakeRemoteConfigValues();
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
