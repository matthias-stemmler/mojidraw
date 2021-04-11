import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/grid_layout.dart';
import '../util/grid_section.dart';
import '../util/grid_size.dart';
import '../util/rect.dart';

const double _borderWidth = 3.0;
const double _handleRadius = 4.0;
const double _maxHandleDistance = 30.0;

const int _minSectionWidth = 2;
const int _minSectionHeight = 2;

Rect _inflateRect(Rect rect) => rect.inflate(_borderWidth / 2.0);

@immutable
class GridSizer extends StatefulWidget {
  final GridSizerController? controller;
  final Widget? child;

  const GridSizer({Key? key, this.controller, this.child}) : super(key: key);

  @override
  State createState() => _GridSizerState();
}

class _GridSizerState extends State<GridSizer> {
  _PanBase? _panBase;

  GridLayout getLayout(GridSize sceneGridSize) => GridLayout.fromSize(
      size: context.size ?? Size.zero, gridSize: sceneGridSize);

  void _handlePanStart(Offset position) {
    final DrawingState state = context.read();
    final GridLayout layout = getLayout(state.sceneGridSize);
    final GridSection section = state.resizingSection!;

    final Rect rect = _inflateRect(layout.sectionToRect(section));
    final double maxHandleDistance =
        min(rect.shortestSide / 4.0, _maxHandleDistance);
    final RectHandle? handle =
        getClosestHandle(rect, position, maxHandleDistance);

    _panBase = handle == null ? null : _PanBase(section, handle, position);
  }

  void _handlePanUpdate(Offset position) {
    if (_panBase != null) {
      _handleMove(
          _panBase!.section, _panBase!.handle, position - _panBase!.position);
    }
  }

  void _handleMove(GridSection section, RectHandle handle, Offset delta) {
    final DrawingState state = context.read();
    final GridSize sceneGridSize = state.sceneGridSize;
    final GridLayout layout = getLayout(sceneGridSize);

    final int dx = (delta.dx / layout.cellSize.width).round();
    final int dy = (delta.dy / layout.cellSize.height).round();

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

    final int left = handle.horizontalSide == RectHorizontalSide.left
        ? (section.left + dx).clamp(1, section.right - _minSectionWidth)
        : section.left;

    final int top = handle.verticalSide == RectVerticalSide.top
        ? (section.top + dy).clamp(1, section.bottom - _minSectionHeight)
        : section.top;

    final int right = handle.horizontalSide == RectHorizontalSide.right
        ? (section.right + dx)
            .clamp(section.left + _minSectionWidth, sceneGridSize.width - 1)
        : section.right;

    final int bottom = handle.verticalSide == RectVerticalSide.bottom
        ? (section.bottom + dy)
            .clamp(section.top + _minSectionHeight, sceneGridSize.height - 1)
        : section.bottom;

    return GridSection.fromLTRB(left, top, right, bottom);
  }

  void _handlePanEnd() {
    _panBase = null;
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  Widget build(BuildContext context) {
    final GridSection? section =
        context.select((DrawingState state) => state.resizingSection);

    final CustomPainter? painter = section == null
        ? null
        : GridSizerPainter(
            gridSize:
                context.select((DrawingState state) => state.sceneGridSize),
            section: section,
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor);

    return CustomPaint(foregroundPainter: painter, child: widget.child);
  }
}

class GridSizerController {
  _GridSizerState? _state;

  void handlePanStart(Offset position) => _state?._handlePanStart(position);

  void handlePanUpdate(Offset position) => _state?._handlePanUpdate(position);

  void handlePanEnd() => _state?._handlePanEnd();
}

@immutable
@visibleForTesting
class GridSizerPainter extends CustomPainter {
  final GridSize gridSize;
  final GridSection section;
  final Color color, backgroundColor;

  const GridSizerPainter(
      {required this.gridSize,
      required this.section,
      required this.color,
      required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final layout = GridLayout.fromSize(size: size, gridSize: gridSize);
    final Rect innerRect = layout.sectionToRect(section);
    final Rect outerRect = _inflateRect(innerRect);

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
          ..strokeWidth = _borderWidth);

    // restore clip so that handles don't get clipped
    canvas.restore();

    // draw handles
    final handlePaint = Paint()..color = color;

    for (final position in getHandlePositions(outerRect)) {
      canvas.drawCircle(position, _handleRadius, handlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is! GridSizerPainter ||
      oldDelegate is GridSizerPainter &&
          (oldDelegate.gridSize != gridSize ||
              oldDelegate.section != section ||
              oldDelegate.color != color ||
              oldDelegate.backgroundColor != backgroundColor);
}

class _PanBase {
  final GridSection section;
  final RectHandle handle;
  final Offset position;

  _PanBase(this.section, this.handle, this.position);
}
