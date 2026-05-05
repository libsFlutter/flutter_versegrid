import '../models/verse_range.dart';

/// Groups [items] into maximal runs: items are [sort]ed, then each adjacent
/// pair [belongsWithPrevious](previous, current) extends the current run.
///
/// Use when editorial rules differ from simple integer `n → n+1` chains.
List<VerseRange<T>> groupConsecutiveRuns<T>(
  List<T> items, {
  required Comparator<T> sort,
  required bool Function(T previous, T current) belongsWithPrevious,
  required String Function(List<T> group) buildLabel,
}) {
  if (items.isEmpty) return [];

  final sorted = [...items]..sort(sort);
  final ranges = <VerseRange<T>>[];
  var group = <T>[sorted.first];

  for (var i = 1; i < sorted.length; i++) {
    final prev = sorted[i - 1];
    final curr = sorted[i];
    if (belongsWithPrevious(prev, curr)) {
      group.add(curr);
    } else {
      ranges.add(
        VerseRange(
          items: List<T>.unmodifiable(group),
          label: buildLabel(group),
        ),
      );
      group = <T>[curr];
    }
  }

  ranges.add(
    VerseRange(
      items: List<T>.unmodifiable(group),
      label: buildLabel(group),
    ),
  );

  return ranges;
}

/// Groups [items] into maximal consecutive ranges by integer [position].
///
/// Items are sorted by [position] before grouping. Non-consecutive jumps start
/// a new range.
List<VerseRange<T>> groupConsecutiveByPosition<T>(
  List<T> items, {
  required int Function(T item) position,
  required String Function(List<T> group) buildLabel,
}) {
  return groupConsecutiveRuns<T>(
    items,
    sort: (a, b) => position(a).compareTo(position(b)),
    belongsWithPrevious: (prev, curr) =>
        position(curr) == position(prev) + 1,
    buildLabel: buildLabel,
  );
}
