import 'dart:ui';

import 'package:mojidraw/util/grid_cell.dart';
import 'package:mojidraw/util/grid_layout.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:test/test.dart';

void main() {
  final layout = GridLayout(const Size(10.0, 20.0), const GridSize(4, 5));

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
