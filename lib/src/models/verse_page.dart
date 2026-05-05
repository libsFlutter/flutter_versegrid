import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'verse_page_block.dart';

enum VersePageBackgroundFit { cover, contain, fill, none }

@immutable
class VersePageBackground {
  const VersePageBackground({
    this.color,
    this.image,
    this.fit = VersePageBackgroundFit.cover,
    this.alignment = Alignment.center,
  });

  final Color? color;
  final ImageProvider? image;
  final VersePageBackgroundFit fit;
  final Alignment alignment;
}

enum VersePageNumberPosition { bottomLeft, bottomCenter, bottomRight }

@immutable
class VersePageNumber {
  const VersePageNumber({
    required this.value,
    this.position = VersePageNumberPosition.bottomLeft,
    this.format,
  });

  final int value;
  final VersePageNumberPosition position;
  final String Function(int value)? format;

  String formatValue() => (format == null) ? value.toString() : format!(value);
}

@immutable
class VersePageOverlayLifecycle {
  const VersePageOverlayLifecycle({
    required this.isVisible,
    required this.pageIndex,
    required this.pageOffset,
  });

  final bool isVisible;
  final int pageIndex;

  /// Signed offset from the focused page: `page - pageIndex`.
  final double pageOffset;
}

@immutable
class VersePageOverlay {
  const VersePageOverlay({
    required this.id,
    required this.builder,
    this.hitTestBehavior = HitTestBehavior.deferToChild,
  });

  final String id;
  final Widget Function(
    BuildContext context,
    VersePage page,
    VersePageOverlayLifecycle lifecycle,
  ) builder;

  final HitTestBehavior hitTestBehavior;
}

/// A single reader page composed from ordered UI blocks.
@immutable
class VersePage {
  const VersePage({
    required this.id,
    required this.blocks,
    this.semanticsLabel,
    this.background,
    this.pageNumber,
    this.overlays = const [],
  });

  /// Stable identifier (e.g. legacy page index as string).
  final String id;

  final List<VersePageBlock> blocks;

  /// Optional combined accessibility label for the page.
  final String? semanticsLabel;

  /// Optional page-level background.
  final VersePageBackground? background;

  /// Optional page number configuration.
  final VersePageNumber? pageNumber;

  /// Optional overlay layers (typically animations/interactive layers).
  final List<VersePageOverlay> overlays;
}

