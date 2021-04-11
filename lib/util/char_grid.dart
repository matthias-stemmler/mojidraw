import 'package:flutter/foundation.dart';

import '../util/grid_cell.dart';
import '../util/grid_size.dart';

@immutable
class CharGrid {
  final GridSize size;
  final List<String> _chars;

  CharGrid(this.size, {String background = ' '})
      : _chars = List.filled(size.cellCount, background);

  CharGrid.generate(this.size, String Function(GridCell cell) generator)
      : _chars = List.generate(
            size.cellCount, (index) => generator(_indexToCell(index, size)));

  String? get(GridCell cell) =>
      size.contains(cell) ? _chars[_cellToIndex(cell)] : null;

  void set(GridCell cell, String char) => _chars[_cellToIndex(cell)] = char;

  String get text => Iterable<int>.generate(size.height)
      .map((y) => _chars.sublist(y * size.width, (y + 1) * size.width).join())
      .join('\n');

  int _cellToIndex(GridCell cell) => cell.y * size.width + cell.x;

  static GridCell _indexToCell(int index, GridSize size) =>
      GridCell(index % size.width, index ~/ size.width);
}
