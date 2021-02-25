import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@immutable
class BottomSheetProvider extends StatefulWidget {
  final WidgetBuilder bottomSheetBuilder, builder;

  const BottomSheetProvider(
      {Key key, @required this.bottomSheetBuilder, @required this.builder})
      : super(key: key);

  @override
  State createState() => BottomSheetProviderState();

  static BottomSheetProviderState of(BuildContext context) =>
      context.findAncestorStateOfType<BottomSheetProviderState>();
}

class BottomSheetProviderState extends State<BottomSheetProvider> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScaffoldFeatureController _controller;

  @override
  Widget build(_) => Builder(builder: widget.builder);

  bool get open => _controller != null;

  void toggle() {
    setState(() {
      if (open) {
        _closeBottomSheet();
      } else {
        _showBottomSheet();
      }
    });
  }

  void _showBottomSheet() {
    final ScaffoldState scaffoldState = _scaffoldKey.currentState;
    assert(scaffoldState != null,
        '$BottomSheetProvider must contain a $BottomSheetArea');

    Widget builder(BuildContext context) => Container(
        constraints: const BoxConstraints.expand(),
        child: widget.bottomSheetBuilder(context));

    _controller = scaffoldState.showBottomSheet(builder);

    _controller.closed.then((_) => setState(() {
          _controller = null;
        }));
  }

  void _closeBottomSheet() {
    _controller.close();
  }
}

@immutable
class BottomSheetArea extends StatelessWidget {
  final Widget child;

  const BottomSheetArea({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomSheetProviderState provider = BottomSheetProvider.of(context);
    assert(provider != null,
        '$BottomSheetArea must be wrapped in a $BottomSheetProvider');

    return Scaffold(key: provider._scaffoldKey, body: child);
  }
}
