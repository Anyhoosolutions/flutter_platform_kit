import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tapping a button item calls its onTap and shows its label as tooltip', (tester) async {
    var taps = 0;
    const key = Key('edit');

    await tester.pumpWidget(
      MaterialApp(
        theme: AnyhooTheme.light(),
        home: Scaffold(
          appBar: AnyhooTopBar(
            topBarTitle: 'Title',
            buttonItems: [
              AnyhooTopBarButtonItem(key: key, label: 'Edit', icon: Icons.edit, onTap: () => taps++),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(key));
    expect(taps, 1);
    expect(find.byTooltip('Edit'), findsOneWidget);
  });
}
