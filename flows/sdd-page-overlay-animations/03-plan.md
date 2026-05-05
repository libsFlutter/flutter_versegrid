# Implementation Plan: page-overlay-animations

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Specifications: `02-specifications.md`

## Summary

Add an opt-in overlay injection API to `VersePageView` so host apps can implement animated/interactive layers with lifecycle signals.

## Task Breakdown

### Phase 1: Models

#### Task 1.1: Add overlay types
- **Files**:
  - `flutter_versegrid/lib/src/models/verse_page.dart` - Modify
  - `flutter_versegrid/lib/flutter_versegrid.dart` - Modify (export)
- **Verification**: `flutter test`
- **Complexity**: Medium

### Phase 2: View integration

#### Task 2.1: Compute visibility and render overlays
- **Description**: In `VersePageView`, wrap page child with a `Stack` and render overlay widgets, updating their lifecycle state from the controller scroll position.
- **Files**:
  - `flutter_versegrid/lib/src/widgets/verse_page_view.dart` - Modify
- **Dependencies**: Phase 1
- **Verification**: `flutter test`
- **Complexity**: Medium

### Phase 3: Tests + Docs

#### Task 3.1: Add widget tests
- **Files**:
  - `flutter_versegrid/test/...` - Create/Modify
- **Verification**: `flutter test`
- **Complexity**: Medium

#### Task 3.2: Document overlay usage
- **Files**:
  - `flutter_versegrid/README.md` - Modify
- **Verification**: Example compiles
- **Complexity**: Low

## Dependency Graph

```
Task 1.1 → Task 2.1 → Task 3.1 → Task 3.2
```

