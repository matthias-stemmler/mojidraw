import 'dart:ui';

import 'package:flutter/material.dart';

import 'char_grid.dart';
import 'text_renderer.dart';

void main() {
  runApp(MojiDrawApp());
}

class MojiDrawApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mojidraw',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MojiDrawPage(title: 'Mojidraw', width: 15, height: 20),
    );
  }
}

class MojiDrawPage extends StatefulWidget {
  final String title;
  final int width, height;

  MojiDrawPage({Key key, this.title, this.width, this.height})
      : super(key: key);

  @override
  _MojiDrawPageState createState() => _MojiDrawPageState();
}

class _MojiDrawPageState extends State<MojiDrawPage> {
  CharGrid _emojis;

  @override
  void initState() {
    super.initState();
    _emojis = CharGrid(widget.width, widget.height, background: '❤');
  }

  void _activateEmoji(int x, int y) {
    setState(() {
      _emojis.set(x, y, '🦔');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
              child: EmojiGrid(emojis: _emojis, onEmojiTouch: _activateEmoji))),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class EmojiGrid extends StatelessWidget {
  final CharGrid emojis;
  final void Function(int x, int y) onEmojiTouch;

  const EmojiGrid({Key key, this.emojis, this.onEmojiTouch}) : super(key: key);

  _handlePanUpdate(Offset position, Size size) {
    final layout = GridLayout(size, emojis.width, emojis.height);
    final cell = layout.offsetToCell(position);

    if (cell != null) {
      onEmojiTouch(cell.x, cell.y);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: onEmojiTouch == null
            ? null
            : (details) {
                _handlePanUpdate(details.localPosition, context.size);
              },
        child: AspectRatio(
            aspectRatio: emojis.aspectRatio,
            child: CustomPaint(painter: GridPainter(emojis))));
  }
}

class GridPainter extends CustomPainter {
  final CharGrid _emojis;
  final Map<String, TextRenderer> _textEmojis = {
    '❤': TextRenderer('❤'),
    '🦔': TextRenderer('🦔')
  };

  GridPainter(this._emojis);

  @override
  void paint(Canvas canvas, Size size) {
    final layout = GridLayout(size, _emojis.width, _emojis.height);
    final cellWidth = layout.cellSize.width;

    for (final y in Iterable<int>.generate(_emojis.height)) {
      for (final x in Iterable<int>.generate(_emojis.width)) {
        canvas.drawParagraph(
            _textEmojis[this._emojis.get(x, y)].render(cellWidth),
            layout.cellToOffset(GridCell(x, y)));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class GridLayout {
  Size _cellSize;
  int _horizontalCells, _verticalCells;

  GridLayout(Size size, this._horizontalCells, this._verticalCells) {
    _cellSize =
        Size(size.width / _horizontalCells, size.height / _verticalCells);
  }

  Offset cellToOffset(GridCell cell) =>
      Offset(cell.x * _cellSize.width, cell.y * _cellSize.height);

  GridCell offsetToCell(Offset offset) {
    int x = (offset.dx / _cellSize.width).floor();
    int y = (offset.dy / _cellSize.height).floor();

    return x >= 0 && x < _horizontalCells && y >= 0 && y < _verticalCells
        ? GridCell(x, y)
        : null;
  }

  Size get cellSize => _cellSize;
}

class GridCell {
  final int x, y;

  GridCell(this.x, this.y);
}
