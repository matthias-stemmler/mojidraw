import 'dart:ui';

import 'package:mojidraw/grid_cell.dart';
import 'package:mojidraw/grid_layout.dart';
import 'package:test/test.dart';

void main() {
  test('cell size is calculated correctly', () {
    final layout = GridLayout(const Size(10.0, 20.0), 4, 5);

    expect(layout.cellSize, const Size(2.5, 4.0));
  });

  test('cells are enumerated correctly', () {
    final layout = GridLayout(const Size(10.0, 20.0), 2, 3);

    expect(
        layout.cells,
        orderedEquals([
          const GridCell(0, 0),
          const GridCell(1, 0),
          const GridCell(0, 1),
          const GridCell(1, 1),
          const GridCell(0, 2),
          const GridCell(1, 2)
        ]));
  });

  test('offset is calculated correctly from cell', () {
    final layout = GridLayout(const Size(10.0, 20.0), 4, 5);
    const cell = GridCell(2, 3);

    expect(layout.cellToOffset(cell), const Offset(5.0, 12.0));
  });

  group('cell is calculated correctly from offset', () {
    final layout = GridLayout(const Size(10.0, 20.0), 4, 5);

    test('within grid', () {
      const offset = Offset(5.0, 12.0);

      expect(layout.offsetToCell(offset), const GridCell(2, 3));
    });

    <String, Offset>{
      'left': const Offset(-0.1, 12.0),
      'right': const Offset(10.0, 12.0),
      'top': const Offset(5.0, -0.1),
      'bottom': const Offset(5.0, 20.0),
    }.forEach((direction, offset) {
      test('$direction of grid', () {
        expect(layout.offsetToCell(offset), null);
      });
    });
  });
}
