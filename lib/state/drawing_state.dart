import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../util/char_grid.dart';
import '../util/grid_cell.dart';
import '../util/grid_size.dart';

const int _maxPaletteLength = 5;

class DrawingState extends ChangeNotifier {
  final CharGrid _grid;
  final List<_PaletteEntry> _palette;
  int _penIndex;
  int _nextScore;

  DrawingState({@required GridSize size})
      : _grid = CharGrid(size: size, background: '🍀'),
        _palette = List.empty(growable: true),
        _penIndex = 0 {
    _palette.add(_PaletteEntry()..char = ' ');
    _palette.add(_PaletteEntry()
      ..char = '🍀'
      ..score = 3);
    _palette.add(_PaletteEntry()
      ..char = '🦦'
      ..score = 2);
    _palette.add(_PaletteEntry()
      ..char = '❤'
      ..score = 1);
    _palette.add(_PaletteEntry()
      ..char = '🌊'
      ..score = 0);
    _nextScore = 4;
  }

  Iterable<String> get paletteChars => _palette.map((entry) => entry.char);

  int get penIndex => _penIndex;

  String get gridAsText => _grid.text;

  String getCellChar(GridCell cell) => _grid.get(cell);

  void switchPen(int penIndex) {
    _switchPen(penIndex);
    notifyListeners();
  }

  void addPen(String pen) {
    _addPen(pen);
    notifyListeners();
  }

  void draw(GridCell cell) {
    _grid.set(cell, _palette[_penIndex].char);
    notifyListeners();
  }

  void _switchPen(int penIndex) {
    _penIndex = penIndex;
    _palette[_penIndex].score = _nextScore++;
  }

  void _addPen(String pen) {
    final int index = _ensureInPalette(pen);
    _switchPen(index);
  }

  int _ensureInPalette(String pen) {
    int minScore;
    int minScoreIndex = -1;

    for (final int index in Iterable.generate(_palette.length)) {
      final _PaletteEntry entry = _palette[index];

      if (entry.char == pen) {
        return index;
      }

      if (index > 0 && (minScore == null || entry.score < minScore)) {
        minScore = entry.score;
        minScoreIndex = index;
      }
    }

    if (_palette.length < _maxPaletteLength) {
      _palette.add(_PaletteEntry()..char = pen);
      return _palette.length - 1;
    } else {
      _palette[minScoreIndex].char = pen;
      return minScoreIndex;
    }
  }
}

class _PaletteEntry {
  String char;
  int score;
}
