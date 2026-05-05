import 'package:flutter/material.dart';

import '../theme/verse_grid_theme.dart';

/// Layout strategy for [VersePassage].
enum VersePassageLayout {
  /// Optional verse index column + centered body + balancing gutter (tablet).
  tabletRow,

  /// Stacked centered lines (phone / single-column readers).
  columnCenter,

  /// Stretched column (e.g. prose translation blocks).
  columnStretch,
}

/// Displays primary verse line(s) with optional secondary line (translation).
///
/// Used by Gitanjali-style verses and Bhagavad Gita section bodies. Typography
/// comes from [primaryStyle] / [secondaryStyle], falling back to [Theme.textTheme].
class VersePassage extends StatelessWidget {
  const VersePassage({
    super.key,
    required this.primary,
    this.secondary,
    this.verseNumber,
    this.layout = VersePassageLayout.columnCenter,
    this.textScaleFactor = 1.0,
    this.primaryStyle,
    this.secondaryStyle,
    this.verseNumberStyle,
    this.primaryTextAlign,
    this.secondaryTextAlign,
  });

  /// Main text (e.g. Sanskrit, transliteration, or translation prose).
  final String primary;

  /// Optional translation or commentary line beneath [primary].
  final String? secondary;

  /// Verse index shown in the side column when [layout] is [tabletRow].
  final int? verseNumber;

  final VersePassageLayout layout;

  /// Applied to font sizes resolved from theme defaults.
  final double textScaleFactor;

  final TextStyle? primaryStyle;
  final TextStyle? secondaryStyle;
  final TextStyle? verseNumberStyle;

  final TextAlign? primaryTextAlign;
  final TextAlign? secondaryTextAlign;

  @override
  Widget build(BuildContext context) {
    final vg = VerseGridTheme.of(context);
    final theme = Theme.of(context);

    final basePrimary = primaryStyle ??
        theme.textTheme.bodyLarge?.copyWith(
              fontSize: vg.defaultOriginalFontSize,
              fontWeight: FontWeight.w500,
            ) ??
        TextStyle(fontSize: vg.defaultOriginalFontSize);

    final baseSecondary = secondaryStyle ??
        theme.textTheme.bodyMedium?.copyWith(
              fontSize: vg.defaultTranslationFontSize,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.74),
            ) ??
        TextStyle(fontSize: vg.defaultTranslationFontSize);

    final baseVerseNumber = verseNumberStyle ??
        theme.textTheme.labelMedium?.copyWith(
              fontSize: vg.defaultVerseNumberFontSize,
            ) ??
        TextStyle(fontSize: vg.defaultVerseNumberFontSize);

    final scaledPrimary = basePrimary.copyWith(
      fontSize: (basePrimary.fontSize ?? vg.defaultOriginalFontSize) *
          textScaleFactor,
    );
    final scaledSecondary = baseSecondary.copyWith(
      fontSize: (baseSecondary.fontSize ?? vg.defaultTranslationFontSize) *
          textScaleFactor,
    );
    final scaledVerseNumber = baseVerseNumber.copyWith(
      fontSize: (baseVerseNumber.fontSize ?? vg.defaultVerseNumberFontSize) *
          textScaleFactor,
    );

    final secondaryTrimmed = secondary?.trim();
    final showSecondary =
        secondaryTrimmed != null && secondaryTrimmed.isNotEmpty;

    switch (layout) {
      case VersePassageLayout.tabletRow:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: vg.rowVerticalPadding / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: vg.verseNumberColumnWidth,
                child: verseNumber != null
                    ? Text(
                        '$verseNumber',
                        style: scaledVerseNumber,
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      primary,
                      textAlign: primaryTextAlign ?? TextAlign.center,
                      style: scaledPrimary,
                    ),
                    if (showSecondary) ...[
                      SizedBox(height: vg.gapOriginalToTranslation),
                      Text(
                        secondaryTrimmed,
                        textAlign: secondaryTextAlign ?? TextAlign.center,
                        style: scaledSecondary,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: vg.verseNumberColumnWidth),
            ],
          ),
        );

      case VersePassageLayout.columnCenter:
        return Padding(
          padding:
              EdgeInsets.symmetric(vertical: vg.columnVerticalPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                primary,
                textAlign: primaryTextAlign ?? TextAlign.center,
                style: scaledPrimary,
              ),
              if (showSecondary) ...[
                SizedBox(height: vg.gapOriginalToTranslationCompact),
                Text(
                  secondaryTrimmed,
                  textAlign: secondaryTextAlign ?? TextAlign.center,
                  style: scaledSecondary,
                ),
              ],
            ],
          ),
        );

      case VersePassageLayout.columnStretch:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              primary,
              textAlign: primaryTextAlign ?? TextAlign.start,
              style: scaledPrimary,
            ),
            if (showSecondary) ...[
              SizedBox(height: vg.gapOriginalToTranslationCompact),
              Text(
                secondaryTrimmed,
                textAlign: secondaryTextAlign ?? TextAlign.start,
                style: scaledSecondary,
              ),
            ],
          ],
        );
    }
  }
}
