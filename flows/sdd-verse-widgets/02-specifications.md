# Specifications: verse-widgets

> Version: 1.0  
> Status: DRAFT (Legacy)  
> Last Updated: 2026-05-05  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview
Виджеты для отображения и навигации по стихам.

## Components

### VersePassage
Отображает основную строку текста (`primary`) и опциональную второстепенную (`secondary`, перевод).

- **Макеты (`VersePassageLayout`)**:
  - `tabletRow`: Номер стиха слева, текст по центру, отступ справа (для планшетов).
  - `columnCenter`: Текст и перевод один под другим, выравнивание по центру.
  - `columnStretch`: Выравнивание по ширине (для длинной прозы).
- **Стилизация**: Использует `VerseGridTheme` для дефолтных размеров и отступов. Поддерживает кастомные `TextStyle`.
- **Масштабирование**: `textScaleFactor` позволяет пропорционально менять размер всех шрифтов.

### VerseRangeChipStrip<T>
Полоса навигационных чипов.
- **Параметры**:
  - `ranges`: Список `VerseRange<T>`.
  - `chipBuilder`: Кастомный строитель чипа (ChoiceChip, и т.д.).
  - `isRangeSelected`: Предикат для выделения активного чипа.
- **Особенности**:
  - Использует `Wrap` для автоматического переноса строк.
  - Поддержка Accessibility: оборачивает чип в `Semantics`, если у диапазона задан `semanticsLabel`.

## Affected Systems
- `lib/src/widgets/verse_passage.dart`
- `lib/src/widgets/verse_range_chip_strip.dart`
- `lib/src/theme/verse_grid_theme.dart`

## Testing Strategy
- Визуальное тестирование различных макетов `VersePassage`.
- Проверка корректности `Semantics` в `VerseRangeChipStrip`.
- Проверка применения `textScaleFactor`.
