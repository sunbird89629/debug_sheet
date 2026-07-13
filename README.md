# debug_sheet

Zero-friction bottom sheets for **in-app debug menus** in Flutter — a text-input sheet that
**remembers past inputs**, and a single-select radio list. Both return typed results via
`Navigator.pop`, so they drop straight into any existing `showModalBottomSheet` flow.

Built for the common case where you want a hidden dev drawer that lets you paste a test URL,
switch WebView engines, toggle feature flags, etc. — without wiring up a whole settings screen.

## Features

- **`DebugInputSheet`** — text field with a **persistent history list** (per-title, MD5-keyed
  in `get_storage`). Enter a URL once, next time it's one tap away. Swipe or long-press to
  remove a stale entry.
- **`DebugSelectSheet`** — radio list that returns the chosen index. No setup, no controllers.
- Pure Flutter widgets — no platform channels, no BuildContext gymnastics.

## Install

```yaml
dependencies:
  debug_sheet:
    git:
      url: https://github.com/sunbird89629/debug_sheet.git
```

Because it uses [`get_storage`](https://pub.dev/packages/get_storage) for history, initialize
it once at startup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}
```

## Usage

### `DebugInputSheet` — text input with history

```dart
final url = await showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true, // recommended: sheet resizes for the keyboard
  builder: (_) => const DebugInputSheet(title: 'H5 URL'),
);
// url: the entered/tapped string, or null if dismissed
```

The `title` doubles as the storage key — sheets with the same title share history.

### `DebugSelectSheet` — single-select radio list

```dart
final index = await showModalBottomSheet<int>(
  context: context,
  builder: (_) => const DebugSelectSheet(
    title: 'Select WebView',
    items: ['New WebView', 'Old WebView'],
  ),
);
// index: the tapped item's index, or null if dismissed
```

## Example

A runnable demo lives in [`example/`](./example) — a home page with two buttons that open
each sheet and show the result.

```bash
cd example
flutter run
```

## License

MIT
