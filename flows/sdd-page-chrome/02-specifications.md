# Specifications: page-chrome

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: `01-requirements.md`

## Overview

Add an optional page-chrome overlay layer to the default `VersePageView` rendering pipeline. The chrome is a set of **slots** and **callbacks**; the host app owns navigation, bookmarks, search, and audio logic.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `flutter_versegrid/lib/src/widgets/verse_page_view.dart` | Modify | Add chrome builder/slots. |
| `flutter_versegrid/lib/src/models/verse_page.dart` | Modify | Optional page chrome hints (per-page enable/disable). |
| `flutter_versegrid/lib/flutter_versegrid.dart` | Modify | Export chrome types. |

## Interfaces

### Chrome action model

```dart
enum VerseChromeAction {
  prevPage,
  nextPage,
  openSearch,
  openBookmarks,
  addBookmark,
  playAudio,
  stopAudio,
  togglePlayer,
}

typedef VerseChromeActionCallback = void Function(
  VerseChromeAction action, {
  required String pageId,
});
```

### Chrome builder

```dart
typedef VersePageChromeBuilder = Widget Function(
  BuildContext context, {
  required VersePage page,
  required int pageIndex,
  required int pageCount,
  required VerseChromeActionCallback onAction,
});
```

### Per-page hints (optional)

```dart
@immutable
class VersePageChromeHints {
  const VersePageChromeHints({
    this.hiddenActions = const {},
    this.disabledActions = const {},
  });

  final Set<VerseChromeAction> hiddenActions;
  final Set<VerseChromeAction> disabledActions;
}
```

`VersePage` optionally gets `final VersePageChromeHints? chromeHints;`.

## Behavior Specifications

### Rendering

- `VersePageView` wraps each rendered page in a `Stack`.
- Base layer: renderer child (`VersePageRenderer` or custom rendererBuilder).
- Top layer: `chromeBuilder(...)` if provided.

### Action routing

- Chrome invokes `onAction(action, pageId: page.id)`.
- Host app decides what to do (e.g., update `pages`, push routes, start audio).

## Testing Strategy

- Widget test: chrome is overlayed on page content.
- Widget test: action callback invoked with correct page id/index.

## Open Design Questions

- Should chrome be part of `VersePageRenderer` instead of `VersePageView`?
- Should we provide a default chrome widget, or only slots?

