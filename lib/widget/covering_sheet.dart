import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

const double _grabbingHeight = 25.0;
const _snappingPositionOpen = SnappingPosition.factor(
    positionFactor: 1.0, grabbingContentOffset: GrabbingContentOffset.bottom);
const _snappingPositionClosed = SnappingPosition.pixels(
    positionPixels: 0.0, grabbingContentOffset: GrabbingContentOffset.bottom);

@immutable
class CoveringSheet extends StatelessWidget {
  final CoveringSheetController controller;
  final Widget child, sheet;

  const CoveringSheet(
      {Key key,
      @required this.controller,
      @required this.sheet,
      @required this.child})
      : super(key: key);

  @override
  Widget build(_) => Scaffold(
          body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            SnappingSheet(
          lockOverflowDrag: true,
          snappingPositions: const [
            _snappingPositionClosed,
            _snappingPositionOpen
          ],
          controller: controller._snappingSheetController,
          onSheetMoved: (double position) =>
              controller._savePosition(position, constraints.maxHeight),
          grabbingHeight: _grabbingHeight,
          grabbing: _Grabbing(),
          sheetBelow: SnappingSheetContent(
              child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: sheet,
          )),
          child: child,
        ),
      ));
}

class CoveringSheetController extends ChangeNotifier {
  final _snappingSheetController = SnappingSheetController();
  double _openness = 0.0;

  double get openness => _openness;

  void toggle() => _snapToPosition(
      _snappingSheetController.currentSnappingPosition == _snappingPositionOpen
          ? _snappingPositionClosed
          : _snappingPositionOpen);

  void close() => _snapToPosition(_snappingPositionClosed);

  void _snapToPosition(SnappingPosition snappingPosition) {
    _snappingSheetController.snapToPosition(snappingPosition);
    notifyListeners();
  }

  void _savePosition(double position, double maxHeight) {
    final double openPosition =
        _snappingPositionOpen.getPositionInPixels(maxHeight, _grabbingHeight);
    final double closedPosition =
        _snappingPositionClosed.getPositionInPixels(maxHeight, _grabbingHeight);

    _openness = (closedPosition - position) / (closedPosition - openPosition);
    notifyListeners();
  }
}

class _Grabbing extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverflowBox(
        maxHeight: _grabbingHeight + 1.0,
        child: Container(
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: Container(
            width: 100.0,
            height: 5.0,
            decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          ),
        ),
      );
}
