import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/verse_page.dart';
import 'verse_page_renderer.dart';

/// Simple page transition presets for [VersePageView].
enum VersePageTransitionPreset { none, fade, scale, fadeAndScale }

/// Page-level reader with swipe navigation and optional in-page transitions.
class VersePageView extends StatefulWidget {
  const VersePageView({
    super.key,
    required this.pages,
    this.initialPage = 0,
    this.onPageChanged,
    this.transitionPreset = VersePageTransitionPreset.none,
    this.viewportFraction = 1.0,
    this.physics,
    this.rendererBuilder,
    this.highlightQuery,
    this.highlightStyle,
    this.highlightCaseSensitive = false,
    this.onPageLinkTap,
  }) : assert(viewportFraction > 0);

  final List<VersePage> pages;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;

  final VersePageTransitionPreset transitionPreset;
  final double viewportFraction;
  final ScrollPhysics? physics;

  /// Override how each page is rendered. Defaults to [VersePageRenderer].
  final Widget Function(BuildContext context, VersePage page)? rendererBuilder;

  final String? highlightQuery;
  final TextStyle? highlightStyle;
  final bool highlightCaseSensitive;

  final ValueChanged<String /* targetPageId */ >? onPageLinkTap;

  @override
  State<VersePageView> createState() => _VersePageViewState();
}

class _VersePageViewState extends State<VersePageView> {
  late final PageController _controller = PageController(
    initialPage: widget.initialPage,
    viewportFraction: widget.viewportFraction,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pages.isEmpty) return const SizedBox.shrink();

    return PageView.builder(
      controller: _controller,
      physics: widget.physics,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.pages.length,
      itemBuilder: (context, index) {
        final page = widget.pages[index];
        final child =
            (widget.rendererBuilder ?? _defaultRendererBuilder)(context, page);

        if (widget.transitionPreset == VersePageTransitionPreset.none) {
          return child;
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final pageValue = _controller.hasClients && _controller.position.haveDimensions
                ? (_controller.page ?? _controller.initialPage.toDouble())
                : _controller.initialPage.toDouble();
            final delta = (pageValue - index).abs().clamp(0.0, 1.0);
            final t = 1.0 - delta; // 1 when focused, 0 when fully offscreen

            var opacity = 1.0;
            var scale = 1.0;

            switch (widget.transitionPreset) {
              case VersePageTransitionPreset.fade:
                opacity = 0.35 + 0.65 * t;
              case VersePageTransitionPreset.scale:
                scale = 0.92 + 0.08 * t;
              case VersePageTransitionPreset.fadeAndScale:
                opacity = 0.35 + 0.65 * t;
                scale = 0.92 + 0.08 * t;
              case VersePageTransitionPreset.none:
                break;
            }

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
        );
      },
    );
  }

  Widget _defaultRendererBuilder(BuildContext context, VersePage page) {
    return VersePageRenderer(
      page: page,
      highlightQuery: widget.highlightQuery,
      highlightStyle: widget.highlightStyle,
      highlightCaseSensitive: widget.highlightCaseSensitive,
      onPageLinkTap: widget.onPageLinkTap,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: math.max(12, MediaQuery.paddingOf(context).top),
      ),
    );
  }
}

