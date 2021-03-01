import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        itemBuilder: (_, int index) => TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(5.0)),
            onPressed: () => {},
            child: Text(emojis.elementAt(index).char,
                style: TextStyle(fontFamily: fontFamily, fontSize: 30.0))));
  }
}
