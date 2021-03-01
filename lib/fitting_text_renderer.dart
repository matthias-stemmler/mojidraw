import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Renders a text in the maximal font size
/// that makes it fit into a box of a given size
class FittingTextRenderer {
  final String text;
  final String fontFamily;
  double _widthFactor, _heightFactor;

  FittingTextRenderer({@required this.text, this.fontFamily}) {
    _calculateSizeFactors();
  }

  TextPainter getTextPainter(Size size) => _buildPainter(_getFontSize(size));

  TextStyle getTextStyle(Size size) =>
      TextStyle(fontFamily: fontFamily, fontSize: _getFontSize(size));

  double _getFontSize(Size size) =>
      min(size.width * _widthFactor, size.height * _heightFactor);

  void _calculateSizeFactors() {
    const double fontSize = 14.0;
    final TextPainter painter = _buildPainter(fontSize);

    _widthFactor = fontSize / painter.width;
    _heightFactor = fontSize / painter.height;
  }

  TextPainter _buildPainter(double fontSize) {
    final span = TextSpan(
        text: text,
        style: TextStyle(fontFamily: fontFamily, fontSize: fontSize));
    return TextPainter(textDirection: TextDirection.ltr, text: span)..layout();
  }
}
