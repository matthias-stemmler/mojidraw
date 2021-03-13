import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mojidraw/covering_sheet.dart';
import 'package:mojidraw/grid_drawing_state.dart';
import 'package:provider/provider.dart';

import 'emoji_grid.dart';
import 'emoji_picker.dart';
import 'grid_size.dart';
import 'palette.dart';

void main() {
  runApp(_MojiDrawApp());
}

class _MojiDrawApp extends StatelessWidget {
  @override
  Widget build(_) => MaterialApp(
        title: 'Mojidraw',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: _MojiDrawPage(
            title: 'Mojidraw', width: 21, height: 21, fontFamily: 'JoyPixels'),
      );
}

class _MojiDrawPage extends StatelessWidget {
  final _coveringSheetController = CoveringSheetController();
  final String title;
  final int width, height;
  final String fontFamily;

  _MojiDrawPage({Key key, this.title, this.width, this.height, this.fontFamily})
      : super(key: key);

  @override
  Widget build(_) => ChangeNotifierProvider(
        create: (_) => GridDrawingState(width: width, height: height),
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _Palette(
                      fontFamily: fontFamily,
                      onToggle: _coveringSheetController.toggle,
                    )),
                Flexible(
                  child: CoveringSheet(
                    controller: _coveringSheetController,
                    sheet: EmojiPicker(fontFamily: fontFamily),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: EmojiGrid(
                              size: GridSize(width, height),
                              fontFamily: fontFamily),
                        ),
                      ],
                    ),
                  ),
                )
              ])),
          bottomNavigationBar: BottomAppBar(
              child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(children: [_CopyButton()]),
          )),
        ),
      );
}

class _CopyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
      icon: const Icon(Icons.copy),
      tooltip: 'Copy to clipboard',
      onPressed: () {
        Clipboard.setData(
            ClipboardData(text: context.read<GridDrawingState>().text));

        Fluttertoast.showToast(
          msg: 'Copied to clipboard',
        );
      });
}

class _Palette extends StatelessWidget {
  final String fontFamily;
  final void Function() onToggle;

  const _Palette({Key key, this.fontFamily, this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) => Palette(
      getChars: [' ', '🍀', '🦦', '❤', '🌊'].take,
      fontFamily: fontFamily,
      selectedChar: context.select((GridDrawingState state) => state.pen),
      onCharSelected: (char) =>
          context.read<GridDrawingState>().switchPen(char),
      onAddPressed: onToggle);
}
