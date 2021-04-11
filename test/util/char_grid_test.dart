import 'package:mojidraw/util/char_grid.dart';
import 'package:mojidraw/util/grid_cell.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:test/test.dart';

void main() {
  const size = GridSize(2, 8);
  const cell = GridCell(1, 3);

  test('generate creates grid according to provided size and generator', () {
    final charGrid =
        CharGrid.generate(size, (GridCell c) => c == cell ? 'X' : ' ');

    expect(charGrid.get(cell), 'X');
  });

  <String, GridCell>{
    'left': const GridCell(-1, 3),
    'top': const GridCell(1, -1),
    'right': const GridCell(2, 3),
    'bottom': const GridCell(1, 8),
  }.forEach((description, cell) {
    test('get returns null when cell is out of range ($description)', () {
      final charGrid = CharGrid(size);

      expect(charGrid.get(cell), isNull);
    });
  });

  group('given no background character', () {
    final charGrid = CharGrid(size);

    test('get returns space when not specified using set', () {
      expect(charGrid.get(cell), ' ');
    });

    test('get returns character specified using set', () {
      charGrid.set(cell, 'F');

      expect(charGrid.get(cell), 'F');
    });
  });

  group('given a background character', () {
    final charGrid = CharGrid(size, background: 'B');

    test('get returns background character when not specified using set', () {
      expect(charGrid.get(cell), 'B');
    });

    test('get returns character specified using set', () {
      charGrid.set(cell, 'F');

      expect(charGrid.get(cell), 'F');
    });
  });

  test('text returns grid rendered as text', () {
    final charGrid = CharGrid(size, background: 'B');
    charGrid.set(cell, 'F');

    expect(charGrid.text, 'BB\nBB\nBB\nBF\nBB\nBB\nBB\nBB');
  });
}
