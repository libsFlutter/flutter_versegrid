import 'package:flutter/material.dart';
import 'package:flutter_versegrid/flutter_versegrid.dart';

void main() {
  runApp(const VersegridGalleryApp());
}

class VersegridGalleryApp extends StatelessWidget {
  const VersegridGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_versegrid',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        extensions: const [
          VerseGridTheme(),
        ],
      ),
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
    [1, 2, 4, 5, 6, 9],
    position: (x) => x,
    buildLabel: (g) =>
        g.length == 1 ? '${g.single}' : '${g.first}-${g.last}',
  );

  int _selected = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_versegrid')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('VersePassage (tablet row)', style: Theme.of(context).textTheme.titleMedium),
          VersePassage(
            verseNumber: 3,
            primary: 'jaya jaya girirājer ārati viśāla',
            secondary: 'All glories to the grand ārati…',
            layout: VersePassageLayout.tabletRow,
          ),
          const SizedBox(height: 24),
          Text('VersePassage (column)', style: Theme.of(context).textTheme.titleMedium),
          VersePassage(
            primary: 'jaśomatī-nandana braja-baro nāgara',
            secondary: 'The son of Yaśodā…',
            layout: VersePassageLayout.columnCenter,
          ),
          const SizedBox(height: 24),
          Text('Verse ranges', style: Theme.of(context).textTheme.titleMedium),
          VerseRangeChipStrip<int>(
            ranges: _ranges,
            isRangeSelected: (range) => range.contains((i) => i == _selected),
            onRangeTap: (range) => setState(() => _selected = range.items.first),
            chipBuilder: (context, range, selected, onTap) {
              return ChoiceChip(
                label: Text(range.label),
                selected: selected,
                onSelected: (_) => onTap(),
              );
            },
          ),
        ],
      ),
    );
  }
}
