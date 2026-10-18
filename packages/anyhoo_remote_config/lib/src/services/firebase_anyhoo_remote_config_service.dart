import 'dart:async';

import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logging/logging.dart';

class FirebaseAnyhooRemoteConfigService implements AnyhooRemoteConfigService {
  final _log = Logger('FirebaseRemoteConfigService');

  final Duration minimumFetchInterval;
  final Duration fetchTimeout;
  final FirebaseRemoteConfig _remoteConfig;
  final Map<String, dynamic> _defaults = {};
  final _configUpdateController = StreamController<void>.broadcast();
  StreamSubscription<RemoteConfigUpdate>? _updatedSubscription;

  FirebaseAnyhooRemoteConfigService({
    required Map<String, dynamic> defaults,
    this.minimumFetchInterval = const Duration(hours: 1),
    this.fetchTimeout = const Duration(seconds: 10),
    FirebaseRemoteConfig? remoteConfig,
  }) : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance {
    _defaults.addAll(defaults);
  }

  @override
  Future<void> setupRemoteConfig() async {
    _log.info('Setting up remote config');
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
    await _remoteConfig.setDefaults(_defaults);
    await _remoteConfig.activate();

    _updatedSubscription = _remoteConfig.onConfigUpdated.listen((event) async {
      _log.info('Remote config updated: ${event.updatedKeys}');
      await _remoteConfig.activate();
      _notify();
    });

    unawaited(_fetchInBackground());
  }

  Future<void> _fetchInBackground() async {
    try {
      await _remoteConfig.fetch();
      final activated = await _remoteConfig.activate();
      if (activated) {
        _notify();
      }
    } catch (error, stackTrace) {
      _log.warning('Remote config fetch failed', error, stackTrace);
    }
  }

  void _notify() {
    if (!_configUpdateController.isClosed) {
      _configUpdateController.add(null);
    }
  }

  @override
  Future<Map<String, String>> getAll() async {
    final allValues = _remoteConfig.getAll().map(
      (key, value) => MapEntry(key, value.asString()),
    );
    _log.info('All remote config: $allValues');
    return allValues;
  }

  @override
  Stream<void> getConfigUpdatesStream() {
    return _configUpdateController.stream;
  }

  @override
  Future<void> dispose() async {
    await _updatedSubscription?.cancel();
    _updatedSubscription = null;
    await _configUpdateController.close();
  }
}
