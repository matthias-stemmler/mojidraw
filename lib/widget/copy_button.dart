import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../state/drawing_state.dart';

@immutable
class CopyButton extends StatelessWidget {
  void copy(String text) => Clipboard.setData(ClipboardData(text: text));

  @override
  Widget build(BuildContext context) => IconButton(
      icon: const Icon(Icons.copy),
      tooltip: 'Copy to clipboard',
      onPressed: () {
        copy(context.read<DrawingState>().gridAsText);

        Fluttertoast.showToast(
          msg: 'Copied to clipboard',
        );
      });
}
