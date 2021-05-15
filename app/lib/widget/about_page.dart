import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(_) => Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Image.asset('images/mojidraw_logo.png'),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Information(
                    label: 'Version', data: packageInfo.then((p) => p.version)),
                const _Information(
                    label: 'Developed by', data: 'Matthias Stemmler'),
                const _Information(label: 'Emoji font by', data: 'JoyPixels®')
              ],
            ),
          ),
        ],
      ));
}

class _Information extends StatelessWidget {
  final String label;
  final FutureOr<String> data;

  const _Information({Key? key, required this.label, required this.data})
      : super(key: key);

  @override
  Widget build(_) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: FutureBuilder(
                future: Future.value(data),
                builder: (_, AsyncSnapshot<String> snapshot) => Text(
                  snapshot.data ?? '',
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            )
          ],
        ),
      );
}
