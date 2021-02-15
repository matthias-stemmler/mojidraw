import 'dart:ui';

import 'grid_cell.dart';

class GridLayout {
  final Size _cellSize;
  final int _horizontalCells, _verticalCells;

  GridLayout(Size size, this._horizontalCells, this._verticalCells)
      : _cellSize =
            Size(size.width / _horizontalCells, size.height / _verticalCells);

  Size get cellSize => _cellSize;

  Iterable<GridCell> get cells sync* {
    for (final y in Iterable<int>.generate(_verticalCells)) {
      for (final x in Iterable<int>.generate(_horizontalCells)) {
        yield GridCell(x, y);
      }
    }
  }

  Offset cellToOffset(GridCell cell) =>
      Offset(cell.x * _cellSize.width, cell.y * _cellSize.height);

  GridCell offsetToCell(Offset offset) {
    final int x = (offset.dx / _cellSize.width).floor();
    final int y = (offset.dy / _cellSize.height).floor();

    return x >= 0 && x < _horizontalCells && y >= 0 && y < _verticalCells
        ? GridCell(x, y)
        : null;
  }
}
