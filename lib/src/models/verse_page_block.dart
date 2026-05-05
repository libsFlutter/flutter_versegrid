import 'package:flutter/foundation.dart';

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
  });

  final String text;
  final String? semanticsLabel;
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

