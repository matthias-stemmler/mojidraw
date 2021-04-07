import 'package:flutter/widgets.dart'
    hide InteractiveViewer, TransformationController;
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../temp_flutter_master/interactive_viewer.dart';
import '../util/fitting_text_renderer.dart';
import '../util/grid_cell.dart';
import '../util/grid_layout.dart';
import '../util/grid_size.dart';
import '../util/pan_disambiguator.dart';

@immutable
class EmojiGrid extends StatefulWidget {
  final GridSize size;
  final String? fontFamily;

  const EmojiGrid({Key? key, required this.size, this.fontFamily})
      : super(key: key);

  @override
  State createState() => _EmojiGridState();
}

class _EmojiGridState extends State<EmojiGrid> {
  late final _panDisambiguator = PanDisambiguator(_handleDraw);
  final _transformationController = TransformationController();

  void _handleDraw(Offset position) {
    final layout = GridLayout.fromSize(
        size: context.size ?? Size.zero, gridSize: widget.size);
    final GridCell cell =
        layout.offsetToCell(_transformationController.toScene(position));

    context.read<DrawingState>().draw(cell);
  }

  @override
  Widget build(_) => AspectRatio(
        aspectRatio: widget.size.aspectRatio,
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 3.25,
          panEnabled: false,
          transformationController: _transformationController,
          onInteractionStart: _panDisambiguator.start,
          onInteractionUpdate: _panDisambiguator.update,
          onInteractionEnd: _panDisambiguator.end,
          child: CustomMultiChildLayout(
              delegate: _GridLayoutDelegate(widget.size),
              children: widget.size.cells
                  .map((cell) => LayoutId(
                      id: cell,
                      child: RepaintBoundary(
                          child: _EmojiGridCell(
                        cell: cell,
                        fontFamily: widget.fontFamily,
                      ))))
                  .toList()),
        ),
      );
}

class _GridLayoutDelegate extends MultiChildLayoutDelegate {
  final GridSize _gridSize;

  _GridLayoutDelegate(this._gridSize);

  @override
  void performLayout(Size size) {
    final layout = GridLayout.fromSize(size: size, gridSize: _gridSize);

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
class _EmojiGridCell extends StatelessWidget {
  final GridCell cell;
  final String? fontFamily;

  const _EmojiGridCell({Key? key, required this.cell, this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) => CustomPaint(
      painter: _GridCellPainter(
          text: context.select((DrawingState state) => state.grid.get(cell)),
          fontFamily: fontFamily));
}

@immutable
class _GridCellPainter extends CustomPainter {
  final String text;
  final String? fontFamily;

  const _GridCellPainter({required this.text, this.fontFamily});

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
