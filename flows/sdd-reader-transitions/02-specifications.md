# Specifications: reader-transitions

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: `01-requirements.md`

## Overview

Extend `VersePageView` with a custom transition builder API that can transform each page child based on scroll position. Keep existing presets intact.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `flutter_versegrid/lib/src/widgets/verse_page_view.dart` | Modify | Add custom transition builder and state plumbing. |
| `flutter_versegrid/lib/flutter_versegrid.dart` | Modify | Export new types (if public). |

## Interfaces

### New transition builder

```dart
typedef VersePageTransitionBuilder = Widget Function(
  BuildContext context, {
  required Widget child,
  required int index,
  required double page, // controller.page-like
});
```

`VersePageView` adds:

- `final VersePageTransitionBuilder? transitionBuilder;`

Resolution order:

1. If `transitionBuilder != null`, use it
2. Else use `transitionPreset` logic (current behavior)

## Behavior Specifications

### Page delta

For a page at `index`, compute:

- `delta = (page - index).abs().clamp(0.0, 1.0)`
- optionally also expose signed offset: `offset = (page - index).clamp(-1.0, 1.0)`

If needed, expand builder signature later to include both.

### Curl-like preset (optional)

Provide a best-effort pure Flutter visual using 3D transform + shadowing (not a perfect curl). Keep it as an optional preset to avoid API bloat.

## Testing Strategy

- Widget test: custom builder invoked.
- Widget test: presets still work if builder is null.

## Open Design Questions

- Should the builder receive `offset` (signed) in addition to `page`?
- Should the builder be able to control hit-testing/opacity for performance?

