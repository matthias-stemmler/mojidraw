import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'file:///C:/home/projects/flutter/mojidraw/lib/widget/palette.dart';

void main() {
  group('Palette', () {
    String selectedChar;
    bool addPressed;

    Future<void> _setUp(WidgetTester tester) async {
      selectedChar = null;
      addPressed = false;

      final Widget palette = MaterialApp(
          home: Scaffold(
              body: Palette(
        getChars: _chars().take,
        onCharSelected: (char) => selectedChar = char,
        onAddPressed: () => addPressed = true,
      )));

      await tester.pumpWidget(palette);
    }

    group('Space character', () {
      testWidgets('is shown as open box', (WidgetTester tester) async {
        await _setUp(tester);

        expect(find.text('␣'), findsOneWidget);
      });

      testWidgets('tapping invokes onCharSelected',
          (WidgetTester tester) async {
        await _setUp(tester);

        await tester.tap(find.text('␣'));

        expect(selectedChar, ' ');
      });
    });

    group('Other characters', () {
      testWidgets('are shown verbatim', (WidgetTester tester) async {
        await _setUp(tester);

        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('tapping invokes onCharSelected',
          (WidgetTester tester) async {
        await _setUp(tester);

        await tester.tap(find.text('1'));

        expect(selectedChar, '1');
      });
    });

    group('Add button', () {
      testWidgets('is shown', (WidgetTester tester) async {
        await _setUp(tester);

        expect(find.text('+'), findsOneWidget);
      });

      testWidgets('tapping invokes onAddPressed', (WidgetTester tester) async {
        await _setUp(tester);

        await tester.tap(find.text('+'));

        expect(addPressed, isTrue);
      });
    });
  });
}

Iterable<String> _chars() sync* {
  yield ' ';

  int i = 0;
  while (true) {
    yield i.toString();
    i++;
  }
}
