import 'package:flutter/material.dart';

class NavigationField {
  String title;
  IconData icon;
  Widget content;
  List<NavigationField> children;

  NavigationField(this.title, this.icon, this.content, this.children);
  NavigationField.empty() {
    title = '';
    icon = null;
    content = null;
    children = null;
  }
}
