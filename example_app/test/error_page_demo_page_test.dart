import 'package:alchemist/alchemist.dart';
import 'package:example_app/pages/errorPageDemo/error_page_demo_page.dart';
import 'package:flutter/material.dart';

void main() {
  goldenTest(
    'Error page demo baseline',
    fileName: 'error_page_demo_page',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints.tightFor(width: 320, height: 640),
      children: [
        GoldenTestScenario(
          name: 'plain_text',
          child: const ErrorPageDemoPage(),
        ),
      ],
    ),
  );
}
