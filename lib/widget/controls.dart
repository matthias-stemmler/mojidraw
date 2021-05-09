import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import 'copy_button.dart';
import 'save_image_button.dart';

@immutable
class Controls extends StatelessWidget {
  final String? fontFamily;

  const Controls({Key? key, this.fontFamily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool resizing =
        context.select((DrawingState state) => state.resizing);
    final bool resizeActionPending =
        context.select((DrawingState state) => state.resizePending);

    final bool resizeMode = resizing && !resizeActionPending;

    return IgnorePointer(
      ignoring: resizeActionPending,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Visibility(
          visible: !resizeMode,
          child: Row(
            children: [CopyButton(), SaveImageButton(fontFamily: fontFamily)],
          ),
        ),
        Row(children: [
          Visibility(
            visible: !resizeMode,
            child: IconButton(
                icon: const Icon(Icons.transform_outlined),
                tooltip: 'Change size of grid',
                onPressed: () {
                  context.read<DrawingState>().startResizing();
                }),
          ),
          Visibility(
            visible: resizeMode,
            child: IconButton(
                icon: const Icon(Icons.close_outlined),
                tooltip: 'Cancel',
                onPressed: () {
                  context.read<DrawingState>().requestCancelResizing();
                }),
          ),
          Visibility(
            visible: resizeMode,
            child: IconButton(
                icon: const Icon(Icons.check_outlined),
                tooltip: 'Confirm size change',
                onPressed: () {
                  context.read<DrawingState>().requestFinishResizing();
                }),
          )
        ])
      ]),
    );
  }
}
