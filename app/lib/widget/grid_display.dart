import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/char_grid.dart';
import '../util/grid_cell.dart';
import '../util/grid_layout.dart';
import '../util/grid_size.dart';
import '../util/paint_grid_cell.dart';

@immutable
class GridDisplay extends StatefulWidget {
  final GridDisplayController? controller;
  final String? fontFamily;

  const GridDisplay({Key? key, this.controller, this.fontFamily})
      : super(key: key);

  @override
  State createState() => _GridDisplayState();
}

class _GridDisplayState extends State<GridDisplay> {
  double _emptyOpacity = 1.0;

  double get emptyOpacity => _emptyOpacity;

  set emptyOpacity(double value) {
    setState(() {
      _emptyOpacity = value;
    });
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
  Widget build(_) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final sceneGridSize =
              context.select((DrawingState state) => state.sceneGridSize);

          return CustomPaint(
              size: constraints.biggest,
              foregroundPainter: _NonEmptyGridCellsPainter(
                  grid: context.select((DrawingState state) => state.grid),
                  sceneGridSize: sceneGridSize,
                  topLeftCell: context.select(
                      (DrawingState state) => state.sceneGridSection.topLeft),
                  fontFamily: widget.fontFamily),
              child: RepaintBoundary(
                child: CustomPaint(
                    size: constraints.biggest,
                    painter: _EmptyGridCellsPainter(
                        grid: context
                            .select((DrawingState state) => state.resizedGrid),
                        sceneGridSize: sceneGridSize,
                        topLeftCell: context.select((DrawingState state) =>
                            state.resizingSection.topLeft),
                        emptyColor: Theme.of(context).primaryColor,
                        opacity: _emptyOpacity,
                        fontFamily: widget.fontFamily)),
              ));
        },
      );
}

class GridDisplayController {
  _GridDisplayState? _state;

  double get emptyOpacity => _state?.emptyOpacity ?? 1.0;

  set emptyOpacity(double value) => _state?.emptyOpacity = value;
}

@immutable
abstract class _GridCellsPainter extends CustomPainter {
  final CharGrid grid;
  final GridSize sceneGridSize;
  final GridCell topLeftCell;
  final String? fontFamily;

  _GridCellsPainter(
      {required this.grid,
      required this.sceneGridSize,
      required this.topLeftCell,
      this.fontFamily});

  bool isCellApplicable(GridCell cell) => true;

  Color? getBackgroundColor(GridCell cell) => null;

  @override
  void paint(Canvas canvas, Size size) {
    final layout = GridLayout.fromSize(size: size, gridSize: sceneGridSize);

    for (final cell in grid.size.cells.where(isCellApplicable)) {
      final offset = layout.cellToOffset(cell + topLeftCell);
      final cellSize = Size.square(layout.cellSideLength);

      paintGridCell(
          canvas: canvas,
          rect: offset & cellSize,
          text: grid.get(cell)!,
          fontFamily: fontFamily,
          backgroundColor: getBackgroundColor(cell));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is! _GridCellsPainter ||
      oldDelegate is _GridCellsPainter &&
          (oldDelegate.grid != grid ||
              oldDelegate.sceneGridSize != sceneGridSize ||
              oldDelegate.topLeftCell != topLeftCell ||
              oldDelegate.fontFamily != fontFamily);
}

@immutable
class _NonEmptyGridCellsPainter extends _GridCellsPainter {
  _NonEmptyGridCellsPainter(
      {required CharGrid grid,
      required GridSize sceneGridSize,
      required GridCell topLeftCell,
      String? fontFamily})
      : super(
            grid: grid,
            sceneGridSize: sceneGridSize,
            topLeftCell: topLeftCell,
            fontFamily: fontFamily);

  @override
  bool isCellApplicable(GridCell cell) => !grid.isEmpty(cell);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is! _NonEmptyGridCellsPainter ||
      super.shouldRepaint(oldDelegate);
}

@immutable
class _EmptyGridCellsPainter extends _GridCellsPainter {
  final Color emptyColor;
  final double opacity;

  _EmptyGridCellsPainter(
      {required CharGrid grid,
      required GridSize sceneGridSize,
      required GridCell topLeftCell,
      required this.emptyColor,
      required this.opacity,
      String? fontFamily})
      : super(
            grid: grid,
            sceneGridSize: sceneGridSize,
            topLeftCell: topLeftCell,
            fontFamily: fontFamily);

  @override
  bool isCellApplicable(GridCell cell) => grid.isEmpty(cell);

  @override
  Color getBackgroundColor(GridCell cell) =>
      emptyColor.withOpacity(opacity * 0.05 * grid.emptiness(cell));

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is! _EmptyGridCellsPainter ||
      oldDelegate is _EmptyGridCellsPainter &&
          (oldDelegate.emptyColor != emptyColor ||
              oldDelegate.opacity != opacity) ||
      super.shouldRepaint(oldDelegate);
}
