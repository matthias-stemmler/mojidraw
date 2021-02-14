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

  TextPainter render(Size size) => _makeTextPainter(
      min(size.width * _widthFactor, size.height * _heightFactor));

  void _calculateSizeFactors() {
    double fontSize = 14.0;
    TextPainter painter = _makeTextPainter(fontSize);

    _widthFactor = fontSize / painter.width;
    _heightFactor = fontSize / painter.height;
  }

  TextPainter _makeTextPainter(double fontSize) {
    var style = TextStyle(fontSize: fontSize);
    var span = TextSpan(text: _text, style: style);
    return TextPainter(textDirection: TextDirection.ltr, text: span)..layout();
  }
}
