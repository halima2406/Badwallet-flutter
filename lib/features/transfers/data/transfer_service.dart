import '../../../core/network/api_client.dart';
import '../../../models/wallet.dart';

// appelle l'API pour envoyer de l'argent
class TransferService {
  final ApiClient _api;
  TransferService(this._api);

  // envoie l'argent, renvoie le portefeuille mis a jour
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
