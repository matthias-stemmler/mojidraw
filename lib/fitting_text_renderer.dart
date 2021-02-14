import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';

/// Renders a text in the maximal font size
/// that makes it fit into a box of a given size
class FittingTextRenderer {
  final String _text;
  double _widthFactor, _heightFactor;

  FittingTextRenderer(this._text) {
    _calculateSizeFactors();
  }

  Paragraph render(Size size) {
    final double fontSize =
        min(size.width * _widthFactor, size.height * _heightFactor);
    final style = ParagraphStyle(fontSize: fontSize);
    final constraints = ParagraphConstraints(width: size.width);

    return (ParagraphBuilder(style)..addText(_text)).build()
      ..layout(constraints);
  }

  void _calculateSizeFactors() {
    final style = TextStyle(fontSize: 14.0);
    final span = TextSpan(text: _text, style: style);
    final painter = TextPainter(textDirection: TextDirection.ltr, text: span)
      ..layout();

    _widthFactor = style.fontSize / painter.width;
    _heightFactor = style.fontSize / painter.height;
  }
}
