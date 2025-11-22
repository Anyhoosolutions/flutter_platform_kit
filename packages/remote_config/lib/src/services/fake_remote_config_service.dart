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

  @override
  RemoteConfigValues getRemoteConfigValues() {
    return FakeRemoteConfigValues();
  }

  @override
  Map<String, String> getLogConfigValues() {
    return {};
  }
}

class FakeRemoteConfigValues implements RemoteConfigValues {
  FakeRemoteConfigValues();
}
