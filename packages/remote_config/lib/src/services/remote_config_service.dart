abstract class RemoteConfigService {
  Future<void> setupRemoteConfig();
  Future<void> getAll();
  Stream<void> getConfigUpdatesStream();
}
