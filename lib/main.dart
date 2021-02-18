import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'char_grid.dart';
import 'fitting_text_renderer.dart';
import 'grid_cell.dart';
import 'grid_layout.dart';

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
        home: MojiDrawPage(title: 'Mojidraw', width: 10, height: 10),
      );
}

class MojiDrawPage extends StatefulWidget {
  final String title;
  final int width, height;

  const MojiDrawPage({Key key, this.title, this.width, this.height})
      : super(key: key);

  @override
  _MojiDrawPageState createState() => _MojiDrawPageState();
}

class _MojiDrawPageState extends State<MojiDrawPage> {
  CharGrid _emojis;

  @override
  void initState() {
    super.initState();
    _emojis = CharGrid(widget.width, widget.height, background: '🍀');
  }

  void _activateEmoji(GridCell cell) {
    setState(() {
      _emojis.set(cell, '🦦');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Center(
                child:
                    EmojiGrid(emojis: _emojis, onEmojiTouch: _activateEmoji))),
        floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
                  tooltip: 'Copy to clipboard',
                  child: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _emojis.text));

                    final snackBar = SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(milliseconds: 1500),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  },
                )),
      );
}

class EmojiGrid extends StatelessWidget {
  final CharGrid emojis;
  final void Function(GridCell cell) onEmojiTouch;

  const EmojiGrid({Key key, this.emojis, this.onEmojiTouch}) : super(key: key);

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
                painter:
                    GridPainter(emojis: emojis, fontFamily: 'JoyPixels'))));
  }
}

class GridPainter extends CustomPainter {
  final CharGrid emojis;
  final Map<String, FittingTextRenderer> _renderers;

  GridPainter({this.emojis, String fontFamily})
      : _renderers = {
          '🍀': FittingTextRenderer(text: '🍀', fontFamily: fontFamily),
          '🦦': FittingTextRenderer(text: '🦦', fontFamily: fontFamily)
        };

  @override
  void paint(Canvas canvas, Size size) {
    final layout = GridLayout(size, emojis.width, emojis.height);

    for (final cell in layout.cells) {
      final TextPainter painter =
          _renderers[this.emojis.get(cell)].render(layout.cellSize);
      painter.paint(canvas, layout.cellToOffset(cell));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
