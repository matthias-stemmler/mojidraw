import 'dart:math';

import 'package:flutter/material.dart'
    hide InteractiveViewer, TransformationController;
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/grid_size.dart';
import '../util/pan_disambiguator.dart';
import '../widget/grid_canvas.dart';
import '../widget/grid_sizer.dart';
import '../widget/scale_viewer.dart';

const _minGridSize = GridSize(2, 2);

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
  final _gridCanvasController = GridCanvasController();
  final _gridSizerController = GridSizerController();
  final _scaleController = ScaleController();

  Matrix4? _transformationBeforeResizing;

  bool get _resizing => context.read<DrawingState>().resizing;

  void _handlePanStart(Offset position) {
    if (_resizing) {
      _gridSizerController.handlePanStart(position);
    } else {
      _gridCanvasController.handlePan(position);
    }
  }

  void _handlePanUpdate(Offset position) {
    if (_resizing) {
      _gridSizerController.handlePanUpdate(position);
    } else {
      _gridCanvasController.handlePan(position);
    }
  }

  void _handlePanEnd() {
    if (_resizing) {
      _gridSizerController.handlePanEnd();
    }
  }

  void _handleResizeStart() {
    _transformationBeforeResizing = _scaleController.value;
    _scaleController.value = Matrix4.identity();
  }

  void _handleResizeFinish() {
    _scaleController.value = Matrix4.identity();
  }

  void _handleResizeCancel() {
    _scaleController.value =
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
    final GridSize sceneGridSize =
        context.select((DrawingState state) => state.sceneGridSize);
    final double maxScale = max(sceneGridSize.width / _minGridSize.width,
        sceneGridSize.height / _minGridSize.height);

    return ScaleViewer(
      onInteractionStart: _panDisambiguator.start,
      onInteractionUpdate: _panDisambiguator.update,
      onInteractionEnd: _panDisambiguator.end,
      maxScale: maxScale,
      scaleController: _scaleController,
      child: Align(
        alignment: Alignment.topCenter,
        child: AspectRatio(
          aspectRatio: sceneGridSize.aspectRatio,
          child: GridSizer(
            controller: _gridSizerController,
            minGridSize: _minGridSize,
            sizeFactor: maxScale,
            child: GridCanvas(
                controller: _gridCanvasController,
                fontFamily: widget.fontFamily),
          ),
        ),
      ),
    );
  }
}
