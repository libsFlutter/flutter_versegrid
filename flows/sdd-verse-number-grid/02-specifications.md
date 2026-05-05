# Specifications: Verse Number Grid (legacy parity)

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: `01-requirements.md`

## Overview

Add a reusable `VerseNumberGrid` widget to `flutter_versegrid` that renders a fixed-column grid of verse-number cells with:

- predictable sizing (square-ish cells)
- optional selection state
- optional bookmark indicator per cell
- capped height via `maxRows` with optional internal scrolling on overflow
- accessibility labels per cell

The widget intentionally delegates colors/shape/typography to the host app via a `cellBuilder`, similar to `VerseRangeChipStrip`.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `flutter_versegrid/lib/src/widgets/` | Create | New widget `verse_number_grid.dart` |
| `flutter_versegrid/lib/flutter_versegrid.dart` | Modify | Export new widget + item model |
| `flutter_versegrid/test/` | Create | Widget/layout tests for sizing + overflow behavior |
| `flows/sdd-verse-number-grid/*` | Create | This SDD flow |

## Architecture

### Component Diagram

```
Host app data (Sloka list / bookmarks / selected)
        |
        v
build List<VerseNumberGridItem<T>>
        |
        v
VerseNumberGrid<T>
  - computes itemSize & cappedHeight from LayoutBuilder
  - renders GridView.builder inside SizedBox(height)
  - wraps cells in Semantics (optional)
        |
        v
host-provided cellBuilder(context, item, selected, size, onTap) -> Widget
```

### Data Flow

```
items + selectionPredicate -> selected bool per item
items + maxRows + columns + width -> itemSize + visibleRows -> height
overflow? -> choose scroll physics
tap -> onItemTap(item)
```

## Interfaces

### New Data Model

```dart
class VerseNumberGridItem<T> {
  const VerseNumberGridItem({
    required this.value,
    required this.label,
    this.bookmarked = false,
    this.semanticsLabel,
  });

  final T value;
  final String label;
  final bool bookmarked;
  final String? semanticsLabel;
}
```

### New Widget

```dart
class VerseNumberGrid<T> extends StatelessWidget {
  const VerseNumberGrid({
    super.key,
    required this.items,
    required this.isSelected,
    required this.onItemTap,
    required this.cellBuilder,
    this.columns = 7,
    this.maxRows = 4,
    this.spacing = 2,
    this.runSpacing = 2,
    this.padding = EdgeInsets.zero,
    this.scrollWhenOverflow = true,
  });
}
```

#### `cellBuilder` contract

- Input: `(context, item, selected, size, onTap)`.
- Output: one cell widget sized to `size x size` (caller may ignore and use `SizedBox.expand`).

## Behavior Specifications

### Layout & sizing

- Uses a `LayoutBuilder` to get available width \(W\).
- Compute `itemSize` as:

\[
itemSize = \frac{W - paddingHorizontal - (columns - 1)\cdot spacing}{columns}
\]

- `rowsNeeded = ceil(items.length / columns)`
- `visibleRows = min(rowsNeeded, maxRows)` (if `maxRows` is non-null; otherwise `visibleRows = rowsNeeded`)
- `gridHeight = visibleRows*itemSize + (visibleRows-1)*runSpacing`
- Wrap grid in `SizedBox(height: gridHeight)` when `maxRows` is set.

### Overflow handling

- If `rowsNeeded > visibleRows`:
  - when `scrollWhenOverflow == true`: grid is vertically scrollable within `gridHeight`
  - else: grid is not scrollable (items beyond visible rows will be unreachable; intended for strict compact mode)

### Selection

- `selected = isSelected(item)`; host app decides how to map selected verse id to items.
- No internal single-selection state is stored (stateless widget).

### Tap

- `onItemTap(item)` is called exactly once per user tap.

### Accessibility

- Each cell is wrapped in `Semantics(button: true, label: item.semanticsLabel ?? item.label)`.
- Host app may include chapter context in `semanticsLabel`.

## Testing Strategy

### Unit / widget tests

- [ ] Size math: for a given width + columns + spacing, the computed height matches expected.
- [ ] Overflow: when items exceed `columns*maxRows`, grid has capped height and scroll physics enabled when `scrollWhenOverflow`.
- [ ] Tap: tapping a cell triggers callback with correct item.
- [ ] Semantics: presence of button semantics and label.

## Migration / Rollout

- Add widget to `flutter_versegrid` without breaking changes.
- Host apps can incrementally adopt it on contents screens where fixed grid is preferred over range chips.

## Open Design Questions

- [ ] Should we ship a default Material cell implementation (with a tiny bookmark dot) as an optional helper widget, or keep this entirely app-owned via `cellBuilder`?

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:

