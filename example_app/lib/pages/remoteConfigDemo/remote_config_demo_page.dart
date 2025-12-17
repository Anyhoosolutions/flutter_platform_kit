import 'package:example_app/pages/remoteConfigDemo/remote_config_values.dart';
import 'package:flutter/material.dart';
import 'package:anyhoo_remote_config/anyhoo_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteConfigDemoPage extends StatelessWidget {
  const RemoteConfigDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultValues = RemoteConfigValues();
    return Scaffold(
      body: BlocProvider(
        create: (context) => RemoteConfigCubit<RemoteConfigValues>(
          service: FirebaseAnyhooRemoteConfigService(defaults: defaultValues.toMap()),
          initialValues: defaultValues,
        ),

        child: BlocBuilder<RemoteConfigCubit<RemoteConfigValues>, RemoteConfigState<RemoteConfigValues>>(
          builder: (context, state) {
            final remoteConfigValues = state.values;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Values: '),
                  ...remoteConfigValues.toMap().entries.map((entry) => Text('${entry.key}: ${entry.value}')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
