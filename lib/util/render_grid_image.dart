import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

import 'char_grid.dart';
import 'grid_layout.dart';
import 'paint_grid_cell.dart';

Future<Image> renderGridImage(
    {required CharGrid grid,
    required double cellSideLength,
    String? fontFamily,
    Color backgroundColor = Colors.transparent,
    EdgeInsets padding = EdgeInsets.zero}) async {
  final layout = GridLayout.fromCellSideLength(
      cellSideLength: cellSideLength, gridSize: grid.size);

  final picture = _recordPicture((canvas) {
    canvas.drawRect(Rect.largest, Paint()..color = backgroundColor);

    for (final cell in grid.size.cells) {
      final offset = padding.topLeft + layout.cellToOffset(cell);
      final size = Size.square(cellSideLength);
      paintGridCell(
          canvas: canvas,
          rect: offset & size,
          text: grid.get(cell)!,
          fontFamily: fontFamily);
    }
  });

  final imageSize = padding.inflateSize(layout.size);
  return picture.toImage(imageSize.width.round(), imageSize.height.round());
}

Picture _recordPicture(void Function(Canvas canvas) draw) {
  final pictureRecorder = PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  draw(canvas);
  return pictureRecorder.endRecording();
}
