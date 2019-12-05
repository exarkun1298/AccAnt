import 'package:flutter/material.dart';

class AccAntDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: ListTile(
        title: Text("Test"),
      ),
    );
  }
}
