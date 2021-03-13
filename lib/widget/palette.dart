import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/fitting_text_renderer.dart';

const double _minButtonWidth = 48.0;
const EdgeInsets _padding = EdgeInsets.all(5.0);

@immutable
class Palette extends StatelessWidget {
  final Iterable<String> Function(int count) getChars;
  final String fontFamily;
  final void Function() onAddPressed;

  const Palette(
      {Key key, @required this.getChars, this.fontFamily, this.onAddPressed})
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

        return _Buttons(
            chars: chars,
            constraints: BoxConstraints.tight(buttonSize),
            textSize: textSize,
            fontFamily: fontFamily,
            onAddPressed: onAddPressed);
      }));
}

class _Buttons extends StatelessWidget {
  final List<String> chars;
  final BoxConstraints constraints;
  final Size textSize;
  final String fontFamily;
  final void Function() onAddPressed;

  const _Buttons(
      {Key key,
      @required this.chars,
      @required this.constraints,
      @required this.textSize,
      this.fontFamily,
      this.onAddPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pen = context.select((DrawingState state) => state.pen);

    return ToggleButtons(
      constraints: constraints,
      renderBorder: false,
      isSelected: [...chars.map((char) => char == pen), false],
      onPressed: (int index) {
        if (index < chars.length) {
          context.read<DrawingState>().switchPen(chars[index]);
        } else {
          onAddPressed?.call();
        }
      },
      children: [
        ...chars.map((char) => char == ' '
            ? _Text('␣', size: textSize)
            : _Text(char, size: textSize, fontFamily: fontFamily)),
        _Text('+', size: textSize)
      ],
    );
  }
}

@immutable
class _Text extends StatelessWidget {
  final String text;
  final Size size;
  final String fontFamily;

  const _Text(this.text, {Key key, this.size, this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Text(text,
      style: FittingTextRenderer(text: text, fontFamily: fontFamily)
          .getTextStyle(size));
}
