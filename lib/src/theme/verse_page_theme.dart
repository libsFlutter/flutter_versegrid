import 'package:flutter/material.dart';

/// Page-level theming and registries for `flutter_versegrid` page renderer/view.
@immutable
class VersePageTheme extends ThemeExtension<VersePageTheme> {
  const VersePageTheme({
    this.paragraphStyles,
  });

  final VerseParagraphStyleRegistry? paragraphStyles;

  static VersePageTheme of(BuildContext context) {
    return Theme.of(context).extension<VersePageTheme>() ??
        const VersePageTheme();
  }

  @override
  VersePageTheme copyWith({
    VerseParagraphStyleRegistry? paragraphStyles,
  }) {
    return VersePageTheme(
      paragraphStyles: paragraphStyles ?? this.paragraphStyles,
    );
  }

  @override
  ThemeExtension<VersePageTheme> lerp(
    ThemeExtension<VersePageTheme>? other,
    double t,
  ) {
    if (other is! VersePageTheme) return this;
    // Registries are not meaningfully interpolatable.
    return t < 0.5 ? this : other;
  }
}

@immutable
class VerseParagraphStyleRegistry {
  const VerseParagraphStyleRegistry({
    required this.styles,
    this.fallback,
  });

  final Map<String, VerseParagraphStyle> styles;
  final VerseParagraphStyle? fallback;

  VerseParagraphStyle? resolve(String key) => styles[key] ?? fallback;
}

@immutable
class VerseParagraphStyle {
  const VerseParagraphStyle({
    this.textStyle,
    this.textAlign,
    this.background,
    this.padding,
  });

  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final BoxDecoration? background;
  final EdgeInsetsGeometry? padding;
}

