import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './transaction.dart';

class StringTransaction {
  String book_date;
  String account_nr;
  String c_account_nr;
  String tags;
  String description;
  String amount;

  StringTransaction({
    @required this.book_date,
    @required this.account_nr,
    @required this.c_account_nr,
    @required this.tags,
    @required this.description,
    @required this.amount,
  });

  Transaction convertToTransaction() {
    try {
      DateFormat formatter = DateFormat('dd.MM.yyyy');
      Transaction transaction = Transaction(
        book_date: formatter.parse(book_date),
        account_nr: int.parse(account_nr),
        c_account_nr: int.parse(c_account_nr),
        tags: tags.split(';'),
        description: description,
        amount: double.parse(amount),
      );
      return transaction;
    } catch (e) {
      print('Error on conversion of StringTransaction -> Transaction');
      print(e);
    }
  }

  String serialize() {
    String serialized = '';
    serialized = serialized + '{';
    serialized = serialized + '\"Bookdate\": \"' + book_date + '\", ';
    serialized = serialized + '\"AccountNo\": \"' + account_nr + '\", ';
    serialized = serialized + '\"C_AccountNo\": \"' + c_account_nr + '\", ';
    serialized = serialized + '\"Tags\": \"' + tags + '\", ';
    serialized = serialized + '\"Description\": \"' + description + '\", ';
    serialized = serialized + '\"Amount\": \"' + amount + '\", ';
    serialized = serialized + '}';
    return serialized;
  }
}
