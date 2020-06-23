import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/transaction.dart';

mixin TransactionFormModel on Model {
  static DateFormat formatter = DateFormat('dd.MM.yyyy');
  String _currentDisplayedDate = formatter.format(DateTime.now());
  String get currentDisplayedDate {
    return _currentDisplayedDate;
  }
}
