import 'package:flutter/material.dart';

import '../util/fitting_text_renderer.dart';

const double _minButtonWidth = 48.0;
const EdgeInsets _padding = EdgeInsets.all(5.0);

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
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int buttonCount = (width / _minButtonWidth).floor();
        final buttonSize = Size.square(width / buttonCount);
        final Size textSize = _padding.deflateSize(buttonSize);
        final List<String> chars = getChars(buttonCount - 1).toList();

        return ToggleButtons(
          constraints: BoxConstraints.tight(buttonSize),
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
            ...chars.map((char) => char == ' '
                ? _text('␣', textSize)
                : _text(char, textSize, fontFamily: fontFamily)),
            _text('+', textSize)
          ],
        );
      }));
}

Widget _text(String text, Size size, {String fontFamily}) => Text(text,
    style: FittingTextRenderer(text: text, fontFamily: fontFamily)
        .getTextStyle(size));
