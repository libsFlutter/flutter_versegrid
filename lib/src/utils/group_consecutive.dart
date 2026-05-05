import '../models/verse_range.dart';

/// Groups [items] into maximal consecutive ranges by integer [position].
///
/// Items are sorted by [position] before grouping. Non-consecutive jumps start
/// a new range.
List<VerseRange<T>> groupConsecutiveByPosition<T>(
  List<T> items, {
  required int Function(T item) position,
  required String Function(List<T> group) buildLabel,
}) {
  if (items.isEmpty) return [];

  final sorted = [...items]..sort((a, b) => position(a).compareTo(position(b)));
  final ranges = <VerseRange<T>>[];
  var group = <T>[sorted.first];

  for (var i = 1; i < sorted.length; i++) {
    final prev = sorted[i - 1];
    final curr = sorted[i];
    if (position(curr) == position(prev) + 1) {
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
