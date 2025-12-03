import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteFirstDemoPage extends StatelessWidget {
  const RouteFirstDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route First Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Route First Demo'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).push('/route-demo/nested');
              },
              child: const Text('Go to Auth'),
            ),
          ],
        ),
      ),
    );
  }
}
