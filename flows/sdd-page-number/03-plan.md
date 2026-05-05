# Implementation Plan: page-number

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Specifications: `02-specifications.md`

## Summary

Provide an opt-in, themeable page number overlay so apps can match legacy page-number UI without re-implementing it.

## Task Breakdown

### Phase 1: API Surface

#### Task 1.1: Add page number model
- **Files**:
  - `flutter_versegrid/lib/src/models/verse_page.dart` - Modify
  - `flutter_versegrid/lib/flutter_versegrid.dart` - Modify (export)
- **Verification**: `flutter test`
- **Complexity**: Low

### Phase 2: Renderer

#### Task 2.1: Render overlay in default renderer path
- **Description**: Add an overlay layer that renders page number when configured.
- **Files**:
  - `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart` - Modify
  - (Optional) `flutter_versegrid/lib/src/widgets/verse_page_view.dart` - Modify for safe-area defaults
- **Dependencies**: Phase 1
- **Verification**: `flutter test`
- **Complexity**: Medium

### Phase 3: Tests + Docs

#### Task 3.1: Add tests
- **Files**:
  - `flutter_versegrid/test/...` - Create/Modify
- **Verification**: `flutter test`
- **Complexity**: Low

#### Task 3.2: Document usage
- **Files**:
  - `flutter_versegrid/README.md` - Modify
- **Verification**: Example compiles
- **Complexity**: Low

## Dependency Graph

```
Task 1.1 → Task 2.1 → Task 3.1 → Task 3.2
```

