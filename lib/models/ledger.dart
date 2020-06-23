import 'package:flutter/material.dart';

import 'account.dart';

class Ledger {
  int id;
  final String name;
  final List<Account> accounts;

  Ledger({this.id, @required this.name, @required this.accounts});
}
