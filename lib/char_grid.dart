import 'grid_cell.dart';

class CharGrid {
  final int _width, _height;
  final List<String> _chars;

  CharGrid(this._width, this._height, {String background = ' '})
      : _chars = List.filled(_width * _height, background);

  int get width => _width;

  int get height => _height;

  double get aspectRatio => _width / _height;

  String get(GridCell cell) => _chars[_getIndex(cell)];

  void set(GridCell cell, String char) => _chars[_getIndex(cell)] = char;

  int _getIndex(GridCell cell) => cell.y * _width + cell.x;
}
