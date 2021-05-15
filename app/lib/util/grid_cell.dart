import 'package:flutter/foundation.dart';

@immutable
class GridCell {
  final int x, y;

  const GridCell(this.x, this.y);

  GridCell operator +(GridCell other) => GridCell(x + other.x, y + other.y);

  GridCell operator -(GridCell other) => GridCell(x - other.x, y - other.y);

  GridCell get above => GridCell(x, y - 1);

  GridCell get below => GridCell(x, y + 1);

  GridCell get left => GridCell(x - 1, y);

  GridCell get right => GridCell(x + 1, y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridCell &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
