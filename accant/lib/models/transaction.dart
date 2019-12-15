import 'package:flutter/material.dart';

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
}
