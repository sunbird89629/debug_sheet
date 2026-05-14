import 'package:debug_sheet/debug_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DebugSelectSheet', () {
    testWidgets('renders title and all items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebugSelectSheet(
              title: 'Pick one',
              items: ['A', 'B', 'C'],
            ),
          ),
        ),
      );
      expect(find.text('Pick one'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('defaults to index 0 selected', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebugSelectSheet(
              title: 'Pick',
              items: ['A', 'B'],
            ),
          ),
        ),
      );
      final radios = tester.widgetList<Radio<int>>(find.byType(Radio<int>)).toList();
      expect(radios[0].groupValue, 0);
      expect(radios[1].groupValue, 0);
    });

    testWidgets('pops with selected index on OK', (tester) async {
      int? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (_) => const DebugSelectSheet(
                    title: 'Pick',
                    items: ['A', 'B'],
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(result, 1);
    });

    testWidgets('pops with 0 when OK tapped without changing selection', (tester) async {
      int? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (_) => const DebugSelectSheet(
                    title: 'Pick',
                    items: ['A', 'B'],
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(result, 0);
    });
  });
}
