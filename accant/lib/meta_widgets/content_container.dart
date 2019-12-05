import 'package:flutter/material.dart';

import '../pages/home.dart';
import './accant_drawer.dart';

class ContentContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AccAnt"),
      ),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.access_alarm),
        ),
        drawer: AccAntDrawer(),
      ),
    );
  }
}
