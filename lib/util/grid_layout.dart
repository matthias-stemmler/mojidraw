import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'grid_cell.dart';
import 'grid_section.dart';
import 'grid_size.dart';

@immutable
class GridLayout {
  final GridSize gridSize;
  final Size cellSize, size;
  late final Rect _toleranceRect;

  GridLayout.fromSize({required this.size, required this.gridSize})
      : cellSize =
            Size(size.width / gridSize.width, size.height / gridSize.height) {
    _toleranceRect = sizeToEdgeInsets(cellSize).inflateRect(Offset.zero & size);
  }

  GridLayout.fromCellSize({required this.cellSize, required this.gridSize})
      : size = Size(
            cellSize.width * gridSize.width, cellSize.height * gridSize.height);

  Offset cellToOffset(GridCell cell) =>
      Offset(cell.x * cellSize.width, cell.y * cellSize.height);

  GridCell? offsetToCell(Offset offset) {
    if (!_toleranceRect.contains(offset)) {
      return null;
    }

    final int x = (offset.dx / cellSize.width).floor();
    final int y = (offset.dy / cellSize.height).floor();
    final cell = GridCell(x, y);

    return gridSize.clamp(cell);
  }

  Rect sectionToRect(GridSection section) => Rect.fromPoints(
      cellToOffset(section.topLeft), cellToOffset(section.bottomRight));
}

EdgeInsets sizeToEdgeInsets(Size size) => EdgeInsets.symmetric(
    horizontal: size.width / 2.0, vertical: size.height / 2.0);
