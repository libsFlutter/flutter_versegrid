# Requirements: Verse Number Grid (legacy parity)

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

`flutter_versegrid` currently provides:

- verse body presentation (`VersePassage`)
- range navigation (`VerseRangeChipStrip`) built on `VerseRange<T>` with grouping helpers (`groupConsecutiveByPosition`, `groupConsecutiveRuns`)

Legacy `bhagavadgita.book` apps (Swift + Java) also had a **chapter verse map** as a **fixed 7-column grid** (one cell per verse) with:

- current verse **selection** highlight
- per-verse **bookmark** badge
- predictable collapsed height (cap rows; optional internal scroll if there are more verses)

Without a shared widget, each app re-implements this pattern, drifting in spacing, sizing, accessibility, and selection behavior.

## User Stories

### Primary

**As a** reader  
**I want** a compact fixed-grid list of verse numbers for a chapter  
**So that** I can jump directly to any verse quickly

**As a** reader  
**I want** the currently open verse to be visually highlighted in that grid  
**So that** I can orient myself within the chapter at a glance

### Secondary

**As a** reader  
**I want** bookmarked verses to show a small indicator on their number cell  
**So that** I can quickly spot saved verses

**As a** developer of multiple verse apps  
**I want** a reusable, theme-friendly widget in `flutter_versegrid`  
**So that** I can use it consistently across apps without copy/paste

## Acceptance Criteria

### Must Have

1. **Given** a list of verse items with labels  
   **When** the grid is rendered  
   **Then** it uses a **fixed column count** (default 7) with square-ish cells that adapt to available width.

2. **Given** a selected verse id/value  
   **When** the grid is rendered  
   **Then** exactly one corresponding cell can be shown in a **selected** visual state (or none if selection is null).

3. **Given** an item marked bookmarked  
   **When** the grid is rendered  
   **Then** a **bookmark indicator** can be displayed for that item.

4. **Given** a maximum row count (default 4)  
   **When** the number of items exceeds `columns * maxRows`  
   **Then** the grid height stays capped to `maxRows` and overflow is handled (scrolling inside the grid is allowed by default).

5. **Given** the user taps a cell  
   **When** the tap occurs  
   **Then** the widget calls `onTap` with the tapped item.

6. **Given** items with semantics labels  
   **When** the grid is rendered  
   **Then** each cell exposes an accessibility label and button semantics.

### Should Have

1. Custom rendering hooks so host apps can provide their own Material 3 visuals (colors, shape, typography) while keeping the layout + sizing logic shared.

2. An option to disable internal scrolling and instead let the parent expand (for surfaces where height is not constrained).

### Won't Have (This Iteration)

- Range grouping logic (already handled by UVGF flow + `VerseRange` helpers).
- Persistent bookmark storage / selected verse storage (owned by host app).
- Per-app navigation logic (only provides callbacks).

## Constraints

- **Flutter**: Must be pure Dart/Flutter (no platform channels).
- **Performance**: Should handle typical chapter sizes (<= ~100 verses) smoothly.
- **Theming**: Should work under any `ThemeData` without requiring package-specific colors.

## Open Questions

- [ ] Default scroll behavior on overflow: scrollable vs clipped vs expanded (default proposed: scrollable).
- [ ] Default visuals: ship a minimal default cell, but prefer `itemBuilder`/`cellBuilder` to keep app palette authority.

## References

- `flows/vdd-verse-grid/*` (range-chip model and grouping rules)
- Legacy Swift: `legacy_bhagavadgita.book_swift/Gita/Views/ShlokaChapterContentsTableViewCell.swift`
- Legacy Java: `legacy_bhagavadgita.book_java/.../adapters/holders/ChapterHolder.java` (nested grid)

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:

