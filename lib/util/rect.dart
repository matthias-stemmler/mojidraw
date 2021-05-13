import 'dart:ui';

import 'package:flutter/foundation.dart';

enum RectHorizontalSide { left, center, right }

enum RectVerticalSide { top, center, bottom }

@immutable
class RectHandle {
  final RectHorizontalSide horizontalSide;
  final RectVerticalSide verticalSide;

  const RectHandle._(this.horizontalSide, this.verticalSide);

  bool get isCenter =>
      horizontalSide == RectHorizontalSide.center &&
      verticalSide == RectVerticalSide.center;

  static Iterable<RectHandle> get values sync* {
    for (final horizontalSide in RectHorizontalSide.values) {
      for (final verticalSide in RectVerticalSide.values) {
        yield RectHandle._(horizontalSide, verticalSide);
      }
    }
  }
}

Iterable<Offset> getHandlePositions(Rect rect) =>
    RectHandle.values.map((handle) => _getHandlePosition(rect, handle));

RectHandle? getClosestHandle(Rect rect, Offset position, double maxDistance) {
  RectHandle? closestHandle;
  var smallestDistance = double.infinity;

  for (final handle in RectHandle.values) {
    final distance = (position - _getHandlePosition(rect, handle)).distance;
    if (distance < maxDistance && distance < smallestDistance) {
      smallestDistance = distance;
      closestHandle = handle;
    }
  }

  return closestHandle;
}

Offset _getHandlePosition(Rect rect, RectHandle handle) => Offset(
    _getHorizontalHandleCoordinate(rect, handle.horizontalSide),
    _getVerticalHandleCoordinate(rect, handle.verticalSide));

double _getHorizontalHandleCoordinate(Rect rect, RectHorizontalSide side) {
  switch (side) {
    case RectHorizontalSide.left:
      return rect.left;
    case RectHorizontalSide.right:
      return rect.right;
    case RectHorizontalSide.center:
      return rect.left + rect.width / 2.0;
  }
}

double _getVerticalHandleCoordinate(Rect rect, RectVerticalSide side) {
  switch (side) {
    case RectVerticalSide.top:
      return rect.top;
    case RectVerticalSide.bottom:
      return rect.bottom;
    case RectVerticalSide.center:
      return rect.top + rect.height / 2.0;
  }
}
