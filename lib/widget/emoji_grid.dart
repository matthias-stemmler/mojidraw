import 'package:flutter/widgets.dart'
    hide InteractiveViewer, TransformationController;
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../temp_flutter_master/interactive_viewer.dart';
import '../util/grid_size.dart';
import '../util/pan_disambiguator.dart';
import '../widget/grid_canvas.dart';
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
  final _gridCanvasController = GridCanvasController();
  final _gridSizerController = GridSizerController();
  final _transformationController = TransformationController();

  Matrix4? _transformationBeforeResizing;

  bool get _resizing => context.read<DrawingState>().resizing;

  void _handlePanStart(Offset position) {
    final scenePosition = _transformationController.toScene(position);

    if (_resizing) {
      _gridSizerController.handlePanStart(scenePosition);
    } else {
      _gridCanvasController.handlePan(scenePosition);
    }
  }

  void _handlePanUpdate(Offset position) {
    final scenePosition = _transformationController.toScene(position);

    if (_resizing) {
      _gridSizerController.handlePanUpdate(scenePosition);
    } else {
      _gridCanvasController.handlePan(scenePosition);
    }
  }

  void _handlePanEnd() {
    if (_resizing) {
      _gridSizerController.handlePanEnd();
    }
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
    final GridSize sceneGridSize =
        context.select((DrawingState state) => state.sceneGridSize);

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
          child: GridCanvas(
              controller: _gridCanvasController, fontFamily: widget.fontFamily),
        ),
      ),
    );
  }
}
