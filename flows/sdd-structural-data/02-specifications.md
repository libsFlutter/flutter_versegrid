# Specifications: structural-data

> Version: 1.0  
> Status: DRAFT (Legacy)  
> Last Updated: 2026-05-05  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview
Модуль содержит базовую модель `VerseRange` и утилиты для группировки данных.

## Data Models

### VerseRange<T>
Обобщенный класс для хранения группы элементов.

- `items`: `List<T>` - список элементов в группе.
- `label`: `String` - текст для отображения на чипе (например, "4-6").
- `semanticsLabel`: `String?` - описание для Accessibility.
- `representative`: `T` - возвращает первый элемент группы.

## Logic / Algorithms

### groupConsecutiveRuns<T>
Функция группировки по произвольному предикату.
- Принимает список элементов, компаратор для сортировки и предикат `belongsWithPrevious`.
- Возвращает список `VerseRange<T>`.

### groupConsecutiveByPosition<T>
Специализированная группировка по целочисленной позиции.
- Использует `groupConsecutiveRuns` внутри.
- Считает элементы последовательными, если их позиции отличаются на 1.

## Affected Systems
- `lib/src/models/verse_range.dart`
- `lib/src/utils/group_consecutive.dart`
- `lib/src/widgets/verse_range_chip_strip.dart` (потребляет эти данные)

## Testing Strategy
- Юнит-тесты на группировку с пропусками в позициях.
- Юнит-тесты на `copyWith` и семантические метки.
- Юнит-тесты на кастомные критерии группировки (например, по длине строки).
