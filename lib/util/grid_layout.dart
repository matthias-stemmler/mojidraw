import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'grid_cell.dart';
import 'grid_section.dart';
import 'grid_size.dart';

@immutable
class GridLayout {
  final double cellSideLength;
  final GridSize gridSize;
  final Size size;

  late final Offset _base;
  late final Rect _rect, _toleranceRect;

  factory GridLayout.fromSize(
      {required GridSize gridSize, required Size size}) {
    double localWidth = size.width;
    double localHeight = size.width / gridSize.aspectRatio;

    if (localHeight > size.height) {
      localHeight = size.height;
      localWidth = localHeight * gridSize.aspectRatio;
    }

    final Size localSize = Size(localWidth, localHeight);
    final double cellSideLength = localWidth / gridSize.width;

    return GridLayout._(gridSize, cellSideLength, size, localSize);
  }

  factory GridLayout.fromCellSideLength(
      {required GridSize gridSize, required double cellSideLength}) {
    final Size size =
        Size(cellSideLength * gridSize.width, cellSideLength * gridSize.height);
    return GridLayout._(gridSize, cellSideLength, size, size);
  }

  GridLayout._(this.gridSize, this.cellSideLength, this.size, Size localSize) {
    _base = Offset((size.width - localSize.width) / 2.0, 0.0);
    _rect = _base & localSize;
    _toleranceRect = EdgeInsets.all(cellSideLength / 2.0).inflateRect(_rect);
  }

  Rect get rect => _rect;

  Offset cellToOffset(GridCell cell) =>
      _base + Offset(cell.x * cellSideLength, cell.y * cellSideLength);

  GridCell? offsetToCell(Offset offset) {
    if (!_toleranceRect.contains(offset)) {
      return null;
    }

    final Offset localOffset = offset - _base;

    final int x = (localOffset.dx / cellSideLength).floor();
    final int y = (localOffset.dy / cellSideLength).floor();
    final cell = GridCell(x, y);

    return gridSize.clamp(cell);
  }

  Rect sectionToRect(GridSection section) => Rect.fromPoints(
      cellToOffset(section.topLeft), cellToOffset(section.bottomRight));
}
