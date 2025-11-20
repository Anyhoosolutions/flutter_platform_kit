import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNestedDemoPage extends StatelessWidget {
  const RouteNestedDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Nested Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Route Nested Demo'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
