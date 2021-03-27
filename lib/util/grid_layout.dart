import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'grid_cell.dart';
import 'grid_size.dart';

@immutable
class GridLayout {
  final GridSize gridSize;
  final Size _cellSize;

  GridLayout({@required Size size, @required this.gridSize})
      : _cellSize =
            Size(size.width / gridSize.width, size.height / gridSize.height);

  Size get cellSize => _cellSize;

  Iterable<GridCell> get cells => gridSize.cells;

  Offset cellToOffset(GridCell cell) =>
      Offset(cell.x * _cellSize.width, cell.y * _cellSize.height);

  GridCell offsetToCell(Offset offset) {
    final int x = (offset.dx / _cellSize.width).floor();
    final int y = (offset.dy / _cellSize.height).floor();
    final cell = GridCell(x, y);

    return gridSize.clamp(cell);
  }
}
