import 'package:flutter/material.dart';

class DebugSelectSheet extends StatefulWidget {
  const DebugSelectSheet({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  State<DebugSelectSheet> createState() => _DebugSelectSheetState();
}

class _DebugSelectSheetState extends State<DebugSelectSheet> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemCount: widget.items.length,
                itemBuilder: (context, index) => RadioListTile<int>(
                  value: index,
                  groupValue: _selectedIndex,
                  onChanged: (value) =>
                      setState(() => _selectedIndex = value ?? 0),
                  title: Text(widget.items[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_selectedIndex),
                  child: const Text('OK'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
