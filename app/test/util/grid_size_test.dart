import 'package:mojidraw/util/grid_cell.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:test/test.dart';

void main() {
  const size = GridSize(2, 4);

  test('cellCount returns number of cells', () {
    expect(size.cellCount, 8);
  });

  test('aspectRatio returns width/height ratio', () {
    expect(size.aspectRatio, 0.5);
  });

  test('contains returns true for cell within grid', () {
    const cell = GridCell(1, 3);

    expect(size.contains(cell), isTrue);
  });

  group('contains returns false for cell', () {
    test('left of grid', () {
      const cell = GridCell(-1, 3);

      expect(size.contains(cell), isFalse);
    });

    test('right of grid', () {
      const cell = GridCell(2, 3);

      expect(size.contains(cell), isFalse);
    });

    test('top of grid', () {
      const cell = GridCell(1, -1);

      expect(size.contains(cell), isFalse);
    });

    test('bottom of grid', () {
      const cell = GridCell(1, 4);

      expect(size.contains(cell), isFalse);
    });
  });

  group('clamp clamps cell', () {
    test('within grid', () {
      const cell = GridCell(1, 3);

      expect(size.clamp(cell), cell);
    });

    test('left of grid', () {
      const cell = GridCell(-1, 3);

      expect(size.clamp(cell), const GridCell(0, 3));
    });

    test('right of grid', () {
      const cell = GridCell(2, 3);

      expect(size.clamp(cell), const GridCell(1, 3));
    });

    test('top of grid', () {
      const cell = GridCell(1, -1);

      expect(size.clamp(cell), const GridCell(1, 0));
    });

    test('bottom of grid', () {
      const cell = GridCell(1, 4);

      expect(size.clamp(cell), const GridCell(1, 3));
    });
  });

  test('cells enumerates all cells', () {
    expect(
        size.cells,
        orderedEquals([
          const GridCell(0, 0),
          const GridCell(1, 0),
          const GridCell(0, 1),
          const GridCell(1, 1),
          const GridCell(0, 2),
          const GridCell(1, 2),
          const GridCell(0, 3),
          const GridCell(1, 3)
        ]));
  });
}
