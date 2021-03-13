import 'package:flutter/foundation.dart';

import '../util/char_grid.dart';
import '../util/grid_cell.dart';
import '../util/grid_size.dart';

class DrawingState extends ChangeNotifier {
  final CharGrid _grid;
  final List<String> _palette;
  int _penIndex;

  DrawingState({@required GridSize size})
      : _grid = CharGrid(size: size, background: '🍀'),
        _palette = [' ', '🍀', '🦦', '❤', '🌊', '😊'],
        _penIndex = 3;

  List<String> get palette => _palette;

  int get penIndex => _penIndex;

  String get gridAsText => _grid.text;

  String getCellChar(GridCell cell) => _grid.get(cell);

  void switchPen(int penIndex) {
    _penIndex = penIndex;
    notifyListeners();
  }

  void draw(GridCell cell) {
    _grid.set(cell, _palette[_penIndex]);
    notifyListeners();
  }
}
