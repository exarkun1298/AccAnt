import 'package:flutter/material.dart';

class NavListTile extends StatelessWidget {
  IconData icon;
  String title;
  Color color;
  Widget newContent;
  Function changeContent;

  NavListTile(
      this.icon, this.title, this.color, this.newContent, this.changeContent);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      highlightColor: Colors.white,
      onPressed: () {
        changeContent(newContent);
      },
      child: ListTile(
        enabled: true,
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
