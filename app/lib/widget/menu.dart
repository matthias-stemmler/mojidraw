import 'package:flutter/material.dart';

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
              child: Image.asset('images/mojidraw_banner.png')),
          ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.of(context).push(AboutPageRoute());
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
