# Specifications: page-style-registry

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-05  
> Requirements: `01-requirements.md`

## Overview

Add a host-supplied **paragraph style registry** to `flutter_versegrid` and extend paragraph blocks to reference styles by key. Integrate style resolution into `VersePageRenderer` while keeping the package theme-agnostic and backward compatible.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `flutter_versegrid/lib/src/models/verse_page_block.dart` | Modify | Extend paragraph block with `styleKey` (and optional `textAlign`). |
| `flutter_versegrid/lib/src/widgets/verse_page_renderer.dart` | Modify | Resolve style and apply alignment/background when rendering paragraphs. |
| `flutter_versegrid/lib/src/theme/...` | Create/Modify | Optional theme extension to carry registry. |
| `flutter_versegrid/flows/...` | Docs | This SDD set. |

## Architecture

### Style Resolution Options

Support one or both:

1. **Callback-based**: `VersePageRenderer(paragraphStyleResolver: ...)`
2. **Theme-based**: `VerseGridThemeData(paragraphStyles: VerseParagraphStyleRegistry(...))`

Prefer Theme-based for consistency with existing theming patterns, but keep an escape hatch callback for apps that do not want to wire Theme extensions.

### Data Types

```dart
/// Host-provided resolver from a style key to a style description.
typedef VerseParagraphStyleResolver = VerseParagraphStyle? Function(
  BuildContext context,
  String styleKey,
);

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
```

### Block Shape

Extend `VerseParagraphBlock`:

- `styleKey`: `String?` (optional, for backward compat)
- `textAlign`: `TextAlign?` (optional override)

Precedence:

1. Block explicit `textAlign` (highest)
2. Resolved style `textAlign`
3. Default `Text` behavior

## Behavior Specifications

### Happy Path

1. Renderer sees `VerseParagraphBlock(styleKey: 'quote')`.
2. Renderer resolves `VerseParagraphStyle` using theme or callback.
3. Renderer applies decoration/padding wrapper if present.
4. Renderer renders text (with highlight, if active) using resolved `TextStyle` and alignment.

### Edge Cases

| Case | Trigger | Expected Behavior |
|------|---------|-------------------|
| Missing style key | `styleKey == null` | Render using `paragraphStyle ?? Theme.of(context).textTheme.bodyLarge`. |
| Unknown key | Resolver returns null | Fall back to default paragraph rendering. |
| Conflicting alignment | block has `textAlign` and style has `textAlign` | Block wins. |

### Error Handling

| Error | Cause | Response |
|-------|-------|----------|
| Resolver throws | Host bug | Catch (optional) and fall back to default rendering. |

## Testing Strategy

### Unit Tests

- Resolve known and unknown style keys.
- Alignment precedence (block vs style vs default).
- Highlight rendering does not lose style.

### Manual Verification

- Render a page containing multiple paragraphs with different `styleKey` values.
- Verify visuals match expected baseline styles.

## Open Design Questions

- Should paragraph background be `Color` or `Decoration`?
- Do we need `TextDirection` or `StrutStyle` hooks for scripts/fonts?

