import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_versegrid/flutter_versegrid.dart';

class _Item {
  const _Item(this.pos);
  final int pos;
}

void main() {
  test('groupConsecutiveByPosition yields singleton ranges when spaced apart', () {
    final items = [_Item(1), _Item(3), _Item(4), _Item(7)];
    final ranges = groupConsecutiveByPosition(
      items,
      position: (x) => x.pos,
      buildLabel: (g) => g.map((e) => e.pos.toString()).join(','),
    );
    expect(ranges.length, 3);
    expect(ranges[0].items.map((e) => e.pos).toList(), [1]);
    expect(ranges[1].items.map((e) => e.pos).toList(), [3, 4]);
    expect(ranges[2].items.map((e) => e.pos).toList(), [7]);
  });

  test('VerseRange.contains respects predicate', () {
    const r = VerseRange<int>(
      items: [1, 2],
      label: '1-2',
    );
    expect(r.contains((i) => i == 2), isTrue);
    expect(r.contains((i) => i == 3), isFalse);
  });

  test('VerseRange.copyWith merges semantics', () {
    const r = VerseRange<int>(items: [1], label: '1');
    final r2 = r.copyWith(semanticsLabel: 'Chapter 2, verse 1');
    expect(r2.semanticsLabel, 'Chapter 2, verse 1');
    expect(r2.label, '1');
    final r3 = r2.copyWith(clearSemanticsLabel: true);
    expect(r3.semanticsLabel, isNull);
  });

  test('groupConsecutiveRuns uses custom adjacency', () {
    final items = ['a', 'bb', 'ccc', 'dddd'];
    final ranges = groupConsecutiveRuns<String>(
      items,
      sort: (a, b) => a.length.compareTo(b.length),
      belongsWithPrevious: (prev, curr) =>
          curr.length == prev.length + 1,
      buildLabel: (g) => g.join('|'),
    );
    expect(ranges.length, 1);
    expect(ranges.single.items.join(','), 'a,bb,ccc,dddd');
  });
}
