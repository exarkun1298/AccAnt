import 'package:data_tables/data_tables.dart' as dtable;
import 'package:flutter/material.dart';

import '../../models/transaction.dart';

class TransactionDataTable extends StatelessWidget {
  List<Transaction> transactions;

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

  List<DataRow> _buildDataRows() {
    List<DataRow> datarows = [];
    for (Transaction transaction in transactions) {
      datarows.add(
        DataRow(
          cells: [
            DataCell(Text(
              transaction.book_date.toString(),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.account_nr.toString(),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.c_account_nr.toString(),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.description,
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.amount.toString(),
              style: rowstyle,
            )),
            DataCell(Text(
              transaction.tags.toString(),
              style: rowstyle,
            )),
            DataCell(Material(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[900],
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  radius: 50,
                  onTap: () {
                    print('pressed');
                  },
                  splashColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Container(
                    height: 35,
                    width: 35,
                    child: Icon(
                      Icons.more_vert,
                      color: textcolor,
                    ),
                  ),
                )))
          ],
        ),
      );
    }
    return datarows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: DataTable(
        columns: _buildDataColumns(),
        rows: _buildDataRows(),
      ),
    );
  }
}
