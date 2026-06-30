import '../../../core/network/api_client.dart';
import '../../../models/wallet.dart';

/// Service de transfert d'argent.
class TransferService {
  final ApiClient _api;
  TransferService(this._api);

  /// POST /api/wallets/transfer
  /// body: { senderPhone, receiverPhone, amount }
  /// renvoie le portefeuille mis à jour de l'émetteur.
  Future<Wallet> transfer({
    required String senderPhone,
    required String receiverPhone,
    required double amount,
  }) async {
    final data = await _api.post('/api/wallets/transfer', body: {
      'senderPhone': senderPhone,
      'receiverPhone': receiverPhone,
      'amount': amount,
    });
    return Wallet.fromJson(data as Map<String, dynamic>);
  }
}
