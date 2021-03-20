import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:mojidraw/state/drawing_state.dart';
import 'package:mojidraw/util/emoji.dart';
import 'package:provider/provider.dart';

import '../util/fitting_text_renderer.dart';

const EdgeInsets _padding = EdgeInsets.all(5.0);

final Map<IconData, Iterable<String>> _emojiTabs = {
  Icons.emoji_emotions_outlined: Emoji.byGroup(EmojiGroup.smileysEmotion)
      .followedBy(Emoji.byGroup(EmojiGroup.peopleBody)),
  Icons.emoji_nature_outlined: Emoji.byGroup(EmojiGroup.animalsNature),
  Icons.emoji_food_beverage_outlined: Emoji.byGroup(EmojiGroup.foodDrink),
  Icons.emoji_events_outlined: Emoji.byGroup(EmojiGroup.activities),
  Icons.emoji_transportation_outlined: Emoji.byGroup(EmojiGroup.travelPlaces),
  Icons.emoji_objects_outlined: Emoji.byGroup(EmojiGroup.objects),
  Icons.emoji_symbols_outlined: Emoji.byGroup(EmojiGroup.symbols),
  Icons.emoji_flags_outlined: Emoji.byGroup(EmojiGroup.flags),
}.map((IconData icon, Iterable<Emoji> emojis) =>
    MapEntry(icon, emojis.map((Emoji emoji) => emoji.char).where(isNeutral)));

@immutable
class EmojiPicker extends StatelessWidget {
  final String fontFamily;
  final void Function() onEmojiPicked;

  const EmojiPicker({Key key, this.fontFamily, this.onEmojiPicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 8,
      child: Scaffold(
        bottomNavigationBar: TabBar(
            indicator: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).indicatorColor, width: 2.0))),
            labelPadding: EdgeInsets.zero,
            tabs: _emojiTabs.keys
                .map((icon) => _CategoryTabButton(icon: icon))
                .toList()),
        body: TabBarView(
            children: _emojiTabs.values
                .map((emojiChars) => _CategoryTab(
                      emojiChars: emojiChars,
                      fontFamily: fontFamily,
                      onEmojiPicked: onEmojiPicked,
                    ))
                .toList()),
      ));
}

@immutable
class _CategoryTabButton extends StatelessWidget {
  final IconData icon;

  const _CategoryTabButton({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) => Tab(
          icon: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ));
}

@immutable
class _CategoryTab extends StatelessWidget {
  final Iterable<String> emojiChars;
  final String fontFamily;
  final void Function() onEmojiPicked;

  const _CategoryTab(
      {Key key, @required this.emojiChars, this.fontFamily, this.onEmojiPicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 48.0),
      itemCount: emojiChars.length,
      itemBuilder: (_, int index) {
        final String char = emojiChars.elementAt(index);
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
