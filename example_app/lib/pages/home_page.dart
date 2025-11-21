import 'package:anyhoo_auth/cubit/auth_cubit.dart';
import 'package:anyhoo_auth/widgets/login_widget.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_core/models/auth_user.dart';
import 'package:anyhoo_core/widgets/error_page.dart';
import 'package:anyhoo_core/widgets/waiting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/models/example_user.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:example_app/pages/arguments_demo_page.dart';
import 'package:example_app/pages/enhance_user_demo_page.dart';
import 'package:example_app/pages/firestore_demo_page.dart';
import 'package:example_app/services/mock_auth_service.dart';
import 'package:example_app/services/mock_enhance_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'image_selector_demo_page.dart';

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
          _DemoCard(
            title: 'Auth Demo',
            description: 'Demonstrates authentication with custom user models',
            icon: Icons.login,
            onTap: () {
              GoRouter.of(context).push('/auth');
            },
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Login Widget Demo',
            description: 'Demonstrates the login widget',
            icon: Icons.login,
            onTap: () {
              final authService = createMockAuthService();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Login Widget Demo'),
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      body: BlocProvider<AuthCubit<AuthUser>>(
                        create: (_) =>
                            AuthCubit<ExampleUser>(authService: authService, converter: ExampleUserConverter()),
                        child: LoginWidget(title: 'Example app', assetLogoPath: 'assets/images/logo.webp'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Enhance User Demo',
            description: 'Demonstrates authentication with custom user models',
            icon: Icons.login,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => AuthCubit<ExampleUser>(
                      authService: createMockAuthService(),
                      converter: ExampleUserConverter(),
                      enhanceUserService: createMockEnhanceUserService(),
                    ),
                    child: EnhanceUserDemoPage(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Image Selector Demo',
            description: 'Demonstrates image selection from gallery, camera, or stock photos',
            icon: Icons.image,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ImageSelectorDemoPage()));
            },
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Arguments Demo',
            description: 'Demonstrates arguments passed in when launching the app',
            icon: Icons.image,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ArgumentsDemoPage(arguments: arguments)));
            },
          ),
          const SizedBox(height: 16),
          _DemoCard(
            title: 'Firestore Demo',
            description: 'Demonstrates Firestore usage',
            icon: Icons.data_array,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FirestoreDemoPage(firestore: firestore)));
            },
          ),
          _DemoCard(
            title: 'Route First Demo',
            description: 'Demonstrates route first demo',
            icon: Icons.route,
            onTap: () {
              GoRouter.of(context).push('/route-demo');
            },
          ),
          const SizedBox(height: 16),
          _DemoCard(
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
          ),

          const SizedBox(height: 16),
          _DemoCard(
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
          ),
        ],
      ),
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
