import 'package:flutter/material.dart';

class NavigationField {
  String title;
  IconData icon;
  Widget content;
  List<NavigationField> children;
  bool isParent = false;

  NavigationField({
    @required this.title,
    @required this.icon,
    @required this.content,
    this.children,
  });

  NavigationField.parent({
    @required this.title,
    @required this.icon,
    this.content,
    @required this.children,
  }) {
    this.isParent = true;
  }

  NavigationField.empty() {
    title = '';
    icon = null;
    content = null;
    children = null;
  }
}
