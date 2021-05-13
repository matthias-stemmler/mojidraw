import 'dart:math';

import 'package:flutter/material.dart'
    hide InteractiveViewer, TransformationController;
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/grid_layout.dart';
import '../util/grid_section.dart';
import '../util/grid_size.dart';
import '../util/pan_disambiguator.dart';
import 'grid_canvas.dart';
import 'grid_display.dart';
import 'grid_sizer.dart';
import 'scale_viewer.dart';

const _minGridSize = GridSize(2, 2);

@immutable
class EmojiGrid extends StatefulWidget {
  final String? fontFamily;

  const EmojiGrid({Key? key, this.fontFamily}) : super(key: key);

  @override
  State createState() => _EmojiGridState();
}

class _EmojiGridState extends State<EmojiGrid> with TickerProviderStateMixin {
  late final _animator = _EmojiGridAnimator(this);
  late final _panDisambiguator = PanDisambiguator(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd);
  final _gridCanvasController = GridCanvasController();
  final _gridDisplayController = GridDisplayController();
  final _gridSizerController = GridSizerController();
  final _scaleController = ScaleController();

  late Matrix4 _transformationBeforeResizing;

  bool get _resizing => context.read<DrawingState>().resizing;

  GridSection get _resizingSection =>
      context.read<DrawingState>().resizingSection;

  GridSize get _sceneGridSize => context.read<DrawingState>().sceneGridSize;

  GridSection get _sceneGridSection =>
      context.read<DrawingState>().sceneGridSection;

  GridLayout get _gridLayout => GridLayout.fromSize(
      gridSize: _sceneGridSize, size: context.size ?? Size.zero);

  void _handlePanStart(Offset position) {
    final scenePosition = _scaleController.toScene(position);

    if (_resizing) {
      _gridSizerController.handlePanStart(scenePosition);
    } else {
      _gridCanvasController.handlePan(scenePosition);
    }
  }

  void _handlePanUpdate(Offset position) {
    final scenePosition = _scaleController.toScene(position);

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
    _transformationBeforeResizing = _scaleController.value;

    _animator.animate(
        transformationTween: Matrix4Tween(
            begin: _scaleController.value.multiplied(
                _gridLayout.sectionToTransformation(_sceneGridSection)),
            end: Matrix4.identity()),
        opacityTween: Tween(begin: _gridSizerController.opacity, end: 1.0));
  }

  Future<void> _handleResizeCancelPending() async {
    await _animator.animate(
        transformationTween: Matrix4Tween(
            begin: _scaleController.value,
            end: _transformationBeforeResizing.multiplied(
                _gridLayout.sectionToTransformation(_sceneGridSection))),
        opacityTween: Tween(begin: _gridSizerController.opacity, end: 0.0));

    context.read<DrawingState>().commitPendingResizeAction();
    _scaleController.value = _transformationBeforeResizing;
  }

  Future<void> _handleResizeFinishPending() async {
    await _animator.animate(
        transformationTween: Matrix4Tween(
            begin: _scaleController.value,
            end: _gridLayout.sectionToTransformation(_resizingSection)),
        opacityTween: Tween(begin: _gridSizerController.opacity, end: 0.0),
        backgroundOpacityTween: Tween(begin: 0.0, end: 1.0));

    context.read<DrawingState>().commitPendingResizeAction();
    _scaleController.value = Matrix4.identity();
  }

  @override
  void initState() {
    super.initState();

    final state = context.read();
    state.resizeStartNotifier.addListener(_handleResizeStart);
    state.resizeCancelPendingNotifier.addListener(_handleResizeCancelPending);
    state.resizeFinishPendingNotifier.addListener(_handleResizeFinishPending);
  }

  @override
  void dispose() {
    _animator.dispose();

    final state = context.read();
    state.resizeStartNotifier.removeListener(_handleResizeStart);
    state.resizeCancelPendingNotifier
        .removeListener(_handleResizeCancelPending);
    state.resizeFinishPendingNotifier
        .removeListener(_handleResizeFinishPending);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resizing = context.select((DrawingState state) => state.resizing);
    final resizePending =
        context.select((DrawingState state) => state.resizePending);
    final sceneGridSize =
        context.select((DrawingState state) => state.sceneGridSize);
    final maxScale = max(sceneGridSize.width / _minGridSize.width,
        sceneGridSize.height / _minGridSize.height);

    return IgnorePointer(
      ignoring: resizePending,
      child: ScaleViewer(
        onInteractionStart: (details) {
          _animator.stopTransformationAnimation();
          _panDisambiguator.start(details);
        },
        onInteractionUpdate: (details) {
          _animator.stopTransformationAnimation();
          _panDisambiguator.update(details);
        },
        onInteractionEnd: (details) {
          _animator.stopTransformationAnimation();
          _panDisambiguator.end(details);
        },
        maxScale: maxScale,
        scaleController: _scaleController,
        child: GridSizer(
            controller: _gridSizerController,
            minGridSize: _minGridSize,
            sizeFactor: maxScale,
            child: resizing
                ? GridDisplay(
                    controller: _gridDisplayController,
                    fontFamily: widget.fontFamily)
                : GridCanvas(
                    controller: _gridCanvasController,
                    fontFamily: widget.fontFamily)),
      ),
    );
  }
}

class _EmojiGridAnimator {
  final _EmojiGridState state;

  final AnimationController _animationController;

  Animatable<Matrix4>? _transformationTween;
  Animatable<double>? _opacityTween, _backgroundOpacityTween;

  _EmojiGridAnimator(this.state)
      : _animationController = AnimationController(
            vsync: state, duration: const Duration(milliseconds: 500)) {
    _animationController.addListener(_step);
  }

  void dispose() => _animationController.dispose();

  Future<void> animate(
      {Animatable<Matrix4>? transformationTween,
      Animatable<double>? opacityTween,
      Animatable<double>? backgroundOpacityTween}) async {
    _transformationTween = transformationTween;
    _opacityTween = opacityTween;
    _backgroundOpacityTween = backgroundOpacityTween ?? ConstantTween(0.0);

    _animationController.reset();
    await _animationController.animateTo(_animationController.upperBound,
        curve: Curves.easeInOut);

    _transformationTween = null;
    _opacityTween = null;
    _backgroundOpacityTween = null;
  }

  void stopTransformationAnimation() => _transformationTween = null;

  void _step() {
    final value = _animationController.value;

    if (_transformationTween != null) {
      state._scaleController.value = _transformationTween!.transform(value);
    }

    if (_opacityTween != null) {
      final opacity = _opacityTween!.transform(value);
      state._gridSizerController.opacity = opacity;
      state._gridDisplayController.emptyOpacity = 1.0 - opacity;
    }

    if (_backgroundOpacityTween != null) {
      state._gridSizerController.backgroundOpacity =
          _backgroundOpacityTween!.transform(value);
    }
  }
}
