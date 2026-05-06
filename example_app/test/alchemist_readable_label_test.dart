import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

/// Minimal Alchemist golden for README (`flutter test`, define flags).
///
/// Generates files next to this test under `goldens/ci/` (and optionally
/// `goldens/<your_os>/` for platform snapshots when enabled).
void main() {
  goldenTest(
    'Readable label baseline',
    fileName: 'alchemist_readable_label',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 320),
      children: [
        GoldenTestScenario(
          name: 'plain_text',
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Readable CI copy'),
          ),
        ),
      ],
    ),
  );
}
