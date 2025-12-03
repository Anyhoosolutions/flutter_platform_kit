import 'package:anyhoo_core/widgets/error_page.dart';
import 'package:flutter/material.dart';

class ErrorPageDemoPage extends StatelessWidget {
  const ErrorPageDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Page Demo'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: ErrorPage(
        errorMessage: 'Error message',
        detailedError:
            'Detailed error message. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      ),
    );
  }
}
