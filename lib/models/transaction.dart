import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'tag.dart';
import 'ledger.dart';
import 'account.dart';

class Transaction {
  int id;
  DateTime dateOfBooking;
  DateTime timestamp;
  Account account;
  Account cAccount;
  String text;
  double value;
  List<Tag> tags;
  Ledger ledger;
  Ledger cLedger;
  bool codified;

  Transaction({
    this.id,
    @required this.dateOfBooking,
    @required this.timestamp,
    @required this.account,
    @required this.cAccount,
    @required this.text,
    @required this.value,
    @required this.tags,
    @required this.ledger,
    @required this.cLedger,
    @required this.codified,
  });
}
