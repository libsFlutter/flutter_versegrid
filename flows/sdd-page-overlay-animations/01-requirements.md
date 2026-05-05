# Requirements: page-overlay-animations

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

Legacy cookbook supports page-level overlay animations (images/video/keyframes) that play on top of the page background and behind/around content. This enables "alive" pages and interactive elements.

`flutter_versegrid` currently renders static blocks only. Host apps have no shared way to attach and synchronize overlay animations with page lifecycle (enter/exit, swipe, visible/invisible).

## User Stories

### Primary

**As a** reader app developer  
**I want** to attach optional overlay layers to a page with lifecycle hooks (start/stop)  
**So that** I can reproduce animated pages without forking the reader surface

### Secondary

**As a** developer  
**I want** animation support to be incremental and extensible  
**So that** apps can plug in their own animation implementations

## Acceptance Criteria

### Must Have

1. **Given** a `VersePage` with one or more overlay layers  
   **When** rendered  
   **Then** overlays are displayed in a predictable z-order relative to background and content.

2. **Given** a page becomes visible/invisible during swipe navigation  
   **When** visibility changes  
   **Then** overlays receive lifecycle signals (e.g., `onStart`, `onStop`) so animations can pause/resume.

3. **Given** an app that does not use overlays  
   **When** rendering pages  
   **Then** there is no behavior or performance regression.

### Should Have

- Provide a generic extension point (`overlayBuilder`) instead of baking a full legacy animation engine.
- Allow per-overlay hit testing (optional), for interactive layers.

### Won't Have (This Iteration)

- Porting legacy `BAnimation`/`BUIAnimationView` data structures directly.
- Video playback or platform-channel based media.

## Constraints

- **Flutter**: pure Dart/Flutter (no platform channels for this iteration).
- **Performance**: overlays should not cause jank while swiping.
- **API design**: keep overlay API small; most apps won’t need it.

## References

- Legacy animation view: `cookbook/legacy/legacy-cookbook-swift/Classes/Interface/BUIAnimationView.*`
- Legacy animation models: `cookbook/legacy/legacy-cookbook-swift/Classes/Data Core/Animations/*`
- Current page-level reader: `flutter_versegrid/lib/src/widgets/verse_page_view.dart`

