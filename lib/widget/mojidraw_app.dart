import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';
import '../util/grid_size.dart';
import 'drawing_page.dart';

@immutable
class MojiDrawApp extends StatelessWidget {
  @override
  Widget build(_) => MaterialApp(
        title: 'Mojidraw',
        theme: ThemeData(
            // this causes the OS status bar text to be rendered in a light color
            appBarTheme: const AppBarTheme(brightness: Brightness.dark),
            primarySwatch: ThemeColors.mojidraw,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home:
            const DrawingPage(size: GridSize(13, 13), fontFamily: 'JoyPixels'),
      );
}
