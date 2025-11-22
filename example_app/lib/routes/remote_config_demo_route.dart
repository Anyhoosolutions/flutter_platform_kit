import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/remote_config_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remote_config/remote_config.dart';

class RemoteConfigDemoRoute extends AnyhooRoute<AnyhooRouteName> {
  RemoteConfigDemoRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder {
    final remoteConfigValues = RRemoteConfigValues(values: {'fruit': 'pear'});
    final remoteConfigService = FirebaseRemoteConfigService(remoteConfigValues: remoteConfigValues);
    remoteConfigService.setupRemoteConfig();

    remoteConfigService.getConfigUpdatesStream().listen((event) {
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

class RRemoteConfigValues implements RemoteConfigValues {
  final Map<String, dynamic> values = {};

  RRemoteConfigValues({required Map<String, dynamic> values}) {
    this.values.addAll(values);
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
