import 'package:flutter/foundation.dart';

import 'grid_cell.dart';
import 'grid_size.dart';

const int _maxEmptiness = 5;

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

  bool isEmpty(GridCell cell) => (get(cell) ?? ' ') == ' ';

  double emptiness(GridCell cell) => _absoluteEmptiness(cell) / _maxEmptiness;

  int _absoluteEmptiness(GridCell cell) {
    if (!isEmpty(cell)) {
      return 0;
    }

    final int emptiness = Iterable<int>.generate(_maxEmptiness).firstWhere(
        (n) => !_isEmptyOfDegree(cell, n + 1),
        orElse: () => _maxEmptiness);

    return emptiness < 2 && _isEmptyAtBoundary(cell) ? 2 : emptiness;
  }

  bool _isEmptyOfDegree(GridCell cell, int degree) {
    final neighborhoodSize = GridSize.square(2 * degree + 1);
    final GridCell neighborhoodTopLeft = cell - GridCell(degree, degree);

    return neighborhoodSize.cells
        .map((c) => neighborhoodTopLeft + c)
        .every(isEmpty);
  }

  bool _isEmptyAtBoundary(GridCell cell) =>
      (cell.x == 0 || cell.x == size.width - 1) &&
          isEmpty(cell.above) &&
          isEmpty(cell.below) ||
      (cell.y == 0 || cell.y == size.height - 1) &&
          isEmpty(cell.left) &&
          isEmpty(cell.right);

  String get text => Iterable<int>.generate(size.height)
      .map((y) => _chars.sublist(y * size.width, (y + 1) * size.width).join())
      .join('\n');

  int _cellToIndex(GridCell cell) => cell.y * size.width + cell.x;

  static GridCell _indexToCell(int index, GridSize size) =>
      GridCell(index % size.width, index ~/ size.width);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharGrid &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          _chars == other._chars;

  @override
  int get hashCode => size.hashCode ^ _chars.hashCode;
}
