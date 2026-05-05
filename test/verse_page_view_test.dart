import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_versegrid/flutter_versegrid.dart';

void main() {
  testWidgets('VersePageView swipes between pages and calls onPageChanged',
      (tester) async {
    final pages = [
      const VersePage(
        id: 'p1',
        blocks: [
          VerseParagraphBlock(text: 'Page 1'),
        ],
      ),
      const VersePage(
        id: 'p2',
        blocks: [
          VerseParagraphBlock(text: 'Page 2'),
        ],
      ),
    ];

    int? changedTo;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VersePageView(
            pages: pages,
            onPageChanged: (i) => changedTo = i,
          ),
        ),
      ),
    );

    expect(find.text('Page 1'), findsOneWidget);
    expect(find.text('Page 2'), findsNothing);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(changedTo, 1);
    expect(find.text('Page 2'), findsOneWidget);
  });
}

