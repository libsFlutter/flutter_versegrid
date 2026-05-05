# Requirements: page-level-reader

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

`flutter_versegrid` currently exposes low-level building blocks (`VersePassage`, range chips, verse number grid),
but host apps still need to re-implement a **page-level reader surface**:

- page composition from heterogeneous blocks (verses, paragraphs, links, custom blocks)
- swipe navigation between pages
- simple, reusable page transitions
- search term highlighting inside rendered text

Without a shared page-level API, each app rebuilds the same reader scaffolding and drifts in behavior.

## User Stories

### Primary

**As a** reader app developer  
**I want** to render a page as a list of ordered blocks  
**So that** I can compose legacy-like pages from verses, prose, and links

**As a** reader  
**I want** to swipe between pages  
**So that** navigation feels natural and fast

**As a** reader  
**I want** search results to highlight the matched word(s)  
**So that** I can scan the page and find the match instantly

### Secondary

**As a** developer  
**I want** to plug in custom blocks and custom link visuals  
**So that** apps can extend the renderer without forking the package

## Acceptance Criteria

### Must Have

1. **Given** a `VersePage` with blocks  
   **When** rendered  
   **Then** blocks are shown in order in a vertical layout.

2. **Given** a list of pages  
   **When** displayed via a reader widget  
   **Then** the user can swipe between pages.

3. **Given** a transition preset  
   **When** swiping pages  
   **Then** the current/adjacent pages are transitioned consistently.

4. **Given** a highlight query  
   **When** a passage/paragraph is rendered  
   **Then** all occurrences are highlighted.

5. **Given** a page-link block  
   **When** tapped  
   **Then** the widget calls back with the target page id.

### Should Have

- Page-level semantics labels (optional).
- Custom builders for page links and custom blocks.

### Won't Have (This Iteration)

- Legacy XML parsing and book domain model
- Search indexing / query execution (only rendering + highlighting)
- Audio player UI

## Constraints

- **Flutter**: pure Dart/Flutter (no platform channels).
- **Theming**: must respect host app theme; no hardcoded palettes.
- **Performance**: must handle typical books smoothly (hundreds of pages).

## References

- `VersePassage` for verse/translation layout
- Legacy iOS reader scaffold: `gitanjali/legacy/legacy-gitanjali-en-swift/.../BUIMainViewController.*`

