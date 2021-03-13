import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'fitting_text_renderer.dart';
import 'grid_cell.dart';
import 'grid_drawing_state.dart';
import 'grid_layout.dart';
import 'grid_size.dart';

@immutable
class EmojiGrid extends StatelessWidget {
  final GridSize size;
  final String fontFamily;

  const EmojiGrid({Key key, this.size, this.fontFamily}) : super(key: key);

  void _handlePan(Offset position, BuildContext context) {
    final layout = GridLayout(context.size, size);
    final GridCell cell = layout.offsetToCell(position);

    if (cell != null) {
      context.read<GridDrawingState>().draw(cell);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onPanStart: (details) => _handlePan(details.localPosition, context),
      onPanUpdate: (details) => _handlePan(details.localPosition, context),
      child: AspectRatio(
          aspectRatio: size.aspectRatio,
          child: CustomMultiChildLayout(
              delegate: _GridLayoutDelegate(size),
              children: size.cells
                  .map((cell) => LayoutId(
                      id: cell,
                      child: RepaintBoundary(
                          child: _EmojiGridCell(
                        cell: cell,
                        fontFamily: fontFamily,
                      ))))
                  .toList())));
}

class _GridLayoutDelegate extends MultiChildLayoutDelegate {
  final GridSize _gridSize;

  _GridLayoutDelegate(this._gridSize);

  @override
  void performLayout(Size size) {
    final layout = GridLayout(size, _gridSize);

    for (final cell in layout.cells) {
      layoutChild(cell, BoxConstraints.tight(layout.cellSize));
      positionChild(cell, layout.cellToOffset(cell));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) =>
      oldDelegate is! _GridLayoutDelegate ||
      oldDelegate is _GridLayoutDelegate && oldDelegate._gridSize != _gridSize;
}

class _EmojiGridCell extends StatelessWidget {
  final GridCell cell;
  final String fontFamily;

  const _EmojiGridCell({Key key, this.cell, this.fontFamily}) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
      painter: _GridCellPainter(
          text: context.select((GridDrawingState state) => state.getCell(cell)),
          fontFamily: fontFamily));
}

@immutable
class _GridCellPainter extends CustomPainter {
  final String text;
  final String fontFamily;

  const _GridCellPainter({@required this.text, this.fontFamily});

  @override
  void paint(Canvas canvas, Size size) {
    final renderer = FittingTextRenderer(text: text, fontFamily: fontFamily);
    final TextPainter painter = renderer.getTextPainter(size);
    painter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is! _GridCellPainter ||
      oldDelegate is _GridCellPainter &&
          (oldDelegate.text != text || oldDelegate.fontFamily != fontFamily);
}