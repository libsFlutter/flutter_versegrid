import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_versegrid/flutter_versegrid.dart';

void main() {
  group('VerseGridColorPalette', () {
    test('matches HRISHIKESH SWAMI hex tokens', () {
      expect(VerseGridColorPalette.forest, const Color(0xFF3A5A40));
      expect(VerseGridColorPalette.forestMid, const Color(0xFF38573D));
      expect(VerseGridColorPalette.forestDeep, const Color(0xFF304B35));
      expect(VerseGridColorPalette.goldBright, const Color(0xFFEEB844));
      expect(VerseGridColorPalette.gold, const Color(0xFFEAA81C));
      expect(VerseGridColorPalette.goldDeep, const Color(0xFFCD9213));
      expect(VerseGridColorPalette.paper, const Color(0xFFFFFFFF));
      expect(VerseGridColorPalette.ink, const Color(0xFF343A40));
      expect(VerseGridColorPalette.black, const Color(0xFF000000));
    });

    test('lightTheme registers VerseGridTheme extension', () {
      final theme = VerseGridColorPalette.lightTheme();
      expect(theme.extension<VerseGridTheme>(), isNotNull);
    });
  });
}
