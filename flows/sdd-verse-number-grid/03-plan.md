# Implementation Plan: Verse Number Grid (legacy parity)

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Specifications: `02-specifications.md`

## Summary

Implement a new reusable `VerseNumberGrid` widget in `flutter_versegrid` that provides the missing legacy fixed-grid verse navigation surface (7 columns, selection, bookmark indicator hook, max-rows cap with internal scroll).

## Task Breakdown

### Phase 1: Foundations

#### Task 1.1: Add public types and exports
- **Description**: Add `VerseNumberGridItem<T>` and export it + widget from package entrypoint.
- **Files**:
  - `flutter_versegrid/lib/src/models/verse_number_grid_item.dart` - Create
  - `flutter_versegrid/lib/src/widgets/verse_number_grid.dart` - Create
  - `flutter_versegrid/lib/flutter_versegrid.dart` - Modify (export)
- **Dependencies**: None
- **Verification**: `dart analyze` (host repo), example app compiles
- **Complexity**: Medium

### Phase 2: Core Implementation

#### Task 2.1: Implement sizing + capped height logic
- **Description**: Use `LayoutBuilder` + `GridView.builder` in a `SizedBox` with computed height. Support `maxRows == null` as "no cap".
- **Files**:
  - `flutter_versegrid/lib/src/widgets/verse_number_grid.dart` - Modify
- **Dependencies**: Task 1.1
- **Verification**: Widget tests for height and overflow behavior
- **Complexity**: Medium

#### Task 2.2: Semantics + interaction
- **Description**: Wrap each cell in `Semantics(button: true, label: ...)` and provide `onTap` callback to builder.
- **Files**:
  - `flutter_versegrid/lib/src/widgets/verse_number_grid.dart` - Modify
- **Dependencies**: Task 2.1
- **Verification**: Semantics test; tap test
- **Complexity**: Low

### Phase 3: Tests

#### Task 3.1: Add widget tests
- **Description**: Test sizing, overflow scroll physics, tap callback, and semantics label.
- **Files**:
  - `flutter_versegrid/test/verse_number_grid_test.dart` - Create
- **Dependencies**: Phase 2
- **Verification**: `flutter test` in `flutter_versegrid`
- **Complexity**: Medium

### Phase 4: Documentation

#### Task 4.1: Add README snippet
- **Description**: Add usage example in `flutter_versegrid/README.md` for `VerseNumberGrid`.
- **Files**:
  - `flutter_versegrid/README.md` - Modify
- **Dependencies**: Phase 1–3
- **Verification**: README example compiles in example app (optional)
- **Complexity**: Low

## Dependency Graph

```
Task 1.1 → Task 2.1 → Task 2.2 → Task 3.1 → Task 4.1
```

## File Change Summary

| File | Action | Reason |
|------|--------|--------|
| `flutter_versegrid/lib/src/models/verse_number_grid_item.dart` | Create | Public item model for grid cells |
| `flutter_versegrid/lib/src/widgets/verse_number_grid.dart` | Create | New reusable widget |
| `flutter_versegrid/lib/flutter_versegrid.dart` | Modify | Export new API |
| `flutter_versegrid/test/verse_number_grid_test.dart` | Create | Prevent regressions |
| `flutter_versegrid/README.md` | Modify | Make feature discoverable |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Height math differs from app expectations | Med | Med | Tests + clear parameters (`spacing`, `runSpacing`, `padding`) |
| Scroll behavior surprises consumers | Med | Low | `scrollWhenOverflow` flag, docs |
| API too rigid for theming | Low | Med | Keep `cellBuilder` flexible and avoid hardcoded colors |

## Rollback Strategy

- If consumers dislike the API, keep it behind a minor-version bump and mark as experimental (doc-only) before any broad adoption.

## Open Implementation Questions

- [ ] Do we want a default `VerseNumberGridCell` helper widget in this package, or keep that in each host app?

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:

