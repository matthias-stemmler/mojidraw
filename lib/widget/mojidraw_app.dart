import 'package:flutter/material.dart';

import 'drawing_page.dart';

@immutable
class MojiDrawApp extends StatelessWidget {
  @override
  Widget build(_) => MaterialApp(
        title: 'Mojidraw',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: DrawingPage(
            title: 'Mojidraw', width: 21, height: 21, fontFamily: 'JoyPixels'),
      );
}
