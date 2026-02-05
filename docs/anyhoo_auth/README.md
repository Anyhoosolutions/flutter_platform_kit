# Anyhoo Auth

A flexible authentication package that supports custom user models using generics.

## Features

- 🔐 Login and logout functionality
- 👤 Support for custom user models via generics
- 🔄 User data refresh
- 📦 BLoC pattern for state management
- 🎯 Type-safe with Dart generics

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  anyhoo_auth:
    git:
      url: https://github.com/anyhoosolutions/flutter_platform_kit.git
      path: packages/anyhoo_auth
      ref: main
  anyhoo_core:
    git:
      url: https://github.com/anyhoosolutions/flutter_platform_kit.git
      path: packages/anyhoo_core
      ref: main
```

## Usage

### 1. Define Your User Model

First, create your app's user model that extends `AuthUser`:

```dart
import 'package:anyhoo_core/anyhoo_core.dart';

class MyAppUser extends AuthUser {
  final String id;
  final String email;
  final String name;
  final MyAppSettings settings;

  MyAppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.settings,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'settings': settings.toJson(),
    };
  }
}

class MyAppSettings {
  final String theme;
  final bool notifications;

  MyAppSettings({required this.theme, required this.notifications});

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'notifications': notifications,
    };
  }

  factory MyAppSettings.fromJson(Map<String, dynamic> json) {
    return MyAppSettings(
      theme: json['theme'],
      notifications: json['notifications'],
    );
  }
}
```

### 2. Create a User Converter

Implement `UserConverter` to convert API responses to your user model:

```dart
import 'package:anyhoo_auth/anyhoo_auth.dart';

class MyAppUserConverter implements UserConverter<MyAppUser> {
  @override
  MyAppUser fromJson(Map<String, dynamic> json) {
    return MyAppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      settings: MyAppSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson(MyAppUser user) {
    return user.toJson();
  }
}
```

### 3. Set Up Auth Service

Create an `AuthService` instance with your login function:

```dart
import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:http/http.dart' as http;

final authService = AuthService<MyAppUser>(
  loginFunction: (email, password) async {
    final response = await http.post(
      Uri.parse('https://api.example.com/login'),
      body: {'email': email, 'password': password},
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  },
  logoutFunction: () async {
    await http.post(Uri.parse('https://api.example.com/logout'));
  },
  refreshUserFunction: () async {
    final response = await http.get(
      Uri.parse('https://api.example.com/user'),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  },
);
```

### 4. Use Auth Cubit in Your App

Wrap your app with `BlocProvider`:

```dart
import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit<MyAppUser>(authService: authService, converter: MyAppUserConverter(),),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
```

AuthCubit also allows for a `EnhanceUserService` that can look up more information about the user, such as reading from Firestore
```data

      create: (_) => AuthCubit<MyAppUser>(authService: authService, converter: MyAppUserConverter(), enhanceUserService: enhanceUserService),
```


### 5. Use Auth State in Widgets

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit<MyAppUser>, AuthState<MyAppUser>>(
      builder: (context, state) {
        if (state.isLoading) {
          return CircularProgressIndicator();
        }

        if (state.isAuthenticated) {
          return Text('Welcome, ${state.user!.email}!');
        }

        return LoginPage();
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit<MyAppUser>, AuthState<MyAppUser>>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Column(
        children: [
          TextField(controller: _emailController),
          TextField(controller: _passwordController, obscureText: true),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit<MyAppUser>>().login(
                    _emailController.text,
                    _passwordController.text,
                  );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

## API Reference

### AuthService<T extends AuthUser>

Main service for authentication operations.

- `login(String email, String password)`: Log in with credentials
- `logout()`: Log out the current user
- `refreshUser()`: Refresh user data from server
- `currentUser`: Get the current authenticated user
- `isAuthenticated`: Check if a user is logged in

### AuthCubit<T extends AuthUser>

BLoC cubit for reactive authentication state.

- `login(String email, String password)`: Log in (emits state changes)
- `logout()`: Log out (emits state changes)
- `refreshUser()`: Refresh user data (emits state changes)
- `setUser(T user)`: Set user (useful for restoring from storage)

### AuthState<T extends AuthUser>

State class containing:
- `user`: Current user or null
- `isLoading`: Whether an operation is in progress
- `errorMessage`: Error message if operation failed
- `isAuthenticated`: Convenience getter for authentication status

## License

See LICENSE file.

---

## Changelog

### 0.0.31 

* Replace svg files by coding svg in dart file

### 0.0.30

* Change colors for Login widget

### 0.0.29

* safeFromJson

### 0.0.28

* Add Sentry logging

### 0.0.27

* Change to use freezed for AnyhooAuthState

### 0.0.26

* Small fix for Google log in
* Logging

### 0.0.25

* Adding logging for Google Sign in

### 0.0.24

* AuthState to start at `null`

### 0.0.23

* Map<String, dynamic> for getting user data and <T extends AnyhooUser> when saving

### 0.0.22

* Simplify AnyhooUser

### 0.0.21

* AnyhooAuthService returns AnyhooUser instead of Map<String, dynamic>

### 0.0.20

* Export AnyhooFirebaseEnhanceUserService

### 0.0.19

* Multiple EnhanceUserServices

### 0.0.18

* More logging

### 0.0.17

* Allow for refreshing user

### 0.0.16

* Allow to refresh a user

### 0.0.15

* Getters for AnyhooUser

### 0.0.14

* Allow EnhancedAuthService to save a user

### 0.0.13

* Refactor EnhancedAuthService to be an interface

### 0.0.12

* Refactor AuthService to be an interface
* Fix logging out with Firebase Auth

### 0.0.11

* Specify T extends AnyhooUser for AnyhooAuthService and AnyhooFirebaseAuthService

### 0.0.10

* Export updater classes

### 0.0.9

* Logging for changing state

### 0.0.8

* UpdatableForAnyhooUser

### 0.0.7

* Change class names

### 0.0.6

* Revert to have references using path

### 0.0.5

* Reference anyhoo_core using Git

### 0.0.4

* Google sign in

### 0.0.3

* Adding support for a EnhanceUserService. It can, after the log in, lock up user data from e.g. Firestore
* Adding a `FirebaseEnhanceUserService`

### 0.0.2

* Fixes
* Adding LoginWidget

### 0.0.1

* Auth service
