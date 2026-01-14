import 'dart:async';

import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/cubit/anyhoo_auth_state.dart';
import 'package:anyhoo_auth/widgets/login_widget_settings.dart';
import 'package:anyhoo_core/anyhoo_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginWidget<T extends AnyhooUser> extends StatefulWidget {
  const LoginWidget(
      {super.key, required this.title, this.assetLogoPath, this.cubit, LoginWidgetSettings? loginWidgetSettings})
      : _loginWidgetSettings = loginWidgetSettings ?? const LoginWidgetSettings();

  final String title;
  final String? assetLogoPath;
  final AnyhooAuthCubit<T>? cubit;
  final LoginWidgetSettings _loginWidgetSettings;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState<T extends AnyhooUser> extends State<LoginWidget<T>> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _isSignUp = false;
  bool _obscurePassword = true;
  StreamSubscription<AnyhooAuthState<T>>? _stateSubscription;

  @override
  void initState() {
    super.initState();
    // Subscribe to cubit stream manually to avoid provider lookup issues with generics
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscribeToCubit();
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToCubit() {
    final cubit = _getCubit(context);
    _stateSubscription = cubit.stream.listen((state) {
      if (!mounted) return;

      if (state.isAuthenticated && state.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Welcome, ${state.user?.toJson()['email'] ?? 'User'}!'), // TODO: A function that gets the email/name whatever?
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  AnyhooAuthCubit<T> _getCubit(BuildContext context) {
    // First, try to use the cubit passed as a parameter
    if (widget.cubit != null) {
      return widget.cubit!;
    }

    // Fallback: try to find it in the widget tree
    // NOTE: This may fail due to Dart's provider system limitations with generics
    try {
      return context.read<AnyhooAuthCubit<T>>();
    } catch (e) {
      throw StateError(
        'Could not find AnyhooAuthCubit<$T>. '
        'Either pass the cubit as a parameter to LoginWidget, or ensure '
        'BlocProvider<AnyhooAuthCubit<$T>> is provided above LoginWidget. '
        'Note: Dart\'s provider system cannot match generic type parameters, '
        'so the concrete type must match exactly. '
        'Original error: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the cubit - prefer passed cubit, fallback to provider lookup
    final cubit = _getCubit(context);

    // Manually listen to state changes since we can't use BlocListener with generics
    return StreamBuilder<AnyhooAuthState<T>>(
      stream: cubit.stream,
      initialData: cubit.state,
      builder: (context, snapshot) {
        // Note: SnackBar handling is done in _subscribeToCubit() to avoid duplicates
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                _getLogo() ?? const SizedBox.shrink(),
                ..._getHeader(),
                ..._getSubHeader(),
                const SizedBox(height: 48),
                ..._getEmailForm(),

                ..._getToggleButton(),

                ..._getDivider(),

                // Social Sign In Buttons
                ..._getGoogleButton(),
                ..._getAppleButton(),
                ..._getAnonymousButton(),
                _getTermsAndPrivacy(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialSignInButton({
    required VoidCallback? onPressed,
    required String icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEmailAuth() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final formData = _formKey.currentState!.value;
      final email = formData['email'] as String;
      final password = formData['password'] as String;

      try {
        if (_isSignUp) {
          _getCubit(context).login(email, password); // TODO: Create account
        } else {
          _getCubit(context).login(email, password);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _getCubit(context).loginWithGoogle();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Google: ${e.toString()}'),
          // backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _getCubit(context).loginWithApple();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Apple: ${e.toString()}'),
          // backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleAnonymousSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _getCubit(context).loginWithAnonymous();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in anonymously: ${e.toString()}'),
          // backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget? _getLogo() {
    if (widget.assetLogoPath != null) return Image.asset(widget.assetLogoPath!, width: 80, height: 80);
    return null;
  }

  List<Widget> _getHeader() {
    return [
      const SizedBox(height: 24),
      Text(
        widget.title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      )
    ];
  }

  List<Widget> _getSubHeader() {
    return [
      const SizedBox(height: 8),
      Text(
        _isSignUp ? 'Create your account' : 'Sign in to continue',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> _getEmailForm() {
    if (!widget._loginWidgetSettings.showEmailSignIn) return [];
    return [
      FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'password',
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(6),
              ]),
            ),
            const SizedBox(height: 24),

            // Sign In/Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleEmailAuth,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(), // TODO: Shimmer
                      )
                    : Text(_isSignUp ? 'Create Account' : 'Sign In'),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ];
  }

  List<Widget> _getToggleButton() {
    return [
      TextButton(
        onPressed: () {
          setState(() {
            _isSignUp = !_isSignUp;
          });
        },
        child: Text(_isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up',
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      const SizedBox(height: 32)
    ];
  }

  List<Widget> _getDivider() {
    if (!widget._loginWidgetSettings.showEmailSignIn) return [];

    if (!widget._loginWidgetSettings.showGoogleSignIn &&
        !widget._loginWidgetSettings.showAppleSignIn &&
        !widget._loginWidgetSettings.showAnonymousSignIn) {
      return [];
    }

    return [
      Row(children: [
        Expanded(
          child: Divider(color: Theme.of(context).colorScheme.outline, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Theme.of(context).colorScheme.outline, thickness: 1),
        ),
      ]),
      const SizedBox(height: 32),
    ];
  }

  List<Widget> _getGoogleButton() {
    if (!widget._loginWidgetSettings.showGoogleSignIn) return [];

    return [
      _buildSocialSignInButton(
        onPressed: _isLoading ? null : _handleGoogleSignIn,
        icon: 'images/google_icon.svg',
        text: 'Continue with Google',
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        borderColor: Theme.of(context).colorScheme.outline,
      ),
      const SizedBox(height: 16),
    ];
  }

  List<Widget> _getAppleButton() {
    if (!widget._loginWidgetSettings.showAppleSignIn) return [];

    return [
      _buildSocialSignInButton(
        onPressed: _isLoading ? null : _handleAppleSignIn,
        icon: 'assets/images/apple_icon.svg',
        text: 'Continue with Apple',
        backgroundColor: Colors.black,
        textColor: Colors.white,
        borderColor: Theme.of(context).colorScheme.outline,
      ),
      const SizedBox(height: 32),
    ];
  }

  List<Widget> _getAnonymousButton() {
    if (!widget._loginWidgetSettings.showAnonymousSignIn) return [];

    return [
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _isLoading ? null : _handleAnonymousSignIn,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.primary,
            // side: BorderSide(color: AppTheme.primaryColor),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Continue as Guest',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 32),
    ];
  }

  Widget _getTermsAndPrivacy() {
    return Text(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
      textAlign: TextAlign.center,
    );
  }
}
