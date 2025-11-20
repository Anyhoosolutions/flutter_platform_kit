// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:example_app/models/example_user_converter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example_app/main.dart';
import 'package:example_app/services/mock_auth_service.dart';

void main() {
  testWidgets('App loads and shows home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final authService = createMockAuthService();
    final converter = ExampleUserConverter();
    await tester.pumpWidget(MyApp(authService: authService, converter: converter));

    // Verify that the home page is displayed
    expect(find.text('Anyhoo Packages Example'), findsOneWidget);
    expect(find.text('Auth Demo'), findsOneWidget);
    expect(find.text('Image Selector Demo'), findsOneWidget);
  });
}
