import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import 'controls.dart';
import 'covering_sheet.dart';
import 'emoji_grid.dart';
import 'emoji_picker.dart';
import 'menu.dart';
import 'palette.dart';

@immutable
class DrawingPage extends StatelessWidget {
  final String? fontFamily;

  const DrawingPage({Key? key, this.fontFamily}) : super(key: key);

  @override
  Widget build(_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DrawingState(),
          ),
          ChangeNotifierProvider(create: (_) => CoveringSheetController())
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mojidraw'),
          ),
          drawer: Drawer(
            child: Menu(),
          ),
          drawerEnableOpenDragGesture: false,
          body: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                child: Palette(fontFamily: fontFamily)),
            Flexible(
              child: _EmojiPickerSheet(fontFamily: fontFamily),
            )
          ]),
          bottomNavigationBar: BottomAppBar(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Controls(fontFamily: fontFamily),
          )),
        ),
      );
}

@immutable
class _EmojiPickerSheet extends StatelessWidget {
  final String? fontFamily;

  const _EmojiPickerSheet({Key? key, this.fontFamily}) : super(key: key);

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
                padding: const EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 30.0),
                child: EmojiGrid(fontFamily: fontFamily),
              ),
            ),
          ],
        ),
      );
}
