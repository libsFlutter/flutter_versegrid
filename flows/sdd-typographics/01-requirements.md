# Requirements: typographics (verse passages)

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-06

## Problem Statement

Multiple reader apps (Gitanjali, Bhagavad Gita, cookbook-style paragraphs) need a **shared layout rhythm** for “original + translation” blocks without copying magic numbers. Typography must stay **host-controlled** (fonts, scripts, accessibility policies) while the package supplies **consistent spacing defaults** and optional theme extension hooks.

Legacy native readers used WebKit (`font: Npx Family`) or platform text; Flutter cannot guarantee pixel-identical metrics without dedicated parity work—requirements focus on **documented defaults** and clear override paths.

## User Stories

### Primary

**As a** maintainer of `flutter_versegrid`  
**I want** a documented `ThemeExtension` for passage gutters and default sizes  
**So that** integrators align vertically without forking widget internals

**As a** host app developer  
**I want** to pass explicit `TextStyle` for primary/secondary lines  
**So that** Devanagari, Latin, and brand fonts stay under app control

### Secondary

**As a** reader on large text settings  
**I want** `textScaleFactor` (or system text scale) to affect passage sizes predictably  
**So that** accessibility sizing remains coherent

## Acceptance Criteria

### Must Have

1. **Given** no explicit `primaryStyle` / `secondaryStyle` on `VersePassage`  
   **When** the widget builds  
   **Then** it resolves sizes using `Theme.textTheme` augmented by `VerseGridTheme` default font sizes from `Theme.of(context).extension<VerseGridTheme>()`.

2. **Given** explicit `TextStyle` on `VersePassage`  
   **When** the widget builds  
   **Then** those styles take precedence for family/weight/color; `textScaleFactor` still scales resolved font sizes.

3. **Given** `VersePassageLayout.tabletRow`  
   **When** `verseNumber` is non-null  
   **Then** side columns use `VerseGridTheme.verseNumberColumnWidth` and verse number style defaults.

4. **Given** this SDD  
   **When** a developer reads `sdd-color-palette`  
   **Then** verse typography parameters are **not** duplicated there—only a pointer to this flow.

### Should Have

1. Host apps document their chosen font bundles (family names matching `pubspec` declarations).

### Won’t Have (this SDD)

- Mandating a single global font family inside the package.
- Pixel-perfect reproduction of legacy UIWebView text layout (separate parity project if needed).

## Constraints

- **Technical**: Flutter `ThemeExtension`, Material 3 compatible.
- **Dependencies**: Works with or without `VerseGridColorPalette.lightTheme()` (palette SDD is orthogonal).

## Open Questions

- [ ] Whether to add optional `TextStyle?` slots on `VerseGridTheme` for hosts that prefer centralized tokens vs per-call overrides.

## References

- Package: `lib/src/theme/verse_grid_theme.dart`, `lib/src/widgets/verse_passage.dart`
- Host examples: Gitanjali `AppTheme` + `verse_block.dart`; Bhagavad Gita `AppText` + `VersePassage`

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
