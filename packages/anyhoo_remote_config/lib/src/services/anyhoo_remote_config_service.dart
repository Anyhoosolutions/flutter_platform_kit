abstract class AnyhooRemoteConfigService {
  Future<void> setupRemoteConfig();
  Future<void> getAll();
  Stream<void> getConfigUpdatesStream();
}
