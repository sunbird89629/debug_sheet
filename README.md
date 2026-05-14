# debug_sheet

Debug-time bottom sheets for Flutter.

## Widgets

### DebugInputSheet

A `showModalBottomSheet` companion that shows a text field with a persistent history list (keyed by `title`).

```dart
final url = await showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  builder: (_) => const DebugInputSheet(title: 'H5 URL'),
);
// url is the entered string, or null if dismissed/empty
```

### DebugSelectSheet

A single-select radio list. Returns the chosen index.

```dart
final index = await showModalBottomSheet<int>(
  context: context,
  builder: (_) => const DebugSelectSheet(
    title: 'Select WebView',
    items: ['New WebView', 'Old WebView'],
  ),
);
```

## Installation

```yaml
dependencies:
  debug_sheet:
    git:
      url: https://github.com/YOUR_HANDLE/debug_sheet.git
```
