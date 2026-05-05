class VerseNumberGridItem<T> {
  const VerseNumberGridItem({
    required this.value,
    required this.label,
    this.bookmarked = false,
    this.semanticsLabel,
  });

  final T value;
  final String label;
  final bool bookmarked;
  final String? semanticsLabel;
}

