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

  group('isEmpty', () {
    test('returns false for non-empty cell', () {
      final charGrid = CharGrid(size);
      charGrid.set(cell, 'X');

      final bool empty = charGrid.isEmpty(cell);

      expect(empty, isFalse);
    });

    test('returns true for empty cell', () {
      final charGrid = CharGrid(size);
      charGrid.set(cell, ' ');

      final bool empty = charGrid.isEmpty(cell);

      expect(empty, isTrue);
    });

    test('returns true for cell outside grid', () {
      final charGrid = CharGrid(size);
      final cellOutsideGrid = GridCell(size.width, size.height);

      final bool empty = charGrid.isEmpty(cellOutsideGrid);

      expect(empty, isTrue);
    });
  });

  test('emptiness returns correct emptiness values', () {
    const size = GridSize(13, 13);
    final charGrid = CharGrid(size);

    // set each corner to be non-empty
    charGrid.set(const GridCell(0, 0), 'X');
    charGrid.set(GridCell(size.width - 1, 0), 'X');
    charGrid.set(GridCell(0, size.height - 1), 'X');
    charGrid.set(GridCell(size.width - 1, size.height - 1), 'X');

    final List<double> emptinessValues =
        size.cells.map(charGrid.emptiness).toList();
    final Iterable<Iterable<double>> emptinessValuesByRow =
        Iterable<int>.generate(size.height)
            .map((y) => emptinessValues.skip(y * size.width).take(size.width));

    expect(emptinessValuesByRow, [
      [0.0, 0.0, 0.4, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.4, 0.0, 0.0],
      [0.0, 0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.2, 0.0, 0.0],
      [0.4, 0.2, 0.2, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.2, 0.2, 0.4],
      [0.4, 0.4, 0.4, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.4, 0.4, 0.4],
      [0.6, 0.6, 0.6, 0.6, 0.6, 0.8, 1.0, 0.8, 0.6, 0.6, 0.6, 0.6, 0.6],
      [0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 1.0, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8],
      [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
      [0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 1.0, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8],
      [0.6, 0.6, 0.6, 0.6, 0.6, 0.8, 1.0, 0.8, 0.6, 0.6, 0.6, 0.6, 0.6],
      [0.4, 0.4, 0.4, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.4, 0.4, 0.4],
      [0.4, 0.2, 0.2, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.2, 0.2, 0.4],
      [0.0, 0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.2, 0.0, 0.0],
      [0.0, 0.0, 0.4, 0.4, 0.6, 0.8, 1.0, 0.8, 0.6, 0.4, 0.4, 0.0, 0.0]
    ]);
  });

  test(
      'text returns grid rendered as text, replacing empty cells by white squares',
      () {
    final charGrid = CharGrid(size, background: 'B');
    charGrid.set(cell, ' ');

    expect(charGrid.text, 'BB\nBB\nBB\nB▫\nBB\nBB\nBB\nBB');
  });
}
