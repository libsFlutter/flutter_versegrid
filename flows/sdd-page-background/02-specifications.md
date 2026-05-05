# Specifications: page-background

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: `01-requirements.md`

## Overview

Add an optional background layer to `VersePage` and integrate it into `VersePageRenderer` (and default renderer inside `VersePageView`) with a small, theme-agnostic API.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `flutter_versegrid/lib/src/models/verse_page.dart` | Modify | Add optional background configuration. |
| `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart` | Modify | Render background behind blocks. |
| `flutter_versegrid/lib/flutter_versegrid.dart` | Modify | Export any new types. |

## Interfaces

### New Types

```dart
enum VersePageBackgroundFit { cover, contain, fill, none }

@immutable
class VersePageBackground {
  const VersePageBackground({
    this.color,
    this.image,
    this.fit = VersePageBackgroundFit.cover,
    this.alignment = Alignment.center,
  });

  final Color? color;
  final ImageProvider? image;
  final VersePageBackgroundFit fit;
  final Alignment alignment;
}
```

### Modified Types

```dart
class VersePage {
  const VersePage({
    required this.id,
    required this.blocks,
    this.semanticsLabel,
    this.background,
  });

  final VersePageBackground? background;
}
```

## Behavior Specifications

### Rendering

- If `background == null`: current rendering unchanged.
- If `background.color != null`: paint a solid background.
- If `background.image != null`: paint image using `DecorationImage` (or `Image` behind content) with provided fit/alignment.
- If both provided: color paints under the image.

### Performance

- Favor `DecorationImage` / `BoxDecoration` so Flutter image cache can work normally.
- Do not prefetch by default; allow host app to pre-cache if needed.

## Testing Strategy

- Widget test that background exists and is behind content.
- Golden tests optional (host project dependent).

## Open Design Questions

- Do we also need a per-block background concept, or is paragraph style registry sufficient?

