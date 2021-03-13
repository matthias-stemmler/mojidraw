import 'package:flutter/foundation.dart';

import '../util/grid_cell.dart';
import '../util/grid_size.dart';

@immutable
class CharGrid {
  final GridSize size;
  final List<String> _chars;

  CharGrid({@required this.size, String background = ' '})
      : _chars = List.filled(size.cellCount, background);

  String get(GridCell cell) => _chars[_getIndex(cell)];

  void set(GridCell cell, String char) => _chars[_getIndex(cell)] = char;

  String get text => Iterable<int>.generate(size.height)
      .map((y) => _chars.sublist(y * size.width, (y + 1) * size.width).join())
      .join('\n');

  int _getIndex(GridCell cell) => cell.y * size.width + cell.x;
}
