import 'package:flutter/foundation.dart';

import '../util/char_grid.dart';
import '../util/grid_cell.dart';
import '../util/grid_size.dart';

class DrawingState extends ChangeNotifier {
  final CharGrid _grid;
  String _pen;

  DrawingState({@required GridSize size})
      : _grid = CharGrid(size: size, background: '🍀'),
        _pen = '❤';

  String get pen => _pen;

  String get gridAsText => _grid.text;

  String getCellChar(GridCell cell) => _grid.get(cell);

  void switchPen(String pen) {
    _pen = pen;
    notifyListeners();
  }

  void draw(GridCell cell) {
    _grid.set(cell, _pen);
    notifyListeners();
  }
}
