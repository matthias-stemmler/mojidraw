import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mojidraw/covering_sheet.dart';

import 'char_grid.dart';
import 'emoji_grid.dart';
import 'emoji_picker.dart';
import 'grid_cell.dart';
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
        home: const _MojiDrawPage(
            title: 'Mojidraw', width: 21, height: 21, fontFamily: 'JoyPixels'),
      );
}

class _MojiDrawPage extends StatefulWidget {
  final String title;
  final int width, height;
  final String fontFamily;

  const _MojiDrawPage(
      {Key key, this.title, this.width, this.height, this.fontFamily})
      : super(key: key);

  @override
  State createState() => _MojiDrawPageState();
}

class _MojiDrawPageState extends State<_MojiDrawPage> {
  final _coveringSheetController = CoveringSheetController();

  CharGrid _emojis;
  String _penEmoji;

  @override
  void initState() {
    super.initState();
    _emojis = CharGrid(GridSize(widget.width, widget.height), background: '🍀');
    _penEmoji = '❤';
  }

  void _drawEmoji(GridCell cell) {
    setState(() {
      _emojis.set(cell, _penEmoji);
    });
  }

  void _switchPen(String penEmoji) {
    setState(() {
      _penEmoji = penEmoji;
    });
  }

  @override
  Widget build(_) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Palette(
                      getChars: [' ', '🍀', '🦦', '❤', '🌊'].take,
                      fontFamily: widget.fontFamily,
                      selectedChar: _penEmoji,
                      onCharSelected: _switchPen,
                      onAddPressed: _coveringSheetController.toggle)),
              Flexible(
                child: CoveringSheet(
                  controller: _coveringSheetController,
                  sheet: EmojiPicker(fontFamily: widget.fontFamily),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: EmojiGrid(
                            emojis: _emojis,
                            onEmojiTouch: _drawEmoji,
                            fontFamily: widget.fontFamily),
                      ),
                    ],
                  ),
                ),
              )
            ])),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(children: [
            IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy to clipboard',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _emojis.text));

                  Fluttertoast.showToast(
                    msg: 'Copied to clipboard',
                  );
                })
          ]),
        )),
      );
}
