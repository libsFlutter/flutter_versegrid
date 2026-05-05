# flutter_versegrid

Общие **Flutter UI** компоненты для приложений чтения стихов и шлок: разметка пассажей (оригинал + перевод), навигационные чипы для диапазонов стихов и токены оформления. **Без нативных плагинов** — чистый Dart + Material.

**SDK:** Dart ^3.11.5 · Flutter >=3.3.0

---

## Установка

Добавьте зависимость через путь или pub:

```yaml
dependencies:
  flutter_versegrid:
    path: ../flutter_versegrid  # или ^0.1.0 после публикации
```

```dart
import 'package:flutter_versegrid/flutter_versegrid.dart';
```

---

## Виджеты

### `VersePassage`

Отображает основную строку текста (**primary**, например: санскрит, транслитерация) и опциональную второстепенную строку (**secondary**, перевод).

| Параметр | Роль |
|-----------|------|
| `primary` / `secondary` | Текст контента |
| `verseNumber` | Номер стиха, отображается в боковой колонке при использовании `tabletRow` |
| `layout` | Режимы разметки: `tabletRow` (планшет), `columnCenter` (центр), `columnStretch` (по ширине) |
| `primaryStyle` / `secondaryStyle` / `verseNumberStyle` | Переопределение типографики (по умолчанию используется `Theme.textTheme` + размеры из `VerseGridTheme`) |
| `textScaleFactor` | Масштабирует итоговые размеры шрифтов |
| `primaryTextAlign` / `secondaryTextAlign` | Выравнивание для каждой строки |
| `highlightQuery` | (опционально) строка поиска для подсветки совпадений |

Приложения сохраняют полный контроль над шрифтами (например, Murari, PT Sans, шрифты Devanagari).

### `VersePageView` / `VersePageRenderer`

Page-level компоновка “страница как список блоков” + свайпы между страницами.

- `VersePage` содержит `id` и список блоков `VersePageBlock`
- `VersePageRenderer` рендерит блоки по порядку (пассажи, параграфы, ссылки на страницы, кастомные блоки)
- `VersePageView` — `PageView`-ридер с transitions (`none/fade/scale/fadeAndScale`) и callback’ами (`onPageChanged`, `onPageLinkTap`)

### `VerseRangeChipStrip<T>`

Горизонтальная лента чипов (**`Wrap`**), построенная на основе `List<VerseRange<T>>`. Вы передаете **`chipBuilder`**, поэтому цвета и типы чипов остаются на стороне приложения (`ChoiceChip`, токены M3 и т.д.).

Если задан `VerseRange.semanticsLabel`, каждый чип оборачивается в **`Semantics`** (`button: true`) для экранных дикторов.

### `VerseNumberGrid<T>`

Фиксированная сетка номеров стихов (по умолчанию **7 колонок**) — для legacy-поведения “одна ячейка на стих” (выбор текущего стиха, индикатор закладки).

Визуал ячейки полностью задаётся через `cellBuilder`, а виджет берёт на себя только **геометрию** (квадратные ячейки, отступы, ограничение по рядам `maxRows` и опциональный внутренний скролл при переполнении).

---

## Модели и группировка

### `VerseRange<T>`

- **`items`** — список элементов (шлок) в одном чипе.
- **`label`** — видимый текст чипа (например, `12` или `4-6`).
- **`semanticsLabel`** — опциональная метка доступности (например, `Глава 3, стихи 4-6`).
- **`representative`** — обычно `items.first` для навигации.
- **`copyWith`** / **`clearSemanticsLabel`**.

### `groupConsecutiveByPosition`

Сортирует элементы по `position(item)` и объединяет их в группы, где `position == previous + 1`. Используется для последовательных стихов (как в Бхагавад-гите).

### `groupConsecutiveRuns`

Общая форма: сортировка через **`Comparator`**, объединение, когда **`belongsWithPrevious(prev, curr)`** истинно. Используется для нестандартных правил редакторской группировки.

---

## Тематизация

### `VerseGridTheme` (`ThemeExtension`)

Регистрируется в `ThemeData.extensions`:

```dart
ThemeData(
  extensions: const [
    VerseGridTheme(
      verseNumberColumnWidth: 40,
      gapOriginalToTranslation: 16,
      defaultOriginalFontSize: 16,
      defaultTranslationFontSize: 15,
    ),
  ],
);
```

Чтение значений: `VerseGridTheme.of(context)`.

### `VerseGridColorPalette` (опционально)

Справочная палитра + вспомогательные методы **`lightColorScheme`** / **`lightTheme`**. Полезно для демо или приложений, которым нужна готовая зелено-золотая схема оформления.

---

## Примеры использования

**Пассаж (по центру, с переводом):**

```dart
VersePassage(
  layout: VersePassageLayout.columnCenter,
  primary: 'jaśomatī-nandana braja-baro nāgara',
  secondary: 'Сын Яшоды…',
  primaryStyle: Theme.of(context).textTheme.titleMedium,
  secondaryStyle: Theme.of(context).textTheme.bodyMedium,
);
```

**Чипы после группировки:**

```dart
final ranges = groupConsecutiveByPosition<Sloka>(
  slokas,
  position: (s) => s.position,
  buildLabel: (g) => g.length == 1 ? '${g.single.position}' : '${g.first.position}-${g.last.position}',
).map((r) => r.copyWith(
      semanticsLabel: 'Глава $chapterPos, стихи ${r.label}',
    ))
    .toList();

VerseRangeChipStrip<Sloka>(
  ranges: ranges,
  isRangeSelected: (r) => r.contains((s) => s.id == selectedId),
  onRangeTap: (r) => openSloka(r.representative),
  chipBuilder: (context, range, selected, onTap) => ChoiceChip(
    label: Text(range.label),
    selected: selected,
    onSelected: (_) => onTap(),
  ),
);
```

**Сетка номеров (fixed 7 columns):**

```dart
VerseNumberGrid<int>(
  items: [
    for (final i in List.generate(47, (i) => i + 1))
      VerseNumberGridItem(
        value: i,
        label: '$i',
        bookmarked: i == 3 || i == 18,
        semanticsLabel: 'Глава 1, стих $i',
      ),
  ],
  isSelected: (item) => item.value == 18,
  onItemTap: (item) => debugPrint('tap ${item.value}'),
  cellBuilder: (context, item, selected, size, onTap) {
    return SizedBox(
      width: size,
      height: size,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? Colors.red : Colors.grey.shade200,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            if (item.bookmarked)
              Positioned(
                top: size * 0.12,
                right: size * 0.12,
                child: Container(
                  width: size * 0.18,
                  height: size * 0.18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  },
);
```

---

## Структура репозитория

| Путь | Содержимое |
|------|----------|
| `lib/flutter_versegrid.dart` | Основной экспорт библиотеки |
| `lib/src/widgets/` | Виджеты `VersePassage`, `VerseRangeChipStrip` |
| `lib/src/utils/group_consecutive.dart` | Логика группировки диапазонов |
| `lib/src/theme/` | Тема `VerseGridTheme`, палитра `VerseGridColorPalette` |
| `example/` | Минимальное демо-приложение |
| `flows/sdd-typographics/` | SDD: типографика и ритм абзацев (`VerseGridTheme`, `VersePassage`) |
| `flows/sdd-color-palette/` | SDD: палитра HRISHIKESH → `ColorScheme` |
| `flows/` | Прочая документация SDD/VDD/PDD |

---

## Лицензия

См. файл `LICENSE` в корне пакета.
