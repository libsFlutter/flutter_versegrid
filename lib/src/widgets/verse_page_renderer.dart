import 'package:flutter/material.dart';

import '../models/verse_page.dart';
import '../models/verse_page_block.dart';
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
    }

    final content = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing(children, blockSpacing),
      ),
    );

    final label = page.semanticsLabel?.trim();
    if (label == null || label.isEmpty) return content;
    return Semantics(label: label, child: content);
  }

  Widget _buildBlock(BuildContext context, VersePageBlock b) {
    return switch (b) {
      VerseParagraphBlock(:final text, :final semanticsLabel) =>
        _maybeSemantics(
          semanticsLabel,
          Text(
            text,
            style: paragraphStyle ?? Theme.of(context).textTheme.bodyLarge,
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

  List<Widget> _withSpacing(List<Widget> children, double spacing) {
    if (children.isEmpty) return const [];
    final out = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) out.add(SizedBox(height: spacing));
      out.add(children[i]);
    }
    return out;
  }
}

