# Requirements: page-chrome

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

Legacy reader UI includes a set of overlay controls ("chrome") such as:

- previous/next page buttons
- bookmarks list + add bookmark
- search entry point
- audio play/stop + toggle player
- page links and other tappable controls defined per page

`flutter_versegrid` intentionally focuses on content rendering, but without a shared chrome layer, host apps re-implement the same control placements, enabling/disabling rules, and state wiring.

## User Stories

### Primary

**As a** reader app developer  
**I want** an optional page-chrome layer with a small set of common control slots and callbacks  
**So that** I can share consistent UI behavior across apps without forking

### Secondary

**As a** developer  
**I want** to customize the chrome UI (replace widgets)  
**So that** each app can match its design system

## Acceptance Criteria

### Must Have

1. **Given** a `VersePageView` showing pages  
   **When** page-chrome is enabled  
   **Then** chrome widgets can be rendered on top of the page content (overlay).

2. **Given** chrome actions (prev/next, open search, open bookmarks, add bookmark, play/stop audio)  
   **When** user taps the control  
   **Then** the host app receives a callback and owns the actual business logic/navigation.

3. **Given** a page that disables a given control  
   **When** rendered  
   **Then** the control can be hidden or disabled via a consistent rule.

### Should Have

- Provide a default "minimal chrome" implementation with sensible layout.
- Support safe-area awareness.

### Won't Have (This Iteration)

- Implementing bookmarks storage, search indexing, audio playback in the package.
- A full declarative legacy control language parser.

## Constraints

- **Flutter**: pure Dart/Flutter.
- **Package boundary**: provide UI slots + callbacks; keep data stores in host app.
- **Back-compat**: chrome is opt-in; existing pages render unchanged.

## References

- Legacy controller: `cookbook/legacy/legacy-cookbook-swift/Classes/Interface/BUIMainViewController.*`
- Legacy controls: `cookbook/legacy/legacy-cookbook-swift/Classes/Interface/BUIControl.*`

