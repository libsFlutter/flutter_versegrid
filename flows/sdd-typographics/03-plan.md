# Implementation Plan: typographics SDD

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-06  
> Specifications: [02-specifications.md](./02-specifications.md)

## Summary

Extract typography / `VerseGridTheme` documentation into `flows/sdd-typographics/` and deduplicate `sdd-color-palette` specifications. No API change required for this documentation milestone.

## Task Breakdown

### Task 1: SDD artifacts

- **Files**: `flows/sdd-typographics/*` (create)
- **Verification**: Links readable from repo root; `_status.md` complete

### Task 2: Cross-links

- **Files**: `flows/sdd-color-palette/02-specifications.md` (trim duplicated `VerseGridTheme` prose; add pointer here)

### Task 3 (optional follow-up)

- Golden / screenshot tests for `VersePassage` with host themes
- Evaluate optional `TextStyle` slots on `VerseGridTheme` (see requirements open question)

## File Change Summary

| File | Action |
|------|--------|
| `flows/sdd-typographics/*` | Create |
| `flows/sdd-color-palette/02-specifications.md` | Replace typography subsection with reference |
