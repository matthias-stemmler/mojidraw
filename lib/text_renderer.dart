import 'dart:ui';

import 'package:flutter/painting.dart';

class TextRenderer {
  final String _text;
  double _widthFactor;

  TextRenderer(this._text) {
    _widthFactor = _getWidthFactor();
  }

  Paragraph render(double width) {
    final style = ParagraphStyle(fontSize: width * _widthFactor);
    final constraints = ParagraphConstraints(width: width);

    return (ParagraphBuilder(style)..addText(_text)).build()
      ..layout(constraints);
  }

  double _getWidthFactor() {
    final style = TextStyle(fontSize: 14.0);
    final span = TextSpan(text: _text, style: style);
    final painter = TextPainter(textDirection: TextDirection.ltr, text: span)
      ..layout();

    return style.fontSize / painter.width;
  }
}
