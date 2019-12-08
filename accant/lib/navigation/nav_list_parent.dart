import 'package:flutter/material.dart';

import './nav-field.dart';
import './nav_list_tile.dart';

class NavListParent extends StatelessWidget {
  IconData icon;
  String title;
  Color color;
  List<NavigationField> children;
  Function changeContent;

  NavListParent(
      this.icon, this.title, this.color, this.children, this.changeContent);

  Icon trailingIcon = Icon(
    Icons.expand_more,
    color: Colors.white,
  );

  List<NavListTile> _buildChildren() {
    List<NavListTile> childrenList = [];
    for (NavigationField child in children) {
      print(child.content);
      childrenList.add(
        NavListTile(
          child.icon,
          child.title,
          color,
          child.content,
          changeContent,
        ),
      );
    }

    return childrenList;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey expansionTileKey = GlobalKey();

    return FlatButton(
      //onPressed: () {},
      child: ExpansionTile(
        initiallyExpanded: false,
        key: expansionTileKey,
        trailing: trailingIcon,
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        children: _buildChildren(),
      ),
    );
  }
}
