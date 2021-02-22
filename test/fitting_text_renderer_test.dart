import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mojidraw/fitting_text_renderer.dart';

void main() {
  group('renders text fitting in box', () {
    <String, Size>{
      'portrait': const Size(100.0, 250.0),
      'landscape': const Size(150.0, 100.0)
    }.forEach((description, size) {
      testGoldens(description, (WidgetTester tester) async {
        final Widget widget = CustomPaint(painter: _TestPainter());

        await tester.pumpWidgetBuilder(widget, surfaceSize: size);

        await screenMatchesGolden(tester, 'fitting_text_renderer_$description');
      });
    });
  });
}

class _TestPainter extends CustomPainter {
  final FittingTextRenderer _renderer;

  _TestPainter()
      : _renderer = FittingTextRenderer(text: 'X', fontFamily: 'Roboto');

  @override
  void paint(Canvas canvas, Size size) {
    final TextPainter painter = _renderer.render(size);

    final Rect rect = _center(size, painter.size);

    canvas.drawRect(rect, Paint()..color = Colors.grey);
    painter.paint(canvas, rect.topLeft);
  }

  Rect _center(Size outerSize, Size innerSize) {
    final Offset offset = ((outerSize - innerSize) as Offset) / 2.0;
    return offset & innerSize;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
