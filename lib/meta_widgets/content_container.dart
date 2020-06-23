import 'package:flutter/material.dart';
import '../navigation/nav_list.dart';

/// Widget for basic app layout
///
/// Controls the Navbar Navigation and Content display
class ContentContainer extends StatefulWidget {
  ///Content widget to display
  const ContentContainer(this.content);

  /// content -> Widget
  /// THis Widget will be displayed besides the navbar
  final Widget content;

  @override
  _ContentContainerState createState() => _ContentContainerState();
}

class _ContentContainerState extends State<ContentContainer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  bool navShown = false;
  double widthSlide = -1;

  Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = widget.content;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _offsetFloat = Tween<Offset>(
      begin: Offset(widthSlide, 0.0),
      end: Offset.zero,
    ).animate(_controller);

    _offsetFloat.addListener(() {
      setState(() => null);
    });

    _controller.forward();
    navShown = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  changeContent(Widget newContent) {
    setState(() {
      currentWidget = newContent;
    });
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
        color: Colors.grey[900],
        child: Row(
          //mainAxisSize: MainAxisSize.max,
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
                  child: NavigationList(context, changeContent),
                ),
              ),
            ),
            Expanded(
              //width: navShown ? viewSize(context) / 5 * 4 : viewSize(context),
              child: Container(
                color: Colors.grey[900],
                child: currentWidget,
              ),
            )
          ],
        ),
      ),
    );
  }
}
