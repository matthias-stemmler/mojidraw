import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mojidraw',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Mojidraw', width: 11, height: 11),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.width, this.height}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final int width, height;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _Emojis _emojis;

  @override
  void initState() {
    super.initState();
    _emojis = _Emojis(widget.width, widget.height);
  }

  void _toggleEmoji(int x, int y) {
    setState(() {
      _emojis.toggle(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Table(
                  border: TableBorder.all(color: Colors.grey),
                  children: List.generate(
                      widget.height,
                      (y) => TableRow(
                          children: List.generate(
                              widget.width,
                              (x) => _GridCell(
                                  active: _emojis.isActive(x, y),
                                  onTap: () {
                                    _toggleEmoji(x, y);
                                  }))))))),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final bool active;
  final GestureTapCallback onTap;

  const _GridCell({Key key, this.active, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(),
            child: AspectRatio(
                aspectRatio: 1.0,
                child: Center(
                    child:
                        Text(active ? '🦔️' : '❤', textScaleFactor: 1.5)))));
  }
}

class _Emojis {
  final int _width;
  final List<bool> _states;

  _Emojis(this._width, height) : _states = List.filled(_width * height, false);

  bool isActive(int x, int y) {
    return _states[getIndex(x, y)];
  }

  void toggle(int x, int y) {
    var index = getIndex(x, y);
    _states[index] = !_states[index];
  }

  int getIndex(int x, int y) => y * _width + x;
}
