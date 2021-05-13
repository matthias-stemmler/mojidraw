import 'package:mojidraw/util/grid_cell.dart';
import 'package:test/test.dart';

void main() {
  test('operator + adds cells', () {
    const cellA = GridCell(1, 2);
    const cellB = GridCell(3, 4);

    expect(cellA + cellB, const GridCell(4, 6));
  });

  test('operator - subtracts cells', () {
    const cellA = GridCell(1, 2);
    const cellB = GridCell(3, 4);

    expect(cellB - cellA, const GridCell(2, 2));
  });

  test('above returns cell above', () {
    const cell = GridCell(2, 4);

    expect(cell.above, const GridCell(2, 3));
  });

  test('below returns cell below', () {
    const cell = GridCell(2, 4);

    expect(cell.below, const GridCell(2, 5));
  });

  test('left returns cell to the left', () {
    const cell = GridCell(2, 4);

    expect(cell.left, const GridCell(1, 4));
  });

  test('right returns cell to the right', () {
    const cell = GridCell(2, 4);

    expect(cell.right, const GridCell(3, 4));
  });
}
