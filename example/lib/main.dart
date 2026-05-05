import 'package:flutter/material.dart';
import 'package:flutter_versegrid/flutter_versegrid.dart';

void main() {
  runApp(const VersegridGalleryApp());
}

/// Sample verse data for the gallery (Sanskrit + transliteration + translation).
class _DemoVerse {
  const _DemoVerse({
    required this.number,
    required this.sanskrit,
    required this.transliteration,
    required this.translationEn,
    required this.translationRu,
  });

  final int number;
  final String sanskrit;
  final String transliteration;
  final String translationEn;
  final String translationRu;
}

const List<_DemoVerse> _demoVerses = [
  _DemoVerse(
    number: 1,
    sanskrit:
        'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥',
    transliteration:
        'karmaṇy-evādhikāras te mā phaleṣhu kadāchana |\nmā karma-phala-hetur bhūr mā te saṅgo ’stv akarmaṇi ||',
    translationEn:
        'You have the right to work only, but never to its fruits. Let not the fruits of action be your motive, nor let your attachment be to inaction.',
    translationRu:
        'Твоё право — лишь на действие, никогда — на плоды действия. Не делай действия ради плода и не впадай в бездействие из привязанности.',
  ),
  _DemoVerse(
    number: 2,
    sanskrit:
        'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय ।\nसिद्ध्यसिद्धयोः समो भूत्वा समत्वं योग उच्यते ॥',
    transliteration:
        'yoga-sthaḥ kuru karmāṇi saṅgaṃ tyaktvā dhanañjaya |\nsiddhy-asiddhyoḥ samo bhūtvā samatvaṃ yoga uchyate ||',
    translationEn:
        'Perform action, O Dhananjaya, remaining steadfast in yoga, abandoning attachment, and remaining the same toward success and failure — such equanimity is called yoga.',
    translationRu:
        'Твори действия, о Дхананджая, пребывая в йоге, отбросив пристрастие и будучи равным к успеху и неудаче: такое равновесие называют йогой.',
  ),
  _DemoVerse(
    number: 3,
    sanskrit:
        'बुद्धियुक्तो जहातीह उभे सुकृतदुष्कृते ।\nतस्माद्योगाय युज्यस्व योगः कर्मसु कौशलम् ॥',
    transliteration:
        'buddhi-yukto jahātīha ubhe sukṛta-duṣkṛte |\ntasmād yogāya yujyasva yogaḥ karmasu kauśalam ||',
    translationEn:
        'One who is endowed with discrimination sheds virtue and vice alike here in this world; therefore devote yourself to yoga — yoga is skill in actions.',
    translationRu:
        'Наделённый различением оставляет здесь и добродетель, и порок; посвяти себя же йоге — йога есть искусство в действиях.',
  ),
];

class VersegridGalleryApp extends StatelessWidget {
  const VersegridGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_versegrid',
      theme: VerseGridColorPalette.lightTheme(),
      home: const _GalleryPage(),
    );
  }
}

class _GalleryPage extends StatefulWidget {
  const _GalleryPage();

