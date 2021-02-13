import 'dart:ui';

import 'package:mojidraw/text_renderer.dart';
import 'package:test/test.dart';

void main() {
  test('renders paragraph with the correct width', () {
    final renderer = TextRenderer('X');

    final Paragraph paragraph = renderer.render(42.0);

    expect(paragraph.width, 42.0);
  });
}
