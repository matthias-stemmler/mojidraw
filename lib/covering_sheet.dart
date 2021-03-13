import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

const double _grabbingHeight = 25.0;
const _snapPositionOpen = SnapPosition(positionFactor: 1.0);
const _snapPositionClosed = SnapPosition(positionPixel: -_grabbingHeight);

class CoveringSheet extends StatefulWidget {
  final CoveringSheetController controller;
  final Widget child, sheet;

  const CoveringSheet({Key key, this.controller, this.sheet, this.child})
      : super(key: key);

  @override
  _CoveringSheetState createState() => _CoveringSheetState();
}

class _CoveringSheetState extends State<CoveringSheet> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: SnappingSheet(
        lockOverflowDrag: true,
        snapPositions: const [_snapPositionClosed, _snapPositionOpen],
        snappingSheetController: widget.controller._snappingSheetController,
        grabbingHeight: _grabbingHeight,
        grabbing: _Grabbing(),
        sheetBelow: SnappingSheetContent(
            child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: widget.sheet,
        )),
        child: widget.child,
      ));
}

class CoveringSheetController {
  final _snappingSheetController = SnappingSheetController();

  void toggle() => _snappingSheetController.snapToPosition(
      _snappingSheetController.currentSnapPosition == _snapPositionOpen
          ? _snapPositionClosed
          : _snapPositionOpen);
}

class _Grabbing extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
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
      );
}
