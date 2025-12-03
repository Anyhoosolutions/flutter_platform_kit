import 'package:anyhoo_core/extensions/anyhoo_string_extensions.dart';
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger('LoggingPage');

/// Home page that serves as a navigation hub for package demos.
class LoggingPage extends StatelessWidget {
  const LoggingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loggingConfiguration = context.read<LoggingConfiguration>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anyhoo Packages Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text('Logging Page'),
            SizedBox(height: 16),
            Divider(indent: 40, endIndent: 40, thickness: 1),
            SizedBox(height: 56),
            _configToAllowInfoLoggingButton(loggingConfiguration),
            _configToOnlyAllowSevereLoggingButton(loggingConfiguration),

            SizedBox(height: 32),
            Divider(indent: 120, endIndent: 120, thickness: 1),
            SizedBox(height: 32),

            _logInfoButton(),
            _logSevereButton(),

            SizedBox(height: 32),
            Divider(indent: 120, endIndent: 120, thickness: 1),
            SizedBox(height: 32),

            Text('Logs:'),
            BlocBuilder<LoggingCubit, List<LogRecord>>(
              builder: (context, logs) {
                return Column(
                  children: logs.map((e) {
                    return Row(
                      children: [
                        SizedBox(width: 16),
                        Text(e.loggerName.substringSafe(0, 12).padRight(20)),
                        SizedBox(width: 8),
                        Text(e.message.substringSafe(0, 30)),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _configToAllowInfoLoggingButton(LoggingConfiguration loggingConfiguration) {
    return OutlinedButton(
      onPressed: () {
        loggingConfiguration.addInfoLogger('LoggingPage');
      },
      child: Text('Config to allow info logging'),
    );
  }

  Widget _configToOnlyAllowSevereLoggingButton(LoggingConfiguration loggingConfiguration) {
    return OutlinedButton(
      onPressed: () {
        loggingConfiguration.addSevereLogger('LoggingPage');
      },
      child: Text('Config to only allow severe logging'),
    );
  }

  Widget _logInfoButton() {
    return OutlinedButton(
      onPressed: () {
        _log.info('Log info');
      },
      child: Text('Log Info'),
    );
  }

  Widget _logSevereButton() {
    return OutlinedButton(
      onPressed: () {
        _log.severe('Log severe');
      },
      child: Text('Log severe'),
    );
  }
}
