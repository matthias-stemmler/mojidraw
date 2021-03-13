import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'grid_cell.dart';
import 'grid_size.dart';

@immutable
class GridLayout {
  final GridSize _gridSize;
  final Size _cellSize;

  GridLayout(Size size, this._gridSize)
      : _cellSize =
            Size(size.width / _gridSize.width, size.height / _gridSize.height);

  Size get cellSize => _cellSize;

  Iterable<GridCell> get cells => _gridSize.cells;

  Offset cellToOffset(GridCell cell) =>
      Offset(cell.x * _cellSize.width, cell.y * _cellSize.height);

  GridCell offsetToCell(Offset offset) {
    final int x = (offset.dx / _cellSize.width).floor();
    final int y = (offset.dy / _cellSize.height).floor();
    final cell = GridCell(x, y);

    return _gridSize.contains(cell) ? cell : null;
  }
}
