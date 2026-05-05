# Requirements: page-background

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

Legacy cookbook pages support per-page background rendering:

- `backgroundColor`
- optional background image (file path)

`flutter_versegrid` currently renders only the page content blocks without a first-class background layer, forcing host apps to wrap every page consistently and re-implement the same logic.

## User Stories

### Primary

**As a** reader app developer  
**I want** to configure a per-page background (color and/or image)  
**So that** I can match legacy visuals and special pages (covers, separators, etc.)

### Secondary

**As a** developer  
**I want** backgrounds to be optional and efficient  
**So that** typical pages remain fast and lightweight

## Acceptance Criteria

### Must Have

1. **Given** a `VersePage` with background configuration  
   **When** rendered  
   **Then** the background is drawn behind all page blocks.

2. **Given** no background configuration  
   **When** rendered  
   **Then** rendering remains identical to current behavior.

3. **Given** an image background  
   **When** pages are swiped  
   **Then** the background does not cause jank (reasonable caching and fitting defaults).

### Should Have

- Support common fit modes (e.g. cover/contain) via a small enum.
- Allow host app to provide an `ImageProvider` rather than forcing asset/file-only.

### Won't Have (This Iteration)

- Downloading remote images.
- Complex parallax or animated backgrounds.

## Constraints

- **Flutter**: pure Dart/Flutter.
- **Theming**: must respect host app theme; no fixed palettes.
- **Performance**: avoid excessive image decoding on swipe.

## References

- Legacy model: `cookbook/legacy/legacy-cookbook-swift/Classes/Data Core/BBookPage.h` (`backgroundColor`, `backgroundImagePath`)
- Legacy rendering: `cookbook/legacy/legacy-cookbook-swift/Classes/Interface/BUIPageView.m` (background `UIImageView`)
- Current renderer: `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart`

