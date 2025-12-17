import 'dart:async'; // Added for StreamController

import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class FirebaseAnyhooRemoteConfigService implements AnyhooRemoteConfigService {
  final _log = Logger('FirebaseRemoteConfigService');

  final Map<String, dynamic> _defaults = {};

  FirebaseAnyhooRemoteConfigService({required Map<String, dynamic> defaults}) {
    _defaults.addAll(defaults);
  }

  // Stream controller for config updates
  final _configUpdateController = StreamController<void>.broadcast();

  @override
  Future<void> setupRemoteConfig() async {
    _log.info('Setting up remote config');
    final remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.setConfigSettings(
      RemoteConfigSettings(fetchTimeout: const Duration(seconds: 10), minimumFetchInterval: const Duration(hours: 1)),
    );

    await remoteConfig.setDefaults(_defaults);

    // if (!kIsWeb) {
    remoteConfig.onConfigUpdated.listen((event) async {
      _log.info('Remote config updated: ${event.updatedKeys}');
      await remoteConfig.activate();
      await getAll(); // Update our local values
      _configUpdateController.add(null); // Notify listeners
    });
    // }

    // Fetch and activate config immediately
    await remoteConfig.fetch();
    await remoteConfig.activate();

    // Load initial values
    await getAll();
  }

  @override
  Future<Map<String, String>> getAll() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final allValues = remoteConfig.getAll().map((key, value) => MapEntry(key, value.asString()));
    _log.info('All remote config: $allValues');
    return allValues;
  }

  void dispose() {
    _configUpdateController.close();
  }

  @override
  Stream<void> getConfigUpdatesStream() {
    return _configUpdateController.stream;
  }
}
