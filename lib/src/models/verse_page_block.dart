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
  });

  final String text;
  final String? semanticsLabel;

  /// Optional host-defined style key (e.g. `body`, `quote`, `title`).
  ///
  /// Resolved by [VersePageRenderer] via theme registry or resolver callback.
  final String? styleKey;

  /// Optional explicit alignment override for this paragraph.
  final TextAlign? textAlign;
}

/// A verse passage block (primary + optional secondary).
class VersePassageBlock extends VersePageBlock {
  const VersePassageBlock({
    required this.primary,
    this.secondary,
    this.verseNumber,
    this.semanticsLabel,
  });

  final String primary;
  final String? secondary;
  final int? verseNumber;
  final String? semanticsLabel;
}

/// A tappable "link" to another page (host app handles navigation).
class VersePageLinkBlock extends VersePageBlock {
  const VersePageLinkBlock({
    required this.targetPageId,
    required this.label,
    this.semanticsLabel,
  });

  final String targetPageId;
  final String label;
  final String? semanticsLabel;
}

/// Custom host-provided block payload. Renderer receives it via callback.
class VerseCustomBlock<T> extends VersePageBlock {
  const VerseCustomBlock(this.payload, {this.semanticsLabel});

  final T payload;
  final String? semanticsLabel;
}

