# flutter_versegrid

Shared **Flutter UI** for verse / shloka readers: passage layout (original + translation), navigation chips for verse ranges, and optional theme tokens. **No native plugins** — pure Dart + Material.

**SDK:** Dart ^3.11.5 · Flutter >=3.3.0

---

## Install

Add a path or pub dependency:

```yaml
dependencies:
  flutter_versegrid:
    path: ../flutter_versegrid  # or ^0.1.0 when published
```

```dart
import 'package:flutter_versegrid/flutter_versegrid.dart';
```

---

## Widgets

### `VersePassage`

Displays a **primary** text line (e.g. Sanskrit, transliteration, or prose) and an optional **secondary** line (translation).

| Parameter | Role |
|-----------|------|
| `primary` / `secondary` | Body copy |
| `verseNumber` | Shown in side column when using `tabletRow` |
| `layout` | `tabletRow` · `columnCenter` · `columnStretch` |
| `primaryStyle` / `secondaryStyle` / `verseNumberStyle` | Override typography (falls back to `Theme.textTheme` + sizes from `VerseGridTheme`) |
| `textScaleFactor` | Scales resolved font sizes |
| `primaryTextAlign` / `secondaryTextAlign` | Per-line alignment |

Host apps keep full control of fonts (e.g. Murari, PT Sans, Devanagari stacks).

### `VerseRangeChipStrip<T>`

Horizontal **`Wrap`** of chips built from `List<VerseRange<T>>`. You supply **`chipBuilder`** so colors and chip widgets stay app-specific (`ChoiceChip`, M3 tokens, etc.).

If `VerseRange.semanticsLabel` is non-empty, each chip is wrapped in **`Semantics`** (`button: true`) for screen readers.

---

## Models & grouping

### `VerseRange<T>`

- **`items`** — slokas / segments in one chip  
- **`label`** — visible chip text (e.g. `12` or `4-6`)  
- **`semanticsLabel`** — optional a11y label (e.g. `Chapter 3, verses 4-6`)  
- **`representative`** — usually `items.first` for navigation  
- **`copyWith`** / **`clearSemanticsLabel`**

### `groupConsecutiveByPosition`

Sorts by `position(item)` and merges runs where `position == previous + 1`. Used for Bhagavad Gita–style ordered verses.

### `groupConsecutiveRuns`

General form: sort with a **`Comparator`**, merge when **`belongsWithPrevious(prev, curr)`** is true. Use for non–integer+1 editorial rules.

---

## Theming

### `VerseGridTheme` (`ThemeExtension`)

Register on `ThemeData.extensions`:

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

Read defaults: `VerseGridTheme.of(context)`.

### `VerseGridColorPalette` (optional)

Reference palette + **`lightColorScheme`** / **`lightTheme`** helper — useful for demos or apps that want a ready-made green/gold scheme; production apps often wire their own `ColorScheme`.

---

## Usage snippets

**Passage (centered, with translation):**

```dart
VersePassage(
  layout: VersePassageLayout.columnCenter,
  primary: 'jaśomatī-nandana braja-baro nāgara',
  secondary: 'The son of Yaśodā…',
  primaryStyle: Theme.of(context).textTheme.titleMedium,
  secondaryStyle: Theme.of(context).textTheme.bodyMedium,
);
```

**Chips after grouping:**

```dart
final ranges = groupConsecutiveByPosition<Sloka>(
  slokas,
  position: (s) => s.position,
  buildLabel: (g) => g.length == 1 ? '${g.single.position}' : '${g.first.position}-${g.last.position}',
).map((r) => r.copyWith(
      semanticsLabel: 'Chapter $chapterPos, verses ${r.label}',
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

---

## Cookbook integration

For XML/book pipelines that expose styled paragraphs, consecutive pairs with:

- `styleName == 'verse_original'`
- followed by `styleName == 'verse_translation'`

can be merged into a single `VersePassage` in the host app (see **Cookbook**’s `CookbookVerseParagraphStyles` + `PageContent` in this monorepo).

---

## Example

Run the bundled gallery:

```bash
cd example && flutter run
```

---

## Repository layout

| Path | Contents |
|------|----------|
| `lib/flutter_versegrid.dart` | Barrel export |
| `lib/src/widgets/` | `VersePassage`, `VerseRangeChipStrip` |
| `lib/src/utils/group_consecutive.dart` | Range grouping |
| `lib/src/theme/` | `VerseGridTheme`, `VerseGridColorPalette` |
| `example/` | Minimal demo |
| `flows/vdd-verse-grid/` | Product / UX notes (draft) |

---

## License

See `LICENSE` in the package root.
