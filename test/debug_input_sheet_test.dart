import 'package:debug_sheet/debug_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.';
      }
      return null;
    });
    await GetStorage.init();
  });

  setUp(() {
    GetStorage().erase();
  });

  group('DebugInputSheet', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebugInputSheet(title: 'Enter URL'),
          ),
        ),
      );
      expect(find.text('Enter URL'), findsOneWidget);
    });

    testWidgets('pops with entered text on OK', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const DebugInputSheet(title: 'Enter URL'),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'https://example.com');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(result, 'https://example.com');
    });

    testWidgets('pops with null when text is empty', (tester) async {
      String? result = 'not-null';
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const DebugInputSheet(title: 'Enter URL'),
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
      expect(result, isNull);
    });

    testWidgets('tapping history item populates text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const DebugInputSheet(title: 'Enter URL'),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      // Save an item to history
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'https://saved.com');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Open again — history item should appear
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('https://saved.com'), findsOneWidget);

      // Tap the history item
      await tester.tap(find.text('https://saved.com'));
      await tester.pumpAndSettle();

      // Text field should be populated
      expect(
        tester.widget<TextFormField>(find.byType(TextFormField)).controller?.text,
        'https://saved.com',
      );
    });

    testWidgets('most recent item is first in history', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const DebugInputSheet(title: 'Enter URL'),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      Future<void> openSheet() async {
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
      }

      Future<void> confirm(String text) async {
        await openSheet();
        await tester.enterText(find.byType(TextFormField), text);
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
      }

      List<String?> history() => tester
          .widgetList<ListTile>(find.byType(ListTile))
          .map((tile) => (tile.title as Text).data)
          .toList();

      await confirm('https://first.com');
      await confirm('https://second.com');

      await openSheet();
      expect(history(), ['https://second.com', 'https://first.com']);

      // Confirming a value already in history moves it back to the top.
      await tester.tap(find.text('https://first.com'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await openSheet();
      expect(history(), ['https://first.com', 'https://second.com']);
    });

    testWidgets('delete icon removes history item', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const DebugInputSheet(title: 'Enter URL'),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      // Save a history item
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'https://delete-me.com');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Open again and delete
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('https://delete-me.com'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      expect(find.text('https://delete-me.com'), findsNothing);
    });
  });
}
