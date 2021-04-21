import 'dart:ui';

import 'package:mojidraw/util/grid_cell.dart';
import 'package:mojidraw/util/grid_layout.dart';
import 'package:mojidraw/util/grid_section.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:test/test.dart';

void main() {
  test('given size, cellSize returns size of a single cell', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 20.0), gridSize: const GridSize(4, 5));

    expect(layout.cellSize, const Size(2.5, 4.0));
  });

  test('given cellSize, size returns total size of grid', () {
    final layout = GridLayout.fromCellSize(
        cellSize: const Size(2.5, 4.0), gridSize: const GridSize(4, 5));

    expect(layout.size, const Size(10.0, 20.0));
  });

  test('cellToOffset returns offset for cell', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 20.0), gridSize: const GridSize(4, 5));

    const cell = GridCell(2, 3);

    expect(layout.cellToOffset(cell), const Offset(5.0, 12.0));
  });

  group('offsetToCell', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 20.0), gridSize: const GridSize(4, 5));

    group('returns cell for offset within tolerance', () {
      test('within grid', () {
        const offset = Offset(5.0, 12.0);

        expect(layout.offsetToCell(offset), const GridCell(2, 3));
      });

      test('left of grid', () {
        const offset = Offset(-1.0, 12.0);

        expect(layout.offsetToCell(offset), const GridCell(0, 3));
      });

      test('right of grid', () {
        const offset = Offset(11.0, 12.0);

        expect(layout.offsetToCell(offset), const GridCell(3, 3));
      });

      test('top of grid', () {
        const offset = Offset(5.0, -1.5);

        expect(layout.offsetToCell(offset), const GridCell(2, 0));
      });

      test('bottom of grid', () {
        const offset = Offset(5.0, 21.5);

        expect(layout.offsetToCell(offset), const GridCell(2, 4));
      });
    });

    group('returns null for offset outside tolerance', () {
      test('left of grid', () {
        const offset = Offset(-1.5, 12.0);

        expect(layout.offsetToCell(offset), isNull);
      });

      test('right of grid', () {
        const offset = Offset(11.5, 12.0);

        expect(layout.offsetToCell(offset), isNull);
      });

      test('top of grid', () {
        const offset = Offset(5.0, -2.5);

        expect(layout.offsetToCell(offset), isNull);
      });

      test('bottom of grid', () {
        const offset = Offset(5.0, 22.5);

        expect(layout.offsetToCell(offset), isNull);
      });
    });
  });

  test('sectionToRect returns rectangle for section', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 20.0), gridSize: const GridSize(4, 5));
    final section = GridSection.fromLTRB(1, 2, 3, 4);

    expect(layout.sectionToRect(section),
        const Rect.fromLTRB(2.5, 8.0, 7.5, 16.0));
  });
}
