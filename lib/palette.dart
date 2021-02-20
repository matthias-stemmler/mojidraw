import 'package:flutter/material.dart';

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
      child: ToggleButtons(
          renderBorder: false,
          children: [
            ...chars.map((char) => char == ' '
                ? Icon(Icons.space_bar)
                : Text(
                    char,
                    style: TextStyle(fontFamily: fontFamily, fontSize: 20.0),
                  )),
            Icon(Icons.add)
          ],
          isSelected: [...chars.map((char) => char == selectedChar), false],
          onPressed: (int index) {
            if (index < chars.length) {
              onCharSelected?.call(chars[index]);
            } else {
              onAddPressed?.call();
            }
          }));
}
