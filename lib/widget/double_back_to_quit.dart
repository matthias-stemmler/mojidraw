import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Duration _toastDuration = Duration(seconds: 2);

class DoubleBackToQuit extends StatefulWidget {
  final Widget child;

  const DoubleBackToQuit({Key? key, required this.child}) : super(key: key);

  @override
  State createState() => _DoubleBackToQuitState();
}

class _DoubleBackToQuitState extends State<DoubleBackToQuit> {
  DateTime? _toastStartTime;

  bool get _willHandlePopInternally =>
      ModalRoute.of(context)?.willHandlePopInternally ?? false;

  bool get _isToastVisible =>
      _toastStartTime != null &&
      DateTime.now().difference(_toastStartTime!) < _toastDuration;

  Future<bool> _handleWillPop() async {
    if (_isToastVisible || _willHandlePopInternally) {
      await Fluttertoast.cancel();
      return true;
    }

    _toastStartTime = DateTime.now();
    await Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: 'Press back button again to quit');
    return false;
  }

  @override
  Widget build(_) =>
      WillPopScope(onWillPop: _handleWillPop, child: widget.child);
}
