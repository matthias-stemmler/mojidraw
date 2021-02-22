import 'package:flutter/foundation.dart';

import 'grid_cell.dart';
import 'grid_size.dart';

@immutable
class CharGrid {
  final GridSize _size;
  final List<String> _chars;

  CharGrid(this._size, {String background = ' '})
      : _chars = List.filled(_size.cellCount, background);

  GridSize get size => _size;

  double get aspectRatio => _size.aspectRatio;

  Iterable<GridCell> get cells => _size.cells;

  String get(GridCell cell) => _chars[_getIndex(cell)];

  void set(GridCell cell, String char) => _chars[_getIndex(cell)] = char;

  String get text => Iterable<int>.generate(_size.height)
      .map((y) => _chars.sublist(y * _size.width, (y + 1) * _size.width).join())
      .join('\n');

  int _getIndex(GridCell cell) => cell.y * _size.width + cell.x;
}
