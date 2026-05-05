# Implementation Plan: page-style-registry

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Specifications: `02-specifications.md`

## Summary

Introduce paragraph style keys and a host-provided style resolver (theme/callback) so `VersePageRenderer` can reproduce legacy-like paragraph styling without embedding app-specific design tokens into `flutter_versegrid`.

## Task Breakdown

### Phase 1: API + Models

#### Task 1.1: Extend paragraph block
- **Description**: Add `styleKey` and optional `textAlign` to `VerseParagraphBlock` with backwards compatibility.
- **Files**:
  - `flutter_versegrid/lib/src/models/verse_page_block.dart` - Modify
- **Verification**: `flutter test`
- **Complexity**: Low

#### Task 1.2: Add paragraph style types
- **Description**: Add `VerseParagraphStyle` + resolver typedef and decide theme vs callback plumbing.
- **Files**:
  - `flutter_versegrid/lib/src/theme/...` - Create/Modify
  - `flutter_versegrid/lib/flutter_versegrid.dart` - Modify (export)
- **Verification**: `flutter test`
- **Complexity**: Medium

### Phase 2: Renderer Integration

#### Task 2.1: Resolve and apply styles in renderer
- **Description**: Teach `VersePageRenderer` to resolve and apply paragraph style + alignment + optional decoration/padding.
- **Files**:
  - `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart` - Modify
- **Dependencies**: Phase 1
- **Verification**: `flutter test`
- **Complexity**: Medium

### Phase 3: Tests

#### Task 3.1: Add tests for precedence + fallback
- **Description**: Add unit/widget tests for style resolution, alignment precedence, and highlight compatibility.
- **Files**:
  - `flutter_versegrid/test/...` - Create/Modify
- **Dependencies**: Phase 2
- **Verification**: `flutter test`
- **Complexity**: Medium

### Phase 4: Docs

#### Task 4.1: Document host integration
- **Description**: Add usage snippet showing style registry wiring and paragraph blocks using `styleKey`.
- **Files**:
  - `flutter_versegrid/README.md` - Modify
- **Dependencies**: Phase 3
- **Verification**: Example compiles
- **Complexity**: Low

## Dependency Graph

```
Task 1.1 → Task 1.2 → Task 2.1 → Task 3.1 → Task 4.1
```

