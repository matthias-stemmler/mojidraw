import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/grid_layout.dart';
import '../util/grid_section.dart';
import '../util/grid_size.dart';
import '../util/rect.dart';

const double _borderWidth = 3.0;
const double _handleRadius = 4.0;
const double _maxHandleDistance = 30.0;

@immutable
class GridSizer extends StatefulWidget {
  final GridSizerController? controller;
  final GridSize minGridSize;
  final double sizeFactor;
  final Widget? child;

  const GridSizer(
      {Key? key,
      this.controller,
      this.minGridSize = GridSize.zero,
      this.sizeFactor = 1.0,
      this.child})
      : super(key: key);

  @override
  State createState() => _GridSizerState();
}

class _GridSizerState extends State<GridSizer> {
  double _opacity = 0.0, _backgroundOpacity = 0.0;
  _PanBase? _panBase;

  GridLayout getLayout(GridSize sceneGridSize) => GridLayout.fromSize(
      gridSize: sceneGridSize, size: context.size ?? Size.zero);

  void _handlePanStart(Offset position) {
    final state = context.read<DrawingState>();
    final layout = getLayout(state.sceneGridSize);
    final section = state.resizingSection;

    final rect = layout
        .sectionToRect(section)
        .inflate(_borderWidth * widget.sizeFactor / 2.0);
    final handle = getClosestHandle(
        rect, position, _maxHandleDistance * widget.sizeFactor);

    _panBase = handle == null ? null : _PanBase(section, handle, position);
  }

  void _handlePanUpdate(Offset position) {
    if (_panBase != null) {
      _handleMove(
          _panBase!.section, _panBase!.handle, position - _panBase!.position);
    }
  }

  void _handleMove(GridSection section, RectHandle handle, Offset delta) {
    final state = context.read<DrawingState>();
    final sceneGridSize = state.sceneGridSize;
    final layout = getLayout(sceneGridSize);

    final dx = (delta.dx / layout.cellSideLength).round();
    final dy = (delta.dy / layout.cellSideLength).round();

    state.resizingSection =
        _moveSection(section, handle, dx, dy, sceneGridSize);
  }

  GridSection _moveSection(GridSection section, RectHandle handle, int dx,
      int dy, GridSize sceneGridSize) {
    if (handle.isCenter) {
      return section.moved(
          dx.clamp(1 - section.left, sceneGridSize.width - 1 - section.right),
          dy.clamp(1 - section.top, sceneGridSize.height - 1 - section.bottom));
    }

    final left = handle.horizontalSide == RectHorizontalSide.left
        ? (section.left + dx).clamp(1, section.right - widget.minGridSize.width)
        : section.left;

    final top = handle.verticalSide == RectVerticalSide.top
        ? (section.top + dy)
            .clamp(1, section.bottom - widget.minGridSize.height)
        : section.top;

    final right = handle.horizontalSide == RectHorizontalSide.right
        ? (section.right + dx).clamp(
            section.left + widget.minGridSize.width, sceneGridSize.width - 1)
        : section.right;

    final bottom = handle.verticalSide == RectVerticalSide.bottom
        ? (section.bottom + dy).clamp(
            section.top + widget.minGridSize.height, sceneGridSize.height - 1)
        : section.bottom;

    return GridSection.fromLTRB(left, top, right, bottom);
  }

  void _handlePanEnd() {
    _panBase = null;
  }

  double get opacity => _opacity;

  set opacity(double value) {
    setState(() {
      _opacity = value;
    });
  }

  double get backgroundOpacity => _backgroundOpacity;

  set backgroundOpacity(double value) {
    setState(() {
      _backgroundOpacity = value;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
      foregroundPainter: GridSizerPainter(
          gridSize: context.select((DrawingState state) => state.sceneGridSize),
          section:
              context.select((DrawingState state) => state.resizingSection),
          color: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sizeFactor: widget.sizeFactor,
          opacity: _opacity,
          backgroundOpacity: _backgroundOpacity),
      child: widget.child);
}

class GridSizerController {
  _GridSizerState? _state;

  void handlePanStart(Offset position) => _state?._handlePanStart(position);

  void handlePanUpdate(Offset position) => _state?._handlePanUpdate(position);

  void handlePanEnd() => _state?._handlePanEnd();

  double get opacity => _state?.opacity ?? 0.0;

  set opacity(double value) => _state?.opacity = value;

  double get backgroundOpacity => _state?.backgroundOpacity ?? 0.0;

  set backgroundOpacity(double value) => _state?.backgroundOpacity = value;
}

@immutable
@visibleForTesting
class GridSizerPainter extends CustomPainter {
  final GridSize gridSize;
  final GridSection section;
  final Color color, backgroundColor;
  final double sizeFactor, opacity, backgroundOpacity;

  const GridSizerPainter(
      {required this.gridSize,
      required this.section,
      required this.color,
      required this.backgroundColor,
      required this.sizeFactor,
      required this.opacity,
      required this.backgroundOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final borderWidth = _borderWidth * sizeFactor;
    final handleRadius = _handleRadius * sizeFactor;

    final layout = GridLayout.fromSize(size: size, gridSize: gridSize);
    final innerRect = layout.sectionToRect(section);
    final outerRect = innerRect.inflate(borderWidth / 2.0);

    // save canvas to be able to restore the clip later
    canvas.save();

    // fill region outside inner rect with semi-transparent background color
    canvas.clipRect(innerRect, clipOp: ClipOp.difference);
    canvas.drawRect(Rect.largest,
        Paint()..color = backgroundColor.withOpacity(backgroundOpacity));

    canvas.restore();

    // save layer to apply opacity uniformly
    canvas.saveLayer(
        Rect.largest, Paint()..color = Color.fromRGBO(0, 0, 0, opacity));

    // save canvas to be able to restore the clip later
    canvas.save();

    // fill region between inner and outer rects with background color
    canvas.clipRect(innerRect, clipOp: ClipOp.difference);
    canvas.drawRect(outerRect, Paint()..color = backgroundColor);

    // fill region outside outer rect with semi-transparent black
    canvas.clipRect(outerRect, clipOp: ClipOp.difference);
    canvas.drawRect(Rect.largest, Paint()..color = Colors.black26);

    // draw outer rect border with foreground color, still clipped by outer rect
    canvas.drawRect(
        outerRect,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth);

    // restore clip so that handles don't get clipped
    canvas.restore();

    // draw handles
    final handlePaint = Paint()..color = color;

    for (final position in getHandlePositions(outerRect)) {
      canvas.drawCircle(position, handleRadius, handlePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is! GridSizerPainter ||
      oldDelegate is GridSizerPainter &&
          (oldDelegate.gridSize != gridSize ||
              oldDelegate.section != section ||
              oldDelegate.color != color ||
              oldDelegate.backgroundColor != backgroundColor ||
              oldDelegate.sizeFactor != sizeFactor ||
              oldDelegate.opacity != opacity ||
              oldDelegate.backgroundOpacity != backgroundOpacity);
}

@immutable
class _PanBase {
  final GridSection section;
  final RectHandle handle;
  final Offset position;

  _PanBase(this.section, this.handle, this.position);
}
