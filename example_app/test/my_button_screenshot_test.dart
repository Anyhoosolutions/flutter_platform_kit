import 'package:flutter/material.dart';
import 'support/golden_test_helpers.dart';

void main() {
  appGoldenTest(
    description: 'MyButton snapshot',
    fileName: 'my_button',
    child: Material(
      child: Center(
        child: FilledButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ),
    ),
  );
}
