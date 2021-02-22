import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'char_grid.dart';
import 'fitting_text_renderer.dart';
import 'grid_cell.dart';
import 'grid_layout.dart';
import 'grid_size.dart';
import 'palette.dart';

void main() {
  runApp(_MojiDrawApp());
}

class _MojiDrawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Mojidraw',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: _MojiDrawPage(
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
  _MojiDrawPageState createState() => _MojiDrawPageState();
}

class _MojiDrawPageState extends State<_MojiDrawPage> {
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
                    getChars: (count) =>
                        [' ', '🍀', '🦦', '❤', '🌊'].take(count),
                    fontFamily: widget.fontFamily,
                    selectedChar: _penEmoji,
                    onCharSelected: _switchPen,
                  )),
              Flexible(
                  child: _EmojiGrid(
                      emojis: _emojis,
                      onEmojiTouch: _drawEmoji,
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

class _EmojiGrid extends StatelessWidget {
  final CharGrid emojis;
  final void Function(GridCell cell) onEmojiTouch;
  final String fontFamily;

  const _EmojiGrid({Key key, this.emojis, this.onEmojiTouch, this.fontFamily})
      : super(key: key);

  _handlePan(Offset position, Size size) {
    final layout = GridLayout(size, emojis.size);
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
            child: CustomMultiChildLayout(
                delegate: _GridLayoutDelegate(emojis.size),
                children: emojis.cells
                    .map((cell) => LayoutId(
                        id: cell,
                        child: RepaintBoundary(
                            child: CustomPaint(
                                painter: _GridCellPainter(
                                    text: emojis.get(cell),
                                    fontFamily: fontFamily)))))
                    .toList())));
  }
}

class _GridLayoutDelegate extends MultiChildLayoutDelegate {
  final GridSize _gridSize;

  _GridLayoutDelegate(this._gridSize);

  @override
  void performLayout(Size size) {
    final layout = GridLayout(size, _gridSize);

    for (final cell in layout.cells) {
      layoutChild(cell, BoxConstraints.tight(layout.cellSize));
      positionChild(cell, layout.cellToOffset(cell));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) =>
      oldDelegate is _GridLayoutDelegate
          ? oldDelegate._gridSize != _gridSize
          : true;
}

@immutable
class _GridCellPainter extends CustomPainter {
  final String text;
  final String fontFamily;

  const _GridCellPainter({@required this.text, this.fontFamily});

  @override
  void paint(Canvas canvas, Size size) {
    final renderer = FittingTextRenderer(text: text, fontFamily: fontFamily);
    final TextPainter painter = renderer.render(size);
    painter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is _GridCellPainter
          ? oldDelegate.text != text || oldDelegate.fontFamily != fontFamily
          : true;
}
