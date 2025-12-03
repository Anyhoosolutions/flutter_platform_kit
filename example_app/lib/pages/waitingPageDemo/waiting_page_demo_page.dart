import 'package:anyhoo_core/widgets/waiting_page.dart';
import 'package:flutter/material.dart';

class WaitingPageDemoPage extends StatelessWidget {
  const WaitingPageDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Page Demo'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: WaitingPage(message: 'Loading...'),
    );
  }
}
