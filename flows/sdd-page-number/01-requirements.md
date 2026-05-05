# Requirements: page-number

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

Legacy pages optionally show a page number (`showNumber`, `number`) as part of the page UI. `flutter_versegrid` currently has no built-in page numbering display and only exposes `VersePage.id`.

Apps that want legacy parity re-implement a page number overlay and numbering rules, which leads to inconsistent placement and styling.

## User Stories

### Primary

**As a** reader app developer  
**I want** an opt-in way to display a page number for a page  
**So that** I can match legacy UI and keep the package usage consistent across apps

### Secondary

**As a** developer  
**I want** to control formatting and visibility (e.g. hide on cover)  
**So that** I can support multiple numbering conventions

## Acceptance Criteria

### Must Have

1. **Given** a page provides a page number payload (or host provides a formatter)  
   **When** rendered via default renderer  
   **Then** the page number can be displayed in a consistent location.

2. **Given** a page where the number is disabled  
   **When** rendered  
   **Then** no page number UI is shown.

3. **Given** a host app theme  
   **When** page number is shown  
   **Then** it uses host-provided styling (no hardcoded colors).

### Should Have

- Allow positioning preset (bottom-left, bottom-center, bottom-right).
- Allow safe-area aware padding defaults.

### Won't Have (This Iteration)

- Automatically computing page numbers from book structure (host app owns this).

## Constraints

- **Flutter**: pure Dart/Flutter.
- **Theming**: must respect host theme.
- **Back-compat**: existing usage of `VersePageRenderer` should not change by default.

## References

- Legacy model: `cookbook/legacy/legacy-cookbook-swift/Classes/Data Core/BBookPage.h` (`showNumber`, `number`)
- Legacy rendering: `cookbook/legacy/legacy-cookbook-swift/Classes/Interface/BUIPageView.m` (page number `UILabel`)
- Current renderer: `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart`

