import 'dart:ui';

import 'package:mojidraw/util/rect.dart';
import 'package:test/test.dart';

void main() {
  group('RectHandle', () {
    test('values returns 9 items', () {
      expect(RectHandle.values, hasLength(9));
    });

    test('isCentered returns true for exactly one of the values', () {
      expect(
          RectHandle.values.where((handle) => handle.isCenter), hasLength(1));
    });
  });

  test('getHandlePositions returns positions of handles for a rectangle', () {
    const rect = Rect.fromLTRB(10.0, 20.0, 30.0, 35.0);

    final Iterable<Offset> handlePositions = getHandlePositions(rect);

    expect(
        handlePositions,
        unorderedEquals([
          const Offset(10.0, 20.0),
          const Offset(20.0, 20.0),
          const Offset(30.0, 20.0),
          const Offset(10.0, 27.5),
          const Offset(20.0, 27.5),
          const Offset(30.0, 27.5),
          const Offset(10.0, 35.0),
          const Offset(20.0, 35.0),
          const Offset(30.0, 35.0)
        ]));
  });

  group('getClosestHandle', () {
    const rect = Rect.fromLTRB(10.0, 20.0, 30.0, 35.0);
    const double maxDistance = 1.5;

    test('returns handle for position close to it', () {
      const position = Offset(9.0, 28.5);

      final RectHandle? handle = getClosestHandle(rect, position, maxDistance);

      expect(handle?.horizontalSide, RectHorizontalSide.left);
      expect(handle?.verticalSide, RectVerticalSide.center);
    });

    test('returns null for position not close to any handle', () {
      const position = Offset(8.5, 28.0);

      final RectHandle? handle = getClosestHandle(rect, position, maxDistance);

      expect(handle, isNull);
    });
  });
}
