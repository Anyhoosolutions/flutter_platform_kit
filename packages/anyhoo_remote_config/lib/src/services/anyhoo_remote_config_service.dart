abstract class AnyhooRemoteConfigService {
  Future<void> setupRemoteConfig();
  Future<Map<String, String>> getAll();
  Stream<void> getConfigUpdatesStream();
}
