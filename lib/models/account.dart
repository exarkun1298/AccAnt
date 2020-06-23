import 'package:accant/models/account_type.dart';
import 'package:accant/models/ledger.dart';
import 'package:flutter/material.dart';

class Account {
  int id;
  int number;
  String name;
  AccountType type;
  bool isActive;
  Ledger validLedger;

  Account({
    this.id,
    @required this.name,
    @required this.number,
    @required this.type,
    @required this.isActive,
    @required this.validLedger,
  });
}
