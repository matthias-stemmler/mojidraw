import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';

class FittingTextRenderer {
  final String text;
  final String? fontFamily;
  late double _widthFactor, _heightFactor;

  FittingTextRenderer({required this.text, this.fontFamily}) {
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
