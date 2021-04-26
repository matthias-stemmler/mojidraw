import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

import 'char_grid.dart';
import 'fitting_text_renderer.dart';
import 'grid_layout.dart';

Future<Image> renderGridImage(
    {required CharGrid grid,
    required double cellSideLength,
    String? fontFamily,
    Color backgroundColor = Colors.transparent,
    EdgeInsets padding = EdgeInsets.zero}) async {
  final layout = GridLayout.fromCellSideLength(
      cellSideLength: cellSideLength, gridSize: grid.size);

  final Picture picture = _recordPicture((canvas) {
    canvas.drawRect(Rect.largest, Paint()..color = backgroundColor);

    for (final cell in grid.size.cells) {
      final renderer =
          FittingTextRenderer(text: grid.get(cell)!, fontFamily: fontFamily);
      final painter = renderer.getTextPainter(Size.square(cellSideLength));
      final offset = padding.topLeft + layout.cellToOffset(cell);
      painter.paint(canvas, offset);
    }
  });

  final Size imageSize = padding.inflateSize(layout.size);
  return picture.toImage(imageSize.width.round(), imageSize.height.round());
}

Picture _recordPicture(void Function(Canvas canvas) draw) {
  final pictureRecorder = PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  draw(canvas);
  return pictureRecorder.endRecording();
}
