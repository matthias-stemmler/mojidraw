import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_page.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
        // ensure that drawer header covers background behind status bar
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              margin: const EdgeInsets.only(bottom: 20.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 30.0),
              child: Image.asset('assets/images/mojidraw_banner.png')),
          ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.of(context).push(AboutPageRoute());
              }),
          ListTile(
              leading: const Icon(Icons.open_in_new_outlined),
              title: const Text('Visit website'),
              onTap: () async {
                await launch('https://mojidraw.app/');
              })
        ],
      );
}

class AboutPageRoute extends PageRoute<void>
    with MaterialRouteTransitionMixin<void> {
  @override
  Widget buildContent(_) => AboutPage();

  // avoid rerendering the main page
  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;
}
