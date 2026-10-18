abstract class AnyhooRemoteConfigService {
  /// Apply defaults and the last activated template, then fetch in the background.
  Future<void> setupRemoteConfig();

  Future<Map<String, String>> getAll();

  /// Fires when a fetch or realtime update has been activated.
  Stream<void> getConfigUpdatesStream();

  Future<void> dispose();
}