  @override
  State<_GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<_GalleryPage> {
  late final List<VerseRange<int>> _ranges = groupConsecutiveByPosition<int>(
    _demoVerses.map((v) => v.number).toList(),
    position: (x) => x,
    buildLabel: (g) =>
        g.length == 1 ? '${g.single}' : '${g.first}–${g.last}',
  );

  int _selectedVerseNumber = _demoVerses.first.number;
  final Set<int> _bookmarkedVerseNumbers = {1, 3};
  bool _showRussianTranslation = true;
  bool _showReaderDemo = false;
  String _highlightQuery = 'yoga';
  late final TextEditingController _highlightController =
      TextEditingController(text: _highlightQuery);

  _DemoVerse get _selectedVerse => _demoVerses.firstWhere(
        (v) => v.number == _selectedVerseNumber,
        orElse: () => _demoVerses.first,
      );

  String get _translation =>
      _showRussianTranslation ? _selectedVerse.translationRu : _selectedVerse.translationEn;

  List<VersePage> get _demoPages {
    final v1 = _demoVerses[0];
    final v2 = _demoVerses[1];
    final v3 = _demoVerses[2];

    return [
      VersePage(
        id: 'p1',
        semanticsLabel: 'Demo page 1',
        blocks: [
          const VerseParagraphBlock(
            text:
                'VersePageView demo: swipe horizontally. This page includes paragraphs, passages, and a page link.',
          ),
          VersePassageBlock(
            primary: v1.transliteration,
            secondary: v1.translationEn,
            verseNumber: v1.number,
            semanticsLabel: 'Verse ${v1.number}',
          ),
          const VersePageLinkBlock(
            targetPageId: 'p3',
            label: 'Jump to page 3 (link block)',
          ),
        ],
      ),
      VersePage(
        id: 'p2',
        semanticsLabel: 'Demo page 2',
        blocks: [
          const VerseParagraphBlock(
            text:
                'Try changing the highlight query below (default is "yoga").',
          ),
          VersePassageBlock(
            primary: v2.translationEn,
            secondary: '…such equanimity is called yoga.',
            verseNumber: v2.number,
            semanticsLabel: 'Verse ${v2.number}',
          ),
        ],
      ),
      VersePage(
        id: 'p3',
        semanticsLabel: 'Demo page 3',
        blocks: [
          const VerseParagraphBlock(
            text:
                'This page demonstrates a custom block. Host apps can render arbitrary payloads.',
          ),
          VerseCustomBlock<String>('Custom payload: "${v3.translationEn}"'),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _highlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_versegrid')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Page-level reader (VersePageView)',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Демо “страница из блоков” + свайпы + transitions + подсветка поиска.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Показать reader demo'),
                  value: _showReaderDemo,
                  onChanged: (v) => setState(() => _showReaderDemo = v),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<VersePageTransitionPreset>(
                value: VersePageTransitionPreset.fadeAndScale,
                items: const [
                  DropdownMenuItem(
                    value: VersePageTransitionPreset.none,
                    child: Text('none'),
                  ),
                  DropdownMenuItem(
                    value: VersePageTransitionPreset.fade,
                    child: Text('fade'),
                  ),
                  DropdownMenuItem(
                    value: VersePageTransitionPreset.scale,
                    child: Text('scale'),
                  ),
                  DropdownMenuItem(
                    value: VersePageTransitionPreset.fadeAndScale,
                    child: Text('fade+scale'),
                  ),
                ],
                onChanged: null, // fixed in demo to keep state simple
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Highlight query',
              hintText: 'e.g. yoga',
              border: OutlineInputBorder(),
            ),
            controller: _highlightController,
            onChanged: (v) => setState(() => _highlightQuery = v),
          ),
          const SizedBox(height: 12),
          if (_showReaderDemo)
            SizedBox(
              height: 320,
              child: Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                child: VersePageView(
                  pages: _demoPages,
                  transitionPreset: VersePageTransitionPreset.fadeAndScale,
                  highlightQuery: _highlightQuery,
                  onPageLinkTap: (targetId) {
                    final idx = _demoPages.indexWhere((p) => p.id == targetId);
                    if (idx >= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Link tapped → $targetId (index $idx)')),
                      );
                    }
                  },
                  rendererBuilder: (context, page) {
                    return VersePageRenderer(
                      page: page,
                      highlightQuery: _highlightQuery,
                      highlightStyle: theme.textTheme.bodyLarge?.copyWith(
                        backgroundColor: theme.colorScheme.tertiaryContainer,
                      ),
                      onPageLinkTap: (targetId) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Link tapped → $targetId')),
                        );
                      },
                      customBlockBuilder: (context, block) {
                        final payload = block.payload;
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: theme.colorScheme.outlineVariant),
                          ),
                          child: Text(
                            payload is String ? payload : payload.toString(),
                            style: theme.textTheme.bodyMedium,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
          else
            Text(
              'Включи переключатель выше, чтобы увидеть PageView-ридер.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          const SizedBox(height: 28),
          Text(
            'Шлоки и переводы',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите стих — ниже показаны санскрит, транслитерация и перевод через VersePassage.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Стих',
                  style: theme.textTheme.titleSmall,
                ),
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('RU'),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('EN'),
                  ),
                ],
                selected: {_showRussianTranslation},
                onSelectionChanged: (selection) {
                  setState(() {
                    _showRussianTranslation = selection.single;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          VerseRangeChipStrip<int>(
            ranges: _ranges,
            isRangeSelected: (range) =>
                range.contains((i) => i == _selectedVerseNumber),
            onRangeTap: (range) => setState(() {
              _selectedVerseNumber = range.items.first;
            }),
            chipBuilder: (context, range, selected, onTap) {
              return ChoiceChip(
                label: Text(range.label),
                selected: selected,
                onSelected: (_) => onTap(),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'VerseNumberGrid (legacy 7×N)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Фиксированная сетка номеров (7 колонок), выделение выбранного и индикатор закладки.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 12),
          VerseNumberGrid<int>(
            items: [
              for (final v in _demoVerses)
                VerseNumberGridItem<int>(
                  value: v.number,
                  label: '${v.number}',
                  bookmarked: _bookmarkedVerseNumbers.contains(v.number),
                  semanticsLabel: 'Chapter 2, verse ${v.number}',
                ),
            ],
            isSelected: (item) => item.value == _selectedVerseNumber,
            onItemTap: (item) => setState(() {
              _selectedVerseNumber = item.value;
            }),
            cellBuilder: (context, item, selected, size, onTap) {
              return SizedBox(
                width: size,
                height: size,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(size / 2),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceContainerHighest,
                              border: selected
                                  ? null
                                  : Border.all(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item.label,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        if (item.bookmarked)
                          Positioned(
                            top: size * 0.12,
                            right: size * 0.12,
                            child: Container(
                              width: size * 0.2,
                              height: size * 0.2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.35,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionTitle(
                    'Санскрит',
                    theme,
                  ),
                  VersePassage(
                    layout: VersePassageLayout.columnCenter,
                    primary: _selectedVerse.sanskrit,
                    primaryTextAlign: TextAlign.center,
                  ),
                  _divider(theme),
                  _SectionTitle('Транслитерация (IAST)', theme),
                  VersePassage(
                    layout: VersePassageLayout.columnStretch,
                    primary: _selectedVerse.transliteration,
                    primaryStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
                    primaryTextAlign: TextAlign.start,
                  ),
                  _divider(theme),
                  _SectionTitle(
                    _showRussianTranslation ? 'Перевод (RU)' : 'Translation (EN)',
                    theme,
                  ),
                  VersePassage(
                    layout: VersePassageLayout.columnStretch,
                    primary: _translation,
                    primaryStyle: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                    primaryTextAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Один виджет: первичный текст + перевод под ним',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'VersePassage с полем secondary — как в строфах Gitanjali.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 560;
              if (wide) {
                return VersePassage(
                  verseNumber: _selectedVerse.number,
                  layout: VersePassageLayout.tabletRow,
                  primary: _selectedVerse.sanskrit,
                  secondary: _translation,
                  primaryTextAlign: TextAlign.center,
                  secondaryTextAlign: TextAlign.center,
                );
              }
              return VersePassage(
                layout: VersePassageLayout.columnCenter,
                primary: _selectedVerse.sanskrit,
                secondary: _translation,
              );
            },
          ),
          const SizedBox(height: 28),
          Text(
            'VersePassage (column, без номера)',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          VersePassage(
            primary: 'jaśomatī-nandana braja-baro nāgara',
            secondary: 'The son of Yaśodā, the hero of Vraja…',
            layout: VersePassageLayout.columnCenter,
          ),
          const SizedBox(height: 28),
          Text(
            'Verse ranges (groupConsecutiveByPosition)',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          VerseRangeChipStrip<int>(
            ranges: groupConsecutiveByPosition<int>(
              [1, 2, 4, 5, 6, 9],
              position: (x) => x,
              buildLabel: (g) =>
                  g.length == 1 ? '${g.single}' : '${g.first}-${g.last}',
            ),
            isRangeSelected: (range) => range.contains((i) => i == 2),
            onRangeTap: (_) {},
            chipBuilder: (context, range, selected, onTap) {
              return FilterChip(
                label: Text(range.label),
                selected: selected,
                onSelected: (_) => onTap(),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Подсказка: при ширине ≥ 560 px блок выше переключается на tabletRow с номером стиха.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label, this.theme);

  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
