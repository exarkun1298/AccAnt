import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main-model.dart';

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

  List<Transaction> _transactions = [];

  String global_validator(String value) {
    return value == '' ? 'Please enter a value' : null;
  }

  String book_date_validator(String value) {
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String errorMessage = '';
    try {
      formatter.parse(value);
    } catch (e) {
      errorMessage = "Bitte das Datum im Format DD.MM.YYYY eingeben" + e;
    } finally {
      return errorMessage;
    }
  }

  account_number_validator(String value) {}
  amount_validator(String value) {}
  tags_validator(String value) {}

  TextEditingController _getTextController() {
    TextEditingController tec = TextEditingController();
    _formTextControllers.add(tec);
    return tec;
  }

  void refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                StandardTextform.date(
                  model: model,
                  dateFormat: DateFormat('dd.MM.yyyy'),
                  icon: Icons.calendar_today,
                  labeltext: 'Datum',
                  refresh: refreshState,
                  formKey: _formKey,
                  validator: global_validator,
                  transactionSetter: model.setBookDate,
                ),
                StandardTextform(
                  model: model,
                  icon: Icons.accessibility,
                  labeltext: 'Kontonummer',
                  formKey: _formKey,
                  refresh: refreshState,
                  validator: global_validator,
                  transactionSetter: model.setAccNo,
                  controller: _getTextController(),
                ),
                StandardTextform(
                  model: model,
                  icon: Icons.add_alarm,
                  labeltext: 'Buchtext',
                  formKey: _formKey,
                  refresh: refreshState,
                  validator: global_validator,
                  transactionSetter: model.setDescription,
                  controller: _getTextController(),
                ),
                StandardTextform(
                  model: model,
                  icon: Icons.add_alarm,
                  labeltext: 'Betrag',
                  formKey: _formKey,
                  refresh: refreshState,
                  validator: global_validator,
                  transactionSetter: model.setAmount,
                  controller: _getTextController(),
                ),
                StandardTextform(
                  model: model,
                  icon: Icons.content_cut,
                  labeltext: 'Gegenkonto',
                  formKey: _formKey,
                  refresh: refreshState,
                  validator: global_validator,
                  transactionSetter: model.setCAccNo,
                  controller: _getTextController(),
                ),
                ReverseEntryCheckbox(),
                StandardTextform(
                  model: model,
                  icon: Icons.add_alarm,
                  labeltext: 'Transaktions-Tags (optional)',
                  formKey: _formKey,
                  refresh: refreshState,
                  validator: global_validator,
                  transactionSetter: model.setTags,
                  controller: _getTextController(),
                ),
                Row(
                  children: <Widget>[
                    FormIndentation(),
                    FormButton(
                      onPressed: () {
                        bool validated = _formKey.currentState.validate();
                        if (validated) {
                          _formKey.currentState.save();
                          Transaction newTransaction = model.newTransaction;
                          print(newTransaction);
                          setState(() {
                            model.addTransaction(newTransaction);
                            print(model.transactions);
                          });
                        }
                      },
                      label: 'Hinzufügen',
                    ),
                    FormButton(
                      onPressed: () {
                        for (TextEditingController _controller
                            in _formTextControllers) {
                          _controller.clear();
                        }
                        model.removeAllTransactions();
                      },
                      label: 'Leeren',
                    ),
                    FormButton(
                      onPressed: () {
                        model.addSomeBookings();
                      },
                      label: 'Mockdata',
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
                model.transactions.isEmpty
                    ? Container()
                    : TransactionDataTable(
                        transactions: model.transactions,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
