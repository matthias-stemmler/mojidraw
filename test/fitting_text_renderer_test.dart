import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mojidraw/fitting_text_renderer.dart';

void main() {
  group('renders text fitting in box', () {
    <String, Size>{
      'portrait': Size(100.0, 250.0),
      'landscape': Size(150.0, 100.0)
    }.forEach((description, size) {
      testGoldens(description, (WidgetTester tester) async {
        Widget widget = Builder(
            builder: (context) => CustomPaint(
                painter: _TestPainter(Theme.of(context).textTheme.bodyText2)));

        await tester.pumpWidgetBuilder(widget, surfaceSize: size);

        await screenMatchesGolden(tester, 'fitting_text_renderer_$description');
      });
    });
  });
}

class _TestPainter extends CustomPainter {
  final FittingTextRenderer _renderer;

  _TestPainter(textStyle)
      : _renderer = FittingTextRenderer(text: 'X', textStyle: textStyle);

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter painter = _renderer.render(size);

    Rect rect = _center(size, painter.size);

    canvas.drawRect(rect, Paint()..color = Colors.black12);
    painter.paint(canvas, rect.topLeft);
  }

  Rect _center(Size outerSize, Size innerSize) {
    Offset offset = ((outerSize - innerSize) as Offset) / 2.0;
    return offset & innerSize;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
