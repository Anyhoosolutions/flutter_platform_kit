import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/remoteConfigDemo/remote_config_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';

class RemoteConfigDemoRoute extends AnyhooRoute<AnyhooRouteName> {
  RemoteConfigDemoRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder {
    final remoteConfigValues = RemoteConfigValues(values: {'fruit': 'pear'});
    final remoteConfigService = FirebaseAnyhooRemoteConfigService(remoteConfigValues: remoteConfigValues);
    remoteConfigService.setupRemoteConfig();

    remoteConfigService.getConfigUpdatesStream().listen((event) {
      // ignore: avoid_print
      print('Remote config updated');
    });

    return (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Remote Config Demo 2')),
      body: StreamBuilder(
        stream: remoteConfigService.getConfigUpdatesStream(),
        builder: (context, snapshot) => RemoteConfigDemoPage(remoteConfigValues: remoteConfigValues),
      ),
    );
  }

  @override
  String get path => '/remote-config';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.remoteConfig;

  @override
  String get title => 'Remote Config Demo';
}

class RemoteConfigValues implements AnyhooRemoteConfigValues {
  final Map<String, dynamic> values = {};

  RemoteConfigValues({required Map<String, dynamic> values}) {
    this.values.addAll(values);
    // ignore: avoid_print
    print('RRemoteConfigValues: $values');
  }
  @override
  void fromMap(Map<String, dynamic> map) {
    values.clear();
    values.addAll(map.cast<String, String>());
  }

  @override
  Map<String, dynamic> toMap() {
    return values;
  }
}
