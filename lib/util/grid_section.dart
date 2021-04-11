import 'grid_cell.dart';
import 'grid_size.dart';

class GridSection {
  late final int left, top, right, bottom;

  GridSection.fromLTRB(this.left, this.top, this.right, this.bottom);

  GridSection.centered(
      {required GridSize outerSize, required GridSize innerSize}) {
    left = (outerSize.width - innerSize.width) ~/ 2;
    top = (outerSize.height - innerSize.height) ~/ 2;
    right = left + innerSize.width;
    bottom = top + innerSize.height;
  }

  GridCell get topLeft => GridCell(left, top);

  GridCell get bottomRight => GridCell(right, bottom);

  GridSize get size => GridSize(right - left, bottom - top);

  GridSection moved(int dx, int dy) =>
      GridSection.fromLTRB(left + dx, top + dy, right + dx, bottom + dy);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridSection &&
          runtimeType == other.runtimeType &&
          left == other.left &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom;

  @override
  int get hashCode =>
      left.hashCode ^ top.hashCode ^ right.hashCode ^ bottom.hashCode;
}
