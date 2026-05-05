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

## Legacy Additions - VerseGridTheme Details
> Added by /legacy on 2026-05-05

- **VerseGridTheme**: Реализован как `ThemeExtension<VerseGridTheme>`.
- **Параметры разметки**:
  - `verseNumberColumnWidth` (дефолт: 40): Ширина боковой колонки для номеров стихов.
  - `rowVerticalPadding` (дефолт: 12): Вертикальный отступ для строчного макета.
  - `columnVerticalPadding` (дефолт: 9): Вертикальный отступ для компактного макета в колонку.
  - `gapOriginalToTranslation` (дефолт: 16): Расстояние между оригиналом и переводом в строчном макете.
  - `gapOriginalToTranslationCompact` (дефолт: 8): Расстояние между оригиналом и переводом в компактном макете.
- **Шрифты**:
  - `defaultOriginalFontSize` (дефолт: 16)
  - `defaultTranslationFontSize` (дефолт: 15)
  - `defaultVerseNumberFontSize` (дефолт: 12)
- **Методы**:
  - `of(context)`: Статический метод для получения темы из контекста.
  - `copyWith`: Поддержка частичного обновления свойств.
  - `lerp`: Плавная интерполяция между состояниями темы.

## Testing Strategy
...
- Unit test: each `Color` equals `Color(0xFF……)`.
- Unit test: `lightTheme().extensions[VerseGridTheme]` non-null.

## Migration / Rollout

Hosts that relied on example’s purple seed should switch explicitly if they want the new default; library consumers opt in via `VerseGridColorPalette.lightTheme()` or raw constants.
