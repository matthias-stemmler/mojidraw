import 'package:flutter/painting.dart';

import 'fitting_text_renderer.dart';

const EdgeInsets _backgroundInsets = EdgeInsets.all(15.0);

void paintGridCell(
    {required Canvas canvas,
    required Rect rect,
    String text = ' ',
    String? fontFamily,
    Color? backgroundColor}) {
  if (backgroundColor != null) {
    canvas.drawRect(
        _backgroundInsets.deflateRect(rect), Paint()..color = backgroundColor);
  }

  if (text != ' ') {
    final renderer = FittingTextRenderer(text: text, fontFamily: fontFamily);
    final painter = renderer.getTextPainter(rect.size);
    painter.paint(canvas, rect.topLeft);
  }
}
