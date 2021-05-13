import 'package:flutter/foundation.dart';

import '../util/char_grid.dart';
import '../util/grid_cell.dart';
import '../util/grid_section.dart';
import '../util/grid_size.dart';

const _initialGridSize = GridSize(10, 10);
const _resizeSceneGridSize = GridSize(22, 22);
const int _maxPaletteLength = 20;

class DrawingState extends ChangeNotifier {
  final resizeStartNotifier = ChangeNotifier();
  final resizeCancelPendingNotifier = ChangeNotifier();
  final resizeFinishPendingNotifier = ChangeNotifier();

  CharGrid _grid;

  final List<_PaletteEntry> _palette;
  int _penIndex;
  late int _nextScore;

  bool _resizing = false;
  bool _resizePending = false;
  GridSection? _resizingSection;
  CharGrid? _resizedGrid;
  bool _saved = false;

  DrawingState()
      : _grid = CharGrid(_initialGridSize, background: '🙂'),
        _palette = List.empty(growable: true),
        _penIndex = 2 {
    _palette.add(_PaletteEntry(' '));
    _palette.add(_PaletteEntry('🙂')..score = 0);
    _palette.add(_PaletteEntry('😊')..score = 1);
    _nextScore = 2;
  }

  CharGrid get grid => _grid;

  CharGrid get resizedGrid => _resizedGrid ?? _grid;

  GridSize get sceneGridSize => resizing ? _resizeSceneGridSize : grid.size;

  GridSection get sceneGridSection =>
      GridSection.centered(outerSize: sceneGridSize, innerSize: grid.size);

  Iterable<String> get paletteChars => _palette.map((entry) => entry.char);

  int get penIndex => _penIndex;

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
    _saved = false;
    notifyListeners();
  }

  bool get resizing => _resizing;

  bool get resizePending => _resizePending;

  GridSection get resizingSection => _resizingSection ?? sceneGridSection;

  set resizingSection(GridSection? value) {
    _resizingSection = value;

    notifyListeners();
  }

  void startResizing() {
    _resizing = true;
    _resizingSection = sceneGridSection;

    resizeStartNotifier.notifyListeners();
    notifyListeners();
  }

  void requestCancelResizing() {
    _resizePending = true;
    resizeCancelPendingNotifier.notifyListeners();
    notifyListeners();
  }

  void requestFinishResizing() {
    if (_resizingSection != sceneGridSection) {
      _resizedGrid = CharGrid.generate(
          _resizingSection!.size,
          (GridCell cell) =>
              _grid.get(
                  cell + resizingSection.topLeft - sceneGridSection.topLeft) ??
              ' ');

      _saved = false;
    }

    _resizePending = true;
    resizeFinishPendingNotifier.notifyListeners();
    notifyListeners();
  }

  void commitPendingResizeAction() {
    _resizePending = false;
    _grid = resizedGrid;
    _resizedGrid = null;
    _resizingSection = null;
    _resizing = false;

    notifyListeners();
  }

  bool get saved => _saved;

  void markSaved() => _saved = true;

  void _switchPen(int penIndex) {
    _penIndex = penIndex;
    _palette[_penIndex].score = _nextScore++;
  }

  void _addPen(String pen) {
    final index = _ensureInPalette(pen);
    _switchPen(index);
  }

  int _ensureInPalette(String pen) {
    int? minScore;
    var minScoreIndex = -1;

    for (final index in Iterable.generate(_palette.length)) {
      final entry = _palette[index];

      if (entry.char == pen) {
        return index;
      }

      if (index > 0 && (minScore == null || entry.score < minScore)) {
        minScore = entry.score;
        minScoreIndex = index;
      }
    }

    if (_palette.length < _maxPaletteLength) {
      _palette.add(_PaletteEntry(pen));
      return _palette.length - 1;
    } else {
      _palette[minScoreIndex].char = pen;
      return minScoreIndex;
    }
  }

  @override
  void dispose() {
    resizeStartNotifier.dispose();
    resizeCancelPendingNotifier.dispose();
    resizeFinishPendingNotifier.dispose();

    super.dispose();
  }
}

class _PaletteEntry {
  String char;
  late int score;

  _PaletteEntry(this.char);
}
