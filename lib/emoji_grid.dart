import 'package:flutter/widgets.dart';

import 'char_grid.dart';
import 'fitting_text_renderer.dart';
import 'grid_cell.dart';
import 'grid_layout.dart';
import 'grid_size.dart';

@immutable
class EmojiGrid extends StatelessWidget {
  final CharGrid emojis;
  final void Function(GridCell cell) onEmojiTouch;
  final String fontFamily;

  const EmojiGrid({Key key, this.emojis, this.onEmojiTouch, this.fontFamily})
      : super(key: key);

  void _handlePan(Offset position, Size size) {
    final layout = GridLayout(size, emojis.size);
    final GridCell cell = layout.offsetToCell(position);

    if (cell != null) {
      onEmojiTouch?.call(cell);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onPanStart: (details) => _handlePan(details.localPosition, context.size),
      onPanUpdate: (details) => _handlePan(details.localPosition, context.size),
      child: AspectRatio(
          aspectRatio: emojis.aspectRatio,
          child: CustomMultiChildLayout(
              delegate: _GridLayoutDelegate(emojis.size),
              children: emojis.cells
                  .map((cell) => LayoutId(
                      id: cell,
                      child: RepaintBoundary(
                          child: CustomPaint(
                              painter: _GridCellPainter(
                                  text: emojis.get(cell),
                                  fontFamily: fontFamily)))))
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
