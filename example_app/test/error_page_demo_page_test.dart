import 'package:example_app/pages/errorPageDemo/error_page_demo_page.dart';
import 'support/golden_test_helpers.dart';

void main() {
  appGoldenTest(
    description: 'Error page demo baseline',
    fileName: 'error_page_demo_page',
    scenarioName: 'plain_text',
    child: const ErrorPageDemoPage(),
  );
}
