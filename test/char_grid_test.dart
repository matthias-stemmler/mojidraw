import 'package:mojidraw/char_grid.dart';
import 'package:test/test.dart';

void main() {
  test('width is returned correctly', () {
    final CharGrid charGrid = CharGrid(2, 8);

    expect(charGrid.width, 2);
  });

  test('height is returned correctly', () {
    final CharGrid charGrid = CharGrid(2, 8);

    expect(charGrid.height, 8);
  });

  test('aspect ratio is calculated correctly', () {
    final CharGrid charGrid = CharGrid(2, 8);

    expect(charGrid.aspectRatio, 0.25);
  });

  group('given no background character', () {
    CharGrid charGrid;

    setUp(() {
      charGrid = CharGrid(2, 8);
    });

    test('get returns space when not specified using set', () {
      expect(charGrid.get(1, 3), ' ');
    });

    test('get returns character specified using set', () {
      charGrid.set(1, 3, 'F');

      expect(charGrid.get(1, 3), 'F');
    });
  });

  group('given a background character', () {
    CharGrid charGrid;

    setUp(() {
      charGrid = CharGrid(2, 8, background: 'B');
    });

    test('get returns background character when not specified using set', () {
      expect(charGrid.get(1, 3), 'B');
    });

    test('get returns character specified using set', () {
      charGrid.set(1, 3, 'F');

      expect(charGrid.get(1, 3), 'F');
    });
  });
}
