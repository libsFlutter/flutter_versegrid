# Requirements: color-palette

> Version: 1.0  
> Status: APPROVED  
> Last Updated: 2026-05-05

## Problem Statement

The package example used an arbitrary seed color (`Colors.deepPurple`) instead of the product palette. Integrators need a documented default that matches the approved HRISHIKESH SWAMI colors.

## User Stories

### Primary

**As a** consumer of `flutter_versegrid`  
**I want** a named default color palette and ready-made light theme  
**So that** verse UI matches the design PDF without re-entering hex values

### Secondary

**As a** maintainer  
**I want** SDD traceability from PDF tokens to code  
**So that** future theme tweaks stay aligned with design intent

## Acceptance Criteria

### Must Have

1. **Given** the PDF palette hex values  
   **When** the package exports palette constants  
   **Then** each hex matches exactly (with `0xFF` alpha).

2. **Given** an app uses `VerseGridColorPalette.lightTheme()`  
   **When** Material widgets render  
   **Then** primary/secondary/surface roles map to forest and gold tones from the PDF.

3. **Given** the example app  
   **When** it builds  
   **Then** it applies the default palette theme (not `deepPurple`).

## Constraints

- **Technical**: Flutter Material 3 `ThemeData` / `ColorScheme`; keep optional `VerseGridTheme` extension.

## Source Palette (authoritative)

From «Цветовая палитра — HRISHIKESH SWAMI»:

| Token (code name) | Hex |
|-------------------|-----|
| Forest | `3A5A40` |
| Forest mid | `38573D` |
| Forest deep | `304B35` |
| Gold bright | `EEB844` |
| Gold | `EAA81C` |
| Gold deep | `CD9213` |
| Paper | `FFFFFF` |
| Ink | `343A40` |
| Black | `000000` |

## References

- Local PDF: `Цветовая палитра — HRISHIKESH SWAMI.pdf`
