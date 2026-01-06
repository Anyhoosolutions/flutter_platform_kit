import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:widgetbook_workspace/helpers/mock_generator.dart';

class MockAuthCubit extends MockCubit<AnyhooAuthState<User>> implements AnyhooAuthCubit<User> {}
