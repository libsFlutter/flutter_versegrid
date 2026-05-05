# Status: sdd-typographics

## Current Phase

DOCUMENTATION

## Phase Status

DRAFT (SDD extracted; host parity validation ongoing)

## Last Updated

2026-05-06

## Blockers

- None

## Progress

- [x] Requirements drafted
- [x] Specifications drafted (canonical home for `VerseGridTheme` + passage typography)
- [x] Plan drafted
- [x] Cross-reference from `sdd-color-palette` specifications
- [ ] Requirements approved (product)
- [ ] Optional: golden tests per host theme

## Context Notes

- **Ownership**: Typography for verse bodies lives in **`VersePassage`** + **`VerseGridTheme`** (`ThemeExtension`). Font **families** are intentionally owned by host apps (bundled assets / `google_fonts`), not mandated by the package.
- **Fork**: Detailed `VerseGridTheme` parameter list was previously embedded under `flows/sdd-color-palette/02-specifications.md`; it now belongs here.

## References

- [01-requirements.md](./01-requirements.md)
- [02-specifications.md](./02-specifications.md)
- [vdd-verse-grid](../vdd-verse-grid/README.md) — chips / navigation (semantics cross-links)
