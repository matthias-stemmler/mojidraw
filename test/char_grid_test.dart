import 'package:mojidraw/char_grid.dart';
import 'package:mojidraw/grid_cell.dart';
import 'package:test/test.dart';

void main() {
  test('width is returned correctly', () {
    final charGrid = CharGrid(2, 8);

    expect(charGrid.width, 2);
  });

  test('height is returned correctly', () {
    final charGrid = CharGrid(2, 8);

    expect(charGrid.height, 8);
  });

  test('aspect ratio is calculated correctly', () {
    final charGrid = CharGrid(2, 8);

    expect(charGrid.aspectRatio, 0.25);
  });

  group('given no background character', () {
    final charGrid = CharGrid(2, 8);

    test('get returns space when not specified using set', () {
      const cell = GridCell(1, 3);

      expect(charGrid.get(cell), ' ');
    });

    test('get returns character specified using set', () {
      const cell = GridCell(1, 3);

      charGrid.set(cell, 'F');

      expect(charGrid.get(cell), 'F');
    });
  });

  group('given a background character', () {
    final charGrid = CharGrid(2, 8, background: 'B');

    test('get returns background character when not specified using set', () {
      const cell = const GridCell(1, 3);

      expect(charGrid.get(cell), 'B');
    });

    test('get returns character specified using set', () {
      const cell = const GridCell(1, 3);
      
      charGrid.set(cell, 'F');

      expect(charGrid.get(cell), 'F');
    });
  });
}
