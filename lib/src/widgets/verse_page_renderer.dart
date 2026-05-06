import 'package:flutter/material.dart';

import '../models/verse_page.dart';
import '../models/verse_page_block.dart';
import '../theme/verse_page_theme.dart';
import 'verse_passage.dart';

typedef VerseCustomBlockBuilder = Widget Function(
  BuildContext context,
  VerseCustomBlock<dynamic> block,
);

/// Renders a [VersePage] into a vertical column of blocks.
class VersePageRenderer extends StatelessWidget {
  const VersePageRenderer({
    super.key,
    required this.page,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.blockSpacing = 12,
    this.paragraphStyle,
    this.paragraphStyleResolver,
    this.pageNumberStyle,
    this.passageLayout = VersePassageLayout.columnStretch,
    this.highlightQuery,
    this.highlightStyle,
    this.highlightCaseSensitive = false,
    this.onPageLinkTap,
    this.pageLinkBuilder,
    this.customBlockBuilder,
  });

  final VersePage page;
  final EdgeInsetsGeometry padding;
  final double blockSpacing;

  final TextStyle? paragraphStyle;
  final VerseParagraphStyle? Function(BuildContext context, String styleKey)?
      paragraphStyleResolver;
  final TextStyle? pageNumberStyle;
  final VersePassageLayout passageLayout;

  final String? highlightQuery;
  final TextStyle? highlightStyle;
  final bool highlightCaseSensitive;

  final ValueChanged<String /* targetPageId */ >? onPageLinkTap;

  /// Optional custom builder for page links.
  final Widget Function(
    BuildContext context,
    VersePageLinkBlock link,
    VoidCallback onTap,
  )? pageLinkBuilder;

  /// Optional custom builder for [VerseCustomBlock] blocks.
  final VerseCustomBlockBuilder? customBlockBuilder;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final b in page.blocks) {
      children.add(_buildBlock(context, b));
      final after = _spacingAfterBlock(b);
      if (after != null && after > 0) {
        children.add(SizedBox(height: after));
      } else {
        children.add(SizedBox(height: blockSpacing));
      }
    }
    if (children.isNotEmpty) {
      children.removeLast();
    }

    Widget content = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    final bg = page.background;
    final pn = page.pageNumber;
    if (bg != null || pn != null) {
      content = Stack(
        fit: StackFit.passthrough,
        children: [
          if (bg != null)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: bg.color,
                  image: bg.image == null
                      ? null
                      : DecorationImage(
                          image: bg.image!,
                          alignment: bg.alignment,
                          fit: switch (bg.fit) {
                            VersePageBackgroundFit.cover => BoxFit.cover,
                            VersePageBackgroundFit.contain => BoxFit.contain,
                            VersePageBackgroundFit.fill => BoxFit.fill,
                            VersePageBackgroundFit.none => BoxFit.none,
                          },
                        ),
                ),
              ),
            ),
          content,
          if (pn != null) _buildPageNumberOverlay(context, pn),
        ],
      );
    }

    final label = page.semanticsLabel?.trim();
    if (label == null || label.isEmpty) return content;
    return Semantics(label: label, child: content);
  }

  Widget _buildPageNumberOverlay(BuildContext context, VersePageNumber pn) {
    final safe = MediaQuery.paddingOf(context);
    final pad = EdgeInsets.only(left: 16 + safe.left, right: 16 + safe.right, bottom: 12 + safe.bottom);

    final alignment = switch (pn.position) {
      VersePageNumberPosition.bottomLeft => Alignment.bottomLeft,
      VersePageNumberPosition.bottomCenter => Alignment.bottomCenter,
      VersePageNumberPosition.bottomRight => Alignment.bottomRight,
    };

    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: pad,
          child: Text(
            pn.formatValue(),
            style: pageNumberStyle ?? Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildBlock(BuildContext context, VersePageBlock b) {
    return switch (b) {
      VerseParagraphBlock(
        :final text,
        :final semanticsLabel,
        :final styleKey,
        :final textAlign,
      ) =>
        _maybeSemantics(
          semanticsLabel,
          _buildParagraph(
            context,
            text: text,
            styleKey: styleKey,
            textAlign: textAlign,
          ),
        ),
      VersePassageBlock(
        :final primary,
        :final secondary,
        :final verseNumber,
        :final semanticsLabel
      ) =>
        _maybeSemantics(
          semanticsLabel,
          VersePassage(
            primary: primary,
            secondary: secondary,
            verseNumber: verseNumber,
            layout: passageLayout,
            highlightQuery: highlightQuery,
            highlightStyle: highlightStyle,
            highlightCaseSensitive: highlightCaseSensitive,
          ),
        ),
      VersePageLinkBlock(
        :final targetPageId,
        :final label,
        :final semanticsLabel
      ) =>
        _maybeSemantics(
          semanticsLabel ?? label,
          _defaultPageLink(
            context,
            VersePageLinkBlock(
              targetPageId: targetPageId,
              label: label,
              semanticsLabel: semanticsLabel,
            ),
          ),
        ),
      VerseCustomBlock<dynamic>() => customBlockBuilder != null
          ? customBlockBuilder!(context, b)
          : const SizedBox.shrink(),
    };
  }

  double? _spacingAfterBlock(VersePageBlock b) {
    return switch (b) {
      VerseParagraphBlock(:final spacingAfter) => spacingAfter,
      VersePassageBlock(:final spacingAfter) => spacingAfter,
      VersePageLinkBlock(:final spacingAfter) => spacingAfter,
      VerseCustomBlock<dynamic>(:final spacingAfter) => spacingAfter,
    };
  }

  Widget _buildParagraph(
    BuildContext context, {
    required String text,
    required String? styleKey,
    required TextAlign? textAlign,
  }) {
    final resolved = styleKey == null
        ? null
        : (paragraphStyleResolver?.call(context, styleKey) ??
            VersePageTheme.of(context).paragraphStyles?.resolve(styleKey));

    final effectiveStyle =
        resolved?.textStyle ?? paragraphStyle ?? Theme.of(context).textTheme.bodyLarge;
    final effectiveAlign = textAlign ?? resolved?.textAlign;

    Widget child = Text(
      text,
      style: effectiveStyle,
      textAlign: effectiveAlign,
    );

    final bg = resolved?.background;
    final pad = resolved?.padding;
    if (bg != null || pad != null) {
      child = Container(
        decoration: bg,
        padding: pad,
        child: child,
      );
    }

    return child;
  }

  Widget _defaultPageLink(BuildContext context, VersePageLinkBlock link) {
    final onTap = onPageLinkTap == null ? null : () => onPageLinkTap!(link.targetPageId);

    if (pageLinkBuilder != null && onTap != null) {
      return pageLinkBuilder!(context, link, onTap);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.link),
        label: Text(link.label),
      ),
    );
  }

  Widget _maybeSemantics(String? label, Widget child) {
    final l = label?.trim();
    if (l == null || l.isEmpty) return child;
    return Semantics(label: l, child: child);
  }

  // Kept intentionally: spacing now handled per-block (see `_spacingAfterBlock`).
}

