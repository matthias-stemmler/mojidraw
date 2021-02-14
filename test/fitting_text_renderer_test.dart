import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:mojidraw/fitting_text_renderer.dart';
import 'package:test/test.dart';

void main() {
  test('renders paragraph with the correct width', () {
    var renderer = FittingTextRenderer('X');

    TextPainter painter = renderer.render(Size.square(42.0));

    expect(painter.width, 42.0);
  });
}
