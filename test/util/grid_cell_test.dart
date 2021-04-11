import 'package:mojidraw/util/grid_cell.dart';
import 'package:test/test.dart';

void main() {
  test('operator + adds cells', () {
    const GridCell cellA = GridCell(1, 2);
    const GridCell cellB = GridCell(3, 4);

    expect(cellA + cellB, const GridCell(4, 6));
  });

  test('operator - subtracts cells', () {
    const GridCell cellA = GridCell(1, 2);
    const GridCell cellB = GridCell(3, 4);

    expect(cellB - cellA, const GridCell(2, 2));
  });
}
