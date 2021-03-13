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

  group('contains returns whether grid contains cell', () {
    test('within grid', () {
      expect(size.contains(const GridCell(1, 3)), true);
    });

    <String, GridCell>{
      'left': const GridCell(-1, 3),
      'right': const GridCell(2, 3),
      'top': const GridCell(1, -1),
      'bottom': const GridCell(1, 4),
    }.forEach((direction, cell) {
      test('$direction of grid', () {
        expect(size.contains(cell), false);
      });
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
