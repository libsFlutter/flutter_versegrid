import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Base class for page-level blocks rendered by [VersePageRenderer].
@immutable
sealed class VersePageBlock {
  const VersePageBlock();
}

/// Plain text paragraph block (prose).
class VerseParagraphBlock extends VersePageBlock {
  const VerseParagraphBlock({
    required this.text,
    this.semanticsLabel,
    this.styleKey,
    this.textAlign,
    this.spacingAfter,
  });

  final String text;
  final String? semanticsLabel;

  /// Optional host-defined style key (e.g. `body`, `quote`, `title`).
  ///
  /// Resolved by [VersePageRenderer] via theme registry or resolver callback.
  final String? styleKey;

  /// Optional explicit alignment override for this paragraph.
  final TextAlign? textAlign;

  /// Optional extra vertical spacing after this block.
  final double? spacingAfter;
}

/// A verse passage block (primary + optional secondary).
class VersePassageBlock extends VersePageBlock {
  const VersePassageBlock({
    required this.primary,
    this.secondary,
    this.verseNumber,
    this.semanticsLabel,
    this.spacingAfter,
  });

  final String primary;
  final String? secondary;
  final int? verseNumber;
  final String? semanticsLabel;
  final double? spacingAfter;
}

/// A tappable "link" to another page (host app handles navigation).
class VersePageLinkBlock extends VersePageBlock {
  const VersePageLinkBlock({
    required this.targetPageId,
    required this.label,
    this.semanticsLabel,
    this.spacingAfter,
  });

  final String targetPageId;
  final String label;
  final String? semanticsLabel;
  final double? spacingAfter;
}

/// Custom host-provided block payload. Renderer receives it via callback.
class VerseCustomBlock<T> extends VersePageBlock {
  const VerseCustomBlock(
    this.payload, {
    this.semanticsLabel,
    this.spacingAfter,
  });

  final T payload;
  final String? semanticsLabel;
  final double? spacingAfter;
}

