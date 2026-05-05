# Specifications: page-overlay-animations

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: `01-requirements.md`

## Overview

Introduce an overlay mechanism for reader pages that allows host apps to inject overlay widgets with lifecycle hooks, without implementing a legacy animation engine inside `flutter_versegrid`.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `flutter_versegrid/lib/src/models/verse_page.dart` | Modify | Add optional overlay descriptors. |
| `flutter_versegrid/lib/src/widgets/verse_page_view.dart` | Modify | Provide visibility/lifecycle signals per page. |
| `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart` | Modify | (Optional) Support overlay rendering if kept at renderer level. |

## Interfaces

### Overlay descriptors

```dart
@immutable
class VersePageOverlay {
  const VersePageOverlay({
    required this.id,
    required this.builder,
    this.hitTestBehavior = HitTestBehavior.deferToChild,
  });

  final String id;
  final Widget Function(BuildContext context, VersePage page, VersePageOverlayLifecycle lifecycle)
      builder;
  final HitTestBehavior hitTestBehavior;
}

@immutable
class VersePageOverlayLifecycle {
  const VersePageOverlayLifecycle({
    required this.isVisible,
    required this.pageIndex,
  });

  final bool isVisible;
  final int pageIndex;
}
```

### Visibility detection

In `VersePageView`, compute visibility signal using the `PageController.page` value and the current item `index`.

- Visible threshold: `abs(page - index) < 0.5` (tunable).
- Provide `isVisible` to overlay builder so it can start/stop animations.

## Behavior Specifications

### Rendering order

`Stack` layers (bottom → top):

1. Background (see `sdd-page-background`)
2. Overlays (0..N)
3. Content blocks (renderer)
4. Chrome (see `sdd-page-chrome`) (optional, if enabled)

### Lifecycle

- Overlays receive updated `VersePageOverlayLifecycle` on scroll.
- Overlay implementations decide whether to animate when `isVisible == true`.

## Testing Strategy

- Widget test: overlay is inserted and receives visibility updates as page scrolls.
- Ensure no overlays by default (no changes to existing behavior).

## Open Design Questions

- Should overlays render above content instead of below? (legacy is more like "between background and content", but some apps may want above).
- Should lifecycle include `pageDelta` (distance from focused page) for nice effects?

