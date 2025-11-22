import 'dart:async'; // Added for StreamController

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:remote_config/src/interface/remote_config_values.dart';
import 'package:remote_config/src/services/remote_config_service.dart';

class FirebaseRemoteConfigService implements RemoteConfigService {
  final _log = Logger('FirebaseRemoteConfigService');

  final RemoteConfigValues remoteConfigValues;
  final Map<String, String> valuesToFetch;

  // Stream controller for config updates
  final _configUpdateController = StreamController<void>.broadcast();

  FirebaseRemoteConfigService({required this.remoteConfigValues, required this.valuesToFetch});

  @override
  Future<void> setupRemoteConfig() async {
    _log.info('Setting up remote config');
    final remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.setConfigSettings(
      RemoteConfigSettings(fetchTimeout: const Duration(seconds: 10), minimumFetchInterval: const Duration(hours: 1)),
    );

    await remoteConfig.setDefaults(remoteConfigValues.toMap());

    if (!kIsWeb) {
      remoteConfig.onConfigUpdated.listen((event) async {
        _log.info('Remote config updated: ${event.updatedKeys}');
        await remoteConfig.activate();
        await getAll(); // Update our local values
        _configUpdateController.add(null); // Notify listeners
      });
    }

    // Fetch and activate config immediately
    await remoteConfig.fetch();
    await remoteConfig.activate();

    // Load initial values
    await getAll();
  }

  @override
  Future<void> getAll() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final allValues = remoteConfig.getAll();
    _log.info('All remote config: $allValues');
    remoteConfigValues.fromMap(allValues);
  }

  void dispose() {
    _configUpdateController.close();
  }

  @override
  Stream<void> getConfigUpdatesStream() {
    return _configUpdateController.stream;
  }
}
