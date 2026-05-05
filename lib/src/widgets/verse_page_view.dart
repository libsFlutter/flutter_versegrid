import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/verse_page.dart';
import 'verse_page_renderer.dart';

/// Simple page transition presets for [VersePageView].
enum VersePageTransitionPreset { none, fade, scale, fadeAndScale }

enum VerseChromeAction {
  prevPage,
  nextPage,
  openSearch,
  openBookmarks,
  addBookmark,
  playAudio,
  stopAudio,
  togglePlayer,
}

typedef VerseChromeActionCallback = void Function(
  VerseChromeAction action, {
  required String pageId,
  required int pageIndex,
});

typedef VersePageChromeBuilder = Widget Function(
  BuildContext context, {
  required VersePage page,
  required int pageIndex,
  required int pageCount,
  required VerseChromeActionCallback onAction,
});

typedef VersePageTransitionBuilder = Widget Function(
  BuildContext context, {
  required Widget child,
  required int index,
  required double page,
});

/// Page-level reader with swipe navigation and optional in-page transitions.
class VersePageView extends StatefulWidget {
  const VersePageView({
    super.key,
    required this.pages,
    this.initialPage = 0,
    this.onPageChanged,
    this.transitionPreset = VersePageTransitionPreset.none,
    this.transitionBuilder,
    this.viewportFraction = 1.0,
    this.physics,
    this.rendererBuilder,
    this.chromeBuilder,
    this.onChromeAction,
    this.highlightQuery,
    this.highlightStyle,
    this.highlightCaseSensitive = false,
    this.onPageLinkTap,
  }) : assert(viewportFraction > 0);

  final List<VersePage> pages;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;

  final VersePageTransitionPreset transitionPreset;
  final VersePageTransitionBuilder? transitionBuilder;
  final double viewportFraction;
  final ScrollPhysics? physics;

  /// Override how each page is rendered. Defaults to [VersePageRenderer].
  final Widget Function(BuildContext context, VersePage page)? rendererBuilder;

  /// Optional page chrome overlay (controls, toolbars, etc).
  final VersePageChromeBuilder? chromeBuilder;

  /// Called when chrome triggers an action.
  final VerseChromeActionCallback? onChromeAction;

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
        final baseChild =
            (widget.rendererBuilder ?? _defaultRendererBuilder)(context, page);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final pageValue = _controller.hasClients && _controller.position.haveDimensions
                ? (_controller.page ?? _controller.initialPage.toDouble())
                : _controller.initialPage.toDouble();

            final offset = (pageValue - index).clamp(-1.0, 1.0);
            final isVisible = offset.abs() < 0.5;

            Widget child = baseChild;

            final overlays = page.overlays;
            final hasOverlays = overlays.isNotEmpty;
            final hasChrome = widget.chromeBuilder != null;
            if (hasOverlays || hasChrome) {
              child = Stack(
                fit: StackFit.passthrough,
                children: [
                  if (hasOverlays)
                    for (final o in overlays)
                      Positioned.fill(
                        child: Listener(
                          behavior: o.hitTestBehavior,
                          child: o.builder(
                            context,
                            page,
                            VersePageOverlayLifecycle(
                              isVisible: isVisible,
                              pageIndex: index,
                              pageOffset: offset,
                            ),
                          ),
                        ),
                      ),
                  child,
                  if (hasChrome)
                    widget.chromeBuilder!(
                      context,
                      page: page,
                      pageIndex: index,
                      pageCount: widget.pages.length,
                      onAction: (action, {required pageId, required pageIndex}) =>
                          widget.onChromeAction?.call(
                        action,
                        pageId: pageId,
                        pageIndex: pageIndex,
                      ),
                    ),
                ],
              );
            }

            if (widget.transitionBuilder != null) {
              return widget.transitionBuilder!(
                context,
                child: child,
                index: index,
                page: pageValue,
              );
            }

            if (widget.transitionPreset == VersePageTransitionPreset.none) {
              return child;
            }

            final delta = offset.abs().clamp(0.0, 1.0);
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

