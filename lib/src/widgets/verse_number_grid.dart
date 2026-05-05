import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/verse_number_grid_item.dart';

typedef VerseNumberGridCellBuilder<T> = Widget Function(
  BuildContext context,
  VerseNumberGridItem<T> item,
  bool selected,
  double size,
  VoidCallback onTap,
);

/// Fixed-column grid of verse numbers (legacy parity).
///
/// Unlike [VerseRangeChipStrip], this widget targets the legacy 7-column
/// "one cell per verse" navigation surface. Visual styling is delegated to
/// [cellBuilder] so host apps keep full control over palette and shape.
class VerseNumberGrid<T> extends StatelessWidget {
  const VerseNumberGrid({
    super.key,
    required this.items,
    required this.isSelected,
    required this.onItemTap,
    required this.cellBuilder,
    this.columns = 7,
    this.maxRows = 4,
    this.spacing = 2,
    this.runSpacing = 2,
    this.padding = EdgeInsets.zero,
    this.scrollWhenOverflow = true,
  }) : assert(columns > 0),
       assert(spacing >= 0),
       assert(runSpacing >= 0);

  final List<VerseNumberGridItem<T>> items;

  /// Whether an [item] should appear selected.
  final bool Function(VerseNumberGridItem<T> item) isSelected;

  /// Called when the user taps a cell.
  final ValueChanged<VerseNumberGridItem<T>> onItemTap;

  /// Builds each cell widget.
  final VerseNumberGridCellBuilder<T> cellBuilder;

  /// Number of columns (default: 7).
  final int columns;

  /// Maximum rows to display before capping height.
  ///
  /// When null, the grid expands to show all rows.
  final int? maxRows;

  /// Horizontal spacing between cells.
  final double spacing;

  /// Vertical spacing between rows.
  final double runSpacing;

  final EdgeInsetsGeometry padding;

  /// If true, allow internal vertical scrolling when items exceed [maxRows].
  final bool scrollWhenOverflow;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedPadding = padding.resolve(Directionality.of(context));
        final usableWidth =
            math.max(0.0, constraints.maxWidth - resolvedPadding.horizontal);

        final rawSize =
            (usableWidth - (columns - 1) * spacing) / columns.toDouble();
        final cellSize = rawSize.isFinite ? math.max(0.0, rawSize) : 0.0;

        final rowsNeeded = (items.length / columns).ceil();
        final visibleRows =
            maxRows == null ? rowsNeeded : math.min(rowsNeeded, maxRows!);

        final cappedHeight = visibleRows * cellSize +
            math.max(0, visibleRows - 1) * runSpacing;

        final isOverflowing = rowsNeeded > visibleRows;
        final physics = (isOverflowing && scrollWhenOverflow)
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics();

        final grid = GridView.builder(
          padding: resolvedPadding,
          shrinkWrap: true,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: 1,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final selected = isSelected(item);
            return _maybeSemantics(
              item,
              cellBuilder(
                context,
                item,
                selected,
                cellSize,
                () => onItemTap(item),
              ),
            );
          },
        );

        if (maxRows == null) return grid;

        // Cap height to keep parent layouts predictable.
        return SizedBox(height: cappedHeight + resolvedPadding.vertical, child: grid);
      },
    );
  }

  Widget _maybeSemantics(VerseNumberGridItem<T> item, Widget cell) {
    final label = (item.semanticsLabel ?? item.label).trim();
    if (label.isEmpty) return cell;
    return Semantics(
      label: label,
      button: true,
      child: cell,
    );
  }
}

