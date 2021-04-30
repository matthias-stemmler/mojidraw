import 'package:flutter/widgets.dart'
    hide InteractiveViewer, TransformationController;

import '../temp_flutter_master/interactive_viewer.dart';

class ScaleViewer extends StatefulWidget {
  final GestureScaleEndCallback? onInteractionEnd;
  final GestureScaleStartCallback? onInteractionStart;
  final GestureScaleUpdateCallback? onInteractionUpdate;
  final ScaleController? scaleController;
  final double maxScale;
  final Widget? child;

  const ScaleViewer(
      {Key? key,
      this.onInteractionEnd,
      this.onInteractionStart,
      this.onInteractionUpdate,
      this.scaleController,
      this.maxScale = 1.0,
      this.child})
      : super(key: key);

  @override
  State createState() => _ScaleViewerState();
}

class _ScaleViewerState extends State<ScaleViewer> {
  @override
  void initState() {
    super.initState();
    widget.scaleController?.maxScale = widget.maxScale;
  }

  @override
  void didUpdateWidget(ScaleViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.scaleController?.maxScale = widget.maxScale;
  }

  @override
  Widget build(_) => LayoutBuilder(
      builder: (_, BoxConstraints constraints) => InteractiveViewer(
          constrained: false,
          maxScale: 1.0,
          minScale: 1.0 / widget.maxScale,
          onInteractionEnd: widget.onInteractionEnd,
          onInteractionStart: widget.onInteractionStart,
          onInteractionUpdate: widget.onInteractionUpdate,
          panEnabled: false,
          transformationController:
              widget.scaleController?._transformationController,
          child: ConstrainedBox(
              constraints: constraints * widget.maxScale,
              child: widget.child)));
}

class ScaleController extends ChangeNotifier {
  final TransformationController _transformationController =
      TransformationController();
  double _maxScale = 1.0;

  ScaleController() {
    _transformationController.addListener(notifyListeners);
  }

  double get maxScale => _maxScale;

  set maxScale(double newMaxScale) {
    _transformationController.value =
        _transformationController.value.scaled(_maxScale / newMaxScale);
    _maxScale = newMaxScale;
  }

  Matrix4 get value => _transformationController.value.scaled(_maxScale);

  set value(Matrix4 newValue) =>
      _transformationController.value = newValue.scaled(1.0 / _maxScale);

  Offset toScene(Offset viewportPoint) =>
      _transformationController.toScene(viewportPoint);

  @override
  void dispose() {
    super.dispose();
    _transformationController.dispose();
  }
}
