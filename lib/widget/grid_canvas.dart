import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/fitting_text_renderer.dart';
import '../util/grid_cell.dart';
import '../util/grid_layout.dart';
import '../util/grid_section.dart';
import '../util/grid_size.dart';

class GridCanvas extends StatefulWidget {
  final GridCanvasController? controller;
  final String? fontFamily;

  const GridCanvas({Key? key, this.controller, this.fontFamily})
      : super(key: key);

  @override
  State createState() => _GridCanvasState();
}

class _GridCanvasState extends State<GridCanvas> {
  void _handlePan(Offset position) {
    final layout = GridLayout.fromSize(
        size: context.size ?? Size.zero,
        gridSize: context.read<DrawingState>().grid.size);
    final GridCell? cell = layout.offsetToCell(position);

    if (cell != null) {
      context.read<DrawingState>().draw(cell);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  Widget build(BuildContext context) {
    final GridSize gridSize =
        context.select((DrawingState state) => state.grid.size);
    final GridSize sceneGridSize =
        context.select((DrawingState state) => state.sceneGridSize);
    final sceneGridSection =
        context.select((DrawingState state) => state.sceneGridSection);

    return CustomMultiChildLayout(
        delegate: _GridLayoutDelegate(
            gridSize: sceneGridSize, gridSection: sceneGridSection),
        children: gridSize.cells
            .map((cell) => LayoutId(
                id: cell,
                child: RepaintBoundary(
                    child: _EmojiGridCell(
                  cell: cell,
                  fontFamily: widget.fontFamily,
                ))))
            .toList());
  }
}

class GridCanvasController {
  _GridCanvasState? _state;

  void handlePan(Offset offset) => _state?._handlePan(offset);
}

class _GridLayoutDelegate extends MultiChildLayoutDelegate {
  final GridSize gridSize;
  final GridSection gridSection;

  _GridLayoutDelegate({required this.gridSize, required this.gridSection});

  @override
  void performLayout(Size size) {
    final layout = GridLayout.fromSize(size: size, gridSize: gridSize);

    for (final cell in gridSection.size.cells) {
      layoutChild(
          cell, BoxConstraints.tight(Size.square(layout.cellSideLength)));
      positionChild(cell, layout.cellToOffset(cell + gridSection.topLeft));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) =>
      oldDelegate is! _GridLayoutDelegate ||
      oldDelegate is _GridLayoutDelegate &&
          (oldDelegate.gridSize != gridSize ||
              oldDelegate.gridSection != gridSection);
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
          text: context.select((DrawingState state) => state.grid.get(cell))!,
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
