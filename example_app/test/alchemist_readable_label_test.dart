import 'package:flutter/material.dart';
import 'support/golden_test_helpers.dart';

/// Minimal Alchemist golden for README (`flutter test`, define flags).
///
/// Generates files next to this test under `goldens/ci/` (and optionally
/// `goldens/<your_os>/` for platform snapshots when enabled).
void main() {
  appGoldenTest(
    description: 'Readable label baseline',
    fileName: 'alchemist_readable_label',
    scenarioName: 'plain_text',
    child: const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Readable CI copy'),
    ),
  );
}
