import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mojidraw/theme/theme_colors.dart';
import 'package:mojidraw/util/grid_section.dart';
import 'package:mojidraw/util/grid_size.dart';
import 'package:mojidraw/widget/grid_sizer.dart';

void main() {
  testGoldens('GridSizerPainter renders grid sizer',
      (WidgetTester tester) async {
    final painter = GridSizerPainter(
        gridSize: const GridSize(10, 12),
        section: GridSection.fromLTRB(1, 1, 9, 11),
        color: ThemeColors.mojidraw,
        backgroundColor: Colors.yellow,
        sizeFactor: 2.0,
        opacity: 0.5,
        backgroundOpacity: 0.5);

    final Widget widget = CustomPaint(
        foregroundPainter: painter,
        child: Container(
            decoration: const BoxDecoration(color: Colors.red)));

    await tester.pumpWidgetBuilder(widget,
        surfaceSize: const Size(600.0, 600.0));

    await screenMatchesGolden(tester, 'grid_sizer_painter');
  });
}
