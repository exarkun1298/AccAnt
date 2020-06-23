import 'package:flutter/material.dart';

import '../meta_widgets/exit.dart';

import '../pages/analysis.dart';
import '../pages/dashboard.dart';
import '../pages/settings.dart';
import '../pages/transactions-template.dart';
import '../pages/transactions.dart';
import '../pages/undo-transactions.dart';

import './nav-field.dart';
import './nav_list_parent.dart';
import './nav_list_tile.dart';

class NavigationList extends StatelessWidget {
  final Color color = Colors.white;
  final ScrollController _controller = ScrollController();
  final BuildContext context;
  final Function changeContent;

  NavigationList(this.context, this.changeContent);

  final List<NavigationField> navFields = [
    NavigationField(
      title: 'Dashboard',
      icon: Icons.dashboard,
      content: DashboardPage(),
    ),
    NavigationField(
      title: 'Auswertung',
      icon: Icons.trending_up,
      content: Analysis('Auswertung'),
    ),
    NavigationField(
      title: 'Erfassen',
      icon: Icons.edit,
      content: TransactionsPage(),
    ),
    NavigationField(
      title: 'Import / Export',
      icon: Icons.import_export,
      content: Analysis('Export'),
    ),
    NavigationField(
      title: 'Buchungsvorlagen',
      icon: Icons.pages,
      content: TransactionsTemplatePage(),
    ),
    NavigationField.parent(
        title: 'Verwalten',
        icon: Icons.more_vert,
        children: [
          NavigationField(
            title: 'Konten',
            icon: Icons.account_balance_wallet,
            content: Analysis('Kontenverwaltung'),
          ),
          NavigationField(
            title: 'Buchung stornieren',
            icon: Icons.undo,
            content: UndoTransactionsPage(),
          ),
          NavigationField(
            title: 'Historie',
            icon: Icons.history,
            content: Analysis('Import'),
          ),
          NavigationField(
            title: 'Bücher / Ledger',
            icon: Icons.collections_bookmark,
            content: Analysis('Buchungskreise'),
          ),
        ]),
    NavigationField.empty(),
    NavigationField(
      title: 'Einstellungen',
      icon: Icons.settings,
      content: SettingsPage(),
    ),
    NavigationField(
      title: 'Info',
      icon: Icons.info,
      content: Analysis('Info'),
    ),
    NavigationField.empty(),
    NavigationField(
      title: 'Beenden',
      icon: Icons.exit_to_app,
      content: Exit(),
    ),
  ];

  List<Widget> _buildNavList() {
    List<Widget> navlist = [];
    for (NavigationField field in navFields) {
      if (field.isParent) {
        navlist.add(NavListParent(
            field.icon, field.title, color, field.children, changeContent));
      } else {
        navlist.add(NavListTile(
            field.icon, field.title, color, field.content, changeContent));
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
