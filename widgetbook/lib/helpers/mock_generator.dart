import 'package:anyhoo_auth/cubit/anyhoo_auth_state.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_classes.dart';

class User implements AnyhooUser {
  final String id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}

class MockGenerator {
  MockAuthCubit getMockAuthCubit() {
    final mockAuthCubit = MockAuthCubit();
    final user = User(id: '123', email: 'mickey.mouse@test.com', name: 'Mickey Mouse');
    when(() => mockAuthCubit.state).thenReturn(AnyhooAuthState(user: user));
    return mockAuthCubit;
  }
}
