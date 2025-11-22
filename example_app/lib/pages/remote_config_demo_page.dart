import 'package:flutter/material.dart';
import 'package:remote_config/remote_config.dart';

class RemoteConfigDemoPage extends StatelessWidget {
  final RemoteConfigValues remoteConfigValues;

  const RemoteConfigDemoPage({super.key, required this.remoteConfigValues});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Values: '),
            ...remoteConfigValues.toMap().entries.map((entry) => Text('${entry.key}: ${entry.value}')),
          ],
        ),
      ),
    );
  }
}
