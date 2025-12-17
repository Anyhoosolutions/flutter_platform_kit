import 'package:anyhoo_core/extensions/anyhoo_string_extensions.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:flutter/material.dart';

class ArgumentsDemoPage extends StatelessWidget {
  final Arguments arguments;
  const ArgumentsDemoPage({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final argumentsString = arguments
        .toString()
        .substring(10)
        .substringSafe(0, arguments.toString().length - 11)
        .split(',');
    return Scaffold(
      appBar: AppBar(title: const Text('Arguments Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Text('Arguments'), ...argumentsString.map((arg) => Text('     $arg'))],
        ),
      ),
    );
  }
}
