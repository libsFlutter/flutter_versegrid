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
}
