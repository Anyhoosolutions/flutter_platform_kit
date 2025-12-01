import 'package:flutter/material.dart';

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
      body: Text('Logging Page'),
    );
  }
}
