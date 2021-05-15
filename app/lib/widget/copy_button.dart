import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';

@immutable
class CopyButton extends StatelessWidget {
  void _copy(String text) => Clipboard.setData(ClipboardData(text: text));

  @override
  Widget build(BuildContext context) => IconButton(
      icon: const Icon(Icons.copy),
      tooltip: 'Copy text to clipboard',
      onPressed: () async {
        _copy(context.read<DrawingState>().grid.text);

        await Fluttertoast.showToast(
          msg: 'Copied to clipboard',
        );
      });
}
