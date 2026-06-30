import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/state/view_status.dart';
import '../../../models/wallet.dart';
import '../data/transfer_service.dart';

// gere un transfert d'argent
class TransferProvider extends ChangeNotifier {
  final TransferService _service;
  TransferProvider(this._service);

  ViewStatus status = ViewStatus.idle;
  String? error;
  Wallet? updatedWallet;

  Future<bool> transfer({
    required String senderPhone,
    required String receiverPhone,
    required double amount,
  }) async {
    status = ViewStatus.loading;
    error = null;
    notifyListeners();
    try {
      updatedWallet = await _service.transfer(
        senderPhone: senderPhone,
        receiverPhone: receiverPhone,
        amount: amount,
      );
      status = ViewStatus.loaded;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      error = e.message;
      status = ViewStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      status = ViewStatus.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    status = ViewStatus.idle;
    error = null;
    updatedWallet = null;
    notifyListeners();
  }
}
