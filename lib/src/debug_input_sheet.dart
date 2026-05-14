import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DebugInputSheet extends StatefulWidget {
  const DebugInputSheet({super.key, required this.title});

  final String title;

  @override
  State<DebugInputSheet> createState() => _DebugInputSheetState();
}

class _DebugInputSheetState extends State<DebugInputSheet> {
  final _controller = TextEditingController();

  String get _storageKey => md5.convert(widget.title.codeUnits).toString();

  List<String> get _cachedItems =>
      (GetStorage().read<List>(_storageKey) ?? []).cast<String>();

  void _saveItem(String item) {
    final items = _cachedItems;
    if (items.contains(item)) return;
    items.add(item);
    GetStorage().write(_storageKey, items);
  }

  void _removeItem(String item) {
    final items = _cachedItems;
    items.remove(item);
    GetStorage().write(_storageKey, items);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cached = _cachedItems;
    return Material(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: cached.length,
                  itemBuilder: (context, index) {
                    final item = cached[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(4),
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeItem(item),
                      ),
                      onTap: () => setState(() => _controller.text = item),
                    );
                  },
                ),
              ),
              TextFormField(controller: _controller),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final text = _controller.text;
                  if (text.isNotEmpty) _saveItem(text);
                  Navigator.of(context).pop(text.isEmpty ? null : text);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
