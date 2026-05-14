import 'package:debug_sheet/debug_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _inputResult = '—';
  int _selectResult = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('debug_sheet example')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Input result: $_inputResult'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const DebugInputSheet(title: 'Enter a URL'),
                );
                setState(() => _inputResult = result ?? '(cancelled)');
              },
              child: const Text('Open DebugInputSheet'),
            ),
            const SizedBox(height: 32),
            Text('Select result: index $_selectResult'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (_) => const DebugSelectSheet(
                    title: 'Choose an option',
                    items: ['Option A', 'Option B', 'Option C'],
                  ),
                );
                setState(() => _selectResult = result ?? -1);
              },
              child: const Text('Open DebugSelectSheet'),
            ),
          ],
        ),
      ),
    );
  }
}
