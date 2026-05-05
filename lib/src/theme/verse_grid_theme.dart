import 'package:flutter/material.dart';

/// Optional styling for [VersePassage] and [VerseRangeChipStrip] via [ThemeExtension].
@immutable
class VerseGridTheme extends ThemeExtension<VerseGridTheme> {
  const VerseGridTheme({
    this.verseNumberColumnWidth = 40,
    this.rowVerticalPadding = 12,
    this.columnVerticalPadding = 9,
    this.gapOriginalToTranslation = 16,
    this.gapOriginalToTranslationCompact = 8,
    this.defaultOriginalFontSize = 16,
    this.defaultTranslationFontSize = 15,
    this.defaultVerseNumberFontSize = 12,
  });

  /// Width of side columns when [VersePassageLayout.tabletRow] is used.
  final double verseNumberColumnWidth;

  /// Vertical padding for row layout (half applied symmetrically).
  final double rowVerticalPadding;

  /// Vertical padding for compact column layout (half applied symmetrically).
  final double columnVerticalPadding;

  /// Space between primary and secondary text in row layout.
  final double gapOriginalToTranslation;

  /// Space between primary and secondary text in compact column layout.
  final double gapOriginalToTranslationCompact;

  final double defaultOriginalFontSize;
  final double defaultTranslationFontSize;
  final double defaultVerseNumberFontSize;

  static VerseGridTheme of(BuildContext context) {
    return Theme.of(context).extension<VerseGridTheme>() ??
        const VerseGridTheme();
  }

  @override
  VerseGridTheme copyWith({
    double? verseNumberColumnWidth,
    double? rowVerticalPadding,
    double? columnVerticalPadding,
    double? gapOriginalToTranslation,
    double? gapOriginalToTranslationCompact,
    double? defaultOriginalFontSize,
    double? defaultTranslationFontSize,
    double? defaultVerseNumberFontSize,
  }) {
    return VerseGridTheme(
      verseNumberColumnWidth:
          verseNumberColumnWidth ?? this.verseNumberColumnWidth,
      rowVerticalPadding: rowVerticalPadding ?? this.rowVerticalPadding,
      columnVerticalPadding:
          columnVerticalPadding ?? this.columnVerticalPadding,
      gapOriginalToTranslation:
          gapOriginalToTranslation ?? this.gapOriginalToTranslation,
      gapOriginalToTranslationCompact: gapOriginalToTranslationCompact ??
          this.gapOriginalToTranslationCompact,
      defaultOriginalFontSize:
          defaultOriginalFontSize ?? this.defaultOriginalFontSize,
      defaultTranslationFontSize:
          defaultTranslationFontSize ?? this.defaultTranslationFontSize,
      defaultVerseNumberFontSize:
          defaultVerseNumberFontSize ?? this.defaultVerseNumberFontSize,
    );
  }

  @override
  ThemeExtension<VerseGridTheme> lerp(
    ThemeExtension<VerseGridTheme>? other,
    double t,
  ) {
    if (other is! VerseGridTheme) return this;
    return VerseGridTheme(
      verseNumberColumnWidth:
          _lerpDouble(verseNumberColumnWidth, other.verseNumberColumnWidth, t),
      rowVerticalPadding:
          _lerpDouble(rowVerticalPadding, other.rowVerticalPadding, t),
      columnVerticalPadding:
          _lerpDouble(columnVerticalPadding, other.columnVerticalPadding, t),
      gapOriginalToTranslation: _lerpDouble(
          gapOriginalToTranslation, other.gapOriginalToTranslation, t),
      gapOriginalToTranslationCompact: _lerpDouble(
          gapOriginalToTranslationCompact,
          other.gapOriginalToTranslationCompact,
          t),
      defaultOriginalFontSize: _lerpDouble(
          defaultOriginalFontSize, other.defaultOriginalFontSize, t),
      defaultTranslationFontSize: _lerpDouble(
          defaultTranslationFontSize, other.defaultTranslationFontSize, t),
      defaultVerseNumberFontSize: _lerpDouble(
          defaultVerseNumberFontSize, other.defaultVerseNumberFontSize, t),
    );
  }

  double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
