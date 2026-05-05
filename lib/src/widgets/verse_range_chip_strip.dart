import 'package:flutter/material.dart';

import '../models/verse_range.dart';

/// Chip strip for verse range navigation (contents / master pane).
///
/// Styling is delegated to [chipBuilder] so host apps keep palette authority.
///
/// When [VerseRange.semanticsLabel] is set, each chip is wrapped in
/// [Semantics] with `button: true`.
class VerseRangeChipStrip<T> extends StatelessWidget {
  const VerseRangeChipStrip({
    super.key,
    required this.ranges,
    required this.isRangeSelected,
    required this.onRangeTap,
    required this.chipBuilder,
    this.spacing = 8,
    this.runSpacing = 8,
    this.padding = EdgeInsets.zero,
  });

  final List<VerseRange<T>> ranges;

  /// Whether the chip for this range should appear selected.
  final bool Function(VerseRange<T> range) isRangeSelected;

  /// Typically opens the first sloka in the range.
  final ValueChanged<VerseRange<T>> onRangeTap;

  /// Builds each chip (e.g. [ChoiceChip], [FilterChip], custom Material 3).
  final Widget Function(
    BuildContext context,
    VerseRange<T> range,
    bool selected,
    VoidCallback onTap,
  ) chipBuilder;

  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: [
          for (final range in ranges)
            _maybeSemantics(
              range,
              chipBuilder(
                context,
                range,
                isRangeSelected(range),
                () => onRangeTap(range),
              ),
            ),
        ],
      ),
    );
  }

  Widget _maybeSemantics(VerseRange<T> range, Widget chip) {
    final label = range.semanticsLabel?.trim();
    if (label == null || label.isEmpty) return chip;
    return Semantics(
      label: label,
      button: true,
      child: chip,
    );
  }
}
