import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_versegrid_example/main.dart';

void main() {
  testWidgets('Gallery loads', (WidgetTester tester) async {
    await tester.pumpWidget(const VersegridGalleryApp());
    expect(find.textContaining('VersePassage'), findsWidgets);
  });
}
