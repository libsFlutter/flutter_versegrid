/// A contiguous run of items in chapter order, shown as one navigation chip.
class VerseRange<T> {
  const VerseRange({
    required this.items,
    required this.label,
  });

  final List<T> items;
  final String label;

  T get representative => items.first;

  bool contains(bool Function(T item) predicate) => items.any(predicate);
}
