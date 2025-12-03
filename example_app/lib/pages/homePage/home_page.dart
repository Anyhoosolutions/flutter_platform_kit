import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_core/widgets/error_page.dart';
import 'package:anyhoo_core/widgets/waiting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/pages/argumentsDemo/arguments_demo_page.dart';
import 'package:example_app/pages/firestoreDemo/firestore_demo_page.dart';
import 'package:example_app/pages/imageSelectorDemo/image_selector_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home page that serves as a navigation hub for package demos.
class HomePage extends StatelessWidget {
  final Arguments arguments;
  final FirebaseFirestore firestore;

  const HomePage({super.key, required this.arguments, required this.firestore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anyhoo Packages Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _authDemoButton(context),
          const SizedBox(height: 16),
          _loggingPageDemoButton(context),
          const SizedBox(height: 16),
          _loginButton(context),
          SizedBox(height: 16),
          _enhancedUserDemoButton(context),
          const SizedBox(height: 16),
          _analyticsDemoButton(context),
          const SizedBox(height: 16),
          _imageSelectorDemoButton(context),
          const SizedBox(height: 16),
          _remoteConfigDemoButton(context),
          const SizedBox(height: 16),
          _argumentsDemoButton(context),
          const SizedBox(height: 16),
          _firestoreDemoButton(context),
          const SizedBox(height: 16),
          _routeDemoButton(context),
          const SizedBox(height: 16),
          _errorPageDemoButton(context),
          const SizedBox(height: 16),
          _waitingPageDemoButton(context),
        ],
      ),
    );
  }

  _DemoCard _authDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Auth Demo',
      description: 'Demonstrates authentication with custom user models',
      icon: Icons.login,
      onTap: () {
        GoRouter.of(context).push('/auth');
      },
    );
  }

  _DemoCard _loginButton(BuildContext context) {
    return _DemoCard(
      title: 'Login Widget Demo',
      description: 'Demonstrates the login widget',
      icon: Icons.login,
      onTap: () {
        GoRouter.of(context).push('/image-selector');
      },
    );
  }

  _DemoCard _enhancedUserDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Enhance User Demo',
      description: 'Demonstrates authentication with custom user models',
      icon: Icons.login,
      onTap: () {
        GoRouter.of(context).push('/enhance-user');
      },
    );
  }

  _DemoCard _analyticsDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Analytics & Crashlytics Demo',
      description: 'Demonstrates Firebase Analytics and Crashlytics',
      icon: Icons.analytics,
      onTap: () {
        GoRouter.of(context).push('/analytics');
      },
    );
  }

  _DemoCard _imageSelectorDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Image Selector Demo',
      description: 'Demonstrates image selection from gallery, camera, or stock photos',
      icon: Icons.image,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ImageSelectorDemoPage()));
      },
    );
  }

  _DemoCard _remoteConfigDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Remote Config Demo',
      description: 'Demonstrates remote config',
      icon: Icons.settings,
      onTap: () {
        GoRouter.of(context).push('/remote-config');
      },
    );
  }

  _DemoCard _argumentsDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Arguments Demo',
      description: 'Demonstrates arguments passed in when launching the app',
      icon: Icons.image,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ArgumentsDemoPage(arguments: arguments)));
      },
    );
  }

  _DemoCard _firestoreDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Firestore Demo',
      description: 'Demonstrates Firestore usage',
      icon: Icons.data_array,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => FirestoreDemoPage(firestore: firestore)));
      },
    );
  }

  _DemoCard _routeDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Route First Demo',
      description: 'Demonstrates route first demo',
      icon: Icons.route,
      onTap: () {
        GoRouter.of(context).push('/route-demo');
      },
    );
  }

  _DemoCard _errorPageDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Error Page Demo',
      description: 'Demonstrates error page',
      icon: Icons.error,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
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
            ),
          ),
        );
      },
    );
  }

  _DemoCard _waitingPageDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Waiting Page Demo',
      description: 'Demonstrates waiting page',
      icon: Icons.hourglass_empty,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
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
            ),
          ),
        );
      },
    );
  }

  _DemoCard _loggingPageDemoButton(BuildContext context) {
    return _DemoCard(
      title: 'Logging Demo',
      description: 'Demonstrates logging',
      icon: Icons.text_snippet,
      onTap: () {
        GoRouter.of(context).push('/logging');
      },
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _DemoCard({required this.title, required this.description, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
