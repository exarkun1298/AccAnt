import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './string-transaction.dart';

class Transaction {
  DateTime book_date;
  int account_nr;
  int c_account_nr;
  List<String> tags;
  String description;
  double amount;

  Transaction({
    @required this.book_date,
    @required this.account_nr,
    @required this.c_account_nr,
    @required this.tags,
    @required this.description,
    @required this.amount,
  });

  StringTransaction convertToStringTransaction() {
    try {
      DateFormat formatter = DateFormat('dd.MM.yyyy');
      StringTransaction transaction = StringTransaction(
        book_date: formatter.format(book_date),
        account_nr: account_nr.toString(),
        c_account_nr: c_account_nr.toString(),
        tags: tags.join(';'),
        description: description,
        amount: amount.toString(),
      );
      return transaction;
    } catch (e) {
      print('Error on conversion of StringTransaction -> Transaction');
      print(e);
    }
  }
}
