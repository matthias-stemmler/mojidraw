class CharGrid {
  final int _width, _height;
  final List<String> _chars;

  CharGrid(this._width, this._height, {String background = ' '})
      : _chars = List.filled(_width * _height, background);

  int get width => _width;

  int get height => _height;

  double get aspectRatio => _width / _height;

  String get(int x, int y) => _chars[_getIndex(x, y)];

  void set(int x, int y, String char) => _chars[_getIndex(x, y)] = char;

  int _getIndex(int x, int y) => y * _width + x;
}
