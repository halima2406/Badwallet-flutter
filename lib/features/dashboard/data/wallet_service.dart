import '../../../core/network/api_client.dart';
import '../../../models/balance.dart';
import '../../../models/transaction.dart';
import '../../../models/wallet.dart';

/// Service d'accès aux endpoints "wallet" de la BadWallet API.
class WalletService {
  final ApiClient _api;
  WalletService(this._api);

  /// GET /api/wallets/{phone}
  Future<Wallet> getWallet(String phone) async {
    final data = await _api.get('/api/wallets/$phone');
    return Wallet.fromJson(data as Map<String, dynamic>);
  }

  /// GET /api/wallets/{phone}/balance
  Future<Balance> getBalance(String phone) async {
    final data = await _api.get('/api/wallets/$phone/balance');
    return Balance.fromJson(data as Map<String, dynamic>);
  }

  /// GET /api/wallets/{phone}/transactions
  Future<List<TransactionModel>> getTransactions(String phone) async {
    final data = await _api.get('/api/wallets/$phone/transactions');
    final list = (data as List?) ?? const [];
    return list
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
