import 'package:flutter/material.dart';

import '../meta_widgets/exit.dart';

import '../pages/analysis.dart';
import '../pages/dashboard.dart';
import '../pages/home.dart';
import '../pages/settings.dart';
import '../pages/transactions-template.dart';
import '../pages/transactions.dart';
import '../pages/undo-transactions.dart';

import './nav-field.dart';
import './nav_list_parent.dart';
import './nav_list_tile.dart';

class NavigationList extends StatelessWidget {
  static Color color = Colors.white;
  final ScrollController _controller = ScrollController();
  final BuildContext context;
  final Function changeContent;

  NavigationList(this.context, this.changeContent);

  List<NavigationField> navFields = [
    NavigationField('Home', Icons.home, HomePage(), null),
    NavigationField('Dashboard', Icons.dashboard, DashboardPage(), null),
    NavigationField('Buchungen', Icons.edit, TransactionsPage(), null),
    NavigationField(
        'Buchungsvorlagen', Icons.pages, TransactionsTemplatePage(), null),
    NavigationField('Stornieren', Icons.undo, UndoTransactionsPage(), null),
    NavigationField('Auswertung', Icons.trending_up, null, [
      NavigationField('Jahr', null, Analysis('year'), null),
      NavigationField('Monat', null, Analysis('day'), null),
      NavigationField('usw', null, Analysis('month'), null),
    ]),
    NavigationField('Mehr', Icons.more_vert, null, [
      NavigationField(
          'Kontenverwaltung', null, Analysis('Kontenverwaltung'), null),
      NavigationField('Export', null, Analysis('Export'), null),
      NavigationField('Import', null, Analysis('Import'), null),
      NavigationField('Buchungskreise', null, Analysis('Buchungskreise'), null),
    ]),
    NavigationField.empty(),
    NavigationField('Einstellungen', Icons.settings, SettingsPage(), null),
    NavigationField('Info', Icons.info, Analysis('Info'), null),
    NavigationField.empty(),
    NavigationField('Beenden', Icons.exit_to_app, Exit(), null),
  ];

  List<Widget> _buildNavList() {
    List<Widget> navlist = [];
    for (NavigationField field in navFields) {
      if (field.children == null) {
        navlist.add(NavListTile(
            field.icon, field.title, color, field.content, changeContent));
      } else {
        navlist.add(NavListParent(
            field.icon, field.title, color, field.children, changeContent));
      }
    }
    return navlist;
  }

  @override
  Widget build(BuildContext context) {
    final navList = _buildNavList();
    return Container(
        child: SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: navList,
      ),
    ));
  }
}
