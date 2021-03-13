import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:mojidraw/state/drawing_state.dart';
import 'package:provider/provider.dart';

import '../util/fitting_text_renderer.dart';

const EdgeInsets _padding = EdgeInsets.all(5.0);

@immutable
class EmojiPicker extends StatelessWidget {
  final String fontFamily;
  final void Function() onEmojiPicked;

  const EmojiPicker({Key key, this.fontFamily, this.onEmojiPicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emojis = Emoji.byGroup(EmojiGroup.animalsNature);

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 48.0),
        itemCount: emojis.length,
        itemBuilder: (_, int index) {
          final String char = emojis.elementAt(index).char;
          final renderer =
              FittingTextRenderer(text: char, fontFamily: fontFamily);

          return LayoutBuilder(builder: (_, BoxConstraints constraints) {
            final Size size = _padding.deflateSize(constraints.biggest);
            final TextStyle textStyle = renderer.getTextStyle(size);

            return TextButton(
                style: TextButton.styleFrom(padding: _padding),
                onPressed: () {
                  context.read<DrawingState>().addPen(char);
                  onEmojiPicked?.call();
                },
                child: Text(char, style: textStyle));
          });
        });
  }
}
