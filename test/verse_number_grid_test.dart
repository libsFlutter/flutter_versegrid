import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_versegrid/flutter_versegrid.dart';

void main() {
  testWidgets('VerseNumberGrid caps height by maxRows', (tester) async {
    final items = [
      for (var i = 1; i <= 50; i++)
        VerseNumberGridItem<int>(value: i, label: '$i'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 350, // 7 columns → 50px each when spacing=0
            child: VerseNumberGrid<int>(
              items: items,
              columns: 7,
              spacing: 0,
              runSpacing: 0,
              maxRows: 4,
              isSelected: (_) => false,
              onItemTap: (_) {},
              cellBuilder: (context, item, selected, size, onTap) {
                return SizedBox(width: size, height: size);
              },
            ),
          ),
        ),
      ),
    );

    // 4 rows * 50px = 200px
    final h = tester.getSize(find.byType(VerseNumberGrid<int>)).height;
    expect(h, 200);
  });

  testWidgets('VerseNumberGrid tap calls callback with item', (tester) async {
    VerseNumberGridItem<int>? tapped;
    final items = [
      for (var i = 1; i <= 7; i++)
        VerseNumberGridItem<int>(value: i, label: '$i'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 350,
            child: VerseNumberGrid<int>(
              items: items,
              columns: 7,
              spacing: 0,
              runSpacing: 0,
              maxRows: 1,
              isSelected: (_) => false,
              onItemTap: (i) => tapped = i,
              cellBuilder: (context, item, selected, size, onTap) {
                return GestureDetector(
                  onTap: onTap,
                  child: SizedBox(width: size, height: size, child: Text(item.label)),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('3'));
    await tester.pump();
    expect(tapped?.value, 3);
  });

  testWidgets('VerseNumberGrid adds semantics labels', (tester) async {
    final items = [
      const VerseNumberGridItem<int>(
        value: 1,
        label: '1',
        semanticsLabel: 'Chapter 1, verse 1',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 350,
            child: VerseNumberGrid<int>(
              items: items,
              columns: 7,
              spacing: 0,
              runSpacing: 0,
              maxRows: 1,
              isSelected: (_) => false,
              onItemTap: (_) {},
              cellBuilder: (context, item, selected, size, onTap) {
                return GestureDetector(
                  onTap: onTap,
                  child: SizedBox(width: size, height: size),
                );
              },
            ),
          ),
        ),
      ),
    );

    final handle = tester.ensureSemantics();
    try {
      expect(find.bySemanticsLabel('Chapter 1, verse 1'), findsOneWidget);
    } finally {
      handle.dispose();
    }
  });
}

