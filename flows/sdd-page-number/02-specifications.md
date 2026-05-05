# Specifications: page-number

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: `01-requirements.md`

## Overview

Add an opt-in page number overlay capability to the default page renderer path, without imposing a numbering scheme. The host app either embeds the number in the page model or supplies it via a formatter.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `flutter_versegrid/lib/src/models/verse_page.dart` | Modify | Add optional `pageNumber` and visibility flag, OR a `meta` bag. |
| `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart` | Modify | Render number overlay when enabled. |
| `flutter_versegrid/lib/src/theme/...` | Create/Modify | Optional theme extension for number style/position. |

## Interfaces

### Option A: Model carries number

```dart
enum VersePageNumberPosition { bottomLeft, bottomCenter, bottomRight }

@immutable
class VersePageNumber {
  const VersePageNumber({
    required this.value,
    this.position = VersePageNumberPosition.bottomLeft,
    this.format,
  });

  final int value;
  final VersePageNumberPosition position;
  final String Function(int value)? format;
}
```

`VersePage` gets `final VersePageNumber? pageNumber;`.

### Rendering rules

- If `page.pageNumber == null`: do nothing.
- Else: render a `Text` overlay aligned per position.
- Default text style: `Theme.of(context).textTheme.labelLarge` (override via parameter/theme).
- Padding: safe-area aware and consistent with `VersePageView` default padding.

## Testing Strategy

- Widget test: number shown/hidden.
- Widget test: format function is applied.
- Widget test: positioning aligns as expected.

## Open Design Questions

- Should `VersePageRenderer` expose `pageNumberBuilder` instead of standardizing UI?
- Should `VersePageView` default renderer be responsible for number (because it knows safe areas)?

