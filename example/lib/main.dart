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
  bool _showRussianTranslation = true;

  _DemoVerse get _selectedVerse => _demoVerses.firstWhere(
        (v) => v.number == _selectedVerseNumber,
        orElse: () => _demoVerses.first,
      );

  String get _translation =>
      _showRussianTranslation ? _selectedVerse.translationRu : _selectedVerse.translationEn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_versegrid')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
