import 'package:mojidraw/util/grid_cell.dart';
import 'package:mojidraw/util/grid_section.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:test/test.dart';

void main() {
  test('fromLRTB creates section according to given boundaries', () {
    final gridSection = GridSection.fromLTRB(1, 2, 3, 4);

    expect(gridSection.left, 1);
    expect(gridSection.top, 2);
    expect(gridSection.right, 3);
    expect(gridSection.bottom, 4);
  });

  test('centered creates section centered within another section', () {
    const outerSize = GridSize(10, 20);
    const innerSize = GridSize(8, 15);

    final gridSection =
        GridSection.centered(outerSize: outerSize, innerSize: innerSize);

    expect(gridSection.left, 1);
    expect(gridSection.bottom, 17);
    expect(gridSection.right, 9);
    expect(gridSection.top, 2);
  });

  test('topLeft returns top left cell (inclusive) of section', () {
    final gridSection = GridSection.fromLTRB(1, 2, 3, 4);

    expect(gridSection.topLeft, const GridCell(1, 2));
  });

  test('bottomRight returns bottom right cell (exclusive) of section', () {
    final gridSection = GridSection.fromLTRB(1, 2, 3, 4);

    expect(gridSection.bottomRight, const GridCell(3, 4));
  });

  test('size returns size of section', () {
    final gridSection = GridSection.fromLTRB(1, 2, 5, 7);

    expect(gridSection.size, const GridSize(4, 5));
  });

  test('moved returns moved section', () {
    final gridSection = GridSection.fromLTRB(1, 2, 5, 7);

    final movedSection = gridSection.moved(-2, 3);

    expect(movedSection, GridSection.fromLTRB(-1, 5, 3, 10));
  });
}
