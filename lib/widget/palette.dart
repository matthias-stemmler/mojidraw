import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/fitting_text_renderer.dart';

const double _minButtonWidth = 48.0;
const EdgeInsets _padding = EdgeInsets.all(5.0);

@immutable
class Palette extends StatelessWidget {
  final void Function() onPenSwitched;
  final void Function() onExpandToggled;
  final String fontFamily;

  const Palette(
      {Key key, this.onPenSwitched, this.onExpandToggled, this.fontFamily})
      : super(key: key);

  @override
  Widget build(_) => Container(
      alignment: Alignment.topLeft,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final Iterable<String> chars =
            context.select((DrawingState state) => state.paletteChars);

        final double width = constraints.maxWidth;
        final int buttonCount = (width / _minButtonWidth).floor();
        final buttonSize = Size.square(width / buttonCount);
        final buttonConstraints = BoxConstraints.tight(buttonSize);
        final Size textSize = _padding.deflateSize(buttonSize);

        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _PenButtons(
                    chars: chars,
                    constraints: buttonConstraints,
                    textSize: textSize,
                    fontFamily: fontFamily),
              ),
            ),
            _ExpandButton(
                constraints: buttonConstraints,
                textSize: textSize,
                onPressed: onExpandToggled)
          ],
        );
      }));
}

class _PenButtons extends StatelessWidget {
  final Iterable<String> chars;
  final BoxConstraints constraints;
  final Size textSize;
  final String fontFamily;
  final void Function() onPenSwitched;

  const _PenButtons(
      {Key key,
      @required this.chars,
      @required this.constraints,
      @required this.textSize,
      this.fontFamily,
      this.onPenSwitched})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int penIndex = context.select((DrawingState state) => state.penIndex);
    final isSelected =
        Iterable.generate(chars.length).map((index) => index == penIndex);

    return ToggleButtons(
      constraints: constraints,
      renderBorder: false,
      isSelected: isSelected.toList(),
      onPressed: (int index) {
        context.read<DrawingState>().switchPen(index);
        onPenSwitched?.call();
      },
      children: chars
          .map((char) => char == ' '
              ? _Text('␣', size: textSize)
              : _Text(char, size: textSize, fontFamily: fontFamily))
          .toList(),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  final BoxConstraints constraints;
  final Size textSize;
  final void Function() onPressed;

  const _ExpandButton(
      {Key key,
      @required this.constraints,
      @required this.textSize,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ToggleButtons(
      constraints: constraints,
      renderBorder: false,
      isSelected: const [false],
      onPressed: (_) => onPressed(),
      children: [_Text('+', size: textSize)]);
}

@immutable
class _Text extends StatelessWidget {
  final String text;
  final Size size;
  final String fontFamily;

  const _Text(this.text, {Key key, @required this.size, this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Text(text,
      style: FittingTextRenderer(text: text, fontFamily: fontFamily)
          .getTextStyle(size));
}
