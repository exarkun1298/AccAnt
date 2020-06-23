import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main-model.dart';

import './form-indentation.dart';
import './form-button.dart';
import './form-reverse-entry-checkbox.dart';
import './form-standard-textform.dart';
//import './transaction-datatable.dart';
//import '../../models/transaction.dart';

class TransactionsForm extends StatefulWidget {
  @override
  _TransactionsFormState createState() => _TransactionsFormState();
}

class _TransactionsFormState extends State<TransactionsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _formTextControllers = [];

  String globalValidator(String value) {
    return value == '' ? 'Please enter a value' : null;
  }

  String bookDateValidator(String value) {
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String errorMessage = '';
    try {
      formatter.parse(value);
    } catch (e) {
      errorMessage = "Bitte das Datum im Format DD.MM.YYYY eingeben" + e;
    }
    return errorMessage;
  }

  List<FocusNode> focusNodes = [];

  FocusNode getFocusNode() {
    FocusNode node = FocusNode();
    focusNodes.add(node);
    return node;
  }

  accountNumberValidator(String value) {}
  amountValidator(String value) {}
  tagsValidator(String value) {}

  TextEditingController _getTextController() {
    TextEditingController tec = TextEditingController();
    _formTextControllers.add(tec);
    return tec;
  }

  void refreshState() {
    setState(() {});
  }

  void _keyUpEvent(RawKeyEvent keyEvent) {
    print(keyEvent.isKeyPressed(LogicalKeyboardKey(2)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (keyEvent) {
              _keyUpEvent(keyEvent);
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  FormStandardTextform.date(
                    initialFocus: false,
                    focusNode: getFocusNode(),
                    model: model,
                    dateFormat: DateFormat('dd.MM.yyyy'),
                    icon: Icons.calendar_today,
                    labeltext: 'Datum',
                    refresh: refreshState,
                    formKey: _formKey,
                    validator: globalValidator,
                    transactionSetter: () {},
                  ),
                  FormStandardTextform(
                    initialFocus: true,
                    focusNode: getFocusNode(),
                    model: model,
                    icon: Icons.accessibility,
                    labeltext: 'Kontonummer',
                    formKey: _formKey,
                    refresh: refreshState,
                    validator: globalValidator,
                    transactionSetter: () {},
                    controller: _getTextController(),
                  ),
                  FormStandardTextform(
                    initialFocus: false,
                    focusNode: getFocusNode(),
                    model: model,
                    icon: Icons.add_alarm,
                    labeltext: 'Buchtext',
                    formKey: _formKey,
                    refresh: refreshState,
                    validator: globalValidator,
                    transactionSetter: () {},
                    controller: _getTextController(),
                  ),
                  FormStandardTextform(
                    initialFocus: false,
                    focusNode: getFocusNode(),
                    model: model,
                    icon: Icons.add_alarm,
                    labeltext: 'Betrag',
                    formKey: _formKey,
                    refresh: refreshState,
                    validator: globalValidator,
                    transactionSetter: () {},
                    controller: _getTextController(),
                  ),
                  FormStandardTextform(
                    initialFocus: false,
                    focusNode: getFocusNode(),
                    model: model,
                    icon: Icons.content_cut,
                    labeltext: 'Gegenkonto',
                    formKey: _formKey,
                    refresh: refreshState,
                    validator: globalValidator,
                    transactionSetter: () {},
                    controller: _getTextController(),
                  ),
                  FormReverseEntryCheckbox(
                    focusNode: getFocusNode(),
                  ),
                  FormStandardTextform(
                    initialFocus: false,
                    focusNode: getFocusNode(),
                    model: model,
                    icon: Icons.add_alarm,
                    labeltext: 'Transaktions-Tags (optional)',
                    formKey: _formKey,
                    refresh: refreshState,
                    validator: globalValidator,
                    transactionSetter: () {},
                    controller: _getTextController(),
                  ),
                  Row(
                    children: <Widget>[
                      FormIndentation(),
                      FormButton(
                        focusNode: getFocusNode(),
                        onPressed: () {
                          bool validated = _formKey.currentState.validate();
                          if (validated) {
                            _formKey.currentState.save();
                            print("send_this_noob");
                          }
                        },
                        label: 'Hinzufügen',
                      ),
                      FormButton(
                        focusNode: getFocusNode(),
                        onPressed: () {
                          for (TextEditingController _controller
                              in _formTextControllers) {
                            _controller.clear();
                          }
                          print('clear');
                        },
                        label: 'Leeren',
                      ),
                      FormButton(
                        focusNode: getFocusNode(),
                        onPressed: () {
                          print(focusNodes);
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
                        focusNode: getFocusNode(),
                        onPressed: () {},
                        label: 'Absenden',
                      ),
                    ],
                  ),
/*                   model.transactions.isEmpty
                      ? Container()
                      : TransactionDataTable(
                          transactions: model.transactions,
                        ), */
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
