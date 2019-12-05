import 'package:flutter/material.dart';

class FirstStartup extends StatefulWidget {
  @override
  _FirstStartupState createState() => _FirstStartupState();
}

class _FirstStartupState extends State<FirstStartup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("First Startup"),
        ),
        body: Container(
          child: Text('first-startup'),
        ));
  }
}
