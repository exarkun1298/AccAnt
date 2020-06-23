import 'package:flutter/material.dart';

import './nav-field.dart';
import './nav_list_tile.dart';

class NavListParent extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<NavigationField> children;
  final Function changeContent;

  NavListParent(
      this.icon, this.title, this.color, this.children, this.changeContent);

  @override
  _NavListParentState createState() => _NavListParentState();
}

class _NavListParentState extends State<NavListParent> {
  bool isExpanded = false;

  final Icon trailingIcon = Icon(
    Icons.expand_more,
    color: Colors.white,
  );

  List<NavListTile> _buildChildren() {
    List<NavListTile> childrenList = [];
    for (NavigationField child in widget.children) {
      print(child.content);
      childrenList.add(
        NavListTile(
          child.icon,
          child.title,
          widget.color,
          child.content,
          widget.changeContent,
        ),
      );
    }

    return childrenList;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey expansionTileKey = GlobalKey();

    return FlatButton(
      onPressed: () {},
      child: ExpansionTile(
        onExpansionChanged: (bool newState) {
          setState(() {
            isExpanded = newState;
          });
        },
        initiallyExpanded: isExpanded,
        key: expansionTileKey,
        trailing: trailingIcon,
        leading: Icon(widget.icon, color: widget.color),
        title: Text(
          widget.title,
          style: TextStyle(color: widget.color),
        ),
        children: _buildChildren(),
      ),
    );
  }
}
