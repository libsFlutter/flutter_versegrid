# Status: sdd-verse-number-grid

## Current Phase

SPECIFICATIONS

## Phase Status

DRAFTING

## Last Updated

2026-05-05 by GPT-5.2 (Cursor)

## Blockers

- None

## Progress

- [x] Requirements drafted
- [ ] Requirements approved
- [x] Specifications drafted
- [ ] Specifications approved
- [ ] Plan drafted
- [ ] Plan approved
- [x] Plan drafted
- [x] Implementation started
- [x] Implementation complete
- [x] Documentation drafted
- [ ] Documentation approved

## Context Notes

- `flutter_versegrid` already standardizes **range chips** (`VerseRangeChipStrip`) and grouping (`groupConsecutiveByPosition`), but legacy apps also used a **fixed 7-column verse-number grid** (one cell per verse) with: selection highlight, per-verse bookmark badge, and a predictable collapsed height (cap rows with internal scroll when overflow).
- This SDD adds a reusable widget to cover that missing legacy functionality for all apps, not just `bhagavadgita.book`.

## Next Actions

1. Wire `VerseNumberGrid` into at least one host app surface (follow-up outside this package).
2. If needed, add an optional helper `DefaultVerseNumberGridCell` (only if multiple apps converge on the same visuals).

