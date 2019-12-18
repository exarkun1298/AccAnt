import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/string-transaction.dart';
import '../models/transaction.dart';

mixin TransactionFormModel on Model {
  static DateFormat formatter = DateFormat('dd.MM.yyyy');
  String _currentDisplayedDate = formatter.format(DateTime.now());
  String get currentDisplayedDate {
    return _currentDisplayedDate;
  }

  void setCurrentDisplyedDateByDateTime(DateTime date) {
    _currentDisplayedDate = formatter.format(date);
    notifyListeners();
  }

  void setCurrentDisplyedDateByString(String formattedDate) {
    _currentDisplayedDate = formattedDate;
    notifyListeners();
  }

  StringTransaction _currentStringTransaction = StringTransaction(
      account_nr: '',
      amount: '',
      book_date: '',
      c_account_nr: '',
      description: '',
      tags: '');
  StringTransaction get currentStringTransaction {
    return _currentStringTransaction;
  }

  void setBookDate(String formtext) {
    _currentStringTransaction.book_date = formtext;
  }

  void setAccNo(String formtext) {
    _currentStringTransaction.account_nr = formtext;
  }

  void setCAccNo(String formtext) {
    _currentStringTransaction.c_account_nr = formtext;
  }

  void setTags(String formtext) {
    _currentStringTransaction.tags = formtext;
  }

  void setDescription(String formtext) {
    _currentStringTransaction.description = formtext;
  }

  void setAmount(String formtext) {
    _currentStringTransaction.amount = formtext;
  }

  Transaction _newTransaction;
  Transaction get newTransaction {
    print(currentStringTransaction.serialize());
    try {
      return _currentStringTransaction.convertToTransaction();
    } catch (e) {
      'Error on Conversion. $e';
    }
  }

  final List<Transaction> _transactions = [];
  List<Transaction> get transactions {
    return _transactions;
  }

  List<Transaction> addTransaction(Transaction t) {
    _transactions.add(t);
    notifyListeners();
    return _transactions;
  }

  Transaction removeTransactionAt(int index) {
    Transaction removedTransaction = _transactions.removeAt(index);
    notifyListeners();
    return removedTransaction;
  }

  List<Transaction> removeAllTransactions() {
    List<Transaction> removedTransactions =
        List<Transaction>.from(_transactions);
    _transactions.clear();
    print("Removed: " +
        removedTransactions
            .map((e) {
              return e.description;
            })
            .toList()
            .toString());
    notifyListeners();
    return removedTransactions;
  }

  void addSomeBookings() {
    addTransaction(Transaction(
      account_nr: 200,
      c_account_nr: 1200,
      book_date: DateTime.now(),
      amount: 22.46,
      description: 'This is a description',
      tags: ['one', 'two', 'three'],
    ));

    addTransaction(Transaction(
      account_nr: 4200,
      c_account_nr: 1600,
      book_date: DateTime.now(),
      amount: 225.46,
      description: 'This is a description',
      tags: ['one', 'two', 'three'],
    ));

    addTransaction(Transaction(
      account_nr: 200,
      c_account_nr: 1400,
      book_date: DateTime.now(),
      amount: 2.46,
      description: 'This is a description',
      tags: ['one', 'two', 'three'],
    ));
  }
}
