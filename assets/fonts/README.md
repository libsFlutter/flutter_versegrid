# Fonts

This package intentionally **does not ship font binaries** (see `flows/sdd-typographics/01-requirements.md`).

Use this directory as a conventional place for host apps (or the `example/` app) to drop their fonts during development.

## Recommended integration patterns

### App-owned fonts (recommended)

Declare fonts in your app’s `pubspec.yaml` and reference them via `ThemeData(fontFamily: ...)` or explicit `TextStyle(fontFamily: ...)`.

### If you decide to bundle fonts inside this package

Add font files here and declare them under the `flutter:` → `fonts:` section of this package’s `pubspec.yaml`.
Keep in mind this makes the package responsible for licensing and file size.

