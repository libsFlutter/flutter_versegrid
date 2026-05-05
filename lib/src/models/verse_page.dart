import 'package:flutter/foundation.dart';

import 'verse_page_block.dart';

/// A single reader page composed from ordered UI blocks.
@immutable
class VersePage {
  const VersePage({
    required this.id,
    required this.blocks,
    this.semanticsLabel,
  });

  /// Stable identifier (e.g. legacy page index as string).
  final String id;

  final List<VersePageBlock> blocks;

  /// Optional combined accessibility label for the page.
  final String? semanticsLabel;
}

