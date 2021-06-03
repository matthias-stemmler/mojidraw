import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

const double _grabbingHeight = 25.0;
const double _grabbingCorrection = 1.0;

const _snappingPositionOpen = SnappingPosition.factor(
    positionFactor: 1.0, grabbingContentOffset: GrabbingContentOffset.bottom);
const _snappingPositionClosed = SnappingPosition.pixels(
    positionPixels: -_grabbingCorrection,
    grabbingContentOffset: GrabbingContentOffset.bottom);

@immutable
class CoveringSheet extends StatelessWidget {
  final CoveringSheetController controller;
  final Widget child, sheet;

  const CoveringSheet(
      {Key? key,
      required this.controller,
      required this.sheet,
      required this.child})
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
          onSheetMoved: (positionData) =>
              controller._setOpenness(positionData.relativeToSnappingPositions),
          grabbingHeight: _grabbingHeight,
          grabbing: _Grabbing(),
          sheetBelow: SnappingSheetContent(
              child: DecoratedBox(
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

  void _setOpenness(double value) {
    _openness = value;
    notifyListeners();
  }

  void toggle() => _snapToPosition(
      _snappingSheetController.currentSnappingPosition == _snappingPositionOpen
          ? _snappingPositionClosed
          : _snappingPositionOpen);

  void close() => _snapToPosition(_snappingPositionClosed);

  void _snapToPosition(SnappingPosition snappingPosition) {
    _snappingSheetController.snapToPosition(snappingPosition);
    notifyListeners();
  }
}

@immutable
class _Grabbing extends StatelessWidget {
  @override
  Widget build(BuildContext context) => OverflowBox(
        maxHeight: _grabbingHeight + _grabbingCorrection,
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
