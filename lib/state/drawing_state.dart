import 'package:flutter/cupertino.dart';
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
  _ResizeAction? _pendingResizeAction;
  GridSection? _resizingSection;
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

  bool get resizeActionPending => _pendingResizeAction != null;

  GridSection? get resizingSection => _resizingSection;

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
    _pendingResizeAction = _ResizeAction.cancel;
    resizeCancelPendingNotifier.notifyListeners();
    notifyListeners();
  }

  void requestFinishResizing() {
    _pendingResizeAction = _ResizeAction.finish;
    resizeFinishPendingNotifier.notifyListeners();
    notifyListeners();
  }

  void commitPendingResizeAction() {
    if (_pendingResizeAction == _ResizeAction.cancel) {
      _cancelResizing();
    } else if (_pendingResizeAction == _ResizeAction.finish) {
      _finishResizing();
    }

    _pendingResizeAction = null;
  }

  void _cancelResizing() {
    _resizingSection = null;
    _resizing = false;

    notifyListeners();
  }

  void _finishResizing() {
    if (_resizingSection != sceneGridSection) {
      _grid = CharGrid.generate(
          _resizingSection!.size,
          (GridCell cell) =>
              _grid.get(
                  cell + resizingSection!.topLeft - sceneGridSection.topLeft) ??
              ' ');

      _saved = false;
    }

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
    final int index = _ensureInPalette(pen);
    _switchPen(index);
  }

  int _ensureInPalette(String pen) {
    int? minScore;
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
      _palette.add(_PaletteEntry(pen));
      return _palette.length - 1;
    } else {
      _palette[minScoreIndex].char = pen;
      return minScoreIndex;
    }
  }

  @override
  void dispose() {
    super.dispose();

    resizeStartNotifier.dispose();
    resizeCancelPendingNotifier.dispose();
    resizeFinishPendingNotifier.dispose();
  }
}

class _PaletteEntry {
  String char;
  late int score;

  _PaletteEntry(this.char);
}

enum _ResizeAction { cancel, finish }
