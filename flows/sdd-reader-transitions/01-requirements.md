# Requirements: reader-transitions

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05

## Problem Statement

Legacy iOS reader uses a "page curl" visual transition when moving between pages. `flutter_versegrid` provides basic transitions (fade/scale), but cannot reproduce legacy curl or other custom transitions.

Apps that need legacy parity must fork or implement custom PageView transformations inconsistently.

## User Stories

### Primary

**As a** reader app developer  
**I want** to plug in a custom page transition effect  
**So that** I can match legacy (curl) or app-specific transition styles consistently

### Secondary

**As a** developer  
**I want** sane defaults and performance safeguards  
**So that** transitions stay smooth across hundreds of pages

## Acceptance Criteria

### Must Have

1. **Given** a custom transition builder  
   **When** swiping pages  
   **Then** the transition is applied consistently for current and adjacent pages.

2. **Given** no custom transition  
   **When** using `VersePageView`  
   **Then** behavior remains identical to today (existing presets).

3. **Given** a transition that depends on scroll delta  
   **When** scrolling  
   **Then** it receives enough state (index, page offset/delta) to render.

### Should Have

- Provide a built-in "curl-like" preset if feasible in pure Flutter (best-effort).

### Won't Have (This Iteration)

- Perfect 1:1 UIKit curl parity if it requires platform-specific APIs.

## Constraints

- **Flutter**: pure Dart/Flutter.
- **Performance**: effects must avoid heavy per-frame allocations.
- **API**: keep current `VersePageTransitionPreset` working.

## References

- Legacy transitions: `cookbook/legacy/legacy-cookbook-swift/Classes/Interface/BUIMainViewController.m` (`UIViewAnimationTransitionCurlUp/Down`)
- Current transitions: `flutter_versegrid/lib/src/widgets/verse_page_view.dart`

