import 'dart:ui';

import 'package:mojidraw/util/grid_cell.dart';
import 'package:mojidraw/util/grid_layout.dart';
import 'package:mojidraw/util/grid_section.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  test('rect returns extent of grid within size bounds', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 12.0), gridSize: const GridSize(4, 6));

    expect(layout.rect, const Rect.fromLTRB(1.0, 0.0, 9.0, 12.0));
  });

  group('given size, cellSideLength returns side length of a single cell', () {
    test('for full-width grids', () {
      final layout = GridLayout.fromSize(
          size: const Size(10.0, 20.0), gridSize: const GridSize(4, 6));

      expect(layout.cellSideLength, 2.5);
    });

    test('for full-height grids', () {
      final layout = GridLayout.fromSize(
          size: const Size(10.0, 12.0), gridSize: const GridSize(4, 6));

      expect(layout.cellSideLength, 2.0);
    });
  });

  test('given cellSideLength, size returns total size of grid', () {
    final layout = GridLayout.fromCellSideLength(
        cellSideLength: 2.5, gridSize: const GridSize(4, 6));

    expect(layout.size, const Size(10.0, 15.0));
  });

  test('cellToOffset returns offset for cell', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 12.0), gridSize: const GridSize(4, 6));

    const cell = GridCell(2, 3);

    expect(layout.cellToOffset(cell), const Offset(5.0, 6.0));
  });

  group('offsetToCell', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 12.0), gridSize: const GridSize(4, 6));

    group('returns cell for offset within tolerance', () {
      test('within grid', () {
        const offset = Offset(5.0, 6.0);

        expect(layout.offsetToCell(offset), const GridCell(2, 3));
      });

      test('left of grid', () {
        const offset = Offset(0.0, 6.0);

        expect(layout.offsetToCell(offset), const GridCell(0, 3));
      });

      test('right of grid', () {
        const offset = Offset(9.9, 6.0);

        expect(layout.offsetToCell(offset), const GridCell(3, 3));
      });

      test('top of grid', () {
        const offset = Offset(5.0, -1.0);

        expect(layout.offsetToCell(offset), const GridCell(2, 0));
      });

      test('bottom of grid', () {
        const offset = Offset(5.0, 12.9);

        expect(layout.offsetToCell(offset), const GridCell(2, 5));
      });
    });

    group('returns null for offset outside tolerance', () {
      test('left of grid', () {
        const offset = Offset(-0.1, 6.0);

        expect(layout.offsetToCell(offset), isNull);
      });

      test('right of grid', () {
        const offset = Offset(10.0, 6.0);

        expect(layout.offsetToCell(offset), isNull);
      });

      test('top of grid', () {
        const offset = Offset(5.0, -1.1);

        expect(layout.offsetToCell(offset), isNull);
      });

      test('bottom of grid', () {
        const offset = Offset(5.0, 13.0);

        expect(layout.offsetToCell(offset), isNull);
      });
    });
  });

  test('sectionToRect returns rectangle for section', () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 12.0), gridSize: const GridSize(4, 6));
    final section = GridSection.fromLTRB(1, 2, 3, 4);

    expect(
        layout.sectionToRect(section), const Rect.fromLTRB(3.0, 4.0, 7.0, 8.0));
  });

  test(
      'sectionToTransformation returns transformation transforming viewport of entire grid to viewport of given section',
      () {
    final layout = GridLayout.fromSize(
        size: const Size(10.0, 12.0), gridSize: const GridSize(4, 6));

    final section = GridSection.fromLTRB(1, 2, 3, 4);

    final transformation = layout.sectionToTransformation(section);

    expect(_transform(transformation, 0.0, 0.0), const Offset(-7.5, -10.0));
    expect(_transform(transformation, 10.0, 12.0), const Offset(17.5, 20.0));
  });
}

Offset _transform(Matrix4 transformation, double x, double y) {
  final transformed = transformation.transform3(Vector3(x, y, 0.0));
  return Offset(transformed.x, transformed.y);
}
