import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';
import '../models/example_user.dart';

/// Demo page showing authentication functionality.
class AuthDemoPage extends StatefulWidget {
  const AuthDemoPage({super.key});

  @override
  State<AuthDemoPage> createState() => _AuthDemoPageState();
}

class _AuthDemoPageState extends State<AuthDemoPage> {
  final _emailController = TextEditingController(text: 'demo@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Demo')),
      body: BlocListener<AuthCubit<ExampleUser>, AuthState<ExampleUser>>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
          }
        },
        child: BlocBuilder<AuthCubit<ExampleUser>, AuthState<ExampleUser>>(
          builder: (context, state) {
            if (state.isAuthenticated) {
              return _buildAuthenticatedView(context, state.user!);
            } else {
              return _buildLoginView(context, state.isLoading);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoginView(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.login, size: 80, color: Colors.blue),
          const SizedBox(height: 32),
          Text('Login Demo', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Enter any email and password to login (mock authentication)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            enabled: !isLoading,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<AuthCubit<ExampleUser>>().login(_emailController.text, _passwordController.text);
                  },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ) // TODO: Shimmer
                : const Text('Login'),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('OR')),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    context.read<AuthCubit<ExampleUser>>().loginWithGoogle();
                  },
            icon: const Icon(Icons.g_mobiledata, size: 28),
            label: const Text('Sign in with Google'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    context.read<AuthCubit<ExampleUser>>().loginWithApple();
                  },
            icon: const Icon(Icons.apple, size: 28),
            label: const Text('Sign in with Apple'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context, ExampleUser user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  Text('Logged In', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  _UserInfoRow(label: 'ID', value: user.id),
                  const Divider(),
                  _UserInfoRow(label: 'Email', value: user.email),
                  const Divider(),
                  _UserInfoRow(label: 'Name', value: user.name),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<AuthCubit<ExampleUser>>().refreshUser();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh User'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AuthCubit<ExampleUser>>().logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ],
      ),
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _UserInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
