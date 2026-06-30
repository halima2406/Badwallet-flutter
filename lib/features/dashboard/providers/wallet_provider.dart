import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/state/view_status.dart';
import '../../../models/balance.dart';
import '../../../models/transaction.dart';
import '../../../models/wallet.dart';
import '../data/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _service;
  WalletProvider(this._service);

  ViewStatus status = ViewStatus.idle;
  String? error;

  Balance? balance;
  Wallet? wallet;
  List<TransactionModel> transactions = [];

  bool hideBalance = false;
  String? _phone;

  List<TransactionModel> get recentTransactions =>
      transactions.take(5).toList();

  String get currency => balance?.currency ?? wallet?.currency ?? 'XOF';

  Future<void> load(String phone) async {
    _phone = phone;
    status = ViewStatus.loading;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.getBalance(phone),
        _service.getWallet(phone),
        _service.getTransactions(phone),
      ]);
      balance = results[0] as Balance;
      wallet = results[1] as Wallet;
      transactions = results[2] as List<TransactionModel>;
      status = ViewStatus.loaded;
    } on ApiException catch (e) {
      error = e.message;
      status = ViewStatus.error;
    } catch (e) {
      error = e.toString();
      status = ViewStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_phone != null) await load(_phone!);
  }

  void toggleHideBalance() {
    hideBalance = !hideBalance;
    notifyListeners();
  }

  void reset() {
    status = ViewStatus.idle;
    error = null;
    balance = null;
    wallet = null;
    transactions = [];
    _phone = null;
    hideBalance = false;
    notifyListeners();
  }
}
