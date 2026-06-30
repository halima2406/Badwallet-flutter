import '../../../core/network/api_client.dart';
import '../../../models/balance.dart';
import '../../../models/transaction.dart';
import '../../../models/wallet.dart';

class WalletService {
  final ApiClient _api;
  WalletService(this._api);

  Future<Wallet> getWallet(String phone) async {
    final data = await _api.get('/api/wallets/$phone');
    return Wallet.fromJson(data as Map<String, dynamic>);
  }

  Future<Balance> getBalance(String phone) async {
    final data = await _api.get('/api/wallets/$phone/balance');
    return Balance.fromJson(data as Map<String, dynamic>);
  }

  Future<List<TransactionModel>> getTransactions(String phone) async {
    final data = await _api.get('/api/wallets/$phone/transactions');
    final list = (data as List?) ?? const [];
    return list
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
