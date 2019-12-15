import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './form-indentation.dart';
import './formbutton.dart';
import './reverse-entry-checkbox.dart';
import './standard-textform.dart';
import './transaction-datatable.dart';
import '../../models/transaction.dart';

class TransactionsForm extends StatefulWidget {
  @override
  _TransactionsFormState createState() => _TransactionsFormState();
}

class _TransactionsFormState extends State<TransactionsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _formTextControllers = [];

  List<Transaction> testdata = [
    Transaction(
      account_nr: 200,
      c_account_nr: 1200,
      book_date: DateTime.now(),
      amount: 22.46,
      description: 'This is a description',
      tags: ['one', 'two', 'three'],
    ),
    Transaction(
      account_nr: 200,
      c_account_nr: 1200,
      book_date: DateTime.now(),
      amount: 22.46,
      description: 'This is a description',
      tags: ['one', 'two', 'three'],
    ),
    Transaction(
      account_nr: 200,
      c_account_nr: 1200,
      book_date: DateTime.now(),
      amount: 22.46,
      description: 'This is a description',
      tags: ['one', 'two', 'three'],
    ),
  ];

  global_validator(String value) {
    value.isEmpty ? 'Please enter a value' : null;
  }

  TextEditingController _getTextController() {
    TextEditingController tec = TextEditingController();
    _formTextControllers.add(tec);
    return tec;
  }

  void refreshState(Function callback) {
    setState(() async {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            StandardTextform.date(
              dateFormat: DateFormat('dd.MM.yyyy'),
              icon: Icons.calendar_today,
              labeltext: 'Datum',
              refresh: refreshState,
              formKey: _formKey,
              validator: global_validator,
              controller: _getTextController(),
            ),
            StandardTextform(
              icon: Icons.accessibility,
              labeltext: 'Kontonummer',
              formKey: _formKey,
              refresh: refreshState,
              validator: global_validator,
              controller: _getTextController(),
            ),
            StandardTextform(
              icon: Icons.add_alarm,
              labeltext: 'Buchtext',
              formKey: _formKey,
              refresh: refreshState,
              validator: global_validator,
              controller: _getTextController(),
            ),
            StandardTextform(
              icon: Icons.add_alarm,
              labeltext: 'Betrag',
              formKey: _formKey,
              refresh: refreshState,
              validator: global_validator,
              controller: _getTextController(),
            ),
            StandardTextform(
              icon: Icons.content_cut,
              labeltext: 'Gegenkonto',
              formKey: _formKey,
              refresh: refreshState,
              validator: global_validator,
              controller: _getTextController(),
            ),
            ReverseEntryCheckbox(),
            StandardTextform(
              icon: Icons.add_alarm,
              labeltext: 'Transaktions-Tags (optional)',
              formKey: _formKey,
              refresh: refreshState,
              validator: global_validator,
              controller: _getTextController(),
            ),
            Row(
              children: <Widget>[
                FormIndentation(),
                FormButton(
                  onPressed: () {},
                  label: 'Hinzufügen',
                ),
                FormButton(
                  onPressed: () {
                    for (TextEditingController _controller
                        in _formTextControllers) {
                      _controller.clear();
                    }
                  },
                  label: 'Leeren',
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                FormIndentation(),
                FormButton(
                  onPressed: () {},
                  label: 'Absenden',
                ),
              ],
            ),
            TransactionDataTable(
              transactions: testdata,
            ),
          ],
        ),
      ),
    );
  }
}
