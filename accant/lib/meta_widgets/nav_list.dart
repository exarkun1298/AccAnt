import 'package:flutter/material.dart';

import './nav_list_tile.dart';

class NavigationList extends StatelessWidget {
  static Color color = Colors.white;

  List<IconData> navIcons = [
    Icons.home,
    Icons.dashboard,
    Icons.edit,
    Icons.pages,
    Icons.undo,
  ];

  List<String> navTitles = [
    'Home',
    'Dashboard',
    'Buchungen',
    'Buchungsvorlagen',
    'Stornieren',
  ];

  _buildNavList({int length, List<IconData> icons, List<String> titles}) {
    List<Widget> navlist = [];
    for (var i = 0; i < length; i++) {
      navlist.add(NavListTile(icons[i], titles[i], color));
    }
    return navlist;
  }

  @override
  Widget build(BuildContext context) {
    int navListlength = navIcons.length;
    final List<Widget> navList = _buildNavList(
        length: navListlength, icons: navIcons, titles: navTitles);

    return Container(
      child: Column(
        children: navList,
      ),
    );
  }
}
