import 'dart:ui';

import 'package:mojidraw/fitting_text_renderer.dart';
import 'package:test/test.dart';

void main() {
  test('renders paragraph with the correct width', () {
    final renderer = FittingTextRenderer('X');

    final Paragraph paragraph = renderer.render(Size.square(42.0));

    expect(paragraph.width, 42.0);
  });
}
