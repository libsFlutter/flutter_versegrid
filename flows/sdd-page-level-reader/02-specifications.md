# Specifications: page-level-reader

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

This flow introduces a minimal **page composition** model and reusable widgets:

- `VersePage` / `VersePageBlock` for describing page content
- `VersePageRenderer` for rendering blocks into a vertical layout
- `VersePageView` for swipe navigation + simple transition presets
- `HighlightedText` and `VersePassage` highlighting integration for search UX

## Public API

### Models

- `VersePage`
  - `id: String`
  - `blocks: List<VersePageBlock>`
  - `semanticsLabel?: String`

- `VersePageBlock` (sealed)
  - `VerseParagraphBlock(text, semanticsLabel?)`
  - `VersePassageBlock(primary, secondary?, verseNumber?, semanticsLabel?)`
  - `VersePageLinkBlock(targetPageId, label, semanticsLabel?)`
  - `VerseCustomBlock<T>(payload, semanticsLabel?)`

### Widgets

- `HighlightedText`
  - `text`, `query`
  - optional: `style`, `highlightStyle`, `caseSensitive`

- `VersePageRenderer`
  - renders blocks as a `Column` with spacing
  - forwards highlight params to `VersePassage`
  - `onPageLinkTap(String targetPageId)`
  - optional overrides:
    - `pageLinkBuilder(...)` for custom link UI
    - `customBlockBuilder` for `VerseCustomBlock`

- `VersePageView`
  - `pages`, `initialPage`, `onPageChanged`
  - `transitionPreset`: `none | fade | scale | fadeAndScale`
  - `rendererBuilder` override for advanced apps
  - forwards highlight + `onPageLinkTap`

## Rendering Rules

- Blocks are rendered strictly in order.
- Empty highlight query means "no highlighting" (renders normal `Text`).
- Page transitions affect only non-focused pages and are purely visual (no impact on hit-testing besides opacity).
- Link blocks are tappable only if `onPageLinkTap` is provided.

## Testing Strategy

- Widget tests:
  - `HighlightedText` highlights all occurrences
  - `VersePageView` calls `onPageChanged` and renders pages

