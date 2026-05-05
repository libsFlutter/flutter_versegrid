/// A contiguous run of items in chapter order, shown as one navigation chip.
class VerseRange<T> {
  const VerseRange({
    required this.items,
    required this.label,
    this.semanticsLabel,
  });

  final List<T> items;
  final String label;

  /// Combined accessibility label (e.g. chapter + verse token). Used by
  /// [VerseRangeChipStrip] when non-null and non-empty.
  final String? semanticsLabel;

  T get representative => items.first;

  bool contains(bool Function(T item) predicate) => items.any(predicate);

  VerseRange<T> copyWith({
    List<T>? items,
    String? label,
    String? semanticsLabel,
    bool clearSemanticsLabel = false,
  }) {
    return VerseRange<T>(
      items: items ?? this.items,
      label: label ?? this.label,
      semanticsLabel: clearSemanticsLabel
          ? null
          : (semanticsLabel ?? this.semanticsLabel),
    );
  }
}
