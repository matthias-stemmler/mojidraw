import 'dart:ui';

import 'package:mojidraw/util/grid_cell.dart';
import 'package:mojidraw/util/grid_layout.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:test/test.dart';

void main() {
  final layout =
      GridLayout(size: const Size(10.0, 20.0), gridSize: const GridSize(4, 5));

  test('cellsize returns size of a single cell', () {
    expect(layout.cellSize, const Size(2.5, 4.0));
  });

  test('cellToOffset returns offset for cell', () {
    const cell = GridCell(2, 3);

    expect(layout.cellToOffset(cell), const Offset(5.0, 12.0));
  });

  group('offsetToCell returns cell for offset', () {
    test('within grid', () {
      const offset = Offset(5.0, 12.0);

      expect(layout.offsetToCell(offset), const GridCell(2, 3));
    });

    test('left of grid', () {
      const offset = Offset(-0.1, 12.0);

      expect(layout.offsetToCell(offset), const GridCell(0, 3));
    });

    test('right of grid', () {
      const offset = Offset(10.0, 12.0);

      expect(layout.offsetToCell(offset), const GridCell(3, 3));
    });

    test('top of grid', () {
      const offset = Offset(5.0, -0.1);

      expect(layout.offsetToCell(offset), const GridCell(2, 0));
    });

    test('bottom of grid', () {
      const offset = Offset(5.0, 20.0);

      expect(layout.offsetToCell(offset), const GridCell(2, 4));
    });
  });
}
