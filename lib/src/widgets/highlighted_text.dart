import 'package:flutter/material.dart';

/// Renders [text] and highlights all occurrences of [query].
///
/// This is intentionally simple: it's meant for search result highlighting
/// in verse readers (not a full rich-text editor).
class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
    this.caseSensitive = false,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final bool caseSensitive;

  @override
  Widget build(BuildContext context) {
    final q = query.trim();
    if (q.isEmpty) {
      return Text(text, style: style);
    }

    final base = style ?? DefaultTextStyle.of(context).style;
    final hi = highlightStyle ??
        base.copyWith(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        );

    final src = caseSensitive ? text : text.toLowerCase();
    final needle = caseSensitive ? q : q.toLowerCase();

    final spans = <InlineSpan>[];
    var start = 0;
    while (true) {
      final index = src.indexOf(needle, start);
      if (index < 0) break;
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: base));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + needle.length),
          style: hi,
        ),
      );
      start = index + needle.length;
      if (start >= text.length) break;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: base));
    }

    return Text.rich(TextSpan(children: spans));
  }
}

