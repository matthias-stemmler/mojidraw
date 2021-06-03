import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/grid_cell.dart';
import '../util/grid_layout.dart';
import '../util/grid_section.dart';
import '../util/grid_size.dart';
import '../util/paint_grid_cell.dart';

@immutable
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
    final cell = layout.offsetToCell(position);

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
  void dispose() {
    widget.controller?._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = context.select((DrawingState state) => state.grid.size);
    final sceneGridSize =
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
  Widget build(BuildContext context) {
    final text = context.select((DrawingState state) => state.grid.get(cell))!;
    final emptiness =
        context.select((DrawingState state) => state.grid.emptiness(cell));

    return CustomPaint(
        painter: _GridCellPainter(
            text: text,
            fontFamily: fontFamily,
            backgroundColor: emptiness == 0.0
                ? null
                : Theme.of(context)
                    .primaryColor
                    .withOpacity(0.05 * emptiness)));
  }
}

@immutable
class _GridCellPainter extends CustomPainter {
  final String text;
  final String? fontFamily;
  final Color? backgroundColor;

  const _GridCellPainter(
      {required this.text, this.fontFamily, this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) => paintGridCell(
      canvas: canvas,
      rect: Offset.zero & size,
      text: text,
      fontFamily: fontFamily,
      backgroundColor: backgroundColor);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is! _GridCellPainter ||
      oldDelegate is _GridCellPainter &&
          (oldDelegate.text != text ||
              oldDelegate.fontFamily != fontFamily ||
              oldDelegate.backgroundColor != backgroundColor);
}
