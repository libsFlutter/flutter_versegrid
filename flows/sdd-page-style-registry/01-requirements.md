# Requirements: page-style-registry

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

Legacy cookbook pages render prose with **named paragraph styles** (font family/size, text color, background, alignment) that are resolved at runtime from a style storage (e.g. `BParagraphStyle` via `BParagraphStylesStorage`) and applied during HTML generation.

`flutter_versegrid` currently renders paragraphs as plain `Text` and does not provide a first-class way to:

- attach a **style key** to a paragraph block
- resolve that key via a host-provided registry
- apply alignment and background consistently across apps

This causes each host app to reinvent style mapping and produces visual drift versus legacy.

## User Stories

### Primary

**As a** reader app developer  
**I want** to render paragraph blocks with a named style (e.g. `body`, `quote`, `title`, `comment`)  
**So that** I can reproduce legacy page typography without embedding app-specific styles into the package

**As a** designer/developer  
**I want** paragraph styles to be supplied by the host app/theme  
**So that** the package stays palette/theme-agnostic and supports multiple design systems

### Secondary

**As a** developer  
**I want** a safe fallback when a style key is missing  
**So that** content still renders without crashes

## Acceptance Criteria

### Must Have

1. **Given** a paragraph block with `styleKey`  
   **When** the page is rendered  
   **Then** the renderer requests a `TextStyle` (and related layout hints) from a host-provided resolver and applies it.

2. **Given** a paragraph block with `textAlign` and/or style-provided alignment  
   **When** the page is rendered  
   **Then** alignment matches the requested alignment (left/center/right/justify when supported).

3. **Given** a paragraph block with an unknown `styleKey`  
   **When** rendered  
   **Then** the renderer falls back to a default paragraph style without throwing.

4. **Given** a highlight query is active  
   **When** a styled paragraph is rendered  
   **Then** highlighting still works and does not break the styling.

### Should Have

- Optional per-paragraph background color/decoration support (legacy used background color at style level).
- Ability for host app to provide style resolution via Theme extension or a callback.

### Won't Have (This Iteration)

- Legacy XML parsing or style storage formats.
- A full CSS box model / HTML rendering engine.
- Rich text markup language (beyond highlight spans).

## Constraints

- **Flutter**: pure Dart/Flutter.
- **Theming**: must respect host app theme; no hardcoded palettes.
- **API Stability**: avoid breaking existing `VerseParagraphBlock` usages when adding styles.
- **Performance**: avoid per-frame expensive style lookups; keep build cheap.

## References

- Legacy iOS paragraph styling: `cookbook/legacy/legacy-cookbook-swift/Classes/Interface/BUIPageView.m` (`_generateHTMLStringForPage`)
- Legacy styles: `cookbook/legacy/legacy-cookbook-swift/Classes/Data Core/BParagraphStyle.*`, `BParagraphStylesStorage.*`
- Current renderer: `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart`

