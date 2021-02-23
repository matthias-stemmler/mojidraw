import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mojidraw/palette.dart';

void main() {
  group('Palette', () {
    _setUp(WidgetTester tester) async {
      final Widget palette = MaterialApp(
          home: Scaffold(
              body: Palette(
        getChars: _chars().take,
        onCharSelected: (char) => print('charSelected: "$char"'),
        onAddPressed: () => print('addPressed'),
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

        final tap = () => tester.tap(find.text('␣'));

        await expectLater(tap, prints('charSelected: " "\n'));
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

        final tap = () => tester.tap(find.text('1'));

        await expectLater(tap, prints('charSelected: "1"\n'));
      });
    });

    group('Add button', () {
      testWidgets('is shown', (WidgetTester tester) async {
        await _setUp(tester);

        expect(find.text('+'), findsOneWidget);
      });

      testWidgets('tapping invokes onAddPressed', (WidgetTester tester) async {
        await _setUp(tester);

        final tap = () => tester.tap(find.text('+'));

        await expectLater(tap, prints('addPressed\n'));
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
