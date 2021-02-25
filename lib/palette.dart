import 'package:flutter/material.dart';

const double _minButtonWidth = 48.0;
const double _fontSize = 32.0;

@immutable
class Palette extends StatelessWidget {
  final String fontFamily;
  final String selectedChar;

  final Iterable<String> Function(int count) getChars;
  final void Function(String char) onCharSelected;
  final void Function() onAddPressed;

  const Palette(
      {Key key,
      @required this.getChars,
      this.fontFamily,
      this.selectedChar,
      this.onCharSelected,
      this.onAddPressed})
      : super(key: key);

  @override
  Widget build(_) => Container(
      alignment: Alignment.topLeft,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int buttonCount = (width / _minButtonWidth).floor();
        final double buttonSize = width / buttonCount;
        final List<String> chars = getChars(buttonCount - 1).toList();

        return ToggleButtons(
          constraints: BoxConstraints.tight(Size.square(buttonSize)),
          renderBorder: false,
          isSelected: [...chars.map((char) => char == selectedChar), false],
          onPressed: (int index) {
            if (index < chars.length) {
              onCharSelected?.call(chars[index]);
            } else {
              onAddPressed?.call();
            }
          },
          children: [
            ...chars.map((char) =>
                char == ' ' ? _text('␣') : _text(char, fontFamily: fontFamily)),
            _text('+')
          ],
        );
      }));
}

Widget _text(String text, {String fontFamily}) =>
    Text(text, style: TextStyle(fontFamily: fontFamily, fontSize: _fontSize));
