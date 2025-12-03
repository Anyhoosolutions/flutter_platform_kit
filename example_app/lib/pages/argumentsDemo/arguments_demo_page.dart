import 'package:anyhoo_core/models/arguments.dart';
import 'package:flutter/material.dart';

class ArgumentsDemoPage extends StatelessWidget {
  final Arguments arguments;
  const ArgumentsDemoPage({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arguments Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Text('Arguments: ${arguments.toString()}')],
        ),
      ),
    );
  }
}
