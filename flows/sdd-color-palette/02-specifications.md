# Specifications: color-palette

> Version: 1.0  
> Status: APPROVED  
> Last Updated: 2026-05-05  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

Add `VerseGridColorPalette` in `lib/src/theme/` with static `Color` constants for every PDF hex and helpers:

- `lightColorScheme` — `ColorScheme.light(...)` with semantic mapping.
- `lightTheme({ VerseGridTheme verseGridExtension })` — `ThemeData(useMaterial3: true, ...)` including existing `VerseGridTheme` extension.

Export the library from `lib/flutter_versegrid.dart`.

## Semantic mapping (light)

| Role | Source token |
|------|----------------|
| primary | Forest `3A5A40` |
| primaryContainer | Forest mid `38573D` |
| secondary | Gold `EAA81C` |
| secondaryContainer | Gold bright `EEB844` |
| tertiary | Gold deep `CD9213` |
| surface | Paper `FFFFFF` |
| onSurface | Ink `343A40` |
| onPrimary / onPrimaryContainer | Paper |
| onSecondary / onSecondaryContainer | Ink |
| onTertiary | Paper |
| outline | Forest deep `304B35` |
| outlineVariant | Forest mid at reduced opacity over paper |
| error | Material default red (`B3261E`) — not in PDF |

## Affected Systems

| System | Impact |
|--------|--------|
| `flutter_versegrid` lib | New file + export |
| `example/` | `theme:` uses `VerseGridColorPalette.lightTheme()` |
| Tests | Assert hex values + extension registration |

## Testing Strategy

- Unit test: each `Color` equals `Color(0xFF……)`.
- Unit test: `lightTheme().extensions[VerseGridTheme]` non-null.

## Migration / Rollout

Hosts that relied on example’s purple seed should switch explicitly if they want the new default; library consumers opt in via `VerseGridColorPalette.lightTheme()` or raw constants.
