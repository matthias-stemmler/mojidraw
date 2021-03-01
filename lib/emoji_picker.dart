import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mojidraw/fitting_text_renderer.dart';

const EdgeInsets _padding = EdgeInsets.all(5.0);

class EmojiPicker extends StatelessWidget {
  final String fontFamily;

  const EmojiPicker({Key key, this.fontFamily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emojis = Emoji.byGroup(EmojiGroup.animalsNature);

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 48.0),
        itemCount: emojis.length,
        itemBuilder: (_, int index) {
          final String text = emojis.elementAt(index).char;

          return LayoutBuilder(
              builder: (_, BoxConstraints constraints) => TextButton(
                  style: TextButton.styleFrom(padding: _padding),
                  onPressed: () => {},
                  child: Text(text,
                      style: FittingTextRenderer(
                              text: text, fontFamily: fontFamily)
                          .getTextStyle(
                              _padding.deflateSize(constraints.biggest)))));
        });
  }
}
