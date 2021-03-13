import 'package:flutter/material.dart';

import '../util/grid_size.dart';
import 'drawing_page.dart';

@immutable
class MojiDrawApp extends StatelessWidget {
  @override
  Widget build(_) => MaterialApp(
        title: 'Mojidraw',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home:
            const DrawingPage(size: GridSize(11, 11), fontFamily: 'JoyPixels'),
      );
}
