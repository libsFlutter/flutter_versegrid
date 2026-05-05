# Implementation Plan: page-chrome

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Specifications: `02-specifications.md`

## Summary

Provide an opt-in overlay chrome builder for `VersePageView` so apps can share consistent reader controls while keeping business logic in the host app.

## Task Breakdown

### Phase 1: API + Models

#### Task 1.1: Add chrome action types
- **Files**:
  - `flutter_versegrid/lib/src/widgets/...` - Create/Modify
  - `flutter_versegrid/lib/flutter_versegrid.dart` - Modify (export)
- **Verification**: `flutter test`
- **Complexity**: Low

#### Task 1.2: Add optional per-page chrome hints
- **Files**:
  - `flutter_versegrid/lib/src/models/verse_page.dart` - Modify
- **Verification**: `flutter test`
- **Complexity**: Low

### Phase 2: `VersePageView` integration

#### Task 2.1: Add `chromeBuilder` to `VersePageView`
- **Description**: Render chrome in a `Stack` above page content and expose action callback.
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

#### Task 3.2: Document usage
- **Files**:
  - `flutter_versegrid/README.md` - Modify
- **Verification**: Example compiles
- **Complexity**: Low

## Dependency Graph

```
Task 1.1 → Task 1.2 → Task 2.1 → Task 3.1 → Task 3.2
```

