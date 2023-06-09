import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/fitting_text_renderer.dart';
import 'covering_sheet.dart';

const double _minButtonWidth = 48.0;
const EdgeInsets _buttonPadding = EdgeInsets.all(5.0);
const double _buttonCutoffRatio = 0.5;
const Duration _scrollDuration = Duration(milliseconds: 300);
const Curve _scrollCurve = Curves.easeInOut;

@immutable
class Palette extends StatelessWidget {
  final String? fontFamily;

  final ScrollController _scrollController = ScrollController();

  Palette({Key? key, this.fontFamily}) : super(key: key);

  void _handlePenSelected(
      int penIndex, double scrollWidth, double buttonWidth) {
    final focusLeft = penIndex * buttonWidth;
    final viewportLeft = _scrollController.offset;

    if (focusLeft < viewportLeft) {
      _scrollTo(focusLeft);
      return;
    }

    final focusRight = focusLeft + buttonWidth;
    final viewportRight = viewportLeft + scrollWidth;

    if (focusRight > viewportRight) {
      _scrollTo(focusRight - scrollWidth);
    }
  }

  void _scrollTo(double offset) {
    _scrollController.animateTo(offset,
        duration: _scrollDuration, curve: _scrollCurve);
  }

  @override
  Widget build(_) => Align(
      alignment: Alignment.topLeft,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final chars =
            context.select((DrawingState state) => state.paletteChars);

        final width = constraints.maxWidth;
        final buttonCount =
            (width / _minButtonWidth - _buttonCutoffRatio).floor() +
                _buttonCutoffRatio;
        final buttonWidth = width / buttonCount;
        final scrollWidth = width - buttonWidth;
        final buttonSize = Size.square(buttonWidth);
        final buttonConstraints = BoxConstraints.tight(buttonSize);
        final textSize = _buttonPadding.deflateSize(buttonSize);

        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: _PenButtons(
                  chars: chars,
                  constraints: buttonConstraints,
                  textSize: textSize,
                  fontFamily: fontFamily,
                  onPenSelected: (penIndex) =>
                      _handlePenSelected(penIndex, scrollWidth, buttonWidth),
                ),
              ),
            ),
            _ExpandButton(constraints: buttonConstraints, textSize: textSize)
          ],
        );
      }));
}

@immutable
class _PenButtons extends StatelessWidget {
  final Iterable<String> chars;
  final BoxConstraints constraints;
  final Size textSize;
  final String? fontFamily;
  final void Function(int penIndex)? onPenSelected;

  const _PenButtons({
    Key? key,
    required this.chars,
    required this.constraints,
    required this.textSize,
    this.fontFamily,
    this.onPenSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final penIndex = context.select((DrawingState state) => state.penIndex);

    return _ToggleButtons(
      chars: chars,
      penIndex: penIndex,
      constraints: constraints,
      textSize: textSize,
      fontFamily: fontFamily,
      onPenSelected: onPenSelected,
    );
  }
}

@immutable
class _ToggleButtons extends StatefulWidget {
  final Iterable<String> chars;
  final int penIndex;
  final BoxConstraints constraints;
  final Size textSize;
  final String? fontFamily;
  final void Function(int penIndex)? onPenSelected;

  const _ToggleButtons(
      {Key? key,
      required this.chars,
      required this.penIndex,
      required this.constraints,
      required this.textSize,
      this.fontFamily,
      this.onPenSelected})
      : super(key: key);

  @override
  State createState() => _ToggleButtonsState();
}

class _ToggleButtonsState extends State<_ToggleButtons> {
  void _handleResizeAction() {
    context.read<CoveringSheetController>().close();
  }

  @override
  void initState() {
    super.initState();

    final state = context.read<DrawingState>();
    state.resizeStartNotifier.addListener(_handleResizeAction);
    state.resizeCancelPendingNotifier.addListener(_handleResizeAction);
    state.resizeFinishPendingNotifier.addListener(_handleResizeAction);
  }

  @override
  void dispose() {
    final state = context.read<DrawingState>();
    state.resizeStartNotifier.removeListener(_handleResizeAction);
    state.resizeCancelPendingNotifier.removeListener(_handleResizeAction);
    state.resizeFinishPendingNotifier.removeListener(_handleResizeAction);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = Iterable.generate(widget.chars.length)
        .map((index) => index == widget.penIndex);

    return ToggleButtons(
      constraints: widget.constraints,
      renderBorder: false,
      isSelected: isSelected.toList(),
      onPressed: (int index) {
        context.read<DrawingState>().switchPen(index);
        context.read<CoveringSheetController>().close();
        widget.onPenSelected?.call(index);
      },
      children: widget.chars
          .map((char) => char == ' '
              ? _Text('␣', size: widget.textSize)
              : _Text(char,
                  size: widget.textSize, fontFamily: widget.fontFamily))
          .toList(),
    );
  }

  @override
  void didUpdateWidget(_ToggleButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.onPenSelected?.call(widget.penIndex);
  }
}

@immutable
class _ExpandButton extends StatelessWidget {
  final BoxConstraints constraints;
  final Size textSize;

  const _ExpandButton(
      {Key? key, required this.constraints, required this.textSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ToggleButtons(
      constraints: constraints,
      renderBorder: false,
      isSelected: const [false],
      onPressed: (_) => context.read<CoveringSheetController>().toggle(),
      children: [_ExpandIcon(size: textSize)]);
}

@immutable
class _ExpandIcon extends StatelessWidget {
  final Size size;

  const _ExpandIcon({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final openness =
        context.select((CoveringSheetController state) => state.openness);

    return Transform.rotate(
        angle: -openness * pi * 0.25, child: _Text('+', size: size));
  }
}

@immutable
class _Text extends StatelessWidget {
  final String text;
  final Size size;
  final String? fontFamily;

  const _Text(this.text, {Key? key, required this.size, this.fontFamily})
      : super(key: key);

  @override
  Widget build(_) => Text(text,
      style: FittingTextRenderer(text: text, fontFamily: fontFamily)
          .getTextStyle(size));
}
