import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/grid_size.dart';
import 'copy_button.dart';
import 'covering_sheet.dart';
import 'emoji_grid.dart';
import 'emoji_picker.dart';
import 'palette.dart';
import 'save_image_button.dart';

@immutable
class DrawingPage extends StatelessWidget {
  final GridSize size;
  final String? fontFamily;

  const DrawingPage({Key? key, required this.size, this.fontFamily})
      : super(key: key);

  @override
  Widget build(_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DrawingState(size: size),
          ),
          ChangeNotifierProvider(create: (_) => CoveringSheetController())
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mojidraw'),
          ),
          body: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                child: Palette(fontFamily: fontFamily)),
            Flexible(
              child: _EmojiPickerSheet(size: size, fontFamily: fontFamily),
            )
          ]),
          bottomNavigationBar: BottomAppBar(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(children: [
              CopyButton(),
              SaveImageButton(fontFamily: fontFamily)
            ]),
          )),
        ),
      );
}

class _EmojiPickerSheet extends StatelessWidget {
  final GridSize size;
  final String? fontFamily;

  const _EmojiPickerSheet({Key? key, required this.size, this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) => CoveringSheet(
        controller: context.read<CoveringSheetController>(),
        sheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: EmojiPicker(fontFamily: fontFamily),
        ),
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 15.0),
                child: EmojiGrid(size: size, fontFamily: fontFamily),
              ),
            ),
          ],
        ),
      );
}
