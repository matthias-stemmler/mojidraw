import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';

/// Renders a text in the maximal font size
/// that makes it fit into a box of a given size
class FittingTextRenderer {
  final String text;
  final TextStyle textStyle;
  double _widthFactor, _heightFactor;

  FittingTextRenderer(
      {this.text, this.textStyle = const TextStyle(fontSize: 14.0)}) {
    _calculateSizeFactors();
  }

  TextPainter render(Size size) {
    final double fontSize =
        min(size.width * _widthFactor, size.height * _heightFactor);
    return _makeTextPainter(
        textStyle.apply(fontSizeFactor: 0.0, fontSizeDelta: fontSize));
  }

  void _calculateSizeFactors() {
    final TextPainter painter = _makeTextPainter(textStyle);

    _widthFactor = textStyle.fontSize / painter.width;
    _heightFactor = textStyle.fontSize / painter.height;
  }

  TextPainter _makeTextPainter(TextStyle style) {
    final span = TextSpan(text: text, style: style);
    return TextPainter(textDirection: TextDirection.ltr, text: span)..layout();
  }
}
