import 'package:flutter/widgets.dart'
    hide InteractiveViewer, TransformationController;
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../temp_flutter_master/interactive_viewer.dart';
import '../util/fitting_text_renderer.dart';
import '../util/grid_cell.dart';
import '../util/grid_layout.dart';
import '../util/grid_section.dart';
import '../util/grid_size.dart';
import '../util/pan_disambiguator.dart';
import '../widget/grid_sizer.dart';

@immutable
class EmojiGrid extends StatefulWidget {
  final String? fontFamily;

  const EmojiGrid({Key? key, this.fontFamily}) : super(key: key);

  @override
  State createState() => _EmojiGridState();
}

class _EmojiGridState extends State<EmojiGrid> {
  late final _panDisambiguator = PanDisambiguator(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd);
  final _gridSizerController = GridSizerController();
  final _transformationController = TransformationController();

  Matrix4? _transformationBeforeResizing;

  bool get _resizing => context.read<DrawingState>().resizing;

  void _handlePanStart(Offset position) {
    final scenePosition = _transformationController.toScene(position);

    if (_resizing) {
      _gridSizerController.handlePanStart(scenePosition);
    } else {
      _draw(scenePosition);
    }
  }

  void _handlePanUpdate(Offset position) {
    final scenePosition = _transformationController.toScene(position);

    if (_resizing) {
      _gridSizerController.handlePanUpdate(scenePosition);
    } else {
      _draw(scenePosition);
    }
  }

  void _handlePanEnd() {
    if (_resizing) {
      _gridSizerController.handlePanEnd();
    }
  }

  void _draw(Offset position) {
    final layout = GridLayout.fromSize(
        size: context.size ?? Size.zero,
        gridSize: context.read<DrawingState>().grid.size);
    final GridCell cell = layout.offsetToCell(position);

    context.read<DrawingState>().draw(cell);
  }

  void _handleResizeStart() {
    _transformationBeforeResizing = _transformationController.value;
    _transformationController.value = Matrix4.identity();
  }

  void _handleResizeFinish() {
    _transformationController.value = Matrix4.identity();
  }

  void _handleResizeCancel() {
    _transformationController.value =
        _transformationBeforeResizing ?? Matrix4.identity();
  }

  @override
  void initState() {
    super.initState();

    final DrawingState state = context.read();
    state.resizeStartNotifier.addListener(_handleResizeStart);
    state.resizeFinishNotifier.addListener(_handleResizeFinish);
    state.resizeCancelNotifier.addListener(_handleResizeCancel);
  }

  @override
  void dispose() {
    super.dispose();

    final DrawingState state = context.read();
    state.resizeStartNotifier.removeListener(_handleResizeStart);
    state.resizeFinishNotifier.removeListener(_handleResizeFinish);
    state.resizeCancelNotifier.removeListener(_handleResizeCancel);
  }

  @override
  Widget build(BuildContext context) {
    final GridSize gridSize =
        context.select((DrawingState state) => state.grid.size);
    final GridSize sceneGridSize =
        context.select((DrawingState state) => state.sceneGridSize);
    final sceneGridSection =
        context.select((DrawingState state) => state.sceneGridSection);

    return AspectRatio(
      aspectRatio: sceneGridSize.aspectRatio,
      child: InteractiveViewer(
        minScale: 1.0,
        maxScale: 3.25,
        panEnabled: false,
        transformationController: _transformationController,
        onInteractionStart: _panDisambiguator.start,
        onInteractionUpdate: _panDisambiguator.update,
        onInteractionEnd: _panDisambiguator.end,
        child: GridSizer(
          controller: _gridSizerController,
          child: CustomMultiChildLayout(
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
                  .toList()),
        ),
      ),
    );
  }
}

class _GridLayoutDelegate extends MultiChildLayoutDelegate {
  final GridSize gridSize;
  final GridSection gridSection;

  _GridLayoutDelegate({required this.gridSize, required this.gridSection});

  @override
  void performLayout(Size size) {
    final layout = GridLayout.fromSize(size: size, gridSize: gridSize);

    for (final cell in gridSection.size.cells) {
      layoutChild(cell, BoxConstraints.tight(layout.cellSize));
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
