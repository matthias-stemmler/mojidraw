import 'package:flutter/foundation.dart';

import 'grid_cell.dart';

@immutable
class GridSize {
  final int _width, _height;

  const GridSize(this._width, this._height);

  const GridSize.square(int length) : this(length, length);

  static const GridSize zero = GridSize(0, 0);

  int get width => _width;

  int get height => _height;

  int get cellCount => _width * _height;

  double get aspectRatio => _width / _height;

  bool contains(GridCell cell) =>
      cell.x >= 0 && cell.x < _width && cell.y >= 0 && cell.y < _height;

  GridCell clamp(GridCell cell) => GridCell(cell.x.clamp(0, _width - 1).toInt(),
      cell.y.clamp(0, _height - 1).toInt());

  Iterable<GridCell> get cells sync* {
    for (final y in Iterable.generate(_height)) {
      for (final x in Iterable.generate(_width)) {
        yield GridCell(x, y);
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridSize &&
          runtimeType == other.runtimeType &&
          _width == other._width &&
          _height == other._height;

  @override
  int get hashCode => _width.hashCode ^ _height.hashCode;
}
