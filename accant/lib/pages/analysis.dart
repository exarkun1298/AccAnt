import 'package:flutter/material.dart';

class Analysis extends StatelessWidget {
  String teststring;

  Analysis(this.teststring);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        teststring,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
