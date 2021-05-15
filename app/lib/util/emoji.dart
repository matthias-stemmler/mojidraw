import 'package:emojis/emoji.dart';

bool isNeutral(String emojiChar) => Emoji.stabilize(emojiChar) == emojiChar;
