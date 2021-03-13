import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';
import '../util/grid_size.dart';
import 'copy_button.dart';
import 'covering_sheet.dart';
import 'emoji_grid.dart';
import 'emoji_picker.dart';
import 'palette.dart';

@immutable
class DrawingPage extends StatefulWidget {
  final GridSize size;
  final String fontFamily;

  const DrawingPage({Key key, @required this.size, this.fontFamily})
      : super(key: key);

  @override
  State createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final _coveringSheetController = CoveringSheetController();

  @override
  Widget build(_) => ChangeNotifierProvider(
        create: (_) => DrawingState(size: widget.size),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mojidraw'),
          ),
          body: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _Palette(
                      fontFamily: widget.fontFamily,
                      onToggle: _coveringSheetController.toggle,
                    )),
                Flexible(
                  child: CoveringSheet(
                    controller: _coveringSheetController,
                    sheet: EmojiPicker(fontFamily: widget.fontFamily),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: EmojiGrid(
                              size: widget.size, fontFamily: widget.fontFamily),
                        ),
                      ],
                    ),
                  ),
                )
              ])),
          bottomNavigationBar: BottomAppBar(
              child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Row(children: [CopyButton()]),
          )),
        ),
      );
}

class _Palette extends StatelessWidget {
  final String fontFamily;
  final void Function() onToggle;

  const _Palette({Key key, this.fontFamily, this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) => Palette(
      getChars: [' ', '🍀', '🦦', '❤', '🌊'].take,
      fontFamily: fontFamily,
      selectedChar: context.select((DrawingState state) => state.pen),
      onCharSelected: (char) => context.read<DrawingState>().switchPen(char),
      onAddPressed: onToggle);
}
