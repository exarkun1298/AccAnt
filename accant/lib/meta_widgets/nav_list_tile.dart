import 'package:flutter/material.dart';

class NavListTile extends StatelessWidget {
  IconData icon;
  String title;
  Color color;

  NavListTile(this.icon, this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      radius: 20,
      onTap: () {},
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
