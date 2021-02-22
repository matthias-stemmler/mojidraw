import 'package:flutter/material.dart';

const double _minButtonWidth = 48.0;
const double _fontSize = 32.0;

@immutable
class Palette extends StatelessWidget {
  final String fontFamily;
  final List<String> chars;
  final String selectedChar;
  final void Function(String char) onCharSelected;
  final void Function() onAddPressed;

  const Palette(
      {Key key,
      this.fontFamily,
      this.chars = const [],
      this.selectedChar,
      this.onCharSelected,
      this.onAddPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.topLeft,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final int buttonCount =
            (constraints.maxWidth / _minButtonWidth).floor();
        final double buttonSize = constraints.maxWidth / buttonCount;
        final Iterable<String> visibleChars = chars.take(buttonCount - 1);
        final textStyle =
            TextStyle(fontFamily: fontFamily, fontSize: _fontSize);

        return ToggleButtons(
            constraints: BoxConstraints.tight(Size.square(buttonSize)),
            renderBorder: false,
            children: [
              ...visibleChars.map((char) => Text(
                    char == ' ' ? '␣' : char,
                    style: textStyle,
                  )),
              Text('+', style: textStyle)
            ],
            isSelected: [
              ...visibleChars.map((char) => char == selectedChar),
              false
            ],
            onPressed: (int index) {
              if (index < visibleChars.length) {
                onCharSelected?.call(chars[index]);
              } else {
                onAddPressed?.call();
              }
            });
      }));
}
