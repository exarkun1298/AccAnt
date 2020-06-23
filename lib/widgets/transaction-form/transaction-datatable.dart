import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main-model.dart';
import '../../models/transaction.dart';
import './datatable-actionbutton.dart';

class TransactionDataTable extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionDataTable({this.transactions});

  static const Color textcolor = Colors.white70;
  static const TextStyle rowstyle =
      TextStyle(fontFamily: 'Roboto', color: textcolor);
  static const TextStyle columnstyle =
      TextStyle(fontFamily: 'Roboto', color: textcolor);

  List<DataColumn> _buildDataColumns() {
    return [
      DataColumn(
          label: Text(
            'Buchungsdatum',
            style: columnstyle,
          ),
          numeric: false),
      DataColumn(
          label: Text(
            'Kontonr',
            style: columnstyle,
          ),
          numeric: true),
      DataColumn(
          label: Text(
            'Gegenkontonr',
            style: columnstyle,
          ),
          numeric: true),
      DataColumn(
          label: Text(
            'Buchtext',
            style: columnstyle,
          ),
          numeric: false),
      DataColumn(
          label: Text(
            'Saldo',
            style: columnstyle,
          ),
          numeric: true),
      DataColumn(
          label: Text(
            'Tags',
            style: columnstyle,
          ),
          numeric: false),
      DataColumn(
          label: Text(
            'Aktion',
            style: columnstyle,
          ),
          numeric: false),
    ];
  }

  List<DataRow> _buildDataRows(MainModel model, BuildContext context) {
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    List<DataRow> datarows = [];

    transactions.asMap().forEach((index, transaction) {
      datarows.add(
        DataRow(
          cells: [
            DataCell(Text(
              formatter.format(transaction.dateOfBooking),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.account.toString(),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.cAccount.toString(),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.text,
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.value.toString(),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.tags.toString(),
              style: rowstyle,
            )),
            DataCell(DataTableActionButton(index: index)),
          ],
        ),
      );
    });
    return datarows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) =>
              DataTable(
            columns: _buildDataColumns(),
            rows: _buildDataRows(model, context),
          ),
        ));
  }
}
