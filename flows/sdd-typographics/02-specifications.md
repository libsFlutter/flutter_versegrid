# Specifications: typographics (verse passages)

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-06  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

Canonical documentation for **`VerseGridTheme`** (layout rhythm + default numeric type sizes) and how **`VersePassage`** combines theme + explicit `TextStyle` overrides.

Color roles and palette hex live in [`../sdd-color-palette/02-specifications.md`](../sdd-color-palette/02-specifications.md).

## Component: `VerseGridTheme`

Implemented as `ThemeExtension<VerseGridTheme>` in `lib/src/theme/verse_grid_theme.dart`.

### Layout / rhythm parameters

| Property | Default | Role |
|----------|---------|------|
| `verseNumberColumnWidth` | `40` | Width of left (and balancing right gutter) column for `VersePassageLayout.tabletRow` |
| `rowVerticalPadding` | `12` | Total vertical padding budget for row layout (half applied top/bottom symmetrically) |
| `columnVerticalPadding` | `9` | Same for compact column layouts |
| `gapOriginalToTranslation` | `16` | Gap between primary and secondary in **tabletRow** |
| `gapOriginalToTranslationCompact` | `8` | Gap between primary and secondary in **column** layouts |

### Default font sizes (logical px)

Used only when the corresponding `TextStyle` does not carry an explicit `fontSize` (see resolution order below).

| Property | Default | Applies to |
|----------|---------|------------|
| `defaultOriginalFontSize` | `16` | Primary line fallback |
| `defaultTranslationFontSize` | `15` | Secondary line fallback |
| `defaultVerseNumberFontSize` | `12` | Verse index in tablet row fallback |

### API surface

| Method | Behavior |
|--------|----------|
| `VerseGridTheme.of(context)` | `Theme.extension` or `const VerseGridTheme()` |
| `copyWith` | Partial updates |
| `lerp` | Theme animation between two extensions |

Hosts register via `ThemeData.extensions: [ VerseGridTheme(...) ]` (see Gitanjali `AppTheme`).

## Component: `VersePassage`

`VersePassageLayout`:

| Layout | Typical use |
|--------|-------------|
| `tabletRow` | Number column + centered stack (Gitanjali tablet-style) |
| `columnCenter` | Phone / centered stanza |
| `columnStretch` | Prose translation / commentary blocks (Bhagavad Gita sections) |

### Style resolution order

1. If `primaryStyle` / `secondaryStyle` / `verseNumberStyle` is non-null, start from that `TextStyle`.
2. Else derive from `Theme.of(context).textTheme` (`bodyLarge` / `bodyMedium` / `labelMedium`) with sensible weight/color hints.
3. Apply `VerseGridTheme` default **fontSize** only where the resolved style has no `fontSize`.
4. Multiply effective font sizes by `textScaleFactor`.

### Host font ownership

- **Family**, **weight**, **feature flags** (e.g. Devanagari fallbacks) are supplied by the host via explicit `TextStyle` or app-wide `ThemeData.fontFamily`.
- The package does **not** ship font binaries.

## Integration patterns (reference hosts)

| Host | Pattern |
|------|---------|
| **Gitanjali** | `VerseGridTheme` mirrors `AppSpacing` / `AppLayout`; `VerseBlock` passes `AppTypography.*` into `VersePassage` |
| **Bhagavad Gita** | `AppText.sanskrit()`, `AppText.body()`, etc. passed as `primaryStyle` / `secondaryStyle` |
| **Cookbook** | Pairs `verse_original` / `verse_translation` paragraphs → `VersePassage` with styles from `ParagraphStyle` |

## Navigation chips

`VerseRangeChipStrip` does **not** fix typography: hosts implement `chipBuilder` (e.g. `ChoiceChip` + `AppText.label`). Accessibility labels are documented in [`../vdd-verse-grid/03-specifications.md`](../vdd-verse-grid/03-specifications.md) and `VerseRange.semanticsLabel`.

## Testing strategy

- Unit: grouping utilities (`group_consecutive`) remain separate SDD; typography-focused tests optional:
  - Widget smoke: `VersePassage` pumps with/without extension.
  - Future: golden tests per host theme (Should Have).

## Migration

- Consumers of older docs: typography tables removed from `sdd-color-palette` specifications—use this flow instead.
