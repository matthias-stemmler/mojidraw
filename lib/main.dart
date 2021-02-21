import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'char_grid.dart';
import 'fitting_text_renderer.dart';
import 'grid_cell.dart';
import 'grid_layout.dart';
import 'palette.dart';

void main() {
  runApp(MojiDrawApp());
}

class MojiDrawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Mojidraw',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            snackBarTheme:
                SnackBarThemeData(behavior: SnackBarBehavior.floating)),
        home: MojiDrawPage(
            title: 'Mojidraw', width: 9, height: 9, fontFamily: 'JoyPixels'),
      );
}

class MojiDrawPage extends StatefulWidget {
  final String title;
  final int width, height;
  final String fontFamily;

  const MojiDrawPage(
      {Key key, this.title, this.width, this.height, this.fontFamily})
      : super(key: key);

  @override
  _MojiDrawPageState createState() => _MojiDrawPageState();
}

class _MojiDrawPageState extends State<MojiDrawPage> {
  CharGrid _emojis;
  String _penEmoji;

  @override
  void initState() {
    super.initState();
    _emojis = CharGrid(widget.width, widget.height, background: '🍀');
    _penEmoji = '❤';
  }

  void _activateEmoji(GridCell cell) {
    setState(() {
      _emojis.set(cell, _penEmoji);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(children: [
              Container(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Palette(
                    chars: [' ', '🍀', '🦦', '❤', '🌊'],
                    fontFamily: widget.fontFamily,
                    selectedChar: _penEmoji,
                    onCharSelected: (char) => setState(() {
                      _penEmoji = char;
                    }),
                  )),
              Flexible(
                  child: EmojiGrid(
                      emojis: _emojis,
                      onEmojiTouch: _activateEmoji,
                      fontFamily: widget.fontFamily))
            ])),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Copy to clipboard',
          child: Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _emojis.text));

            Fluttertoast.showToast(
              msg: 'Copied to clipboard',
            );
          },
        ),
      );
}

class EmojiGrid extends StatelessWidget {
  final CharGrid emojis;
  final void Function(GridCell cell) onEmojiTouch;
  final String fontFamily;

  const EmojiGrid({Key key, this.emojis, this.onEmojiTouch, this.fontFamily})
      : super(key: key);

  _handlePan(Offset position, Size size) {
    final layout = GridLayout(size, emojis.width, emojis.height);
    final GridCell cell = layout.offsetToCell(position);

    if (cell != null) {
      onEmojiTouch(cell);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onPan = onEmojiTouch == null
        ? null
        : (details) {
            _handlePan(details.localPosition, context.size);
          };
    return GestureDetector(
        onPanStart: onPan,
        onPanUpdate: onPan,
        child: AspectRatio(
            aspectRatio: emojis.aspectRatio,
            child: CustomPaint(
                painter: GridPainter(emojis: emojis, fontFamily: fontFamily))));
  }
}

class GridPainter extends CustomPainter {
  final CharGrid emojis;
  final String fontFamily;

  const GridPainter({this.emojis, this.fontFamily});

  @override
  void paint(Canvas canvas, Size size) {
    final layout = GridLayout(size, emojis.width, emojis.height);

    for (final cell in layout.cells) {
      final renderer = FittingTextRenderer(
          text: this.emojis.get(cell), fontFamily: fontFamily);
      final TextPainter painter = renderer.render(layout.cellSize);
      painter.paint(canvas, layout.cellToOffset(cell));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
