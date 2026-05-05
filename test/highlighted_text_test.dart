import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_versegrid/flutter_versegrid.dart';

void main() {
  testWidgets('HighlightedText highlights all occurrences', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedText(
            text: 'one two one',
            query: 'one',
          ),
        ),
      ),
    );

    expect(find.text('one two one'), findsOneWidget);
    expect(find.byType(RichText), findsOneWidget);

    final rich = tester.widget<RichText>(find.byType(RichText));
    final span = rich.text as TextSpan;
    final text = span.toPlainText();
    expect(text, 'one two one');

    int countHighlighted(TextSpan s) {
      var count = (s.style?.backgroundColor != null) ? 1 : 0;
      final children = s.children ?? const <InlineSpan>[];
      for (final c in children) {
        if (c is TextSpan) count += countHighlighted(c);
      }
      return count;
    }

    expect(countHighlighted(span), 2);
  });
}

