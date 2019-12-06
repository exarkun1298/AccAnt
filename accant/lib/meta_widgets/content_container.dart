import 'dart:math' as math;

import 'package:flutter/material.dart';
import './nav_list.dart';

class ContentContainer extends StatefulWidget {
  final Widget content;

  ContentContainer(this.content);

  @override
  _ContentContainerState createState() => _ContentContainerState();
}

class _ContentContainerState extends State<ContentContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  bool navShown = false;
  double widthSlide = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _offsetFloat =
        Tween<Offset>(begin: Offset(widthSlide, 0.0), end: Offset.zero)
            .animate(_controller);

    _offsetFloat.addListener(() {
      setState(() {});
    });

    _controller.forward();
    navShown = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double viewSize(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    viewSize(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("AccAnt"),
        leading: IconButton(
            onPressed: () {
              if (navShown) {
                setState(() {
                  _controller.reverse();
                  navShown = false;
                });
              } else {
                setState(() {
                  _controller.forward();
                  navShown = true;
                });
              }
            },
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            )),
      ),
      body: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            SlideTransition(
              position: _offsetFloat,
              child: Container(
                width: navShown
                    ? 250 > viewSize(context) / 5 ? 250 : viewSize(context) / 5
                    : 0,

                //color: Colors.blueGrey[500],
                //width: 200,
                child: Container(
                  color: Colors.blueGrey[800],
                  child: NavigationList(),
                ),
              ),
            ),
            Container(
              width: navShown ? viewSize(context) / 5 * 4 : viewSize(context),
              child: Container(
                color: Colors.grey[900],
                child: widget.content,
              ),
            )
          ],
        ),
      ),
    );
  }
}
