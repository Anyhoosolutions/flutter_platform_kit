import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger('LoggingPage');

/// Home page that serves as a navigation hub for package demos.
class LoggingPage extends StatelessWidget {
  const LoggingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anyhoo Packages Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text('Logging Page'),
            Divider(indent: 40, endIndent: 40, thickness: 1),
            SizedBox(height: 56),
            _configToAllowInfoLoggingButton(),
            _configToOnlyAllowSevereLoggingButton(),
            SizedBox(height: 32),

            _logInfoButton(),
            _logSevereButton(),
          ],
        ),
      ),
    );
  }

  Widget _configToAllowInfoLoggingButton() {
    return OutlinedButton(
      onPressed: () {
        LoggingConfiguration.setupLogging(
          logLevel: 'INFO',
          loggersAtInfo: ['LoggingPage'],
          loggersAtWarning: [],
          loggersAtSevere: [],
        );
      },
      child: Text('Config to allow info logging'),
    );
  }

  Widget _configToOnlyAllowSevereLoggingButton() {
    return OutlinedButton(
      onPressed: () {
        LoggingConfiguration.setupLogging(
          logLevel: 'SEVERE',
          loggersAtInfo: [],
          loggersAtWarning: [],
          loggersAtSevere: ['LoggingPage'],
        );
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
